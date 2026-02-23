# Caixa de Loja em Dart

Aplicacao de terminal feita em Dart para simular o fechamento de compras com regras fiscais, desconto progressivo e arredondamento monetario.

## Sobre o projeto

Este projeto resolve o exercicio de "Caixa de Loja com Regras Fiscais (Arredondamento e Auditoria)".

O sistema permite cadastrar itens da compra e, ao finalizar, gera um cupom fiscal detalhado com:

- total por item
- imposto por item
- subtotal da compra
- desconto aplicado
- total final

## Regras de negocio

### Categorias e impostos

| Categoria | Imposto |
| --- | --- |
| `ALIMENTO` | 4% |
| `HIGIENE` | 7% |
| `ELETRONICO` | 12% |

### Desconto progressivo (sobre o subtotal)

| Faixa de subtotal | Desconto |
| --- | --- |
| `< 100` | 0% |
| `>= 100` e `< 300` | 5% |
| `>= 300` | 10% |

## Validacoes implementadas

- entrada segura com `tryParse` para valores numericos
- repeticao de leitura ate receber valor valido
- `quantidade` precisa ser inteiro positivo
- `preco` precisa ser maior que zero
- categoria aceita apenas `ALIMENTO`, `HIGIENE` ou `ELETRONICO`

## Precisao e arredondamento

Para reduzir erros de ponto flutuante, os calculos monetarios sao feitos em centavos (`int`) internamente.

- entrada em `double` -> convertida para centavos
- calculos de total, imposto e desconto em centavos
- exibicao final com 2 casas decimais (`toStringAsFixed(2)`)

## Como executar

### Requisitos

- Dart SDK `^3.11.0`

### Passos

```bash
cd exercicios/dart/caixa_de_loja
dart pub get
dart run bin/caixa_de_loja.dart
```

## Exemplo rapido de uso

```text
=== Caixa de Loja ===

Nome do item (ou FIM para encerrar): Arroz
Preco unitario (> 0): 10.50
Quantidade (inteiro positivo): 2
Categoria [ALIMENTO, HIGIENE, ELETRONICO]: ALIMENTO
Item adicionado com sucesso.

Nome do item (ou FIM para encerrar): FIM

===== CUPOM FISCAL =====
Arroz | Qtd: 2 | Unit: R$ 10.50 | Total Item: R$ 21.00 | Imposto: R$ 0.84
-------------------------
Subtotal:       R$ 21.00
Impostos:       R$ 0.84
Desconto:      -R$ 0.00
TOTAL FINAL:    R$ 21.84
=========================
```

## Estrutura principal

- `bin/caixa_de_loja.dart`: ponto de entrada e fluxo principal do caixa
- `lib/caixa_de_loja.dart`: biblioteca base do pacote
- `test/`: testes automatizados

## Funcoes principais do exercicio

- `lerDoubleSeguro()`
- `lerIntSeguro()`
- `calcularImposto()`
- `calcularDesconto()`
- `imprimirCupom()`
