

import UIKit

public struct UserInfo: Codable {
    let id: String
    let appleToken: String
    let pushToken: String
    let createdAt: String
    let isPremium: Bool = false 

    enum CodingKeys: String, CodingKey {
        case id
        case appleToken = "auth_token"
        case pushToken = "push_token"
        case createdAt = "created_at"
    }
}
