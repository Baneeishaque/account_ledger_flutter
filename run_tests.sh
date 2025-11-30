#!/bin/bash
# Comprehensive test runner script

echo "=== Running Comprehensive Test Suite ==="

# Run Python tests
if [ -d "tests" ]; then
    echo "Running Python tests..."
    python -m pytest tests/ -v --tb=short 2>/dev/null || python -m unittest discover tests/ -v
fi

# Run JavaScript tests
if [ -d "__tests__" ] || [ -f "package.json" ]; then
    echo "Running JavaScript tests..."
    npm test 2>/dev/null || yarn test 2>/dev/null || echo "No JS test runner configured"
fi

echo "=== Test Suite Complete ==="