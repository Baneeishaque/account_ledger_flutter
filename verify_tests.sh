#!/bin/bash
# Verify all test files exist and are properly structured

echo "=== Test Suite Verification ==="
echo ""

# Check Dart tests
echo "Checking Dart tests..."
dart_tests=(
    "test/config_validation/azure_pipelines_validation_test.dart"
    "test/config_validation/copilot_instructions_validation_test.dart"
    "test/config_validation/shell_script_validation_test.dart"
    "test/config_validation/readme_validation_test.dart"
    "test/config_validation/integration_test.dart"
    "test/config_validation/pubspec_validation_test.dart"
)

dart_count=0
for test in "${dart_tests[@]}"; do
    if [ -f "$test" ]; then
        echo "  ✓ $test"
        dart_count=$((dart_count + 1))
    else
        echo "  ✗ $test (missing)"
    fi
done

echo ""
echo "Checking Python tests..."
python_tests=(
    "tests/test_config_validation.py"
    "tests/test_yaml_validation.py"
    "tests/test_shell_scripts.py"
    "tests/test_readme_validation.py"
)

python_count=0
for test in "${python_tests[@]}"; do
    if [ -f "$test" ]; then
        echo "  ✓ $test"
        python_count=$((python_count + 1))
    else
        echo "  ✗ $test (missing)"
    fi
done

echo ""
echo "Checking documentation..."
docs=(
    "test/README.md"
    "test/config_validation/README.md"
    "test/TEST_SUMMARY.md"
)

doc_count=0
for doc in "${docs[@]}"; do
    if [ -f "$doc" ]; then
        echo "  ✓ $doc"
        doc_count=$((doc_count + 1))
    else
        echo "  ✗ $doc (missing)"
    fi
done

echo ""
echo "=== Summary ==="
echo "Dart tests: $dart_count/${#dart_tests[@]}"
echo "Python tests: $python_count/${#python_tests[@]}"
echo "Documentation: $doc_count/${#docs[@]}"
echo ""

total_expected=$((${#dart_tests[@]} + ${#python_tests[@]} + ${#docs[@]}))
total_found=$((dart_count + python_count + doc_count))

if [ $total_found -eq $total_expected ]; then
    echo "✓ All test files present!"
    exit 0
else
    echo "✗ Some test files missing ($total_found/$total_expected)"
    exit 1
fi