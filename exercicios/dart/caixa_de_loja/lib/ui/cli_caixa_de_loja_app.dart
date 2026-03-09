import 'dart:io';

import 'package:caixa_de_loja/caixa_de_loja.dart';

/// Aplicacao de terminal para operacao do caixa de loja.
class CliCaixaDeLojaApp {
  /// Cria a aplicacao com [service] opcional para facilitar testes.
  CliCaixaDeLojaApp({CaixaService? service})
    : _service = service ?? CaixaService();

  final CaixaService _service;

  /// Inicia o fluxo principal de cadastro e fechamento.
  void run() {
    print('=== Caixa de Loja ===');

    while (true) {
      stdout.write('\nNome do item (ou FIM para encerrar): ');
      final nome = (stdin.readLineSync() ?? '').trim();

      if (nome.toUpperCase() == 'FIM') {
        break;
      }

      if (nome.isEmpty) {
        print('Nome invalido. Tente novamente.');
        continue;
      }

      final precoUnitario = _lerPrecoSeguro();
      final quantidade = _lerQuantidadeSegura();
      final categoria = _lerCategoriaSegura();

      _service.adicionarItem(
        ItemCompra(
          nome: nome,
          precoUnitarioCentavos: paraCentavos(precoUnitario),
          quantidade: quantidade,
          categoria: categoria,
        ),
      );

      print('Item adicionado com sucesso.');
    }

    if (_service.isEmpty) {
      print('\nNenhum item registrado.');
      return;
    }

    _imprimirCupom();
  }

  double _lerPrecoSeguro() {
    while (true) {
      final preco = _lerDoubleSeguro('Preco unitario (> 0): ');
      if (preco > 0) {
        return preco;
      }
      print('Preco precisa ser maior que zero.');
    }
  }

  int _lerQuantidadeSegura() {
    while (true) {
      final quantidade = _lerIntSeguro('Quantidade (inteiro positivo): ');
      if (quantidade > 0) {
        return quantidade;
      }
      print('Quantidade precisa ser um inteiro positivo.');
    }
  }

  double _lerDoubleSeguro(String mensagem) {
    while (true) {
      stdout.write(mensagem);
      final entrada = (stdin.readLineSync() ?? '').replaceAll(',', '.').trim();
      final valor = double.tryParse(entrada);

      if (valor != null) {
        return valor;
      }

      print('Entrada invalida. Digite um numero valido.');
    }
  }

  int _lerIntSeguro(String mensagem) {
    while (true) {
      stdout.write(mensagem);
      final entrada = (stdin.readLineSync() ?? '').trim();
      final valor = int.tryParse(entrada);

      if (valor != null) {
        return valor;
      }

      print('Entrada invalida. Digite um inteiro valido.');
    }
  }

  Categoria _lerCategoriaSegura() {
    while (true) {
      stdout.write('Categoria [ALIMENTO, HIGIENE, ELETRONICO]: ');
      final entrada = (stdin.readLineSync() ?? '').trim().toUpperCase();

      switch (entrada) {
        case 'ALIMENTO':
          return Categoria.alimento;
        case 'HIGIENE':
          return Categoria.higiene;
        case 'ELETRONICO':
          return Categoria.eletronico;
        default:
          print('Categoria invalida. Use ALIMENTO, HIGIENE ou ELETRONICO.');
      }
    }
  }

  void _imprimirCupom() {
    print('\n===== CUPOM FISCAL =====');

    for (final item in _service.itens) {
      print(
        '${item.nome} | '
        'Qtd: ${item.quantidade} | '
        'Unit: R\$ ${formatarMoeda(item.precoUnitarioCentavos)} | '
        'Total Item: R\$ ${formatarMoeda(item.totalCentavos)} | '
        'Imposto: R\$ ${formatarMoeda(item.impostoCentavos)}',
      );
    }

    print('-------------------------');
    print('Subtotal:       R\$ ${formatarMoeda(_service.subtotalCentavos)}');
    print(
      'Impostos:       R\$ ${formatarMoeda(_service.totalImpostosCentavos)}',
    );
    print('Desconto:      -R\$ ${formatarMoeda(_service.descontoCentavos)}');
    print('TOTAL FINAL:    R\$ ${formatarMoeda(_service.totalFinalCentavos)}');
    print('=========================');
  }
}
