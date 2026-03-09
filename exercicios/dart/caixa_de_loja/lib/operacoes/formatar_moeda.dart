import 'package:caixa_de_loja/operacoes/de_centavos.dart';

/// Formata [centavos] como texto monetario com duas casas decimais.
String formatarMoeda(int centavos) => deCentavos(centavos).toStringAsFixed(2);
