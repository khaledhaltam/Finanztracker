import SwiftUI
import Charts

struct ContractView: View {
    let contract: ContractDto

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Vertragsdetails
                contractDetailsSection

                // Zahlungsvorschau
                paymentPreviewSection

                // Statistiken
                paymentFrequencyChart
            }
            .padding()
            .navigationTitle(contract.name)
        }
    }

    // MARK: - Vertragsdetails
    private var contractDetailsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: contract.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 10)

                VStack(alignment: .leading, spacing: 5) {
                    Text(contract.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Nächste Abbuchung: \(contract.nextPaymentDate, style: .date)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }

            HStack {
                VStack(alignment: .leading) {
                    Text("Intervall")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(contract.frequency)
                        .font(.body)
                }

                Spacer()

                VStack(alignment: .leading) {
                    Text("Betrag")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(contract.amount, format: .currency(code: "EUR"))
                        .font(.body)
                        .foregroundColor(contract.amount < 0 ? .red : .green)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    // MARK: - Zahlungsvorschau
    private var paymentPreviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Zahlungsvorschau")
                .font(.headline)

            ForEach(nextFivePayments, id: \ .self) { date in
                HStack {
                    Text(date, style: .date)
                        .font(.body)
                    Spacer()
                    Text(contract.amount, format: .currency(code: "EUR"))
                        .font(.body)
                        .foregroundColor(contract.amount < 0 ? .red : .green)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    // MARK: - Zahlungshäufigkeit
    private var paymentFrequencyChart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Zahlungshäufigkeit")
                .font(.headline)

            Chart {
                ForEach(paymentFrequencyData, id: \ .label) { data in
                    BarMark(
                        x: .value("Intervall", data.label),
                        y: .value("Betrag", data.value)
                    )
                    .foregroundStyle(data.label == contract.frequency ? .blue : .gray)
                }
            }
            .frame(height: 200)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    // MARK: - Helper Properties
    private var nextFivePayments: [Date] {
        var dates: [Date] = []
        var currentDate = contract.nextPaymentDate

        for _ in 1...5 {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: frequencyComponent, value: 1, to: currentDate) ?? currentDate
        }

        return dates
    }

    private var frequencyComponent: Calendar.Component {
        switch contract.frequency.lowercased() {
        case "täglich":
            return .day
        case "wöchentlich":
            return .weekOfYear
        case "monatlich":
            return .month
        case "jährlich":
            return .year
        default:
            return .month
        }
    }

    private var paymentFrequencyData: [ChartData] {
        [
            ChartData(label: "Täglich", value: contract.frequency == "Täglich" ? abs(contract.amount) : 0),
            ChartData(label: "Wöchentlich", value: contract.frequency == "Wöchentlich" ? abs(contract.amount) : 0),
            ChartData(label: "Monatlich", value: contract.frequency == "Monatlich" ? abs(contract.amount) : 0),
            ChartData(label: "Jährlich", value: contract.frequency == "Jährlich" ? abs(contract.amount) : 0)
        ]
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}

#Preview {
    let contract = ContractDto(
        name: "Netflix", amount: -12.99, icon: "film.fill",
        nextPaymentDate: Date().addingTimeInterval(86400 * 15),
        frequency: "Monatlich")
    ContractView(contract: contract)
}
