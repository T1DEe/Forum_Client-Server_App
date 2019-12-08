
import Foundation

struct Thread: Codable {
    var id: Int
    var title: String
    var description: String
    var post_count: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "TITLE"
        case description = "DESCRIPTION"
        case post_count = "POSTS_COUNT"
    }
}
