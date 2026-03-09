import 'package:calculadora/services/expression_parser.dart';

class CalculadoraService {
  CalculadoraService({
    this.historyLimit = 12,
    this.decimalPlaces = 6,
    this.clearScreenEnabled = true,
  });

  final int historyLimit;
  final List<String> history = [];
  int decimalPlaces;
  bool clearScreenEnabled;
  double ans = 0;
  double? memory;

  String get ansLabel => formatNumber(ans);

  String get memoryLabel => memory == null ? 'vazio' : formatNumber(memory!);

  double evaluateExpression(String expression) {
    final parser = ExpressionParser(expression, ans: ans, memory: memory);
    return parser.parse();
  }

  bool saveResult(String expression, double result) {
    if (!result.isFinite) {
      return false;
    }

    ans = result;
    _addHistory('$expression = ${formatNumber(result)}');
    return true;
  }

  void clearHistory() {
    history.clear();
  }

  void memoryAddAns() {
    memory = (memory ?? 0) + ans;
  }

  void memorySubtractAns() {
    memory = (memory ?? 0) - ans;
  }

  double recallMemory() {
    if (memory == null) {
      throw StateError('Memoria vazia.');
    }
    ans = memory!;
    return memory!;
  }

  void clearMemory() {
    memory = null;
  }

  void setDecimalPlaces(int value) {
    if (value < 0 || value > 10) {
      throw RangeError('Casas decimais devem estar entre 0 e 10.');
    }
    decimalPlaces = value;
  }

  double parseNumberInput(String rawInput) {
    final cleaned = rawInput.trim().toLowerCase();
    if (cleaned == 'ans') {
      return ans;
    }

    if (cleaned == 'mem') {
      if (memory == null) {
        throw const FormatException('Memoria vazia.');
      }
      return memory!;
    }

    final value = double.tryParse(cleaned.replaceAll(',', '.'));
    if (value == null) {
      throw const FormatException(
        'Entrada invalida. Use numero, "ans" ou "mem".',
      );
    }

    if (!value.isFinite) {
      throw const FormatException(
        'Entrada invalida. Numero nao finito nao e permitido.',
      );
    }

    return value;
  }

  String formatNumber(double value) {
    if (value.isNaN) {
      return 'NaN';
    }

    if (value.isInfinite) {
      return value.isNegative ? '-Infinity' : 'Infinity';
    }

    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }

    final fixed = value.toStringAsFixed(decimalPlaces);
    return fixed
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  void _addHistory(String item) {
    history.add(item);
    if (history.length > historyLimit) {
      history.removeAt(0);
    }
  }
}
