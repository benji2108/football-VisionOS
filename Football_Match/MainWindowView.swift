import SwiftUI
import AVKit

struct MainWindowView: View {
    @Environment(\.openWindow) private var openWindow  // Hypothétique API pour ouvrir des fenêtres
    
    var body: some View {
        NavigationStack {  // Utilisation de NavigationStack pour englober tout le contenu
            videoPlayerSection  // Appel d'une vue séparée pour la lecture vidéo
            .edgesIgnoringSafeArea(.all)  // Assure que la vidéo s'étend jusqu'aux bords de l'écran
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Stats") {
                            openWindow(id: "first-window")
                            openWindow(id: "second-window")
                        }
                    } label: {
                        Label("Menu", systemImage: "ellipsis.circle")
                    }
                }
            }
        }
    }
    
    private var videoPlayerSection: some View {
        GeometryReader { geometry in
            if let url = Bundle.main.url(forResource: "AMNESIA", withExtension: "mp4") {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else {
                Text("Video not found")
                    .foregroundColor(.red)
                    .frame(width: geometry.size.width)
            }
        }
    }
}

struct MainWindowView_Previews: PreviewProvider {
    static var previews: some View {
        MainWindowView()
    }
}
