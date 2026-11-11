import SwiftUI

struct NovoFilmeView: View {
    let anoLimite: Int
    let aoSalvar: (Filme) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var titulo = ""
    @State private var ano = ""
    @State private var genero = "Drama"
    @State private var nota = 3
    private var podeSalvar: Bool {
        guard let numero = Int(ano) else { return false }
        return !titulo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && (1900...anoLimite).contains(numero)
    }
    var body: some View {
        NavigationStack {
            Form {
                TextField("Título", text: $titulo)
                TextField("Ano", text: $ano).keyboardType(.numberPad)
                Picker("Gênero", selection: $genero) {
                    Text("Ação").tag("Ação"); Text("Comédia").tag("Comédia")
                    Text("Drama").tag("Drama"); Text("Animação").tag("Animação")
                    Text("Documentário").tag("Documentário")
                }
                Stepper("Nota: \(nota)", value: $nota, in: 1...5)
            }
            .navigationTitle("Novo filme")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        guard podeSalvar, let numero = Int(ano) else { return }
                        aoSalvar(Filme(titulo: titulo.trimmingCharacters(in: .whitespacesAndNewlines), ano: numero, genero: genero, nota: nota))
                        dismiss()
                    }.disabled(!podeSalvar)
                }
            }
        }
    }
}
