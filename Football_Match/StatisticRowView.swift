import SwiftUI

struct StatisticRowView: View {
    let statType: String
    let homeValue: String
    let awayValue: String

    var body: some View {
        HStack {
            Text(homeValue)
                .font(.body) // Taille de police augmentée
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(colorForValue(homeValue, comparedTo: awayValue, isHigherBetter: isHigherBetter(for: statType)))
            Text(statType)
                .font(.body) // Taille de police augmentée
                .frame(maxWidth: .infinity, alignment: .center)
            Text(awayValue)
                .font(.body) // Taille de police augmentée
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(colorForValue(awayValue, comparedTo: homeValue, isHigherBetter: isHigherBetter(for: statType)))
        }
        .padding(.vertical, 5)
    }

    // Détermine si une valeur plus élevée est meilleure pour une statistique donnée
    func isHigherBetter(for statType: String) -> Bool {
        let positiveStats = ["Shots on Goal", "Total Shots", "Ball Possession", "Passes accurate", "Total passes", "Shots off Goal", "Blocked Shots", "Shots insidebox", "Shots outsidebox", "Goalkeeper Saves", "Corner Kicks"]
        let negativeStats = ["Fouls", "Yellow Cards", "Red Cards", "Offsides"]
        if positiveStats.contains(statType) {
            return true
        } else if negativeStats.contains(statType) {
            return false
        } else {
            return true // Par défaut, considérer qu'une valeur plus élevée est meilleure
        }
    }

    // Compare les valeurs et renvoie une couleur
    func colorForValue(_ value: String, comparedTo otherValue: String, isHigherBetter: Bool) -> Color {
        guard let valueNumber = parseValue(value),
              let otherValueNumber = parseValue(otherValue) else {
            return .primary
        }

        if valueNumber == otherValueNumber {
            return .primary
        } else if (valueNumber > otherValueNumber && isHigherBetter) || (valueNumber < otherValueNumber && !isHigherBetter) {
            return .green
        } else {
            return .red
        }
    }

    // Fonction pour extraire le nombre d'une chaîne, en gérant les pourcentages
    func parseValue(_ value: String) -> Double? {
        let cleanedValue = value.replacingOccurrences(of: "%", with: "")
        return Double(cleanedValue)
    }
}

struct StatisticRowView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticRowView(statType: "Possession", homeValue: "60%", awayValue: "40%")
    }
}
