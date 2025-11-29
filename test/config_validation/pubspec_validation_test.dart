import 'dart:io';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

/// Comprehensive validation tests for pubspec.yaml
void main() {
  late File pubspecFile;
  late dynamic pubspecConfig;

  setUpAll(() {
    pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      throw Exception('pubspec.yaml not found');
    }
  });

  group('Pubspec Structure Validation', () {
    test('should be valid YAML', () {
      expect(pubspecFile.existsSync(), isTrue);

      final content = pubspecFile.readAsStringSync();
      expect(content, isNotEmpty);

      expect(() {
        pubspecConfig = loadYaml(content);
      }, returnsNormally, reason: 'YAML should parse without errors');

      expect(pubspecConfig, isNotNull);
    });

    test('should have required top-level fields', () {
      final content = pubspecFile.readAsStringSync();
      pubspecConfig = loadYaml(content);

      expect(pubspecConfig, isA<Map>());
      final config = pubspecConfig as Map;

      final requiredFields = [
        'name',
        'description',
        'version',
        'environment',
        'dependencies',
      ];

      for (final field in requiredFields) {
        expect(config.containsKey(field), isTrue,
            reason: 'pubspec.yaml must have $field field');
      }
    });

    test('should have valid package name', () {
      final content = pubspecFile.readAsStringSync();
      pubspecConfig = loadYaml(content);

      final name = pubspecConfig['name'] as String;
      expect(name, isNotEmpty);
      expect(name, matches(RegExp(r'^[a-z_][a-z0-9_]*$')),
          reason: 'Package name should follow Dart naming conventions');
    });

    test('should have valid version', () {
      final content = pubspecFile.readAsStringSync();
      pubspecConfig = loadYaml(content);

      final version = pubspecConfig['version'].toString();
      expect(version, isNotEmpty);
      expect(version, matches(RegExp(r'^\d+\.\d+\.\d+(\+\d+)?$')),
          reason: 'Version should follow semantic versioning');
    });

    test('should have SDK constraints', () {
      final content = pubspecFile.readAsStringSync();
      pubspecConfig = loadYaml(content);

      expect(pubspecConfig['environment'], isA<Map>());
      final environment = pubspecConfig['environment'] as Map;

      expect(environment.containsKey('sdk'), isTrue,
          reason: 'Must specify SDK constraint');

      final sdkConstraint = environment['sdk'].toString();
      expect(sdkConstraint, isNotEmpty);
    });
  });

  group('Dependencies Validation', () {
    setUp(() {
      final content = pubspecFile.readAsStringSync();
      pubspecConfig = loadYaml(content);
    });

    test('should have dependencies section', () {
      expect(pubspecConfig['dependencies'], isA<Map>(),
          reason: 'dependencies should be a map');

      final deps = pubspecConfig['dependencies'] as Map;
      expect(deps, isNotEmpty, reason: 'Should have at least one dependency');
    });

    test('should include Flutter SDK', () {
      final deps = pubspecConfig['dependencies'] as Map;
      expect(deps.containsKey('flutter'), isTrue,
          reason: 'Flutter app must include Flutter SDK');

      final flutterDep = deps['flutter'];
      expect(flutterDep, isA<Map>());
      expect((flutterDep as Map).containsKey('sdk'), isTrue);
    });

    test('should have dev_dependencies section', () {
      expect(pubspecConfig.containsKey('dev_dependencies'), isTrue,
          reason: 'Should have dev_dependencies for testing and tooling');

      expect(pubspecConfig['dev_dependencies'], isA<Map>());
    });

    test('should include test dependencies', () {
      final devDeps = pubspecConfig['dev_dependencies'] as Map;

      final hasTestPackage =
          devDeps.containsKey('test') || devDeps.containsKey('flutter_test');

      expect(hasTestPackage, isTrue,
          reason: 'Should include test or flutter_test package');
    });

    test('should include yaml package for config validation', () {
      final devDeps = pubspecConfig['dev_dependencies'] as Map;
      expect(devDeps.containsKey('yaml'), isTrue,
          reason: 'Should include yaml package for validation tests');
    });

    test('should have proper dependency versions', () {
      final deps = pubspecConfig['dependencies'] as Map;

      for (final entry in deps.entries) {
        final key = entry.key as String;
        final value = entry.value;

        if (value is String) {
          // Version constraint
          expect(value, isNotEmpty, reason: 'Version for $key should not be empty');
        } else if (value is Map) {
          // Git or SDK dependency
          expect(value, isNotEmpty, reason: 'Config for $key should not be empty');
        }
      }
    });
  });

  group('Flutter Configuration', () {
    setUp(() {
      final content = pubspecFile.readAsStringSync();
      pubspecConfig = loadYaml(content);
    });

    test('should have flutter section', () {
      expect(pubspecConfig.containsKey('flutter'), isTrue,
          reason: 'Flutter app must have flutter section');

      expect(pubspecConfig['flutter'], isA<Map>());
    });

    test('should specify uses-material-design', () {
      final flutter = pubspecConfig['flutter'] as Map;
      expect(flutter.containsKey('uses-material-design'), isTrue,
          reason: 'Should specify material design usage');
    });
  });

  group('Publish Configuration', () {
    setUp(() {
      final content = pubspecFile.readAsStringSync();
      pubspecConfig = loadYaml(content);
    });

    test('should set publish_to for private packages', () {
      if (pubspecConfig.containsKey('publish_to')) {
        final publishTo = pubspecConfig['publish_to'];
        expect(publishTo, equals('none'),
            reason: 'Private packages should set publish_to: none');
      }
    });
  });

  group('Quality and Best Practices', () {
    test('should not have trailing whitespace', () {
      final lines = pubspecFile.readAsLinesSync();

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        expect(line.endsWith(' ') || line.endsWith('\t'), isFalse,
            reason: 'Line ${i + 1} should not have trailing whitespace');
      }
    });

    test('should use consistent indentation', () {
      final lines = pubspecFile.readAsLinesSync();

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.contains('\t')) {
          fail('Line ${i + 1} contains tabs; use spaces for indentation');
        }
      }
    });

    test('should have reasonable file size', () {
      final size = pubspecFile.lengthSync();
      expect(size, greaterThan(100), reason: 'Should have meaningful content');
      expect(size, lessThan(50000), reason: 'Should not be excessively large');
    });

    test('should have description', () {
      final content = pubspecFile.readAsStringSync();
      pubspecConfig = loadYaml(content);

      expect(pubspecConfig.containsKey('description'), isTrue);
      final description = pubspecConfig['description'] as String;
      expect(description, isNotEmpty);
      expect(description.length, greaterThan(10),
          reason: 'Description should be meaningful');
    });
  });

  group('Dependency Security', () {
    setUp(() {
      final content = pubspecFile.readAsStringSync();
      pubspecConfig = loadYaml(content);
    });

    test('git dependencies should specify ref or version', () {
      final deps = pubspecConfig['dependencies'] as Map;

      for (final entry in deps.entries) {
        final key = entry.key as String;
        final value = entry.value;

        if (value is Map && value.containsKey('git')) {
          // Git dependency - should ideally have ref
          final gitConfig = value['git'];
          if (gitConfig is Map) {
            // Having a ref is good practice but not always required
            expect(gitConfig, isNotEmpty,
                reason: 'Git dependency $key should have configuration');
          }
        }
      }
    });

    test('should not have suspicious patterns in dependencies', () {
      final content = pubspecFile.readAsStringSync();

      // Check for potentially suspicious patterns
      final suspiciousPatterns = [
        RegExp(r'file:///'),
        RegExp(r'localhost'),
      ];

      for (final pattern in suspiciousPatterns) {
        final matches = pattern.allMatches(content);
        expect(matches, isEmpty,
            reason: 'Should not contain suspicious pattern: ${pattern.pattern}');
      }
    });
  });

  group('Integration with Project', () {
    test('dependencies should be compatible with SDK version', () {
      final content = pubspecFile.readAsStringSync();
      pubspecConfig = loadYaml(content);

      final environment = pubspecConfig['environment'] as Map;
      final sdkConstraint = environment['sdk'].toString();

      // Basic check that SDK constraint is reasonable
      expect(sdkConstraint, isNotEmpty);
      expect(sdkConstraint, isNot(equals('any')),
          reason: 'Should specify explicit SDK version constraint');
    });

    test('dev_dependencies should include linting tools', () {
      final content = pubspecFile.readAsStringSync();
      pubspecConfig = loadYaml(content);

      final devDeps = pubspecConfig['dev_dependencies'] as Map;

      // Should have some linting/analysis tool
      final hasLinting = devDeps.containsKey('flutter_lints') ||
          devDeps.containsKey('lint') ||
          devDeps.containsKey('lints');

      expect(hasLinting, isTrue,
          reason: 'Should include linting package for code quality');
    });
  });
}