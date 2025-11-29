"""
Comprehensive tests for README and documentation files.
Tests markdown structure, content, and formatting.
"""

import unittest
from pathlib import Path
import re


class TestREADMEFiles(unittest.TestCase):
    """Validate README files for correctness and completeness."""
    
    def setUp(self):
        """Set up test fixtures."""
        self.repo_root = Path(__file__).parent.parent
        self.readme_files = [
            self.repo_root / 'test' / 'README.md',
            self.repo_root / 'test' / 'config_validation' / 'README.md',
        ]
    
    def test_readme_files_exist(self):
        """Ensure README files exist in key directories."""
        for readme in self.readme_files:
            with self.subTest(file=readme):
                self.assertTrue(readme.exists(), f"{readme} should exist")
    
    def test_readme_files_not_empty(self):
        """Ensure README files contain content."""
        for readme in self.readme_files:
            if readme.exists():
                with self.subTest(file=readme):
                    content = readme.read_text().strip()
                    self.assertTrue(len(content) > 0, f"{readme} should not be empty")
    
    def test_readme_has_heading(self):
        """Ensure README files start with a heading."""
        for readme in self.readme_files:
            if readme.exists():
                with self.subTest(file=readme):
                    content = readme.read_text()
                    lines = content.split('\n')
                    self.assertTrue(lines[0].startswith('#'), 
                                  f"{readme} should start with heading")
    
    def test_config_validation_readme_completeness(self):
        """Ensure config_validation README has required sections."""
        readme = self.repo_root / 'test' / 'config_validation' / 'README.md'
        if readme.exists():
            content = readme.read_text()
            required_sections = [
                'Test Files',
                'Running the Tests',
                'Test Coverage',
            ]
            for section in required_sections:
                with self.subTest(section=section):
                    self.assertIn(section, content, 
                                f"Should have {section} section")


if __name__ == '__main__':
    unittest.main()