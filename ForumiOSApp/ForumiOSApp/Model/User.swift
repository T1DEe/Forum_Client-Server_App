
import Foundation

struct User: Codable {
    let id: Int
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case username = "USERNAME"
    }
}
