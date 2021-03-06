//
//  Label.swift
//  Label
//
//  Created by Philipp on 19.08.21.
//
//  A backport of the `Label` control found in iOS 14 for iOS 13
//

import SwiftUI

#if TARGET_IOS_MAJOR_13

// MARK: - Label View
///
/// A standard label for user interface items, consisting of an icon with a
/// title.
///
/// See documentation and usage in Apple documentation
///     <https://developer.apple.com/documentation/SwiftUI/Label>
///
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.Label")
public struct Label<Title, Icon>: View where Title: View, Icon: View {

    @Environment(\.labelStyle) private var styles

    private var configuration: LabelStyleConfiguration

    public init(@ViewBuilder title: () -> Title, @ViewBuilder icon: () -> Icon) {
        configuration = .init(title: .init(title()), icon: .init(icon()))
    }

    public var body: some View {
        if let style = styles.last {
            let remainingStyles = Array(styles.dropLast())

            style.makeBody(configuration: configuration)
                .environment(\.labelStyle, remainingStyles)

        } else {
            DefaultLabelStyle().makeBody(configuration: configuration)
        }
    }
}

extension Label where Title == Text, Icon == Image {

    public init(_ titleKey: LocalizedStringKey, image name: String) {
        configuration = LabelStyleConfiguration(
            title: LabelStyleConfiguration.Title(Text(titleKey)),
            icon: LabelStyleConfiguration.Icon(Image(name))
        )
    }

    public init(_ titleKey: LocalizedStringKey, systemImage name: String) {
        configuration = LabelStyleConfiguration(
            title: LabelStyleConfiguration.Title(Text(titleKey)),
            icon: LabelStyleConfiguration.Icon(systemName: name)
        )
    }

    public init<S>(_ titleKey: S, image name: String) where S: StringProtocol {
        configuration = LabelStyleConfiguration(
            title: LabelStyleConfiguration.Title(Text(titleKey)),
            icon: LabelStyleConfiguration.Icon(Image(name))
        )
    }

    public init<S>(_ titleKey: S, systemImage name: String) where S: StringProtocol {
        configuration = LabelStyleConfiguration(
            title: LabelStyleConfiguration.Title(Text(titleKey)),
            icon: LabelStyleConfiguration.Icon(systemName: name)
        )
    }
}

extension Label where Title == LabelStyleConfiguration.Title, Icon == LabelStyleConfiguration.Icon {

    public init(_ configuration: LabelStyleConfiguration) {
        self.configuration = configuration
    }
}

// MARK: - LabelStyle Protocol
///
/// A type that applies a custom appearance to all labels within a view.
///
/// To configure the current label style for a view hierarchy, use the
/// ``View/labelStyle(_:)`` modifier.
///
/// See documentation and usage in Apple documentation
///     <https://developer.apple.com/documentation/SwiftUI/LabelStyle>
///
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.LabelStyle")
public protocol LabelStyle {
    /// A view that represents the body of a label.
    associatedtype Body: View

    /// Creates a view that represents the body of a label.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// The properties of a label.
    typealias Configuration = LabelStyleConfiguration
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.LabelStyle.iconOnly")
extension LabelStyle where Self == IconOnlyLabelStyle {
    public static var iconOnly: IconOnlyLabelStyle { IconOnlyLabelStyle() }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.LabelStyle.titleOnly")
extension LabelStyle where Self == TitleOnlyLabelStyle {
    public static var titleOnly: TitleOnlyLabelStyle { TitleOnlyLabelStyle() }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.LabelStyle.titleAndIcon")
extension LabelStyle where Self == TitleAndIconLabelStyle {
    public static var titleAndIcon: TitleAndIconLabelStyle { TitleAndIconLabelStyle() }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.LabelStyle.automatic")
extension LabelStyle where Self == DefaultLabelStyle {
    public static var automatic: DefaultLabelStyle { DefaultLabelStyle() }
}

// MARK: - LabelStyleConfiguration
///
/// The properties of a label.
///
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.LabelStyleConfiguration")
public struct LabelStyleConfiguration {

    /// A type-erased title view of a label.
    public struct Title: View {
        fileprivate init<I: View>(_ view: I) {
            body = AnyView(view)
        }

        public let body: AnyView
    }

    /// A type-erased icon view of a label.
    public struct Icon: View {
        private let _body: AnyView
        fileprivate init<I: View>(_ view: I) {
            _body = AnyView(view)
        }

        fileprivate init(systemName name: String) {
            _body = AnyView(ProperlySizedSFSymbol(name: name))
        }

        fileprivate init(image: Image) {
            _body = AnyView(image)
        }

        public var body: some View {
            _body
        }
    }

    fileprivate init(title: Title, icon: Icon) {
        _title = title
        _icon = icon
    }

    private var _title: Title
    private var _icon: Icon

    public var title: LabelStyleConfiguration.Title { _title }
    public var icon: LabelStyleConfiguration.Icon { _icon }
}

// MARK: - DefaultLabelStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.DefaultLabelStyle")
public struct DefaultLabelStyle: LabelStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        TitleAndIconLabelStyle().makeBody(configuration: configuration)
    }
}

// MARK: - IconOnlyLabelStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.IconOnlyLabelStyle")
public struct IconOnlyLabelStyle: LabelStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.icon
    }
}

// MARK: - TitleAndIconLabelStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.TitleAndIconLabelStyle")
public struct TitleAndIconLabelStyle: LabelStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .padding(.horizontal, 1.5)
            configuration.title
        }
    }
}

// MARK: - TitleOnlyLabelStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.TitleOnlyLabelStyle")
public struct TitleOnlyLabelStyle: LabelStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.title
    }
}

// MARK: - Type Erased LabelStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AnyLabelStyle")
private struct AnyLabelStyle: LabelStyle {
    private let _makeBody: (LabelStyle.Configuration) -> AnyView

    init<S: LabelStyle>(_ style: S) {
        _makeBody = style.makeBodyTypeErased
    }

    func makeBody(configuration: LabelStyle.Configuration) -> AnyView {
        _makeBody(configuration)
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
extension LabelStyle {
    fileprivate func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
        AnyView(self.makeBody(configuration: configuration))
    }
}

// MARK: - Custom environment for LabelStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
private struct LabelStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: [AnyLabelStyle] = []
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
extension EnvironmentValues {
    fileprivate var labelStyle: [AnyLabelStyle] {
        get { self[LabelStyleEnvironmentKey.self] }
        set { self[LabelStyleEnvironmentKey.self] = newValue }
    }
}

// MARK: - ViewModifier to enhance environment with additional style
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
private struct LabelStyleViewModifier: ViewModifier {

    @Environment(\.labelStyle) private var styles

    let style: AnyLabelStyle

    func body(content: Content) -> some View {
        content
            .environment(\.labelStyle, newStyles)
    }

    private var newStyles: [AnyLabelStyle] {
        // There is no `Array.appending()` so we have to write it ourselves
        var newArray = styles
        newArray.append(style)
        return newArray
    }
}

// MARK: - View extension for conveniently setting the label style
extension View {
    @available(iOS, introduced: 13, obsoleted: 14.0,
               message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.View.labelStyle")
    public func labelStyle<S>(_ style: S) -> some View where S: LabelStyle {
        self.modifier(LabelStyleViewModifier(style: AnyLabelStyle(style)))
    }
}
#endif
