# Validação — 11/11/2026

Os 15 projetos individuais e o aplicativo geral compilaram com sucesso no Xcode 27.2 (27B52), para o SDK de simulador iOS. A assinatura foi desabilitada nesses builds de simulador.

As 30 verificações de regras dos ViewModels passaram. Os 16 cenários de interface passaram no iPhone 17 Pro com iOS 26.5: 12 na execução inicial e os três testes com seletores ajustados, mais o teste do menu, na execução seguinte.

## Cobertura de interface

- Foco: validação, slider desabilitado, dados compartilhados e alerta após fechar a sheet.
- Mixer: trava conjunta dos três sliders e do botão; zerar cores.
- Reserva: nome vazio ou só com espaços e confirmação da reserva.
- Cartaz: nome com número inválido, publicação e contagem de fechamento.
- Humor: troca de humor, observação curta inválida e registro válido.
- Peças: aparição da tela e contador de aberturas.
- Filmes: ano futuro inválido, inclusão, filtro, exclusão do item correto e resumo da coleção completa.
- Chamada: exclusão com filtro ativo preservando alunos ocultos e inclusão de novo aluno.
- Ranking: filtro estritamente maior que 50 e soma sobre a lista inteira.
- Mural: nome compartilhado, detalhe de colega, recado, cancelamento e confirmação da saída.
- Guia: navegação e dados do local correto.
- Cantina: lanche obrigatório e pedido com observação.
- Estante: alteração de leitura atualiza o resumo e cancelar não grava rascunho.
- Laboratório: stepper atualiza o total da lista e publicação do aviso.
- Agenda: filtro, cancelar/confirmar exclusão e incluir prova.
- Menu geral: abrir uma atividade e voltar ao catálogo.

## Regras dos modelos

`python3 scripts/testar-modelos.py` verifica campos vazios, espaços, foco zero, reinício dos valores e da data, limites de páginas e integrantes, totais, publicação de aviso, ordenação por data, filtros e exclusão por ID. O script terminou com **30 verificações aprovadas**.

## Compilação individual

- TrilhaFoco: aprovado.
- MixerCor: aprovado.
- ReservaSala: aprovado.
- CartazTurma: aprovado.
- HumorDia: aprovado.
- PecasSoltas: aprovado.
- ColecaoFilmes: aprovado.
- Chamada: aprovado.
- Ranking: aprovado.
- MuralTurma: aprovado.
- GuiaEscola: aprovado.
- Cantina: aprovado.
- Estante: aprovado.
- Laboratorio: aprovado.
- AgendaProvas: aprovado.

Para repetir, execute `python3 scripts/compilar-projetos.py`. Para repetir os testes de interface, abra `AtividadesIOS.xcodeproj`, selecione o scheme **AtividadesIOS**, escolha um simulador e use **⌘U**.

## Conferência visual e limites

Foram conferidas as 15 telas renderizadas no simulador iOS 27.2. As prévias dos READMEs vêm do aplicativo geral, que compila os mesmos arquivos Swift dos projetos individuais.

A automação inicial no iOS 27.2 parou de responder; os testes de interação foram executados no iOS 26.5. As primeiras falhas de seleção dos testes foram corrigidas para tocar o switch, identificar o rótulo completo dos pickers e dispensar o teclado antes de trocar de aba. Os cenários afetados foram reexecutados e aprovados.

Pinça, giro e a combinação simultânea dos gestos foram conferidos no código, mas não são cobertos integralmente pela automação. Não houve teste em iPhone físico. Os dados ficam em memória, conforme o escopo dos exercícios.

## Projetos retomados

O TrilhaFoco foi retomado da correção local anterior, mantendo a instância compartilhada e completando a organização e a validação. O CartazTurma recebeu validação de recado, publicação, cartão, contadores de ciclo de vida e ajustes do selo. O histórico dos dois repositórios foi preservado na publicação.
