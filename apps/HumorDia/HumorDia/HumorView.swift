import SwiftUI

struct HumorView: View {
    @State private var humor = "Neutro"
    @State private var observacao = ""
    @State private var apoio = "Como foi o dia?"
    @State private var aviso = ""
    @State private var corBorda = Color.gray
    @State private var registro = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Picker("Humor", selection: $humor) {
                Text("Feliz").tag("Feliz")
                Text("Triste").tag("Triste")
                Text("Neutro").tag("Neutro")
                Text("Animado").tag("Animado")
            }
            .pickerStyle(.segmented)
            .onChange(of: humor) { _, novo in
                if novo == "Triste" { apoio = "Quer conversar sobre isso?" }
                else if novo == "Feliz" { apoio = "Que bom! Conte mais..." }
                else if novo == "Animado" { apoio = "O que te animou?" }
                else { apoio = "Como foi o dia?" }
            }
            TextField(apoio, text: $observacao, axis: .vertical)
                .accessibilityIdentifier("observacao")
                .textFieldStyle(.roundedBorder)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(corBorda))
                .onChange(of: observacao) { _, novo in
                    let texto = novo.trimmingCharacters(in: .whitespacesAndNewlines)
                    if texto.isEmpty { aviso = ""; corBorda = .gray }
                    else if texto.count < 8 { aviso = "Escreva um pouco mais (mínimo de 8 caracteres)."; corBorda = .red }
                    else { aviso = ""; corBorda = .green }
                }
            if !aviso.isEmpty { Text(aviso).foregroundStyle(.red) }
            Button("Guardar") { registro = "\(humor): \(observacao.trimmingCharacters(in: .whitespacesAndNewlines))" }
                .buttonStyle(.borderedProminent)
                .disabled(observacao.trimmingCharacters(in: .whitespacesAndNewlines).count < 8)
            if !registro.isEmpty { Text("Guardado: \(registro)").foregroundStyle(.secondary) }
            Spacer()
        }
        .padding()
        .navigationTitle("Humor")
    }
}
