> **EN:** SwiftUI practice project: Ficha de foco. Open `fichaFoco.xcodeproj` in Xcode and run on an iOS simulator.
>
> O restante deste documento está em português brasileiro.

# Ficha de foco

Atividade de Desenvolvimento iOS — Capítulo 5, exercício 1.

Ficha compartilhada entre tela principal, painel e ajustes com `ObservableObject`, `@StateObject`, `@ObservedObject`, validação e alerta ao salvar.

## Executar

1. Abra `fichaFoco.xcodeproj` no Xcode.
2. Selecione o scheme `fichaFoco` e um simulador de iPhone.
3. Execute com **⌘R**.

Requer iOS 17 ou superior e Xcode com o SDK correspondente. Não há dependências externas. Para um iPhone físico, selecione seu time de assinatura no Xcode.

## Organização e estudo

O código está em [`fichaFoco/`](./fichaFoco/). O [enunciado](./ENUNCIADO.md) e as imagens de referência do professor estão incluídos para comparação.

Os dados ficam em memória durante a execução, conforme o escopo do exercício. Fechar e reabrir o app restaura os exemplos.

[Repositório geral com todas as atividades](https://github.com/trvzera/atividades-ios).

## Tela

<img src="./preview.png" alt="Tela da atividade" width="320">

## Validação

Projeto compilado separadamente para o simulador no Xcode 27.2. O projeto geral compila os mesmos arquivos Swift e reúne os testes de interface. [Resultados e cobertura](https://github.com/trvzera/atividades-ios/blob/main/VALIDACAO.md).
