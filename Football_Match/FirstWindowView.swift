import SwiftUI

struct FirstWindowView: View {
    @State private var result: String = "Loading data..."

    var body: some View {
        VStack {
            Text(result)
                .foregroundColor(.blue)
                .padding()
                .onAppear {
                    loadFixtureStatistics()
                }
        }
    }

    private func loadFixtureStatistics() {
        APIManager.shared.fetchFixtureStatistics(fixtureId: 215662, type: "Total Shots", teamId: 463) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dataString):
                    self.result = dataString
                case .failure(let error):
                    self.result = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct FirstWindowView_Previews: PreviewProvider {
    static var previews: some View {
        FirstWindowView()
    }
}
