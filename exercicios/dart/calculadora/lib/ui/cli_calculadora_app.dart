import 'dart:io';

import 'package:calculadora/calculadora.dart';

class _InputClosed implements Exception {}

/// aplicacao CLI da calculadora.
///
/// centraliza o fluxo de menus, leitura de entrada e impressao de resultados.
class CliCalculadoraApp {
  /// Cria a aplicacao com um [CalculadoraService] opcional.
  CliCalculadoraApp({CalculadoraService? service})
    : _service = service ?? CalculadoraService();

  final CalculadoraService _service;

  /// Inicia o loop principal da calculadora no terminal.
  void run() {
    try {
      while (true) {
        _clearScreen();
        _showMainMenu();

        final input = _readLine(prompt: '> ').trim();
        if (input.isEmpty) {
          continue;
        }

        if (_isMainOption(input)) {
          final shouldExit = _handleMainOption(input);
          if (shouldExit) {
            _clearScreen();
            print('Calculadora encerrada.');
            break;
          }
        } else {
          _runExpression(input);
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

  bool _handleMainOption(String option) {
    switch (option) {
      case '1':
        _basicMenu();
        return false;
      case '2':
        _scientificMenu();
        return false;
      case '3':
        _percentageFlow();
        return false;
      case '4':
        _memoryMenu();
        return false;
      case '5':
        _historyMenu();
        return false;
      case '6':
        _settingsMenu();
        return false;
      case '0':
        return true;
      default:
        print('Opcao invalida.');
        return false;
    }
  }

  void _showMainMenu() {
    print('==============================');
    print('      CALCULADORA PRO');
    print('==============================');
    print('ANS: ${_service.ansLabel}    MEM: ${_service.memoryLabel}');
    print('Modo: Menu    Historico: ${_service.history.length} itens');
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

  void _basicMenu() {
    while (true) {
      _clearScreen();
      print('--- Basicas ---');
      print('1) Soma');
      print('2) Subtracao');
      print('3) Multiplicacao');
      print('4) Divisao');
      print('0) Voltar');

      final option = _readLine(prompt: 'Escolha: ').trim();

      switch (option) {
        case '1':
          _runBinaryOperation('+', somar);
          _pause();
          break;
        case '2':
          _runBinaryOperation('-', subtrair);
          _pause();
          break;
        case '3':
          _runBinaryOperation('*', multiplicar);
          _pause();
          break;
        case '4':
          _runDivisionOperation();
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

  void _scientificMenu() {
    while (true) {
      _clearScreen();
      print('--- Cientifica ---');
      print('1) Potencia');
      print('2) Raiz quadrada');
      print('0) Voltar');

      final option = _readLine(prompt: 'Escolha: ').trim();

      switch (option) {
        case '1':
          _runBinaryOperation('^', potencia);
          _pause();
          break;
        case '2':
          _runSquareRootOperation();
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

  void _percentageFlow() {
    _clearScreen();
    print('--- Porcentagem ---');

    final base = _readNumber('Valor base (ou ans/mem): ');
    final percent = _readNumber('Percentual (%): ');
    final result = porcentagem(base, percent);

    final expression =
        '${_service.formatNumber(percent)}% de ${_service.formatNumber(base)}';
    if (_service.saveResult(expression, result)) {
      print('Resultado: ${_service.formatNumber(result)}');
    } else {
      print('Erro: resultado nao representavel (NaN/Infinity).');
    }
  }

  void _memoryMenu() {
    while (true) {
      _clearScreen();
      print('--- Memoria ---');
      print('ANS: ${_service.ansLabel}    MEM: ${_service.memoryLabel}');
      print('1) M+  (somar ANS na memoria)');
      print('2) M-  (subtrair ANS da memoria)');
      print('3) MR  (recuperar memoria para ANS)');
      print('4) MC  (limpar memoria)');
      print('0) Voltar');

      final option = _readLine(prompt: 'Escolha: ').trim();

      switch (option) {
        case '1':
          _service.memoryAddAns();
          print('Memoria atualizada: ${_service.memoryLabel}');
          _pause();
          break;
        case '2':
          _service.memorySubtractAns();
          print('Memoria atualizada: ${_service.memoryLabel}');
          _pause();
          break;
        case '3':
          try {
            final value = _service.recallMemory();
            print('MR -> ANS = ${_service.formatNumber(value)}');
          } on StateError {
            print('Memoria vazia.');
          }
          _pause();
          break;
        case '4':
          _service.clearMemory();
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

  void _historyMenu() {
    while (true) {
      _clearScreen();
      print('--- Historico (ultimos ${_service.historyLimit}) ---');

      if (_service.history.isEmpty) {
        print('Sem calculos ainda.');
      } else {
        for (var i = 0; i < _service.history.length; i++) {
          print('${i + 1}. ${_service.history[i]}');
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
        _service.clearHistory();
        print('Historico limpo.');
        _pause();
        continue;
      }

      print('Opcao invalida.');
      _pause();
    }
  }

  void _settingsMenu() {
    while (true) {
      _clearScreen();
      print('--- Configuracoes ---');
      print(
        '1) Limpar tela automaticamente: ${_service.clearScreenEnabled ? 'ON' : 'OFF'}',
      );
      print('2) Casas decimais: ${_service.decimalPlaces}');
      print('0) Voltar');

      final option = _readLine(prompt: 'Escolha: ').trim();

      switch (option) {
        case '1':
          _service.clearScreenEnabled = !_service.clearScreenEnabled;
          print('Limpar tela: ${_service.clearScreenEnabled ? 'ON' : 'OFF'}');
          _pause();
          break;
        case '2':
          final input = _readLine(prompt: 'Nova quantidade (0-10): ').trim();
          final value = int.tryParse(input);
          if (value == null || value < 0 || value > 10) {
            print('Valor invalido. Use inteiro entre 0 e 10.');
          } else {
            _service.setDecimalPlaces(value);
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

  void _runExpression(String expression) {
    try {
      final result = _service.evaluateExpression(expression);
      if (_service.saveResult(expression, result)) {
        print('Resultado: ${_service.formatNumber(result)}');
      } else {
        print('Erro: resultado nao representavel (NaN/Infinity).');
      }
    } on FormatException catch (error) {
      print('Erro: ${error.message}');
    }
  }

  void _runBinaryOperation(
    String symbol,
    double Function(double, double) operation,
  ) {
    final first = _readNumber('Primeiro numero (ou ans/mem): ');
    final second = _readNumber('Segundo numero (ou ans/mem): ');
    final result = operation(first, second);

    final expression =
        '${_service.formatNumber(first)} $symbol ${_service.formatNumber(second)}';

    if (_service.saveResult(expression, result)) {
      print('Resultado: ${_service.formatNumber(result)}');
    } else {
      print('Erro: resultado nao representavel (NaN/Infinity).');
    }
  }

  void _runDivisionOperation() {
    final first = _readNumber('Primeiro numero (ou ans/mem): ');
    final second = _readNumber('Segundo numero (ou ans/mem): ');
    final result = dividir(first, second);

    if (result == null) {
      print('Erro: nao e possivel dividir por zero.');
      return;
    }

    final expression =
        '${_service.formatNumber(first)} / ${_service.formatNumber(second)}';

    if (_service.saveResult(expression, result)) {
      print('Resultado: ${_service.formatNumber(result)}');
    } else {
      print('Erro: resultado nao representavel (NaN/Infinity).');
    }
  }

  void _runSquareRootOperation() {
    final value = _readNumber('Numero para raiz (ou ans/mem): ');
    final result = raizQuadrada(value);

    if (result == null) {
      print('Erro: nao existe raiz quadrada real de numero negativo.');
      return;
    }

    final expression = 'raiz(${_service.formatNumber(value)})';

    if (_service.saveResult(expression, result)) {
      print('Resultado: ${_service.formatNumber(result)}');
    } else {
      print('Erro: resultado nao representavel (NaN/Infinity).');
    }
  }

  double _readNumber(String prompt) {
    while (true) {
      final raw = _readLine(prompt: prompt);
      try {
        return _service.parseNumberInput(raw);
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

  void _clearScreen() {
    if (_service.clearScreenEnabled && stdout.hasTerminal) {
      stdout.write('\x1B[2J\x1B[0;0H');
    }
  }

  void _pause() {
    stdout.write('\nPressione Enter para continuar...');
    if (stdin.readLineSync() == null) {
      throw _InputClosed();
    }
  }
}
