//
//  AsyncImage.swift
//  AsyncImage
//
//  Created by Philipp on 19.08.21.
//

import SwiftUI
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

    public enum Errors: Error {
        case imageDecodingError
    }

    @State private var phase = AsyncImagePhase.empty
    @State private var cancellable: AnyCancellable?

    public init(url: URL?, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.contentBuilder = content
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
            .onAppear(perform: fetchImage)
    }

    private func fetchImage() {
        guard let url = url, case .empty = self.phase else {
            return
        }
        cancellable = Just(1)
            .receive(on: DispatchQueue.global(qos: .default), options: nil)
            .setFailureType(to: Error.self) // this is required for iOS 13!
            .flatMap({ _ -> AnyPublisher<UIImage, Error> in
                URLSession.shared.dataTaskPublisher(for: url)
                    .tryMap({
                        guard let image = UIImage(data: $0.data) else {
                            throw Errors.imageDecodingError
                        }
                        return image
                    })
                    .eraseToAnyPublisher()
            })
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    self.phase = .failure(error)
                case .finished:
                    // FIXME: This should not happen!
                    if case .empty = self.phase {
                        print("🔴🔴🔴 Error: no image was load! Restarting fetchImage again!")
                        fetchImage()
                    }
                    break
                }
            }, receiveValue: { image in
                self.phase = .success(Image(uiImage: image))
            })
    }
}

#if DEBUG
struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageDemo()
    }
}
#endif
