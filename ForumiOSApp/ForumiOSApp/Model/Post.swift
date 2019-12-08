
import Foundation

struct Post: Codable {
    let id: Int
    let userId: Int
    let content: String
    let toPost: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case userId = "USER_ID"
        case content = "CONTENT"
        case toPost = "TO_POST_ID"
    }
}
