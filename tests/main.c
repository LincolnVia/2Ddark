#include "test_runner.h"

#include <stddef.h>

static void dark_test_runner_smoke_test(void) {
    DARK_TEST_ASSERT(1 + 1 == 2);
}

int main(void) {
    static const DarkTestCase tests[] = {
        {"test runner smoke test", dark_test_runner_smoke_test},
    };

    return dark_test_run(tests, sizeof(tests) / sizeof(tests[0]));
}
