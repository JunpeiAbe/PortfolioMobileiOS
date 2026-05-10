import SwiftUI

extension View {
    func appFont(
        size: CGFloat,
        weight: Font.Weight = .regular,
        design: Font.Design = .default
    ) -> some View {
        font(.system(size: size, weight: weight, design: design))
    }

    func titleFont() -> some View {
        appFont(size: 24, weight: .bold)
    }

    func headlineFont() -> some View {
        appFont(size: 18, weight: .semibold)
    }

    func bodyFont() -> some View {
        appFont(size: 16, weight: .regular)
    }

    func captionFont() -> some View {
        appFont(size: 12, weight: .regular)
    }
}
