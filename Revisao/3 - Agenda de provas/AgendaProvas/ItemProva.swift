import Foundation

struct ItemProva: Identifiable {
    let id = UUID()
    var materia: String
    var sala: String
    var dia: Date
    var revisada = false
}
