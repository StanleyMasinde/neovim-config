# PHP Development Setup

This Neovim configuration now includes comprehensive PHP and PHPStan support.

## Features Added

### 1. Language Server Protocol (LSP)
- **Intelephense**: Full-featured PHP language server with intelligent code completion, go-to-definition, hover information, and more
- Auto-completion with use statement insertion
- Diagnostics and error detection
- Code formatting support

### 2. Static Analysis
- **PHPStan**: Advanced static analysis for PHP code
- Integrated with nvim-lint for real-time analysis
- Customizable analysis levels (0-8)

### 3. Code Formatting
- **PHP-CS-Fixer**: Automatic code formatting following PSR standards
- Integrated with conform.nvim
- Configurable coding standards

### 4. Syntax Highlighting
- PHP syntax highlighting via nvim-treesitter
- Support for PHP 8+ features

### 5. Debugging Support
- **PHP Debug Adapter**: Full debugging support with Xdebug
- Breakpoints, step-through debugging, variable inspection
- Support for local scripts and web server debugging

## Installation

### Via Mason (Recommended)
1. Open Neovim
2. Run `:MasonInstall intelephense phpstan php-cs-fixer php-debug-adapter`

### Via Package Manager
```bash
# Install PHP and PHPStan
brew install php phpstan/phpstan/phpstan

# Install PHP-CS-Fixer globally
composer global require friendsofphp/php-cs-fixer
```

## Configuration

### PHPStan Configuration
Create a `phpstan.neon` file in your project root:

```neon
parameters:
    level: 8
    paths:
        - src
        - tests
    excludePaths:
        - vendor
```

### PHP-CS-Fixer Configuration
Create a `.php-cs-fixer.php` file in your project root:

```php
<?php

return (new PhpCsFixer\Config())
    ->setRules([
        '@PSR12' => true,
        'array_syntax' => ['syntax' => 'short'],
        'ordered_imports' => ['sort_algorithm' => 'alpha'],
        'no_unused_imports' => true,
    ])
    ->setFinder(
        PhpCsFixer\Finder::create()
            ->in(__DIR__)
            ->exclude('vendor')
    );
```

### Xdebug Configuration
For debugging support, configure Xdebug in your `php.ini`:

```ini
[xdebug]
zend_extension=xdebug
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.client_host=127.0.0.1
xdebug.client_port=9003
xdebug.log=/tmp/xdebug.log
```

For Docker environments, use:
```ini
xdebug.client_host=host.docker.internal
```

## Key Mappings

All mappings use the leader key (`<space>`):

### PHP-Specific Mappings
- `<space>pl` - Run PHPStan analysis on current file
- `<space>pf` - Format current PHP file with PHP-CS-Fixer

### General LSP Mappings (work with PHP)
- `<space>gd` - Go to definition
- `<space>ac` - Show code actions
- `<space>er` - Jump to next diagnostic/error
- `<space>fm` - Format file (general formatting)

### Linting
- `<space>l` - Trigger linting for current file

### Debugging Mappings
- `<space>db` - Toggle breakpoint
- `<space>dc` - Continue debugging
- `<space>dso` - Step over
- `<space>dsi` - Step into
- `<space>dsO` - Step out
- `<space>dt` - Toggle DAP UI
- `<space>dp` - Start PHP Xdebug listener
- `<space>dx` - Terminate debugging session

## Usage Tips

1. **Intelephense License**: For advanced features, consider getting an Intelephense premium license
2. **Project Setup**: Ensure your PHP project has proper composer.json and autoloading configured
3. **PHPStan Baseline**: For existing projects, consider creating a PHPStan baseline to gradually improve code quality
4. **Formatting on Save**: Uncomment the format_on_save section in `lua/configs/conform.lua` to enable automatic formatting

## Troubleshooting

### Common Issues
1. **LSP not working**: Ensure PHP is in your PATH and Intelephense is installed
2. **PHPStan errors**: Check if PHPStan is installed and accessible via command line
3. **Formatting not working**: Verify PHP-CS-Fixer installation and configuration

### Debugging
- Use `:Mason` to check installed tools
- Use `:LspInfo` to check LSP server status
- Use `:checkhealth` to verify Neovim configuration
