import SwiftUI

struct FirstWindowView: View {
    @State private var statistics: [StatisticItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedFixtureID: Int? = nil
    @State private var showFixtureList = false

    var body: some View {
        VStack {
            if let fixtureID = selectedFixtureID {
                // Afficher les statistiques pour le match sélectionné
                VStack {
                    if isLoading {
                        ProgressView("Chargement des statistiques...")
                    } else if let errorMessage = errorMessage {
                        Text("Erreur : \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    } else if statistics.count == 2 {
                        // Affichage principal pour deux équipes
                        ScrollView {
                            VStack(spacing: 20) {
                                // En-tête avec les logos et noms des équipes
                                HStack(spacing: 50) {
                                    TeamHeaderView(team: statistics[0].team)
                                    Text("VS")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    TeamHeaderView(team: statistics[1].team)
                                }

                                Divider()

                                // Récupérer les types de statistiques disponibles
                                let statTypes = statistics[0].statistics.map { $0.type }

                                // Afficher chaque statistique
                                ForEach(statTypes, id: \.self) { type in
                                    let homeStat = statistics[0].statistics.first(where: { $0.type == type })?.value?.description ?? "N/A"
                                    let awayStat = statistics[1].statistics.first(where: { $0.type == type })?.value?.description ?? "N/A"

                                    StatisticRowView(statType: type, homeValue: homeStat, awayValue: awayStat)
                                }
                            }
                            .padding()
                        }
                    } else if statistics.count >= 1 {
                        // Affichage pour une seule équipe
                        ScrollView {
                            VStack(spacing: 20) {
                                // Afficher l'équipe disponible
                                TeamHeaderView(team: statistics[0].team)
                                    .padding()

                                // Afficher les statistiques de l'équipe
                                ForEach(statistics[0].statistics, id: \.type) { stat in
                                    HStack {
                                        Text(stat.type)
                                            .font(.body)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(stat.value?.description ?? "N/A")
                                            .font(.body)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                            .padding()
                        }
                    } else {
                        Text("Les données des équipes ne sont pas disponibles.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                // Supprimer l'appel à `loadFixtureStatistics` depuis `onAppear`
                // Ajouter un bouton pour changer de match
                Button("Changer de match") {
                    showFixtureList = true
                }
                .padding()
                // Présenter FixtureListView avec NavigationView pour le titre
                .sheet(isPresented: $showFixtureList) {
                    NavigationView {
                        FixtureListView(selectedFixtureID: $selectedFixtureID)
                            .navigationTitle("Sélectionnez un match")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                }
            } else {
                // Si aucun match n'est sélectionné, afficher la liste des fixtures
                NavigationView {
                    FixtureListView(selectedFixtureID: $selectedFixtureID)
                        .navigationTitle("Sélectionnez un match")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        // Utiliser `onChange` pour réagir aux changements de `selectedFixtureID`
        .onChange(of: selectedFixtureID) { newFixtureID in
            if let fixtureID = newFixtureID {
                loadFixtureStatistics(fixtureId: fixtureID)
            } else {
                // Réinitialiser les données si aucun match n'est sélectionné
                statistics = []
                errorMessage = nil
            }
        }
    }

    private func loadFixtureStatistics(fixtureId: Int) {
        isLoading = true
        statistics = []
        errorMessage = nil

        APIManager.shared.fetchFixtureStatistics(fixtureId: fixtureId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let statistics):
                    if statistics.isEmpty {
                        self.errorMessage = "Aucune statistique disponible."
                    } else {
                        self.statistics = statistics
                    }
                case .failure(let error):
                    print("Erreur lors du chargement des statistiques : \(error)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
