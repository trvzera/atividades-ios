import SwiftUI

struct Lanche: Identifiable {
    let id = UUID()
    let nome: String
    let preco: Double
}

struct CantinaView: View {
    @State private var pedido = ""
    private let lanches = [Lanche(nome: "Pão de queijo", preco: 5), Lanche(nome: "Sanduíche natural", preco: 9), Lanche(nome: "Suco", preco: 6), Lanche(nome: "Bolo", preco: 7)]
    var body: some View {
        TabView {
            CardapioCantinaView(lanches: lanches).tabItem { Label("Cardápio", systemImage: "fork.knife") }
            PedidoCantinaView(pedido: $pedido, lanches: lanches).tabItem { Label("Pedido", systemImage: "bag") }
        }
    }
}

struct CardapioCantinaView: View {
    let lanches: [Lanche]
    var body: some View {
        NavigationStack {
            List {
                ForEach(lanches) { lanche in
                    NavigationLink { LancheDetalheView(lanche: lanche) } label: {
                        HStack { Text(lanche.nome); Spacer(); Text(lanche.preco, format: .currency(code: "BRL")).foregroundStyle(.secondary) }
                    }
                }
            }.navigationTitle("Cardápio")
        }
    }
}

struct LancheDetalheView: View {
    let lanche: Lanche
    var body: some View {
        Form { Text(lanche.preco, format: .currency(code: "BRL")) }.navigationTitle(lanche.nome)
    }
}

struct PedidoCantinaView: View {
    @Binding var pedido: String
    let lanches: [Lanche]
    @State private var mostrarSheet = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text(pedido.isEmpty ? "Nenhum pedido" : pedido)
                Button("Novo pedido") { mostrarSheet = true }.buttonStyle(.borderedProminent)
            }.padding().navigationTitle("Pedido")
                .sheet(isPresented: $mostrarSheet) { PedidoSheetView(pedido: $pedido, lanches: lanches) }
        }
    }
}

struct PedidoSheetView: View {
    @Binding var pedido: String
    let lanches: [Lanche]
    @State private var escolhido: UUID? = nil
    @State private var observacao = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Form {
                Picker("Lanche", selection: $escolhido) {
                    Text("Escolha").tag(UUID?.none)
                    ForEach(lanches) { lanche in Text(lanche.nome).tag(Optional(lanche.id)) }
                }
                TextField("Observação", text: $observacao)
                Button("Confirmar") {
                    guard let lanche = lanches.first(where: { $0.id == escolhido }) else { return }
                    let texto = observacao.trimmingCharacters(in: .whitespacesAndNewlines)
                    pedido = texto.isEmpty ? lanche.nome : "\(lanche.nome) — \(texto)"
                    dismiss()
                }.disabled(escolhido == nil)
            }.navigationTitle("Novo pedido")
        }
    }
}
