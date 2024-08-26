import SwiftUI

@main
struct Football_MatchApp: App {
    var body: some Scene {
        WindowGroup {
            MainWindowView()
        }

        WindowGroup(id: "first-window") {
            FirstWindowView()
        }
        // Hypothétique exemple d'utilisation de la configuration de position et de taille
        .defaultSize(CGSize(width: 300, height: 800))
        
        WindowGroup(id: "second-window") {
            SecondWindowView()
        }
        .defaultSize(CGSize(width: 300, height: 800))
    }
}
