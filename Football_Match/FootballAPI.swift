import Foundation

class APIManager {
    static let shared = APIManager()
    let baseURL = "https://v3.football.api-sports.io"
    let apiKey = "8caf8a128fc530a7cebe15efc10b6de7"  // Remplacez par votre propre clé API

    // Fonction pour récupérer les statistiques d'un match
    func fetchFixtureStatistics(fixtureId: Int, type: String? = nil, teamId: Int? = nil, completion: @escaping (Result<String, Error>) -> Void) {
        var urlString = "\(baseURL)/fixtures/statistics?fixture=\(fixtureId)"
        if let type = type {
            urlString += "&type=\(type)"
        }
        if let teamId = teamId {
            urlString += "&team=\(teamId)"
        }

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Data: \(dataString)")
                    completion(.success(dataString))
                } else {
                    completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
                }
            } else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed authentication or other network error"])))
            }
        }.resume()
    }
}
