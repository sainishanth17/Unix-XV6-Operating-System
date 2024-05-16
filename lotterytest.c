#include "types.h"
#include "user.h"

#define MAX_CHILDREN 10

int random_value(int max) {
    return chr() % max;
}

void do_work(int num_tickets, int nice, int test_id) {
    int i, j;
    for (i = 0; i < 1000000; i++) {
        for (j = 0; j < 100; j++) {
            asm("nop");
        }
    }

    sleep(10);
    if (test_id != 2) {
        printf(1, "Winning PID Based on Lottery : %d\n", getpid());
    }
    if(test_id!=2){
    printf(1, "child process (PID : %d , nice : %d) finished\n", getpid(), nice);
    }
    else{
        
        printf(1, "All child process with equal priority (nice : %d) finished\n", nice);
       
    }

    exit();
}

void run_lottery_test() {
    printf(1, "Testing Lottery Scheduler in XV6\n");
    int i;

    for (i = 0; i < MAX_CHILDREN; i++) {
        int pid = fork();
        if (pid == 0) {

            int nice = chr() % 20;
            if (nice < 0) {
                nice *= -1;
            }
            int num_tickets = 20 - nice;

            chpr(getpid(), nice); // Setting nice for the current process.
            settickets(num_tickets); // Setting the number of tickets.

           // printf(1, "Child PID %d - Assigned %d tickets and Nice %d\n", getpid(), num_tickets, nice);
            do_work(num_tickets, nice, 1);
        } else if (pid < 0) {
            printf(2, "Fork failed\n");
            exit();
        }
    }

    // Wait for the child processes to complete and print their completion messages
    for (i = 0; i < MAX_CHILDREN; i++) {
        wait();
    }
}

void run_round_robin_test() {
    printf(1, "Round-Robin Scheduling Test Case\n");
    int i;

    for (i = 0; i < MAX_CHILDREN; i++) {
        int pid = fork();
        if (pid == 0) {

            // Call "do_work" in round-robin test case
            int nice = 0;
            int num_tickets = 20;

            chpr(getpid(), nice); // Setting nice for the current process.
            settickets(num_tickets); // Setting the number of tickets.

            do_work(num_tickets, nice, 2);
        } else if (pid < 0) {
            printf(2, "Fork failed\n");
            exit();
        }
    }

    // Wait for the child processes to complete and print their completion messages
    for (i = 0; i < MAX_CHILDREN; i++) {
        wait();
    }
}

void run_edge_test() {
    printf(1, "Edge Test\n");
    int num_tickets_min = 1;
    int num_tickets_max = 32767;

    int pid_min = fork();
    if (pid_min == 0) {
        chpr(getpid(), 0); // Set nice to 0
        settickets(num_tickets_min);
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets_min);
        do_work(num_tickets_min, 0, 3);
    } else if (pid_min < 0) {
        printf(2, "Fork failed\n");
        exit();
    }

    int pid_max = fork();
    if (pid_max == 0) {
        chpr(getpid(), 0); // Set nice to 0
        settickets(num_tickets_max);
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets_max);
        do_work(num_tickets_max, 0, 3);
    } else if (pid_max < 0) {
        printf(2, "Fork failed\n");
        exit();
    }

    // Wait for the child processes to complete and print their completion messages
    wait();
    wait();
}

void dynamic_priority_adjustment_test() {
    printf(1, "Dynamic Priority Adjustment Test\n");
    int pid = fork();
    if (pid == 0) {
        int num_tickets = 15;
        chpr(getpid(), 0); // Set initial nice to 0
        settickets(num_tickets);
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets);

        // Simulate work and print progress
        int i;
        for (i = 0; i < 10; i++) {
            printf(1, "PID %d - Progress: %d/10\n", getpid(), i);
            if (i == 5) {
                // Change the nice value to adjust priority
                chpr(getpid(), 10);
                printf(1, "PID %d - Priority Increased (Nice 10)\n", getpid());
            }
            sleep(100); // Sleep to yield the CPU
        }
        do_work(num_tickets, 0, 4);
    } else if (pid < 0) {
        printf(2, "Fork failed\n");
        exit();
    }

    // Wait for the child process to complete
    wait();
}

void extreme_ticket_count_test() {
    printf(1, "Extreme Ticket Count Test\n");
    int pid = fork();
    if (pid == 0) {
        int num_tickets = 32767; // Maximum ticket count
        chpr(getpid(), 0); // Set initial nice to 0
        settickets(num_tickets);
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets);

        // Simulate work and print progress
        int i;
        for (i = 0; i < 10; i++) {
            printf(1, "PID %d - Progress: %d/10\n", getpid(), i);
            sleep(100); // Sleep to yield the CPU
        }
        do_work(num_tickets, 0, 3);
    } else if (pid < 0) {
        printf(2, "Fork failed\n");
        exit();
    }

    // Wait for the child process to complete
    wait();
}

void run_mixed_test() {
    printf(1, "Mixed Scheduling Test\n");
    int i;
    for (i = 0; i < MAX_CHILDREN; i++) {
        int pid = fork();
        if (pid == 0) {
            int nice = chr() % 10;
            int num_tickets = 10 + nice;

            chpr(getpid(), nice); // Set nice for the current process.
            settickets(num_tickets); // Set the number of tickets.

            printf(1, "Child PID %d - Assigned %d tickets and Nice %d\n", getpid(), num_tickets, nice);
            do_work(num_tickets, nice, 5);
        } else if (pid < 0) {
            printf(2, "Fork failed\n");
            exit();
        }
    }

    // Wait for the child processes to complete and print their completion messages
    for (i = 0; i < MAX_CHILDREN; i++) {
        wait();
    }
}

void run_starvation_test() {
    printf(1, "Starvation Test\n");
    int pid_high = fork();
    if (pid_high == 0) {
        chpr(getpid(), 10); // Set nice to a high value
        settickets(1); // Set minimal tickets

        printf(1, "Child PID %d - Assigned 1 ticket and Nice 10\n", getpid());
        do_work(1, 10, 6);
    } else if (pid_high < 0) {
        printf(2, "Fork failed\n");
        exit();
    }

    int pid_low = fork();
    if (pid_low == 0) {
        chpr(getpid(), 0); // Set nice to 0
        settickets(32766); // Set almost maximum tickets

        printf(1, "Child PID %d - Assigned 32766 tickets and Nice 0\n", getpid());
        do_work(32766, 0, 6);
    } else if (pid_low < 0) {
        printf(2, "Fork failed\n");
        exit();
    }

    // Wait for the child processes to complete and print their completion messages
    wait();
    wait();
}

int main() {
    // Run the Lottery Scheduler test
    run_lottery_test();
    printf(1, "Lottery Test Completed\n");
    printf(1, "\n");

    // Run the Round-Robin Scheduling test
    run_round_robin_test();
    printf(1, "Round-Robin Scheduling Test Completed\n");
    printf(1, "\n");

    // Run the Edge Test
    extreme_ticket_count_test();
    printf(1, "Extreme Ticket Count Test Completed\n");
    printf(1, "\n");

    dynamic_priority_adjustment_test();
    printf(1, "Dynamic Priority Adjustment Test Completed\n");
    printf(1, "\n");
    printf(1, "\n");
    
    run_mixed_test();
    printf(1, "Mixed Scheduling Test Completed\n");
    printf(1, "\n");

    // Run the Starvation Test
    run_starvation_test();
    printf(1, "Starvation Test Completed\n");
    printf(1, "All test cases completed\n");

    exit();
}
