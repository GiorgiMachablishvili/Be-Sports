

import Foundation

struct Workouts: Codable {
    let taskName: String
    let taskCount: Int
    let level: Level
    let completers: [String]
    let details: String
    let id: String
    let image: String
    let userId: String?
    let isSelected: Bool
    let likeCount: Int
    let tasks: [Task]
    private let rawRating: Double

    var rating: Double {
        return Double(String(format: "%.1f", rawRating)) ?? 0.0
    }

    var time: Int {
        return tasks.reduce(0) { $0 + $1.time }
    }

    enum CodingKeys: String, CodingKey {
        case taskName = "name"
        case taskCount = "task_count"
        case level
        case completers
        case details
        case id
        case image
        case userId = "user_id"
        case isSelected = "is_selected"
        case likeCount = "like_count"
        case tasks
        case rawRating = "rating"
    }

    enum Level: Codable, Equatable {
        case easy
        case advance
        case difficult
        case all
        case intermediate(String)

        var rawValue: String {
            switch self {
            case .easy:
                return "Easy"
            case .advance:
                return "Advance"
            case .difficult:
                return "Difficult"
            case .all:
                return "All"
            case .intermediate(let value):
                return value
            }
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            switch value {
            case "Easy": self = .easy
            case "Advance": self = .advance
            case "Difficult": self = .difficult
            case "All": self = .all
            default: self = .intermediate(value)
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
        }
    }
}
