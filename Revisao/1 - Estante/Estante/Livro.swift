import Foundation

struct Livro: Identifiable {
    let id = UUID()
    var titulo: String
    var autor: String
    var paginas: Int
    var lido = false
}
