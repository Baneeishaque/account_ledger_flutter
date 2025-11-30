import 'dart:io';
import 'package:test/test.dart';

/// Comprehensive validation tests for README files
/// Tests cover: file existence, markdown structure, content quality,
/// completeness, and cross-references.
void main() {
  group('test/README.md Validation', () {
    late File readmeFile;
    late String content;
    late List<String> lines;

    setUpAll(() {
      readmeFile = File('test/README.md');
      expect(readmeFile.existsSync(), isTrue,
          reason: 'test/README.md should exist');
      content = readmeFile.readAsStringSync();
      lines = content.split('\n');
    });

    test('should not be empty', () {
      expect(content.trim(), isNotEmpty);
    });

    test('should start with a heading', () {
      expect(lines.first.startsWith('#'), isTrue,
          reason: 'README should start with a heading');
    });

    test('should describe the test suite', () {
      expect(content.toLowerCase().contains('test'), isTrue);
    });

    test('should have reasonable content length', () {
      expect(content.length, greaterThan(50),
          reason: 'README should have meaningful documentation');
    });

    test('should have proper markdown structure', () {
      // Check for headings
      final headings = lines.where((l) => l.startsWith('#'));
      expect(headings, isNotEmpty,
          reason: 'Should have section headings');
    });

    test('should reference test directory structure', () {
      expect(content.toLowerCase().contains('directory') ||
             content.toLowerCase().contains('structure') ||
             content.toLowerCase().contains('organization'), isTrue,
          reason: 'Should document test organization');
    });
  });

  group('test/config_validation/README.md Validation', () {
    late File readmeFile;
    late String content;
    late List<String> lines;

    setUpAll(() {
      readmeFile = File('test/config_validation/README.md');
      expect(readmeFile.existsSync(), isTrue,
          reason: 'test/config_validation/README.md should exist');
      content = readmeFile.readAsStringSync();
      lines = content.split('\n');
    });

    test('should not be empty', () {
      expect(content.trim(), isNotEmpty);
    });

    test('should start with main heading', () {
      expect(lines.first.startsWith('# '), isTrue);
    });

    test('should document test files', () {
      expect(content.contains('azure_pipelines_validation_test.dart'), isTrue,
          reason: 'Should list azure pipelines test file');
      expect(content.contains('copilot_instructions_validation_test.dart'),
          isTrue,
          reason: 'Should list copilot instructions test file');
    });

    test('should have "Test Files" section', () {
      expect(content.contains('## Test Files'), isTrue,
          reason: 'Should have dedicated section for test files');
    });

    test('should have "Running the Tests" section', () {
      expect(content.contains('## Running'), isTrue,
          reason: 'Should document how to run tests');
    });

    test('should provide flutter test commands', () {
      expect(content.contains('flutter test'), isTrue,
          reason: 'Should show how to run tests');
    });

    test('should document test coverage', () {
      expect(content.contains('## Test Coverage') ||
             content.contains('Coverage'), isTrue,
          reason: 'Should document what tests cover');
    });

    test('should have code blocks for commands', () {
      expect(content.contains('```'), isTrue,
          reason: 'Should use code blocks for commands');
    });

    test('should document each test file purpose', () {
      // Should describe what each test file validates
      final hasDescriptions = content.contains('Validates') ||
                              content.contains('validates') ||
                              content.contains('Tests');
      expect(hasDescriptions, isTrue,
          reason: 'Should describe test purposes');
    });

    test('should list what is being tested', () {
      expect(content.contains('YAML') || content.contains('syntax'), isTrue);
      expect(content.contains('Markdown') || content.contains('structure'),
          isTrue);
    });

    test('should have "Adding New Tests" guidance', () {
      expect(content.contains('Adding') && content.contains('Tests'), isTrue,
          reason: 'Should guide contributors on adding tests');
    });

    test('should document best practices', () {
      expect(content.contains('best practices') ||
             content.contains('conventions') ||
             content.contains('should'), isTrue);
    });

    test('should use checkmark emoji for coverage items', () {
      expect(content.contains('✅'), isTrue,
          reason: 'Should use visual indicators for coverage items');
    });
  });

  group('README Markdown Quality', () {
    test('test/README.md should not have trailing whitespace', () {
      if (!File('test/README.md').existsSync()) return;
      
      final lines = File('test/README.md').readAsStringSync().split('\n');
      for (var i = 0; i < lines.length; i++) {
        expect(lines[i].endsWith(' '), isFalse,
            reason: 'Line ${i + 1} should not have trailing whitespace');
      }
    });

    test('config_validation README should not have trailing whitespace', () {
      final file = File('test/config_validation/README.md');
      final lines = file.readAsStringSync().split('\n');
      
      for (var i = 0; i < lines.length; i++) {
        expect(lines[i].endsWith(' '), isFalse,
            reason: 'Line ${i + 1} should not have trailing whitespace');
      }
    });

    test('should have consistent heading levels', () {
      final file = File('test/config_validation/README.md');
      final content = file.readAsStringSync();
      final lines = content.split('\n');
      
      final headingPattern = RegExp(r'^(#{1,6})\s');
      int previousLevel = 0;
      
      for (final line in lines) {
        final match = headingPattern.firstMatch(line);
        if (match != null) {
          final level = match.group(1)!.length;
          if (previousLevel > 0) {
            expect(level - previousLevel, lessThanOrEqualTo(1),
                reason: 'Should not skip heading levels');
          }
          previousLevel = level;
        }
      }
    });
  });

  group('README Cross-References', () {
    test('should reference actual test files', () {
      final readme = File('test/config_validation/README.md');
      final content = readme.readAsStringSync();
      
      // Extract mentioned test files
      if (content.contains('azure_pipelines_validation_test.dart')) {
        expect(File('test/config_validation/azure_pipelines_validation_test.dart')
            .existsSync(), isTrue,
            reason: 'Referenced test file should exist');
      }
      
      if (content.contains('copilot_instructions_validation_test.dart')) {
        expect(File('test/config_validation/copilot_instructions_validation_test.dart')
            .existsSync(), isTrue,
            reason: 'Referenced test file should exist');
      }
    });

    test('should reference correct command paths', () {
      final readme = File('test/config_validation/README.md');
      final content = readme.readAsStringSync();
      
      if (content.contains('test/config_validation/')) {
        expect(Directory('test/config_validation').existsSync(), isTrue,
            reason: 'Referenced directory should exist');
      }
    });
  });

  group('Documentation Completeness', () {
    test('config_validation README should document all test aspects', () {
      final readme = File('test/config_validation/README.md');
      final content = readme.readAsStringSync();
      
      final requiredSections = [
        'Test Files',
        'Running',
        'Coverage',
        'Adding',
      ];
      
      for (final section in requiredSections) {
        expect(content.contains(section), isTrue,
            reason: 'Should have "$section" section or content');
      }
    });

    test('should provide examples', () {
      final readme = File('test/config_validation/README.md');
      final content = readme.readAsStringSync();
      
      expect(content.contains('```'), isTrue,
          reason: 'Should have code examples');
    });

    test('should explain test purpose', () {
      final readme = File('test/config_validation/README.md');
      final content = readme.readAsStringSync();
      
      expect(content.toLowerCase().contains('validation') ||
             content.toLowerCase().contains('verify') ||
             content.toLowerCase().contains('ensure'), isTrue,
          reason: 'Should explain validation purpose');
    });
  });

  group('README Consistency', () {
    test('both READMEs should follow similar structure', () {
      final testReadme = File('test/README.md');
      final configReadme = File('test/config_validation/README.md');
      
      if (!testReadme.existsSync()) return;
      
      final testContent = testReadme.readAsStringSync();
      final configContent = configReadme.readAsStringSync();
      
      // Both should start with # heading
      expect(testContent.trimLeft().startsWith('#'), isTrue);
      expect(configContent.trimLeft().startsWith('#'), isTrue);
    });

    test('should use consistent formatting style', () {
      final readme = File('test/config_validation/README.md');
      final content = readme.readAsStringSync();
      
      // Check for consistent list markers
      final listItems = content.split('\n')
          .where((line) => line.trim().startsWith('- ') || 
                          line.trim().startsWith('* '));
      
      if (listItems.isNotEmpty) {
        final firstMarker = listItems.first.trim()[0];
        for (final item in listItems) {
          if (item.trim().isNotEmpty && 
              (item.trim().startsWith('-') || item.trim().startsWith('*'))) {
            expect(item.trim()[0], equals(firstMarker),
                reason: 'Should use consistent list markers');
          }
        }
      }
    });
  });
}