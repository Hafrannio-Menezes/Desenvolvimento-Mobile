import 'dart:math' as math;

/// calcula a raiz quadrada de [numero].
///
/// retorna `null` quando [numero] e negativo.
double? raizQuadrada(double numero) {
  if (numero < 0) {
    return null;
  }

  return math.sqrt(numero);
}
