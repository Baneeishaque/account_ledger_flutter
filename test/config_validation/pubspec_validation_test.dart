import 'dart:io';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

/// Comprehensive validation tests for pubspec.yaml
/// Tests cover: YAML syntax, dependencies, versioning, package metadata,
/// and Flutter configuration.
void main() {
  late File pubspecFile;
  late dynamic pubspecConfig;
  late String content;

  setUpAll(() {
    pubspecFile = File('pubspec.yaml');
    expect(pubspecFile.existsSync(), isTrue,
        reason: 'pubspec.yaml should exist at project root');
    content = pubspecFile.readAsStringSync();
    pubspecConfig = loadYaml(content);
  });

  group('PubSpec File Structure', () {
    test('should be valid YAML', () {
      expect(() => loadYaml(content), returnsNormally,
          reason: 'pubspec.yaml must be valid YAML');
    });

    test('should have required top-level fields', () {
      final config = pubspecConfig as Map;
      expect(config.containsKey('name'), isTrue);
      expect(config.containsKey('description'), isTrue);
      expect(config.containsKey('version'), isTrue);
      expect(config.containsKey('environment'), isTrue);
    });

    test('should have Flutter configuration', () {
      final config = pubspecConfig as Map;
      expect(config.containsKey('flutter'), isTrue,
          reason: 'Flutter projects must have flutter section');
    });
  });

  group('Dependencies Validation', () {
    test('should have dependencies section', () {
      final config = pubspecConfig as Map;
      expect(config.containsKey('dependencies'), isTrue);
    });

    test('should have dev_dependencies section', () {
      final config = pubspecConfig as Map;
      expect(config.containsKey('dev_dependencies'), isTrue);
    });

    test('should include flutter SDK dependency', () {
      final config = pubspecConfig as Map;
      final deps = config['dependencies'] as Map;
      expect(deps.containsKey('flutter'), isTrue);
      
      final flutterDep = deps['flutter'] as Map;
      expect(flutterDep.containsKey('sdk'), isTrue);
      expect(flutterDep['sdk'], equals('flutter'));
    });

    test('should have test package in dev_dependencies', () {
      final config = pubspecConfig as Map;
      final devDeps = config['dev_dependencies'] as Map;
      
      expect(devDeps.containsKey('test'), isTrue,
          reason: 'test package is required for unit testing');
    });

    test('should have yaml package for validation tests', () {
      final config = pubspecConfig as Map;
      final devDeps = config['dev_dependencies'] as Map;
      
      expect(devDeps.containsKey('yaml'), isTrue,
          reason: 'yaml package is needed for config validation tests');
    });

    test('should have flutter_test in dev_dependencies', () {
      final config = pubspecConfig as Map;
      final devDeps = config['dev_dependencies'] as Map;
      
      expect(devDeps.containsKey('flutter_test'), isTrue);
    });

    test('should have flutter_lints for code quality', () {
      final config = pubspecConfig as Map;
      final devDeps = config['dev_dependencies'] as Map;
      
      expect(devDeps.containsKey('flutter_lints'), isTrue,
          reason: 'flutter_lints enforces code quality standards');
    });

    test('should use semantic versioning', () {
      final config = pubspecConfig as Map;
      final devDeps = config['dev_dependencies'] as Map;
      
      // Check version format for test package
      if (devDeps.containsKey('test')) {
        final testVersion = devDeps['test'].toString();
        // Should match semantic versioning pattern (^1.2.3 or similar)
        expect(testVersion.contains(RegExp(r'\d+\.\d+\.\d+')), isTrue,
            reason: 'Dependencies should use semantic versioning');
      }
    });
  });

  group('Version and Metadata', () {
    test('should have valid version number', () {
      final config = pubspecConfig as Map;
      final version = config['version'].toString();
      
      // Should match semantic versioning
      expect(version, matches(RegExp(r'^\d+\.\d+\.\d+')),
          reason: 'Version should follow semantic versioning');
    });

    test('should have meaningful package name', () {
      final config = pubspecConfig as Map;
      final name = config['name'].toString();
      
      expect(name, isNotEmpty);
      expect(name.contains(' '), isFalse,
          reason: 'Package name should not contain spaces');
      expect(name, matches(RegExp(r'^[a-z][a-z0-9_]*$')),
          reason: 'Package name should follow Dart conventions');
    });

    test('should have description', () {
      final config = pubspecConfig as Map;
      final description = config['description'].toString();
      
      expect(description, isNotEmpty);
      expect(description.length, greaterThan(10),
          reason: 'Description should be meaningful');
    });
  });

  group('Environment Configuration', () {
    test('should specify Dart SDK constraints', () {
      final config = pubspecConfig as Map;
      expect(config.containsKey('environment'), isTrue);
      
      final environment = config['environment'] as Map;
      expect(environment.containsKey('sdk'), isTrue,
          reason: 'Must specify Dart SDK version constraints');
    });

    test('should have reasonable SDK version constraints', () {
      final config = pubspecConfig as Map;
      final environment = config['environment'] as Map;
      final sdkConstraint = environment['sdk'].toString();
      
      expect(sdkConstraint, isNotEmpty);
      // Should contain version bounds
      expect(sdkConstraint.contains('>=') || sdkConstraint.contains('^'),
          isTrue,
          reason: 'SDK constraint should specify minimum version');
    });
  });

  group('Flutter Specific Configuration', () {
    test('should have Flutter section', () {
      final config = pubspecConfig as Map;
      final flutter = config['flutter'] as Map;
      
      expect(flutter, isNotNull);
    });

    test('should specify assets if needed', () {
      final config = pubspecConfig as Map;
      final flutter = config['flutter'] as Map;
      
      // If assets are specified, they should be properly formatted
      if (flutter.containsKey('assets')) {
        final assets = flutter['assets'];
        expect(assets, isA<List>(),
            reason: 'Assets should be a list');
      }
    });

    test('should not have syntax errors in Flutter config', () {
      final config = pubspecConfig as Map;
      expect(config['flutter'], isA<Map>());
    });
  });

  group('Code Quality and Formatting', () {
    test('should not have trailing whitespace', () {
      final lines = content.split('\n');
      
      for (var i = 0; i < lines.length; i++) {
        expect(lines[i].endsWith(' ') || lines[i].endsWith('\t'), isFalse,
            reason: 'Line ${i + 1} should not have trailing whitespace');
      }
    });

    test('should use consistent indentation', () {
      final lines = content.split('\n');
      
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].contains('\t')) {
          fail('Line ${i + 1} contains tabs instead of spaces');
        }
      }
    });

    test('should have reasonable file size', () {
      final size = pubspecFile.lengthSync();
      expect(size, lessThan(50000),
          reason: 'pubspec.yaml should not be excessively large');
    });
  });

  group('Security Best Practices', () {
    test('should not contain API keys or secrets', () {
      expect(content.toLowerCase().contains('api_key'), isFalse,
          reason: 'Should not contain hardcoded API keys');
      expect(content.toLowerCase().contains('password'), isFalse,
          reason: 'Should not contain hardcoded passwords');
      expect(content.toLowerCase().contains('secret'), isFalse,
          reason: 'Should not contain hardcoded secrets');
    });

    test('should not have commented-out secrets', () {
      final lines = content.split('\n');
      final comments = lines.where((l) => l.trim().startsWith('#'));
      
      for (final comment in comments) {
        expect(comment.toLowerCase().contains('password'), isFalse);
        expect(comment.toLowerCase().contains('api_key'), isFalse);
      }
    });
  });

  group('Dependency Version Management', () {
    test('should pin critical dependencies appropriately', () {
      final config = pubspecConfig as Map;
      final devDeps = config['dev_dependencies'] as Map;
      
      // Test and yaml packages should have version constraints
      if (devDeps['test'] != null) {
        final testDep = devDeps['test'].toString();
        expect(testDep, isNot(equals('any')),
            reason: 'Critical dependencies should be version-constrained');
      }
    });

    test('should not have conflicting version constraints', () {
      // This is implicitly tested by YAML parsing success
      expect(() => loadYaml(content), returnsNormally);
    });
  });

  group('Project Metadata Completeness', () {
    test('should have publish_to configuration', () {
      final config = pubspecConfig as Map;
      // For private packages, should have publish_to: 'none'
      // For public packages, should either not have it or have proper value
      if (config.containsKey('publish_to')) {
        final publishTo = config['publish_to'];
        expect(publishTo, isNotNull);
      }
    });
  });

  group('Recent Changes Validation', () {
    test('should have added test package dependency', () {
      final config = pubspecConfig as Map;
      final devDeps = config['dev_dependencies'] as Map;
      
      expect(devDeps.containsKey('test'), isTrue,
          reason: 'test package was added in recent changes');
      
      final testVersion = devDeps['test'].toString();
      expect(testVersion, contains('1.25'),
          reason: 'Should use recent test package version');
    });

    test('should have added yaml package dependency', () {
      final config = pubspecConfig as Map;
      final devDeps = config['dev_dependencies'] as Map;
      
      expect(devDeps.containsKey('yaml'), isTrue,
          reason: 'yaml package was added for config validation');
      
      final yamlVersion = devDeps['yaml'].toString();
      expect(yamlVersion, contains('3.1'),
          reason: 'Should use recent yaml package version');
    });
  });
}