/// divide [numero1] por [numero2].
///
/// retorna `null` quando [numero2] e zero.
double? dividir(double numero1, double numero2) {
  if (numero2 == 0) {
    return null;
  }

  return numero1 / numero2;
}
