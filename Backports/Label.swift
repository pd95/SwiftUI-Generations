//
//  Label.swift
//  Label
//
//  Created by Philipp on 19.08.21.
//
//  A backport of the `Label` control found in iOS 14 for iOS 13
//

import SwiftUI

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

    @Environment(\.labelStyle) private var style: AnyLabelStyle

    fileprivate let title: Title
    fileprivate let icon: Icon

    public init(@ViewBuilder title: () -> Title, @ViewBuilder icon: () -> Icon) {
        self.title = title()
        self.icon = icon()
    }

    public var body: some View {
        let configuration = LabelStyleConfiguration(title: .init(title), icon: .init(icon))
        return style.makeBody(configuration: configuration)
    }
}

extension Label where Title == Text, Icon == Image {

    public init(_ titleKey: LocalizedStringKey, image name: String) {
        title = Text(titleKey)
        icon = Image(name)
    }

    public init(_ titleKey: LocalizedStringKey, systemImage name: String) {
        title = Text(titleKey)
        icon = Image(systemName: name)
    }

    public init<S>(_ titleKey: S, image name: String) where S: StringProtocol {
        title = Text(titleKey)
        icon = Image(name)
    }

    public init<S>(_ titleKey: S, systemImage name: String) where S: StringProtocol {
        title = Text(titleKey)
        icon = Image(systemName: name)
    }
}

extension Label where Title == LabelStyleConfiguration.Title, Icon == LabelStyleConfiguration.Icon {

    public init(_ configuration: LabelStyleConfiguration) {
        title = configuration.title
        icon = configuration.icon
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
extension LabelStyle where Self == DefaultLabelstyle {
    public static var automatic: DefaultLabelstyle { DefaultLabelstyle() }
}

extension LabelStyle {
    fileprivate func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
        AnyView(self.makeBody(configuration: configuration))
    }
}

// MARK: - LabelStyleConfiguration
///
/// The properties of a label.
///
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.LabelStyleConfiguration")
public struct LabelStyleConfiguration {

    /// A type-erased title view of a label.
    public struct Title {
        private let _view: AnyView

        fileprivate init<T: View>(_ view: T) {
            self._view = AnyView(view)
        }

        fileprivate var wrappedView: AnyView {
            _view
        }

        public typealias Body = Never
    }

    /// A type-erased icon view of a label.
    public struct Icon {
        private let _view: AnyView

        fileprivate init<I: View>(_ view: I) {
            self._view = AnyView(view)
        }

        fileprivate var wrappedView: AnyView {
            _view
        }

        public typealias Body = Never
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

extension LabelStyleConfiguration.Title: View {
    public var body: Never {
        fatalError("Unsupported - don't call this")
    }
}

extension LabelStyleConfiguration.Icon: View {
    public var body: Never {
        fatalError("Unsupported - don't call this")
    }
}

// MARK: - DefaultLabelstyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.DefaultLabelstyle")
public struct DefaultLabelstyle: LabelStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon.wrappedView
            configuration.title.wrappedView
        }
    }
}

// MARK: - IconOnlyLabelStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.IconOnlyLabelStyle")
public struct IconOnlyLabelStyle: LabelStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.icon.wrappedView
    }
}

// MARK: - TitleAndIconLabelStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.TitleAndIconLabelStyle")
public struct TitleAndIconLabelStyle: LabelStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon.wrappedView
            configuration.title.wrappedView
        }
    }
}

// MARK: - TitleOnlyLabelStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.TitleOnlyLabelStyle")
public struct TitleOnlyLabelStyle: LabelStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.title.wrappedView
    }
}

// MARK: - Type Erased LabelStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.AnyLabelStyle")
private struct AnyLabelStyle: LabelStyle {
    private let _makeBody: (LabelStyle.Configuration) -> AnyView

    init<S: LabelStyle>(_ style: S) {
        self._makeBody = style.makeBodyTypeErased
    }

    func makeBody(configuration: LabelStyle.Configuration) -> AnyView {
        return self._makeBody(configuration)
    }
}

// MARK: - Custom environment for LabelStyle
@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.DefaultLabelstyle")
private struct LabelStyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: AnyLabelStyle = AnyLabelStyle(DefaultLabelstyle())
}

extension EnvironmentValues {
    @available(iOS, introduced: 13, obsoleted: 14.0,
               message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.EnvironmentValues.labelStyle")
    fileprivate var labelStyle: AnyLabelStyle {
        get { self[LabelStyleEnvironmentKey.self] }
        set { self[LabelStyleEnvironmentKey.self] = newValue }
    }
}

// MARK: - View extension
extension View {
    @available(iOS, introduced: 13, obsoleted: 14.0,
               message: "Backport not necessary as of iOS 14", renamed: "SwiftUI.View.labelStyle")
    public func labelStyle<S>(_ style: S) -> some View where S: LabelStyle {
        self.environment(\.labelStyle, AnyLabelStyle(style))
    }
}
