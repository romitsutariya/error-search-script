# search_errors.sh

[![Run Unit Tests](https://github.com/romitsutariya/error-search-script/actions/workflows/run-tests.yml/badge.svg)](https://github.com/romitsutariya/error-search-script/actions/workflows/run-tests.yml)
[![Tests Passing](https://img.shields.io/badge/tests-passing-brightgreen?style=flat-square)]()

A lightweight bash utility for searching error and exception keywords in log files and text documents.

## What the Script Does

`search_errors.sh` scans a file for common error and exception-related keywords using case-insensitive pattern matching. It helps developers and DevOps engineers quickly identify issues in log files, configuration outputs, and system debug logs.

**Searched Keywords:**
- `exception`
- `error`
- `fatal`
- `critical`
- `failed`
- `failure`
- `invalid`
- `undefined`
- `null`
- `crash`

All keyword searches are case-insensitive (finds ERROR, Error, error, etc.).

## Usage

```bash
./search_errors.sh <filename>
```

### Examples

```bash
# Search for errors in a log file
./search_errors.sh application.log

# Search in a system debug output
./search_errors.sh system_debug.txt

# Search in configuration file
./search_errors.sh config.txt
```

### Output

The script outputs all matching lines in a formatted display:

```
Searching for exceptions and errors in: application.log
==============================================
Line 5: An error occurred in the database module
Line 12: WARNING: Critical failure detected
Line 23: NullPointerException at handler
==============================================
Search completed. Results shown above.
```

If no errors are found:

```
No exceptions or errors found.
```

## Exit Codes

- **0**: Search completed successfully
- **1**: Missing filename argument or file not found

## Requirements

- Bash shell
- Standard Unix tools (`grep`)

Works on:
- Linux
- macOS
- Unix systems
- Windows (via WSL or Git Bash)

## Testing

Run the comprehensive test suite:

```bash
./test_search_errors.sh
```

The test suite includes 18 tests covering:
- Missing arguments and missing files
- Empty files and large files (1000+ lines)
- Each individual keyword
- Case-insensitive searching
- Special characters
- Multiple errors in one file

## Development

To prepare for development:

```bash
# Make scripts executable
chmod +x search_errors.sh test_search_errors.sh

# Run tests locally
./test_search_errors.sh

# Run the script
./search_errors.sh <filename>
```

Tests automatically run on every push and pull request via GitHub Actions.

## License

MIT
