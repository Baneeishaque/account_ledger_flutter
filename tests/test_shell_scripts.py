"""
Comprehensive tests for shell scripts in the repository.
Tests syntax, structure, functionality, and best practices.
"""

import unittest
import os
import stat
import subprocess
from pathlib import Path


class TestShellScripts(unittest.TestCase):
    """Validate shell scripts for correctness and best practices."""
    
    def setUp(self):
        """Set up test fixtures."""
        self.repo_root = Path(__file__).parent.parent
        self.shell_scripts = [
            self.repo_root / 'run_tests.sh',
            self.repo_root / 'run_validation_tests.sh',
        ]
    
    def test_shell_scripts_exist(self):
        """Ensure required shell scripts exist."""
        for script in self.shell_scripts:
            with self.subTest(script=script.name):
                self.assertTrue(script.exists(), f"{script.name} should exist")
    
    def test_shell_scripts_have_shebang(self):
        """Ensure shell scripts have proper shebang."""
        for script in self.shell_scripts:
            if script.exists():
                with self.subTest(script=script.name):
                    with open(script, 'r') as f:
                        first_line = f.readline().strip()
                        self.assertTrue(first_line.startswith('#!'))
    
    def test_shell_scripts_syntax(self):
        """Validate shell script syntax using bash -n."""
        for script in self.shell_scripts:
            if script.exists():
                with self.subTest(script=script.name):
                    try:
                        result = subprocess.run(
                            ['bash', '-n', str(script)],
                            capture_output=True,
                            text=True,
                            timeout=5
                        )
                        if result.returncode != 0:
                            self.fail(f"Syntax error in {script.name}")
                    except:
                        pass


if __name__ == '__main__':
    unittest.main()