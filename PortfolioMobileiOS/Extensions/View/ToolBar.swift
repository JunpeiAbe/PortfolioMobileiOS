import SwiftUI

extension View {
    /// ナビゲーションバーのボタン、背景色指定
    @ViewBuilder
    func toolBar(
        title: String,
        isLeftButtonHidden: Bool = false,
        isRightButtonHidden: Bool = false,
        leftButtonAction: @escaping () -> Void,
        rightButtonAction: @escaping () -> Void
    ) -> some View {
        self.toolbar {
            if !isLeftButtonHidden {
                ToolbarItem(placement: .topBarLeading) {
                    Button(
                        action: {
                            leftButtonAction()
                        },
                        label: {
                            SymbolImage.back
                                .font(.system(size: 20))
                                .foregroundStyle(.gray)
                        }
                    )
                    .buttonStyle(.plain)
                }
            }
            ToolbarItem(placement: .title) {
                Text(title)
                    .font(.system(size: 18,weight: .bold))
                    .foregroundStyle(.textPrimary)
            }
            if !isRightButtonHidden {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {
                            rightButtonAction()
                        },
                        label: {
                            SymbolImage.help
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.gray)
                        }
                    )
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.clear, for: .navigationBar)
    }
}

