import SwiftUI

struct LaboratorioView: View {
    @StateObject private var laboratorio = LaboratorioViewModel()
    var body: some View {
        TabView {
            EquipesLabView(laboratorio: laboratorio).tabItem { Label("Equipes", systemImage: "person.3") }
            AvisoLabView(laboratorio: laboratorio).tabItem { Label("Aviso", systemImage: "megaphone") }
        }
    }
}

struct EquipesLabView: View {
    @ObservedObject var laboratorio: LaboratorioViewModel
    var body: some View {
        NavigationStack {
            List {
                Text("Integrantes: \(laboratorio.totalIntegrantes)")
                ForEach(laboratorio.equipes) { equipe in
                    NavigationLink { EquipeLabDetalheView(laboratorio: laboratorio, id: equipe.id) } label: {
                        VStack(alignment: .leading) { Text(equipe.nome); Text(equipe.tema).font(.caption).foregroundStyle(.secondary) }
                    }
                }
                .onDelete { indices in
                    let ids = indices.map { laboratorio.equipes[$0].id }
                    ids.forEach { laboratorio.apagar(id: $0) }
                }
            }.navigationTitle("Equipes")
        }
    }
}

struct EquipeLabDetalheView: View {
    @ObservedObject var laboratorio: LaboratorioViewModel
    let id: UUID
    var body: some View {
        Form {
            if let equipe = laboratorio.equipe(id: id) {
                LabeledContent("Tema", value: equipe.tema)
                Stepper("Integrantes: \(equipe.integrantes)", value: Binding(
                    get: { laboratorio.equipe(id: id)?.integrantes ?? 1 },
                    set: { laboratorio.definirIntegrantes(id: id, valor: $0) }
                ), in: 1...12)
            } else { Text("Equipe removida") }
        }.navigationTitle(laboratorio.equipe(id: id)?.nome ?? "Equipe")
    }
}

struct AvisoLabView: View {
    @ObservedObject var laboratorio: LaboratorioViewModel
    @State private var mostrarSheet = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text(laboratorio.aviso.isEmpty ? "Nenhum aviso" : laboratorio.aviso)
                Button("Novo aviso") { mostrarSheet = true }.buttonStyle(.borderedProminent)
            }.padding().navigationTitle("Aviso")
                .sheet(isPresented: $mostrarSheet) { AvisoLabFormView(laboratorio: laboratorio) }
        }
    }
}

struct AvisoLabFormView: View {
    @ObservedObject var laboratorio: LaboratorioViewModel
    @State private var rascunho = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                TextField("Aviso", text: $rascunho).textFieldStyle(.roundedBorder)
                Button("Publicar") { laboratorio.publicarAviso(rascunho); dismiss() }
                    .buttonStyle(.borderedProminent)
                    .disabled(rascunho.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                Spacer()
            }.padding().navigationTitle("Novo aviso")
        }
    }
}
