

import UIKit

public struct RateWorkouts: Codable {
    let workoutId: String
    let score: Int
    let userId: String


    enum CodingKeys: String, CodingKey {
        case workoutId = "workout_id"
        case score
        case userId = "user_id"

    }
}
