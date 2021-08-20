//
//  ProgressView.swift
//  ProgressView
//
//  Created by Philipp on 19.08.21.
//

import SwiftUI

// MARK: - ProgressView View
///
/// A view that shows the progress towards completion of a task.
///
/// See documentation and usage in Apple documentation
///     <https://developer.apple.com/documentation/SwiftUI/ProgressView>
///
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.ProgressView")
struct ProgressView: View {

    private struct ActivityIndicatorView: UIViewRepresentable {
        let style: UIActivityIndicatorView.Style

        init(style: UIActivityIndicatorView.Style = .medium) {
            self.style = style
        }

        func makeUIView(context: Context) -> UIActivityIndicatorView {
            let activityIndicator = UIActivityIndicatorView(style: style)
            activityIndicator.startAnimating()
            return activityIndicator
        }

        func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        }

    }

    var body: some View {
        ActivityIndicatorView()
    }
}

#if DEBUG
struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
#endif
