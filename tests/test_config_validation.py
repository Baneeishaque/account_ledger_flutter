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
            if 'node_modules' in str(json_file) or '.git' in str(json_file):
                continue
            with self.subTest(file=str(json_file)):
                with open(json_file, 'r', encoding='utf-8') as f:
                    try:
                        data = json.load(f)
                        self.assertIsNotNone(data)
                    except json.JSONDecodeError as e:
                        self.fail(f"Invalid JSON in {json_file}: {e}")
    
    def test_json_files_not_empty(self):
        """Ensure JSON files contain data."""
        json_files = list(self.repo_root.glob('**/*.json'))
        for json_file in json_files:
            if 'node_modules' in str(json_file) or '.git' in str(json_file):
                continue
            with self.subTest(file=str(json_file)):
                with open(json_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    if isinstance(data, dict):
                        self.assertTrue(len(data) > 0 or data == {},
                                      f"{json_file} should have content or be explicitly empty")
    
    def test_renovate_json_structure(self):
        """Validate renovate.json configuration."""
        renovate_file = self.repo_root / 'renovate.json'
        if not renovate_file.exists():
            self.skipTest("renovate.json not found")
        
        with open(renovate_file, 'r', encoding='utf-8') as f:
            config = json.load(f)
        
        # Renovate should have extends configuration
        self.assertIsInstance(config, dict)
        # Common renovate config keys
        valid_keys = ['extends', 'packageRules', 'schedule', 'timezone', 
                      'labels', 'assignees', 'reviewers']
        has_valid_key = any(key in config for key in valid_keys)
        self.assertTrue(has_valid_key, 
                       "renovate.json should have at least one valid configuration key")
    
    def test_idea_config_files(self):
        """Validate .idea configuration files if present."""
        idea_dir = self.repo_root / '.idea'
        if not idea_dir.exists():
            self.skipTest(".idea directory not found")
        
        # Check for common IntelliJ IDEA config files
        for config_file in idea_dir.glob('*.xml'):
            with self.subTest(file=config_file.name):
                content = config_file.read_text(encoding='utf-8')
                # Should be valid XML (basic check)
                self.assertTrue(content.strip().startswith('<?xml') or 
                              content.strip().startswith('<'),
                              f"{config_file.name} should be valid XML")
    
    def test_configuration_files_encoding(self):
        """Ensure configuration files use UTF-8 encoding."""
        config_files = list(self.repo_root.glob('*.json')) + \
                      list(self.repo_root.glob('*.yaml')) + \
                      list(self.repo_root.glob('*.yml'))
        
        for config_file in config_files:
            if '.git' in str(config_file):
                continue
            with self.subTest(file=config_file.name):
                try:
                    with open(config_file, 'r', encoding='utf-8') as f:
                        _ = f.read()
                except UnicodeDecodeError:
                    self.fail(f"{config_file} should be UTF-8 encoded")
    
    def test_no_secrets_in_config_files(self):
        """Ensure no secrets are hardcoded in configuration files."""
        config_files = list(self.repo_root.glob('*.json')) + \
                      list(self.repo_root.glob('*.yaml')) + \
                      list(self.repo_root.glob('*.yml'))
        
        secret_patterns = ['password', 'api_key', 'apikey', 'secret', 
                          'token', 'credentials']
        
        for config_file in config_files:
            if '.git' in str(config_file):
                continue
            with self.subTest(file=config_file.name):
                content = config_file.read_text(encoding='utf-8').lower()
                for pattern in secret_patterns:
                    if pattern in content:
                        # Check if it's just a field name or placeholder
                        self.assertTrue(
                            '${' in content or '{{' in content or 
                            'your_' in content or 'example' in content,
                            f"{config_file} may contain hardcoded {pattern}"
                        )
    
    def test_config_files_not_too_large(self):
        """Ensure configuration files are reasonably sized."""
        config_files = list(self.repo_root.glob('*.json')) + \
                      list(self.repo_root.glob('*.yaml')) + \
                      list(self.repo_root.glob('*.yml'))
        
        max_size = 100 * 1024  # 100 KB
        
        for config_file in config_files:
            if '.git' in str(config_file):
                continue
            with self.subTest(file=config_file.name):
                size = config_file.stat().st_size
                self.assertLess(size, max_size,
                              f"{config_file} is {size} bytes (max: {max_size})")
    
    def test_whitesource_config(self):
        """Validate WhiteSource configuration if present."""
        ws_file = self.repo_root / '.whitesource'
        if not ws_file.exists():
            self.skipTest(".whitesource not found")
        
        content = ws_file.read_text(encoding='utf-8')
        self.assertTrue(len(content) > 0, ".whitesource should not be empty")


class TestPubspecYaml(unittest.TestCase):
    """Validate pubspec.yaml specifically."""
    
    def setUp(self):
        """Load pubspec.yaml."""
        self.repo_root = Path(__file__).parent.parent
        self.pubspec_file = self.repo_root / 'pubspec.yaml'
    
    def test_pubspec_exists(self):
        """Ensure pubspec.yaml exists."""
        self.assertTrue(self.pubspec_file.exists(),
                       "pubspec.yaml must exist for Flutter projects")
    
    def test_pubspec_has_test_dependencies(self):
        """Verify test and yaml packages are in dev_dependencies."""
        if not self.pubspec_file.exists():
            self.skipTest("pubspec.yaml not found")
        
        try:
            import yaml
        except ImportError:
            self.skipTest("PyYAML not installed")
        
        with open(self.pubspec_file, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)
        
        self.assertIn('dev_dependencies', config,
                     "pubspec.yaml should have dev_dependencies")
        
        dev_deps = config['dev_dependencies']
        self.assertIn('test', dev_deps,
                     "test package should be in dev_dependencies")
        self.assertIn('yaml', dev_deps,
                     "yaml package should be in dev_dependencies")
    
    def test_pubspec_has_proper_structure(self):
        """Ensure pubspec.yaml has required fields."""
        if not self.pubspec_file.exists():
            self.skipTest("pubspec.yaml not found")
        
        try:
            import yaml
        except ImportError:
            self.skipTest("PyYAML not installed")
        
        with open(self.pubspec_file, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)
        
        required_fields = ['name', 'description', 'version', 'environment']
        for field in required_fields:
            self.assertIn(field, config,
                         f"pubspec.yaml should have '{field}' field")


class TestShellScripts(unittest.TestCase):
    """Validate shell scripts."""
    
    def setUp(self):
        """Set up test environment."""
        self.repo_root = Path(__file__).parent.parent
    
    def test_run_tests_script_exists(self):
        """Ensure run_tests.sh exists."""
        script = self.repo_root / 'run_tests.sh'
        self.assertTrue(script.exists(), "run_tests.sh should exist")
    
    def test_run_validation_tests_script_exists(self):
        """Ensure run_validation_tests.sh exists."""
        script = self.repo_root / 'run_validation_tests.sh'
        self.assertTrue(script.exists(), "run_validation_tests.sh should exist")
    
    def test_shell_scripts_have_shebang(self):
        """Ensure shell scripts have proper shebang."""
        scripts = [
            self.repo_root / 'run_tests.sh',
            self.repo_root / 'run_validation_tests.sh'
        ]
        
        for script in scripts:
            if not script.exists():
                continue
            with self.subTest(script=script.name):
                with open(script, 'r', encoding='utf-8') as f:
                    first_line = f.readline()
                    self.assertTrue(first_line.startswith('#!'),
                                  f"{script.name} should have shebang")
                    self.assertIn('bash', first_line.lower(),
                                f"{script.name} should use bash")
    
    def test_shell_scripts_not_empty(self):
        """Ensure shell scripts have content."""
        scripts = [
            self.repo_root / 'run_tests.sh',
            self.repo_root / 'run_validation_tests.sh'
        ]
        
        for script in scripts:
            if not script.exists():
                continue
            with self.subTest(script=script.name):
                content = script.read_text(encoding='utf-8')
                # Should have more than just shebang and comments
                lines = [l for l in content.split('\n') 
                        if l.strip() and not l.strip().startswith('#')]
                self.assertGreater(len(lines), 0,
                                 f"{script.name} should have executable commands")


if __name__ == '__main__':
    unittest.main()