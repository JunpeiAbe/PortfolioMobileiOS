import SwiftUI

struct NotificationRow: View {
    
    let notice: Notice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(notice.category.title)
                    .captionFont()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(notice.category.color)
                    .foregroundStyle(Color.primaryWhite)
                    .clipShape(.capsule)
                Spacer()
                Text(notice.publishedAt.iso8601ToJSTString())
                    .captionFont()
                    .foregroundStyle(.gray)
            }
            Text(notice.title)
                .headlineFont()
                .foregroundStyle(.primaryBlack)
            Text(notice.summary)
                .bodyFont()
                .foregroundStyle(.textPrimary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.primaryWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    let notice: Notice = .init(
        id: "1",
        title: "お知らせ",
        summary: "概要",
        body: .init(),
        category: .campaign,
        publishedAt: "2026-06-12T09:30:00Z",
        thumbnailURL: nil
    )
    NotificationRow(notice: notice)
}
