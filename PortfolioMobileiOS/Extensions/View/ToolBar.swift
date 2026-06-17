import SwiftUI

extension View {
    /// ナビゲーションバーのボタン、背景色指定
    @ViewBuilder
    func toolBar(
        title: String,
        isLeftButtonHidden: Bool = false,
        isRightButtonHidden: Bool = false,
        leftButtonAction: @escaping () -> Void,
        logoutButtonAction: @escaping () -> Void,
        helpButtonAction: @escaping () -> Void
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
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
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
                    HStack(spacing: 16) {
                        Button(
                            action: {
                                logoutButtonAction()
                            },
                            label: {
                                SymbolImage.logout
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.main)
                            }
                        )
                        .buttonStyle(.plain)
                        Button(
                            action: {
                                helpButtonAction()
                            },
                            label: {
                                SymbolImage.help
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.main)
                            }
                        )
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.white, for: .navigationBar)
    }
}

