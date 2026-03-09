import 'package:caixa_de_loja/caixa_de_loja.dart';
import 'package:test/test.dart';

void main() {
  group('operacoes fiscais', () {
    test('calcula imposto por categoria', () {
      expect(calcularImposto(10000, Categoria.alimento), 400);
      expect(calcularImposto(10000, Categoria.higiene), 700);
      expect(calcularImposto(10000, Categoria.eletronico), 1200);
    });

    test('calcula desconto progressivo', () {
      expect(calcularDesconto(9999), 0);
      expect(calcularDesconto(10000), 500);
      expect(calcularDesconto(29999), 1500);
      expect(calcularDesconto(30000), 3000);
    });
  });

  group('operacoes monetarias', () {
    test('converte para e de centavos', () {
      expect(paraCentavos(10.50), 1050);
      expect(deCentavos(1050), 10.5);
    });

    test('formata moeda com duas casas', () {
      expect(formatarMoeda(1050), '10.50');
      expect(formatarMoeda(3), '0.03');
    });
  });

  group('entidade e service', () {
    test('item calcula total e imposto', () {
      final item = ItemCompra(
        nome: 'Sabonete',
        precoUnitarioCentavos: 350,
        quantidade: 2,
        categoria: Categoria.higiene,
      );

      expect(item.totalCentavos, 700);
      expect(item.impostoCentavos, 49);
    });

    test('caixa soma subtotal, impostos e total final', () {
      final service = CaixaService();

      service.adicionarItem(
        ItemCompra(
          nome: 'Arroz',
          precoUnitarioCentavos: 10000,
          quantidade: 1,
          categoria: Categoria.alimento,
        ),
      );

      service.adicionarItem(
        ItemCompra(
          nome: 'Fone',
          precoUnitarioCentavos: 20000,
          quantidade: 1,
          categoria: Categoria.eletronico,
        ),
      );

      expect(service.subtotalCentavos, 30000);
      expect(service.totalImpostosCentavos, 2800);
      expect(service.descontoCentavos, 3000);
      expect(service.totalFinalCentavos, 29800);
    });
  });
}
