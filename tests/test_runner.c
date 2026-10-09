#include "test_runner.h"

#include <stdbool.h>
#include <stdio.h>

static size_t dark_assertion_count;
static size_t dark_failure_count;
static bool dark_current_test_failed;

void dark_test_record_assertion(void) {
    dark_assertion_count += 1U;
}

void dark_test_fail(const char *expression, const char *file, int line) {
    dark_current_test_failed = true;
    (void)fprintf(stderr, "%s:%d: assertion failed: %s\n", file, line, expression);
}

int dark_test_run(const DarkTestCase *tests, size_t test_count) {
    size_t test_index = 0U;

    dark_assertion_count = 0U;
    dark_failure_count = 0U;

    for (test_index = 0U; test_index < test_count; ++test_index) {
        dark_current_test_failed = false;
        tests[test_index].function();

        if (dark_current_test_failed) {
            dark_failure_count += 1U;
            (void)printf("[FAIL] %s\n", tests[test_index].name);
        } else {
            (void)printf("[PASS] %s\n", tests[test_index].name);
        }
    }

    (void)printf("%zu test(s), %zu assertion(s), %zu failure(s)\n", test_count,
                 dark_assertion_count, dark_failure_count);
    return dark_failure_count == 0U ? 0 : 1;
}
