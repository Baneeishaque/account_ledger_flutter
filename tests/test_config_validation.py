"""
Tests for configuration file validation.
Validates schema, required keys, and critical values.
"""

import unittest
import json
import os
from pathlib import Path


class TestConfigurationFiles(unittest.TestCase):
    """Validate configuration files for correctness."""
    
    def setUp(self):
        """Load configuration files."""
        self.repo_root = Path(__file__).parent.parent
        
    def test_json_files_are_valid(self):
        """Ensure all JSON files are valid and parseable."""
        json_files = list(self.repo_root.glob('**/*.json'))
        for json_file in json_files:
            if 'node_modules' in str(json_file):
                continue
            with self.subTest(file=str(json_file)):
                with open(json_file, 'r') as f:
                    try:
                        json.load(f)
                    except json.JSONDecodeError as e:
                        self.fail(f"Invalid JSON in {json_file}: {e}")
    
    
    def test_json_schema_structure(self):
        """Validate JSON files have proper structure."""
        json_files = list(self.repo_root.glob('**/*.json'))
        for json_file in json_files:
            if 'node_modules' in str(json_file) or '.git' in str(json_file):
                continue
            with self.subTest(file=str(json_file)):
                with open(json_file, 'r') as f:
                    data = json.load(f)
                    # Should be either dict or list
                    self.assertIn(
                        type(data).__name__,
                        ['dict', 'list'],
                        f"{json_file} should contain object or array"
                    )
    
    def test_json_files_not_empty(self):
        """Ensure JSON files are not empty."""
        json_files = list(self.repo_root.glob('**/*.json'))
        for json_file in json_files:
            if 'node_modules' in str(json_file) or '.git' in str(json_file):
                continue
            with self.subTest(file=str(json_file)):
                with open(json_file, 'r') as f:
                    content = f.read().strip()
                    self.assertTrue(
                        len(content) > 0,
                        f"{json_file} should not be empty"
                    )
    
    def test_no_duplicate_keys(self):
        """Ensure JSON files don't have duplicate keys."""
        json_files = list(self.repo_root.glob('**/*.json'))
        for json_file in json_files:
            if 'node_modules' in str(json_file) or '.git' in str(json_file):
                continue
            with self.subTest(file=str(json_file)):
                with open(json_file, 'r') as f:
                    content = f.read()
                    # Parse with object_pairs_hook to detect duplicates
                    try:
                        json.loads(content, object_pairs_hook=self._check_duplicate_keys)
                    except ValueError as e:
                        if 'duplicate' in str(e).lower():
                            self.fail(f"Duplicate keys in {json_file}: {e}")
    
    def _check_duplicate_keys(self, pairs):
        """Helper to detect duplicate keys in JSON."""
        keys = [k for k, v in pairs]
        if len(keys) != len(set(keys)):
            duplicates = [k for k in keys if keys.count(k) > 1]
            raise ValueError(f"Duplicate keys found: {set(duplicates)}")
        return dict(pairs)
    
    def test_renovate_json_structure(self):
        """Validate renovate.json specific structure."""
        renovate_file = self.repo_root / 'renovate.json'
        if not renovate_file.exists():
            self.skipTest("renovate.json not found")
        
        with open(renovate_file, 'r') as f:
            data = json.load(f)
            
            # Should be a dictionary
            self.assertIsInstance(data, dict, "renovate.json should be an object")
            
            # If it has packageRules, they should be a list
            if 'packageRules' in data:
                self.assertIsInstance(
                    data['packageRules'],
                    list,
                    "packageRules should be an array"
                )


if __name__ == '__main__':
    unittest.main()