import 'dart:io';
import 'package:test/test.dart';

/// Comprehensive validation tests for README files
/// Tests cover: file existence, structure, content, and cross-references.
void main() {
  group('README Files Validation', () {
    late File testReadme;
    late File configReadme;

    setUpAll(() {
      testReadme = File('test/README.md');
      configReadme = File('test/config_validation/README.md');
    });

    group('File Existence', () {
      test('test/README.md should exist', () {
        expect(testReadme.existsSync(), isTrue,
            reason: 'test/README.md should exist');
      });

      test('test/config_validation/README.md should exist', () {
        expect(configReadme.existsSync(), isTrue,
            reason: 'test/config_validation/README.md should exist');
      });
    });

    group('Content Structure', () {
      test('README files should not be empty', () {
        for (final readme in [testReadme, configReadme]) {
          if (!readme.existsSync()) continue;

          final content = readme.readAsStringSync().trim();
          expect(content, isNotEmpty,
              reason: '${readme.path} should have content');
        }
      });

      test('README files should have headings', () {
        for (final readme in [testReadme, configReadme]) {
          if (!readme.existsSync()) continue;

          final content = readme.readAsStringSync();
          expect(content, contains('#'),
              reason: '${readme.path} should have markdown headings');
        }
      });

      test('config README should start with title', () {
        if (!configReadme.existsSync()) return;

        final lines = configReadme.readAsLinesSync();
        expect(lines.first, startsWith('#'),
            reason: 'Should start with heading');
      });
    });

    group('Documentation Quality', () {
      test('config README should document test files', () {
        if (!configReadme.existsSync()) return;

        final content = configReadme.readAsStringSync();

        expect(content, contains('azure_pipelines_validation_test.dart'),
            reason: 'Should document azure pipelines test');
        expect(content, contains('copilot_instructions_validation_test.dart'),
            reason: 'Should document copilot instructions test');
      });

      test('config README should have running instructions', () {
        if (!configReadme.existsSync()) return;

        final content = configReadme.readAsStringSync();

        expect(content, contains('flutter test'),
            reason: 'Should provide test running instructions');
      });

      test('config README should list test coverage areas', () {
        if (!configReadme.existsSync()) return;

        final content = configReadme.readAsStringSync();

        final coverageAreas = [
          'Syntax',
          'Structure',
          'Required',
          'Security',
          'Best practices'
        ];

        for (final area in coverageAreas) {
          expect(content, contains(RegExp(area, caseSensitive: false)),
              reason: 'Should mention $area coverage');
        }
      });
    });

    group('Markdown Formatting', () {
      test('code blocks should be balanced', () {
        for (final readme in [testReadme, configReadme]) {
          if (!readme.existsSync()) continue;

          final content = readme.readAsStringSync();
          final fenceCount = '```'.allMatches(content).length;

          expect(fenceCount % 2, equals(0),
              reason: '${readme.path} should have balanced code fences');
        }
      });

      test('should not have trailing whitespace', () {
        for (final readme in [testReadme, configReadme]) {
          if (!readme.existsSync()) continue;

          final lines = readme.readAsLinesSync();

          for (var i = 0; i < lines.length; i++) {
            final line = lines[i];
            if (line.isNotEmpty && line != line.trimRight()) {
              fail('${readme.path} line ${i + 1} has trailing whitespace');
            }
          }
        }
      });
    });

    group('Cross-References', () {
      test('config README should reference actual test files', () {
        if (!configReadme.existsSync()) return;

        final content = configReadme.readAsStringSync();

        // Extract mentioned file names
        final testFilePattern = RegExp(r'(\w+_test\.dart)');
        final matches = testFilePattern.allMatches(content);

        for (final match in matches) {
          final fileName = match.group(1);
          final testFile = File('test/config_validation/$fileName');

          expect(testFile.existsSync(), isTrue,
              reason: 'Referenced file $fileName should exist');
        }
      });

      test('README should provide correct relative paths', () {
        if (!configReadme.existsSync()) return;

        final content = configReadme.readAsStringSync();

        // Check for flutter test commands
        if (content.contains('flutter test')) {
          expect(content, contains('test/config_validation'),
              reason: 'Should use correct test path');
        }
      });
    });

    group('Completeness', () {
      test('config README should document all test files in directory', () {
        if (!configReadme.existsSync()) return;

        final content = configReadme.readAsStringSync();
        final configDir = Directory('test/config_validation');

        if (!configDir.existsSync()) return;

        final testFiles = configDir
            .listSync()
            .where((f) => f is File && f.path.endsWith('_test.dart'))
            .map((f) => f.path.split('/').last);

        for (final testFile in testFiles) {
          expect(content, contains(testFile),
              reason: 'Should document $testFile');
        }
      });
    });
  });
}