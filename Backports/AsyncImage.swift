//
//  AsyncImage.swift
//  AsyncImage
//
//  Created by Philipp on 19.08.21.
//

import SwiftUI
import os.log
import Combine

@available(iOS, introduced: 13, obsoleted: 15.0,
           message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.AsyncImagePhase")
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
public struct AsyncImage<Content>: View where Content: View {
    private var url: URL?
    private var contentBuilder: ((AsyncImagePhase) -> Content)?

    private let backgroundQueue: DispatchQueue

    public enum Errors: Error {
        case imageDecodingError
    }

    @State private var phase = AsyncImagePhase.empty
    @State private var cancellable: AnyCancellable?
    @State private var fileURL: URL?
    @State private var sizeSubject = CurrentValueSubject<CGSize, Never>(.zero)

    @Environment(\.displayScale) private var displayScale

    public init(url: URL?, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.contentBuilder = content
        self.backgroundQueue = DispatchQueue.global(qos: .userInitiated)
    }

    public init(url: URL?) where Content == Image {
        self.init(url: url) { phase in
            phase.image ?? Image(uiImage: UIImage())
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

    public var body: some View {
        contentBuilder?(phase)
            .onAppear(perform: refreshImage)
            .background(GeometryReader { proxy in
                Color.clear
                    .preference(key: ViewGeometryPreferenceKey.self, value: proxy.frame(in: .local))
            })
            .onPreferenceChange(ViewGeometryPreferenceKey.self, perform: { newValue in
                let newSize = newValue.size
                sizeSubject.send(newSize)
            })
    }

    private var localURLPublisher: AnyPublisher<URL, Never> {
        let urlPublisher: AnyPublisher<URL, Never>
        if let fileURL = fileURL {
            // return the existing local URL
            urlPublisher = Just(fileURL)
                .eraseToAnyPublisher()
        } else if let url = url {

            // Start a download task to fetch the remote url
            urlPublisher = URLSession.shared.downloadTaskPublisher(for: url)
                .map({ (url, response) in
                    do {
                        // Move file to our local url (in temp directory)
                        let newTempUrl = FileManager.default.temporaryDirectory
                            .appendingPathComponent("AsyncImage-Temp-"+url.lastPathComponent)
                        try FileManager.default.moveItem(at: url, to: newTempUrl)
                        os_log("AsyncImage: Moved image to %{public}@", newTempUrl.absoluteString)

                        DispatchQueue.main.async {
                            // Make sure we keep the local url for image refresh
                            fileURL = newTempUrl
                        }
                        return Optional.some(newTempUrl)
                    } catch {
                        os_log("AsyncImage: 🔴 Error during file move %{public}@", url.absoluteString)
                    }
                    return nil
                })
                .replaceError(with: nil)
                .compactMap({ $0 })
                .eraseToAnyPublisher()
        } else {
            urlPublisher = Empty()
                .eraseToAnyPublisher()
        }
        return urlPublisher
    }

    private func refreshImage() {
        // Debounce the size changes to reduce succession of downsampling due to animation
        let sizePublisher = sizeSubject
            .debounce(for: 0.02, scheduler: backgroundQueue)
            .removeDuplicates()
            .eraseToAnyPublisher()

        cancellable = Publishers.CombineLatest(localURLPublisher, sizePublisher)
            .subscribe(on: backgroundQueue)
            .tryMap({ (url, size) in

                let image: UIImage?
                if size != .zero {
                    image = downsample(imageAt: url, to: size, scale: displayScale)
                } else {
                    image = UIImage(contentsOfFile: url.path)
                }
                guard let image = image else {
                    throw Errors.imageDecodingError
                }
                return image
            })
            .receive(on: RunLoop.main, options: nil)
            .sink(receiveCompletion: { result in
                if case .failure(let error) = result {
                    phase = .failure(error)
                    os_log("AsyncImage: 🔴 Error: loading image %{public}@!", error.localizedDescription)
                } else {
                    if case .empty = phase {
                        // This should not happen!
                        os_log("AsyncImage: 🔴 Error: no image was load for an unknown reason!")
                        cancellable = nil
                    }
                }
            }, receiveValue: { image in
                phase = .success(Image(uiImage: image))
            })
    }

    /// Loading an appropriately sized image from the given URL
    ///
    /// Downsampling code has been shown at WWDC 2018: Image and Graphics Best Practices
    private func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage? {
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
        return UIImage(cgImage: downsampledImage)
    }
}

#if DEBUG
struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageDemo()
    }
}
#endif
