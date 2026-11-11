"""Testa regras dos ViewModels com o compilador Swift do Xcode instalado."""
from pathlib import Path
import os, subprocess, tempfile

ROOT = Path(__file__).resolve().parents[1]
files = [
    'apps/TrilhaFoco/fichaFoco/FocoViewModel.swift',
    'apps/Estante/Estante/Livro.swift', 'apps/Estante/Estante/EstanteViewModel.swift',
    'apps/Laboratorio/Laboratorio/EquipeLab.swift', 'apps/Laboratorio/Laboratorio/LaboratorioViewModel.swift',
    'apps/AgendaProvas/AgendaProvas/ItemProva.swift', 'apps/AgendaProvas/AgendaProvas/AgendaProvasViewModel.swift',
]
main = r'''
import Foundation
var verificacoes = 0
func conferir(_ condicao: @autoclosure () -> Bool, _ mensagem: String) {
    guard condicao() else { fatalError(mensagem) }
    verificacoes += 1
}

let foco = FocoViewModel()
conferir(!foco.formularioValido, "Ficha vazia não pode salvar")
foco.materia = " \n "
conferir(!foco.formularioValido, "Espaços não são matéria")
foco.materia = "iOS"; foco.nivelFoco = 0
conferir(!foco.formularioValido, "Foco zero é inválido")
foco.nivelFoco = 0.1
conferir(foco.formularioValido, "Matéria e foco positivo são válidos")
foco.minutosAlvo = 60; foco.somLigado = true; foco.dataProva = .distantFuture
foco.reiniciar()
conferir(foco.materia.isEmpty && foco.minutosAlvo == 25 && foco.nivelFoco == 0.5 && !foco.somLigado, "Reiniciar restaura quatro valores")
conferir(Calendar.current.isDateInToday(foco.dataProva), "Reiniciar restaura a data de hoje")

let estante = EstanteViewModel()
conferir(estante.livros.count >= 4, "Quatro livros de exemplo")
let livro = estante.livros[1]
let soma = estante.paginasLidas
estante.definirLido(id: livro.id, lido: true)
conferir(estante.livro(id: livro.id)?.lido == true && estante.paginasLidas == soma + livro.paginas, "Mudar detalhe atualiza resumo")
estante.definirLido(id: UUID(), lido: true)
conferir(estante.livros.count == 4, "Id desconhecido não cria item")
estante.adicionar(titulo: "  ", autor: "Autor", paginas: 100)
conferir(estante.livros.count == 4, "Livro sem título é rejeitado")
estante.adicionar(titulo: "Novo", autor: " ", paginas: 100)
conferir(estante.livros.count == 4, "Livro sem autor é rejeitado")
estante.adicionar(titulo: "Novo", autor: "Autor", paginas: 0)
conferir(estante.livros.count == 4, "Zero páginas é inválido")
estante.adicionar(titulo: " Novo ", autor: " Autor ", paginas: 2000)
conferir(estante.livros.last?.titulo == "Novo" && estante.livros.last?.lido == false, "Inclusão limpa texto e começa não lido")
estante.apagar(id: livro.id)
conferir(estante.livro(id: livro.id) == nil && estante.livros.count == 4, "Exclusão usa id")
for id in estante.livros.map(\.id) { estante.apagar(id: id) }
conferir(estante.lidos == 0 && estante.paginasLidas == 0, "Resumo de estante vazia")

let lab = LaboratorioViewModel()
let equipe = lab.equipes[2]; let total = lab.totalIntegrantes
lab.definirIntegrantes(id: equipe.id, valor: 12)
conferir(lab.totalIntegrantes == total - equipe.integrantes + 12, "Stepper atualiza equipe correta e total")
lab.definirIntegrantes(id: equipe.id, valor: 13)
conferir(lab.equipe(id: equipe.id)?.integrantes == 12, "Limite superior de integrantes")
lab.definirIntegrantes(id: equipe.id, valor: 0)
conferir(lab.equipe(id: equipe.id)?.integrantes == 12, "Limite inferior de integrantes")
lab.publicarAviso("  Levar material  ")
conferir(lab.aviso == "Levar material", "Publicação limpa espaços")
lab.publicarAviso(" \n ")
conferir(lab.aviso == "Levar material", "Aviso vazio não substitui aviso publicado")
lab.apagar(id: equipe.id)
conferir(lab.equipe(id: equipe.id) == nil, "Exclusão de equipe por id")

let agenda = AgendaProvasViewModel()
conferir(agenda.provas.count >= 4 && !agenda.soPendentes, "Agenda começa com quatro provas e filtro desligado")
agenda.soPendentes = true
conferir(agenda.visiveis.allSatisfy { !$0.revisada }, "Filtro exclui revisadas")
let visiveis = agenda.visiveis
conferir(zip(visiveis, visiveis.dropFirst()).allSatisfy { $0.dia <= $1.dia }, "Agenda ordenada por data")
let revisada = agenda.provas.first { $0.revisada }!
let apagar = agenda.visiveis[1].id
agenda.apagar(id: apagar)
conferir(agenda.prova(id: apagar) == nil && agenda.prova(id: revisada.id) != nil, "Exclusão filtrada preserva item oculto")
let pendentes = agenda.pendentes
let revisar = agenda.visiveis[0].id
agenda.definirRevisada(id: revisar, revisada: true)
conferir(agenda.pendentes == pendentes - 1 && !agenda.visiveis.contains { $0.id == revisar }, "Revisar atualiza filtro e total")
let quantidade = agenda.provas.count
agenda.adicionar(materia: " ", sala: "Sala", dia: Date())
conferir(agenda.provas.count == quantidade, "Prova vazia não entra")
agenda.adicionar(materia: " Química ", sala: " Sala 9 ", dia: .distantPast)
conferir(agenda.visiveis.first?.materia == "Química" && agenda.visiveis.first?.sala == "Sala 9", "Prova nova é limpa e ordenada")
conferir(agenda.visiveis.first?.revisada == false, "Prova nova começa pendente")
for id in agenda.provas.map(\.id) { agenda.apagar(id: id) }
conferir(agenda.pendentes == 0 && agenda.visiveis.isEmpty, "Agenda vazia")
print("\(verificacoes) verificações de regras aprovadas.")
'''
env = dict(os.environ, DEVELOPER_DIR='/Applications/Xcode.app/Contents/Developer')
with tempfile.TemporaryDirectory(prefix='ios-modelos-') as temp:
    folder = Path(temp)
    (folder/'main.swift').write_text(main)
    subprocess.run(['xcrun','swiftc',*[str(ROOT/f) for f in files],str(folder/'main.swift'),'-o',str(folder/'testes')],check=True,env=env)
    subprocess.run([str(folder/'testes')],check=True,env=env)
