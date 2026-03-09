import 'package:calculadora/services/expression_parser.dart';

/// service que concentra estado e regras da calculadora.
///
/// mantem `ANS`, memoria, historico e configuracoes de formatacao.
class CalculadoraService {
  /// Cria o service com configuracoes iniciais de execucao.
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

  /// Representacao formatada do valor atual de `ANS`.
  String get ansLabel => formatNumber(ans);

  /// Representacao formatada do valor de memoria.
  String get memoryLabel => memory == null ? 'vazio' : formatNumber(memory!);

  /// Avalia uma expressao matematica textual.
  double evaluateExpression(String expression) {
    final parser = ExpressionParser(expression, ans: ans, memory: memory);
    return parser.parse();
  }

  /// Salva um resultado no estado interno e no historico.
  ///
  /// Retorna `false` quando o valor nao e finito (`NaN/Infinity`).
  bool saveResult(String expression, double result) {
    if (!result.isFinite) {
      return false;
    }

    ans = result;
    _addHistory('$expression = ${formatNumber(result)}');
    return true;
  }

  /// Limpa todo o historico da sessao atual.
  void clearHistory() {
    history.clear();
  }

  /// Soma `ANS` ao valor de memoria.
  void memoryAddAns() {
    memory = (memory ?? 0) + ans;
  }

  /// Subtrai `ANS` do valor de memoria.
  void memorySubtractAns() {
    memory = (memory ?? 0) - ans;
  }

  /// Recupera o valor da memoria e atualiza `ANS`.
  ///
  /// Lanca [StateError] se a memoria estiver vazia.
  double recallMemory() {
    if (memory == null) {
      throw StateError('Memoria vazia.');
    }
    ans = memory!;
    return memory!;
  }

  /// Limpa o valor atual de memoria.
  void clearMemory() {
    memory = null;
  }

  /// Atualiza a quantidade de casas decimais usadas na formatacao.
  void setDecimalPlaces(int value) {
    if (value < 0 || value > 10) {
      throw RangeError('Casas decimais devem estar entre 0 e 10.');
    }
    decimalPlaces = value;
  }

  /// Converte entrada textual em numero.
  ///
  /// Aceita numero decimal, `ans` e `mem`.
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

  /// Formata um numero para exibicao no terminal.
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
