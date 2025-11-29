# Configuration Validation Tests

This directory contains comprehensive validation tests for project configuration files.

## Test Files

### azure_pipelines_validation_test.dart
Validates the Azure Pipelines CI/CD configuration including:
- YAML syntax and structure
- Required sections and fields
- Parameter definitions
- Build step configurations
- Platform-specific conditionals
- Security best practices
- Artifact publishing

### copilot_instructions_validation_test.dart
Validates the GitHub Copilot instructions document including:
- Markdown structure and formatting
- Required documentation sections
- Content quality and completeness
- Branch safety instructions
- File and directory references
- Formatting consistency

## Running the Tests

```bash
# Run all configuration validation tests
flutter test test/config_validation/

# Run specific test file
flutter test test/config_validation/azure_pipelines_validation_test.dart

# Run with verbose output
flutter test test/config_validation/ --reporter=expanded
```

## Test Coverage

These tests provide validation for:
- ✅ Syntax correctness (YAML, Markdown)
- ✅ Structural completeness
- ✅ Required fields and sections
- ✅ Best practices adherence
- ✅ Security considerations
- ✅ Cross-references to actual project files
- ✅ Formatting consistency
- ✅ Content quality

## Adding New Tests

When adding new configuration files, create corresponding validation tests that cover:
1. File existence and basic validation
2. Syntax and structure validation
3. Required sections/fields
4. Content quality and completeness
5. Security and best practices
6. Edge cases and error handling
7. Integration with the broader project

## Notes

- These tests validate configuration files that changed from the master branch
- Tests are comprehensive and cover happy paths, edge cases, and error conditions
- Security validation checks for hardcoded secrets and proper credential handling
- Tests follow Flutter/Dart testing conventions using the `test` package