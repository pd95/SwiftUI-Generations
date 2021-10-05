//
//  View-Accessibility-Wrappers.swift
//  View-Accessibility-Wrappers
//
//  Created by Philipp on 10.09.21.
//

import SwiftUI

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    @inlinable public func accessibilityAction(named nameKey: LocalizedStringKey, _ handler: @escaping () -> Void)
    -> ModifiedContent<Content, Modifier> {
        self.accessibilityAction(named: Text(nameKey), handler)
    }

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    @inlinable public func accessibilityAction<S>(named name: S, _ handler: @escaping () -> Void)
    -> ModifiedContent<Content, Modifier> where S: StringProtocol {
        self.accessibilityAction(named: Text(name), handler)
    }

    /// Specifies whether to hide this view from system accessibility features.
    @inlinable public func accessibilityHidden(_ hidden: Bool) -> ModifiedContent<Content, Modifier> {
        self.accessibility(hidden: hidden)
    }

    /// Adds a label to the view that describes its contents.
    @inlinable public func accessibilityLabel(_ label: Text) -> ModifiedContent<Content, Modifier> {
        self.accessibility(label: label)
    }

    /// Communicates to the user what happens after performing the view's
    /// action.
    @inlinable public func accessibilityHint(_ hint: Text) -> ModifiedContent<Content, Modifier> {
        accessibility(hint: hint)
    }

    /// Sets alternate input labels with which users identify a view.
    @inlinable public func accessibilityInputLabels(_ inputLabels: [Text]) -> ModifiedContent<Content, Modifier> {
        accessibility(inputLabels: inputLabels)
    }

    /// Uses the string you specify to identify the view.
    @inlinable public func accessibilityIdentifier(_ identifier: String) -> ModifiedContent<Content, Modifier> {
        accessibility(identifier: identifier)
    }

    /// Specifies the point where activations occur in the view.
    @inlinable public func accessibilityActivationPoint(_ activationPoint: CGPoint)
    -> ModifiedContent<Content, Modifier> {
        accessibility(activationPoint: activationPoint)
    }

    /// Specifies the unit point where activations occur in the view.
    @inlinable public func accessibilityActivationPoint(_ activationPoint: UnitPoint)
    -> ModifiedContent<Content, Modifier> {
        accessibility(activationPoint: activationPoint)
    }

    /// Adds a label to the view that describes its contents.
    @inlinable public func accessibilityLabel(_ labelKey: LocalizedStringKey) -> ModifiedContent<Content, Modifier> {
        accessibility(label: Text(labelKey))
    }

    /// Adds a label to the view that describes its contents.
    @inlinable public func accessibilityLabel<S>(_ label: S) -> ModifiedContent<Content, Modifier>
    where S: StringProtocol {
        accessibility(label: Text(label))
    }

    /// Communicates to the user what happens after performing the view's action.
    @inlinable public func accessibilityHint(_ hintKey: LocalizedStringKey) -> ModifiedContent<Content, Modifier> {
        accessibility(hint: Text(hintKey))
    }

    /// Communicates to the user what happens after performing the view's action.
    @inlinable public func accessibilityHint<S>(_ hint: S) -> ModifiedContent<Content, Modifier>
    where S: StringProtocol {
        accessibility(hint: Text(hint))
    }

    /// Sets alternate input labels with which users identify a view.
    @inlinable public func accessibilityInputLabels(_ inputLabelKeys: [LocalizedStringKey])
    -> ModifiedContent<Content, Modifier> {
        accessibility(inputLabels: inputLabelKeys.map({Text($0)}))
    }

    /// Sets alternate input labels with which users identify a view.
    @inlinable public func accessibilityInputLabels<S>(_ inputLabels: [S]) -> ModifiedContent<Content, Modifier>
    where S: StringProtocol {
        accessibility(inputLabels: inputLabels.map(Text.init))
    }

    /// Sets the sort priority order for this view's accessibility
    /// element, relative to other elements at the same level.
    @inlinable public func accessibilitySortPriority(_ sortPriority: Double) -> ModifiedContent<Content, Modifier> {
        accessibility(sortPriority: sortPriority)
    }

    /// Adds the given traits to the view.
    @inlinable public func accessibilityAddTraits(_ traits: AccessibilityTraits) -> ModifiedContent<Content, Modifier> {
        accessibility(addTraits: traits)
    }

    /// Removes the given traits from this view.
    @inlinable public func accessibilityRemoveTraits(_ traits: AccessibilityTraits)
    -> ModifiedContent<Content, Modifier> {
        accessibility(removeTraits: traits)
    }

    /// Adds a textual description of the value that the view contains.
    @inlinable public func accessibilityValue(_ valueDescription: Text) -> ModifiedContent<Content, Modifier> {
        accessibility(value: valueDescription)
    }

    /// Adds a textual description of the value that the view contains.
    @inlinable public func accessibilityValue(_ valueKey: LocalizedStringKey) -> ModifiedContent<Content, Modifier> {
        accessibility(value: Text(valueKey))
    }

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    @inlinable public func accessibilityValue<S>(_ value: S) -> ModifiedContent<Content, Modifier>
    where S: StringProtocol {
        accessibility(value: Text(value))
    }
}

@available(iOS, introduced: 13, obsoleted: 14.0,
           message: "Backport not necessary as of iOS 14")
extension View {

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    @inlinable public func accessibilityAction(named nameKey: LocalizedStringKey, _ handler: @escaping () -> Void)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        self.accessibilityAction(named: Text(nameKey), handler)
    }

    /// Adds an accessibility action to the view. Actions allow assistive technologies,
    /// such as the VoiceOver, to interact with the view by invoking the action.
    @inlinable public func accessibilityAction<S>(named name: S, _ handler: @escaping () -> Void)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> where S: StringProtocol {
        self.accessibilityAction(named: Text(name), handler)
    }

    /// Specifies whether to hide this view from system accessibility features.
    @inlinable public func accessibilityHidden(_ hidden: Bool)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        self.accessibility(hidden: hidden)
    }

    /// Adds a label to the view that describes its contents.
    @inlinable public func accessibilityLabel(_ label: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        self.accessibility(label: label)
    }

    /// Communicates to the user what happens after performing the view's
    /// action.
    @inlinable public func accessibilityHint(_ hint: Text) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(hint: hint)
    }

    /// Sets alternate input labels with which users identify a view.
    @inlinable public func accessibilityInputLabels(_ inputLabels: [Text])
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(inputLabels: inputLabels)
    }

    /// Uses the string you specify to identify the view.
    @inlinable public func accessibilityIdentifier(_ identifier: String)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(identifier: identifier)
    }

    /// Specifies the point where activations occur in the view.
    @inlinable public func accessibilityActivationPoint(_ activationPoint: CGPoint)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(activationPoint: activationPoint)
    }

    /// Specifies the unit point where activations occur in the view.
    @inlinable public func accessibilityActivationPoint(_ activationPoint: UnitPoint)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(activationPoint: activationPoint)
    }

    /// Adds a label to the view that describes its contents.
    @inlinable public func accessibilityLabel(_ labelKey: LocalizedStringKey)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(label: Text(labelKey))
    }

    /// Adds a label to the view that describes its contents.
    @inlinable public func accessibilityLabel<S>(_ label: S) -> ModifiedContent<Self, AccessibilityAttachmentModifier>
    where S: StringProtocol {
        accessibility(label: Text(label))
    }

    /// Communicates to the user what happens after performing the view's action.
    @inlinable public func accessibilityHint(_ hintKey: LocalizedStringKey)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(hint: Text(hintKey))
    }

    /// Communicates to the user what happens after performing the view's action.
    @inlinable public func accessibilityHint<S>(_ hint: S) -> ModifiedContent<Self, AccessibilityAttachmentModifier>
    where S: StringProtocol {
        accessibility(hint: Text(hint))
    }

    /// Sets alternate input labels with which users identify a view.
    @inlinable public func accessibilityInputLabels(_ inputLabelKeys: [LocalizedStringKey])
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(inputLabels: inputLabelKeys.map({Text($0)}))
    }

    /// Sets alternate input labels with which users identify a view.
    @inlinable public func accessibilityInputLabels<S>(_ inputLabels: [S])
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> where S: StringProtocol {
        accessibility(inputLabels: inputLabels.map(Text.init))
    }

    /// Sets the sort priority order for this view's accessibility
    /// element, relative to other elements at the same level.
    @inlinable public func accessibilitySortPriority(_ sortPriority: Double)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(sortPriority: sortPriority)
    }

    /// Adds the given traits to the view.
    @inlinable public func accessibilityAddTraits(_ traits: AccessibilityTraits)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(addTraits: traits)
    }

    /// Removes the given traits from this view.
    @inlinable public func accessibilityRemoveTraits(_ traits: AccessibilityTraits)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(removeTraits: traits)
    }

    /// Adds a textual description of the value that the view contains.
    @inlinable public func accessibilityValue(_ valueDescription: Text)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(value: valueDescription)
    }

    /// Adds a textual description of the value that the view contains.
    @inlinable public func accessibilityValue(_ valueKey: LocalizedStringKey)
    -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        accessibility(value: Text(valueKey))
    }

    /// Adds a textual description of the value that the view contains.
    ///
    /// Use this method to describe the value represented by a view, but only if that's different than the
    /// view's label. For example, for a slider that you label as "Volume" using accessibilityLabel(),
    /// you can provide the current volume setting, like "60%", using accessibilityValue().
    @inlinable public func accessibilityValue<S>(_ value: S) -> ModifiedContent<Self, AccessibilityAttachmentModifier>
    where S: StringProtocol {
        accessibility(value: Text(value))
    }
}
