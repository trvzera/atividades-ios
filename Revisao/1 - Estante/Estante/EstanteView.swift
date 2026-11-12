import SwiftUI

struct EstanteView: View {
    @StateObject private var estante = EstanteViewModel()
    @State private var mostrarNovo = false
    var body: some View {
        NavigationStack {
            List {
                Section("Resumo") {
                    Text("Livros: \(estante.livros.count)")
                    Text("Lidos: \(estante.lidos)")
                    Text("Páginas lidas: \(estante.paginasLidas)")
                }
                Section("Estante") {
                    ForEach(estante.livros) { livro in
                        NavigationLink { LivroDetalheView(estante: estante, id: livro.id) } label: {
                            VStack(alignment: .leading) { Text(livro.titulo); Text(livro.autor).font(.caption).foregroundStyle(.secondary) }
                        }
                    }
                    .onDelete { indices in
                        let ids = indices.map { estante.livros[$0].id }
                        ids.forEach { estante.apagar(id: $0) }
                    }
                }
            }.navigationTitle("Estante")
                .toolbar {
                    Button { mostrarNovo = true } label: { Image(systemName: "plus") }.accessibilityLabel("Novo livro")
                }
                .sheet(isPresented: $mostrarNovo) { NovoLivroView(estante: estante) }
        }
    }
}

struct LivroDetalheView: View {
    @ObservedObject var estante: EstanteViewModel
    let id: UUID
    var body: some View {
        Form {
            if let livro = estante.livro(id: id) {
                LabeledContent("Autor", value: livro.autor)
                LabeledContent("Páginas", value: "\(livro.paginas)")
                Toggle("Lido", isOn: Binding(
                    get: { estante.livro(id: id)?.lido ?? false },
                    set: { estante.definirLido(id: id, lido: $0) }
                ))
            } else { Text("Livro removido") }
        }.navigationTitle(estante.livro(id: id)?.titulo ?? "Livro")
    }
}

struct NovoLivroView: View {
    @ObservedObject var estante: EstanteViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var titulo = ""
    @State private var autor = ""
    @State private var paginas = 100
    private var podeSalvar: Bool {
        !titulo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !autor.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var body: some View {
        NavigationStack {
            Form {
                TextField("Título", text: $titulo)
                TextField("Autor", text: $autor).textInputAutocapitalization(.words)
                Stepper("Páginas: \(paginas)", value: $paginas, in: 1...2000)
            }.navigationTitle("Novo livro")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Salvar") { estante.adicionar(titulo: titulo, autor: autor, paginas: paginas); dismiss() }.disabled(!podeSalvar)
                    }
                }
        }
    }
}
