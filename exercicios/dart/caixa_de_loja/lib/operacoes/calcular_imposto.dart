import 'package:caixa_de_loja/models/categoria.dart';

/// Calcula o imposto de um item, em centavos, de acordo com [categoria].
int calcularImposto(int totalItemCentavos, Categoria categoria) {
  final taxa = switch (categoria) {
    Categoria.alimento => 0.04,
    Categoria.higiene => 0.07,
    Categoria.eletronico => 0.12,
  };

  return (totalItemCentavos * taxa).round();
}
