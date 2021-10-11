//
//  ProgressView.swift
//  ProgressView
//
//  Created by Philipp on 19.08.21.
//
// swiftlint:disable file_length

import SwiftUI

#if SwiftUIv1
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

    @Environment(\.progressViewStyle) private var styles

    private var configuration: ProgressViewStyleConfiguration

    public var body: some View {
        if let style = styles.last {
            let remainingStyles = Array(styles.dropLast())

            style.makeBody(configuration: configuration)
                .environment(\.progressViewStyle, remainingStyles)

        } else {
            DefaultProgressViewStyle().makeBody(configuration: configuration)
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

// To allow styling customizations as shown below, we need this initializer.
//
//      struct DarkBlueShadowProgressViewStyle: ProgressViewStyle {
//          func makeBody(configuration: Configuration) -> some View {
//              ProgressView(configuration)
//                  .shadow(color: Color(red: 0, green: 0, blue: 0.6),
//                          radius: 4.0, x: 1.0, y: 2.0)
//          }
//      }
extension ProgressView {

    /// Creates a progress view based on a style configuration.
    public init(_ configuration: ProgressViewStyleConfiguration)
    where Label == ProgressViewStyleConfiguration.Label,
    CurrentValueLabel == ProgressViewStyleConfiguration.CurrentValueLabel {
        self.configuration = configuration
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

// MARK: - ProgressViewStyle Protocol
/// A type that applies standard interaction behavior to all progress views
/// within a view hierarchy.
///
/// To configure the current progress view style for a view hierarchy, use the
/// ``View/progressViewStyle(_:)`` modifier.
///
/// See documentation and usage in Apple documentation
///     <https://developer.apple.com/documentation/SwiftUI/ProgressViewStyle>
///
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.ProgressViewStyle")
public protocol ProgressViewStyle {
    /// A view that represents the body of a label.
    associatedtype Body: View

    /// Creates a view that represents the body of a label.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a label.
    typealias Configuration = ProgressViewStyleConfiguration
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.ProgressViewStyle")
extension ProgressViewStyle where Self == DefaultProgressViewStyle {

    /// The default progress view style in the current context of the view being
    /// styled.
    public static var automatic: DefaultProgressViewStyle { DefaultProgressViewStyle() }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.ProgressViewStyle")
extension ProgressViewStyle where Self == CircularProgressViewStyle {

    /// A progress view that visually indicates its progress using a circular
    /// gauge.
    public static var circular: CircularProgressViewStyle { CircularProgressViewStyle() }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.ProgressViewStyle")
extension ProgressViewStyle where Self == LinearProgressViewStyle {

    /// A progress view that visually indicates its progress using a horizontal
    /// bar.
    public static var linear: LinearProgressViewStyle { LinearProgressViewStyle() }
}

// MARK: - DefaultProgressViewStyle
/// A progress view that visually indicates its progress using a horizontal bar.
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.DefaultProgressViewStyle")
public struct DefaultProgressViewStyle: ProgressViewStyle {

    /// Creates a linear progress view style.
    public init() {}

    /// Creates a view representing the body of a progress view.
    public func makeBody(configuration: DefaultProgressViewStyle.Configuration) -> some View {
        if configuration.fractionCompleted == nil {
            // Indeterminate process
            CircularProgressViewStyle().makeBody(configuration: configuration)
        } else {
            // Determinate process
            LinearProgressViewStyle().makeBody(configuration: configuration)
        }
    }
}

// MARK: - CircularProgressViewStyle
/// A progress view that visually indicates its progress using a circular gauge, optionally
/// vertically stacked with a label and a current value label, giving the user feedback
/// about what's the current progress made.
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.CircularProgressViewStyle")
public struct CircularProgressViewStyle: ProgressViewStyle {

    /// Creates a linear progress view style.
    public init() {}

    /// Creates a view representing the body of a progress view.
    public func makeBody(configuration: CircularProgressViewStyle.Configuration) -> some View {
        // Indeterminate process
        if let label = configuration.label {
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

// MARK: - LinearProgressViewStyle
/// A progress view that indicates its progress using a horizontal bar, optionally vertically
/// stacked with a label and a current value label, giving the user feedback about what's the
/// current progress made.
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.LinearProgressViewStyle")
public struct LinearProgressViewStyle: ProgressViewStyle {

    /// Creates a linear progress view style.
    public init() {}

    /// Creates a view representing the body of a progress view.
    public func makeBody(configuration: LinearProgressViewStyle.Configuration) -> some View {
        // Determinate process
        VStack(alignment: .leading, spacing: 4) {
            if let label = configuration.label {
                label
            }
            LinearProgressView(fractionCompleted: configuration.fractionCompleted ?? 0)
            if let currentValueLabel = configuration.currentValueLabel {
                currentValueLabel
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
    }
}

// MARK: - Type Erased ProgressViewStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
private struct AnyProgressViewStyle: ProgressViewStyle {
    private let _makeBody: (Configuration) -> AnyView

    init<S: ProgressViewStyle>(_ style: S) {
        _makeBody = style.makeBodyTypeErased
    }

    func makeBody(configuration: Configuration) -> AnyView {
        _makeBody(configuration)
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
extension ProgressViewStyle {
    fileprivate func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
        AnyView(makeBody(configuration: configuration))
    }
}

// MARK: - Custom environment for ProgressViewStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
private struct ProgressViewStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: [AnyProgressViewStyle] = []
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
extension EnvironmentValues {
    fileprivate var progressViewStyle: [AnyProgressViewStyle] {
        get { self[ProgressViewStyleEnvironmentKey.self] }
        set { self[ProgressViewStyleEnvironmentKey.self] = newValue }
    }
}

// MARK: - ViewModifier to enhance environment with additional style
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
private struct ProgressViewModifier: ViewModifier {

    @Environment(\.progressViewStyle) private var styles

    let style: AnyProgressViewStyle

    func body(content: Content) -> some View {
        content
            .environment(\.progressViewStyle, newStyles)
    }

    private var newStyles: [AnyProgressViewStyle] {
        // There is no `Array.appending()` so we have to write it ourselves
        var newArray = styles
        newArray.append(style)
        return newArray
    }
}

// MARK: - View extension for conveniently setting the progress view style
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.View.progressViewStyle")
extension View {
    public func progressViewStyle<S>(_ style: S) -> some View where S: ProgressViewStyle {
        self.modifier(ProgressViewModifier(style: AnyProgressViewStyle(style)))
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

        fileprivate init<T: View>(_ view: T) {
            body = AnyView(view)
        }

        public let body: AnyView
    }

    /// A type-erased label that describes the current value of a progress view.
    public struct CurrentValueLabel: View {

        fileprivate init<T: View>(_ view: T) {
            body = AnyView(view)
        }

        public let body: AnyView
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

// MARK: - LinearProgressView
/// A linear growing rectangular bar representing the fractional completion of the current progress.
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

// MARK: - CircularProgressView
/// The basic "spinner" used for indeterminate progress.
/// Relying here on the UIKit `UIActivityIndicatorView`
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
#endif
