//
//  LikeResponse.swift
//  Betus
//
//  Created by Gio's Mac on 06.12.24.
//

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


