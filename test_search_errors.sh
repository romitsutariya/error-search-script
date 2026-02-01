#!/bin/bash

# Unit tests for search_errors.sh script
# This script tests various scenarios for the error/exception search functionality

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Setup test environment
TEST_DIR="/tmp/search_errors_test_$$"
mkdir -p "$TEST_DIR"

# Cleanup function
cleanup() {
    rm -rf "$TEST_DIR"
}

trap cleanup EXIT

# Test helper function
run_test() {
    local test_name="$1"
    local expected_result="$2"
    shift 2
    local command=("$@")

    TESTS_RUN=$((TESTS_RUN + 1))

    echo -n "Test $TESTS_RUN: $test_name ... "

    # Run the command and capture output and exit code
    output=$("${command[@]}" 2>&1)
    exit_code=$?

    if [[ "$expected_result" == "exit:0" && $exit_code -eq 0 ]] || \
       [[ "$expected_result" == "exit:1" && $exit_code -eq 1 ]] || \
       [[ "$output" == *"$expected_result"* ]]; then
        echo -e "${GREEN}PASSED${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}FAILED${NC}"
        echo "  Expected: $expected_result"
        echo "  Got: $output"
        echo "  Exit code: $exit_code"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Test 1: No arguments provided
run_test "No arguments provided" "Usage:" bash search_errors.sh

# Test 2: File not found
run_test "File not found" "Error: File" bash search_errors.sh /nonexistent/file.txt

# Test 3: File exists but no errors
TEST_FILE="$TEST_DIR/no_errors.txt"
echo "This is a normal log file with no issues" > "$TEST_FILE"
run_test "File with no errors" "No exceptions or errors found" bash search_errors.sh "$TEST_FILE"

# Test 4: File with 'error' keyword
TEST_FILE="$TEST_DIR/with_error.txt"
echo "An error occurred in the system" > "$TEST_FILE"
run_test "File with 'error' keyword" "error" bash search_errors.sh "$TEST_FILE"

# Test 5: File with 'exception' keyword
TEST_FILE="$TEST_DIR/with_exception.txt"
echo "Java exception thrown at line 42" > "$TEST_FILE"
run_test "File with 'exception' keyword" "exception" bash search_errors.sh "$TEST_FILE"

# Test 6: File with 'fatal' keyword
TEST_FILE="$TEST_DIR/with_fatal.txt"
echo "FATAL: System failure detected" > "$TEST_FILE"
run_test "File with 'fatal' keyword" "fatal" bash search_errors.sh "$TEST_FILE"

# Test 7: File with 'critical' keyword
TEST_FILE="$TEST_DIR/with_critical.txt"
echo "Critical error in database connection" > "$TEST_FILE"
run_test "File with 'critical' keyword" "critical" bash search_errors.sh "$TEST_FILE"

# Test 8: File with 'failed' keyword
TEST_FILE="$TEST_DIR/with_failed.txt"
echo "Request failed with status 500" > "$TEST_FILE"
run_test "File with 'failed' keyword" "failed" bash search_errors.sh "$TEST_FILE"

# Test 9: File with 'failure' keyword
TEST_FILE="$TEST_DIR/with_failure.txt"
echo "Network failure detected" > "$TEST_FILE"
run_test "File with 'failure' keyword" "failure" bash search_errors.sh "$TEST_FILE"

# Test 10: File with 'invalid' keyword
TEST_FILE="$TEST_DIR/with_invalid.txt"
echo "Invalid input provided" > "$TEST_FILE"
run_test "File with 'invalid' keyword" "invalid" bash search_errors.sh "$TEST_FILE"

# Test 11: File with 'undefined' keyword
TEST_FILE="$TEST_DIR/with_undefined.txt"
echo "Variable undefined in scope" > "$TEST_FILE"
run_test "File with 'undefined' keyword" "undefined" bash search_errors.sh "$TEST_FILE"

# Test 12: File with 'null' keyword
TEST_FILE="$TEST_DIR/with_null.txt"
echo "NullPointerException: null reference" > "$TEST_FILE"
run_test "File with 'null' keyword" "null" bash search_errors.sh "$TEST_FILE"

# Test 13: File with 'crash' keyword
TEST_FILE="$TEST_DIR/with_crash.txt"
echo "Application crashed unexpectedly" > "$TEST_FILE"
run_test "File with 'crash' keyword" "crash" bash search_errors.sh "$TEST_FILE"

# Test 14: Case-insensitive search (ERROR in uppercase)
TEST_FILE="$TEST_DIR/uppercase_error.txt"
echo "ERROR: Something went wrong" > "$TEST_FILE"
run_test "Case-insensitive search (ERROR)" "ERROR" bash search_errors.sh "$TEST_FILE"

# Test 15: Multiple errors in file
TEST_FILE="$TEST_DIR/multiple_errors.txt"
cat > "$TEST_FILE" << 'EOF'
Line 1: Normal log entry
Line 2: An error occurred
Line 3: Another warning
Line 4: Exception thrown
Line 5: Fatal crash
EOF
run_test "Multiple errors in file" "error" bash search_errors.sh "$TEST_FILE"

# Test 16: Empty file
TEST_FILE="$TEST_DIR/empty.txt"
touch "$TEST_FILE"
run_test "Empty file" "No exceptions or errors found" bash search_errors.sh "$TEST_FILE"

# Test 17: Large file with errors
TEST_FILE="$TEST_DIR/large_file.txt"
for i in {1..1000}; do
    echo "Log entry $i" >> "$TEST_FILE"
done
echo "ERROR found at end" >> "$TEST_FILE"
run_test "Large file with error" "ERROR" bash search_errors.sh "$TEST_FILE"

# Test 18: File with special characters
TEST_FILE="$TEST_DIR/special_chars.txt"
echo "Error: \$variable has invalid \@symbol" > "$TEST_FILE"
run_test "File with special characters" "Error" bash search_errors.sh "$TEST_FILE"

# Print summary
echo ""
echo "=============================================="
echo "Test Summary:"
echo "=============================================="
echo "Total Tests Run:  $TESTS_RUN"
echo -e "Tests Passed:     ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed:     ${RED}$TESTS_FAILED${NC}"
echo "=============================================="

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
