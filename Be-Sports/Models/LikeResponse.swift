

import Foundation

struct LikeResponse: Codable {
    let userId: String
    let id: String
    let isSelected: Bool?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case id
        case isSelected = "is_selected"
    }
}


