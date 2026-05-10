import SwiftUI

struct FilledButtonStyle: ButtonStyle {
    var backgroundColor: Color = .main
    var cornerRadius: CGFloat = 8
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .shadow(color: .init(.systemGray4), radius: 8, y: 4)
            .brightness(configuration.isPressed ? -0.1 : 0.0)
    }
}

extension ButtonStyle where Self == FilledButtonStyle {
    static func filled(
        backgroundColor: Color = .main,
        cornerRadius: CGFloat = 8
    ) -> FilledButtonStyle {
        .init(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius
        )
    }
}
