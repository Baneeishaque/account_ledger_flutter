"""
Tests for markdown documentation files.
Validates markdown syntax, structure, and content quality.
"""

import unittest
import re
from pathlib import Path


class TestMarkdownFiles(unittest.TestCase):
    """Validate markdown documentation."""
    
    def setUp(self):
        """Set up test fixtures."""
        self.repo_root = Path(__file__).parent.parent
        self.copilot_instructions = self.repo_root / '.github' / 'copilot-instructions.md'
        self.test_readme = self.repo_root / 'test' / 'README.md'
        self.config_readme = self.repo_root / 'test' / 'config_validation' / 'README.md'
    
    def test_copilot_instructions_exists(self):
        """Verify copilot-instructions.md exists."""
        self.assertTrue(
            self.copilot_instructions.exists(),
            "copilot-instructions.md should exist in .github directory"
        )
    
    def test_readme_files_exist(self):
        """Verify README files exist."""
        self.assertTrue(
            self.test_readme.exists(),
            "test/README.md should exist"
        )
        self.assertTrue(
            self.config_readme.exists(),
            "test/config_validation/README.md should exist"
        )
    
    def test_markdown_files_not_empty(self):
        """Ensure markdown files have content."""
        md_files = [self.copilot_instructions, self.test_readme, self.config_readme]
        for md_file in md_files:
            if md_file.exists():
                with self.subTest(file=md_file.name):
                    with open(md_file, 'r') as f:
                        content = f.read().strip()
                        self.assertTrue(
                            len(content) > 0,
                            f"{md_file} should not be empty"
                        )
    
    def test_markdown_has_headings(self):
        """Verify markdown files have proper heading structure."""
        md_files = [self.copilot_instructions, self.test_readme, self.config_readme]
        for md_file in md_files:
            if md_file.exists():
                with self.subTest(file=md_file.name):
                    with open(md_file, 'r') as f:
                        content = f.read()
                        
                        # Should have at least one heading
                        headings = re.findall(r'^#{1,6}\s+.+$', content, re.MULTILINE)
                        self.assertTrue(
                            len(headings) > 0,
                            f"{md_file} should have headings"
                        )
    
    def test_copilot_instructions_has_required_sections(self):
        """Verify copilot-instructions.md has required sections."""
        if not self.copilot_instructions.exists():
            self.skipTest("copilot-instructions.md not found")
        
        with open(self.copilot_instructions, 'r') as f:
            content = f.read()
            
            required_sections = [
                'Branch Safety',
                'Project Overview',
                'Key Architecture',
                'Developer Workflows',
                'Project Conventions',
                'Integration Points',
                'Examples',
                'References'
            ]
            
            for section in required_sections:
                with self.subTest(section=section):
                    self.assertIn(
                        section,
                        content,
                        f"Should have '{section}' section"
                    )
    
    def test_copilot_instructions_mentions_flutter(self):
        """Verify copilot-instructions.md mentions Flutter."""
        if not self.copilot_instructions.exists():
            self.skipTest("copilot-instructions.md not found")
        
        with open(self.copilot_instructions, 'r') as f:
            content = f.read().lower()
            self.assertIn('flutter', content, "Should mention Flutter")
    
    def test_markdown_code_blocks_balanced(self):
        """Verify code blocks are properly closed."""
        md_files = [self.copilot_instructions, self.test_readme, self.config_readme]
        for md_file in md_files:
            if md_file.exists():
                with self.subTest(file=md_file.name):
                    with open(md_file, 'r') as f:
                        content = f.read()
                        
                        # Count code fence markers
                        fence_count = content.count('```')
                        self.assertEqual(
                            fence_count % 2,
                            0,
                            f"{md_file} should have balanced code fences"
                        )
    
    def test_markdown_inline_code_balanced(self):
        """Verify inline code markers are balanced."""
        md_files = [self.copilot_instructions, self.test_readme, self.config_readme]
        for md_file in md_files:
            if md_file.exists():
                with self.subTest(file=md_file.name):
                    with open(md_file, 'r') as f:
                        content = f.read()
                        
                        # Count inline code markers (excluding code blocks)
                        lines = content.split('\n')
                        for i, line in enumerate(lines):
                            # Skip code block lines
                            if line.strip().startswith('```'):
                                continue
                            
                            backtick_count = line.count('`')
                            if backtick_count > 0:
                                self.assertEqual(
                                    backtick_count % 2,
                                    0,
                                    f"{md_file} line {i+1} has unbalanced backticks"
                                )
    
    def test_markdown_no_trailing_whitespace(self):
        """Verify markdown files don't have trailing whitespace."""
        md_files = [self.copilot_instructions, self.test_readme, self.config_readme]
        for md_file in md_files:
            if md_file.exists():
                with self.subTest(file=md_file.name):
                    with open(md_file, 'r') as f:
                        lines = f.readlines()
                        
                        for i, line in enumerate(lines):
                            # Remove newline for checking
                            line_content = line.rstrip('\n\r')
                            if line_content and line_content != line_content.rstrip():
                                self.fail(
                                    f"{md_file} line {i+1} has trailing whitespace"
                                )
    
    def test_config_readme_documents_test_files(self):
        """Verify config_validation README documents test files."""
        if not self.config_readme.exists():
            self.skipTest("config_validation/README.md not found")
        
        with open(self.config_readme, 'r') as f:
            content = f.read()
            
            # Should mention the test files
            self.assertIn(
                'azure_pipelines_validation_test.dart',
                content,
                "Should document azure pipelines test"
            )
            self.assertIn(
                'copilot_instructions_validation_test.dart',
                content,
                "Should document copilot instructions test"
            )
    
    def test_readme_has_run_instructions(self):
        """Verify README files have instructions for running tests."""
        if self.config_readme.exists():
            with open(self.config_readme, 'r') as f:
                content = f.read()
                
                # Should have flutter test command
                self.assertIn(
                    'flutter test',
                    content,
                    "Should provide flutter test command"
                )
    
    def test_markdown_links_format(self):
        """Verify markdown links are properly formatted."""
        md_files = [self.copilot_instructions, self.test_readme, self.config_readme]
        for md_file in md_files:
            if md_file.exists():
                with self.subTest(file=md_file.name):
                    with open(md_file, 'r') as f:
                        content = f.read()
                        
                        # Find all markdown links [text](url)
                        links = re.findall(r'\[([^\]]+)\]\(([^\)]+)\)', content)
                        
                        for text, url in links:
                            # Text should not be empty
                            self.assertTrue(
                                len(text.strip()) > 0,
                                f"{md_file} has link with empty text"
                            )
                            # URL should not be empty
                            self.assertTrue(
                                len(url.strip()) > 0,
                                f"{md_file} has link with empty URL"
                            )


if __name__ == '__main__':
    unittest.main()