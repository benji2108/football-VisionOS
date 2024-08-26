import SwiftUI

struct SidePanel: View {
    var content: String
    var color: Color
    
    var body: some View {
        VStack {
            Text(content)
                .padding()
                .foregroundColor(.white)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color)
    }
}

struct SidePanel_Previews: PreviewProvider {
    static var previews: some View {
        SidePanel(content: "Sample Content", color: .blue)
    }
}
