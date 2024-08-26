import SwiftUI

struct FirstWindowView: View {
    @State private var dataString: String = "Loading..."
    @State private var errorOccurred: Bool = false

    var body: some View {
        VStack {
            if errorOccurred {
                Text("Failed to load data.")
                    .foregroundColor(.red)
            } else {
                Text(dataString)
                    .foregroundColor(.green)
            }
        }
        .onAppear {
            APIManager.shared.fetchLeagues { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.dataString = data
                    case .failure(let error):
                        self.dataString = error.localizedDescription
                        self.errorOccurred = true
                    }
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
