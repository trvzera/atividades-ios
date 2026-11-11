import SwiftUI

struct LocalEscola: Identifiable {
    let id = UUID()
    let nome: String
    let horario: String
    let piso: String
}

struct GuiaEscolaView: View {
    private let locais = [
        LocalEscola(nome: "Biblioteca", horario: "7h às 18h", piso: "1º andar"),
        LocalEscola(nome: "Laboratório", horario: "8h às 17h", piso: "2º andar"),
        LocalEscola(nome: "Secretaria", horario: "7h às 16h", piso: "Térreo"),
        LocalEscola(nome: "Quadra", horario: "7h às 19h", piso: "Térreo")
    ]
    var body: some View {
        NavigationStack {
            List {
                ForEach(locais) { local in
                    NavigationLink { LocalDetalheView(local: local) } label: {
                        VStack(alignment: .leading) { Text(local.nome); Text(local.horario).font(.caption).foregroundStyle(.secondary) }
                    }
                }
            }.navigationTitle("Guia")
        }
    }
}

struct LocalDetalheView: View {
    let local: LocalEscola
    var body: some View {
        Form {
            Text("Horário: \(local.horario)")
            Text("Piso: \(local.piso)")
        }.navigationTitle(local.nome)
    }
}
