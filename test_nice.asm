
_test_nice:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
        cps();
    }
    printf(1, "-------------------------\n");
}

int main(int argc, char *argv[]) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
    if (argc != 1) {
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
        printf(1, "Usage: test_nice\n");
   f:	c7 44 24 04 79 09 00 	movl   $0x979,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 5d 05 00 00       	call   580 <printf>
        exit();
  23:	e8 ea 03 00 00       	call   412 <exit>
    }

    int pid = 2;  // Replace with the appropriate PID


    run_test(pid, 10, "Valid input");
  28:	c7 44 24 08 8b 09 00 	movl   $0x98b,0x8(%esp)
  2f:	00 
  30:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  37:	00 
  38:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  3f:	e8 dc 00 00 00       	call   120 <run_test>
    run_test(pid, 20, "Out-of-bounds high");
  44:	c7 44 24 08 97 09 00 	movl   $0x997,0x8(%esp)
  4b:	00 
  4c:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
  53:	00 
  54:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  5b:	e8 c0 00 00 00       	call   120 <run_test>
    run_test(pid, -21, "Out-of-bounds low");
  60:	c7 44 24 08 aa 09 00 	movl   $0x9aa,0x8(%esp)
  67:	00 
  68:	c7 44 24 04 eb ff ff 	movl   $0xffffffeb,0x4(%esp)
  6f:	ff 
  70:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  77:	e8 a4 00 00 00       	call   120 <run_test>
    run_test(pid, custom_strtol("abc"), "Invalid input");
  7c:	c7 04 24 bc 09 00 00 	movl   $0x9bc,(%esp)
  83:	e8 28 00 00 00       	call   b0 <custom_strtol>
  88:	c7 44 24 08 c0 09 00 	movl   $0x9c0,0x8(%esp)
  8f:	00 
  90:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  97:	89 44 24 04          	mov    %eax,0x4(%esp)
  9b:	e8 80 00 00 00       	call   120 <run_test>
    // Add more test cases as needed

    exit();
  a0:	e8 6d 03 00 00       	call   412 <exit>
  a5:	66 90                	xchg   %ax,%ax
  a7:	66 90                	xchg   %ax,%ax
  a9:	66 90                	xchg   %ax,%ax
  ab:	66 90                	xchg   %ax,%ax
  ad:	66 90                	xchg   %ax,%ax
  af:	90                   	nop

000000b0 <custom_strtol>:
#include "types.h"
#include "user.h"

#define CUSTOM_STRTOL_ERROR -5  // Define an error code

long custom_strtol(const char *str) {
  b0:	55                   	push   %ebp
    long result = 0;
    int sign = 1;
    int i = 0;

    if (str[0] == '-') {
  b1:	31 d2                	xor    %edx,%edx
#include "types.h"
#include "user.h"

#define CUSTOM_STRTOL_ERROR -5  // Define an error code

long custom_strtol(const char *str) {
  b3:	89 e5                	mov    %esp,%ebp
  b5:	8b 45 08             	mov    0x8(%ebp),%eax
  b8:	57                   	push   %edi
  b9:	56                   	push   %esi
  ba:	53                   	push   %ebx
    long result = 0;
    int sign = 1;
    int i = 0;

    if (str[0] == '-') {
  bb:	80 38 2d             	cmpb   $0x2d,(%eax)
  be:	0f 94 c2             	sete   %dl
  c1:	0f 95 c3             	setne  %bl
  c4:	89 d1                	mov    %edx,%ecx
        sign = -1;
        i = 1;
    }

    for (; str[i] != '\0'; i++) {
  c6:	0f be 14 10          	movsbl (%eax,%edx,1),%edx
long custom_strtol(const char *str) {
    long result = 0;
    int sign = 1;
    int i = 0;

    if (str[0] == '-') {
  ca:	0f b6 db             	movzbl %bl,%ebx
  cd:	8d 7c 1b ff          	lea    -0x1(%ebx,%ebx,1),%edi
        sign = -1;
        i = 1;
    }

    for (; str[i] != '\0'; i++) {
  d1:	84 d2                	test   %dl,%dl
  d3:	74 45                	je     11a <custom_strtol+0x6a>
        if (str[i] >= '0' && str[i] <= '9') {
  d5:	8d 72 d0             	lea    -0x30(%edx),%esi
  d8:	89 f3                	mov    %esi,%ebx
  da:	80 fb 09             	cmp    $0x9,%bl
  dd:	77 31                	ja     110 <custom_strtol+0x60>
  df:	01 c1                	add    %eax,%ecx
  e1:	31 c0                	xor    %eax,%eax
  e3:	eb 0e                	jmp    f3 <custom_strtol+0x43>
  e5:	8d 76 00             	lea    0x0(%esi),%esi
  e8:	8d 5a d0             	lea    -0x30(%edx),%ebx
  eb:	83 c1 01             	add    $0x1,%ecx
  ee:	80 fb 09             	cmp    $0x9,%bl
  f1:	77 1d                	ja     110 <custom_strtol+0x60>
            result = result * 10 + (str[i] - '0');
  f3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  f6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
    if (str[0] == '-') {
        sign = -1;
        i = 1;
    }

    for (; str[i] != '\0'; i++) {
  fa:	0f be 51 01          	movsbl 0x1(%ecx),%edx
  fe:	84 d2                	test   %dl,%dl
 100:	75 e6                	jne    e8 <custom_strtol+0x38>
 102:	0f af c7             	imul   %edi,%eax
            return -5;
        }
    }

    return result * sign;
}
 105:	5b                   	pop    %ebx
 106:	5e                   	pop    %esi
 107:	5f                   	pop    %edi
 108:	5d                   	pop    %ebp
 109:	c3                   	ret    
 10a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 110:	5b                   	pop    %ebx
    for (; str[i] != '\0'; i++) {
        if (str[i] >= '0' && str[i] <= '9') {
            result = result * 10 + (str[i] - '0');
        } else {
            // Handle invalid characters or other cases
            return -5;
 111:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
        }
    }

    return result * sign;
}
 116:	5e                   	pop    %esi
 117:	5f                   	pop    %edi
 118:	5d                   	pop    %ebp
 119:	c3                   	ret    
    if (str[0] == '-') {
        sign = -1;
        i = 1;
    }

    for (; str[i] != '\0'; i++) {
 11a:	31 c0                	xor    %eax,%eax
            // Handle invalid characters or other cases
            return -5;
        }
    }

    return result * sign;
 11c:	eb e7                	jmp    105 <custom_strtol+0x55>
 11e:	66 90                	xchg   %ax,%ax

00000120 <run_test>:
}

void run_test(int pid, long value, const char *description) {
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	56                   	push   %esi
 125:	53                   	push   %ebx
 126:	83 ec 1c             	sub    $0x1c,%esp
 129:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	8b 75 10             	mov    0x10(%ebp),%esi
    if (value == CUSTOM_STRTOL_ERROR) {
 132:	83 fb fb             	cmp    $0xfffffffb,%ebx
 135:	0f 84 85 00 00 00    	je     1c0 <run_test+0xa0>
        printf(2, "Invalid value in test case: %s\n", description);
        cps();
        return;
    }

    int result = chpr(pid, (int)value);
 13b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 13f:	89 04 24             	mov    %eax,(%esp)
 142:	e8 73 03 00 00       	call   4ba <chpr>
    printf(1, "Test case: %s with value %d\n", description, value);
 147:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 14b:	89 74 24 08          	mov    %esi,0x8(%esp)
 14f:	c7 44 24 04 08 09 00 	movl   $0x908,0x4(%esp)
 156:	00 
 157:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
        printf(2, "Invalid value in test case: %s\n", description);
        cps();
        return;
    }

    int result = chpr(pid, (int)value);
 15e:	89 c7                	mov    %eax,%edi
    printf(1, "Test case: %s with value %d\n", description, value);
 160:	e8 1b 04 00 00       	call   580 <printf>
    if (result == 0) {
 165:	85 ff                	test   %edi,%edi
 167:	74 37                	je     1a0 <run_test+0x80>
        printf(1, "Nice value set successfully.\n");
        cps();
    } else {
        printf(2, "Failed to set nice value.\n");
 169:	c7 44 24 04 43 09 00 	movl   $0x943,0x4(%esp)
 170:	00 
 171:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 178:	e8 03 04 00 00       	call   580 <printf>
        cps();
 17d:	e8 30 03 00 00       	call   4b2 <cps>
    }
    printf(1, "-------------------------\n");
 182:	c7 45 0c 5e 09 00 00 	movl   $0x95e,0xc(%ebp)
 189:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
 190:	83 c4 1c             	add    $0x1c,%esp
 193:	5b                   	pop    %ebx
 194:	5e                   	pop    %esi
 195:	5f                   	pop    %edi
 196:	5d                   	pop    %ebp
        cps();
    } else {
        printf(2, "Failed to set nice value.\n");
        cps();
    }
    printf(1, "-------------------------\n");
 197:	e9 e4 03 00 00       	jmp    580 <printf>
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }

    int result = chpr(pid, (int)value);
    printf(1, "Test case: %s with value %d\n", description, value);
    if (result == 0) {
        printf(1, "Nice value set successfully.\n");
 1a0:	c7 44 24 04 25 09 00 	movl   $0x925,0x4(%esp)
 1a7:	00 
 1a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1af:	e8 cc 03 00 00       	call   580 <printf>
        cps();
 1b4:	e8 f9 02 00 00       	call   4b2 <cps>
 1b9:	eb c7                	jmp    182 <run_test+0x62>
 1bb:	90                   	nop
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return result * sign;
}

void run_test(int pid, long value, const char *description) {
    if (value == CUSTOM_STRTOL_ERROR) {
        printf(2, "Invalid value in test case: %s\n", description);
 1c0:	89 74 24 08          	mov    %esi,0x8(%esp)
 1c4:	c7 44 24 04 e8 08 00 	movl   $0x8e8,0x4(%esp)
 1cb:	00 
 1cc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 1d3:	e8 a8 03 00 00       	call   580 <printf>
    } else {
        printf(2, "Failed to set nice value.\n");
        cps();
    }
    printf(1, "-------------------------\n");
}
 1d8:	83 c4 1c             	add    $0x1c,%esp
 1db:	5b                   	pop    %ebx
 1dc:	5e                   	pop    %esi
 1dd:	5f                   	pop    %edi
 1de:	5d                   	pop    %ebp
}

void run_test(int pid, long value, const char *description) {
    if (value == CUSTOM_STRTOL_ERROR) {
        printf(2, "Invalid value in test case: %s\n", description);
        cps();
 1df:	e9 ce 02 00 00       	jmp    4b2 <cps>
 1e4:	66 90                	xchg   %ax,%ax
 1e6:	66 90                	xchg   %ax,%ax
 1e8:	66 90                	xchg   %ax,%ax
 1ea:	66 90                	xchg   %ax,%ax
 1ec:	66 90                	xchg   %ax,%ax
 1ee:	66 90                	xchg   %ax,%ax

000001f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1f9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1fa:	89 c2                	mov    %eax,%edx
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 200:	83 c1 01             	add    $0x1,%ecx
 203:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 207:	83 c2 01             	add    $0x1,%edx
 20a:	84 db                	test   %bl,%bl
 20c:	88 5a ff             	mov    %bl,-0x1(%edx)
 20f:	75 ef                	jne    200 <strcpy+0x10>
    ;
  return os;
}
 211:	5b                   	pop    %ebx
 212:	5d                   	pop    %ebp
 213:	c3                   	ret    
 214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 21a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000220 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 55 08             	mov    0x8(%ebp),%edx
 226:	53                   	push   %ebx
 227:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 22a:	0f b6 02             	movzbl (%edx),%eax
 22d:	84 c0                	test   %al,%al
 22f:	74 2d                	je     25e <strcmp+0x3e>
 231:	0f b6 19             	movzbl (%ecx),%ebx
 234:	38 d8                	cmp    %bl,%al
 236:	74 0e                	je     246 <strcmp+0x26>
 238:	eb 2b                	jmp    265 <strcmp+0x45>
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 240:	38 c8                	cmp    %cl,%al
 242:	75 15                	jne    259 <strcmp+0x39>
    p++, q++;
 244:	89 d9                	mov    %ebx,%ecx
 246:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 249:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 24c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 24f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 253:	84 c0                	test   %al,%al
 255:	75 e9                	jne    240 <strcmp+0x20>
 257:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 259:	29 c8                	sub    %ecx,%eax
}
 25b:	5b                   	pop    %ebx
 25c:	5d                   	pop    %ebp
 25d:	c3                   	ret    
 25e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 261:	31 c0                	xor    %eax,%eax
 263:	eb f4                	jmp    259 <strcmp+0x39>
 265:	0f b6 cb             	movzbl %bl,%ecx
 268:	eb ef                	jmp    259 <strcmp+0x39>
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000270 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 276:	80 39 00             	cmpb   $0x0,(%ecx)
 279:	74 12                	je     28d <strlen+0x1d>
 27b:	31 d2                	xor    %edx,%edx
 27d:	8d 76 00             	lea    0x0(%esi),%esi
 280:	83 c2 01             	add    $0x1,%edx
 283:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 287:	89 d0                	mov    %edx,%eax
 289:	75 f5                	jne    280 <strlen+0x10>
    ;
  return n;
}
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 28d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret    
 291:	eb 0d                	jmp    2a0 <memset>
 293:	90                   	nop
 294:	90                   	nop
 295:	90                   	nop
 296:	90                   	nop
 297:	90                   	nop
 298:	90                   	nop
 299:	90                   	nop
 29a:	90                   	nop
 29b:	90                   	nop
 29c:	90                   	nop
 29d:	90                   	nop
 29e:	90                   	nop
 29f:	90                   	nop

000002a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	8b 55 08             	mov    0x8(%ebp),%edx
 2a6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	89 d7                	mov    %edx,%edi
 2af:	fc                   	cld    
 2b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2b2:	89 d0                	mov    %edx,%eax
 2b4:	5f                   	pop    %edi
 2b5:	5d                   	pop    %ebp
 2b6:	c3                   	ret    
 2b7:	89 f6                	mov    %esi,%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002c0 <strchr>:

char*
strchr(const char *s, char c)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	53                   	push   %ebx
 2c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 2ca:	0f b6 18             	movzbl (%eax),%ebx
 2cd:	84 db                	test   %bl,%bl
 2cf:	74 1d                	je     2ee <strchr+0x2e>
    if(*s == c)
 2d1:	38 d3                	cmp    %dl,%bl
 2d3:	89 d1                	mov    %edx,%ecx
 2d5:	75 0d                	jne    2e4 <strchr+0x24>
 2d7:	eb 17                	jmp    2f0 <strchr+0x30>
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2e0:	38 ca                	cmp    %cl,%dl
 2e2:	74 0c                	je     2f0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e4:	83 c0 01             	add    $0x1,%eax
 2e7:	0f b6 10             	movzbl (%eax),%edx
 2ea:	84 d2                	test   %dl,%dl
 2ec:	75 f2                	jne    2e0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 2ee:	31 c0                	xor    %eax,%eax
}
 2f0:	5b                   	pop    %ebx
 2f1:	5d                   	pop    %ebp
 2f2:	c3                   	ret    
 2f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000300 <gets>:

char*
gets(char *buf, int max)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 305:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 307:	53                   	push   %ebx
 308:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 30b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 30e:	eb 31                	jmp    341 <gets+0x41>
    cc = read(0, &c, 1);
 310:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 317:	00 
 318:	89 7c 24 04          	mov    %edi,0x4(%esp)
 31c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 323:	e8 02 01 00 00       	call   42a <read>
    if(cc < 1)
 328:	85 c0                	test   %eax,%eax
 32a:	7e 1d                	jle    349 <gets+0x49>
      break;
    buf[i++] = c;
 32c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 330:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 332:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 335:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 337:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 33b:	74 0c                	je     349 <gets+0x49>
 33d:	3c 0a                	cmp    $0xa,%al
 33f:	74 08                	je     349 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 341:	8d 5e 01             	lea    0x1(%esi),%ebx
 344:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 347:	7c c7                	jl     310 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 350:	83 c4 2c             	add    $0x2c,%esp
 353:	5b                   	pop    %ebx
 354:	5e                   	pop    %esi
 355:	5f                   	pop    %edi
 356:	5d                   	pop    %ebp
 357:	c3                   	ret    
 358:	90                   	nop
 359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000360 <stat>:

int
stat(char *n, struct stat *st)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	56                   	push   %esi
 364:	53                   	push   %ebx
 365:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 368:	8b 45 08             	mov    0x8(%ebp),%eax
 36b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 372:	00 
 373:	89 04 24             	mov    %eax,(%esp)
 376:	e8 d7 00 00 00       	call   452 <open>
  if(fd < 0)
 37b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 37d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 37f:	78 27                	js     3a8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	89 1c 24             	mov    %ebx,(%esp)
 387:	89 44 24 04          	mov    %eax,0x4(%esp)
 38b:	e8 da 00 00 00       	call   46a <fstat>
  close(fd);
 390:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 393:	89 c6                	mov    %eax,%esi
  close(fd);
 395:	e8 a0 00 00 00       	call   43a <close>
  return r;
 39a:	89 f0                	mov    %esi,%eax
}
 39c:	83 c4 10             	add    $0x10,%esp
 39f:	5b                   	pop    %ebx
 3a0:	5e                   	pop    %esi
 3a1:	5d                   	pop    %ebp
 3a2:	c3                   	ret    
 3a3:	90                   	nop
 3a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 3a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ad:	eb ed                	jmp    39c <stat+0x3c>
 3af:	90                   	nop

000003b0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3b6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b7:	0f be 11             	movsbl (%ecx),%edx
 3ba:	8d 42 d0             	lea    -0x30(%edx),%eax
 3bd:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 3bf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 3c4:	77 17                	ja     3dd <atoi+0x2d>
 3c6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 3c8:	83 c1 01             	add    $0x1,%ecx
 3cb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3ce:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d2:	0f be 11             	movsbl (%ecx),%edx
 3d5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3d8:	80 fb 09             	cmp    $0x9,%bl
 3db:	76 eb                	jbe    3c8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 3dd:	5b                   	pop    %ebx
 3de:	5d                   	pop    %ebp
 3df:	c3                   	ret    

000003e0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3e0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3e1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 3e3:	89 e5                	mov    %esp,%ebp
 3e5:	56                   	push   %esi
 3e6:	8b 45 08             	mov    0x8(%ebp),%eax
 3e9:	53                   	push   %ebx
 3ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ed:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3f0:	85 db                	test   %ebx,%ebx
 3f2:	7e 12                	jle    406 <memmove+0x26>
 3f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 3f8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3ff:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 402:	39 da                	cmp    %ebx,%edx
 404:	75 f2                	jne    3f8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 406:	5b                   	pop    %ebx
 407:	5e                   	pop    %esi
 408:	5d                   	pop    %ebp
 409:	c3                   	ret    

0000040a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40a:	b8 01 00 00 00       	mov    $0x1,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <exit>:
SYSCALL(exit)
 412:	b8 02 00 00 00       	mov    $0x2,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <wait>:
SYSCALL(wait)
 41a:	b8 03 00 00 00       	mov    $0x3,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <pipe>:
SYSCALL(pipe)
 422:	b8 04 00 00 00       	mov    $0x4,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <read>:
SYSCALL(read)
 42a:	b8 05 00 00 00       	mov    $0x5,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <write>:
SYSCALL(write)
 432:	b8 10 00 00 00       	mov    $0x10,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <close>:
SYSCALL(close)
 43a:	b8 15 00 00 00       	mov    $0x15,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <kill>:
SYSCALL(kill)
 442:	b8 06 00 00 00       	mov    $0x6,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <exec>:
SYSCALL(exec)
 44a:	b8 07 00 00 00       	mov    $0x7,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <open>:
SYSCALL(open)
 452:	b8 0f 00 00 00       	mov    $0xf,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <mknod>:
SYSCALL(mknod)
 45a:	b8 11 00 00 00       	mov    $0x11,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <unlink>:
SYSCALL(unlink)
 462:	b8 12 00 00 00       	mov    $0x12,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <fstat>:
SYSCALL(fstat)
 46a:	b8 08 00 00 00       	mov    $0x8,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <link>:
SYSCALL(link)
 472:	b8 13 00 00 00       	mov    $0x13,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <mkdir>:
SYSCALL(mkdir)
 47a:	b8 14 00 00 00       	mov    $0x14,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <chdir>:
SYSCALL(chdir)
 482:	b8 09 00 00 00       	mov    $0x9,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <dup>:
SYSCALL(dup)
 48a:	b8 0a 00 00 00       	mov    $0xa,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <getpid>:
SYSCALL(getpid)
 492:	b8 0b 00 00 00       	mov    $0xb,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <sbrk>:
SYSCALL(sbrk)
 49a:	b8 0c 00 00 00       	mov    $0xc,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <sleep>:
SYSCALL(sleep)
 4a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <uptime>:
SYSCALL(uptime)
 4aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <cps>:
SYSCALL(cps)
 4b2:	b8 16 00 00 00       	mov    $0x16,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <chpr>:
SYSCALL(chpr)
 4ba:	b8 17 00 00 00       	mov    $0x17,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <settickets>:
SYSCALL(settickets)
 4c2:	b8 18 00 00 00       	mov    $0x18,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <chr>:
SYSCALL(chr)
 4ca:	b8 19 00 00 00       	mov    $0x19,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    
 4d2:	66 90                	xchg   %ax,%ax
 4d4:	66 90                	xchg   %ax,%ax
 4d6:	66 90                	xchg   %ax,%ax
 4d8:	66 90                	xchg   %ax,%ax
 4da:	66 90                	xchg   %ax,%ax
 4dc:	66 90                	xchg   %ax,%ax
 4de:	66 90                	xchg   %ax,%ax

000004e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	89 c6                	mov    %eax,%esi
 4e7:	53                   	push   %ebx
 4e8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4ee:	85 db                	test   %ebx,%ebx
 4f0:	74 09                	je     4fb <printint+0x1b>
 4f2:	89 d0                	mov    %edx,%eax
 4f4:	c1 e8 1f             	shr    $0x1f,%eax
 4f7:	84 c0                	test   %al,%al
 4f9:	75 75                	jne    570 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4fb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4fd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 504:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 507:	31 ff                	xor    %edi,%edi
 509:	89 ce                	mov    %ecx,%esi
 50b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 50e:	eb 02                	jmp    512 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 510:	89 cf                	mov    %ecx,%edi
 512:	31 d2                	xor    %edx,%edx
 514:	f7 f6                	div    %esi
 516:	8d 4f 01             	lea    0x1(%edi),%ecx
 519:	0f b6 92 d5 09 00 00 	movzbl 0x9d5(%edx),%edx
  }while((x /= base) != 0);
 520:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 522:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 525:	75 e9                	jne    510 <printint+0x30>
  if(neg)
 527:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 52a:	89 c8                	mov    %ecx,%eax
 52c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 52f:	85 d2                	test   %edx,%edx
 531:	74 08                	je     53b <printint+0x5b>
    buf[i++] = '-';
 533:	8d 4f 02             	lea    0x2(%edi),%ecx
 536:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 53b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 53e:	66 90                	xchg   %ax,%ax
 540:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 545:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 548:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 54f:	00 
 550:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 554:	89 34 24             	mov    %esi,(%esp)
 557:	88 45 d7             	mov    %al,-0x29(%ebp)
 55a:	e8 d3 fe ff ff       	call   432 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 55f:	83 ff ff             	cmp    $0xffffffff,%edi
 562:	75 dc                	jne    540 <printint+0x60>
    putc(fd, buf[i]);
}
 564:	83 c4 4c             	add    $0x4c,%esp
 567:	5b                   	pop    %ebx
 568:	5e                   	pop    %esi
 569:	5f                   	pop    %edi
 56a:	5d                   	pop    %ebp
 56b:	c3                   	ret    
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 570:	89 d0                	mov    %edx,%eax
 572:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 574:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 57b:	eb 87                	jmp    504 <printint+0x24>
 57d:	8d 76 00             	lea    0x0(%esi),%esi

00000580 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 584:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 586:	56                   	push   %esi
 587:	53                   	push   %ebx
 588:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 58b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 58e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 591:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 594:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 597:	0f b6 13             	movzbl (%ebx),%edx
 59a:	83 c3 01             	add    $0x1,%ebx
 59d:	84 d2                	test   %dl,%dl
 59f:	75 39                	jne    5da <printf+0x5a>
 5a1:	e9 c2 00 00 00       	jmp    668 <printf+0xe8>
 5a6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5a8:	83 fa 25             	cmp    $0x25,%edx
 5ab:	0f 84 bf 00 00 00    	je     670 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5bb:	00 
 5bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5c3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5c6:	e8 67 fe ff ff       	call   432 <write>
 5cb:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ce:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 5d2:	84 d2                	test   %dl,%dl
 5d4:	0f 84 8e 00 00 00    	je     668 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 5da:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 5dc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 5df:	74 c7                	je     5a8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5e1:	83 ff 25             	cmp    $0x25,%edi
 5e4:	75 e5                	jne    5cb <printf+0x4b>
      if(c == 'd'){
 5e6:	83 fa 64             	cmp    $0x64,%edx
 5e9:	0f 84 31 01 00 00    	je     720 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5ef:	25 f7 00 00 00       	and    $0xf7,%eax
 5f4:	83 f8 70             	cmp    $0x70,%eax
 5f7:	0f 84 83 00 00 00    	je     680 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5fd:	83 fa 73             	cmp    $0x73,%edx
 600:	0f 84 a2 00 00 00    	je     6a8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 606:	83 fa 63             	cmp    $0x63,%edx
 609:	0f 84 35 01 00 00    	je     744 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 60f:	83 fa 25             	cmp    $0x25,%edx
 612:	0f 84 e0 00 00 00    	je     6f8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 618:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 61b:	83 c3 01             	add    $0x1,%ebx
 61e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 625:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 626:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 628:	89 44 24 04          	mov    %eax,0x4(%esp)
 62c:	89 34 24             	mov    %esi,(%esp)
 62f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 632:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 636:	e8 f7 fd ff ff       	call   432 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 63b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 63e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 641:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 648:	00 
 649:	89 44 24 04          	mov    %eax,0x4(%esp)
 64d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 650:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 653:	e8 da fd ff ff       	call   432 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 658:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 65c:	84 d2                	test   %dl,%dl
 65e:	0f 85 76 ff ff ff    	jne    5da <printf+0x5a>
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 668:	83 c4 3c             	add    $0x3c,%esp
 66b:	5b                   	pop    %ebx
 66c:	5e                   	pop    %esi
 66d:	5f                   	pop    %edi
 66e:	5d                   	pop    %ebp
 66f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 670:	bf 25 00 00 00       	mov    $0x25,%edi
 675:	e9 51 ff ff ff       	jmp    5cb <printf+0x4b>
 67a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 680:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 683:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 688:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 68a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 691:	8b 10                	mov    (%eax),%edx
 693:	89 f0                	mov    %esi,%eax
 695:	e8 46 fe ff ff       	call   4e0 <printint>
        ap++;
 69a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 69e:	e9 28 ff ff ff       	jmp    5cb <printf+0x4b>
 6a3:	90                   	nop
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 6a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 6ab:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 6af:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 6b1:	b8 ce 09 00 00       	mov    $0x9ce,%eax
 6b6:	85 ff                	test   %edi,%edi
 6b8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 6bb:	0f b6 07             	movzbl (%edi),%eax
 6be:	84 c0                	test   %al,%al
 6c0:	74 2a                	je     6ec <printf+0x16c>
 6c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6c8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6cb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 6ce:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6d8:	00 
 6d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6dd:	89 34 24             	mov    %esi,(%esp)
 6e0:	e8 4d fd ff ff       	call   432 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6e5:	0f b6 07             	movzbl (%edi),%eax
 6e8:	84 c0                	test   %al,%al
 6ea:	75 dc                	jne    6c8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ec:	31 ff                	xor    %edi,%edi
 6ee:	e9 d8 fe ff ff       	jmp    5cb <printf+0x4b>
 6f3:	90                   	nop
 6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6f8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6fb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 704:	00 
 705:	89 44 24 04          	mov    %eax,0x4(%esp)
 709:	89 34 24             	mov    %esi,(%esp)
 70c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 710:	e8 1d fd ff ff       	call   432 <write>
 715:	e9 b1 fe ff ff       	jmp    5cb <printf+0x4b>
 71a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 723:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 728:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 72b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 732:	8b 10                	mov    (%eax),%edx
 734:	89 f0                	mov    %esi,%eax
 736:	e8 a5 fd ff ff       	call   4e0 <printint>
        ap++;
 73b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 73f:	e9 87 fe ff ff       	jmp    5cb <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 744:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 747:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 749:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 74b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 752:	00 
 753:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 756:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 759:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 75c:	89 44 24 04          	mov    %eax,0x4(%esp)
 760:	e8 cd fc ff ff       	call   432 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 765:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 769:	e9 5d fe ff ff       	jmp    5cb <printf+0x4b>
 76e:	66 90                	xchg   %ax,%ax

00000770 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 770:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 771:	a1 c8 0c 00 00       	mov    0xcc8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 776:	89 e5                	mov    %esp,%ebp
 778:	57                   	push   %edi
 779:	56                   	push   %esi
 77a:	53                   	push   %ebx
 77b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 780:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 783:	39 d0                	cmp    %edx,%eax
 785:	72 11                	jb     798 <free+0x28>
 787:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 788:	39 c8                	cmp    %ecx,%eax
 78a:	72 04                	jb     790 <free+0x20>
 78c:	39 ca                	cmp    %ecx,%edx
 78e:	72 10                	jb     7a0 <free+0x30>
 790:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 792:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 796:	73 f0                	jae    788 <free+0x18>
 798:	39 ca                	cmp    %ecx,%edx
 79a:	72 04                	jb     7a0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79c:	39 c8                	cmp    %ecx,%eax
 79e:	72 f0                	jb     790 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7a3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 7a6:	39 cf                	cmp    %ecx,%edi
 7a8:	74 1e                	je     7c8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7aa:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ad:	8b 48 04             	mov    0x4(%eax),%ecx
 7b0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 7b3:	39 f2                	cmp    %esi,%edx
 7b5:	74 28                	je     7df <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7b7:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b9:	a3 c8 0c 00 00       	mov    %eax,0xcc8
}
 7be:	5b                   	pop    %ebx
 7bf:	5e                   	pop    %esi
 7c0:	5f                   	pop    %edi
 7c1:	5d                   	pop    %ebp
 7c2:	c3                   	ret    
 7c3:	90                   	nop
 7c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c8:	03 71 04             	add    0x4(%ecx),%esi
 7cb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	8b 08                	mov    (%eax),%ecx
 7d0:	8b 09                	mov    (%ecx),%ecx
 7d2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7d5:	8b 48 04             	mov    0x4(%eax),%ecx
 7d8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 7db:	39 f2                	cmp    %esi,%edx
 7dd:	75 d8                	jne    7b7 <free+0x47>
    p->s.size += bp->s.size;
 7df:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 7e2:	a3 c8 0c 00 00       	mov    %eax,0xcc8
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7e7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ea:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7ed:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7ef:	5b                   	pop    %ebx
 7f0:	5e                   	pop    %esi
 7f1:	5f                   	pop    %edi
 7f2:	5d                   	pop    %ebp
 7f3:	c3                   	ret    
 7f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000800 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	57                   	push   %edi
 804:	56                   	push   %esi
 805:	53                   	push   %ebx
 806:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 809:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 80c:	8b 1d c8 0c 00 00    	mov    0xcc8,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 812:	8d 48 07             	lea    0x7(%eax),%ecx
 815:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 818:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 81d:	0f 84 9b 00 00 00    	je     8be <malloc+0xbe>
 823:	8b 13                	mov    (%ebx),%edx
 825:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 828:	39 fe                	cmp    %edi,%esi
 82a:	76 64                	jbe    890 <malloc+0x90>
 82c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 833:	bb 00 80 00 00       	mov    $0x8000,%ebx
 838:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 83b:	eb 0e                	jmp    84b <malloc+0x4b>
 83d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 842:	8b 78 04             	mov    0x4(%eax),%edi
 845:	39 fe                	cmp    %edi,%esi
 847:	76 4f                	jbe    898 <malloc+0x98>
 849:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 84b:	3b 15 c8 0c 00 00    	cmp    0xcc8,%edx
 851:	75 ed                	jne    840 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 856:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 85c:	bf 00 10 00 00       	mov    $0x1000,%edi
 861:	0f 43 fe             	cmovae %esi,%edi
 864:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 867:	89 04 24             	mov    %eax,(%esp)
 86a:	e8 2b fc ff ff       	call   49a <sbrk>
  if(p == (char*)-1)
 86f:	83 f8 ff             	cmp    $0xffffffff,%eax
 872:	74 18                	je     88c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 874:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 877:	83 c0 08             	add    $0x8,%eax
 87a:	89 04 24             	mov    %eax,(%esp)
 87d:	e8 ee fe ff ff       	call   770 <free>
  return freep;
 882:	8b 15 c8 0c 00 00    	mov    0xcc8,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 888:	85 d2                	test   %edx,%edx
 88a:	75 b4                	jne    840 <malloc+0x40>
        return 0;
 88c:	31 c0                	xor    %eax,%eax
 88e:	eb 20                	jmp    8b0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 890:	89 d0                	mov    %edx,%eax
 892:	89 da                	mov    %ebx,%edx
 894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 898:	39 fe                	cmp    %edi,%esi
 89a:	74 1c                	je     8b8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 89c:	29 f7                	sub    %esi,%edi
 89e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 8a1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 8a4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 8a7:	89 15 c8 0c 00 00    	mov    %edx,0xcc8
      return (void*)(p + 1);
 8ad:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b0:	83 c4 1c             	add    $0x1c,%esp
 8b3:	5b                   	pop    %ebx
 8b4:	5e                   	pop    %esi
 8b5:	5f                   	pop    %edi
 8b6:	5d                   	pop    %ebp
 8b7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 8b8:	8b 08                	mov    (%eax),%ecx
 8ba:	89 0a                	mov    %ecx,(%edx)
 8bc:	eb e9                	jmp    8a7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 8be:	c7 05 c8 0c 00 00 cc 	movl   $0xccc,0xcc8
 8c5:	0c 00 00 
    base.s.size = 0;
 8c8:	ba cc 0c 00 00       	mov    $0xccc,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 8cd:	c7 05 cc 0c 00 00 cc 	movl   $0xccc,0xccc
 8d4:	0c 00 00 
    base.s.size = 0;
 8d7:	c7 05 d0 0c 00 00 00 	movl   $0x0,0xcd0
 8de:	00 00 00 
 8e1:	e9 46 ff ff ff       	jmp    82c <malloc+0x2c>
