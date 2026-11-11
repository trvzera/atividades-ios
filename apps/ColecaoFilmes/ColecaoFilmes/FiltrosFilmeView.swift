import SwiftUI

struct FiltrosFilmeView: View {
    @Binding var situacao: String
    @Binding var genero: String
    @Binding var notaMinima: Int
    @Binding var ordem: String
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Form {
                Picker("Situação", selection: $situacao) {
                    Text("Todos").tag("Todos"); Text("Assistidos").tag("Assistidos"); Text("Não assistidos").tag("Não assistidos")
                }
                Picker("Gênero", selection: $genero) {
                    Text("Todos").tag("Todos"); Text("Ação").tag("Ação"); Text("Comédia").tag("Comédia")
                    Text("Drama").tag("Drama"); Text("Animação").tag("Animação"); Text("Documentário").tag("Documentário")
                }
                Stepper("Nota mínima: \(notaMinima)", value: $notaMinima, in: 1...5)
                Picker("Ordem", selection: $ordem) {
                    Text("Título").tag("Título"); Text("Ano").tag("Ano"); Text("Avaliação").tag("Avaliação")
                }
            }
            .navigationTitle("Filtros")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Fechar") { dismiss() } } }
        }
    }
}
