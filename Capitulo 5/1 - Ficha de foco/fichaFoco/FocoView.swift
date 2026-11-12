import SwiftUI

struct FocoView: View {
    @StateObject private var foco = FocoViewModel()
    @State private var mostrarAjustes = false
    @State private var mostrarAlerta = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text(foco.materia.isEmpty ? "Sem matéria" : foco.materia)
                    .font(.largeTitle.bold())
                Text("\(foco.minutosAlvo) minutos")
                    .font(.title2).foregroundStyle(.secondary)
                PainelFocoView(foco: foco)
                HStack {
                    Button("Reiniciar") { foco.reiniciar() }
                        .buttonStyle(.bordered)
                        .disabled(foco.valoresIniciais)
                    Spacer()
                    Button("Ajustes") { mostrarAjustes = true }
                        .buttonStyle(.borderedProminent)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Foco")
            .sheet(isPresented: $mostrarAjustes) {
                AjustesFocoView(foco: foco, mostrarAlerta: $mostrarAlerta)
            }
            .alert("Pronto", isPresented: $mostrarAlerta) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Sessão de \(foco.materia) pronta: \(foco.minutosAlvo) min.")
            }
        }
    }
}

// A view filha observa a mesma instância criada na tela principal.
struct PainelFocoView: View {
    @ObservedObject var foco: FocoViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Nível de foco: \(Int(foco.nivelFoco * 100))%")
            Slider(value: $foco.nivelFoco, in: 0...1)
                .disabled(foco.materia.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}
