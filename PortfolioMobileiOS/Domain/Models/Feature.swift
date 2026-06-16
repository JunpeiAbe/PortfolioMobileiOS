import Foundation

struct Feature: Identifiable, Decodable, Hashable {
    let id: String
    let title: String
    let category: FeatureCategory
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case category = "category"
    }
}
