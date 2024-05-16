#include "types.h"
#include "user.h"

#define MAX_CHILDREN 10

void do_work() {
    int i, j;
    for (i = 0; i < 1000000; i++) {
        for (j = 0; j < 100; j++) {
            asm("nop");
        }
    }
    printf(1, "Child PID %d completed\n", getpid());
    exit();
}

int main(int argc, char *argv[]) {
    int i;

    printf(1, "Testing Round Robin Scheduler\n");

    // Ensure the correct number of arguments
    if (argc != 2) {
        printf(1, "Usage: roundrobin <num_iterations>\n");
        exit();
    }

    int num_iterations = atoi(argv[1]);
    int iteration;
    for (iteration = 0; iteration < num_iterations; iteration++) {
        int winner_pid = -1;
        for (i = 0; i < MAX_CHILDREN; i++) {
            int pid = fork();
            if (pid == 0) {
                // Child process
                do_work();
                printf(1, "Child PID %d completed\n", getpid());
                exit();
            } else if (pid > 0) {
                // Parent process
                printf(1, "Forked child with PID %d\n", pid);

                if (i == 0) {
                    // The first child in the iteration is the winner
                    winner_pid = pid;
                }
            } else {
                printf(2, "Fork failed\n");
                exit();
            }
        }

        // Print the winner of the iteration
        printf(1, "Iteration %d: The winner is Child PID %d\n", iteration + 1, winner_pid);

        // Wait for all children to complete
        for (i = 0; i < MAX_CHILDREN; i++) {
            wait();
        }
    }

    exit();
}
