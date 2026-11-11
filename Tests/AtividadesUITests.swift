import XCTest

@MainActor
final class AtividadesUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    private func abrir(_ nome: String) {
        app.launchArguments = ["--exercise", nome, "-AppleLanguages", "(pt-BR)", "-AppleLocale", "pt_BR"]
        app.launch()
    }

    private func digitar(_ campo: String, _ texto: String) {
        let field = app.textFields[campo]
        XCTAssertTrue(field.waitForExistence(timeout: 5), "Campo ausente: \(campo)")
        field.tap()
        field.typeText(texto)
    }

    private func alternar(_ nome: String) {
        let controle = app.switches[nome]
        XCTAssertTrue(controle.waitForExistence(timeout: 5))
        controle.coordinate(withNormalizedOffset: CGVector(dx: 0.92, dy: 0.5)).tap()
    }

    func testMenuGeralAbreAtividadeEVolta() {
        app.launchArguments = ["-AppleLanguages", "(pt-BR)", "-AppleLocale", "pt_BR"]
        app.launch()
        app.buttons["Mixer de cor"].tap()
        XCTAssertTrue(app.buttons["Zerar"].waitForExistence(timeout: 5))
        app.buttons["Voltar às atividades"].tap()
        XCTAssertTrue(app.buttons["Ficha de foco"].waitForExistence(timeout: 5))
    }

    func testFocoValidaCompartilhaEExibeAlertaDepoisDaSheet() {
        abrir("TrilhaFoco")
        XCTAssertFalse(app.buttons["Reiniciar"].isEnabled)
        XCTAssertFalse(app.sliders.firstMatch.isEnabled)
        app.buttons["Ajustes"].tap()
        XCTAssertFalse(app.buttons["Salvar"].isEnabled)
        digitar("Matéria", "Matematica")
        app.buttons["Salvar"].tap()
        XCTAssertTrue(app.alerts["Pronto"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.alerts.staticTexts["Sessão de Matematica pronta: 25 min."].exists)
        app.alerts.buttons["OK"].tap()
        XCTAssertTrue(app.sliders.firstMatch.isEnabled)
        app.sliders.firstMatch.adjust(toNormalizedSliderPosition: 0)
        app.buttons["Ajustes"].tap()
        XCTAssertFalse(app.buttons["Salvar"].isEnabled)
    }

    func testMixerTravaTodosOsControlesEZera() {
        abrir("MixerCor")
        XCTAssertEqual(app.sliders.count, 3)
        alternar("Travar sliders")
        XCTAssertFalse(app.buttons["Zerar"].isEnabled)
        for slider in app.sliders.allElementsBoundByIndex { XCTAssertFalse(slider.isEnabled) }
        alternar("Travar sliders")
        app.buttons["Zerar"].tap()
        for slider in app.sliders.allElementsBoundByIndex {
            XCTAssertTrue((slider.value as? String ?? "").contains("0"))
        }
    }

    func testReservaRejeitaEspacosEConfirma() {
        abrir("ReservaSala")
        XCTAssertFalse(app.buttons["Reservar"].isEnabled)
        digitar("Nome", "   ")
        XCTAssertFalse(app.buttons["Reservar"].isEnabled)
        app.textFields["Nome"].typeText("Ana")
        app.buttons["Reservar"].tap()
        XCTAssertTrue(app.alerts["Reserva feita"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.alerts.staticTexts["Laboratório reservada para Ana, 10 pessoas."].exists)
    }

    func testCartazValidaPublicaEContaFechamento() {
        abrir("CartazTurma")
        XCTAssertFalse(app.buttons["Publicar"].isEnabled)
        digitar("Seu nome", "Ana2 Silva")
        digitar("Recado", "Ola turma!")
        XCTAssertFalse(app.buttons["Publicar"].isEnabled)
        let nome = app.textFields["Seu nome"]
        nome.tap()
        nome.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 10) + "Ana Silva")
        app.buttons["Publicar"].tap()
        XCTAssertTrue(app.staticTexts["Publicações: 1"].waitForExistence(timeout: 5))
        app.buttons["Fechar"].tap()
        XCTAssertTrue(app.staticTexts["Fechamentos: 1"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Publicar"].isEnabled)
    }

    func testHumorMudaPlaceholderEValidaTexto() {
        abrir("HumorDia")
        XCTAssertFalse(app.buttons["Guardar"].isEnabled)
        app.segmentedControls.buttons["Triste"].tap()
        let campo = app.descendants(matching: .any)["observacao"].firstMatch
        XCTAssertTrue(campo.exists)
        campo.tap(); campo.typeText("Curto")
        XCTAssertFalse(app.buttons["Guardar"].isEnabled)
        campo.typeText(" mas suficiente")
        app.buttons["Guardar"].tap()
        XCTAssertTrue(app.staticTexts["Guardado: Triste: Curto mas suficiente"].exists)
    }

    func testPecasRegistraAbertura() {
        abrir("PecasSoltas")
        XCTAssertTrue(app.staticTexts["Aberturas: 1"].exists)
        let peca = app.otherElements["Peça de giro"]
        if peca.exists { peca.press(forDuration: 1) }
        XCTAssertTrue(app.staticTexts["Aberturas: 1"].exists)
    }

    func testFilmeValidaAnoEFiltroMantemResumoCompleto() {
        abrir("ColecaoFilmes")
        app.buttons["Novo filme"].tap()
        XCTAssertFalse(app.buttons["Salvar"].isEnabled)
        digitar("Título", "Filme de teste")
        digitar("Ano", "9999")
        XCTAssertFalse(app.buttons["Salvar"].isEnabled)
        app.textFields["Ano"].tap()
        app.textFields["Ano"].typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 4) + "2020")
        app.buttons["Salvar"].tap()
        XCTAssertTrue(app.staticTexts["Total: 6"].waitForExistence(timeout: 5))
        app.buttons["Filtros"].tap()
        app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Situação,")).firstMatch.tap()
        app.buttons["Assistidos"].tap()
        app.buttons["Fechar"].tap()
        XCTAssertTrue(app.staticTexts["Total: 6"].exists)
        XCTAssertFalse(app.staticTexts["Filme de teste"].exists)
        app.swipeUp()
        let apagar = app.buttons["Apagar De Volta para o Futuro"]
        XCTAssertTrue(apagar.waitForExistence(timeout: 5))
        apagar.tap()
        app.swipeDown()
        XCTAssertTrue(app.staticTexts["Total: 5"].exists)
    }

    func testChamadaApagaPeloIdComFiltroAtivo() {
        abrir("Chamada")
        XCTAssertTrue(app.staticTexts["2 de 4 presentes"].exists)
        app.segmentedControls.buttons["Ausentes"].tap()
        let cell = app.cells.containing(.staticText, identifier: "Bruno").firstMatch
        cell.swipeLeft()
        let apagar = app.buttons.matching(NSPredicate(format: "label == 'Apagar' OR label == 'Delete' OR label == 'Excluir'")).firstMatch
        XCTAssertTrue(apagar.waitForExistence(timeout: 5)); apagar.tap()
        XCTAssertTrue(app.staticTexts["2 de 3 presentes"].waitForExistence(timeout: 5))
        app.segmentedControls.buttons["Todos"].tap()
        XCTAssertTrue(app.staticTexts["Ana"].exists)
        XCTAssertFalse(app.staticTexts["Bruno"].exists)
        digitar("Novo aluno", "Eva")
        app.buttons["Adicionar aluno"].tap()
        XCTAssertTrue(app.staticTexts["2 de 4 presentes"].exists)
    }

    func testRankingUsaTotalCompletoEExcluiExatamente50() {
        abrir("Ranking")
        alternar("Só quem passou de 50")
        XCTAssertFalse(app.staticTexts["Caio"].exists)
        XCTAssertTrue(app.staticTexts["Total de pontos: 250"].exists)
        XCTAssertTrue(app.staticTexts["Turma: Ana, Bruno, Caio, Duda"].exists)
        app.buttons["Somar 10 a Ana"].tap()
        XCTAssertTrue(app.staticTexts["Total de pontos: 260"].exists)
    }

    func testMuralCompartilhaNomePublicaRecadoEEncerraSessao() {
        abrir("MuralTurma")
        app.tabBars.buttons["Ajustes"].tap()
        let nome = app.textFields["Nome"]
        nome.tap(); nome.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 5) + "Giovanni\n")
        app.tabBars.buttons["Turma"].tap()
        XCTAssertTrue(app.staticTexts["Olá, Giovanni"].exists)
        app.cells.containing(.staticText, identifier: "Ana").firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Interesse: basquete"].exists)
        app.tabBars.buttons["Recado"].tap()
        app.buttons["Novo recado"].tap()
        XCTAssertFalse(app.buttons["Publicar"].isEnabled)
        digitar("Recado", "Revisao amanha")
        app.buttons["Publicar"].tap()
        XCTAssertTrue(app.staticTexts["Revisao amanha"].waitForExistence(timeout: 5))
        app.tabBars.buttons["Ajustes"].tap()
        app.buttons["Sair"].tap()
        app.alerts.buttons["Cancelar"].tap()
        XCTAssertFalse(app.staticTexts["Sessão encerrada"].exists)
        app.buttons["Sair"].tap()
        app.alerts.buttons["Sair"].tap()
        XCTAssertTrue(app.staticTexts["Sessão encerrada"].exists)
    }

    func testGuiaAbreDetalheDoLocal() {
        abrir("GuiaEscola")
        app.cells.containing(.staticText, identifier: "Biblioteca").firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Piso: 1º andar"].exists)
        XCTAssertTrue(app.staticTexts["Horário: 7h às 18h"].exists)
    }

    func testCantinaExigeLancheEIncluiObservacao() {
        abrir("Cantina")
        app.tabBars.buttons["Pedido"].tap()
        app.buttons["Novo pedido"].tap()
        XCTAssertFalse(app.buttons["Confirmar"].isEnabled)
        app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Lanche,")).firstMatch.tap()
        app.buttons["Pão de queijo"].tap()
        digitar("Observação", "Sem sal")
        app.buttons["Confirmar"].tap()
        XCTAssertTrue(app.staticTexts["Pão de queijo — Sem sal"].waitForExistence(timeout: 5))
    }

    func testEstanteAtualizaResumoDaMesmaClasseECancelaRascunho() {
        abrir("Estante")
        app.cells.containing(.staticText, identifier: "Dom Casmurro").firstMatch.tap()
        alternar("Lido")
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Lidos: 3"].exists)
        XCTAssertTrue(app.staticTexts["Páginas lidas: 440"].exists)
        app.buttons["Novo livro"].tap()
        XCTAssertFalse(app.buttons["Salvar"].isEnabled)
        digitar("Título", "Rascunho")
        app.buttons["Cancelar"].tap()
        XCTAssertTrue(app.staticTexts["Livros: 4"].exists)
        XCTAssertFalse(app.staticTexts["Rascunho"].exists)
    }

    func testLaboratorioAtualizaIntegrantesEPublicaAviso() {
        abrir("Laboratorio")
        app.cells.containing(.staticText, identifier: "Órbita").firstMatch.tap()
        app.steppers.buttons.element(boundBy: 1).tap()
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Integrantes: 17"].exists)
        app.tabBars.buttons["Aviso"].tap()
        app.buttons["Novo aviso"].tap()
        XCTAssertFalse(app.buttons["Publicar"].isEnabled)
        digitar("Aviso", "Levar material")
        app.buttons["Publicar"].tap()
        XCTAssertTrue(app.staticTexts["Levar material"].waitForExistence(timeout: 5))
    }

    func testAgendaCancelaEConfirmaExclusaoComFiltro() {
        abrir("AgendaProvas")
        alternar("Só as pendentes")
        XCTAssertFalse(app.staticTexts["Português"].exists)
        app.cells.containing(.staticText, identifier: "História").firstMatch.tap()
        app.buttons["Apagar"].tap()
        app.alerts.buttons["Cancelar"].tap()
        XCTAssertTrue(app.switches["Revisada"].exists)
        app.buttons["Apagar"].tap()
        app.alerts.buttons["Apagar"].tap()
        XCTAssertTrue(app.staticTexts["Total: 3"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Pendentes: 2"].exists)
        alternar("Só as pendentes")
        XCTAssertTrue(app.staticTexts["Português"].exists)
        XCTAssertFalse(app.staticTexts["História"].exists)
        app.buttons["Nova prova"].tap()
        XCTAssertFalse(app.buttons["Salvar"].isEnabled)
        digitar("Matéria", "Geografia")
        digitar("Sala", "Sala 9")
        app.buttons["Salvar"].tap()
        XCTAssertTrue(app.staticTexts["Total: 4"].waitForExistence(timeout: 5))
    }
}
