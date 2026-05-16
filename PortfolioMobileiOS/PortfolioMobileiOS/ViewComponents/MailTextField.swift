import SwiftUI

struct MailTextField: View {
    
    @Binding var text: String
    var placeHolder: String = "Required"
    var isError: Bool = false
    var isFocused: Bool = false
    var onSubmit: (String) -> Void
    var onChange: (String) -> Void
    private var borderColor: Color {
        if isError {
            return .red
        }
        if isFocused {
            return .main
        }
        return .border
    }
    
    var body: some View {
        TextField(
            placeHolder,
            text: $text,
            axis: .horizontal
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(height: 48)
        .autocorrectionDisabled()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: 1.5)
        }
        .onSubmit {
            onSubmit(text)
        }
        .onChange(of: text) { _, newValue in
            onChange(text)
        }
    }
}

#Preview {
    @Previewable @State var text: String = .init()
    MailTextField(
        text: $text,
        onSubmit: { text in print(text)},
        onChange: { text in print(text)}
    )
    .padding(16)
}
