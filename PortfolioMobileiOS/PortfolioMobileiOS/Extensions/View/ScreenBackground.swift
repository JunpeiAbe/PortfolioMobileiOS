import SwiftUI

struct ScreenBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.mainLight
                .ignoresSafeArea()

            content
        }
    }
}

struct DismissFocusScreenBackgroundModifier<Value: Hashable>: ViewModifier {
    let focusedField: FocusState<Value?>.Binding

    func body(content: Content) -> some View {
        ZStack {
            Color.mainLight
                .ignoresSafeArea()
            content
        }
        .contentShape(Rectangle())
        .simultaneousGesture(
            TapGesture().onEnded {
                focusedField.wrappedValue = nil
            }
        )
    }
}

extension View {
    func screenBackground() -> some View {
        modifier(ScreenBackgroundModifier())
    }
    
    func screenBackground<Value: Hashable>(
        dismissing focusedField: FocusState<Value?>.Binding
    ) -> some View {
        modifier(
            DismissFocusScreenBackgroundModifier(
                focusedField: focusedField
            )
        )
    }
}

