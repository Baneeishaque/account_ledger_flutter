import 'dart:io';
import 'package:test/test.dart';

/// Comprehensive validation tests for shell scripts
/// Tests cover: file existence, shebang, syntax patterns, and best practices.
void main() {
  group('Shell Scripts Validation', () {
    late File runTestsScript;
    late File runValidationScript;

    setUpAll(() {
      runTestsScript = File('run_tests.sh');
      runValidationScript = File('run_validation_tests.sh');
    });

    group('File Existence', () {
      test('run_tests.sh should exist', () {
        expect(runTestsScript.existsSync(), isTrue,
            reason: 'run_tests.sh should exist in repository root');
      });

      test('run_validation_tests.sh should exist', () {
        expect(runValidationScript.existsSync(), isTrue,
            reason: 'run_validation_tests.sh should exist in repository root');
      });
    });

    group('Shebang Validation', () {
      test('run_tests.sh should have proper shebang', () {
        if (!runTestsScript.existsSync()) return;

        final lines = runTestsScript.readAsLinesSync();
        expect(lines, isNotEmpty);
        expect(lines.first, startsWith('#!/'),
            reason: 'Should start with shebang');
        expect(lines.first.toLowerCase(), contains('bash'),
            reason: 'Should use bash');
      });

      test('run_validation_tests.sh should have proper shebang', () {
        if (!runValidationScript.existsSync()) return;

        final lines = runValidationScript.readAsLinesSync();
        expect(lines, isNotEmpty);
        expect(lines.first, startsWith('#!/'),
            reason: 'Should start with shebang');
        expect(lines.first.toLowerCase(), contains('bash'),
            reason: 'Should use bash');
      });
    });

    group('Content Validation', () {
      test('run_tests.sh should check for tests directory', () {
        if (!runTestsScript.existsSync()) return;

        final content = runTestsScript.readAsStringSync();
        expect(content, contains('tests'),
            reason: 'Should reference tests directory');
      });

      test('run_tests.sh should run Python tests', () {
        if (!runTestsScript.existsSync()) return;

        final content = runTestsScript.readAsStringSync();
        expect(
            content.contains('pytest') || content.contains('unittest'), isTrue,
            reason: 'Should run Python tests');
      });

      test('run_validation_tests.sh should check Flutter installation', () {
        if (!runValidationScript.existsSync()) return;

        final content = runValidationScript.readAsStringSync();
        expect(content, contains('flutter'),
            reason: 'Should reference Flutter');
        expect(content, contains('command'),
            reason: 'Should check if Flutter is available');
      });

      test('run_validation_tests.sh should have error handling', () {
        if (!runValidationScript.existsSync()) return;

        final content = runValidationScript.readAsStringSync();
        expect(content, contains('set -e'),
            reason: 'Should exit on error');
      });

      test('run_validation_tests.sh should get dependencies', () {
        if (!runValidationScript.existsSync()) return;

        final content = runValidationScript.readAsStringSync();
        expect(content, contains('flutter pub get'),
            reason: 'Should fetch dependencies');
      });

      test('run_validation_tests.sh should run config validation tests', () {
        if (!runValidationScript.existsSync()) return;

        final content = runValidationScript.readAsStringSync();
        expect(content, contains('flutter test'));
        expect(content, contains('test/config_validation'));
      });
    });

    group('Best Practices', () {
      test('scripts should have descriptive comments', () {
        for (final script in [runTestsScript, runValidationScript]) {
          if (!script.existsSync()) continue;

          final content = script.readAsStringSync();
          final commentCount = '#'.allMatches(content).length;
          expect(commentCount, greaterThan(0),
              reason: '${script.path} should have comments');
        }
      });

      test('scripts should have echo statements for user feedback', () {
        for (final script in [runTestsScript, runValidationScript]) {
          if (!script.existsSync()) continue;

          final content = script.readAsStringSync();
          expect(content, contains('echo'),
              reason: '${script.path} should have output messages');
        }
      });

      test('scripts should indicate completion', () {
        for (final script in [runTestsScript, runValidationScript]) {
          if (!script.existsSync()) continue;

          final content = script.readAsStringSync().toLowerCase();
          expect(
              content.contains('complete') ||
                  content.contains('done') ||
                  content.contains('finished'),
              isTrue,
              reason: '${script.path} should indicate completion');
        }
      });

      test('scripts should not have hardcoded absolute paths', () {
        for (final script in [runTestsScript, runValidationScript]) {
          if (!script.existsSync()) continue;

          final content = script.readAsStringSync();
          final problematicPaths = ['/home/', '/Users/', 'C:\\'];

          for (final path in problematicPaths) {
            expect(content, isNot(contains(path)),
                reason:
                    '${script.path} should not have hardcoded path: $path');
          }
        }
      });
    });

    group('Error Handling', () {
      test('run_tests.sh should handle missing dependencies gracefully', () {
        if (!runTestsScript.existsSync()) return;

        final content = runTestsScript.readAsStringSync();
        expect(
            content.contains('2>/dev/null') || content.contains('if'), isTrue,
            reason: 'Should handle missing dependencies');
      });

      test('run_validation_tests.sh should exit on Flutter not found', () {
        if (!runValidationScript.existsSync()) return;

        final content = runValidationScript.readAsStringSync();
        expect(content, contains('exit'),
            reason: 'Should exit if Flutter not found');
      });
    });

    group('Integration', () {
      test('scripts should reference correct test directories', () {
        if (runValidationScript.existsSync()) {
          final content = runValidationScript.readAsStringSync();
          expect(content, contains('test/config_validation'),
              reason: 'Should reference correct test path');
        }
      });

      test('scripts should not conflict with each other', () {
        if (!runTestsScript.existsSync() ||
            !runValidationScript.existsSync()) {
          return;
        }

        // Both scripts should be independently runnable
        final runTestsContent = runTestsScript.readAsStringSync();
        final runValidationContent = runValidationScript.readAsStringSync();

        // Should not modify same files or have conflicting operations
        expect(runTestsContent, isNot(contains('flutter test')),
            reason:
                'run_tests.sh should not run Flutter tests (run_validation_tests.sh does)');
      });
    });
  });
}