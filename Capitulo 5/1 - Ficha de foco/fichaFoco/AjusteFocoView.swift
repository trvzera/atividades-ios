import SwiftUI

struct AjustesFocoView: View {
    @ObservedObject var foco: FocoViewModel
    @Binding var mostrarAlerta: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("Matéria", text: $foco.materia)
                    .textInputAutocapitalization(.words)
                Stepper("Minutos: \(foco.minutosAlvo)", value: $foco.minutosAlvo, in: 5...60)
                Toggle("Som ao terminar", isOn: $foco.somLigado)
                DatePicker("Data da prova", selection: $foco.dataProva, displayedComponents: [.date])
            }
            .navigationTitle("Ajustes")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        dismiss()
                        mostrarAlerta = true
                    }
                    .disabled(!foco.formularioValido)
                }
            }
        }
    }
}
