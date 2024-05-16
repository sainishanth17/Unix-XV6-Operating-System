#include "types.h"
#include "stat.h"
#include "user.h"

extern int chr(void); // Declare the chr() function defined in proc.c

int main(void) {
    int i;
    int min = 0x7FFFFFFF; // Maximum positive integer
    int max = 0x80000000; // Minimum negative integer
    int sum = 0;
    int count[100] = {0};

   
     for (i = 0; i < 1000; i++) {
        int num = (chr() & 0x7FFFFFFF); // Ensure the number is non-negative
        if (num < min) min = num;
        if (num > max) max = num;
        sum += num;
        int bin = num % 100;
        count[bin]++;
    }

    printf(1, "Min: %d\n", min);
    printf(1, "Max: %d\n", max);
    printf(1, "Mean: %d\n", sum / 1000);

    // Print histogram with range
    for (i = 0; i < 100; i++) {
        int startRange = i * (0x7FFFFFFF / 100);
        int endRange = (i + 1) * (0x7FFFFFFF / 100) - 1;
        printf(1, "%d th bin (%d - %d): %d\n", i, startRange, endRange, count[i]);
    }

    exit();
    
}




