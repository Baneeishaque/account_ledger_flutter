"""
YAML configuration validation tests.
"""

import unittest
from pathlib import Path

try:
    import yaml
except ImportError:
    yaml = None


class TestYAMLValidation(unittest.TestCase):
    """Validate YAML files in the repository."""
    
    def setUp(self):
        if yaml is None:
            self.skipTest("PyYAML not installed")
        self.repo_root = Path(__file__).parent.parent
    
    def test_yaml_files_are_valid(self):
        """Ensure all YAML files are valid."""
        yaml_files = list(self.repo_root.rglob('*.yml')) + list(self.repo_root.rglob('*.yaml'))
        for yaml_file in yaml_files:
            if '.git' in str(yaml_file):
                continue
            with self.subTest(file=str(yaml_file)):
                with open(yaml_file, 'r') as f:
                    try:
                        data = yaml.safe_load(f)
                        self.assertIsNotNone(data)
                    except yaml.YAMLError as e:
                        self.fail(f"Invalid YAML in {yaml_file}: {e}")
34r .sed-tmp
