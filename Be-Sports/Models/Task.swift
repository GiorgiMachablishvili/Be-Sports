struct Task: Codable {
    let title: String
    let description: String
    let time: Int
    let id: String

    enum CodingKeys: String, CodingKey {
        case title = "task_name"
        case description = "task_description"
        case time
        case id
    }
}
