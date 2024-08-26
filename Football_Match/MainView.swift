import SwiftUI
import AVKit

struct MainView: View {
    var body: some View {
        GeometryReader { geometry in
            if let url = Bundle.main.url(forResource: "AMNESIA", withExtension: "mp4") {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Video not found")
                    .foregroundColor(.red)
            }
        }
    }
}

struct MainVideoScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
