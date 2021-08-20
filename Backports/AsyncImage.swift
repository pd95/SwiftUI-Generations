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
enum AsyncImagePhase {
    case empty
    case success(Image)
    case failure(URLError)

    var image: Image? {
        if case .success(let image) = self {
            return image
        }
        return nil
    }

    var error: URLError? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }
}

@available(iOS, introduced: 13, obsoleted: 15.0,
           message: "Backport not necessary as of iOS 15", renamed: "SwiftUI.AsyncImage")
struct AsyncImage<Content>: View where Content: View {
    private var url: URL?
    private var contentBuilder: ((AsyncImagePhase) -> Content)?

    @State private var phase = AsyncImagePhase.empty
    @State private var cancellable: AnyCancellable?

    init(url: URL?, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.contentBuilder = content
    }

    init(url: URL?) where Content == Image {
        self.init(url: url) { phase in
            phase.image ?? Image(uiImage: UIImage())
        }
    }

    init<I, P>(url: URL?,
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

    var body: some View {
        contentBuilder?(phase)
            .onAppear(perform: fetchImage)
    }

    func fetchImage() {
        guard let url = url else {
            return
        }
        cancellable = Just(1)
            .receive(on: DispatchQueue.global(qos: .default), options: nil)
            .setFailureType(to: URLError.self) // this is required for iOS 13!
            .flatMap({ _ -> AnyPublisher<UIImage, URLError> in
                URLSession.shared.dataTaskPublisher(for: url)
                    .compactMap({ UIImage(data: $0.data) })
                    .eraseToAnyPublisher()
            })
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    self.phase = .failure(error)
                case .finished:
                    break
                }
            }, receiveValue: { image in
                self.phase = .success(Image(uiImage: image))
            })
    }
}

struct AsyncImage_Previews: PreviewProvider {
    static let url = URL(string: "https://developer.apple.com/assets/elements/icons/xcode/xcode-128x128_2x.png")!

    static var previews: some View {
        VStack {
            Group {
                AsyncImage(url: url)
                    .frame(width: 100, height: 100)

                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)

                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image // Displays the loaded image.
                    } else if phase.error != nil {
                        Color.red // Indicates an error.
                    } else {
                        Color.blue // Acts as a placeholder.
                    }
                }

            }
            .overlay(RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.red, lineWidth: 4))
        }
    }
}
