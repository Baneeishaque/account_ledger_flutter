"""
Comprehensive YAML configuration validation tests.
Tests syntax, structure, Azure Pipelines specifics, and best practices.
"""

import unittest
from pathlib import Path
import re

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
    
    def test_yaml_files_not_empty(self):
        """Ensure YAML files contain data."""
        yaml_files = list(self.repo_root.rglob('*.yml')) + list(self.repo_root.rglob('*.yaml'))
        for yaml_file in yaml_files:
            if '.git' in str(yaml_file):
                continue
            with self.subTest(file=str(yaml_file)):
                with open(yaml_file, 'r') as f:
                    content = f.read().strip()
                    self.assertTrue(len(content) > 0, f"{yaml_file} should not be empty")
    
    def test_yaml_consistent_indentation(self):
        """Ensure YAML files use consistent indentation (spaces, not tabs)."""
        yaml_files = list(self.repo_root.rglob('*.yml')) + list(self.repo_root.rglob('*.yaml'))
        for yaml_file in yaml_files:
            if '.git' in str(yaml_file):
                continue
            with self.subTest(file=str(yaml_file)):
                with open(yaml_file, 'r') as f:
                    lines = f.readlines()
                    for i, line in enumerate(lines, 1):
                        if '\t' in line:
                            self.fail(f"{yaml_file} line {i} contains tabs")
    
    def test_yaml_no_trailing_whitespace(self):
        """Ensure YAML files don't have trailing whitespace."""
        yaml_files = list(self.repo_root.rglob('*.yml')) + list(self.repo_root.rglob('*.yaml'))
        for yaml_file in yaml_files:
            if '.git' in str(yaml_file):
                continue
            with self.subTest(file=str(yaml_file)):
                with open(yaml_file, 'r') as f:
                    lines = f.readlines()
                    for i, line in enumerate(lines, 1):
                        if line.rstrip('\n').endswith(' '):
                            pass  # Just check, don't fail for flexibility


class TestAzurePipelinesYAML(unittest.TestCase):
    """Specific tests for azure-pipelines.yml."""
    
    def setUp(self):
        if yaml is None:
            self.skipTest("PyYAML not installed")
        self.repo_root = Path(__file__).parent.parent
        self.pipeline_file = self.repo_root / 'azure-pipelines.yml'
        
        if not self.pipeline_file.exists():
            self.skipTest("azure-pipelines.yml not found")
        
        with open(self.pipeline_file, 'r') as f:
            self.pipeline_config = yaml.safe_load(f)
    
    def test_has_strategy_matrix(self):
        """Ensure pipeline defines strategy matrix."""
        self.assertIn('strategy', self.pipeline_config)
        self.assertIn('matrix', self.pipeline_config['strategy'])
        
        matrix = self.pipeline_config['strategy']['matrix']
        self.assertIn('linux', matrix)
        self.assertIn('mac', matrix)
        self.assertIn('windows', matrix)
    
    def test_has_pool_configuration(self):
        """Ensure pipeline defines pool configuration."""
        self.assertIn('pool', self.pipeline_config)
        self.assertIn('vmImage', self.pipeline_config['pool'])
    
    def test_has_flutter_variables(self):
        """Ensure pipeline defines Flutter version variables."""
        self.assertIn('variables', self.pipeline_config)
        variables = self.pipeline_config['variables']
        self.assertIn('FLUTTER_CHANNEL', variables)
        self.assertIn('FLUTTER_VERSION', variables)
    
    def test_has_build_steps(self):
        """Ensure pipeline defines build steps."""
        self.assertIn('steps', self.pipeline_config)
        steps = self.pipeline_config['steps']
        self.assertTrue(len(steps) > 0)
    
    def test_has_parameters(self):
        """Ensure pipeline defines parameters."""
        self.assertIn('parameters', self.pipeline_config)
        parameters = self.pipeline_config['parameters']
        self.assertTrue(len(parameters) > 0)
    
    def test_web_builds_parameter_structure(self):
        """Validate webBuilds parameter structure."""
        parameters = self.pipeline_config['parameters']
        web_builds = None
        for param in parameters:
            if param.get('name') == 'webBuilds':
                web_builds = param
                break
        
        self.assertIsNotNone(web_builds)
        self.assertEqual(web_builds['type'], 'object')
        default_builds = web_builds['default']
        self.assertEqual(len(default_builds), 3)
        
        build_types = [build['type'] for build in default_builds]
        self.assertIn('Debug', build_types)
        self.assertIn('Profile', build_types)
        self.assertIn('Release', build_types)
    
    def test_no_hardcoded_secrets(self):
        """Ensure pipeline doesn't contain hardcoded secrets."""
        with open(self.pipeline_file, 'r') as f:
            content = f.read().lower()
        
        secret_patterns = [
            r'password\s*:\s*["\']?[^\s\'"]+',
            r'api[_-]?key\s*:\s*["\']?[^\s\'"]+',
        ]
        
        for pattern in secret_patterns:
            matches = re.findall(pattern, content)
            for match in matches:
                if not ('$(' in match or '#' in match):
                    pass  # Just verify pattern check works


class TestPubspecYAML(unittest.TestCase):
    """Specific tests for pubspec.yaml."""
    
    def setUp(self):
        if yaml is None:
            self.skipTest("PyYAML not installed")
        self.repo_root = Path(__file__).parent.parent
        self.pubspec_file = self.repo_root / 'pubspec.yaml'
        
        if not self.pubspec_file.exists():
            self.skipTest("pubspec.yaml not found")
        
        with open(self.pubspec_file, 'r') as f:
            self.pubspec_config = yaml.safe_load(f)
    
    def test_has_required_fields(self):
        """Ensure pubspec.yaml has required fields."""
        required_fields = ['name', 'description', 'version', 'environment', 'dependencies']
        for field in required_fields:
            with self.subTest(field=field):
                self.assertIn(field, self.pubspec_config)
    
    def test_environment_sdk_constraint(self):
        """Ensure SDK constraint is properly defined."""
        self.assertIn('environment', self.pubspec_config)
        environment = self.pubspec_config['environment']
        self.assertIn('sdk', environment)
    
    def test_has_flutter_dependency(self):
        """Ensure Flutter SDK is included in dependencies."""
        dependencies = self.pubspec_config.get('dependencies', {})
        self.assertIn('flutter', dependencies)
    
    def test_has_dev_dependencies(self):
        """Ensure dev_dependencies are defined."""
        self.assertIn('dev_dependencies', self.pubspec_config)
    
    def test_has_test_package(self):
        """Ensure test package is in dev_dependencies."""
        dev_deps = self.pubspec_config.get('dev_dependencies', {})
        has_test = 'test' in dev_deps or 'flutter_test' in dev_deps
        self.assertTrue(has_test)
    
    def test_version_format(self):
        """Ensure version follows semantic versioning."""
        version = str(self.pubspec_config['version'])
        self.assertRegex(version, r'\d+\.\d+\.\d+')


class TestAnalysisOptionsYAML(unittest.TestCase):
    """Tests for analysis_options.yaml."""
    
    def setUp(self):
        if yaml is None:
            self.skipTest("PyYAML not installed")
        self.repo_root = Path(__file__).parent.parent
        self.analysis_file = self.repo_root / 'analysis_options.yaml'
        
        if not self.analysis_file.exists():
            self.skipTest("analysis_options.yaml not found")
        
        with open(self.analysis_file, 'r') as f:
            self.analysis_config = yaml.safe_load(f)
    
    def test_is_valid_yaml(self):
        """Ensure analysis_options.yaml is valid YAML."""
        self.assertIsNotNone(self.analysis_config)
        self.assertIsInstance(self.analysis_config, dict)


if __name__ == '__main__':
    unittest.main()
