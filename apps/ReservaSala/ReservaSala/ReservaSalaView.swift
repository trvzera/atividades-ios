import SwiftUI

struct ReservaSalaView: View {
    @State private var nome = ""
    @State private var sala = "Laboratório"
    @State private var data = Date()
    @State private var pessoas = 10
    @State private var projetor = false
    @State private var mostrarAlerta = false

    var body: some View {
        Form {
            Section("Quem reserva") {
                TextField("Nome", text: $nome).textInputAutocapitalization(.words)
                Picker("Sala", selection: $sala) {
                    Text("Laboratório").tag("Laboratório")
                    Text("Biblioteca").tag("Biblioteca")
                    Text("Auditório").tag("Auditório")
                }
            }
            Section("Quando") {
                DatePicker("Data", selection: $data, displayedComponents: .date)
                Stepper("Pessoas: \(pessoas)", value: $pessoas, in: 1...40)
                Toggle("Projetor", isOn: $projetor)
            }
            Button("Reservar") { mostrarAlerta = true }
                .disabled(nome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .navigationTitle("Reserva")
        .alert("Reserva feita", isPresented: $mostrarAlerta) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(sala) reservada para \(nome.trimmingCharacters(in: .whitespacesAndNewlines)), \(pessoas) pessoas.")
        }
    }
}
