import Foundation

enum AlertContent: Equatable {
    static let sample: PresentAlert = .init(title: "タイトル", message: "メッセージ", actions: [.cancel, .ok])
}

