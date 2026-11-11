import SwiftUI

struct ListaFilmesView: View {
    @State private var filmes = [
        Filme(titulo: "A Viagem de Chihiro", ano: 2001, genero: "Animação", nota: 5, assistido: true),
        Filme(titulo: "Interestelar", ano: 2014, genero: "Drama", nota: 5),
        Filme(titulo: "De Volta para o Futuro", ano: 1985, genero: "Comédia", nota: 4, assistido: true),
        Filme(titulo: "Planeta Azul", ano: 2001, genero: "Documentário", nota: 4),
        Filme(titulo: "Pantera Negra", ano: 2018, genero: "Ação", nota: 4)
    ]
    @State private var mostrarNovo = false
    @State private var mostrarFiltros = false
    @State private var situacao = "Todos"
    @State private var genero = "Todos"
    @State private var notaMinima = 1
    @State private var ordem = "Título"

    var visiveis: [Filme] {
        filmes.filter { filme in
            (situacao == "Todos" || (situacao == "Assistidos" ? filme.assistido : !filme.assistido)) &&
            (genero == "Todos" || filme.genero == genero) && filme.nota >= notaMinima
        }.sorted {
            if ordem == "Ano" { return $0.ano == $1.ano ? $0.titulo < $1.titulo : $0.ano < $1.ano }
            if ordem == "Avaliação" { return $0.nota == $1.nota ? $0.titulo < $1.titulo : $0.nota > $1.nota }
            return $0.titulo.localizedCaseInsensitiveCompare($1.titulo) == .orderedAscending
        }
    }
    private var assistidos: Int { filmes.filter(\.assistido).count }
    private var media: Double { filmes.isEmpty ? 0 : Double(filmes.reduce(0) { $0 + $1.nota }) / Double(filmes.count) }

    var body: some View {
        NavigationStack {
            List {
                Section("Resumo") {
                    Text("Total: \(filmes.count)")
                    Text("Assistidos: \(assistidos) (\(filmes.isEmpty ? 0 : assistidos * 100 / filmes.count)%)")
                    Text("Média: \(media, specifier: "%.1f")")
                    Text("Ação: \(filmes.filter { $0.genero == "Ação" }.count)").foregroundStyle(corDoGenero("Ação"))
                    Text("Comédia: \(filmes.filter { $0.genero == "Comédia" }.count)").foregroundStyle(corDoGenero("Comédia"))
                    Text("Drama: \(filmes.filter { $0.genero == "Drama" }.count)").foregroundStyle(corDoGenero("Drama"))
                    Text("Animação: \(filmes.filter { $0.genero == "Animação" }.count)").foregroundStyle(corDoGenero("Animação"))
                    Text("Documentário: \(filmes.filter { $0.genero == "Documentário" }.count)").foregroundStyle(corDoGenero("Documentário"))
                }
                Section("Filmes") {
                    ForEach(visiveis) { filme in
                        HStack {
                            Button { alternar(filme.id) } label: { FilmeCell(filme: filme) }
                                .buttonStyle(.borderless)
                            Spacer()
                            Button(role: .destructive) { apagar(filme.id) } label: { Image(systemName: "trash") }
                                .buttonStyle(.borderless).accessibilityLabel("Apagar \(filme.titulo)")
                        }
                    }
                    .onDelete { indices in
                        // Os índices pertencem à lista filtrada: capture os ids antes de remover.
                        let ids = indices.map { visiveis[$0].id }
                        filmes.removeAll { ids.contains($0.id) }
                    }
                }
            }
            .navigationTitle("Filmes")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { mostrarFiltros = true } label: { Image(systemName: "line.3.horizontal.decrease.circle") }
                        .accessibilityLabel("Filtros")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { mostrarNovo = true } label: { Image(systemName: "plus") }.accessibilityLabel("Novo filme")
                }
            }
            .sheet(isPresented: $mostrarNovo) {
                NovoFilmeView(anoLimite: Calendar.current.component(.year, from: Date())) { filmes.append($0) }
            }
            .sheet(isPresented: $mostrarFiltros) {
                FiltrosFilmeView(situacao: $situacao, genero: $genero, notaMinima: $notaMinima, ordem: $ordem)
            }
        }
    }
    private func alternar(_ id: UUID) {
        if let indice = filmes.firstIndex(where: { $0.id == id }) { filmes[indice].assistido.toggle() }
    }
    private func apagar(_ id: UUID) { filmes.removeAll { $0.id == id } }
}

struct FilmeCell: View {
    let filme: Filme
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Label(filme.titulo, systemImage: filme.assistido ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(.primary)
            Text("\(String(filme.ano)) · \(filme.genero)").font(.caption).foregroundStyle(corDoGenero(filme.genero))
            HStack(spacing: 3) {
                ForEach(1...5, id: \.self) { estrela in
                    Image(systemName: estrela <= filme.nota ? "star.fill" : "star").foregroundStyle(.orange)
                }
            }.font(.caption).accessibilityLabel("Nota \(filme.nota) de 5")
        }
    }
}
