import 'dart:io';
import 'package:test/test.dart';

/// Validation tests for shell scripts
void main() {
  group('Shell Script Validation', () {
    test('run_tests.sh should exist', () {
      final file = File('run_tests.sh');
      expect(file.existsSync(), isTrue);
    });

    test('run_validation_tests.sh should exist', () {
      final file = File('run_validation_tests.sh');
      expect(file.existsSync(), isTrue);
    });

    test('shell scripts should have shebang', () {
      final scripts = ['run_tests.sh', 'run_validation_tests.sh'];
      for (final script in scripts) {
        final file = File(script);
        if (file.existsSync()) {
          final firstLine = file.readAsLinesSync().first;
          expect(firstLine, startsWith('#!/bin/bash'));
        }
      }
    });

    test('run_validation_tests.sh should check for Flutter', () {
      final file = File('run_validation_tests.sh');
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        expect(content, contains('flutter'));
      }
    });
  });
}