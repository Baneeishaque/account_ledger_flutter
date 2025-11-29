"""
YAML configuration validation tests.
Comprehensive validation for all YAML files in the repository.
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
        yaml_files = list(self.repo_root.rglob('*.yml')) + \
                    list(self.repo_root.rglob('*.yaml'))
        
        for yaml_file in yaml_files:
            if '.git' in str(yaml_file):
                continue
            with self.subTest(file=str(yaml_file)):
                with open(yaml_file, 'r', encoding='utf-8') as f:
                    try:
                        data = yaml.safe_load(f)
                        self.assertIsNotNone(data)
                    except yaml.YAMLError as e:
                        self.fail(f"Invalid YAML in {yaml_file}: {e}")
    
    def test_yaml_files_not_empty(self):
        """Ensure YAML files contain data."""
        yaml_files = list(self.repo_root.rglob('*.yml')) + \
                    list(self.repo_root.rglob('*.yaml'))
        
        for yaml_file in yaml_files:
            if '.git' in str(yaml_file):
                continue
            with self.subTest(file=str(yaml_file)):
                with open(yaml_file, 'r', encoding='utf-8') as f:
                    content = f.read().strip()
                    self.assertTrue(len(content) > 0,
                                  f"{yaml_file} should not be empty")
    
    def test_azure_pipelines_structure(self):
        """Validate azure-pipelines.yml structure."""
        pipeline_file = self.repo_root / 'azure-pipelines.yml'
        if not pipeline_file.exists():
            self.skipTest("azure-pipelines.yml not found")
        
        with open(pipeline_file, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)
        
        # Check for essential Azure Pipelines keys
        self.assertIn('strategy', config, "Pipeline should have strategy")
        self.assertIn('pool', config, "Pipeline should have pool")
        self.assertIn('steps', config, "Pipeline should have steps")
    
    def test_azure_pipelines_has_flutter_config(self):
        """Ensure Azure Pipelines has Flutter configuration."""
        pipeline_file = self.repo_root / 'azure-pipelines.yml'
        if not pipeline_file.exists():
            self.skipTest("azure-pipelines.yml not found")
        
        with open(pipeline_file, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)
        
        # Should have Flutter version variables
        self.assertIn('variables', config)
        variables = config['variables']
        
        self.assertIn('FLUTTER_VERSION', variables,
                     "Should specify Flutter version")
        self.assertIn('FLUTTER_CHANNEL', variables,
                     "Should specify Flutter channel")
    
    def test_azure_pipelines_has_parameters(self):
        """Ensure Azure Pipelines has webBuilds parameter."""
        pipeline_file = self.repo_root / 'azure-pipelines.yml'
        if not pipeline_file.exists():
            self.skipTest("azure-pipelines.yml not found")
        
        with open(pipeline_file, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)
        
        self.assertIn('parameters', config,
                     "Pipeline should have parameters section")
        
        parameters = config['parameters']
        self.assertIsInstance(parameters, list)
        
        # Find webBuilds parameter
        web_builds_param = None
        for param in parameters:
            if param.get('name') == 'webBuilds':
                web_builds_param = param
                break
        
        self.assertIsNotNone(web_builds_param,
                           "Should have webBuilds parameter")
        self.assertEqual(web_builds_param['type'], 'object')
    
    def test_pubspec_yaml_structure(self):
        """Validate pubspec.yaml structure."""
        pubspec_file = self.repo_root / 'pubspec.yaml'
        if not pubspec_file.exists():
            self.skipTest("pubspec.yaml not found")
        
        with open(pubspec_file, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)
        
        # Essential Flutter project fields
        required_fields = ['name', 'description', 'version', 
                          'environment', 'dependencies', 'dev_dependencies']
        
        for field in required_fields:
            self.assertIn(field, config,
                         f"pubspec.yaml should have '{field}' field")
    
    def test_analysis_options_structure(self):
        """Validate analysis_options.yaml structure."""
        analysis_file = self.repo_root / 'analysis_options.yaml'
        if not analysis_file.exists():
            self.skipTest("analysis_options.yaml not found")
        
        with open(analysis_file, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)
        
        # Should have linter configuration
        self.assertIsInstance(config, dict)
        # Common analysis options keys
        valid_keys = ['include', 'analyzer', 'linter']
        has_valid_key = any(key in config for key in valid_keys)
        self.assertTrue(has_valid_key,
                       "analysis_options.yaml should have linter configuration")
    
    def test_yaml_no_tabs(self):
        """Ensure YAML files use spaces, not tabs."""
        yaml_files = list(self.repo_root.rglob('*.yml')) + \
                    list(self.repo_root.rglob('*.yaml'))
        
        for yaml_file in yaml_files:
            if '.git' in str(yaml_file):
                continue
            with self.subTest(file=str(yaml_file)):
                with open(yaml_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                    self.assertNotIn('\t', content,
                                   f"{yaml_file} should use spaces, not tabs")
    
    def test_yaml_no_trailing_whitespace(self):
        """Ensure YAML files don't have trailing whitespace."""
        yaml_files = list(self.repo_root.rglob('*.yml')) + \
                    list(self.repo_root.rglob('*.yaml'))
        
        for yaml_file in yaml_files:
            if '.git' in str(yaml_file):
                continue
            with self.subTest(file=str(yaml_file)):
                with open(yaml_file, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    for i, line in enumerate(lines, 1):
                        # Remove newline and check if line ends with space
                        clean_line = line.rstrip('\n\r')
                        self.assertFalse(
                            clean_line.endswith(' ') or clean_line.endswith('\t'),
                            f"{yaml_file} line {i} has trailing whitespace"
                        )
    
    def test_yaml_proper_encoding(self):
        """Ensure YAML files are UTF-8 encoded."""
        yaml_files = list(self.repo_root.rglob('*.yml')) + \
                    list(self.repo_root.rglob('*.yaml'))
        
        for yaml_file in yaml_files:
            if '.git' in str(yaml_file):
                continue
            with self.subTest(file=str(yaml_file)):
                try:
                    with open(yaml_file, 'r', encoding='utf-8') as f:
                        _ = f.read()
                except UnicodeDecodeError:
                    self.fail(f"{yaml_file} should be UTF-8 encoded")
    
    def test_yaml_reasonable_size(self):
        """Ensure YAML files are reasonably sized."""
        yaml_files = list(self.repo_root.rglob('*.yml')) + \
                    list(self.repo_root.rglob('*.yaml'))
        
        max_size = 100 * 1024  # 100 KB
        
        for yaml_file in yaml_files:
            if '.git' in str(yaml_file):
                continue
            with self.subTest(file=str(yaml_file)):
                size = yaml_file.stat().st_size
                self.assertLess(size, max_size,
                              f"{yaml_file} is {size} bytes (exceeds {max_size})")


class TestAzurePipelinesSpecific(unittest.TestCase):
    """Specific tests for Azure Pipelines configuration."""
    
    def setUp(self):
        if yaml is None:
            self.skipTest("PyYAML not installed")
        self.repo_root = Path(__file__).parent.parent
        self.pipeline_file = self.repo_root / 'azure-pipelines.yml'
    
    def test_has_multi_platform_strategy(self):
        """Ensure pipeline builds for multiple platforms."""
        if not self.pipeline_file.exists():
            self.skipTest("azure-pipelines.yml not found")
        
        with open(self.pipeline_file, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)
        
        strategy = config.get('strategy', {})
        matrix = strategy.get('matrix', {})
        
        # Should build for at least 2 platforms
        self.assertGreaterEqual(len(matrix), 2,
                               "Should build for multiple platforms")
    
    def test_has_flutter_install_step(self):
        """Ensure pipeline installs Flutter."""
        if not self.pipeline_file.exists():
            self.skipTest("azure-pipelines.yml not found")
        
        with open(self.pipeline_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Should have FlutterInstall task
        self.assertIn('FlutterInstall', content,
                     "Pipeline should install Flutter")
    
    def test_has_web_build_configuration(self):
        """Ensure pipeline builds for web."""
        if not self.pipeline_file.exists():
            self.skipTest("azure-pipelines.yml not found")
        
        with open(self.pipeline_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Should have web build target
        self.assertIn("target: 'web'", content,
                     "Pipeline should build web target")


if __name__ == '__main__':
    unittest.main()
