# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

A lightweight bash utility for searching error and exception keywords in files. Useful for debugging log files and identifying issues quickly across system outputs.

## Architecture

The project follows a **single-responsibility pattern**:

```
repository/
├── search_errors.sh          # Main utility - searches for error keywords in files
├── test_search_errors.sh     # Comprehensive unit test suite (18 tests)
├── .github/workflows/        # CI/CD automation
│   └── run-tests.yml         # Runs tests automatically on push/PR
└── .claude/                  # Claude Code configuration
```

**Key Design:**
- Pure bash script (no build system, no dependencies)
- Case-insensitive pattern matching for 10 keywords: exception, error, fatal, critical, failed, failure, invalid, undefined, null, crash
- Accepts single filename as argument
- Clear output formatting with visual delimiters
- Comprehensive error handling for missing files/arguments

## Common Commands

### Running the Script
```bash
./search_errors.sh <filename>
```

### Running Tests
```bash
./test_search_errors.sh
```
Executes 18 unit tests covering edge cases: missing args, missing files, empty files, each keyword, case-insensitivity, special characters, large files, multiple errors.

### Making Scripts Executable
```bash
chmod +x search_errors.sh test_search_errors.sh
```

### CI/CD
Tests run automatically via GitHub Actions on:
- Push to main branch
- Pull requests against main
- **Platform:** ubuntu-latest
- **Trigger file:** `.github/workflows/run-tests.yml`

## Development Notes

**Testing Strategy:**
- Unit tests use a temporary directory (`/tmp/search_errors_test_$$`) for isolated test files
- Tests validate both exit codes and output content
- Cleanup happens automatically via trap EXIT

**Error Handling:**
- Exit code 1: Invalid arguments or file not found
- Exit code 0: Search completed (may find 0 or more errors)
- Clear error messages guide users to correct usage

**Future Enhancements:**
- Currently planned: Support for multiple file arguments (see `.claude/settings.local.json`)
