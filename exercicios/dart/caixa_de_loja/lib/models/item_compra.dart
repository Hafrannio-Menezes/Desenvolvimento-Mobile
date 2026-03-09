import 'package:caixa_de_loja/models/categoria.dart';
import 'package:caixa_de_loja/operacoes/calcular_imposto.dart';

/// Entidade de item inserido no caixa.
class ItemCompra {
  /// Cria um item de compra com os dados de entrada do operador.
  ItemCompra({
    required this.nome,
    required this.precoUnitarioCentavos,
    required this.quantidade,
    required this.categoria,
  });

  /// Nome do produto.
  final String nome;

  /// Preco unitario em centavos.
  final int precoUnitarioCentavos;

  /// Quantidade comprada.
  final int quantidade;

  /// Categoria fiscal.
  final Categoria categoria;

  /// Total bruto do item (sem desconto), em centavos.
  int get totalCentavos => precoUnitarioCentavos * quantidade;

  /// Imposto do item, em centavos.
  int get impostoCentavos => calcularImposto(totalCentavos, categoria);
}
