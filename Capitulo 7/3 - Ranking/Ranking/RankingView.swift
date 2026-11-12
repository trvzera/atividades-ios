import SwiftUI

struct JogadorRanking: Identifiable {
    let id = UUID()
    var nome: String
    var pontos: Int
}
struct RankingView: View {
    @State private var jogadores = [JogadorRanking(nome: "Ana", pontos: 70), JogadorRanking(nome: "Bruno", pontos: 40), JogadorRanking(nome: "Caio", pontos: 50), JogadorRanking(nome: "Duda", pontos: 90)]
    @State private var soAcimaDe50 = false
    var visiveis: [JogadorRanking] { soAcimaDe50 ? jogadores.filter { $0.pontos > 50 } : jogadores }
    var body: some View {
        List {
            Section("Resumo") {
                Text("Total de pontos: \(jogadores.reduce(0) { $0 + $1.pontos })")
                Text("Turma: \(jogadores.map(\.nome).joined(separator: ", "))")
                Toggle("Só quem passou de 50", isOn: $soAcimaDe50)
            }
            Section("Jogadores") {
                ForEach(visiveis) { jogador in
                    HStack {
                        Text(jogador.nome); Spacer(); Text("\(jogador.pontos)")
                        Button("+10") {
                            if let indice = jogadores.firstIndex(where: { $0.id == jogador.id }) { jogadores[indice].pontos += 10 }
                        }.buttonStyle(.bordered).accessibilityLabel("Somar 10 a \(jogador.nome)")
                    }
                }
            }
        }.navigationTitle("Ranking")
    }
}
