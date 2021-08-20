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
public struct ProgressView<Label>: View where Label: View {

    private var label: Label?
    private var percent: Double?

    public init(@ViewBuilder label: () -> Label) {
        self.label = label()
    }

    public var body: some View {
        if let label = label {
            VStack {
                ActivityIndicatorView()
                label
                    .foregroundColor(.secondary)
            }
        } else {
            ActivityIndicatorView()
        }
    }
}

// MARK: - Indeterminate progress initializers
extension ProgressView {
    
    /// Creates a progress view for showing indeterminate progress
    public init() where Label == EmptyView {
    }

    public init(_ titleKey: LocalizedStringKey) where Label == Text {
        self.init(label: {Text(titleKey)})
    }

    public init<S>(_ title: S) where Label == Text, S: StringProtocol {
        self.init(label: {Text(title)})
    }
}

// MARK: - Determinate progress initializers
extension ProgressView {

    /// Creates a progress view for showing a determinate progress
    public init<V>(value: V?, total: V = 1.0) where Label == Text, V: BinaryFloatingPoint {
        let percent: V = round((value ?? 0)/total*1000.0)/10
        self.label = Text("\(String(describing: percent))%")
        self.percent = Double(percent)
    }
}

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

#if DEBUG
struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressViewDemo()
    }
}
#endif
