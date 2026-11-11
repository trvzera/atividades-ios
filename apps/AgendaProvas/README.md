> **EN:** SwiftUI practice project: Agenda de provas. Open `AgendaProvas.xcodeproj` in Xcode and run on an iOS simulator.
>
> O restante deste documento está em português brasileiro.

# Agenda de provas

Atividade de Desenvolvimento iOS — Revisão, exercício 3.

Provas ordenadas por data, filtro de pendentes, inclusão, revisão e exclusão por ID com confirmação.

## Executar

1. Abra `AgendaProvas.xcodeproj` no Xcode.
2. Selecione o scheme `AgendaProvas` e um simulador de iPhone.
3. Execute com **⌘R**.

Requer iOS 17 ou superior e Xcode com o SDK correspondente. Não há dependências externas. Para um iPhone físico, selecione seu time de assinatura no Xcode.

## Organização e estudo

O código está em [`AgendaProvas/`](./AgendaProvas/). O [enunciado](./ENUNCIADO.md) e as imagens de referência do professor estão incluídos para comparação.

Os dados ficam em memória durante a execução, conforme o escopo do exercício. Fechar e reabrir o app restaura os exemplos.

[Repositório geral com todas as atividades](https://github.com/trvzera/atividades-ios).

## Tela

<img src="./preview.png" alt="Tela da atividade" width="320">

## Validação

Projeto compilado separadamente para o simulador no Xcode 27.2. O projeto geral compila os mesmos arquivos Swift e reúne os testes de interface. [Resultados e cobertura](https://github.com/trvzera/atividades-ios/blob/main/VALIDACAO.md).
