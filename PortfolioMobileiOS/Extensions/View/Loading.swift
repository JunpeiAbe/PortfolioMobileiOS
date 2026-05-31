import SwiftUI

struct LoadingModifier: ViewModifier {
    @Binding var isPresented: Bool
    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    ZStack {
                        Color.overlayGray
                            .ignoresSafeArea()
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.paleGray)
                        VStack(alignment: .center, spacing: 16) {
                            ProgressView()
                                .scaleEffect(x: 1.5, y: 1.5)
                        }
                    }
                }
            }
    }
}

extension View {
    /// カスタムローディング表示
    @ViewBuilder
    func loading(
        isPresented: Binding<Bool>
    ) -> some View {
        self.modifier(
            LoadingModifier(
                isPresented: isPresented
            )
        )
    }
}
