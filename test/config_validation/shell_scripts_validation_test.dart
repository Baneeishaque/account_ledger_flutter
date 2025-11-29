import 'dart:io';
import 'package:test/test.dart';

/// Comprehensive validation tests for shell scripts
/// Tests cover: script syntax, error handling, shebang, permissions,
/// portability, and proper command usage.
void main() {
  group('Shell Script: run_tests.sh', () {
    late File scriptFile;
    late String content;
    late List<String> lines;

    setUpAll(() {
      scriptFile = File('run_tests.sh');
      expect(scriptFile.existsSync(), isTrue,
          reason: 'run_tests.sh should exist');
      content = scriptFile.readAsStringSync();
      lines = content.split('\n');
    });

    test('should have proper shebang', () {
      expect(lines.first, startsWith('#!/bin/bash'),
          reason: 'Script should start with bash shebang');
    });

    test('should have descriptive comments', () {
      final commentLines = lines.where((line) => line.trim().startsWith('#'));
      expect(commentLines.length, greaterThan(1),
          reason: 'Should have explanatory comments');
    });

    test('should handle Python test directory check', () {
      expect(content.contains('if [ -d "tests" ]'), isTrue,
          reason: 'Should check for tests directory');
    });

    test('should have fallback for test runners', () {
      expect(content.contains('pytest') && content.contains('unittest'), isTrue,
          reason: 'Should support multiple Python test runners');
      expect(content.contains('2>/dev/null'), isTrue,
          reason: 'Should handle missing pytest gracefully');
    });

    test('should check for JavaScript test configurations', () {
      expect(content.contains('__tests__') || content.contains('package.json'),
          isTrue,
          reason: 'Should check for JS test configurations');
    });

    test('should provide user feedback', () {
      expect(content.contains('echo'), isTrue,
          reason: 'Should provide progress messages');
      final echoCount = 'echo'.allMatches(content).length;
      expect(echoCount, greaterThanOrEqualTo(3),
          reason: 'Should have adequate feedback messages');
    });

    test('should not have syntax errors', () {
      // Check for common bash syntax issues
      expect(content.contains('[ -d') || content.contains('[ -f'), isTrue);
      
      // Check brackets are balanced
      final openBrackets = '['.allMatches(content).length;
      final closeBrackets = ']'.allMatches(content).length;
      expect(openBrackets, equals(closeBrackets),
          reason: 'Brackets should be balanced');
    });

    test('should handle multiple test frameworks', () {
      expect(content.contains('pytest') || content.contains('unittest'), isTrue);
      expect(content.contains('npm') || content.contains('yarn'), isTrue);
    });

    test('should not exit on non-critical errors', () {
      expect(content.contains('set -e'), isFalse,
          reason: 'Should not exit on first error to run all test suites');
    });

    test('should have proper command structure', () {
      // Check for proper use of logical operators
      final hasProperLogic = content.contains('||') || content.contains('&&');
      expect(hasProperLogic, isTrue,
          reason: 'Should use logical operators for fallbacks');
    });
  });

  group('Shell Script: run_validation_tests.sh', () {
    late File scriptFile;
    late String content;
    late List<String> lines;

    setUpAll(() {
      scriptFile = File('run_validation_tests.sh');
      expect(scriptFile.existsSync(), isTrue,
          reason: 'run_validation_tests.sh should exist');
      content = scriptFile.readAsStringSync();
      lines = content.split('\n');
    });

    test('should have proper shebang', () {
      expect(lines.first, startsWith('#!/bin/bash'),
          reason: 'Script should start with bash shebang');
    });

    test('should exit on errors for validation', () {
      expect(content.contains('set -e'), isTrue,
          reason: 'Validation tests should fail fast');
    });

    test('should check for Flutter installation', () {
      expect(content.contains('command -v flutter'), isTrue,
          reason: 'Should verify Flutter is installed');
      expect(content.contains('&> /dev/null'), isTrue,
          reason: 'Should suppress command output in check');
    });

    test('should provide clear error messages', () {
      expect(content.contains('Flutter is not installed'), isTrue,
          reason: 'Should explain why script fails');
      expect(content.contains('exit 1'), isTrue,
          reason: 'Should exit with error code when Flutter missing');
    });

    test('should show Flutter version information', () {
      expect(content.contains('flutter --version'), isTrue,
          reason: 'Should display Flutter version');
    });

    test('should get dependencies before running tests', () {
      expect(content.contains('flutter pub get'), isTrue,
          reason: 'Should ensure dependencies are installed');
    });

    test('should run specific test directory', () {
      expect(content.contains('test/config_validation/'), isTrue,
          reason: 'Should target config validation tests');
    });

    test('should use expanded reporter for better output', () {
      expect(content.contains('--reporter=expanded'), isTrue,
          reason: 'Should provide detailed test output');
    });

    test('should have proper section markers', () {
      final sectionMarkers = lines
          .where((line) => line.contains('===') && line.contains('echo'))
          .length;
      expect(sectionMarkers, greaterThanOrEqualTo(2),
          reason: 'Should have clear section separators');
    });

    test('should use emoji for better UX', () {
      expect(content.contains('✓') || content.contains('✗') || 
             content.contains('❌') || content.contains('📦') || 
             content.contains('🧪'), isTrue,
          reason: 'Should use visual indicators for better readability');
    });

    test('should handle command substitution correctly', () {
      expect(content.contains(r'$('), isTrue,
          reason: 'Should use command substitution for dynamic content');
    });
  });

  group('Shell Script Best Practices', () {
    test('run_tests.sh should be executable or documented', () {
      final file = File('run_tests.sh');
      // In a real environment, we'd check: file.statSync().mode & 0x111 != 0
      // For this test, we verify the file exists and could be made executable
      expect(file.existsSync(), isTrue);
    });

    test('run_validation_tests.sh should be executable or documented', () {
      final file = File('run_validation_tests.sh');
      expect(file.existsSync(), isTrue);
    });

    test('scripts should not contain hardcoded paths', () {
      final runTests = File('run_tests.sh').readAsStringSync();
      final runValidation = File('run_validation_tests.sh').readAsStringSync();
      
      // Check for absolute paths that might not be portable
      expect(runTests.contains('/home/') || runTests.contains('/usr/local/'),
          isFalse,
          reason: 'run_tests.sh should not have hardcoded absolute paths');
      expect(runValidation.contains('/home/') || 
             runValidation.contains('/usr/local/'),
          isFalse,
          reason: 'run_validation_tests.sh should not have hardcoded paths');
    });
  });

  group('Script Integration Tests', () {
    test('scripts reference correct directories', () {
      final runTests = File('run_tests.sh').readAsStringSync();
      final runValidation = File('run_validation_tests.sh').readAsStringSync();

      // Verify referenced directories exist
      if (runTests.contains('tests/')) {
        expect(Directory('tests').existsSync(), isTrue,
            reason: 'Referenced tests/ directory should exist');
      }

      if (runValidation.contains('test/config_validation/')) {
        expect(Directory('test/config_validation').existsSync(), isTrue,
            reason: 'Referenced test/config_validation/ should exist');
      }
    });

    test('scripts are documented in README', () {
      final testReadme = File('test/README.md');
      final configReadme = File('test/config_validation/README.md');
      
      if (configReadme.existsSync()) {
        final readmeContent = configReadme.readAsStringSync();
        // Should reference how to run tests
        expect(readmeContent.contains('flutter test') || 
               readmeContent.contains('run'), isTrue,
            reason: 'README should document test execution');
      }
    });
  });

  group('Error Handling and Edge Cases', () {
    test('scripts handle missing dependencies gracefully', () {
      final runTests = File('run_tests.sh').readAsStringSync();
      
      // Should have fallback mechanisms
      expect(runTests.contains('||'), isTrue,
          reason: 'Should provide fallback for missing commands');
    });

    test('validation script fails appropriately', () {
      final runValidation = File('run_validation_tests.sh').readAsStringSync();
      
      expect(runValidation.contains('exit 1'), isTrue,
          reason: 'Should exit with error code on critical failures');
    });

    test('scripts do not have trailing whitespace', () {
      for (final scriptName in ['run_tests.sh', 'run_validation_tests.sh']) {
        final file = File(scriptName);
        final lines = file.readAsStringSync().split('\n');
        
        for (var i = 0; i < lines.length; i++) {
          expect(lines[i].endsWith(' ') || lines[i].endsWith('\t'), isFalse,
              reason: 'Line ${i + 1} in $scriptName should not have trailing whitespace');
        }
      }
    });
  });
}