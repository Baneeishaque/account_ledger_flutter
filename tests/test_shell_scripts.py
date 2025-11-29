"""
Tests for shell script functionality and structure.
Validates shell scripts are executable, have proper syntax, and contain expected commands.
"""

import unittest
import os
import subprocess
from pathlib import Path


class TestShellScripts(unittest.TestCase):
    """Validate shell scripts for correctness and best practices."""
    
    def setUp(self):
        """Set up test fixtures."""
        self.repo_root = Path(__file__).parent.parent
        self.run_tests_script = self.repo_root / 'run_tests.sh'
        self.run_validation_script = self.repo_root / 'run_validation_tests.sh'
    
    def test_run_tests_exists(self):
        """Verify run_tests.sh exists."""
        self.assertTrue(
            self.run_tests_script.exists(),
            "run_tests.sh should exist in repository root"
        )
    
    def test_run_validation_tests_exists(self):
        """Verify run_validation_tests.sh exists."""
        self.assertTrue(
            self.run_validation_script.exists(),
            "run_validation_tests.sh should exist in repository root"
        )
    
    def test_scripts_are_executable(self):
        """Ensure scripts have execute permissions."""
        for script in [self.run_tests_script, self.run_validation_script]:
            if script.exists():
                with self.subTest(script=script.name):
                    # Check if executable bit is set
                    is_executable = os.access(script, os.X_OK)
                    self.assertTrue(
                        is_executable,
                        f"{script.name} should be executable"
                    )
    
    def test_scripts_have_shebang(self):
        """Verify scripts start with proper shebang."""
        for script in [self.run_tests_script, self.run_validation_script]:
            if script.exists():
                with self.subTest(script=script.name):
                    with open(script, 'r') as f:
                        first_line = f.readline().strip()
                        self.assertTrue(
                            first_line.startswith('#!'),
                            f"{script.name} should start with shebang"
                        )
                        self.assertIn(
                            'bash',
                            first_line.lower(),
                            f"{script.name} should use bash"
                        )
    
    def test_run_tests_has_python_tests(self):
        """Verify run_tests.sh includes Python test execution."""
        if not self.run_tests_script.exists():
            self.skipTest("run_tests.sh not found")
        
        with open(self.run_tests_script, 'r') as f:
            content = f.read()
            
            # Should check for tests directory
            self.assertIn('tests', content, "Should reference tests directory")
            
            # Should run Python tests
            self.assertTrue(
                'pytest' in content or 'unittest' in content,
                "Should run Python tests with pytest or unittest"
            )
    
    def test_run_validation_has_flutter_check(self):
        """Verify run_validation_tests.sh checks for Flutter."""
        if not self.run_validation_script.exists():
            self.skipTest("run_validation_tests.sh not found")
        
        with open(self.run_validation_script, 'r') as f:
            content = f.read()
            
            # Should check for Flutter installation
            self.assertIn('flutter', content, "Should reference Flutter")
            self.assertIn('command', content, "Should check if Flutter is available")
    
    def test_run_validation_has_error_handling(self):
        """Verify run_validation_tests.sh has error handling."""
        if not self.run_validation_script.exists():
            self.skipTest("run_validation_tests.sh not found")
        
        with open(self.run_validation_script, 'r') as f:
            content = f.read()
            
            # Should have set -e for error handling
            self.assertIn('set -e', content, "Should exit on error")
    
    def test_scripts_have_descriptive_output(self):
        """Verify scripts have user-friendly output messages."""
        for script in [self.run_tests_script, self.run_validation_script]:
            if script.exists():
                with self.subTest(script=script.name):
                    with open(script, 'r') as f:
                        content = f.read()
                        
                        # Should have echo statements for user feedback
                        echo_count = content.count('echo')
                        self.assertGreater(
                            echo_count,
                            0,
                            f"{script.name} should have output messages"
                        )
    
    def test_run_validation_runs_flutter_test(self):
        """Verify run_validation_tests.sh runs Flutter tests."""
        if not self.run_validation_script.exists():
            self.skipTest("run_validation_tests.sh not found")
        
        with open(self.run_validation_script, 'r') as f:
            content = f.read()
            
            # Should run flutter test
            self.assertIn('flutter test', content, "Should run Flutter tests")
            self.assertIn(
                'test/config_validation',
                content,
                "Should test config_validation directory"
            )
    
    def test_scripts_handle_missing_dependencies(self):
        """Verify scripts handle missing dependencies gracefully."""
        if self.run_tests_script.exists():
            with open(self.run_tests_script, 'r') as f:
                content = f.read()
                
                # Should have conditional checks or error suppression
                self.assertTrue(
                    '2>/dev/null' in content or 'if' in content,
                    "Should handle missing dependencies"
                )
    
    def test_run_validation_gets_dependencies(self):
        """Verify run_validation_tests.sh gets Flutter dependencies."""
        if not self.run_validation_script.exists():
            self.skipTest("run_validation_tests.sh not found")
        
        with open(self.run_validation_script, 'r') as f:
            content = f.read()
            
            # Should run flutter pub get
            self.assertIn(
                'flutter pub get',
                content,
                "Should fetch dependencies"
            )
    
    def test_scripts_have_completion_messages(self):
        """Verify scripts indicate completion."""
        for script in [self.run_tests_script, self.run_validation_script]:
            if script.exists():
                with self.subTest(script=script.name):
                    with open(script, 'r') as f:
                        content = f.read().lower()
                        
                        # Should have completion message
                        self.assertTrue(
                            'complete' in content or 'done' in content or 'finished' in content,
                            f"{script.name} should indicate completion"
                        )
    
    def test_bash_syntax_validity(self):
        """Verify scripts have valid bash syntax."""
        for script in [self.run_tests_script, self.run_validation_script]:
            if script.exists():
                with self.subTest(script=script.name):
                    # Use bash -n to check syntax without executing
                    try:
                        result = subprocess.run(
                            ['bash', '-n', str(script)],
                            capture_output=True,
                            text=True,
                            timeout=5
                        )
                        self.assertEqual(
                            result.returncode,
                            0,
                            f"{script.name} has syntax errors: {result.stderr}"
                        )
                    except FileNotFoundError:
                        self.skipTest("bash not available")
                    except subprocess.TimeoutExpired:
                        self.fail(f"{script.name} syntax check timed out")
    
    def test_scripts_no_hardcoded_paths(self):
        """Verify scripts don't have problematic hardcoded paths."""
        for script in [self.run_tests_script, self.run_validation_script]:
            if script.exists():
                with self.subTest(script=script.name):
                    with open(script, 'r') as f:
                        content = f.read()
                        
                        # Should not have absolute paths to user directories
                        problematic_paths = ['/home/', '/Users/', 'C:\\']
                        for path in problematic_paths:
                            self.assertNotIn(
                                path,
                                content,
                                f"{script.name} should not have hardcoded path: {path}"
                            )


if __name__ == '__main__':
    unittest.main()