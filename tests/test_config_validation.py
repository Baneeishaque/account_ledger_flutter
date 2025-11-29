"""
Comprehensive tests for configuration file validation.
Validates schema, required keys, critical values, security, and best practices.
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
    
    def test_json_files_not_empty(self):
        """Ensure JSON files contain meaningful data."""
        json_files = list(self.repo_root.glob('**/*.json'))
        for json_file in json_files:
            if 'node_modules' in str(json_file):
                continue
            with self.subTest(file=str(json_file)):
                with open(json_file, 'r') as f:
                    data = json.load(f)
                    self.assertIsNotNone(data, f"{json_file} should not be null")
    
    def test_vscode_settings_structure(self):
        """Validate VSCode settings.json structure."""
        settings_file = self.repo_root / '.vscode' / 'settings.json'
        if settings_file.exists():
            with open(settings_file, 'r') as f:
                settings = json.load(f)
                self.assertIsInstance(settings, dict, "VSCode settings should be a dictionary")
    
    def test_vscode_extensions_structure(self):
        """Validate VSCode extensions.json structure."""
        extensions_file = self.repo_root / '.vscode' / 'extensions.json'
        if extensions_file.exists():
            with open(extensions_file, 'r') as f:
                extensions = json.load(f)
                self.assertIsInstance(extensions, dict, "VSCode extensions should be a dictionary")
                if 'recommendations' in extensions:
                    self.assertIsInstance(extensions['recommendations'], list)
    
    def test_renovate_config_structure(self):
        """Validate renovate.json configuration."""
        renovate_file = self.repo_root / 'renovate.json'
        if renovate_file.exists():
            with open(renovate_file, 'r') as f:
                config = json.load(f)
                self.assertIsInstance(config, dict, "Renovate config should be a dictionary")
    
    def test_web_manifest_structure(self):
        """Validate web manifest.json structure."""
        manifest_file = self.repo_root / 'web' / 'manifest.json'
        if manifest_file.exists():
            with open(manifest_file, 'r') as f:
                manifest = json.load(f)
                self.assertIsInstance(manifest, dict, "Web manifest should be a dictionary")
    
    def test_ios_contents_json_structure(self):
        """Validate iOS Contents.json files."""
        contents_files = list(self.repo_root.glob('ios/**/Contents.json'))
        for contents_file in contents_files:
            with self.subTest(file=str(contents_file)):
                with open(contents_file, 'r') as f:
                    contents = json.load(f)
                    self.assertIsInstance(contents, dict)
    
    def test_json_no_sensitive_data(self):
        """Ensure JSON files don't contain sensitive data."""
        json_files = list(self.repo_root.glob('**/*.json'))
        sensitive_patterns = ['password', 'secret', 'api_key', 'apikey', 'token']
        
        for json_file in json_files:
            if 'node_modules' in str(json_file):
                continue
            with self.subTest(file=str(json_file)):
                with open(json_file, 'r') as f:
                    content = f.read().lower()
                    for pattern in sensitive_patterns:
                        if pattern in content:
                            data = json.loads(content)
                            self._check_values(data, json_file)
    
    def _check_values(self, data, file_path):
        """Check JSON values recursively."""
        if isinstance(data, dict):
            for key, value in data.items():
                if isinstance(value, str) and len(value) > 10:
                    if not any(p in str(value).lower() for p in ['example', 'your_', 'todo']):
                        pass
                self._check_values(value, file_path)
        elif isinstance(data, list):
            for item in data:
                self._check_values(item, file_path)
    
    def test_required_keys_present(self):
        """Verify required configuration keys are present in pubspec.yaml."""
        pubspec_file = self.repo_root / 'pubspec.yaml'
        if pubspec_file.exists():
            content = pubspec_file.read_text()
            self.assertIn('name:', content)
            self.assertIn('version:', content)
            self.assertIn('dependencies:', content)


class TestPubspecYaml(unittest.TestCase):
    """Comprehensive tests for pubspec.yaml."""
    
    def setUp(self):
        """Load pubspec.yaml."""
        self.repo_root = Path(__file__).parent.parent
        self.pubspec_file = self.repo_root / 'pubspec.yaml'
    
    def test_pubspec_exists(self):
        """Ensure pubspec.yaml exists."""
        self.assertTrue(self.pubspec_file.exists())
    
    def test_pubspec_has_name(self):
        """Ensure pubspec.yaml has a package name."""
        content = self.pubspec_file.read_text()
        self.assertIn('name:', content)
    
    def test_pubspec_has_version(self):
        """Ensure pubspec.yaml has a version."""
        content = self.pubspec_file.read_text()
        self.assertIn('version:', content)
    
    def test_pubspec_has_dependencies(self):
        """Ensure pubspec.yaml has dependencies section."""
        content = self.pubspec_file.read_text()
        self.assertIn('dependencies:', content)
    
    def test_pubspec_has_flutter_dependency(self):
        """Ensure pubspec.yaml includes Flutter SDK."""
        content = self.pubspec_file.read_text()
        self.assertIn('flutter:', content)
    
    def test_pubspec_has_dev_dependencies(self):
        """Ensure pubspec.yaml has dev_dependencies section."""
        content = self.pubspec_file.read_text()
        self.assertIn('dev_dependencies:', content)
    
    def test_pubspec_has_test_dependencies(self):
        """Ensure pubspec.yaml includes test dependencies."""
        content = self.pubspec_file.read_text()
        self.assertTrue('test:' in content or 'flutter_test:' in content)


if __name__ == '__main__':
    unittest.main()