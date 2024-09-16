import Foundation

// MARK: - FixtureStatisticsResponse
struct FixtureStatisticsResponse: Codable {
    let get: String?
    let parameters: Parameters?
    let errors: [String]?  // Modifié pour correspondre au JSON
    let results: Int?
    let paging: Paging?
    let response: [StatisticItem]?
}

// MARK: - Paging
struct Paging: Codable {
    let current, total: Int?
}

// MARK: - Parameters
struct Parameters: Codable {
    let team: String?     // Ajouté pour correspondre au JSON
    let fixture: String?
}

// MARK: - StatisticItem
struct StatisticItem: Codable {
    let team: Team
    let statistics: [StatisticDetail]
}

// MARK: - Team
struct Team: Codable {
    let id: Int
    let name: String
    let logo: String
}

// MARK: - StatisticDetail
struct StatisticDetail: Codable {
    let type: String
    let value: StatisticValue?
}

// MARK: - StatisticValue
enum StatisticValue: Codable {
    case int(Int)
    case double(Double)
    case string(String)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(StatisticValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Type non supporté"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let intValue):
            try container.encode(intValue)
        case .double(let doubleValue):
            try container.encode(doubleValue)
        case .string(let stringValue):
            try container.encode(stringValue)
        case .null:
            try container.encodeNil()
        }
    }
}

extension StatisticValue {
    var description: String {
        switch self {
        case .int(let value):
            return "\(value)"
        case .double(let value):
            return String(format: "%.2f", value)
        case .string(let value):
            return value
        case .null:
            return "N/A"
        }
    }
}
