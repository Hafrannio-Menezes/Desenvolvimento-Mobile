# Calculadora CLI em Dart

Calculadora de terminal com menu organizado, entrada por expressao direta e recursos de memoria.

## Recursos

- Menu principal limpo com status de `ANS` e `MEM`
- Modos por secao: basicas, cientifica, porcentagem, memoria, historico e configuracoes
- Entrada direta de expressao (`2 + 3*4`, `(2+3)^2`, `ans + mem`)
- Historico dos ultimos calculos com opcao de limpar
- Memoria estilo calculadora (`M+`, `M-`, `MR`, `MC`)
- Configuracao de casas decimais e limpeza automatica de tela
- Aceita `,` ou `.` como separador decimal

## Estrutura

- `bin/calculadora.dart`: ponto de entrada da aplicacao
- `lib/operacoes/`: funcoes matematicas separadas por arquivo
- `lib/ui/cli_calculadora_app.dart`: camada de interface CLI (menus e fluxo)
- `lib/services/calculadora_service.dart`: estado da aplicacao (`ANS`, memoria, historico, config)
- `lib/services/expression_parser.dart`: parser para expressoes com precedencia
- `test/calculadora_test.dart`: testes de operacoes, parser e service

## Como executar

```bash
dart run bin/calculadora.dart
```

## Como testar

```bash
dart analyze
dart test
```
