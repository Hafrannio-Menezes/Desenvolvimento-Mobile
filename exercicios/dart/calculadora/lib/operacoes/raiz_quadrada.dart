import 'dart:math' as math;

/// Calcula a raiz quadrada de [numero].
///
/// Retorna `null` quando [numero] e negativo.
double? raizQuadrada(double numero) {
  if (numero < 0) {
    return null;
  }

  return math.sqrt(numero);
}
