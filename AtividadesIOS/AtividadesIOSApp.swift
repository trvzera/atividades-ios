import SwiftUI

@main
struct AtividadesIOSApp: App {
    var body: some Scene {
        WindowGroup {
            if let indice = ProcessInfo.processInfo.arguments.firstIndex(of: "--exercise"),
               ProcessInfo.processInfo.arguments.indices.contains(indice + 1) {
                ExercicioView(nome: ProcessInfo.processInfo.arguments[indice + 1])
            } else { MenuAtividadesView() }
        }
    }
}

struct MenuAtividadesView: View {
    @State private var selecionada: String? = nil
    var body: some View {
        NavigationStack {
            List {
                Section("Capítulo 5") {
                    Button("Ficha de foco") { selecionada = "TrilhaFoco" }
                    Button("Mixer de cor") { selecionada = "MixerCor" }
                    Button("Reserva da sala") { selecionada = "ReservaSala" }
                }
                Section("Capítulo 6") {
                    Button("Cartaz da turma") { selecionada = "CartazTurma" }
                    Button("Humor do dia") { selecionada = "HumorDia" }
                    Button("Peças soltas") { selecionada = "PecasSoltas" }
                }
                Section("Capítulo 7") {
                    Button("Coleção de filmes") { selecionada = "ColecaoFilmes" }
                    Button("Chamada") { selecionada = "Chamada" }
                    Button("Ranking") { selecionada = "Ranking" }
                }
                Section("Capítulo 8") {
                    Button("Mural da turma") { selecionada = "MuralTurma" }
                    Button("Guia da escola") { selecionada = "GuiaEscola" }
                    Button("Cantina") { selecionada = "Cantina" }
                }
                Section("Revisão") {
                    Button("Estante") { selecionada = "Estante" }
                    Button("Laboratório") { selecionada = "Laboratorio" }
                    Button("Agenda de provas") { selecionada = "AgendaProvas" }
                }
            }.navigationTitle("Atividades iOS")
                .fullScreenCover(isPresented: Binding(get: { selecionada != nil }, set: { if !$0 { selecionada = nil } })) {
                    ExercicioView(nome: selecionada ?? "")
                        .safeAreaInset(edge: .top) {
                            HStack {
                                Button("Voltar às atividades", systemImage: "chevron.left") { selecionada = nil }
                                Spacer()
                            }.padding().background(.bar)
                        }
                }
        }
    }
}

struct ExercicioView: View {
    let nome: String
    @ViewBuilder var body: some View {
        switch nome {
        case "TrilhaFoco": FocoView()
        case "MixerCor": NavigationStack { MixerCorView() }
        case "ReservaSala": NavigationStack { ReservaSalaView() }
        case "CartazTurma": NavigationStack { CartazView() }
        case "HumorDia": NavigationStack { HumorView() }
        case "PecasSoltas": NavigationStack { PecasView() }
        case "ColecaoFilmes": ListaFilmesView()
        case "Chamada": NavigationStack { ChamadaView() }
        case "Ranking": NavigationStack { RankingView() }
        case "MuralTurma": MuralView()
        case "GuiaEscola": GuiaEscolaView()
        case "Cantina": CantinaView()
        case "Estante": EstanteView()
        case "Laboratorio": LaboratorioView()
        case "AgendaProvas": AgendaProvasView()
        default: Text("Selecione uma atividade")
        }
    }
}
