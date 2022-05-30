//
//  AsyncImage.swift
//  AsyncImage
//
//  Created by Philipp on 19.08.21.
//

import SwiftUI
import os.log
import Combine

// First we need some helpers to become platform independent: NSImage on macOS UIImage on iOS
#if os(macOS)
typealias PlatformImage = NSImage

extension Image {
    static func fromPlatformImage(_ image: PlatformImage) -> Image {
        return Image(nsImage: image)
    }

    static func failureImage() -> Image {
        let size = CGSize(width: 400, height: 400)
        let nsImage = NSImage(size: size)
        nsImage.lockFocus()
        NSColor.systemGray.drawSwatch(in: NSRect(origin: .zero, size: size))
        nsImage.unlockFocus()
        return Image(nsImage: nsImage)
    }
}

extension NSImage {
    convenience init(cgImage image: CGImage) {
        self.init(cgImage: image, size: .zero)
    }
}

#elseif os(iOS)
typealias PlatformImage = UIImage

extension Image {
    static func fromPlatformImage(_ image: PlatformImage) -> Image {
        return Image(uiImage: image)
    }

    static func failureImage() -> Image {
        let size = CGSize(width: 400, height: 400)
        let uiImage = UIGraphicsImageRenderer(size: size).image { rendererContext in
            UIColor.systemGray.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
        return Image(uiImage: uiImage)
    }
}

#else
#error("This platform is not yet supported")
#endif

extension Image {
    static func emptyImage() -> Image {
        return Image.fromPlatformImage(.init())
    }
}

#if os(iOS) && (TARGET_IOS_MAJOR_13 || TARGET_IOS_MAJOR_14) || os(macOS)

@available(iOS, introduced: 13, obsoleted: 15.0,
           message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.AsyncImagePhase")
@available(macOS, introduced: 11, obsoleted: 12.0,
           message: "Backport not necessary as of macOS 12", renamed: "SwiftUI.AsyncImagePhase")
public enum AsyncImagePhase {

    /// No image is loaded.
    case empty

    /// An image succesfully loaded.
    case success(Image)

    /// An image failed to load with an error.
    case failure(Error)

    /// The loaded image, if any.
    public var image: Image? {
        if case .success(let image) = self {
            return image
        }
        return nil
    }

    /// The error that occurred when attempting to load an image, if any.
    public var error: Error? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }
}

@available(iOS, introduced: 13, obsoleted: 15.0,
           message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.AsyncImage")
@available(macOS, introduced: 11, obsoleted: 12.0,
           message: "Backport not necessary as of macOS 12", renamed: "SwiftUI.AsyncImage")
public struct AsyncImage<Content>: View where Content: View {
    private var url: URL?
    private var scale: CGFloat    // TODO: support scale when transforming cgImage
    private var contentBuilder: ((AsyncImagePhase) -> Content)?

    @StateObject private var loader = AsyncImageLoader()

    public init(url: URL?, scale: CGFloat = 1, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.contentBuilder = content
    }

    public var body: some View {
        contentBuilder?(loader.phase)
            .onAppear(perform: {
                loader.fetchImage(url)
            })
            .onChange(of: url, perform: { newValue in
                loader.fetchImage(newValue)
            })
            .background(GeometryReader { proxy in
                Color.clear
                    .preference(key: ViewGeometryPreferenceKey.self, value: proxy.frame(in: .local))
            })
            .onPreferenceChange(ViewGeometryPreferenceKey.self, perform: { newValue in
                loader.setSize(newValue.size)  // update model with latest size
            })
    }
}

@available(iOS, introduced: 13, obsoleted: 15.0,
           message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.AsyncImage")
@available(macOS, introduced: 11, obsoleted: 12.0,
           message: "Backport not necessary as of macOS 12", renamed: "SwiftUI.AsyncImage")
extension AsyncImage {
    public init(url: URL?, scale: CGFloat = 1) where Content == Image {
        self.init(url: url, scale: scale) { phase in
            switch phase {
            case .success(let image):
                return image

            case .empty:
                return Image.emptyImage()

            case .failure:
                return Image.failureImage()
            }
        }
    }

    public init<I, P>(url: URL?,
                      @ViewBuilder content: @escaping (Image) -> I,
                      @ViewBuilder placeholder: @escaping () -> P)
    where Content == _ConditionalContent<I, P>, I: View, P: View {

        self.init(url: url, content: { phase in
            if let image = phase.image {
                content(image)
            } else {
                placeholder()
            }
        })
    }
}

private class AsyncImageLoader: ObservableObject {

    enum Errors: Error {
        case selfWasDeallocated
        case httpDownloadError
        case fileMoveError
        case imageDecodingError
    }

    @Published private(set) var phase = AsyncImagePhase.empty
    @Environment(\.displayScale) private var displayScale

    private var sizeSubject = CurrentValueSubject<CGSize, Never>(.zero)
    private var cancellable: AnyCancellable?

    init() {
        print("🔴 init")
    }

    deinit {
        print("🔴 deinit")
    }

    private var lastURL: URL?

    // swiftlint:disable function_body_length
     func fetchImage(_ url: URL?) {
        print(#function, "from", url?.lastPathComponent ?? "(nil)",
              "(previous was \(lastURL?.lastPathComponent ?? "(nil)"))")
        guard lastURL != url else {
            os_log("AsyncImage: 🟡 Skip refetching same url %{public}@", url?.absoluteString ?? "(nil)")
            return
        }

        lastURL = url
        cancellable?.cancel()
        phase = .empty

        // Debounce the size changes to reduce succession of downsampling due to animation
        let sizePublisher = sizeSubject
            .debounce(for: 0.02, scheduler: DispatchQueue.global(qos: .userInitiated))
            .removeDuplicates()
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        weak var weakSelf = self

        let urlPublisher = Just(url)
            .compactMap({ $0 })
            .removeDuplicates()
            .setFailureType(to: Error.self)
            .flatMap({ (url: URL) -> AnyPublisher<URL, Error> in
                URLSession.shared.downloadTaskPublisher(for: url)
                    .tryMap({ (fileURL, response) in
                        guard let urlResponse = response as? HTTPURLResponse,
                              (200...399).contains(urlResponse.statusCode)
                        else {
                            os_log("AsyncImage: 🔴 HTTP error %ld while loading %{public}@",
                                   (response as? HTTPURLResponse)?.statusCode ?? -1, url.absoluteString)
                            throw Errors.httpDownloadError
                        }

                        do {
                            // Move file to our local url (in temp directory)
                            let newTempUrl = FileManager.default.temporaryDirectory
                                .appendingPathComponent("AsyncImage-Temp-"+fileURL.lastPathComponent)
                            try FileManager.default.moveItem(at: fileURL, to: newTempUrl)
                            os_log("AsyncImage: Moved image to %{public}@", newTempUrl.absoluteString)

                            return newTempUrl
                        } catch {
                            os_log("AsyncImage: 🔴 File processing error %{public}@ for %{public}@",
                                   error.localizedDescription, fileURL.absoluteString)
                            throw Errors.fileMoveError
                        }
                    })
                    .mapError({ $0 as Error })
                    .eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()

        cancellable = Publishers.CombineLatest(urlPublisher, sizePublisher)
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .tryMap({ (url, size) -> (URL, PlatformImage) in
                guard let self = weakSelf else {
                    throw Errors.selfWasDeallocated
                }

                let image: PlatformImage?
                if size != .zero {
                    image = self.downsample(imageAt: url, to: size, scale: self.displayScale)
                } else {
                    image = PlatformImage(contentsOfFile: url.path)
                }
                guard let image = image else {
                    throw Errors.imageDecodingError
                }
                return (url, image)
            })
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { result in
                guard let self = weakSelf else { return }
                if case .failure(let error) = result {
                    self.phase = .failure(error)
                    os_log("AsyncImage: 🔴 Error: loading image %{public}@!", error.localizedDescription)
                } else if case .empty = self.phase {
                    // This should not happen!
                    os_log("AsyncImage: 🔴 Error: no image was load for an unknown reason!")
                }
                self.cancellable = nil
            }, receiveValue: { (_, image) in
                weakSelf?.phase = .success(Image.fromPlatformImage(image))
            })
    }

    func setSize(_ size: CGSize) {
        sizeSubject.send(size)
    }

    /// Loading an appropriately sized image from the given URL
    ///
    /// Downsampling code has been shown at WWDC 2018: Image and Graphics Best Practices
    private func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> PlatformImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            os_log("AsyncImage: 🔴 CGImageSourceCreateWithURL failed due to an unknown reason!")
            return nil
        }

        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary

        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            os_log("AsyncImage: 🔴 CGImageSourceCreateThumbnailAtIndex failed due to an unknown reason!")
            return nil
        }
        return PlatformImage(cgImage: downsampledImage)
    }
}

#endif
