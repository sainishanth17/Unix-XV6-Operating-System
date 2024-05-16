#include "types.h"
#include "user.h"

#define CUSTOM_STRTOL_ERROR -5  // Define an error code

long custom_strtol(const char *str) {
    long result = 0;
    int sign = 1;
    int i = 0;

    if (str[0] == '-') {
        sign = -1;
        i = 1;
    }

    for (; str[i] != '\0'; i++) {
        if (str[i] >= '0' && str[i] <= '9') {
            result = result * 10 + (str[i] - '0');
        } else {
            // Handle invalid characters or other cases
            return -5;
        }
    }

    return result * sign;
}

void run_test(int pid, long value, const char *description) {
    if (value == CUSTOM_STRTOL_ERROR) {
        printf(2, "Invalid value in test case: %s\n", description);
        cps();
        return;
    }

    int result = chpr(pid, (int)value);
    printf(1, "Test case: %s with value %d\n", description, value);
    if (result == 0) {
        printf(1, "Nice value set successfully.\n");
        cps();
    } else {
        printf(2, "Failed to set nice value.\n");
        cps();
    }
    printf(1, "-------------------------\n");
}

int main(int argc, char *argv[]) {
    if (argc != 1) {
        printf(1, "Usage: test_nice\n");
        exit();
    }

    int pid = 2;  // Replace with the appropriate PID


    run_test(pid, 10, "Valid input");
    run_test(pid, 20, "Out-of-bounds high");
    run_test(pid, -21, "Out-of-bounds low");
    run_test(pid, custom_strtol("abc"), "Invalid input");
    // Add more test cases as needed

    exit();
}
