import SwiftUI

struct TermScreen: View {
    @State var state: TermScreenState
    init(state: TermScreenState) {
        self.state = state
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            WebView(source: .localFile(name: "terms_stub", extension: "html"))
            Divider()
                .foregroundStyle(.gray)
            bottomContent
        }
        .screenBackground()
        .toolBar(
            title: "Terms",
            isLeftButtonHidden: true,
            isRightButtonHidden: true,
            leftButtonAction: {},
            rightButtonAction: {},
        )
    }
    
    private var bottomContent: some View {
            VStack(alignment: .center, spacing: 16) {
                HStack(spacing: 8) {
                    Button {
                        state.checkButtonPressed()
                    } label: {
                        state.isChecked
                        ? SymbolImage.checkmarkFill
                        : SymbolImage.checkmarkEmpty
                    }
                    .titleFont()
                    .foregroundStyle(state.isChecked ? Color.main : Color.gray)
                    Text("利用規約に同意する")
                        .bodyFont()
                }
                Button("Agree") {
                    state.agreeButtonPressed()
                }
                .buttonStyle(
                    .filled(
                        backgroundColor: state.isAgreeButtonDisabled ? Color.gray : Color.main
                    )
                )
                .headlineFont()
                .disabled(state.isAgreeButtonDisabled)
                .frame(height: 48)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .background {
                Color.white
                    .ignoresSafeArea(edges: .bottom)
            }
    }
}

#Preview {
    @Previewable var state: TermScreenState = .init()
    TermScreen(state: state)
}
