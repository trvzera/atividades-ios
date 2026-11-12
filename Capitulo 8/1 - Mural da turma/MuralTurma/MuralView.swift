import SwiftUI

struct MuralView: View {
    @State private var nomeUsuario = "Aluno"
    @State private var modoEscuro = false
    var body: some View {
        TabView {
            TurmaView(nomeUsuario: nomeUsuario).tabItem { Label("Turma", systemImage: "person.2") }
            RecadoView().tabItem { Label("Recado", systemImage: "text.bubble") }
            AjustesView(nomeUsuario: $nomeUsuario, modoEscuro: $modoEscuro).tabItem { Label("Ajustes", systemImage: "gearshape") }
        }.preferredColorScheme(modoEscuro ? .dark : .light)
    }
}

struct Colega: Identifiable {
    let id = UUID()
    let nome: String
    let interesse: String
}

struct TurmaView: View {
    let nomeUsuario: String
    private let colegas = [Colega(nome: "Ana", interesse: "basquete"), Colega(nome: "Bruno", interesse: "programação"), Colega(nome: "Caio", interesse: "música"), Colega(nome: "Duda", interesse: "cinema")]
    var body: some View {
        NavigationStack {
            List {
                Text("Olá, \(nomeUsuario)")
                ForEach(colegas) { colega in
                    NavigationLink { ColegaDetalheView(colega: colega) } label: {
                        HStack { Text(colega.nome); Spacer(); Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary) }
                    }
                }
            }.navigationTitle("Turma")
        }
    }
}

struct ColegaDetalheView: View {
    let colega: Colega
    var body: some View {
        Form { Text("Interesse: \(colega.interesse)") }.navigationTitle(colega.nome)
    }
}

struct RecadoView: View {
    @State private var recadoPublicado = ""
    @State private var mostrarSheet = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text(recadoPublicado.isEmpty ? "Nenhum recado" : recadoPublicado)
                Button("Novo recado") { mostrarSheet = true }.buttonStyle(.borderedProminent)
            }.padding().navigationTitle("Recado")
                .sheet(isPresented: $mostrarSheet) { RecadoFormView(recadoPublicado: $recadoPublicado) }
        }
    }
}

struct RecadoFormView: View {
    @Binding var recadoPublicado: String
    @State private var rascunho = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                TextField("Recado", text: $rascunho).textFieldStyle(.roundedBorder)
                Button("Publicar") {
                    recadoPublicado = rascunho.trimmingCharacters(in: .whitespacesAndNewlines)
                    dismiss()
                }.buttonStyle(.borderedProminent)
                    .disabled(rascunho.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                Spacer()
            }.padding().navigationTitle("Novo recado")
        }
    }
}

struct AjustesView: View {
    @Binding var nomeUsuario: String
    @Binding var modoEscuro: Bool
    @State private var mostrarAlerta = false
    @State private var sessao = ""
    var body: some View {
        NavigationStack {
            Form {
                Toggle("Modo escuro", isOn: $modoEscuro)
                TextField("Nome", text: $nomeUsuario).textInputAutocapitalization(.words)
                Button("Sair", role: .destructive) { mostrarAlerta = true }
                if !sessao.isEmpty { Text(sessao) }
            }
            .navigationTitle("Ajustes")
            .alert("Deseja sair do mural?", isPresented: $mostrarAlerta) {
                Button("Sair", role: .destructive) { sessao = "Sessão encerrada" }
                Button("Cancelar", role: .cancel) { }
            }
        }
    }
}
