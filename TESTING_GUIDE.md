# Testing Guide

## Quick Start

### Running All Tests

```bash
# Run Python tests
python -m pytest tests/ -v

# Run Dart/Flutter tests
flutter test test/config_validation/

# Or use the convenience scripts
./run_tests.sh
./run_validation_tests.sh
```

## Test Files Overview

### Python Tests (tests/)

#### 1. test_config_validation.py
Tests JSON configuration files for:
- Valid JSON syntax
- Proper schema structure
- No empty files
- No duplicate keys
- Renovate.json specific validation

#### 2. test_yaml_validation.py
Tests YAML configuration files for:
- Valid YAML syntax
- Azure Pipelines structure
- No tabs (spaces only)
- Proper data types
- Flutter-specific tasks

#### 3. test_shell_scripts.py (NEW)
Tests shell scripts for:
- File existence and permissions
- Proper shebang lines
- Command presence
- Error handling
- No hardcoded paths
- Bash syntax validity

#### 4. test_markdown_validation.py (NEW)
Tests markdown documentation for:
- File existence
- Proper heading structure
- Required sections
- Balanced code blocks
- Link formatting
- No trailing whitespace

### Dart Tests (test/config_validation/)

#### 5. azure_pipelines_validation_test.dart
Comprehensive tests for Azure Pipelines configuration (23 tests)

#### 6. copilot_instructions_validation_test.dart
Validation for GitHub Copilot instructions (30 tests)

#### 7. shell_scripts_validation_test.dart (NEW)
Dart-based shell script validation (18 tests)

#### 8. readme_validation_test.dart (NEW)
README documentation validation (13 tests)

## Running Specific Tests

### Python - Run Single Test File
```bash
python -m pytest tests/test_shell_scripts.py -v
```

### Dart - Run Single Test File
```bash
flutter test test/config_validation/shell_scripts_validation_test.dart
```

## Summary

This comprehensive test suite ensures:
- Configuration correctness
- Documentation quality
- Script reliability
- Security best practices
- Formatting consistency

Total: 115+ tests across Python and Dart