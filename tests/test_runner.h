#ifndef DARK_TEST_RUNNER_H
#define DARK_TEST_RUNNER_H

#include <stddef.h>

typedef void (*DarkTestFunction)(void);

typedef struct DarkTestCase {
    const char *name;
    DarkTestFunction function;
} DarkTestCase;

void dark_test_record_assertion(void);
void dark_test_fail(const char *expression, const char *file, int line);
int dark_test_run(const DarkTestCase *tests, size_t test_count);

#define DARK_TEST_ASSERT(condition)                                                               \
    do {                                                                                          \
        dark_test_record_assertion();                                                             \
        if (!(condition)) {                                                                       \
            dark_test_fail(#condition, __FILE__, __LINE__);                                       \
            return;                                                                               \
        }                                                                                         \
    } while (0)

#endif
