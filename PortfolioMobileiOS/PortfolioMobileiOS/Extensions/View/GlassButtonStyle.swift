import SwiftUI

struct GlassButtonStyle: ButtonStyle {
    var tintColor: Color = .main
    var foregroundColor: Color = .white
    var cornerRadius: CGFloat = 8
    var tintOpacity: Double = 0.35

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(
                GlassButtonBackgroundModifier(
                    tintColor: tintColor,
                    cornerRadius: cornerRadius,
                    tintOpacity: tintOpacity
                )
            )
            .shadow(color: .init(.systemGray4), radius: 8, y: 4)
            .brightness(configuration.isPressed ? -0.1 : 0.0)
    }
}

private struct GlassButtonBackgroundModifier: ViewModifier {
    let tintColor: Color
    let cornerRadius: CGFloat
    let tintOpacity: Double

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(
                    .regular
                        .tint(tintColor.opacity(tintOpacity))
                        .interactive(),
                    in: .rect(cornerRadius: cornerRadius)
                )
        } else {
            content
                .background(
                    tintColor.opacity(tintOpacity),
                    in: .rect(cornerRadius: cornerRadius)
                )
                .background(
                    .ultraThinMaterial,
                    in: .rect(cornerRadius: cornerRadius)
                )
        }
    }
}

extension ButtonStyle where Self == GlassButtonStyle {
    static func glass(
        tintColor: Color = .main,
        foregroundColor: Color = .white,
        cornerRadius: CGFloat = 8,
        tintOpacity: Double = 0.35
    ) -> GlassButtonStyle {
        .init(
            tintColor: tintColor,
            foregroundColor: foregroundColor,
            cornerRadius: cornerRadius,
            tintOpacity: tintOpacity
        )
    }
}
