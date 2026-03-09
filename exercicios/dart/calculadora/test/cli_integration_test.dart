import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('cli integration', () {
    test(
      'encerra normalmente quando escolhe 0',
      () async {
        final result = await _runCli(input: '0\n');

        expect(result.exitCode, 0);
        expect(result.stdout, contains('Calculadora encerrada.'));
        expect(result.stderr, isEmpty);
      },
      timeout: const Timeout(Duration(seconds: 20)),
    );

    test('nao trava em EOF na entrada', () async {
      final result = await _runCli();

      expect(result.exitCode, 0);
      expect(result.stdout, contains('Entrada encerrada.'));
      expect(result.stderr, isEmpty);
    }, timeout: const Timeout(Duration(seconds: 20)));

    test(
      'calcula expressao direta e volta ao menu',
      () async {
        final result = await _runCli(input: '2+3*4\n\n0\n');

        expect(result.exitCode, 0);
        expect(result.stdout, contains('Resultado: 14'));
        expect(result.stdout, contains('Calculadora encerrada.'));
        expect(result.stderr, isEmpty);
      },
      timeout: const Timeout(Duration(seconds: 20)),
    );
  });
}

Future<_CliRunResult> _runCli({String input = ''}) async {
  final process = await Process.start(Platform.resolvedExecutable, [
    'run',
    'bin/calculadora.dart',
  ], workingDirectory: Directory.current.path);

  final stdoutBuffer = StringBuffer();
  final stderrBuffer = StringBuffer();

  final stdoutDone = process.stdout.transform(utf8.decoder).listen((chunk) {
    stdoutBuffer.write(chunk);
  }).asFuture<void>();

  final stderrDone = process.stderr.transform(utf8.decoder).listen((chunk) {
    stderrBuffer.write(chunk);
  }).asFuture<void>();

  if (input.isNotEmpty) {
    process.stdin.write(input);
  }
  await process.stdin.close();

  final exitCode = await process.exitCode.timeout(
    const Duration(seconds: 15),
    onTimeout: () {
      process.kill();
      throw TimeoutException('Processo da CLI excedeu o tempo limite.');
    },
  );

  await Future.wait([stdoutDone, stderrDone]);

  return _CliRunResult(
    exitCode: exitCode,
    stdout: stdoutBuffer.toString(),
    stderr: stderrBuffer.toString(),
  );
}

class _CliRunResult {
  const _CliRunResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

  final int exitCode;
  final String stdout;
  final String stderr;
}
