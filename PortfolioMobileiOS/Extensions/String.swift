import Foundation

extension String {
    /// ISO8601形式の日時文字列をJST表記に変換
    /// 例: "2026-06-12T09:30:00Z" -> "2026/06/12 18:30"
    func iso8601ToJSTString(
        format: String = "yyyy/MM/dd HH:mm"
    ) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime
        ]

        guard let date = isoFormatter.date(from: self) else {
            return self
        }

        let outputFormatter = DateFormatter()
        outputFormatter.calendar = Calendar(identifier: .gregorian)
        outputFormatter.locale = Locale(identifier: "ja_JP")
        outputFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        outputFormatter.dateFormat = format

        return outputFormatter.string(from: date)
    }
}
