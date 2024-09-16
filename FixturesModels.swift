import Foundation

// MARK: - FixturesResponse
struct FixturesResponse: Codable {
    let get: String?
    let parameters: Parameters?
    let errors: [String]?
    let results: Int?
    let paging: Paging?
    let response: [Fixture]?
}

// MARK: - Fixture
struct Fixture: Codable, Identifiable {
    let fixture: FixtureDetails
    let league: League
    let teams: Teams
    let goals: Goals

    var id: Int {
        return fixture.id
    }
}

// MARK: - FixtureDetails
struct FixtureDetails: Codable {
    let id: Int
    let referee: String?
    let timezone: String?
    let date: String?
    let timestamp: Int?
    let venue: Venue?
    let status: Status?
}

// MARK: - League
struct League: Codable {
    let id: Int?
    let name: String?
    let country: String?
    let logo: String?
    let flag: String?
    let season: Int?
    let round: String?
}

// MARK: - Teams
struct Teams: Codable {
    let home: TeamInfo
    let away: TeamInfo
}

// MARK: - TeamInfo
struct TeamInfo: Codable {
    let id: Int?
    let name: String?
    let logo: String?
    let winner: Bool?
}

// MARK: - Goals
struct Goals: Codable {
    let home: Int?
    let away: Int?
}

// MARK: - Venue
struct Venue: Codable {
    let id: Int?
    let name: String?
    let city: String?
    let address: String?
    let capacity: Int?
    let surface: String?
    let image: String?
}

// MARK: - Status
struct Status: Codable {
    let long: String?
    let short: String?
    let elapsed: Int?
}

// Vous pouvez ajouter ou ajuster les structures en fonction des données réelles que vous recevez de l'API.
