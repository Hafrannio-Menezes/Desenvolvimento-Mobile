import 'dart:collection';

import 'package:caixa_de_loja/models/item_compra.dart';
import 'package:caixa_de_loja/operacoes/calcular_desconto.dart';

/// Service que agrega os itens e calcula os totais do fechamento.
class CaixaService {
  final List<ItemCompra> _itens = [];

  /// Lista imutavel de itens registrados.
  UnmodifiableListView<ItemCompra> get itens => UnmodifiableListView(_itens);

  /// Indica se ainda nao ha itens no caixa.
  bool get isEmpty => _itens.isEmpty;

  /// Adiciona um item ao fechamento.
  void adicionarItem(ItemCompra item) {
    _itens.add(item);
  }

  /// Soma de todos os itens sem impostos e sem desconto.
  int get subtotalCentavos =>
      _itens.fold<int>(0, (soma, item) => soma + item.totalCentavos);

  /// Soma dos impostos de todos os itens.
  int get totalImpostosCentavos =>
      _itens.fold<int>(0, (soma, item) => soma + item.impostoCentavos);

  /// Valor do desconto progressivo aplicado no subtotal.
  int get descontoCentavos => calcularDesconto(subtotalCentavos);

  /// Valor final: subtotal - desconto + impostos.
  int get totalFinalCentavos =>
      subtotalCentavos - descontoCentavos + totalImpostosCentavos;
}
