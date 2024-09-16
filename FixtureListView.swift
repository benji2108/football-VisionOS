import SwiftUI

struct FixtureListView: View {
    @State private var fixtures: [Fixture] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @Binding var selectedFixtureID: Int?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Sélectionnez un match")
                .font(.title)
                .padding()

            if isLoading {
                ProgressView("Chargement des matchs...")
            } else if let errorMessage = errorMessage {
                Text("Erreur : \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(fixtures) { fixture in
                    Button(action: {
                        selectedFixtureID = fixture.fixture.id
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack(alignment: .leading) {
                            Text("\(fixture.teams.home.name ?? "Équipe A") vs \(fixture.teams.away.name ?? "Équipe B")")
                                .font(.headline)
                            Text(fixture.league.name ?? "Ligue inconnue")
                                .font(.subheadline)
                            if let date = fixture.fixture.date {
                                Text(formatDate(date))
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            loadFixtures()
        }
    }

    private func loadFixtures() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let dateString = dateFormatter.string(from: today)

        APIManager.shared.fetchFixtures(forDate: dateString) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fixtures):
                    self.fixtures = fixtures
                case .failure(let error):
                    print("Erreur lors du chargement des fixtures : \(error)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func formatDate(_ dateString: String) -> String {
        // Formate la date pour un affichage convivial
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
}
