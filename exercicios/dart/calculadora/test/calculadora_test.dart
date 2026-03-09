import 'package:calculadora/calculadora.dart';
import 'package:test/test.dart';

void main() {
  group('operacoes basicas', () {
    test('soma', () {
      expect(somar(10, 5), 15);
    });

    test('subtracao', () {
      expect(subtrair(10, 5), 5);
    });

    test('multiplicacao', () {
      expect(multiplicar(10, 5), 50);
    });

    test('divisao', () {
      expect(dividir(10, 5), 2);
    });

    test('divisao por zero retorna null', () {
      expect(dividir(10, 0), isNull);
    });
  });

  group('operacoes extras', () {
    test('potencia', () {
      expect(potencia(2, 3), 8);
    });

    test('raiz quadrada', () {
      expect(raizQuadrada(81), 9);
    });

    test('raiz quadrada negativa retorna null', () {
      expect(raizQuadrada(-1), isNull);
    });

    test('porcentagem', () {
      expect(porcentagem(250, 10), 25);
    });
  });

  group('parser de expressoes', () {
    test('funciona sem espacos', () {
      final parser = ExpressionParser('2+3*4', ans: 0, memory: null);
      expect(parser.parse(), 14);
    });

    test('respeita precedencia', () {
      final parser = ExpressionParser('2 + 3 * 4', ans: 0, memory: null);
      expect(parser.parse(), 14);
    });

    test('respeita parenteses', () {
      final parser = ExpressionParser('(2 + 3) * 4', ans: 0, memory: null);
      expect(parser.parse(), 20);
    });

    test('usa ans e mem', () {
      final parser = ExpressionParser('ans + mem', ans: 10, memory: 5);
      expect(parser.parse(), 15);
    });

    test('divisao por zero falha', () {
      final parser = ExpressionParser('5/0', ans: 0, memory: null);
      expect(parser.parse, throwsFormatException);
    });
  });

  group('estado da calculadora', () {
    test('salva resultado atualizando ans e historico', () {
      final service = CalculadoraService();
      final ok = service.saveResult('2 + 2', 4);

      expect(ok, isTrue);
      expect(service.ans, 4);
      expect(service.history, contains('2 + 2 = 4'));
    });

    test('memoria M+ e MR', () {
      final service = CalculadoraService();
      service.ans = 7;
      service.memoryAddAns();

      expect(service.memory, 7);
      expect(service.recallMemory(), 7);
      expect(service.ans, 7);
    });

    test('limite do historico e respeitado', () {
      final service = CalculadoraService(historyLimit: 3);

      service.saveResult('1', 1);
      service.saveResult('2', 2);
      service.saveResult('3', 3);
      service.saveResult('4', 4);

      expect(service.history.length, 3);
      expect(service.history.first, '2 = 2');
      expect(service.history.last, '4 = 4');
    });

    test('nao salva resultado nao finito', () {
      final service = CalculadoraService();
      service.ans = 10;

      final ok = service.saveResult('(-1)^0.5', double.nan);

      expect(ok, isFalse);
      expect(service.ans, 10);
      expect(service.history, isEmpty);
    });

    test('formatacao de nao finito nao quebra', () {
      final service = CalculadoraService();

      expect(service.formatNumber(double.nan), 'NaN');
      expect(service.formatNumber(double.infinity), 'Infinity');
      expect(service.formatNumber(double.negativeInfinity), '-Infinity');
    });

    test('entrada infinity e rejeitada', () {
      final service = CalculadoraService();
      expect(() => service.parseNumberInput('Infinity'), throwsFormatException);
    });
  });
}
