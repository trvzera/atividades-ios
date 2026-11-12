import SwiftUI

struct CartazView: View {
    @State private var nome = ""
    @State private var recado = ""
    @State private var mensagemNome = ""
    @State private var mensagemRecado = ""
    @State private var publicado = false
    @State private var publicacoes = 0
    @State private var fechamentos = 0

    private var nomeValido: Bool {
        nome.split(whereSeparator: { $0.isWhitespace }).count >= 2 && !nome.contains(where: { $0.isNumber })
    }
    private var recadoValido: Bool { (5...80).contains(recado.trimmingCharacters(in: .whitespacesAndNewlines).count) }
    private var corNome: Color { nome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : (nomeValido ? .green : .red) }
    private var corRecado: Color { recado.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : (recadoValido ? .green : .red) }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    Text("Publicações: \(publicacoes)")
                    Spacer()
                    Text("Fechamentos: \(fechamentos)")
                }.font(.subheadline)
                SeloView().padding(.vertical, 20)
                if publicado {
                    VStack(spacing: 20) {
                        FigurinhaView()
                        Text(nome).font(.title2.bold())
                        Text(recado)
                        Button("Fechar") { publicado = false }.buttonStyle(.bordered)
                    }
                    .frame(maxWidth: .infinity).padding(24)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 20))
                    .onAppear { publicacoes += 1 }
                    .onDisappear { fechamentos += 1 }
                } else {
                    TextField("Seu nome", text: $nome)
                        .textInputAutocapitalization(.words)
                        .textFieldStyle(.roundedBorder)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(corNome))
                        .onChange(of: nome) { _, novo in
                            mensagemNome = novo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || nomeValido ? "" : "Use nome e sobrenome, sem números."
                        }
                    TextField("Recado", text: $recado)
                        .textFieldStyle(.roundedBorder)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(corRecado))
                        .onChange(of: recado) { _, novo in
                            let texto = novo.trimmingCharacters(in: .whitespacesAndNewlines)
                            if texto.isEmpty { mensagemRecado = "" }
                            else if texto.count < 5 { mensagemRecado = "Recado curto demais." }
                            else if texto.count > 80 { mensagemRecado = "Recado longo demais." }
                            else { mensagemRecado = "" }
                        }
                    if nomeValido && recadoValido {
                        Text("Pronto para publicar.").foregroundStyle(.green)
                    } else if !mensagemNome.isEmpty {
                        Text(mensagemNome).foregroundStyle(.red)
                    } else if !mensagemRecado.isEmpty {
                        Text(mensagemRecado).foregroundStyle(.red)
                    }
                    Button("Publicar") { publicado = true }
                        .buttonStyle(.borderedProminent)
                        .disabled(!nomeValido || !recadoValido)
                }
            }.padding(24)
        }
        .navigationTitle("Cartaz")
    }
}
