import 'dart:io';
import 'package:test/test.dart';

/// Comprehensive validation tests for .github/copilot-instructions.md
/// Tests cover: file existence, markdown syntax, required sections,
/// content structure, link validity, and formatting consistency.
void main() {
  late File instructionsFile;

  setUpAll(() {
    instructionsFile = File('.github/copilot-instructions.md');
  });

  group('File Existence and Basic Validation', () {
    test('should exist in correct location', () {
      expect(instructionsFile.existsSync(), isTrue,
          reason: 'copilot-instructions.md should exist in .github directory');
    });

    test('should not be empty', () {
      final content = instructionsFile.readAsStringSync();
      expect(content.trim(), isNotEmpty,
          reason: 'File should contain instructions');
    });

    test('should have reasonable file size', () {
      final size = instructionsFile.lengthSync();
      expect(size, greaterThan(100),
          reason: 'Should have meaningful content');
      expect(size, lessThan(100000),
          reason: 'Should not be excessively large');
    });
  });

  group('Markdown Structure Validation', () {
    late String content;
    late List<String> lines;

    setUp(() {
      content = instructionsFile.readAsStringSync();
      lines = content.split('\n');
    });

    test('should start with level 1 heading', () {
      expect(lines.first.startsWith('# '), isTrue,
          reason: 'Document should start with main heading');
    });

    test('should have proper heading hierarchy', () {
      final headingPattern = RegExp(r'^#{1,6}\s+');
      final headings = lines.where((line) => headingPattern.hasMatch(line));

      expect(headings, isNotEmpty, reason: 'Should have section headings');

      // Check heading levels are sequential (no skipping levels)
      int previousLevel = 0;
      for (final heading in headings) {
        final level = heading.indexOf(' ');
        if (previousLevel > 0) {
          expect(level - previousLevel, lessThanOrEqualTo(1),
              reason: 'Should not skip heading levels');
        }
        previousLevel = level;
      }
    });

    test('should have consistent list formatting', () {
      final listItems = lines.where((line) =>
          line.trim().startsWith('- ') || line.trim().startsWith('* '));

      if (listItems.isNotEmpty) {
        // All list items should use the same marker (- or *)
        final firstMarker = listItems.first.trim()[0];
        for (final item in listItems) {
          if (item.trim().startsWith('-') || item.trim().startsWith('*')) {
            expect(item.trim()[0], equals(firstMarker),
                reason: 'List items should use consistent markers');
          }
        }
      }
    });

    test('should not have trailing whitespace', () {
      for (var i = 0; i < lines.length; i++) {
        expect(lines[i].endsWith(' '), isFalse,
            reason: 'Line ${i + 1} should not have trailing whitespace');
      }
    });
  });

  group('Required Sections Validation', () {
    late String content;

    setUp(() {
      content = instructionsFile.readAsStringSync();
    });

    test('should have Branch Safety section', () {
      expect(content.contains('Branch Safety'), isTrue,
          reason: 'Must document branch safety practices');
    });

    test('should have Project Overview section', () {
      expect(content.contains('Project Overview'), isTrue,
          reason: 'Must provide project overview');
    });

    test('should have Key Architecture & Patterns section', () {
      expect(content.contains('Key Architecture'), isTrue,
          reason: 'Must document architecture patterns');
    });

    test('should have Developer Workflows section', () {
      expect(content.contains('Developer Workflows'), isTrue,
          reason: 'Must document development workflows');
    });

    test('should have Project Conventions section', () {
      expect(content.contains('Project Conventions'), isTrue,
          reason: 'Must document coding conventions');
    });

    test('should have Integration Points section', () {
      expect(content.contains('Integration Points'), isTrue,
          reason: 'Must document integration points');
    });

    test('should have Examples section', () {
      expect(content.contains('Examples'), isTrue,
          reason: 'Must provide usage examples');
    });

    test('should have References section', () {
      expect(content.contains('References'), isTrue,
          reason: 'Must provide references to key files');
    });
  });

  group('Content Quality Validation', () {
    late String content;

    setUp(() {
      content = instructionsFile.readAsStringSync();
    });

    test('should mention Flutter', () {
      expect(content.toLowerCase().contains('flutter'), isTrue,
          reason: 'Should explicitly mention Flutter framework');
    });

    test('should reference key directories', () {
      final keyDirs = ['lib/', 'android/', 'ios/', 'web/'];
      for (final dir in keyDirs) {
        expect(content.contains(dir), isTrue,
            reason: 'Should reference $dir directory');
      }
    });

    test('should reference important files', () {
      final importantFiles = ['main.dart', 'pubspec.yaml'];
      for (final file in importantFiles) {
        expect(content.contains(file), isTrue,
            reason: 'Should reference $file');
      }
    });

    test('should provide actionable instructions', () {
      // Check for command examples
      final hasCommands = content.contains('flutter build') ||
          content.contains('flutter run') ||
          content.contains('flutter pub get');

      expect(hasCommands, isTrue,
          reason: 'Should provide Flutter command examples');
    });

    test('should have proper code formatting', () {
      // Check for inline code markers
      final inlineCodeCount = '`'.allMatches(content).length;
      expect(inlineCodeCount % 2, equals(0),
          reason: 'Inline code markers should be balanced');
    });
  });

  group('Branch Safety Instructions Validation', () {
    late String content;

    setUp(() {
      content = instructionsFile.readAsStringSync();
    });

    test('should emphasize branch safety', () {
      final branchSafetySection = content.split('## Branch Safety')[1];
      expect(branchSafetySection, isNotNull);

      expect(branchSafetySection.toLowerCase().contains('master'), isTrue,
          reason: 'Should mention master branch');
      expect(
          branchSafetySection.toLowerCase().contains('feature') ||
              branchSafetySection.toLowerCase().contains('pull request'),
          isTrue,
          reason: 'Should mention feature/PR branches');
    });

    test('should warn about master branch changes', () {
      final content = instructionsFile.readAsStringSync();
      final lowerContent = content.toLowerCase();

      expect(
          lowerContent.contains('not master') ||
              lowerContent.contains('correct branch') ||
              lowerContent.contains('ensure'),
          isTrue,
          reason: 'Should emphasize checking the correct branch');
    });
  });

  group('Link and Reference Validation', () {
    late String content;

    setUp(() {
      content = instructionsFile.readAsStringSync();
    });

    test('should reference existing project files', () {
      // Extract file references
      final fileRefs = RegExp(r'`([^`]+\.(dart|yaml|md))`')
          .allMatches(content)
          .map((m) => m.group(1))
          .whereType<String>();

      for (final fileRef in fileRefs) {
        // Remove any path prefixes
        final fileName = fileRef.split('/').last;

        // Skip if it's an example or placeholder
        if (fileName.contains('example') || fileName.contains('your_')) {
          continue;
        }

        // Check if file exists or is mentioned as optional
        final file = File(fileRef);
        if (!file.existsSync()) {
          // It's okay if the content mentions it might not exist
          expect(
              content.contains('if needed') ||
                  content.contains('add') ||
                  content.contains('create'),
              isTrue,
              reason:
                  'Referenced file $fileRef should exist or be marked as optional');
        }
      }
    });

    test('should have valid directory references', () {
      final dirRefs = ['lib/', 'android/', 'ios/', 'web/', 'windows/', 'linux/', 'macos/'];
      
      for (final dirRef in dirRefs) {
        if (content.contains(dirRef)) {
          final dir = Directory(dirRef.replaceAll('/', ''));
          expect(dir.existsSync(), isTrue,
              reason: 'Referenced directory $dirRef should exist');
        }
      }
    });
  });

  group('Formatting Consistency', () {
    late List<String> lines;

    setUp(() {
      lines = instructionsFile.readAsStringSync().split('\n');
    });

    test('should have consistent blank lines between sections', () {
      // Headings should generally have blank line before them (except first)
      for (var i = 1; i < lines.length; i++) {
        if (lines[i].startsWith('##')) {
          // Allow for some flexibility, but generally expect blank line
          if (i > 1 && lines[i - 1].trim().isNotEmpty) {
            // This is a soft check - some variation is acceptable
            expect(
                lines[i - 2].trim().isEmpty ||
                    lines[i - 1].startsWith('#') ||
                    lines[i - 1].startsWith('---'),
                isTrue,
                reason: 'Sections should generally be separated by blank lines');
          }
        }
      }
    });

    test('should use consistent bold/italic markers', () {
      final content = instructionsFile.readAsStringSync();

      // Count marker types
      final doubleStarCount = '**'.allMatches(content).length;
      final doubleLowbarCount = '__'.allMatches(content).length;

      // Should use one style consistently
      if (doubleStarCount > 0 && doubleLowbarCount > 0) {
        expect(doubleStarCount, greaterThan(doubleLowbarCount * 10),
            reason: 'Should use ** consistently for bold rather than mixing');
      }

      // Markers should be balanced
      expect(doubleStarCount % 2, equals(0),
          reason: 'Bold markers should be balanced');
    });
  });

  group('Edge Cases and Error Handling', () {
    test('should handle Unicode characters correctly', () {
      final content = instructionsFile.readAsStringSync();

      // Should be able to read without encoding errors
      expect(() => content, returnsNormally);

      // Check for common problematic characters
      final hasSmartQuotes = content.contains('"') || content.contains('"');
      if (hasSmartQuotes) {
        // This is a warning rather than failure - smart quotes are okay in markdown
        print('Note: File contains smart quotes (")');
      }
    });

    test('should not have extremely long lines', () {
      final lines = instructionsFile.readAsStringSync().split('\n');

      for (var i = 0; i < lines.length; i++) {
        // Allow some flexibility for code examples and links
        if (!lines[i].contains('http') && !lines[i].trim().startsWith('`')) {
          expect(lines[i].length, lessThan(200),
              reason: 'Line ${i + 1} is excessively long (improves readability to keep lines shorter)');
        }
      }
    });
  });

  group('Content Completeness', () {
    late String content;

    setUp(() {
      content = instructionsFile.readAsStringSync();
    });

    test('should provide sufficient detail for AI agents', () {
      // Should have substantial content (not just headings)
      final contentWithoutHeadings = content.replaceAll(RegExp(r'^#.*$', multiLine: true), '');
      final substantiveContent = contentWithoutHeadings.replaceAll(RegExp(r'\s+'), ' ').trim();

      expect(substantiveContent.length, greaterThan(500),
          reason: 'Should have substantial instructional content');
    });

    test('should document all critical project aspects', () {
      final criticalAspects = [
        'build',
        'test',
        'dependencies',
        'navigation',
        'state',
      ];

      for (final aspect in criticalAspects) {
        expect(content.toLowerCase().contains(aspect), isTrue,
            reason: 'Should document $aspect');
      }
    });
  });
}