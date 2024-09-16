import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURL = "https://v3.football.api-sports.io"
    private let apiKey = "8caf8a128fc530a7cebe15efc10b6de7"  // Remplacez par votre clé API réelle

    // Fonction existante pour récupérer les statistiques d'un match
    func fetchFixtureStatistics(fixtureId: Int, completion: @escaping (Result<[StatisticItem], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/fixtures/statistics?fixture=\(fixtureId)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL invalide"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-apisports-key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur lors de la requête : \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("Aucune donnée reçue")
                completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Aucune donnée reçue"])))
                return
            }

            // Afficher le JSON brut pour le débogage
            if let dataString = String(data: data, encoding: .utf8) {
                print("JSON reçu : \(dataString)")
            }

            do {
                let decoder = JSONDecoder()
                let statisticsResponse = try decoder.decode(FixtureStatisticsResponse.self, from: data)
                if let statistics = statisticsResponse.response {
                    completion(.success(statistics))
                } else {
                    completion(.failure(NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "Pas de données dans la réponse"])))
                }
            } catch {
                print("Erreur de décodage : \(error)")
                completion(.failure(error))
            }
        }.resume()
    }

    // Nouvelle fonction pour récupérer les matchs d'une date donnée
    func fetchFixtures(forDate date: String, completion: @escaping (Result<[Fixture], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/fixtures?date=\(date)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL invalide"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-apisports-key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur lors de la requête : \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("Aucune donnée reçue")
                completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Aucune donnée reçue"])))
                return
            }

            // Afficher le JSON brut pour le débogage
            if let dataString = String(data: data, encoding: .utf8) {
                print("JSON reçu : \(dataString)")
            }

            do {
                let decoder = JSONDecoder()
                let fixturesResponse = try decoder.decode(FixturesResponse.self, from: data)
                if let fixtures = fixturesResponse.response {
                    completion(.success(fixtures))
                } else {
                    completion(.failure(NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "Pas de données dans la réponse"])))
                }
            } catch {
                print("Erreur de décodage : \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
