
_lotterytest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    // Wait for the child processes to complete and print their completion messages
    wait();
    wait();
}

int main() {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
    // Run the Lottery Scheduler test
    run_lottery_test();
   9:	e8 e2 01 00 00       	call   1f0 <run_lottery_test>
    printf(1, "Lottery Test Completed\n");
   e:	c7 44 24 04 c5 12 00 	movl   $0x12c5,0x4(%esp)
  15:	00 
  16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1d:	e8 3e 0c 00 00       	call   c60 <printf>
    printf(1, "\n");
  22:	c7 44 24 04 80 12 00 	movl   $0x1280,0x4(%esp)
  29:	00 
  2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  31:	e8 2a 0c 00 00       	call   c60 <printf>

    // Run the Round-Robin Scheduling test
    run_round_robin_test();
  36:	e8 85 02 00 00       	call   2c0 <run_round_robin_test>
    printf(1, "Round-Robin Scheduling Test Completed\n");
  3b:	c7 44 24 04 b0 11 00 	movl   $0x11b0,0x4(%esp)
  42:	00 
  43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4a:	e8 11 0c 00 00       	call   c60 <printf>
    printf(1, "\n");
  4f:	c7 44 24 04 80 12 00 	movl   $0x1280,0x4(%esp)
  56:	00 
  57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5e:	e8 fd 0b 00 00       	call   c60 <printf>

    // Run the Edge Test
    extreme_ticket_count_test();
  63:	e8 68 05 00 00       	call   5d0 <extreme_ticket_count_test>
    printf(1, "Extreme Ticket Count Test Completed\n");
  68:	c7 44 24 04 d8 11 00 	movl   $0x11d8,0x4(%esp)
  6f:	00 
  70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  77:	e8 e4 0b 00 00       	call   c60 <printf>
    printf(1, "\n");
  7c:	c7 44 24 04 80 12 00 	movl   $0x1280,0x4(%esp)
  83:	00 
  84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8b:	e8 d0 0b 00 00       	call   c60 <printf>

    dynamic_priority_adjustment_test();
  90:	e8 fb 03 00 00       	call   490 <dynamic_priority_adjustment_test>
    printf(1, "Dynamic Priority Adjustment Test Completed\n");
  95:	c7 44 24 04 00 12 00 	movl   $0x1200,0x4(%esp)
  9c:	00 
  9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a4:	e8 b7 0b 00 00       	call   c60 <printf>
    printf(1, "\n");
  a9:	c7 44 24 04 80 12 00 	movl   $0x1280,0x4(%esp)
  b0:	00 
  b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b8:	e8 a3 0b 00 00       	call   c60 <printf>
    printf(1, "\n");
  bd:	c7 44 24 04 80 12 00 	movl   $0x1280,0x4(%esp)
  c4:	00 
  c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  cc:	e8 8f 0b 00 00       	call   c60 <printf>
    
    run_mixed_test();
  d1:	e8 ea 05 00 00       	call   6c0 <run_mixed_test>
    printf(1, "Mixed Scheduling Test Completed\n");
  d6:	c7 44 24 04 2c 12 00 	movl   $0x122c,0x4(%esp)
  dd:	00 
  de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e5:	e8 76 0b 00 00       	call   c60 <printf>
    printf(1, "\n");
  ea:	c7 44 24 04 80 12 00 	movl   $0x1280,0x4(%esp)
  f1:	00 
  f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f9:	e8 62 0b 00 00       	call   c60 <printf>

    // Run the Starvation Test
    run_starvation_test();
  fe:	e8 ad 06 00 00       	call   7b0 <run_starvation_test>
    printf(1, "Starvation Test Completed\n");
 103:	c7 44 24 04 dd 12 00 	movl   $0x12dd,0x4(%esp)
 10a:	00 
 10b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 112:	e8 49 0b 00 00       	call   c60 <printf>
    printf(1, "All test cases completed\n");
 117:	c7 44 24 04 f8 12 00 	movl   $0x12f8,0x4(%esp)
 11e:	00 
 11f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 126:	e8 35 0b 00 00       	call   c60 <printf>

    exit();
 12b:	e8 c2 09 00 00       	call   af2 <exit>

00000130 <random_value>:
#include "types.h"
#include "user.h"

#define MAX_CHILDREN 10

int random_value(int max) {
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 ec 08             	sub    $0x8,%esp
    return chr() % max;
 136:	e8 6f 0a 00 00       	call   baa <chr>
 13b:	99                   	cltd   
 13c:	f7 7d 08             	idivl  0x8(%ebp)
}
 13f:	c9                   	leave  
 140:	89 d0                	mov    %edx,%eax
 142:	c3                   	ret    
 143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <do_work>:

void do_work(int num_tickets, int nice, int test_id) {
 150:	55                   	push   %ebp
 151:	ba 40 42 0f 00       	mov    $0xf4240,%edx
 156:	89 e5                	mov    %esp,%ebp
 158:	53                   	push   %ebx
 159:	83 ec 14             	sub    $0x14,%esp
 15c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 15f:	90                   	nop
 160:	b8 64 00 00 00       	mov    $0x64,%eax
 165:	8d 76 00             	lea    0x0(%esi),%esi
    int i, j;
    for (i = 0; i < 1000000; i++) {
        for (j = 0; j < 100; j++) {
            asm("nop");
 168:	90                   	nop
}

void do_work(int num_tickets, int nice, int test_id) {
    int i, j;
    for (i = 0; i < 1000000; i++) {
        for (j = 0; j < 100; j++) {
 169:	83 e8 01             	sub    $0x1,%eax
 16c:	75 fa                	jne    168 <do_work+0x18>
    return chr() % max;
}

void do_work(int num_tickets, int nice, int test_id) {
    int i, j;
    for (i = 0; i < 1000000; i++) {
 16e:	83 ea 01             	sub    $0x1,%edx
 171:	75 ed                	jne    160 <do_work+0x10>
        for (j = 0; j < 100; j++) {
            asm("nop");
        }
    }

    sleep(10);
 173:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 17a:	e8 03 0a 00 00       	call   b82 <sleep>
    if (test_id != 2) {
 17f:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
 183:	75 1d                	jne    1a2 <do_work+0x52>
    if(test_id!=2){
    printf(1, "child process (PID : %d , nice : %d) finished\n", getpid(), nice);
    }
    else{
        
        printf(1, "All child process with equal priority (nice : %d) finished\n", nice);
 185:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 189:	c7 44 24 04 1c 10 00 	movl   $0x101c,0x4(%esp)
 190:	00 
 191:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 198:	e8 c3 0a 00 00       	call   c60 <printf>
       
    }

    exit();
 19d:	e8 50 09 00 00       	call   af2 <exit>
        }
    }

    sleep(10);
    if (test_id != 2) {
        printf(1, "Winning PID Based on Lottery : %d\n", getpid());
 1a2:	e8 cb 09 00 00       	call   b72 <getpid>
 1a7:	c7 44 24 04 c8 0f 00 	movl   $0xfc8,0x4(%esp)
 1ae:	00 
 1af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b6:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ba:	e8 a1 0a 00 00       	call   c60 <printf>
    }
    if(test_id!=2){
    printf(1, "child process (PID : %d , nice : %d) finished\n", getpid(), nice);
 1bf:	e8 ae 09 00 00       	call   b72 <getpid>
 1c4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 1c8:	c7 44 24 04 ec 0f 00 	movl   $0xfec,0x4(%esp)
 1cf:	00 
 1d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d7:	89 44 24 08          	mov    %eax,0x8(%esp)
 1db:	e8 80 0a 00 00       	call   c60 <printf>
 1e0:	eb bb                	jmp    19d <do_work+0x4d>
 1e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <run_lottery_test>:
    }

    exit();
}

void run_lottery_test() {
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
    printf(1, "Testing Lottery Scheduler in XV6\n");
 1f5:	bb 0a 00 00 00       	mov    $0xa,%ebx
    }

    exit();
}

void run_lottery_test() {
 1fa:	83 ec 10             	sub    $0x10,%esp
    printf(1, "Testing Lottery Scheduler in XV6\n");
 1fd:	c7 44 24 04 58 10 00 	movl   $0x1058,0x4(%esp)
 204:	00 
 205:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 20c:	e8 4f 0a 00 00       	call   c60 <printf>
 211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    int i;

    for (i = 0; i < MAX_CHILDREN; i++) {
        int pid = fork();
 218:	e8 cd 08 00 00       	call   aea <fork>
        if (pid == 0) {
 21d:	85 c0                	test   %eax,%eax
 21f:	74 20                	je     241 <run_lottery_test+0x51>
            chpr(getpid(), nice); // Setting nice for the current process.
            settickets(num_tickets); // Setting the number of tickets.

           // printf(1, "Child PID %d - Assigned %d tickets and Nice %d\n", getpid(), num_tickets, nice);
            do_work(num_tickets, nice, 1);
        } else if (pid < 0) {
 221:	78 7f                	js     2a2 <run_lottery_test+0xb2>

void run_lottery_test() {
    printf(1, "Testing Lottery Scheduler in XV6\n");
    int i;

    for (i = 0; i < MAX_CHILDREN; i++) {
 223:	83 eb 01             	sub    $0x1,%ebx
 226:	75 f0                	jne    218 <run_lottery_test+0x28>
 228:	bb 0a 00 00 00       	mov    $0xa,%ebx
 22d:	8d 76 00             	lea    0x0(%esi),%esi
        }
    }

    // Wait for the child processes to complete and print their completion messages
    for (i = 0; i < MAX_CHILDREN; i++) {
        wait();
 230:	e8 c5 08 00 00       	call   afa <wait>
            exit();
        }
    }

    // Wait for the child processes to complete and print their completion messages
    for (i = 0; i < MAX_CHILDREN; i++) {
 235:	83 eb 01             	sub    $0x1,%ebx
 238:	75 f6                	jne    230 <run_lottery_test+0x40>
        wait();
    }
}
 23a:	83 c4 10             	add    $0x10,%esp
 23d:	5b                   	pop    %ebx
 23e:	5e                   	pop    %esi
 23f:	5d                   	pop    %ebp
 240:	c3                   	ret    

    for (i = 0; i < MAX_CHILDREN; i++) {
        int pid = fork();
        if (pid == 0) {

            int nice = chr() % 20;
 241:	e8 64 09 00 00       	call   baa <chr>
 246:	bb 67 66 66 66       	mov    $0x66666667,%ebx
            if (nice < 0) {
                nice *= -1;
            }
            int num_tickets = 20 - nice;
 24b:	be 14 00 00 00       	mov    $0x14,%esi

    for (i = 0; i < MAX_CHILDREN; i++) {
        int pid = fork();
        if (pid == 0) {

            int nice = chr() % 20;
 250:	89 c1                	mov    %eax,%ecx
 252:	f7 eb                	imul   %ebx
 254:	89 c8                	mov    %ecx,%eax
 256:	c1 f8 1f             	sar    $0x1f,%eax
 259:	89 d3                	mov    %edx,%ebx
 25b:	c1 fb 03             	sar    $0x3,%ebx
 25e:	29 c3                	sub    %eax,%ebx
 260:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 263:	c1 e0 02             	shl    $0x2,%eax
 266:	29 c1                	sub    %eax,%ecx
            if (nice < 0) {
                nice *= -1;
 268:	89 c8                	mov    %ecx,%eax

    for (i = 0; i < MAX_CHILDREN; i++) {
        int pid = fork();
        if (pid == 0) {

            int nice = chr() % 20;
 26a:	89 cb                	mov    %ecx,%ebx
            if (nice < 0) {
                nice *= -1;
 26c:	c1 f8 1f             	sar    $0x1f,%eax
 26f:	31 c3                	xor    %eax,%ebx
 271:	29 c3                	sub    %eax,%ebx
            }
            int num_tickets = 20 - nice;

            chpr(getpid(), nice); // Setting nice for the current process.
 273:	e8 fa 08 00 00       	call   b72 <getpid>

            int nice = chr() % 20;
            if (nice < 0) {
                nice *= -1;
            }
            int num_tickets = 20 - nice;
 278:	29 de                	sub    %ebx,%esi

            chpr(getpid(), nice); // Setting nice for the current process.
 27a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 27e:	89 04 24             	mov    %eax,(%esp)
 281:	e8 14 09 00 00       	call   b9a <chpr>
            settickets(num_tickets); // Setting the number of tickets.
 286:	89 34 24             	mov    %esi,(%esp)
 289:	e8 14 09 00 00       	call   ba2 <settickets>

           // printf(1, "Child PID %d - Assigned %d tickets and Nice %d\n", getpid(), num_tickets, nice);
            do_work(num_tickets, nice, 1);
 28e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 295:	00 
 296:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 29a:	89 34 24             	mov    %esi,(%esp)
 29d:	e8 ae fe ff ff       	call   150 <do_work>
        } else if (pid < 0) {
            printf(2, "Fork failed\n");
 2a2:	c7 44 24 04 50 12 00 	movl   $0x1250,0x4(%esp)
 2a9:	00 
 2aa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2b1:	e8 aa 09 00 00       	call   c60 <printf>
            exit();
 2b6:	e8 37 08 00 00       	call   af2 <exit>
 2bb:	90                   	nop
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002c0 <run_round_robin_test>:
    for (i = 0; i < MAX_CHILDREN; i++) {
        wait();
    }
}

void run_round_robin_test() {
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	53                   	push   %ebx
    printf(1, "Round-Robin Scheduling Test Case\n");
 2c4:	bb 0a 00 00 00       	mov    $0xa,%ebx
    for (i = 0; i < MAX_CHILDREN; i++) {
        wait();
    }
}

void run_round_robin_test() {
 2c9:	83 ec 14             	sub    $0x14,%esp
    printf(1, "Round-Robin Scheduling Test Case\n");
 2cc:	c7 44 24 04 7c 10 00 	movl   $0x107c,0x4(%esp)
 2d3:	00 
 2d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2db:	e8 80 09 00 00       	call   c60 <printf>
    int i;

    for (i = 0; i < MAX_CHILDREN; i++) {
        int pid = fork();
 2e0:	e8 05 08 00 00       	call   aea <fork>
        if (pid == 0) {
 2e5:	85 c0                	test   %eax,%eax
 2e7:	74 1f                	je     308 <run_round_robin_test+0x48>

            chpr(getpid(), nice); // Setting nice for the current process.
            settickets(num_tickets); // Setting the number of tickets.

            do_work(num_tickets, nice, 2);
        } else if (pid < 0) {
 2e9:	78 5a                	js     345 <run_round_robin_test+0x85>

void run_round_robin_test() {
    printf(1, "Round-Robin Scheduling Test Case\n");
    int i;

    for (i = 0; i < MAX_CHILDREN; i++) {
 2eb:	83 eb 01             	sub    $0x1,%ebx
 2ee:	66 90                	xchg   %ax,%ax
 2f0:	75 ee                	jne    2e0 <run_round_robin_test+0x20>
 2f2:	bb 0a 00 00 00       	mov    $0xa,%ebx
 2f7:	90                   	nop
        }
    }

    // Wait for the child processes to complete and print their completion messages
    for (i = 0; i < MAX_CHILDREN; i++) {
        wait();
 2f8:	e8 fd 07 00 00       	call   afa <wait>
            exit();
        }
    }

    // Wait for the child processes to complete and print their completion messages
    for (i = 0; i < MAX_CHILDREN; i++) {
 2fd:	83 eb 01             	sub    $0x1,%ebx
 300:	75 f6                	jne    2f8 <run_round_robin_test+0x38>
        wait();
    }
}
 302:	83 c4 14             	add    $0x14,%esp
 305:	5b                   	pop    %ebx
 306:	5d                   	pop    %ebp
 307:	c3                   	ret    

            // Call "do_work" in round-robin test case
            int nice = 0;
            int num_tickets = 20;

            chpr(getpid(), nice); // Setting nice for the current process.
 308:	e8 65 08 00 00       	call   b72 <getpid>
 30d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 314:	00 
 315:	89 04 24             	mov    %eax,(%esp)
 318:	e8 7d 08 00 00       	call   b9a <chpr>
            settickets(num_tickets); // Setting the number of tickets.
 31d:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
 324:	e8 79 08 00 00       	call   ba2 <settickets>

            do_work(num_tickets, nice, 2);
 329:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
 330:	00 
 331:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 338:	00 
 339:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
 340:	e8 0b fe ff ff       	call   150 <do_work>
        } else if (pid < 0) {
            printf(2, "Fork failed\n");
 345:	c7 44 24 04 50 12 00 	movl   $0x1250,0x4(%esp)
 34c:	00 
 34d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 354:	e8 07 09 00 00       	call   c60 <printf>
            exit();
 359:	e8 94 07 00 00       	call   af2 <exit>
 35e:	66 90                	xchg   %ax,%ax

00000360 <run_edge_test>:
    for (i = 0; i < MAX_CHILDREN; i++) {
        wait();
    }
}

void run_edge_test() {
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	83 ec 18             	sub    $0x18,%esp
    printf(1, "Edge Test\n");
 366:	c7 44 24 04 5d 12 00 	movl   $0x125d,0x4(%esp)
 36d:	00 
 36e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 375:	e8 e6 08 00 00       	call   c60 <printf>
    int num_tickets_min = 1;
    int num_tickets_max = 32767;

    int pid_min = fork();
 37a:	e8 6b 07 00 00       	call   aea <fork>
    if (pid_min == 0) {
 37f:	85 c0                	test   %eax,%eax
 381:	74 41                	je     3c4 <run_edge_test+0x64>
        chpr(getpid(), 0); // Set nice to 0
        settickets(num_tickets_min);
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets_min);
        do_work(num_tickets_min, 0, 3);
    } else if (pid_min < 0) {
 383:	78 26                	js     3ab <run_edge_test+0x4b>
        printf(2, "Fork failed\n");
        exit();
    }

    int pid_max = fork();
 385:	e8 60 07 00 00       	call   aea <fork>
    if (pid_max == 0) {
 38a:	85 c0                	test   %eax,%eax
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 390:	0f 84 90 00 00 00    	je     426 <run_edge_test+0xc6>
        chpr(getpid(), 0); // Set nice to 0
        settickets(num_tickets_max);
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets_max);
        do_work(num_tickets_max, 0, 3);
    } else if (pid_max < 0) {
 396:	78 13                	js     3ab <run_edge_test+0x4b>
 398:	90                   	nop
 399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(2, "Fork failed\n");
        exit();
    }

    // Wait for the child processes to complete and print their completion messages
    wait();
 3a0:	e8 55 07 00 00       	call   afa <wait>
    wait();
}
 3a5:	c9                   	leave  
        exit();
    }

    // Wait for the child processes to complete and print their completion messages
    wait();
    wait();
 3a6:	e9 4f 07 00 00       	jmp    afa <wait>
        chpr(getpid(), 0); // Set nice to 0
        settickets(num_tickets_min);
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets_min);
        do_work(num_tickets_min, 0, 3);
    } else if (pid_min < 0) {
        printf(2, "Fork failed\n");
 3ab:	c7 44 24 04 50 12 00 	movl   $0x1250,0x4(%esp)
 3b2:	00 
 3b3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 3ba:	e8 a1 08 00 00       	call   c60 <printf>
        exit();
 3bf:	e8 2e 07 00 00       	call   af2 <exit>
    int num_tickets_min = 1;
    int num_tickets_max = 32767;

    int pid_min = fork();
    if (pid_min == 0) {
        chpr(getpid(), 0); // Set nice to 0
 3c4:	e8 a9 07 00 00       	call   b72 <getpid>
 3c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3d0:	00 
 3d1:	89 04 24             	mov    %eax,(%esp)
 3d4:	e8 c1 07 00 00       	call   b9a <chpr>
        settickets(num_tickets_min);
 3d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3e0:	e8 bd 07 00 00       	call   ba2 <settickets>
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets_min);
 3e5:	e8 88 07 00 00       	call   b72 <getpid>
 3ea:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 3f1:	00 
 3f2:	c7 44 24 04 a0 10 00 	movl   $0x10a0,0x4(%esp)
 3f9:	00 
 3fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 401:	89 44 24 08          	mov    %eax,0x8(%esp)
 405:	e8 56 08 00 00       	call   c60 <printf>
        do_work(num_tickets_min, 0, 3);
 40a:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
 411:	00 
 412:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 419:	00 
 41a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 421:	e8 2a fd ff ff       	call   150 <do_work>
        exit();
    }

    int pid_max = fork();
    if (pid_max == 0) {
        chpr(getpid(), 0); // Set nice to 0
 426:	e8 47 07 00 00       	call   b72 <getpid>
 42b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 432:	00 
 433:	89 04 24             	mov    %eax,(%esp)
 436:	e8 5f 07 00 00       	call   b9a <chpr>
        settickets(num_tickets_max);
 43b:	c7 04 24 ff 7f 00 00 	movl   $0x7fff,(%esp)
 442:	e8 5b 07 00 00       	call   ba2 <settickets>
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets_max);
 447:	e8 26 07 00 00       	call   b72 <getpid>
 44c:	c7 44 24 0c ff 7f 00 	movl   $0x7fff,0xc(%esp)
 453:	00 
 454:	c7 44 24 04 a0 10 00 	movl   $0x10a0,0x4(%esp)
 45b:	00 
 45c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 463:	89 44 24 08          	mov    %eax,0x8(%esp)
 467:	e8 f4 07 00 00       	call   c60 <printf>
        do_work(num_tickets_max, 0, 3);
 46c:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
 473:	00 
 474:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 47b:	00 
 47c:	c7 04 24 ff 7f 00 00 	movl   $0x7fff,(%esp)
 483:	e8 c8 fc ff ff       	call   150 <do_work>
 488:	90                   	nop
 489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000490 <dynamic_priority_adjustment_test>:
    // Wait for the child processes to complete and print their completion messages
    wait();
    wait();
}

void dynamic_priority_adjustment_test() {
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	56                   	push   %esi
 494:	53                   	push   %ebx
 495:	83 ec 10             	sub    $0x10,%esp
    printf(1, "Dynamic Priority Adjustment Test\n");
 498:	c7 44 24 04 d0 10 00 	movl   $0x10d0,0x4(%esp)
 49f:	00 
 4a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4a7:	e8 b4 07 00 00       	call   c60 <printf>
    int pid = fork();
 4ac:	e8 39 06 00 00       	call   aea <fork>
    if (pid == 0) {
 4b1:	85 c0                	test   %eax,%eax
 4b3:	74 11                	je     4c6 <dynamic_priority_adjustment_test+0x36>
                printf(1, "PID %d - Priority Increased (Nice 10)\n", getpid());
            }
            sleep(100); // Sleep to yield the CPU
        }
        do_work(num_tickets, 0, 4);
    } else if (pid < 0) {
 4b5:	0f 88 b1 00 00 00    	js     56c <dynamic_priority_adjustment_test+0xdc>
        exit();
    }

    // Wait for the child process to complete
    wait();
}
 4bb:	83 c4 10             	add    $0x10,%esp
 4be:	5b                   	pop    %ebx
 4bf:	5e                   	pop    %esi
 4c0:	5d                   	pop    %ebp
        printf(2, "Fork failed\n");
        exit();
    }

    // Wait for the child process to complete
    wait();
 4c1:	e9 34 06 00 00       	jmp    afa <wait>
void dynamic_priority_adjustment_test() {
    printf(1, "Dynamic Priority Adjustment Test\n");
    int pid = fork();
    if (pid == 0) {
        int num_tickets = 15;
        chpr(getpid(), 0); // Set initial nice to 0
 4c6:	e8 a7 06 00 00       	call   b72 <getpid>
        settickets(num_tickets);
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets);
 4cb:	bb 01 00 00 00       	mov    $0x1,%ebx
void dynamic_priority_adjustment_test() {
    printf(1, "Dynamic Priority Adjustment Test\n");
    int pid = fork();
    if (pid == 0) {
        int num_tickets = 15;
        chpr(getpid(), 0); // Set initial nice to 0
 4d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4d7:	00 
 4d8:	89 04 24             	mov    %eax,(%esp)
 4db:	e8 ba 06 00 00       	call   b9a <chpr>
        settickets(num_tickets);
 4e0:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
 4e7:	e8 b6 06 00 00       	call   ba2 <settickets>
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets);
 4ec:	e8 81 06 00 00       	call   b72 <getpid>
 4f1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
 4f8:	00 
 4f9:	c7 44 24 04 a0 10 00 	movl   $0x10a0,0x4(%esp)
 500:	00 
 501:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 508:	89 44 24 08          	mov    %eax,0x8(%esp)
 50c:	e8 4f 07 00 00       	call   c60 <printf>
 511:	eb 03                	jmp    516 <dynamic_priority_adjustment_test+0x86>
 513:	83 c3 01             	add    $0x1,%ebx

        // Simulate work and print progress
        int i;
        for (i = 0; i < 10; i++) {
            printf(1, "PID %d - Progress: %d/10\n", getpid(), i);
 516:	e8 57 06 00 00       	call   b72 <getpid>
 51b:	8d 73 ff             	lea    -0x1(%ebx),%esi
 51e:	89 74 24 0c          	mov    %esi,0xc(%esp)
 522:	c7 44 24 04 68 12 00 	movl   $0x1268,0x4(%esp)
 529:	00 
 52a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 531:	89 44 24 08          	mov    %eax,0x8(%esp)
 535:	e8 26 07 00 00       	call   c60 <printf>
            if (i == 5) {
 53a:	83 fe 05             	cmp    $0x5,%esi
 53d:	74 46                	je     585 <dynamic_priority_adjustment_test+0xf5>
                // Change the nice value to adjust priority
                chpr(getpid(), 10);
                printf(1, "PID %d - Priority Increased (Nice 10)\n", getpid());
            }
            sleep(100); // Sleep to yield the CPU
 53f:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 546:	e8 37 06 00 00       	call   b82 <sleep>
        settickets(num_tickets);
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets);

        // Simulate work and print progress
        int i;
        for (i = 0; i < 10; i++) {
 54b:	83 fb 0a             	cmp    $0xa,%ebx
 54e:	75 c3                	jne    513 <dynamic_priority_adjustment_test+0x83>
                chpr(getpid(), 10);
                printf(1, "PID %d - Priority Increased (Nice 10)\n", getpid());
            }
            sleep(100); // Sleep to yield the CPU
        }
        do_work(num_tickets, 0, 4);
 550:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 557:	00 
 558:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 55f:	00 
 560:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
 567:	e8 e4 fb ff ff       	call   150 <do_work>
    } else if (pid < 0) {
        printf(2, "Fork failed\n");
 56c:	c7 44 24 04 50 12 00 	movl   $0x1250,0x4(%esp)
 573:	00 
 574:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 57b:	e8 e0 06 00 00       	call   c60 <printf>
        exit();
 580:	e8 6d 05 00 00       	call   af2 <exit>
        int i;
        for (i = 0; i < 10; i++) {
            printf(1, "PID %d - Progress: %d/10\n", getpid(), i);
            if (i == 5) {
                // Change the nice value to adjust priority
                chpr(getpid(), 10);
 585:	e8 e8 05 00 00       	call   b72 <getpid>
 58a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
 591:	00 
 592:	89 04 24             	mov    %eax,(%esp)
 595:	e8 00 06 00 00       	call   b9a <chpr>
                printf(1, "PID %d - Priority Increased (Nice 10)\n", getpid());
 59a:	e8 d3 05 00 00       	call   b72 <getpid>
 59f:	c7 44 24 04 f4 10 00 	movl   $0x10f4,0x4(%esp)
 5a6:	00 
 5a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5ae:	89 44 24 08          	mov    %eax,0x8(%esp)
 5b2:	e8 a9 06 00 00       	call   c60 <printf>
            }
            sleep(100); // Sleep to yield the CPU
 5b7:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 5be:	e8 bf 05 00 00       	call   b82 <sleep>
 5c3:	e9 4b ff ff ff       	jmp    513 <dynamic_priority_adjustment_test+0x83>
 5c8:	90                   	nop
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005d0 <extreme_ticket_count_test>:

    // Wait for the child process to complete
    wait();
}

void extreme_ticket_count_test() {
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	53                   	push   %ebx
 5d4:	83 ec 14             	sub    $0x14,%esp
    printf(1, "Extreme Ticket Count Test\n");
 5d7:	c7 44 24 04 82 12 00 	movl   $0x1282,0x4(%esp)
 5de:	00 
 5df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5e6:	e8 75 06 00 00       	call   c60 <printf>
    int pid = fork();
 5eb:	e8 fa 04 00 00       	call   aea <fork>
    if (pid == 0) {
 5f0:	85 c0                	test   %eax,%eax
 5f2:	74 10                	je     604 <extreme_ticket_count_test+0x34>
        for (i = 0; i < 10; i++) {
            printf(1, "PID %d - Progress: %d/10\n", getpid(), i);
            sleep(100); // Sleep to yield the CPU
        }
        do_work(num_tickets, 0, 3);
    } else if (pid < 0) {
 5f4:	0f 88 a3 00 00 00    	js     69d <extreme_ticket_count_test+0xcd>
        exit();
    }

    // Wait for the child process to complete
    wait();
}
 5fa:	83 c4 14             	add    $0x14,%esp
 5fd:	5b                   	pop    %ebx
 5fe:	5d                   	pop    %ebp
        printf(2, "Fork failed\n");
        exit();
    }

    // Wait for the child process to complete
    wait();
 5ff:	e9 f6 04 00 00       	jmp    afa <wait>
void extreme_ticket_count_test() {
    printf(1, "Extreme Ticket Count Test\n");
    int pid = fork();
    if (pid == 0) {
        int num_tickets = 32767; // Maximum ticket count
        chpr(getpid(), 0); // Set initial nice to 0
 604:	e8 69 05 00 00       	call   b72 <getpid>
        settickets(num_tickets);
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets);

        // Simulate work and print progress
        int i;
        for (i = 0; i < 10; i++) {
 609:	31 db                	xor    %ebx,%ebx
void extreme_ticket_count_test() {
    printf(1, "Extreme Ticket Count Test\n");
    int pid = fork();
    if (pid == 0) {
        int num_tickets = 32767; // Maximum ticket count
        chpr(getpid(), 0); // Set initial nice to 0
 60b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 612:	00 
 613:	89 04 24             	mov    %eax,(%esp)
 616:	e8 7f 05 00 00       	call   b9a <chpr>
        settickets(num_tickets);
 61b:	c7 04 24 ff 7f 00 00 	movl   $0x7fff,(%esp)
 622:	e8 7b 05 00 00       	call   ba2 <settickets>
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets);
 627:	e8 46 05 00 00       	call   b72 <getpid>
 62c:	c7 44 24 0c ff 7f 00 	movl   $0x7fff,0xc(%esp)
 633:	00 
 634:	c7 44 24 04 a0 10 00 	movl   $0x10a0,0x4(%esp)
 63b:	00 
 63c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 643:	89 44 24 08          	mov    %eax,0x8(%esp)
 647:	e8 14 06 00 00       	call   c60 <printf>

        // Simulate work and print progress
        int i;
        for (i = 0; i < 10; i++) {
            printf(1, "PID %d - Progress: %d/10\n", getpid(), i);
 64c:	e8 21 05 00 00       	call   b72 <getpid>
 651:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
        settickets(num_tickets);
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets);

        // Simulate work and print progress
        int i;
        for (i = 0; i < 10; i++) {
 655:	83 c3 01             	add    $0x1,%ebx
            printf(1, "PID %d - Progress: %d/10\n", getpid(), i);
 658:	c7 44 24 04 68 12 00 	movl   $0x1268,0x4(%esp)
 65f:	00 
 660:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 667:	89 44 24 08          	mov    %eax,0x8(%esp)
 66b:	e8 f0 05 00 00       	call   c60 <printf>
            sleep(100); // Sleep to yield the CPU
 670:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 677:	e8 06 05 00 00       	call   b82 <sleep>
        settickets(num_tickets);
        printf(1, "Child PID %d - Assigned %d tickets and Nice 0\n", getpid(), num_tickets);

        // Simulate work and print progress
        int i;
        for (i = 0; i < 10; i++) {
 67c:	83 fb 0a             	cmp    $0xa,%ebx
 67f:	75 cb                	jne    64c <extreme_ticket_count_test+0x7c>
            printf(1, "PID %d - Progress: %d/10\n", getpid(), i);
            sleep(100); // Sleep to yield the CPU
        }
        do_work(num_tickets, 0, 3);
 681:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
 688:	00 
 689:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 690:	00 
 691:	c7 04 24 ff 7f 00 00 	movl   $0x7fff,(%esp)
 698:	e8 b3 fa ff ff       	call   150 <do_work>
    } else if (pid < 0) {
        printf(2, "Fork failed\n");
 69d:	c7 44 24 04 50 12 00 	movl   $0x1250,0x4(%esp)
 6a4:	00 
 6a5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 6ac:	e8 af 05 00 00       	call   c60 <printf>
        exit();
 6b1:	e8 3c 04 00 00       	call   af2 <exit>
 6b6:	8d 76 00             	lea    0x0(%esi),%esi
 6b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006c0 <run_mixed_test>:

    // Wait for the child process to complete
    wait();
}

void run_mixed_test() {
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	56                   	push   %esi
 6c4:	53                   	push   %ebx
    printf(1, "Mixed Scheduling Test\n");
 6c5:	bb 0a 00 00 00       	mov    $0xa,%ebx

    // Wait for the child process to complete
    wait();
}

void run_mixed_test() {
 6ca:	83 ec 20             	sub    $0x20,%esp
    printf(1, "Mixed Scheduling Test\n");
 6cd:	c7 44 24 04 9d 12 00 	movl   $0x129d,0x4(%esp)
 6d4:	00 
 6d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6dc:	e8 7f 05 00 00       	call   c60 <printf>
 6e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    int i;
    for (i = 0; i < MAX_CHILDREN; i++) {
        int pid = fork();
 6e8:	e8 fd 03 00 00       	call   aea <fork>
        if (pid == 0) {
 6ed:	85 c0                	test   %eax,%eax
 6ef:	74 28                	je     719 <run_mixed_test+0x59>
            chpr(getpid(), nice); // Set nice for the current process.
            settickets(num_tickets); // Set the number of tickets.

            printf(1, "Child PID %d - Assigned %d tickets and Nice %d\n", getpid(), num_tickets, nice);
            do_work(num_tickets, nice, 5);
        } else if (pid < 0) {
 6f1:	0f 88 9a 00 00 00    	js     791 <run_mixed_test+0xd1>
}

void run_mixed_test() {
    printf(1, "Mixed Scheduling Test\n");
    int i;
    for (i = 0; i < MAX_CHILDREN; i++) {
 6f7:	83 eb 01             	sub    $0x1,%ebx
 6fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 700:	75 e6                	jne    6e8 <run_mixed_test+0x28>
 702:	bb 0a 00 00 00       	mov    $0xa,%ebx
 707:	90                   	nop
        }
    }

    // Wait for the child processes to complete and print their completion messages
    for (i = 0; i < MAX_CHILDREN; i++) {
        wait();
 708:	e8 ed 03 00 00       	call   afa <wait>
            exit();
        }
    }

    // Wait for the child processes to complete and print their completion messages
    for (i = 0; i < MAX_CHILDREN; i++) {
 70d:	83 eb 01             	sub    $0x1,%ebx
 710:	75 f6                	jne    708 <run_mixed_test+0x48>
        wait();
    }
}
 712:	83 c4 20             	add    $0x20,%esp
 715:	5b                   	pop    %ebx
 716:	5e                   	pop    %esi
 717:	5d                   	pop    %ebp
 718:	c3                   	ret    
    printf(1, "Mixed Scheduling Test\n");
    int i;
    for (i = 0; i < MAX_CHILDREN; i++) {
        int pid = fork();
        if (pid == 0) {
            int nice = chr() % 10;
 719:	e8 8c 04 00 00       	call   baa <chr>
 71e:	bb 67 66 66 66       	mov    $0x66666667,%ebx
 723:	89 c1                	mov    %eax,%ecx
 725:	f7 eb                	imul   %ebx
 727:	89 c8                	mov    %ecx,%eax
 729:	c1 f8 1f             	sar    $0x1f,%eax
 72c:	89 d3                	mov    %edx,%ebx
 72e:	c1 fb 02             	sar    $0x2,%ebx
 731:	29 c3                	sub    %eax,%ebx
 733:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
 736:	01 c0                	add    %eax,%eax
 738:	29 c1                	sub    %eax,%ecx
 73a:	89 cb                	mov    %ecx,%ebx
            int num_tickets = 10 + nice;
 73c:	8d 71 0a             	lea    0xa(%ecx),%esi

            chpr(getpid(), nice); // Set nice for the current process.
 73f:	e8 2e 04 00 00       	call   b72 <getpid>
 744:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 748:	89 04 24             	mov    %eax,(%esp)
 74b:	e8 4a 04 00 00       	call   b9a <chpr>
            settickets(num_tickets); // Set the number of tickets.
 750:	89 34 24             	mov    %esi,(%esp)
 753:	e8 4a 04 00 00       	call   ba2 <settickets>

            printf(1, "Child PID %d - Assigned %d tickets and Nice %d\n", getpid(), num_tickets, nice);
 758:	e8 15 04 00 00       	call   b72 <getpid>
 75d:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 761:	89 74 24 0c          	mov    %esi,0xc(%esp)
 765:	c7 44 24 04 1c 11 00 	movl   $0x111c,0x4(%esp)
 76c:	00 
 76d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 774:	89 44 24 08          	mov    %eax,0x8(%esp)
 778:	e8 e3 04 00 00       	call   c60 <printf>
            do_work(num_tickets, nice, 5);
 77d:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
 784:	00 
 785:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 789:	89 34 24             	mov    %esi,(%esp)
 78c:	e8 bf f9 ff ff       	call   150 <do_work>
        } else if (pid < 0) {
            printf(2, "Fork failed\n");
 791:	c7 44 24 04 50 12 00 	movl   $0x1250,0x4(%esp)
 798:	00 
 799:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 7a0:	e8 bb 04 00 00       	call   c60 <printf>
            exit();
 7a5:	e8 48 03 00 00       	call   af2 <exit>
 7aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000007b0 <run_starvation_test>:
    for (i = 0; i < MAX_CHILDREN; i++) {
        wait();
    }
}

void run_starvation_test() {
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	83 ec 18             	sub    $0x18,%esp
    printf(1, "Starvation Test\n");
 7b6:	c7 44 24 04 b4 12 00 	movl   $0x12b4,0x4(%esp)
 7bd:	00 
 7be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 7c5:	e8 96 04 00 00       	call   c60 <printf>
    int pid_high = fork();
 7ca:	e8 1b 03 00 00       	call   aea <fork>
    if (pid_high == 0) {
 7cf:	85 c0                	test   %eax,%eax
 7d1:	74 41                	je     814 <run_starvation_test+0x64>
        chpr(getpid(), 10); // Set nice to a high value
        settickets(1); // Set minimal tickets

        printf(1, "Child PID %d - Assigned 1 ticket and Nice 10\n", getpid());
        do_work(1, 10, 6);
    } else if (pid_high < 0) {
 7d3:	78 26                	js     7fb <run_starvation_test+0x4b>
        printf(2, "Fork failed\n");
        exit();
    }

    int pid_low = fork();
 7d5:	e8 10 03 00 00       	call   aea <fork>
    if (pid_low == 0) {
 7da:	85 c0                	test   %eax,%eax
 7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7e0:	0f 84 88 00 00 00    	je     86e <run_starvation_test+0xbe>
        chpr(getpid(), 0); // Set nice to 0
        settickets(32766); // Set almost maximum tickets

        printf(1, "Child PID %d - Assigned 32766 tickets and Nice 0\n", getpid());
        do_work(32766, 0, 6);
    } else if (pid_low < 0) {
 7e6:	78 13                	js     7fb <run_starvation_test+0x4b>
 7e8:	90                   	nop
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(2, "Fork failed\n");
        exit();
    }

    // Wait for the child processes to complete and print their completion messages
    wait();
 7f0:	e8 05 03 00 00       	call   afa <wait>
    wait();
}
 7f5:	c9                   	leave  
        exit();
    }

    // Wait for the child processes to complete and print their completion messages
    wait();
    wait();
 7f6:	e9 ff 02 00 00       	jmp    afa <wait>
        settickets(1); // Set minimal tickets

        printf(1, "Child PID %d - Assigned 1 ticket and Nice 10\n", getpid());
        do_work(1, 10, 6);
    } else if (pid_high < 0) {
        printf(2, "Fork failed\n");
 7fb:	c7 44 24 04 50 12 00 	movl   $0x1250,0x4(%esp)
 802:	00 
 803:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 80a:	e8 51 04 00 00       	call   c60 <printf>
        exit();
 80f:	e8 de 02 00 00       	call   af2 <exit>

void run_starvation_test() {
    printf(1, "Starvation Test\n");
    int pid_high = fork();
    if (pid_high == 0) {
        chpr(getpid(), 10); // Set nice to a high value
 814:	e8 59 03 00 00       	call   b72 <getpid>
 819:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
 820:	00 
 821:	89 04 24             	mov    %eax,(%esp)
 824:	e8 71 03 00 00       	call   b9a <chpr>
        settickets(1); // Set minimal tickets
 829:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 830:	e8 6d 03 00 00       	call   ba2 <settickets>

        printf(1, "Child PID %d - Assigned 1 ticket and Nice 10\n", getpid());
 835:	e8 38 03 00 00       	call   b72 <getpid>
 83a:	c7 44 24 04 4c 11 00 	movl   $0x114c,0x4(%esp)
 841:	00 
 842:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 849:	89 44 24 08          	mov    %eax,0x8(%esp)
 84d:	e8 0e 04 00 00       	call   c60 <printf>
        do_work(1, 10, 6);
 852:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
 859:	00 
 85a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
 861:	00 
 862:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 869:	e8 e2 f8 ff ff       	call   150 <do_work>
        exit();
    }

    int pid_low = fork();
    if (pid_low == 0) {
        chpr(getpid(), 0); // Set nice to 0
 86e:	e8 ff 02 00 00       	call   b72 <getpid>
 873:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 87a:	00 
 87b:	89 04 24             	mov    %eax,(%esp)
 87e:	e8 17 03 00 00       	call   b9a <chpr>
        settickets(32766); // Set almost maximum tickets
 883:	c7 04 24 fe 7f 00 00 	movl   $0x7ffe,(%esp)
 88a:	e8 13 03 00 00       	call   ba2 <settickets>

        printf(1, "Child PID %d - Assigned 32766 tickets and Nice 0\n", getpid());
 88f:	e8 de 02 00 00       	call   b72 <getpid>
 894:	c7 44 24 04 7c 11 00 	movl   $0x117c,0x4(%esp)
 89b:	00 
 89c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8a3:	89 44 24 08          	mov    %eax,0x8(%esp)
 8a7:	e8 b4 03 00 00       	call   c60 <printf>
        do_work(32766, 0, 6);
 8ac:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
 8b3:	00 
 8b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8bb:	00 
 8bc:	c7 04 24 fe 7f 00 00 	movl   $0x7ffe,(%esp)
 8c3:	e8 88 f8 ff ff       	call   150 <do_work>
 8c8:	66 90                	xchg   %ax,%ax
 8ca:	66 90                	xchg   %ax,%ax
 8cc:	66 90                	xchg   %ax,%ax
 8ce:	66 90                	xchg   %ax,%ax

000008d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	8b 45 08             	mov    0x8(%ebp),%eax
 8d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8d9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 8da:	89 c2                	mov    %eax,%edx
 8dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8e0:	83 c1 01             	add    $0x1,%ecx
 8e3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 8e7:	83 c2 01             	add    $0x1,%edx
 8ea:	84 db                	test   %bl,%bl
 8ec:	88 5a ff             	mov    %bl,-0x1(%edx)
 8ef:	75 ef                	jne    8e0 <strcpy+0x10>
    ;
  return os;
}
 8f1:	5b                   	pop    %ebx
 8f2:	5d                   	pop    %ebp
 8f3:	c3                   	ret    
 8f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000900 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	8b 55 08             	mov    0x8(%ebp),%edx
 906:	53                   	push   %ebx
 907:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 90a:	0f b6 02             	movzbl (%edx),%eax
 90d:	84 c0                	test   %al,%al
 90f:	74 2d                	je     93e <strcmp+0x3e>
 911:	0f b6 19             	movzbl (%ecx),%ebx
 914:	38 d8                	cmp    %bl,%al
 916:	74 0e                	je     926 <strcmp+0x26>
 918:	eb 2b                	jmp    945 <strcmp+0x45>
 91a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 920:	38 c8                	cmp    %cl,%al
 922:	75 15                	jne    939 <strcmp+0x39>
    p++, q++;
 924:	89 d9                	mov    %ebx,%ecx
 926:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 929:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 92c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 92f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 933:	84 c0                	test   %al,%al
 935:	75 e9                	jne    920 <strcmp+0x20>
 937:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 939:	29 c8                	sub    %ecx,%eax
}
 93b:	5b                   	pop    %ebx
 93c:	5d                   	pop    %ebp
 93d:	c3                   	ret    
 93e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 941:	31 c0                	xor    %eax,%eax
 943:	eb f4                	jmp    939 <strcmp+0x39>
 945:	0f b6 cb             	movzbl %bl,%ecx
 948:	eb ef                	jmp    939 <strcmp+0x39>
 94a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000950 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 956:	80 39 00             	cmpb   $0x0,(%ecx)
 959:	74 12                	je     96d <strlen+0x1d>
 95b:	31 d2                	xor    %edx,%edx
 95d:	8d 76 00             	lea    0x0(%esi),%esi
 960:	83 c2 01             	add    $0x1,%edx
 963:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 967:	89 d0                	mov    %edx,%eax
 969:	75 f5                	jne    960 <strlen+0x10>
    ;
  return n;
}
 96b:	5d                   	pop    %ebp
 96c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 96d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 96f:	5d                   	pop    %ebp
 970:	c3                   	ret    
 971:	eb 0d                	jmp    980 <memset>
 973:	90                   	nop
 974:	90                   	nop
 975:	90                   	nop
 976:	90                   	nop
 977:	90                   	nop
 978:	90                   	nop
 979:	90                   	nop
 97a:	90                   	nop
 97b:	90                   	nop
 97c:	90                   	nop
 97d:	90                   	nop
 97e:	90                   	nop
 97f:	90                   	nop

00000980 <memset>:

void*
memset(void *dst, int c, uint n)
{
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	8b 55 08             	mov    0x8(%ebp),%edx
 986:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 987:	8b 4d 10             	mov    0x10(%ebp),%ecx
 98a:	8b 45 0c             	mov    0xc(%ebp),%eax
 98d:	89 d7                	mov    %edx,%edi
 98f:	fc                   	cld    
 990:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 992:	89 d0                	mov    %edx,%eax
 994:	5f                   	pop    %edi
 995:	5d                   	pop    %ebp
 996:	c3                   	ret    
 997:	89 f6                	mov    %esi,%esi
 999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000009a0 <strchr>:

char*
strchr(const char *s, char c)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	8b 45 08             	mov    0x8(%ebp),%eax
 9a6:	53                   	push   %ebx
 9a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 9aa:	0f b6 18             	movzbl (%eax),%ebx
 9ad:	84 db                	test   %bl,%bl
 9af:	74 1d                	je     9ce <strchr+0x2e>
    if(*s == c)
 9b1:	38 d3                	cmp    %dl,%bl
 9b3:	89 d1                	mov    %edx,%ecx
 9b5:	75 0d                	jne    9c4 <strchr+0x24>
 9b7:	eb 17                	jmp    9d0 <strchr+0x30>
 9b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9c0:	38 ca                	cmp    %cl,%dl
 9c2:	74 0c                	je     9d0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 9c4:	83 c0 01             	add    $0x1,%eax
 9c7:	0f b6 10             	movzbl (%eax),%edx
 9ca:	84 d2                	test   %dl,%dl
 9cc:	75 f2                	jne    9c0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 9ce:	31 c0                	xor    %eax,%eax
}
 9d0:	5b                   	pop    %ebx
 9d1:	5d                   	pop    %ebp
 9d2:	c3                   	ret    
 9d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 9d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000009e0 <gets>:

char*
gets(char *buf, int max)
{
 9e0:	55                   	push   %ebp
 9e1:	89 e5                	mov    %esp,%ebp
 9e3:	57                   	push   %edi
 9e4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 9e5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 9e7:	53                   	push   %ebx
 9e8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 9eb:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 9ee:	eb 31                	jmp    a21 <gets+0x41>
    cc = read(0, &c, 1);
 9f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 9f7:	00 
 9f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 9fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 a03:	e8 02 01 00 00       	call   b0a <read>
    if(cc < 1)
 a08:	85 c0                	test   %eax,%eax
 a0a:	7e 1d                	jle    a29 <gets+0x49>
      break;
    buf[i++] = c;
 a0c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 a10:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 a12:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 a15:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 a17:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 a1b:	74 0c                	je     a29 <gets+0x49>
 a1d:	3c 0a                	cmp    $0xa,%al
 a1f:	74 08                	je     a29 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 a21:	8d 5e 01             	lea    0x1(%esi),%ebx
 a24:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 a27:	7c c7                	jl     9f0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 a29:	8b 45 08             	mov    0x8(%ebp),%eax
 a2c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 a30:	83 c4 2c             	add    $0x2c,%esp
 a33:	5b                   	pop    %ebx
 a34:	5e                   	pop    %esi
 a35:	5f                   	pop    %edi
 a36:	5d                   	pop    %ebp
 a37:	c3                   	ret    
 a38:	90                   	nop
 a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000a40 <stat>:

int
stat(char *n, struct stat *st)
{
 a40:	55                   	push   %ebp
 a41:	89 e5                	mov    %esp,%ebp
 a43:	56                   	push   %esi
 a44:	53                   	push   %ebx
 a45:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 a48:	8b 45 08             	mov    0x8(%ebp),%eax
 a4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 a52:	00 
 a53:	89 04 24             	mov    %eax,(%esp)
 a56:	e8 d7 00 00 00       	call   b32 <open>
  if(fd < 0)
 a5b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 a5d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 a5f:	78 27                	js     a88 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 a61:	8b 45 0c             	mov    0xc(%ebp),%eax
 a64:	89 1c 24             	mov    %ebx,(%esp)
 a67:	89 44 24 04          	mov    %eax,0x4(%esp)
 a6b:	e8 da 00 00 00       	call   b4a <fstat>
  close(fd);
 a70:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 a73:	89 c6                	mov    %eax,%esi
  close(fd);
 a75:	e8 a0 00 00 00       	call   b1a <close>
  return r;
 a7a:	89 f0                	mov    %esi,%eax
}
 a7c:	83 c4 10             	add    $0x10,%esp
 a7f:	5b                   	pop    %ebx
 a80:	5e                   	pop    %esi
 a81:	5d                   	pop    %ebp
 a82:	c3                   	ret    
 a83:	90                   	nop
 a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a8d:	eb ed                	jmp    a7c <stat+0x3c>
 a8f:	90                   	nop

00000a90 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 a90:	55                   	push   %ebp
 a91:	89 e5                	mov    %esp,%ebp
 a93:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a96:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 a97:	0f be 11             	movsbl (%ecx),%edx
 a9a:	8d 42 d0             	lea    -0x30(%edx),%eax
 a9d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 aa4:	77 17                	ja     abd <atoi+0x2d>
 aa6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 aa8:	83 c1 01             	add    $0x1,%ecx
 aab:	8d 04 80             	lea    (%eax,%eax,4),%eax
 aae:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 ab2:	0f be 11             	movsbl (%ecx),%edx
 ab5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 ab8:	80 fb 09             	cmp    $0x9,%bl
 abb:	76 eb                	jbe    aa8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 abd:	5b                   	pop    %ebx
 abe:	5d                   	pop    %ebp
 abf:	c3                   	ret    

00000ac0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 ac0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 ac1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 ac3:	89 e5                	mov    %esp,%ebp
 ac5:	56                   	push   %esi
 ac6:	8b 45 08             	mov    0x8(%ebp),%eax
 ac9:	53                   	push   %ebx
 aca:	8b 5d 10             	mov    0x10(%ebp),%ebx
 acd:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 ad0:	85 db                	test   %ebx,%ebx
 ad2:	7e 12                	jle    ae6 <memmove+0x26>
 ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 ad8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 adc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 adf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 ae2:	39 da                	cmp    %ebx,%edx
 ae4:	75 f2                	jne    ad8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 ae6:	5b                   	pop    %ebx
 ae7:	5e                   	pop    %esi
 ae8:	5d                   	pop    %ebp
 ae9:	c3                   	ret    

00000aea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 aea:	b8 01 00 00 00       	mov    $0x1,%eax
 aef:	cd 40                	int    $0x40
 af1:	c3                   	ret    

00000af2 <exit>:
SYSCALL(exit)
 af2:	b8 02 00 00 00       	mov    $0x2,%eax
 af7:	cd 40                	int    $0x40
 af9:	c3                   	ret    

00000afa <wait>:
SYSCALL(wait)
 afa:	b8 03 00 00 00       	mov    $0x3,%eax
 aff:	cd 40                	int    $0x40
 b01:	c3                   	ret    

00000b02 <pipe>:
SYSCALL(pipe)
 b02:	b8 04 00 00 00       	mov    $0x4,%eax
 b07:	cd 40                	int    $0x40
 b09:	c3                   	ret    

00000b0a <read>:
SYSCALL(read)
 b0a:	b8 05 00 00 00       	mov    $0x5,%eax
 b0f:	cd 40                	int    $0x40
 b11:	c3                   	ret    

00000b12 <write>:
SYSCALL(write)
 b12:	b8 10 00 00 00       	mov    $0x10,%eax
 b17:	cd 40                	int    $0x40
 b19:	c3                   	ret    

00000b1a <close>:
SYSCALL(close)
 b1a:	b8 15 00 00 00       	mov    $0x15,%eax
 b1f:	cd 40                	int    $0x40
 b21:	c3                   	ret    

00000b22 <kill>:
SYSCALL(kill)
 b22:	b8 06 00 00 00       	mov    $0x6,%eax
 b27:	cd 40                	int    $0x40
 b29:	c3                   	ret    

00000b2a <exec>:
SYSCALL(exec)
 b2a:	b8 07 00 00 00       	mov    $0x7,%eax
 b2f:	cd 40                	int    $0x40
 b31:	c3                   	ret    

00000b32 <open>:
SYSCALL(open)
 b32:	b8 0f 00 00 00       	mov    $0xf,%eax
 b37:	cd 40                	int    $0x40
 b39:	c3                   	ret    

00000b3a <mknod>:
SYSCALL(mknod)
 b3a:	b8 11 00 00 00       	mov    $0x11,%eax
 b3f:	cd 40                	int    $0x40
 b41:	c3                   	ret    

00000b42 <unlink>:
SYSCALL(unlink)
 b42:	b8 12 00 00 00       	mov    $0x12,%eax
 b47:	cd 40                	int    $0x40
 b49:	c3                   	ret    

00000b4a <fstat>:
SYSCALL(fstat)
 b4a:	b8 08 00 00 00       	mov    $0x8,%eax
 b4f:	cd 40                	int    $0x40
 b51:	c3                   	ret    

00000b52 <link>:
SYSCALL(link)
 b52:	b8 13 00 00 00       	mov    $0x13,%eax
 b57:	cd 40                	int    $0x40
 b59:	c3                   	ret    

00000b5a <mkdir>:
SYSCALL(mkdir)
 b5a:	b8 14 00 00 00       	mov    $0x14,%eax
 b5f:	cd 40                	int    $0x40
 b61:	c3                   	ret    

00000b62 <chdir>:
SYSCALL(chdir)
 b62:	b8 09 00 00 00       	mov    $0x9,%eax
 b67:	cd 40                	int    $0x40
 b69:	c3                   	ret    

00000b6a <dup>:
SYSCALL(dup)
 b6a:	b8 0a 00 00 00       	mov    $0xa,%eax
 b6f:	cd 40                	int    $0x40
 b71:	c3                   	ret    

00000b72 <getpid>:
SYSCALL(getpid)
 b72:	b8 0b 00 00 00       	mov    $0xb,%eax
 b77:	cd 40                	int    $0x40
 b79:	c3                   	ret    

00000b7a <sbrk>:
SYSCALL(sbrk)
 b7a:	b8 0c 00 00 00       	mov    $0xc,%eax
 b7f:	cd 40                	int    $0x40
 b81:	c3                   	ret    

00000b82 <sleep>:
SYSCALL(sleep)
 b82:	b8 0d 00 00 00       	mov    $0xd,%eax
 b87:	cd 40                	int    $0x40
 b89:	c3                   	ret    

00000b8a <uptime>:
SYSCALL(uptime)
 b8a:	b8 0e 00 00 00       	mov    $0xe,%eax
 b8f:	cd 40                	int    $0x40
 b91:	c3                   	ret    

00000b92 <cps>:
SYSCALL(cps)
 b92:	b8 16 00 00 00       	mov    $0x16,%eax
 b97:	cd 40                	int    $0x40
 b99:	c3                   	ret    

00000b9a <chpr>:
SYSCALL(chpr)
 b9a:	b8 17 00 00 00       	mov    $0x17,%eax
 b9f:	cd 40                	int    $0x40
 ba1:	c3                   	ret    

00000ba2 <settickets>:
SYSCALL(settickets)
 ba2:	b8 18 00 00 00       	mov    $0x18,%eax
 ba7:	cd 40                	int    $0x40
 ba9:	c3                   	ret    

00000baa <chr>:
SYSCALL(chr)
 baa:	b8 19 00 00 00       	mov    $0x19,%eax
 baf:	cd 40                	int    $0x40
 bb1:	c3                   	ret    
 bb2:	66 90                	xchg   %ax,%ax
 bb4:	66 90                	xchg   %ax,%ax
 bb6:	66 90                	xchg   %ax,%ax
 bb8:	66 90                	xchg   %ax,%ax
 bba:	66 90                	xchg   %ax,%ax
 bbc:	66 90                	xchg   %ax,%ax
 bbe:	66 90                	xchg   %ax,%ax

00000bc0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 bc0:	55                   	push   %ebp
 bc1:	89 e5                	mov    %esp,%ebp
 bc3:	57                   	push   %edi
 bc4:	56                   	push   %esi
 bc5:	89 c6                	mov    %eax,%esi
 bc7:	53                   	push   %ebx
 bc8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 bcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 bce:	85 db                	test   %ebx,%ebx
 bd0:	74 09                	je     bdb <printint+0x1b>
 bd2:	89 d0                	mov    %edx,%eax
 bd4:	c1 e8 1f             	shr    $0x1f,%eax
 bd7:	84 c0                	test   %al,%al
 bd9:	75 75                	jne    c50 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 bdb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 bdd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 be4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 be7:	31 ff                	xor    %edi,%edi
 be9:	89 ce                	mov    %ecx,%esi
 beb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 bee:	eb 02                	jmp    bf2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 bf0:	89 cf                	mov    %ecx,%edi
 bf2:	31 d2                	xor    %edx,%edx
 bf4:	f7 f6                	div    %esi
 bf6:	8d 4f 01             	lea    0x1(%edi),%ecx
 bf9:	0f b6 92 19 13 00 00 	movzbl 0x1319(%edx),%edx
  }while((x /= base) != 0);
 c00:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 c02:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 c05:	75 e9                	jne    bf0 <printint+0x30>
  if(neg)
 c07:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 c0a:	89 c8                	mov    %ecx,%eax
 c0c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 c0f:	85 d2                	test   %edx,%edx
 c11:	74 08                	je     c1b <printint+0x5b>
    buf[i++] = '-';
 c13:	8d 4f 02             	lea    0x2(%edi),%ecx
 c16:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 c1b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 c1e:	66 90                	xchg   %ax,%ax
 c20:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 c25:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 c28:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 c2f:	00 
 c30:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 c34:	89 34 24             	mov    %esi,(%esp)
 c37:	88 45 d7             	mov    %al,-0x29(%ebp)
 c3a:	e8 d3 fe ff ff       	call   b12 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 c3f:	83 ff ff             	cmp    $0xffffffff,%edi
 c42:	75 dc                	jne    c20 <printint+0x60>
    putc(fd, buf[i]);
}
 c44:	83 c4 4c             	add    $0x4c,%esp
 c47:	5b                   	pop    %ebx
 c48:	5e                   	pop    %esi
 c49:	5f                   	pop    %edi
 c4a:	5d                   	pop    %ebp
 c4b:	c3                   	ret    
 c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 c50:	89 d0                	mov    %edx,%eax
 c52:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 c54:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 c5b:	eb 87                	jmp    be4 <printint+0x24>
 c5d:	8d 76 00             	lea    0x0(%esi),%esi

00000c60 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 c60:	55                   	push   %ebp
 c61:	89 e5                	mov    %esp,%ebp
 c63:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 c64:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 c66:	56                   	push   %esi
 c67:	53                   	push   %ebx
 c68:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 c6e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 c71:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 c74:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 c77:	0f b6 13             	movzbl (%ebx),%edx
 c7a:	83 c3 01             	add    $0x1,%ebx
 c7d:	84 d2                	test   %dl,%dl
 c7f:	75 39                	jne    cba <printf+0x5a>
 c81:	e9 c2 00 00 00       	jmp    d48 <printf+0xe8>
 c86:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 c88:	83 fa 25             	cmp    $0x25,%edx
 c8b:	0f 84 bf 00 00 00    	je     d50 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 c91:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 c94:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 c9b:	00 
 c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
 ca0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 ca3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 ca6:	e8 67 fe ff ff       	call   b12 <write>
 cab:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 cae:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 cb2:	84 d2                	test   %dl,%dl
 cb4:	0f 84 8e 00 00 00    	je     d48 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 cba:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 cbc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 cbf:	74 c7                	je     c88 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 cc1:	83 ff 25             	cmp    $0x25,%edi
 cc4:	75 e5                	jne    cab <printf+0x4b>
      if(c == 'd'){
 cc6:	83 fa 64             	cmp    $0x64,%edx
 cc9:	0f 84 31 01 00 00    	je     e00 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 ccf:	25 f7 00 00 00       	and    $0xf7,%eax
 cd4:	83 f8 70             	cmp    $0x70,%eax
 cd7:	0f 84 83 00 00 00    	je     d60 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 cdd:	83 fa 73             	cmp    $0x73,%edx
 ce0:	0f 84 a2 00 00 00    	je     d88 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 ce6:	83 fa 63             	cmp    $0x63,%edx
 ce9:	0f 84 35 01 00 00    	je     e24 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 cef:	83 fa 25             	cmp    $0x25,%edx
 cf2:	0f 84 e0 00 00 00    	je     dd8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 cf8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 cfb:	83 c3 01             	add    $0x1,%ebx
 cfe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 d05:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 d06:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d08:	89 44 24 04          	mov    %eax,0x4(%esp)
 d0c:	89 34 24             	mov    %esi,(%esp)
 d0f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 d12:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 d16:	e8 f7 fd ff ff       	call   b12 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 d1b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d1e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 d21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 d28:	00 
 d29:	89 44 24 04          	mov    %eax,0x4(%esp)
 d2d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 d30:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d33:	e8 da fd ff ff       	call   b12 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 d38:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 d3c:	84 d2                	test   %dl,%dl
 d3e:	0f 85 76 ff ff ff    	jne    cba <printf+0x5a>
 d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 d48:	83 c4 3c             	add    $0x3c,%esp
 d4b:	5b                   	pop    %ebx
 d4c:	5e                   	pop    %esi
 d4d:	5f                   	pop    %edi
 d4e:	5d                   	pop    %ebp
 d4f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 d50:	bf 25 00 00 00       	mov    $0x25,%edi
 d55:	e9 51 ff ff ff       	jmp    cab <printf+0x4b>
 d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 d60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 d63:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 d68:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 d6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 d71:	8b 10                	mov    (%eax),%edx
 d73:	89 f0                	mov    %esi,%eax
 d75:	e8 46 fe ff ff       	call   bc0 <printint>
        ap++;
 d7a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 d7e:	e9 28 ff ff ff       	jmp    cab <printf+0x4b>
 d83:	90                   	nop
 d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 d88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 d8b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 d8f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 d91:	b8 12 13 00 00       	mov    $0x1312,%eax
 d96:	85 ff                	test   %edi,%edi
 d98:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 d9b:	0f b6 07             	movzbl (%edi),%eax
 d9e:	84 c0                	test   %al,%al
 da0:	74 2a                	je     dcc <printf+0x16c>
 da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 da8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 dab:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 dae:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 db1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 db8:	00 
 db9:	89 44 24 04          	mov    %eax,0x4(%esp)
 dbd:	89 34 24             	mov    %esi,(%esp)
 dc0:	e8 4d fd ff ff       	call   b12 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 dc5:	0f b6 07             	movzbl (%edi),%eax
 dc8:	84 c0                	test   %al,%al
 dca:	75 dc                	jne    da8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 dcc:	31 ff                	xor    %edi,%edi
 dce:	e9 d8 fe ff ff       	jmp    cab <printf+0x4b>
 dd3:	90                   	nop
 dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 dd8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 ddb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 ddd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 de4:	00 
 de5:	89 44 24 04          	mov    %eax,0x4(%esp)
 de9:	89 34 24             	mov    %esi,(%esp)
 dec:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 df0:	e8 1d fd ff ff       	call   b12 <write>
 df5:	e9 b1 fe ff ff       	jmp    cab <printf+0x4b>
 dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 e00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 e03:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 e08:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 e0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 e12:	8b 10                	mov    (%eax),%edx
 e14:	89 f0                	mov    %esi,%eax
 e16:	e8 a5 fd ff ff       	call   bc0 <printint>
        ap++;
 e1b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 e1f:	e9 87 fe ff ff       	jmp    cab <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 e24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 e27:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 e29:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 e2b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 e32:	00 
 e33:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 e36:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 e39:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 e3c:	89 44 24 04          	mov    %eax,0x4(%esp)
 e40:	e8 cd fc ff ff       	call   b12 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 e45:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 e49:	e9 5d fe ff ff       	jmp    cab <printf+0x4b>
 e4e:	66 90                	xchg   %ax,%ax

00000e50 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e50:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e51:	a1 e8 16 00 00       	mov    0x16e8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 e56:	89 e5                	mov    %esp,%ebp
 e58:	57                   	push   %edi
 e59:	56                   	push   %esi
 e5a:	53                   	push   %ebx
 e5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e5e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 e60:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e63:	39 d0                	cmp    %edx,%eax
 e65:	72 11                	jb     e78 <free+0x28>
 e67:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e68:	39 c8                	cmp    %ecx,%eax
 e6a:	72 04                	jb     e70 <free+0x20>
 e6c:	39 ca                	cmp    %ecx,%edx
 e6e:	72 10                	jb     e80 <free+0x30>
 e70:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e72:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e74:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e76:	73 f0                	jae    e68 <free+0x18>
 e78:	39 ca                	cmp    %ecx,%edx
 e7a:	72 04                	jb     e80 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e7c:	39 c8                	cmp    %ecx,%eax
 e7e:	72 f0                	jb     e70 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 e80:	8b 73 fc             	mov    -0x4(%ebx),%esi
 e83:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 e86:	39 cf                	cmp    %ecx,%edi
 e88:	74 1e                	je     ea8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 e8a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 e8d:	8b 48 04             	mov    0x4(%eax),%ecx
 e90:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 e93:	39 f2                	cmp    %esi,%edx
 e95:	74 28                	je     ebf <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 e97:	89 10                	mov    %edx,(%eax)
  freep = p;
 e99:	a3 e8 16 00 00       	mov    %eax,0x16e8
}
 e9e:	5b                   	pop    %ebx
 e9f:	5e                   	pop    %esi
 ea0:	5f                   	pop    %edi
 ea1:	5d                   	pop    %ebp
 ea2:	c3                   	ret    
 ea3:	90                   	nop
 ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ea8:	03 71 04             	add    0x4(%ecx),%esi
 eab:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 eae:	8b 08                	mov    (%eax),%ecx
 eb0:	8b 09                	mov    (%ecx),%ecx
 eb2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 eb5:	8b 48 04             	mov    0x4(%eax),%ecx
 eb8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 ebb:	39 f2                	cmp    %esi,%edx
 ebd:	75 d8                	jne    e97 <free+0x47>
    p->s.size += bp->s.size;
 ebf:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 ec2:	a3 e8 16 00 00       	mov    %eax,0x16e8
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ec7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 eca:	8b 53 f8             	mov    -0x8(%ebx),%edx
 ecd:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 ecf:	5b                   	pop    %ebx
 ed0:	5e                   	pop    %esi
 ed1:	5f                   	pop    %edi
 ed2:	5d                   	pop    %ebp
 ed3:	c3                   	ret    
 ed4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 eda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000ee0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ee0:	55                   	push   %ebp
 ee1:	89 e5                	mov    %esp,%ebp
 ee3:	57                   	push   %edi
 ee4:	56                   	push   %esi
 ee5:	53                   	push   %ebx
 ee6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 eec:	8b 1d e8 16 00 00    	mov    0x16e8,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ef2:	8d 48 07             	lea    0x7(%eax),%ecx
 ef5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 ef8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 efa:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 efd:	0f 84 9b 00 00 00    	je     f9e <malloc+0xbe>
 f03:	8b 13                	mov    (%ebx),%edx
 f05:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 f08:	39 fe                	cmp    %edi,%esi
 f0a:	76 64                	jbe    f70 <malloc+0x90>
 f0c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 f13:	bb 00 80 00 00       	mov    $0x8000,%ebx
 f18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 f1b:	eb 0e                	jmp    f2b <malloc+0x4b>
 f1d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f20:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 f22:	8b 78 04             	mov    0x4(%eax),%edi
 f25:	39 fe                	cmp    %edi,%esi
 f27:	76 4f                	jbe    f78 <malloc+0x98>
 f29:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 f2b:	3b 15 e8 16 00 00    	cmp    0x16e8,%edx
 f31:	75 ed                	jne    f20 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 f33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 f36:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 f3c:	bf 00 10 00 00       	mov    $0x1000,%edi
 f41:	0f 43 fe             	cmovae %esi,%edi
 f44:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 f47:	89 04 24             	mov    %eax,(%esp)
 f4a:	e8 2b fc ff ff       	call   b7a <sbrk>
  if(p == (char*)-1)
 f4f:	83 f8 ff             	cmp    $0xffffffff,%eax
 f52:	74 18                	je     f6c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 f54:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 f57:	83 c0 08             	add    $0x8,%eax
 f5a:	89 04 24             	mov    %eax,(%esp)
 f5d:	e8 ee fe ff ff       	call   e50 <free>
  return freep;
 f62:	8b 15 e8 16 00 00    	mov    0x16e8,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 f68:	85 d2                	test   %edx,%edx
 f6a:	75 b4                	jne    f20 <malloc+0x40>
        return 0;
 f6c:	31 c0                	xor    %eax,%eax
 f6e:	eb 20                	jmp    f90 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 f70:	89 d0                	mov    %edx,%eax
 f72:	89 da                	mov    %ebx,%edx
 f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 f78:	39 fe                	cmp    %edi,%esi
 f7a:	74 1c                	je     f98 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 f7c:	29 f7                	sub    %esi,%edi
 f7e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 f81:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 f84:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 f87:	89 15 e8 16 00 00    	mov    %edx,0x16e8
      return (void*)(p + 1);
 f8d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 f90:	83 c4 1c             	add    $0x1c,%esp
 f93:	5b                   	pop    %ebx
 f94:	5e                   	pop    %esi
 f95:	5f                   	pop    %edi
 f96:	5d                   	pop    %ebp
 f97:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 f98:	8b 08                	mov    (%eax),%ecx
 f9a:	89 0a                	mov    %ecx,(%edx)
 f9c:	eb e9                	jmp    f87 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 f9e:	c7 05 e8 16 00 00 ec 	movl   $0x16ec,0x16e8
 fa5:	16 00 00 
    base.s.size = 0;
 fa8:	ba ec 16 00 00       	mov    $0x16ec,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 fad:	c7 05 ec 16 00 00 ec 	movl   $0x16ec,0x16ec
 fb4:	16 00 00 
    base.s.size = 0;
 fb7:	c7 05 f0 16 00 00 00 	movl   $0x0,0x16f0
 fbe:	00 00 00 
 fc1:	e9 46 ff ff ff       	jmp    f0c <malloc+0x2c>
