import 'package:caixa_de_loja/operacoes/de_centavos.dart';

/// Calcula o desconto progressivo sobre [subtotalCentavos].
///
/// Regras:
/// - `< 100` reais: 0%
/// - `>= 100` e `< 300` reais: 5%
/// - `>= 300` reais: 10%
int calcularDesconto(int subtotalCentavos) {
  final subtotal = deCentavos(subtotalCentavos);

  final taxa = subtotal < 100
      ? 0.0
      : subtotal < 300
      ? 0.05
      : 0.10;

  return (subtotalCentavos * taxa).round();
}
