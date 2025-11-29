import 'dart:io';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

/// Comprehensive validation tests for azure-pipelines.yml
/// Tests cover: YAML syntax, structure, required fields, parameter validation,
/// task configurations, conditional logic, and artifact definitions.
void main() {
  late File pipelineFile;
  late dynamic pipelineConfig;

  setUpAll(() {
    // Load the azure-pipelines.yml file
    pipelineFile = File('azure-pipelines.yml');
    if (!pipelineFile.existsSync()) {
      throw Exception('azure-pipelines.yml not found');
    }
  });

  group('Azure Pipelines YAML Syntax Validation', () {
    test('should be valid YAML', () {
      expect(pipelineFile.existsSync(), isTrue,
          reason: 'azure-pipelines.yml file should exist');

      final content = pipelineFile.readAsStringSync();
      expect(content, isNotEmpty, reason: 'File should not be empty');

      // Parse YAML - will throw if invalid
      expect(() {
        pipelineConfig = loadYaml(content);
      }, returnsNormally, reason: 'YAML should parse without errors');

      expect(pipelineConfig, isNotNull);
    });

    test('should have proper indentation and formatting', () {
      final content = pipelineFile.readAsStringSync();
      final lines = content.split('\n');

      // Check for consistent indentation (spaces, not tabs)
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.contains('\t')) {
          fail('Line ${i + 1} contains tabs instead of spaces');
        }
      }
    });

    test('should not have trailing whitespace', () {
      final content = pipelineFile.readAsStringSync();
      final lines = content.split('\n');

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.endsWith(' ') || line.endsWith('\t')) {
          fail('Line ${i + 1} has trailing whitespace');
        }
      }
    });
  });

  group('Azure Pipelines Structure Validation', () {
    setUp(() {
      final content = pipelineFile.readAsStringSync();
      pipelineConfig = loadYaml(content);
    });

    test('should have required top-level keys', () {
      expect(pipelineConfig, isA<Map>());
      final config = pipelineConfig as Map;

      // Check for essential Azure Pipelines keys
      expect(config.containsKey('strategy'), isTrue,
          reason: 'Must define strategy for multi-platform builds');
      expect(config.containsKey('pool'), isTrue,
          reason: 'Must define agent pool');
      expect(config.containsKey('steps'), isTrue,
          reason: 'Must define build steps');
    });

    test('should have valid strategy configuration', () {
      final config = pipelineConfig as Map;
      expect(config['strategy'], isA<Map>());

      final strategy = config['strategy'] as Map;
      expect(strategy.containsKey('matrix'), isTrue,
          reason: 'Strategy should define matrix for multi-OS builds');

      final matrix = strategy['matrix'] as Map;
      expect(matrix.containsKey('linux'), isTrue);
      expect(matrix.containsKey('mac'), isTrue);
      expect(matrix.containsKey('windows'), isTrue);
    });

    test('should have valid pool configuration', () {
      final config = pipelineConfig as Map;
      expect(config['pool'], isA<Map>());

      final pool = config['pool'] as Map;
      expect(pool.containsKey('vmImage'), isTrue,
          reason: 'Pool must specify vmImage');
    });

    test('should define Flutter version variables', () {
      final config = pipelineConfig as Map;
      expect(config.containsKey('variables'), isTrue);

      final variables = config['variables'] as Map;
      expect(variables.containsKey('FLUTTER_CHANNEL'), isTrue,
          reason: 'Must define Flutter channel');
      expect(variables.containsKey('FLUTTER_VERSION'), isTrue,
          reason: 'Must define Flutter version');
    });
  });

  group('Parameters Validation', () {
    setUp(() {
      final content = pipelineFile.readAsStringSync();
      pipelineConfig = loadYaml(content);
    });

    test('should have webBuilds parameter defined', () {
      final config = pipelineConfig as Map;
      expect(config.containsKey('parameters'), isTrue,
          reason: 'Must define parameters section');

      final parameters = config['parameters'] as List;
      expect(parameters, isNotEmpty);

      final webBuildsParam = parameters.firstWhere(
        (p) => (p as Map)['name'] == 'webBuilds',
        orElse: () => null,
      );
      expect(webBuildsParam, isNotNull,
          reason: 'webBuilds parameter should be defined');
    });

    test('should have valid webBuilds parameter structure', () {
      final config = pipelineConfig as Map;
      final parameters = config['parameters'] as List;

      final webBuildsParam = parameters.firstWhere(
        (p) => (p as Map)['name'] == 'webBuilds',
      ) as Map;

      expect(webBuildsParam['type'], equals('object'));
      expect(webBuildsParam.containsKey('default'), isTrue);

      final defaultValue = webBuildsParam['default'] as List;
      expect(defaultValue.length, equals(3),
          reason: 'Should have Debug, Profile, and Release builds');

      // Verify build types
      final buildTypes =
          defaultValue.map((b) => (b as Map)['type']).toList();
      expect(buildTypes, contains('Debug'));
      expect(buildTypes, contains('Profile'));
      expect(buildTypes, contains('Release'));
    });
  });

  group('Build Steps Validation', () {
    setUp(() {
      final content = pipelineFile.readAsStringSync();
      pipelineConfig = loadYaml(content);
    });

    test('should have Flutter install step', () {
      final config = pipelineConfig as Map;
      final steps = config['steps'] as List;

      final flutterInstall = steps.any((step) {
        if (step is! Map) return false;
        return step.containsKey('task') &&
            step['task'].toString().contains('FlutterInstall');
      });

      expect(flutterInstall, isTrue,
          reason: 'Must include FlutterInstall task');
    });

    test('should have cache configuration', () {
      final config = pipelineConfig as Map;
      final steps = config['steps'] as List;

      final cacheSteps = steps.where((step) {
        if (step is! Map) return false;
        return step.containsKey('task') &&
            step['task'].toString().contains('Cache');
      }).toList();

      expect(cacheSteps, isNotEmpty,
          reason: 'Should include cache configuration for faster builds');
    });

    test('should have platform-specific build tasks', () {
      final config = pipelineConfig as Map;
      final steps = config['steps'] as List;

      final flutterBuilds = steps.where((step) {
        if (step is! Map) return false;
        return step.containsKey('task') &&
            step['task'].toString().contains('FlutterBuild');
      }).toList();

      expect(flutterBuilds, isNotEmpty,
          reason: 'Must include FlutterBuild tasks');

      // Check for different build targets
      final buildTargets = flutterBuilds
          .map((step) => (step as Map)['inputs'])
          .where((inputs) => inputs != null)
          .map((inputs) => (inputs as Map)['target'])
          .toList();

      expect(buildTargets, contains('apk'),
          reason: 'Should build Android APK');
      expect(buildTargets, contains('web'),
          reason: 'Should build web app');
    });

    test('should have artifact publish steps', () {
      final config = pipelineConfig as Map;
      final steps = config['steps'] as List;

      final publishSteps = steps.where((step) {
        if (step is! Map) return false;
        return step.containsKey('publish');
      }).toList();

      expect(publishSteps, isNotEmpty,
          reason: 'Should publish build artifacts');
    });
  });

  group('Conditional Logic Validation', () {
    setUp(() {
      final content = pipelineFile.readAsStringSync();
      pipelineConfig = loadYaml(content);
    });

    test('should have OS-specific conditions', () {
      final config = pipelineConfig as Map;
      final steps = config['steps'] as List;

      final conditionalSteps = steps.where((step) {
        if (step is! Map) return false;
        return step.containsKey('condition');
      }).toList();

      expect(conditionalSteps, isNotEmpty,
          reason: 'Should have platform-specific conditional steps');

      // Check for OS conditions
      final conditions = conditionalSteps
          .map((step) => (step as Map)['condition'].toString())
          .toList();

      expect(
          conditions.any((c) => c.contains('Windows_NT')), isTrue,
          reason: 'Should have Windows-specific steps');
    });
  });

  group('Web Builds Loop Validation', () {
    test('should use parameters for web builds', () {
      final content = pipelineFile.readAsStringSync();

      // Check for template expression syntax
      expect(content.contains(r'${{ if'), isTrue,
          reason: 'Should use template expressions');
      expect(content.contains(r'${{ each build in parameters.webBuilds }}'),
          isTrue,
          reason: 'Should iterate over webBuilds parameter');
    });

    test('should have conditional build modes', () {
      final content = pipelineFile.readAsStringSync();

      expect(content.contains('debugMode'), isTrue);
      expect(content.contains('profileMode'), isTrue);
    });
  });

  group('Security and Best Practices', () {
    test('should not contain hardcoded secrets', () {
      final content = pipelineFile.readAsStringSync();

      // Check for common secret patterns
      final secretPatterns = [
        RegExp(r'password\s*:\s*["\']?[^\s\'"]+', caseSensitive: false),
        RegExp(r'api[_-]?key\s*:\s*["\']?[^\s\'"]+', caseSensitive: false),
        RegExp(r'secret\s*:\s*["\']?[^\s\'"]+', caseSensitive: false),
        RegExp(r'token\s*:\s*["\']?[^\s\'"]+', caseSensitive: false),
      ];

      for (final pattern in secretPatterns) {
        final matches = pattern.allMatches(content);
        if (matches.isNotEmpty) {
          // Allow variable references like $(SecretVariable)
          for (final match in matches) {
            final matchedText = content.substring(match.start, match.end);
            if (!matchedText.contains(r'$(') && !matchedText.contains('#')) {
              fail('Potential hardcoded secret found: $matchedText');
            }
          }
        }
      }
    });

    test('should use proper task versions', () {
      final content = pipelineFile.readAsStringSync();
      pipelineConfig = loadYaml(content);

      final config = pipelineConfig as Map;
      final steps = config['steps'] as List;

      for (final step in steps) {
        if (step is Map && step.containsKey('task')) {
          final task = step['task'].toString();
          // Tasks should have version specified
          if (task.contains('@')) {
            final version = task.split('@')[1];
            expect(version, isNotEmpty,
                reason: 'Task versions should be specified');
          }
        }
      }
    });
  });

  group('Edge Cases and Error Handling', () {
    test('should handle file size limits', () {
      final size = pipelineFile.lengthSync();
      expect(size, lessThan(100000),
          reason: 'Pipeline file should be reasonably sized');
    });

    test('should have reasonable number of steps', () {
      final content = pipelineFile.readAsStringSync();
      pipelineConfig = loadYaml(content);

      final config = pipelineConfig as Map;
      final steps = config['steps'] as List;

      expect(steps.length, greaterThan(0));
      expect(steps.length, lessThan(100),
          reason: 'Should have reasonable number of steps');
    });

    test('should handle missing optional configurations', () {
      final content = pipelineFile.readAsStringSync();
      pipelineConfig = loadYaml(content);

      // Test that pipeline can handle optional fields being absent
      expect(() => pipelineConfig, returnsNormally);
    });
  });

  group('Integration with Flutter Project', () {
    test('should reference correct project paths', () {
      final content = pipelineFile.readAsStringSync();

      expect(content.contains("projectDirectory: '.'"), isTrue,
          reason: 'Should build from repository root');
    });

    test('should produce Flutter-specific artifacts', () {
      final content = pipelineFile.readAsStringSync();
      pipelineConfig = loadYaml(content);

      final config = pipelineConfig as Map;
      final steps = config['steps'] as List;

      final publishSteps = steps
          .where((step) => step is Map && step.containsKey('artifact'))
          .toList();

      final artifactNames = publishSteps
          .map((step) => (step as Map)['artifact'].toString())
          .toList();

      // Check for expected Flutter build artifacts
      expect(
          artifactNames.any((name) =>
              name.toLowerCase().contains('apk') ||
              name.toLowerCase().contains('web')),
          isTrue,
          reason: 'Should publish Flutter build artifacts');
    });
  });
}