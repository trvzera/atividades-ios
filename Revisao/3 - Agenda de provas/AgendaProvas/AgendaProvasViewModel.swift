import Foundation
import Combine

class AgendaProvasViewModel: ObservableObject {
    @Published var provas: [ItemProva] = (1...4).map { numero in
        let materias = ["Matemática", "Português", "História", "Desenvolvimento iOS"]
        return ItemProva(materia: materias[numero - 1], sala: "Sala \(numero)", dia: Calendar.current.date(byAdding: .day, value: numero, to: Date()) ?? Date(), revisada: numero == 2)
    }
    @Published var soPendentes = false
    var visiveis: [ItemProva] { provas.filter { !soPendentes || !$0.revisada }.sorted { $0.dia < $1.dia } }
    var pendentes: Int { provas.filter { !$0.revisada }.count }
    func adicionar(materia: String, sala: String, dia: Date) {
        let materia = materia.trimmingCharacters(in: .whitespacesAndNewlines)
        let sala = sala.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !materia.isEmpty, !sala.isEmpty else { return }
        provas.append(ItemProva(materia: materia, sala: sala, dia: dia))
    }
    func apagar(id: UUID) { provas.removeAll { $0.id == id } }
    func definirRevisada(id: UUID, revisada: Bool) {
        if let indice = provas.firstIndex(where: { $0.id == id }) { provas[indice].revisada = revisada }
    }
    func prova(id: UUID) -> ItemProva? { provas.first { $0.id == id } }
}
