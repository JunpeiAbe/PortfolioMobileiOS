import Foundation
import SwiftUI

enum NoticeCategory: Int, Decodable {
    case maintenance
    case versionUpdate
    case service
    case term
    case campaign
    case unknown
    
    var title: String {
        switch self {
            
        case .maintenance:
            "メンテナンスのお知らせ"
        case .versionUpdate:
            "アップデートのお知らせ"
        case .service:
            "サービスに関するお知らせ"
        case .term:
            "利用規約のお知らせ"
        case .campaign:
            "キャンペーンのお知らせ"
        case .unknown:
            "その他のお知らせ"
        }
    }
    
    var color: Color {
        switch self {
            
        case .maintenance:
            return .red
        case .versionUpdate:
            return .blue
        case .service, .term, .campaign:
            return .main
        case .unknown:
            return .black
        }
    }
}
