import Foundation

enum NoticeCategory: Int, Decodable {
    case maintenance
    case versiosnUpdate
    case service
    case term
    case campaign
    case unknown
}
