#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

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
            // Handle invalid characters or other cases as needed
            return 0;
        }
    }

    return result * sign;
}

int main(int argc, char *argv[]) {
    long priority;  // Use long to handle negative numbers
    int pid;
    if (argc < 3) {
        printf(2,"Usage: nice pid priority\n");
        exit();
    }
    pid = atoi(argv[1]);
    priority = custom_strtol(argv[2]);

    printf(1, "Priority: %d\n", priority);

    if (priority < -20 || priority > 19) {
        printf(2, "Invalid priority range, range should only be within (-20-19)!\n");
        exit();
    }

    int result = chpr(pid, (int)priority);  // Cast priority to int for the system call
    if (result == -1) {
        printf(2, "Failed to set priority.\n");
    }

    exit();
}
