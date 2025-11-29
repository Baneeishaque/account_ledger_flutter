#!/bin/bash
# Comprehensive configuration validation test runner

set -e

echo "=== Configuration Validation Test Suite ==="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    exit 1
fi

echo "✓ Flutter found: $(flutter --version | head -1)"
echo ""

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

echo ""
echo "🧪 Running configuration validation tests..."
echo ""

# Run the validation tests
flutter test test/config_validation/ --reporter=expanded

echo ""
echo "=== Test Suite Complete ==="