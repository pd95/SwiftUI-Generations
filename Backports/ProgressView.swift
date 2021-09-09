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

    private var configuration: ProgressViewStyleConfiguration

    public var body: some View {
        if let fractionCompleted = configuration.fractionCompleted {
            // Determinate process
            VStack(alignment: .leading, spacing: 4) {
                if let label = configuration.label {
                    label.wrappedView
                }
                LinearProgressView(fractionCompleted: fractionCompleted)
                if let currentValueLabel = configuration.currentValueLabel {
                    currentValueLabel.wrappedView
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
        } else {
            // Indeterminate process
            if let label = configuration.label {
                VStack {
                    CircularProgressView()
                    label.wrappedView
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
        self.configuration = ProgressViewStyleConfiguration(fractionCompleted: nil)
    }

    /// Creates a progress view for showing indeterminate progress that displays
    /// a custom label.
    public init(@ViewBuilder label: () -> Label) {
        self.configuration = ProgressViewStyleConfiguration(
            fractionCompleted: nil,
            label: .init(label())
        )
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
        self.configuration = ProgressViewStyleConfiguration(fractionCompleted: Double((value ?? 0)/total))
    }

    /// Creates a progress view for showing determinate progress, with a
    /// custom label.
    public init<V>(value: V?, total: V = 1.0, @ViewBuilder label: () -> Label)
    where CurrentValueLabel == EmptyView, V: BinaryFloatingPoint {
        self.configuration = ProgressViewStyleConfiguration(
            fractionCompleted: Double((value ?? 0)/total),
            label: .init(label())
        )
    }

    /// Creates a progress view for showing determinate progress, with a
    /// custom label.
    public init<V>(value: V?, total: V = 1.0,
                   @ViewBuilder label: () -> Label,
                   @ViewBuilder currentValueLabel: () -> CurrentValueLabel)
    where V: BinaryFloatingPoint {
        self.configuration = ProgressViewStyleConfiguration(
            fractionCompleted: Double((value ?? 0)/total),
            label: .init(label()),
            currentValueLabel: .init(currentValueLabel())
        )
    }

    /// Creates a progress view for showing determinate progress that generates
    /// its label from a localized string.
    public init<V>(_ titleKey: LocalizedStringKey,
                   value: V?, total: V = 1.0)
    where Label == Text, CurrentValueLabel == EmptyView, V: BinaryFloatingPoint {
        self.configuration = ProgressViewStyleConfiguration(
            fractionCompleted: Double((value ?? 0)/total),
            label: .init(Text(titleKey))
        )
    }

    /// Creates a progress view for showing determinate progress that generates
    /// its label from a string.
    public init<S, V>(_ title: S,
                      value: V?, total: V = 1.0)
    where Label == Text, CurrentValueLabel == EmptyView, S: StringProtocol, V: BinaryFloatingPoint {
        self.configuration = ProgressViewStyleConfiguration(
            fractionCompleted: Double((value ?? 0)/total),
            label: .init(Text(title))
        )
    }
}

// MARK: - Determinate progress initializer based on Foundation `Progress` object
extension ProgressView {
    /// Creates a progress view for visualizing the given progress instance.
    public init(_ progress: Progress)
    where Label == Text, CurrentValueLabel == Text { // FIXME: This should be EmptyView, EmptyView instead of Text,Text!
        let value: Double = Double(progress.completedUnitCount)
        let total: Double = progress.totalUnitCount > 0 ? Double(progress.totalUnitCount) : 1.0

        let description: String
        if let localizedDescription = progress.localizedDescription {
            description = localizedDescription
        } else {
            description = "\(Int(value/total*100))% completed"
        }

        self.init(
            value: value, total: total,
            label: {
                Text(description)
            },
            currentValueLabel: {
                Text("\(progress.completedUnitCount) of \(progress.totalUnitCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        )
    }
}


// MARK: - ProgressViewStyleConfiguration
/// The properties of a progress view instance.
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.ProgressViewStyleConfiguration")
public struct ProgressViewStyleConfiguration {

    /// A type-erased label describing the task represented by the progress
    /// view.
    public struct Label: View {

        private let _view: AnyView

        fileprivate init<T: View>(_ view: T) {
            self._view = AnyView(view)
        }

        fileprivate var wrappedView: AnyView {
            _view
        }

        /// The type of view representing the body of this view.
        public typealias Body = Never
    }

    /// A type-erased label that describes the current value of a progress view.
    public struct CurrentValueLabel: View {

        private let _view: AnyView

        fileprivate init<T: View>(_ view: T) {
            self._view = AnyView(view)
        }

        fileprivate var wrappedView: AnyView {
            _view
        }

        /// The type of view representing the body of this view.
        public typealias Body = Never
    }

    /// The completed fraction of the task represented by the progress view,
    /// from `0.0` (not yet started) to `1.0` (fully complete), or `nil` if the
    /// progress is indeterminate.
    public let fractionCompleted: Double?

    /// A view that describes the task represented by the progress view.
    public var label: ProgressViewStyleConfiguration.Label?

    /// A view that describes the current value of a progress view.
    public var currentValueLabel: ProgressViewStyleConfiguration.CurrentValueLabel?
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
