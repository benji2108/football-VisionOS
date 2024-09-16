import SwiftUI

struct TeamHeaderView: View {
    let team: Team

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: team.logo)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80) // Augmenter la taille du logo
            .clipShape(Circle())
            Text(team.name)
                .font(.title) // Taille de police augmentée
                .multilineTextAlignment(.center)
        }
    }

    struct TeamHeaderView_Previews: PreviewProvider {
        static var previews: some View {
            TeamHeaderView(team: Team(id: 1, name: "Équipe A", logo: "https://via.placeholder.com/60"))
        }
    }
}
