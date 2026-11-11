import SwiftUI

struct AlunoChamada: Identifiable {
    let id = UUID()
    var nome: String
    var presente = false
}

struct ChamadaView: View {
    @State private var alunos = [AlunoChamada(nome: "Ana", presente: true), AlunoChamada(nome: "Bruno"), AlunoChamada(nome: "Caio", presente: true), AlunoChamada(nome: "Duda")]
    @State private var nomeNovo = ""
    @State private var filtro = "Todos"
    var visiveis: [AlunoChamada] {
        if filtro == "Presentes" { return alunos.filter(\.presente) }
        if filtro == "Ausentes" { return alunos.filter { !$0.presente } }
        return alunos
    }
    var body: some View {
        VStack {
            Picker("Filtro", selection: $filtro) {
                Text("Todos").tag("Todos"); Text("Presentes").tag("Presentes"); Text("Ausentes").tag("Ausentes")
            }.pickerStyle(.segmented).padding(.horizontal)
            HStack {
                TextField("Novo aluno", text: $nomeNovo).textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.words).onSubmit { adicionar() }
                Button { adicionar() } label: { Image(systemName: "plus") }
                    .accessibilityLabel("Adicionar aluno")
                    .disabled(nomeNovo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }.padding(.horizontal)
            List {
                ForEach(visiveis) { aluno in
                    Button {
                        if let indice = alunos.firstIndex(where: { $0.id == aluno.id }) { alunos[indice].presente.toggle() }
                    } label: {
                        HStack {
                            Text(aluno.nome).foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: aluno.presente ? "checkmark.circle.fill" : "circle")
                        }
                    }.accessibilityValue(aluno.presente ? "Presente" : "Ausente")
                }
                .onDelete { indices in
                    let ids = indices.map { visiveis[$0].id }
                    alunos.removeAll { ids.contains($0.id) }
                }
            }
            Text("\(alunos.filter(\.presente).count) de \(alunos.count) presentes").padding()
        }
        .navigationTitle("Chamada")
    }
    private func adicionar() {
        let nome = nomeNovo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !nome.isEmpty else { return }
        alunos.append(AlunoChamada(nome: nome)); nomeNovo = ""
    }
}
