import 'dart:io';

import 'package:calculadora/calculadora.dart';

class _InputClosed implements Exception {}

void main() {
  final app = CalculadoraService();

  try {
    while (true) {
      _clearScreen(app);
      _showMainMenu(app);

      final input = _readLine(prompt: '> ').trim();
      if (input.isEmpty) {
        continue;
      }

      if (_isMainOption(input)) {
        final shouldExit = _handleMainOption(input, app);
        if (shouldExit) {
          _clearScreen(app);
          print('Calculadora encerrada.');
          break;
        }
      } else {
        _runExpression(input, app);
      }

      _pause();
    }
  } on _InputClosed {
    print('\nEntrada encerrada.');
  }
}

bool _isMainOption(String input) {
  const options = {'0', '1', '2', '3', '4', '5', '6'};
  return options.contains(input);
}

bool _handleMainOption(String option, CalculadoraService app) {
  switch (option) {
    case '1':
      _basicMenu(app);
      return false;
    case '2':
      _scientificMenu(app);
      return false;
    case '3':
      _percentageFlow(app);
      return false;
    case '4':
      _memoryMenu(app);
      return false;
    case '5':
      _historyMenu(app);
      return false;
    case '6':
      _settingsMenu(app);
      return false;
    case '0':
      return true;
    default:
      print('Opcao invalida.');
      return false;
  }
}

void _showMainMenu(CalculadoraService app) {
  print('==============================');
  print('      CALCULADORA PRO');
  print('==============================');
  print('ANS: ${app.ansLabel}    MEM: ${app.memoryLabel}');
  print('Modo: Menu    Historico: ${app.history.length} itens');
  print('');
  print('1) Basicas (+ - * /)');
  print('2) Cientifica (pot, raiz)');
  print('3) Porcentagem');
  print('4) Memoria (M+, M-, MR, MC)');
  print('5) Historico');
  print('6) Configuracoes');
  print('0) Sair');
  print('');
  print('Ou digite uma expressao direta (ex: 2 + 3*4, ans + 2, mem/5)');
}

void _basicMenu(CalculadoraService app) {
  while (true) {
    _clearScreen(app);
    print('--- Basicas ---');
    print('1) Soma');
    print('2) Subtracao');
    print('3) Multiplicacao');
    print('4) Divisao');
    print('0) Voltar');

    final option = _readLine(prompt: 'Escolha: ').trim();

    switch (option) {
      case '1':
        _runBinaryOperation(app, '+', somar);
        _pause();
        break;
      case '2':
        _runBinaryOperation(app, '-', subtrair);
        _pause();
        break;
      case '3':
        _runBinaryOperation(app, '*', multiplicar);
        _pause();
        break;
      case '4':
        _runDivisionOperation(app);
        _pause();
        break;
      case '0':
        return;
      default:
        print('Opcao invalida.');
        _pause();
        break;
    }
  }
}

void _scientificMenu(CalculadoraService app) {
  while (true) {
    _clearScreen(app);
    print('--- Cientifica ---');
    print('1) Potencia');
    print('2) Raiz quadrada');
    print('0) Voltar');

    final option = _readLine(prompt: 'Escolha: ').trim();

    switch (option) {
      case '1':
        _runBinaryOperation(app, '^', potencia);
        _pause();
        break;
      case '2':
        _runSquareRootOperation(app);
        _pause();
        break;
      case '0':
        return;
      default:
        print('Opcao invalida.');
        _pause();
        break;
    }
  }
}

void _percentageFlow(CalculadoraService app) {
  _clearScreen(app);
  print('--- Porcentagem ---');

  final base = _readNumber(app, 'Valor base (ou ans/mem): ');
  final percent = _readNumber(app, 'Percentual (%): ');
  final result = porcentagem(base, percent);

  final expression =
      '${app.formatNumber(percent)}% de ${app.formatNumber(base)}';
  if (app.saveResult(expression, result)) {
    print('Resultado: ${app.formatNumber(result)}');
  } else {
    print('Erro: resultado nao representavel (NaN/Infinity).');
  }
}

void _memoryMenu(CalculadoraService app) {
  while (true) {
    _clearScreen(app);
    print('--- Memoria ---');
    print('ANS: ${app.ansLabel}    MEM: ${app.memoryLabel}');
    print('1) M+  (somar ANS na memoria)');
    print('2) M-  (subtrair ANS da memoria)');
    print('3) MR  (recuperar memoria para ANS)');
    print('4) MC  (limpar memoria)');
    print('0) Voltar');

    final option = _readLine(prompt: 'Escolha: ').trim();

    switch (option) {
      case '1':
        app.memoryAddAns();
        print('Memoria atualizada: ${app.memoryLabel}');
        _pause();
        break;
      case '2':
        app.memorySubtractAns();
        print('Memoria atualizada: ${app.memoryLabel}');
        _pause();
        break;
      case '3':
        try {
          final value = app.recallMemory();
          print('MR -> ANS = ${app.formatNumber(value)}');
        } on StateError {
          print('Memoria vazia.');
        }
        _pause();
        break;
      case '4':
        app.clearMemory();
        print('Memoria limpa.');
        _pause();
        break;
      case '0':
        return;
      default:
        print('Opcao invalida.');
        _pause();
        break;
    }
  }
}

void _historyMenu(CalculadoraService app) {
  while (true) {
    _clearScreen(app);
    print('--- Historico (ultimos ${app.historyLimit}) ---');

    if (app.history.isEmpty) {
      print('Sem calculos ainda.');
    } else {
      for (var i = 0; i < app.history.length; i++) {
        print('${i + 1}. ${app.history[i]}');
      }
    }

    print('');
    print('[C] Limpar historico');
    print('[V] Voltar');

    final option = _readLine(prompt: '> ').trim().toLowerCase();

    if (option == 'v' || option == '0' || option.isEmpty) {
      return;
    }

    if (option == 'c') {
      app.clearHistory();
      print('Historico limpo.');
      _pause();
      continue;
    }

    print('Opcao invalida.');
    _pause();
  }
}

void _settingsMenu(CalculadoraService app) {
  while (true) {
    _clearScreen(app);
    print('--- Configuracoes ---');
    print(
      '1) Limpar tela automaticamente: ${app.clearScreenEnabled ? 'ON' : 'OFF'}',
    );
    print('2) Casas decimais: ${app.decimalPlaces}');
    print('0) Voltar');

    final option = _readLine(prompt: 'Escolha: ').trim();

    switch (option) {
      case '1':
        app.clearScreenEnabled = !app.clearScreenEnabled;
        print('Limpar tela: ${app.clearScreenEnabled ? 'ON' : 'OFF'}');
        _pause();
        break;
      case '2':
        final input = _readLine(prompt: 'Nova quantidade (0-10): ').trim();
        final value = int.tryParse(input);
        if (value == null || value < 0 || value > 10) {
          print('Valor invalido. Use inteiro entre 0 e 10.');
        } else {
          app.setDecimalPlaces(value);
          print('Casas decimais atualizadas para $value.');
        }
        _pause();
        break;
      case '0':
        return;
      default:
        print('Opcao invalida.');
        _pause();
        break;
    }
  }
}

void _runExpression(String expression, CalculadoraService app) {
  try {
    final result = app.evaluateExpression(expression);
    if (app.saveResult(expression, result)) {
      print('Resultado: ${app.formatNumber(result)}');
    } else {
      print('Erro: resultado nao representavel (NaN/Infinity).');
    }
  } on FormatException catch (error) {
    print('Erro: ${error.message}');
  }
}

void _runBinaryOperation(
  CalculadoraService app,
  String symbol,
  double Function(double, double) operation,
) {
  final first = _readNumber(app, 'Primeiro numero (ou ans/mem): ');
  final second = _readNumber(app, 'Segundo numero (ou ans/mem): ');
  final result = operation(first, second);

  final expression =
      '${app.formatNumber(first)} $symbol ${app.formatNumber(second)}';

  if (app.saveResult(expression, result)) {
    print('Resultado: ${app.formatNumber(result)}');
  } else {
    print('Erro: resultado nao representavel (NaN/Infinity).');
  }
}

void _runDivisionOperation(CalculadoraService app) {
  final first = _readNumber(app, 'Primeiro numero (ou ans/mem): ');
  final second = _readNumber(app, 'Segundo numero (ou ans/mem): ');
  final result = dividir(first, second);

  if (result == null) {
    print('Erro: nao e possivel dividir por zero.');
    return;
  }

  final expression = '${app.formatNumber(first)} / ${app.formatNumber(second)}';

  if (app.saveResult(expression, result)) {
    print('Resultado: ${app.formatNumber(result)}');
  } else {
    print('Erro: resultado nao representavel (NaN/Infinity).');
  }
}

void _runSquareRootOperation(CalculadoraService app) {
  final value = _readNumber(app, 'Numero para raiz (ou ans/mem): ');
  final result = raizQuadrada(value);

  if (result == null) {
    print('Erro: nao existe raiz quadrada real de numero negativo.');
    return;
  }

  final expression = 'raiz(${app.formatNumber(value)})';

  if (app.saveResult(expression, result)) {
    print('Resultado: ${app.formatNumber(result)}');
  } else {
    print('Erro: resultado nao representavel (NaN/Infinity).');
  }
}

double _readNumber(CalculadoraService app, String prompt) {
  while (true) {
    final raw = _readLine(prompt: prompt);
    try {
      return app.parseNumberInput(raw);
    } on FormatException catch (error) {
      print(error.message);
    }
  }
}

String _readLine({required String prompt}) {
  stdout.write(prompt);
  final input = stdin.readLineSync();
  if (input == null) {
    throw _InputClosed();
  }
  return input;
}

void _clearScreen(CalculadoraService app) {
  if (app.clearScreenEnabled && stdout.hasTerminal) {
    stdout.write('\x1B[2J\x1B[0;0H');
  }
}

void _pause() {
  stdout.write('\nPressione Enter para continuar...');
  if (stdin.readLineSync() == null) {
    throw _InputClosed();
  }
}
