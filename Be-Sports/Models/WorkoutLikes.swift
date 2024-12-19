//
//  WorkoutLikes.swift
//  Betus
//
//  Created by Gio's Mac on 07.12.24.
//

import UIKit

struct WorkoutLikes: Codable {
    let id: String
    let taskCount: Int
    let time: Int
    let level: String
    let details: String
    let isSelected: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case taskCount = "task_count"
        case time
        case level
        case details
        case isSelected
    }
}

