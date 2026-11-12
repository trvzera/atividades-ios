//
//  FocoViewModel.swift
//  fichaFoco
//
//  Created by COTEMIG on 31/10/26.
//

import SwiftUI
import Combine

// A mesma instância compartilha a ficha entre o painel e os ajustes.
class FocoViewModel: ObservableObject {
    @Published var materia = ""
    @Published var minutosAlvo = 25
    @Published var nivelFoco = 0.5
    @Published var somLigado = false
    @Published var dataProva = Date()

    var formularioValido: Bool {
        !materia.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && nivelFoco > 0
    }

    var valoresIniciais: Bool {
        materia.isEmpty && minutosAlvo == 25 && nivelFoco == 0.5 && !somLigado
    }

    func reiniciar() {
        materia = ""
        minutosAlvo = 25
        nivelFoco = 0.5
        somLigado = false
        dataProva = Date()
    }
}
