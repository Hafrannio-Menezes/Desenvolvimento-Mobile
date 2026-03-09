import 'dart:math' as math;

double? raizQuadrada(double numero) {
  if (numero < 0) {
    return null;
  }

  return math.sqrt(numero);
}
