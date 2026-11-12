import SwiftUI

struct Filme: Identifiable {
    let id = UUID()
    var titulo: String
    var ano: Int
    var genero: String
    var nota: Int
    var assistido = false
}

func corDoGenero(_ nome: String) -> Color {
    if nome == "Ação" { return .red }
    if nome == "Comédia" { return .orange }
    if nome == "Drama" { return .purple }
    if nome == "Animação" { return .blue }
    if nome == "Documentário" { return .green }
    return .gray
}
