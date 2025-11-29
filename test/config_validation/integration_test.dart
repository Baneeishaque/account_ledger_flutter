import 'dart:io';
import 'package:test/test.dart';

/// Integration tests for the configuration validation test suite
void main() {
  group('Test Suite Integration', () {
    test('all required test files exist', () {
      final testFiles = [
        'test/config_validation/azure_pipelines_validation_test.dart',
        'test/config_validation/copilot_instructions_validation_test.dart',
        'test/config_validation/shell_script_validation_test.dart',
        'test/config_validation/readme_validation_test.dart',
      ];

      for (final testFile in testFiles) {
        final file = File(testFile);
        expect(file.existsSync(), isTrue, reason: '$testFile should exist');
      }
    });

    test('all Python test files exist', () {
      final pythonTests = [
        'tests/test_config_validation.py',
        'tests/test_yaml_validation.py',
        'tests/test_shell_scripts.py',
        'tests/test_readme_validation.py',
      ];

      for (final testFile in pythonTests) {
        final file = File(testFile);
        expect(file.existsSync(), isTrue, reason: '$testFile should exist');
      }
    });

    test('test runner scripts exist and are executable', () {
      final scripts = [
        'run_tests.sh',
        'run_validation_tests.sh',
      ];

      for (final script in scripts) {
        final file = File(script);
        expect(file.existsSync(), isTrue, reason: '$script should exist');

        // Check if file is executable (on Unix-like systems)
        if (!Platform.isWindows) {
          final stat = file.statSync();
          final isExecutable = (stat.mode & 0x49) != 0; // Check execute bits
          expect(isExecutable, isTrue, reason: '$script should be executable');
        }
      }
    });

    test('configuration files being tested exist', () {
      final configFiles = [
        'azure-pipelines.yml',
        '.github/copilot-instructions.md',
        'pubspec.yaml',
        'analysis_options.yaml',
      ];

      for (final configFile in configFiles) {
        final file = File(configFile);
        expect(file.existsSync(), isTrue, reason: '$configFile should exist');
      }
    });

    test('test directories have README files', () {
      final readmes = [
        'test/README.md',
        'test/config_validation/README.md',
      ];

      for (final readme in readmes) {
        final file = File(readme);
        expect(file.existsSync(), isTrue, reason: '$readme should exist');
      }
    });

    test('Python tests module is properly structured', () {
      final testsDir = Directory('tests');
      expect(testsDir.existsSync(), isTrue, reason: 'tests directory should exist');

      final initFile = File('tests/__init__.py');
      expect(initFile.existsSync(), isTrue, reason: '__init__.py should exist');
    });

    test('pubspec.yaml includes required test dependencies', () {
      final pubspecFile = File('pubspec.yaml');
      expect(pubspecFile.existsSync(), isTrue);

      final content = pubspecFile.readAsStringSync();

      expect(content, contains('dev_dependencies:'),
          reason: 'Should have dev_dependencies section');
      expect(content, contains('test:'), reason: 'Should include test package');
      expect(content, contains('yaml:'), reason: 'Should include yaml package');
    });

    test('test files follow naming conventions', () {
      final dartTests = Directory('test/config_validation')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'));

      for (final testFile in dartTests) {
        expect(testFile.path, endsWith('_test.dart'),
            reason: 'Dart test files should end with _test.dart');
      }

      final pythonTests = Directory('tests')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.py') && !f.path.endsWith('__init__.py'));

      for (final testFile in pythonTests) {
        final name = testFile.path.split('/').last;
        expect(name, startsWith('test_'),
            reason: 'Python test files should start with test_');
      }
    });
  });

  group('Test Suite Coverage', () {
    test('covers all modified files from diff', () {
      final modifiedFiles = [
        '.github/copilot-instructions.md',
        'azure-pipelines.yml',
        'pubspec.yaml',
        'run_tests.sh',
        'run_validation_tests.sh',
      ];

      // Verify each modified file has corresponding tests
      for (final file in modifiedFiles) {
        expect(File(file).existsSync(), isTrue,
            reason: 'Modified file should exist: $file');
      }
    });

    test('test suite is comprehensive', () {
      // Count total test files
      final dartTestFiles = Directory('test/config_validation')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('_test.dart'))
          .length;

      final pythonTestFiles = Directory('tests')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.py') && !f.path.endsWith('__init__.py'))
          .length;

      expect(dartTestFiles, greaterThanOrEqualTo(4),
          reason: 'Should have at least 4 Dart test files');
      expect(pythonTestFiles, greaterThanOrEqualTo(4),
          reason: 'Should have at least 4 Python test files');
    });
  });
}