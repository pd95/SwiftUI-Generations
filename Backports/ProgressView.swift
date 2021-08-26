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
public struct ProgressView<Label, CurrentValueLabel>: View
where Label: View, CurrentValueLabel: View {

    private var label: Label?
    private var currentValueLabel: CurrentValueLabel?
    private var fractionCompleted: Double?

    public var body: some View {
        if let fractionCompleted = fractionCompleted {
            // Determinate process
            VStack(alignment: .leading, spacing: 4) {
                if let label = label {
                    label
                }
                LinearProgressView(fractionCompleted: fractionCompleted)
                if let currentValueLabel = currentValueLabel {
                    currentValueLabel
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
        } else {
            // Indeterminate process
            if let label = label {
                VStack {
                    CircularProgressView()
                    label
                        .foregroundColor(.secondary)
                }
            } else {
                CircularProgressView()
            }
        }
    }
}

// MARK: - Indeterminate progress initializers
extension ProgressView where CurrentValueLabel == EmptyView {

    /// Creates a progress view for showing indeterminate progress, without a
    /// label.
    public init() where Label == EmptyView {
    }

    /// Creates a progress view for showing indeterminate progress that displays
    /// a custom label.
    public init(@ViewBuilder label: () -> Label) {
        self.label = label()
    }

    /// Creates a progress view for showing indeterminate progress that
    /// generates its label from a localized string.
    public init(_ titleKey: LocalizedStringKey) where Label == Text {
        self.init(label: {Text(titleKey)})
    }

    /// Creates a progress view for showing indeterminate progress that
    /// generates its label from a string.
    public init<S>(_ title: S) where Label == Text, S: StringProtocol {
        self.init(label: {Text(title)})
    }
}

// MARK: - Determinate progress initializers
extension ProgressView {

    /// Creates a progress view for showing determinate progress.
    public init<V>(value: V?, total: V = 1.0)
    where Label == EmptyView, CurrentValueLabel == EmptyView, V: BinaryFloatingPoint {
        self.fractionCompleted = Double((value ?? 0)/total)
    }

    /// Creates a progress view for showing determinate progress, with a
    /// custom label.
    public init<V>(value: V?, total: V = 1.0, @ViewBuilder label: () -> Label)
    where CurrentValueLabel == EmptyView, V: BinaryFloatingPoint {
        self.label = label()
        self.fractionCompleted = Double((value ?? 0)/total)
    }

    /// Creates a progress view for showing determinate progress, with a
    /// custom label.
    public init<V>(value: V?, total: V = 1.0,
                   @ViewBuilder label: () -> Label,
                   @ViewBuilder currentValueLabel: () -> CurrentValueLabel)
    where V: BinaryFloatingPoint {
        self.label = label()
        self.currentValueLabel = currentValueLabel()
        self.fractionCompleted = Double((value ?? 0)/total)
    }

    /// Creates a progress view for showing determinate progress that generates
    /// its label from a localized string.
    public init<V>(_ titleKey: LocalizedStringKey,
                   value: V?, total: V = 1.0)
    where Label == Text, CurrentValueLabel == EmptyView, V: BinaryFloatingPoint {
        self.label = Text(titleKey)
        self.fractionCompleted = Double((value ?? 0)/total)
    }

    /// Creates a progress view for showing determinate progress that generates
    /// its label from a string.
    public init<S, V>(_ title: S,
                      value: V?, total: V = 1.0)
    where Label == Text, CurrentValueLabel == EmptyView, S: StringProtocol, V: BinaryFloatingPoint {
        self.label = Text(title)
        self.fractionCompleted = Double((value ?? 0)/total)
    }
}

private struct LinearProgressView: View {
    let fractionCompleted: Double

    var body: some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(Color(.systemFill))
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(.accentColor)
                        .frame(width: proxy.size.width * CGFloat(fractionCompleted)),
                    alignment: .leading
                )
        }
        .frame(height: 4)
    }
}

private struct CircularProgressView: UIViewRepresentable {
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
