import Foundation
import Combine

class EstanteViewModel: ObservableObject {
    @Published var livros = [
        Livro(titulo: "O Pequeno Príncipe", autor: "Antoine de Saint-Exupéry", paginas: 96, lido: true),
        Livro(titulo: "Dom Casmurro", autor: "Machado de Assis", paginas: 256),
        Livro(titulo: "A Hora da Estrela", autor: "Clarice Lispector", paginas: 88, lido: true),
        Livro(titulo: "Capitães da Areia", autor: "Jorge Amado", paginas: 280)
    ]
    var lidos: Int { livros.filter(\.lido).count }
    var paginasLidas: Int { livros.filter(\.lido).reduce(0) { $0 + $1.paginas } }
    func adicionar(titulo: String, autor: String, paginas: Int) {
        let titulo = titulo.trimmingCharacters(in: .whitespacesAndNewlines)
        let autor = autor.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !titulo.isEmpty, !autor.isEmpty, (1...2000).contains(paginas) else { return }
        livros.append(Livro(titulo: titulo, autor: autor, paginas: paginas))
    }
    func apagar(id: UUID) { livros.removeAll { $0.id == id } }
    func definirLido(id: UUID, lido: Bool) {
        if let indice = livros.firstIndex(where: { $0.id == id }) { livros[indice].lido = lido }
    }
    func livro(id: UUID) -> Livro? { livros.first { $0.id == id } }
}
