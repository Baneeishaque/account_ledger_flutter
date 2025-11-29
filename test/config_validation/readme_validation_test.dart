import 'dart:io';
import 'package:test/test.dart';

/// Comprehensive validation tests for README documentation files
void main() {
  group('README Files Validation', () {
    late File testReadme;
    late File configReadme;

    setUpAll(() {
      testReadme = File('test/README.md');
      configReadme = File('test/config_validation/README.md');
    });

    test('test README.md should exist', () {
      expect(testReadme.existsSync(), isTrue,
          reason: 'test/README.md should exist');
    });

    test('config_validation README.md should exist', () {
      expect(configReadme.existsSync(), isTrue,
          reason: 'test/config_validation/README.md should exist');
    });

    test('README files should not be empty', () {
      if (testReadme.existsSync()) {
        final content = testReadme.readAsStringSync().trim();
        expect(content, isNotEmpty, reason: 'test/README.md should not be empty');
      }

      if (configReadme.existsSync()) {
        final content = configReadme.readAsStringSync().trim();
        expect(content, isNotEmpty,
            reason: 'config_validation/README.md should not be empty');
      }
    });

    test('README files should start with heading', () {
      if (testReadme.existsSync()) {
        final lines = testReadme.readAsLinesSync();
        expect(lines.first, startsWith('#'),
            reason: 'README should start with markdown heading');
      }

      if (configReadme.existsSync()) {
        final lines = configReadme.readAsLinesSync();
        expect(lines.first, startsWith('#'),
            reason: 'config_validation README should start with heading');
      }
    });

    test('config_validation README should have required sections', () {
      if (!configReadme.existsSync()) return;

      final content = configReadme.readAsStringSync();

      final requiredSections = [
        'Test Files',
        'Running the Tests',
        'Test Coverage',
        'azure_pipelines_validation_test.dart',
        'copilot_instructions_validation_test.dart',
      ];

      for (final section in requiredSections) {
        expect(content, contains(section),
            reason: 'Should have section: $section');
      }
    });

    test('config_validation README should document test commands', () {
      if (!configReadme.existsSync()) return;

      final content = configReadme.readAsStringSync();

      expect(content, contains('flutter test'),
          reason: 'Should document flutter test command');
      expect(content, contains('--reporter=expanded'),
          reason: 'Should mention expanded reporter');
    });

    test('config_validation README should list test coverage areas', () {
      if (!configReadme.existsSync()) return;

      final content = configReadme.readAsStringSync();

      final coverageAreas = [
        'Syntax',
        'Structure',
        'Security',
        'Best practices',
      ];

      for (final area in coverageAreas) {
        expect(content.toLowerCase(), contains(area.toLowerCase()),
            reason: 'Should mention coverage area: $area');
      }
    });

    test('README files should have reasonable length', () {
      if (testReadme.existsSync()) {
        final lines = testReadme.readAsLinesSync();
        expect(lines.length, greaterThan(2),
            reason: 'test/README.md should have content');
      }

      if (configReadme.existsSync()) {
        final lines = configReadme.readAsLinesSync();
        expect(lines.length, greaterThan(10),
            reason: 'config_validation/README.md should be comprehensive');
      }
    });

    test('README files should use proper markdown formatting', () {
      if (configReadme.existsSync()) {
        final content = configReadme.readAsStringSync();

        // Check for code blocks
        final codeBlockCount = '```'.allMatches(content).length;
        expect(codeBlockCount % 2, equals(0),
            reason: 'Code block markers should be balanced');

        // Check for proper list formatting
        final lines = content.split('\n');
        for (final line in lines) {
          if (line.trim().startsWith('- ') || line.trim().startsWith('* ')) {
            // Lists should be properly formatted
            expect(line.contains('  -') || line.startsWith('- ') || line.startsWith('* '),
                isTrue,
                reason: 'List items should be properly formatted');
          }
        }
      }
    });

    test('config_validation README should reference actual test files', () {
      if (!configReadme.existsSync()) return;

      final content = configReadme.readAsStringSync();

      // Should reference the actual test files
      final testFiles = [
        'azure_pipelines_validation_test.dart',
        'copilot_instructions_validation_test.dart',
      ];

      for (final testFile in testFiles) {
        expect(content, contains(testFile),
            reason: 'Should reference test file: $testFile');

        // Verify the referenced file actually exists
        final file = File('test/config_validation/$testFile');
        expect(file.existsSync(), isTrue,
            reason: 'Referenced test file should exist: $testFile');
      }
    });

    test('README should document how to add new tests', () {
      if (!configReadme.existsSync()) return;

      final content = configReadme.readAsStringSync();

      expect(content.toLowerCase(), contains('adding'),
          reason: 'Should explain how to add new tests');
    });
  });

  group('README Content Quality', () {
    test('config_validation README should explain test purpose', () {
      final configReadme = File('test/config_validation/README.md');
      if (!configReadme.existsSync()) return;

      final content = configReadme.readAsStringSync().toLowerCase();

      final keyTerms = [
        'validation',
        'configuration',
        'test',
      ];

      for (final term in keyTerms) {
        expect(content, contains(term),
            reason: 'Should explain purpose using term: $term');
      }
    });

    test('README should provide examples', () {
      final configReadme = File('test/config_validation/README.md');
      if (!configReadme.existsSync()) return;

      final content = configReadme.readAsStringSync();

      // Should have code examples (backticks or code blocks)
      expect('`'.allMatches(content).length > 0 || content.contains('```'), isTrue,
          reason: 'Should provide code examples');
    });
  });
}