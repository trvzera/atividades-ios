import SwiftUI

struct AgendaProvasView: View {
    @StateObject private var agenda = AgendaProvasViewModel()
    @State private var mostrarNova = false
    var body: some View {
        NavigationStack {
            List {
                Section("Resumo") {
                    Text("Total: \(agenda.provas.count)")
                    Text("Pendentes: \(agenda.pendentes)")
                    Toggle("Só as pendentes", isOn: $agenda.soPendentes)
                }
                Section("Provas") {
                    ForEach(agenda.visiveis) { prova in
                        NavigationLink { ProvaDetalheView(agenda: agenda, id: prova.id) } label: {
                            VStack(alignment: .leading) {
                                Text(prova.materia)
                                Text("\(prova.sala) · \(prova.revisada ? "Revisada" : "Pendente")").font(.caption).foregroundStyle(.secondary)
                                Text(prova.dia, format: .dateTime.day().month(.wide)).font(.caption)
                            }
                        }
                    }
                    .onDelete { indices in
                        let ids = indices.map { agenda.visiveis[$0].id }
                        ids.forEach { agenda.apagar(id: $0) }
                    }
                }
            }.navigationTitle("Provas")
                .toolbar { Button { mostrarNova = true } label: { Image(systemName: "plus") }.accessibilityLabel("Nova prova") }
                .sheet(isPresented: $mostrarNova) { NovaProvaView(agenda: agenda) }
        }
    }
}

struct ProvaDetalheView: View {
    @ObservedObject var agenda: AgendaProvasViewModel
    let id: UUID
    @Environment(\.dismiss) private var dismiss
    @State private var mostrarAlerta = false
    var body: some View {
        Form {
            if let prova = agenda.prova(id: id) {
                LabeledContent("Sala", value: prova.sala)
                LabeledContent("Dia") { Text(prova.dia, format: .dateTime.day().month(.wide).year()) }
                Toggle("Revisada", isOn: Binding(
                    get: { agenda.prova(id: id)?.revisada ?? false },
                    set: { agenda.definirRevisada(id: id, revisada: $0) }
                ))
                Button("Apagar", role: .destructive) { mostrarAlerta = true }
            } else { Text("Prova removida") }
        }
        .navigationTitle(agenda.prova(id: id)?.materia ?? "Prova")
        .alert("Apagar esta prova?", isPresented: $mostrarAlerta) {
            Button("Apagar", role: .destructive) { agenda.apagar(id: id); dismiss() }
            Button("Cancelar", role: .cancel) { }
        }
    }
}

struct NovaProvaView: View {
    @ObservedObject var agenda: AgendaProvasViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var materia = ""
    @State private var sala = ""
    @State private var dia = Date()
    private var podeSalvar: Bool {
        !materia.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !sala.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var body: some View {
        NavigationStack {
            Form {
                TextField("Matéria", text: $materia).textInputAutocapitalization(.words)
                TextField("Sala", text: $sala)
                DatePicker("Dia", selection: $dia, displayedComponents: .date)
            }.navigationTitle("Nova prova")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Salvar") { agenda.adicionar(materia: materia, sala: sala, dia: dia); dismiss() }.disabled(!podeSalvar)
                    }
                }
        }
    }
}
