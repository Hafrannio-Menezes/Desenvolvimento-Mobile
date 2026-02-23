import 'dart:io';

enum Categoria { alimento, higiene, eletronico }

class ItemCompra {
  ItemCompra({
    required this.nome,
    required this.precoUnitarioCentavos,
    required this.quantidade,
    required this.categoria,
  });

  final String nome;
  final int precoUnitarioCentavos;
  final int quantidade;
  final Categoria categoria;

  int get totalCentavos => precoUnitarioCentavos * quantidade;
  int get impostoCentavos => calcularImposto(totalCentavos, categoria);
}

void main() {
  final itens = <ItemCompra>[];

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

    double precoUnitario;
    do {
      precoUnitario = lerDoubleSeguro('Preco unitario (> 0): ');
      if (precoUnitario <= 0) {
        print('Preco precisa ser maior que zero.');
      }
    } while (precoUnitario <= 0);

    int quantidade;
    do {
      quantidade = lerIntSeguro('Quantidade (inteiro positivo): ');
      if (quantidade <= 0) {
        print('Quantidade precisa ser um inteiro positivo.');
      }
    } while (quantidade <= 0);

    final categoria = lerCategoriaSeguro();

    itens.add(
      ItemCompra(
        nome: nome,
        precoUnitarioCentavos: paraCentavos(precoUnitario),
        quantidade: quantidade,
        categoria: categoria,
      ),
    );

    print('Item adicionado com sucesso.');
  }

  if (itens.isEmpty) {
    print('\nNenhum item registrado.');
    return;
  }

  final subtotalCentavos = itens.fold<int>(0, (soma, item) => soma + item.totalCentavos);
  final totalImpostosCentavos = itens.fold<int>(0, (soma, item) => soma + item.impostoCentavos);
  final descontoCentavos = calcularDesconto(subtotalCentavos);
  final totalFinalCentavos = subtotalCentavos - descontoCentavos + totalImpostosCentavos;

  imprimirCupom(
    itens,
    subtotalCentavos,
    totalImpostosCentavos,
    descontoCentavos,
    totalFinalCentavos,
  );
}

double lerDoubleSeguro(String mensagem) {
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

int lerIntSeguro(String mensagem) {
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

Categoria lerCategoriaSeguro() {
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

int calcularImposto(int totalItemCentavos, Categoria categoria) {
  final taxa = switch (categoria) {
    Categoria.alimento => 0.04,
    Categoria.higiene => 0.07,
    Categoria.eletronico => 0.12,
  };

  return (totalItemCentavos * taxa).round();
}

int calcularDesconto(int subtotalCentavos) {
  final subtotal = deCentavos(subtotalCentavos);

  final taxa = subtotal < 100
      ? 0.0
      : subtotal < 300
      ? 0.05
      : 0.10;

  return (subtotalCentavos * taxa).round();
}

void imprimirCupom(
  List<ItemCompra> itens,
  int subtotalCentavos,
  int totalImpostosCentavos,
  int descontoCentavos,
  int totalFinalCentavos,
) {
  print('\n===== CUPOM FISCAL =====');

  for (final item in itens) {
    print(
      '${item.nome} | '
      'Qtd: ${item.quantidade} | '
      'Unit: R\$ ${formatarMoeda(item.precoUnitarioCentavos)} | '
      'Total Item: R\$ ${formatarMoeda(item.totalCentavos)} | '
      'Imposto: R\$ ${formatarMoeda(item.impostoCentavos)}',
    );
  }

  print('-------------------------');
  print('Subtotal:       R\$ ${formatarMoeda(subtotalCentavos)}');
  print('Impostos:       R\$ ${formatarMoeda(totalImpostosCentavos)}');
  print('Desconto:      -R\$ ${formatarMoeda(descontoCentavos)}');
  print('TOTAL FINAL:    R\$ ${formatarMoeda(totalFinalCentavos)}');
  print('=========================');
}

int paraCentavos(double valor) => (valor * 100).round();

double deCentavos(int centavos) => centavos / 100;

String formatarMoeda(int centavos) => deCentavos(centavos).toStringAsFixed(2);
