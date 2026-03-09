import 'package:calculadora/operacoes/potencia.dart';

/// Parser recursivo para expressoes matematicas da CLI.
///
/// Suporta `+`, `-`, `*`, `/`, `^`, parenteses e os identificadores `ans` e
/// `mem`.
class ExpressionParser {
  /// Cria um parser para [_input] com contexto de [ans] e [memory].
  ExpressionParser(this._input, {required this.ans, required this.memory});

  final String _input;
  final double ans;
  final double? memory;
  int _index = 0;

  bool get _isAtEnd => _index >= _input.length;

  /// Executa o parsing da expressao e retorna o valor numerico final.
  double parse() {
    final value = _parseExpression();
    _skipSpaces();

    if (!_isAtEnd) {
      throw FormatException(
        'Expressao invalida: caractere inesperado "${_input[_index]}".',
      );
    }

    return value;
  }

  double _parseExpression() {
    var value = _parseTerm();

    while (true) {
      _skipSpaces();
      if (_match('+')) {
        value += _parseTerm();
      } else if (_match('-')) {
        value -= _parseTerm();
      } else {
        return value;
      }
    }
  }

  double _parseTerm() {
    var value = _parsePower();

    while (true) {
      _skipSpaces();
      if (_match('*')) {
        value *= _parsePower();
      } else if (_match('/')) {
        final divisor = _parsePower();
        if (divisor == 0) {
          throw FormatException('Nao e possivel dividir por zero.');
        }
        value /= divisor;
      } else {
        return value;
      }
    }
  }

  double _parsePower() {
    var value = _parseUnary();
    _skipSpaces();

    if (_match('^')) {
      final exponent = _parsePower();
      value = potencia(value, exponent);
    }

    return value;
  }

  double _parseUnary() {
    _skipSpaces();
    if (_match('+')) {
      return _parseUnary();
    }
    if (_match('-')) {
      return -_parseUnary();
    }
    return _parsePrimary();
  }

  double _parsePrimary() {
    _skipSpaces();

    if (_match('(')) {
      final value = _parseExpression();
      _skipSpaces();
      if (!_match(')')) {
        throw FormatException('Feche parenteses com ")".');
      }
      return value;
    }

    if (_peekIsLetter()) {
      final identifier = _readIdentifier().toLowerCase();
      switch (identifier) {
        case 'ans':
          return ans;
        case 'mem':
          if (memory == null) {
            throw FormatException('Memoria vazia.');
          }
          return memory!;
        default:
          throw FormatException('Identificador desconhecido: $identifier.');
      }
    }

    return _readNumber();
  }

  double _readNumber() {
    _skipSpaces();
    final start = _index;
    var hasDigit = false;
    var hasDot = false;

    while (!_isAtEnd) {
      final char = _input[_index];
      if (_isDigit(char)) {
        hasDigit = true;
        _index++;
        continue;
      }
      if ((char == '.' || char == ',') && !hasDot) {
        hasDot = true;
        _index++;
        continue;
      }
      break;
    }

    if (!hasDigit) {
      throw FormatException('Numero esperado na posicao ${start + 1}.');
    }

    final token = _input.substring(start, _index).replaceAll(',', '.');
    final value = double.tryParse(token);
    if (value == null) {
      throw FormatException('Numero invalido: $token.');
    }

    return value;
  }

  String _readIdentifier() {
    final start = _index;
    while (!_isAtEnd) {
      final char = _input[_index];
      if (_isLetter(char)) {
        _index++;
      } else {
        break;
      }
    }
    return _input.substring(start, _index);
  }

  void _skipSpaces() {
    while (!_isAtEnd && _input[_index].trim().isEmpty) {
      _index++;
    }
  }

  bool _match(String expected) {
    if (_isAtEnd || _input[_index] != expected) {
      return false;
    }
    _index++;
    return true;
  }

  bool _peekIsLetter() {
    if (_isAtEnd) {
      return false;
    }
    return _isLetter(_input[_index]);
  }

  bool _isLetter(String char) {
    return RegExp(r'[A-Za-z]').hasMatch(char);
  }

  bool _isDigit(String char) {
    return RegExp(r'[0-9]').hasMatch(char);
  }
}
