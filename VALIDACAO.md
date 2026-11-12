# Validação — organização por capítulos

A entrega contém 15 projetos Xcode independentes, divididos em cinco grupos com três atividades cada: Capítulo 5, Capítulo 6, Capítulo 7, Capítulo 8 e Revisão.

## Conferência após reorganizar

- Os 15 projetos foram compilados individualmente nos novos caminhos com o Xcode 27.2 (27B52), usando o SDK de simulador e assinatura desabilitada.
- Os 43 arquivos Swift das atividades foram comparados por SHA-256 antes e depois da mudança: o código foi preservado.
- Foram conferidos os projetos, os enunciados, as imagens e os links dos índices de cada capítulo.
- As 30 verificações de regras dos ViewModels foram executadas novamente nos novos caminhos e aprovadas.

## Verificações de interface anteriores

Os 16 cenários de interface aprovados pertencem à [versão inicial, commit 4237902](https://github.com/trvzera/atividades-ios/tree/4237902792ec01066c5dd9c59770b95a50edc8d3), que compilava esses mesmos arquivos Swift em um aplicativo com menu. Essa estrutura foi substituída pela coleção de projetos separados por capítulo solicitada para a entrega.

Os cenários verificaram validação de formulários, bindings, alertas, inclusão, exclusão por ID com filtros ativos, resumos e navegação. As interações foram executadas no iPhone 17 Pro com iOS 26.5. As 15 telas também foram conferidas visualmente no simulador iOS 27.2.

Pinça, giro e gestos simultâneos foram conferidos no código, sem cobertura integral pela automação. Não houve teste em iPhone físico.

## Repetir a compilação

Abra o arquivo `.xcodeproj` da atividade, selecione seu scheme e um simulador e use **⌘B**. Para executar, use **⌘R**.

Cada projeto inclui `README.md`, `ENUNCIADO.md` e uma prévia da tela. Requer iOS 17 ou superior. Os dados ficam em memória durante a execução.
