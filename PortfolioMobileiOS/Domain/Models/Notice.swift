import Foundation

struct Notice: Identifiable, Decodable {
    let id: String
    let title: String
    let summary: String
    let body: String
    let category: NoticeCategory
    let publishedAt: Date
    let thumbnailURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case summary = "summary"
        case body = "body"
        case category = "category"
        case publishedAt = "published_at"
        case thumbnailURL = "thumbnail_url"
    }
}

