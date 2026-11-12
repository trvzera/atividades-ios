import Foundation
import Combine

class LaboratorioViewModel: ObservableObject {
    @Published var equipes = [EquipeLab(nome: "Órbita", tema: "Astronomia", integrantes: 4), EquipeLab(nome: "Raízes", tema: "Botânica", integrantes: 3), EquipeLab(nome: "Circuito", tema: "Robótica", integrantes: 5), EquipeLab(nome: "Aurora", tema: "Energia solar", integrantes: 4)]
    @Published var aviso = ""
    var totalIntegrantes: Int { equipes.reduce(0) { $0 + $1.integrantes } }
    func apagar(id: UUID) { equipes.removeAll { $0.id == id } }
    func definirIntegrantes(id: UUID, valor: Int) {
        guard (1...12).contains(valor) else { return }
        if let indice = equipes.firstIndex(where: { $0.id == id }) { equipes[indice].integrantes = valor }
    }
    func equipe(id: UUID) -> EquipeLab? { equipes.first { $0.id == id } }
    func publicarAviso(_ texto: String) {
        let texto = texto.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty else { return }
        aviso = texto
    }
}
