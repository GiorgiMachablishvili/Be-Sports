//
//  WorkoutInfo.swift
//  Betus
//
//  Created by Gio's Mac on 03.12.24.
//

import UIKit

struct WorkoutInfo: Codable {
    let taskCount: Int
    let time: Int
    let level: Level
    let details: String
    let taskName: String
    let taskDescription: String
    let userId: String?
    let image: String
    let id: String
    let isSelected: Bool

    enum CodingKeys: String, CodingKey {
        case taskCount = "task_count"
        case time, level, details, image, id
        case userId = "user_id"
        case taskName = "task_name"
        case taskDescription = "task_description"
        case isSelected = "is_selected"
    }

    enum Level: String, Codable {
        case easy = "Easy"
        case advance = "Advance"
        case difficult = "Difficult"
        case all = "All"
    }
}

