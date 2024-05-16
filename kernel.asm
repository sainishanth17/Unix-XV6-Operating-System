
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 2e 10 80       	mov    $0x80102e60,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 c0 70 10 	movl   $0x801070c0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010005b:	e8 00 44 00 00       	call   80104460 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 c7 70 10 	movl   $0x801070c7,0x4(%esp)
8010009b:	80 
8010009c:	e8 af 42 00 00       	call   80104350 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 f5 43 00 00       	call   801044e0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000f1:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100161:	e8 aa 44 00 00       	call   80104610 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 1f 42 00 00       	call   80104390 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 a2 1f 00 00       	call   80102120 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 ce 70 10 80 	movl   $0x801070ce,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 7b 42 00 00       	call   80104430 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 df 70 10 80 	movl   $0x801070df,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 3a 42 00 00       	call   80104430 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 ee 41 00 00       	call   801043f0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100209:	e8 d2 42 00 00       	call   801044e0 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 bb 43 00 00       	jmp    80104610 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 e6 70 10 80 	movl   $0x801070e6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 09 15 00 00       	call   80101790 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 4d 42 00 00       	call   801044e0 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 26                	jmp    801002c9 <consoleread+0x59>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(proc->killed){
801002a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002ae:	8b 40 24             	mov    0x24(%eax),%eax
801002b1:	85 c0                	test   %eax,%eax
801002b3:	75 73                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b5:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bc:	80 
801002bd:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
801002c4:	e8 77 3b 00 00       	call   80103e40 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c9:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002ce:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d4:	74 d2                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d6:	8d 50 01             	lea    0x1(%eax),%edx
801002d9:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
801002df:	89 c2                	mov    %eax,%edx
801002e1:	83 e2 7f             	and    $0x7f,%edx
801002e4:	0f b6 8a 40 ff 10 80 	movzbl -0x7fef00c0(%edx),%ecx
801002eb:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ee:	83 fa 04             	cmp    $0x4,%edx
801002f1:	74 56                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f3:	83 c6 01             	add    $0x1,%esi
    --n;
801002f6:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f9:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fc:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002ff:	74 52                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100301:	85 db                	test   %ebx,%ebx
80100303:	75 c4                	jne    801002c9 <consoleread+0x59>
80100305:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100308:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100312:	e8 f9 42 00 00       	call   80104610 <release>
  ilock(ip);
80100317:	89 3c 24             	mov    %edi,(%esp)
8010031a:	e8 a1 13 00 00       	call   801016c0 <ilock>
8010031f:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100322:	eb 1d                	jmp    80100341 <consoleread+0xd1>
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 dc 42 00 00       	call   80104610 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 84 13 00 00       	call   801016c0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ae                	jmp    80100308 <consoleread+0x98>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb aa                	jmp    80100308 <consoleread+0x98>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100369:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
8010036f:	8d 5d d0             	lea    -0x30(%ebp),%ebx
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100372:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100379:	00 00 00 
8010037c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010037f:	0f b6 00             	movzbl (%eax),%eax
80100382:	c7 04 24 ed 70 10 80 	movl   $0x801070ed,(%esp)
80100389:	89 44 24 04          	mov    %eax,0x4(%esp)
8010038d:	e8 be 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
80100392:	8b 45 08             	mov    0x8(%ebp),%eax
80100395:	89 04 24             	mov    %eax,(%esp)
80100398:	e8 b3 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
8010039d:	c7 04 24 e6 75 10 80 	movl   $0x801075e6,(%esp)
801003a4:	e8 a7 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a9:	8d 45 08             	lea    0x8(%ebp),%eax
801003ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003b0:	89 04 24             	mov    %eax,(%esp)
801003b3:	e8 c8 40 00 00       	call   80104480 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 09 71 10 80 	movl   $0x80107109,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 02 58 00 00       	call   80105c10 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 52 57 00 00       	call   80105c10 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 46 57 00 00       	call   80105c10 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 3a 57 00 00       	call   80105c10 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 ff 41 00 00       	call   80104700 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 42 41 00 00       	call   80104660 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 0d 71 10 80 	movl   $0x8010710d,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 38 71 10 80 	movzbl -0x7fef8ec8(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 89 11 00 00       	call   80101790 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 cd 3e 00 00       	call   801044e0 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 d5 3f 00 00       	call   80104610 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 7a 10 00 00       	call   801016c0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 18 3f 00 00       	call   80104610 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 20 71 10 80       	mov    $0x80107120,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 44 3d 00 00       	call   801044e0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 27 71 10 80 	movl   $0x80107127,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 16 3d 00 00       	call   801044e0 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801007f7:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 e4 3d 00 00       	call   80104610 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d c0 ff 10 80    	mov    0x8010ffc0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801008b2:	e8 39 37 00 00       	call   80103ff0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008c5:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008ec:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 b4 37 00 00       	jmp    801040e0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 30 71 10 	movl   $0x80107130,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 f6 3a 00 00       	call   80104460 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
8010096a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100971:	c7 05 8c 09 11 80 f0 	movl   $0x801005f0,0x8011098c
80100978:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010097b:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
80100982:	02 10 80 
  cons.locking = 1;
80100985:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
8010098c:	00 00 00 

  picenable(IRQ_KBD);
8010098f:	e8 6c 28 00 00       	call   80103200 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100994:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010099b:	00 
8010099c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801009a3:	e8 08 19 00 00       	call   801022b0 <ioapicenable>
}
801009a8:	c9                   	leave  
801009a9:	c3                   	ret    
801009aa:	66 90                	xchg   %ax,%ax
801009ac:	66 90                	xchg   %ax,%ax
801009ae:	66 90                	xchg   %ax,%ax

801009b0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009b0:	55                   	push   %ebp
801009b1:	89 e5                	mov    %esp,%ebp
801009b3:	57                   	push   %edi
801009b4:	56                   	push   %esi
801009b5:	53                   	push   %ebx
801009b6:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009bc:	e8 cf 21 00 00       	call   80102b90 <begin_op>

  if((ip = namei(path)) == 0){
801009c1:	8b 45 08             	mov    0x8(%ebp),%eax
801009c4:	89 04 24             	mov    %eax,(%esp)
801009c7:	e8 24 15 00 00       	call   80101ef0 <namei>
801009cc:	85 c0                	test   %eax,%eax
801009ce:	89 c3                	mov    %eax,%ebx
801009d0:	74 37                	je     80100a09 <exec+0x59>
    end_op();
    return -1;
  }
  ilock(ip);
801009d2:	89 04 24             	mov    %eax,(%esp)
801009d5:	e8 e6 0c 00 00       	call   801016c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
801009da:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009e0:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e7:	00 
801009e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ef:	00 
801009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f4:	89 1c 24             	mov    %ebx,(%esp)
801009f7:	e8 54 0f 00 00       	call   80101950 <readi>
801009fc:	83 f8 33             	cmp    $0x33,%eax
801009ff:	77 1f                	ja     80100a20 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a01:	89 1c 24             	mov    %ebx,(%esp)
80100a04:	e8 f7 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a09:	e8 f2 21 00 00       	call   80102c00 <end_op>
  }
  return -1;
80100a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a13:	81 c4 1c 01 00 00    	add    $0x11c,%esp
80100a19:	5b                   	pop    %ebx
80100a1a:	5e                   	pop    %esi
80100a1b:	5f                   	pop    %edi
80100a1c:	5d                   	pop    %ebp
80100a1d:	c3                   	ret    
80100a1e:	66 90                	xchg   %ax,%ax
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d5                	jne    80100a01 <exec+0x51>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 5f 60 00 00       	call   80106a90 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a39:	74 c6                	je     80100a01 <exec+0x51>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a49:	0f 84 d3 02 00 00    	je     80100d22 <exec+0x372>

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a4f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a56:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xc5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x183>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 bd 0e 00 00       	call   80101950 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x170>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x170>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x170>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 59 62 00 00       	call   80106d30 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x170>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x170>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 58 61 00 00       	call   80106c70 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xb0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 12 63 00 00       	call   80106e40 <freevm>
80100b2e:	e9 ce fe ff ff       	jmp    80100a01 <exec+0x51>
80100b33:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100b39:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100b3f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80100b45:	8d be 00 20 00 00    	lea    0x2000(%esi),%edi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b4b:	89 1c 24             	mov    %ebx,(%esp)
80100b4e:	e8 ad 0d 00 00       	call   80101900 <iunlockput>
  end_op();
80100b53:	e8 a8 20 00 00       	call   80102c00 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b58:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b5e:	89 7c 24 08          	mov    %edi,0x8(%esp)
80100b62:	89 74 24 04          	mov    %esi,0x4(%esp)
80100b66:	89 04 24             	mov    %eax,(%esp)
80100b69:	e8 c2 61 00 00       	call   80106d30 <allocuvm>
80100b6e:	85 c0                	test   %eax,%eax
80100b70:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b76:	75 18                	jne    80100b90 <exec+0x1e0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b78:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b7e:	89 04 24             	mov    %eax,(%esp)
80100b81:	e8 ba 62 00 00       	call   80106e40 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8b:	e9 83 fe ff ff       	jmp    80100a13 <exec+0x63>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b90:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100b96:	89 d8                	mov    %ebx,%eax
80100b98:	2d 00 20 00 00       	sub    $0x2000,%eax
80100b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ba1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100ba7:	89 04 24             	mov    %eax,(%esp)
80100baa:	e8 11 63 00 00       	call   80106ec0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100baf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb2:	8b 00                	mov    (%eax),%eax
80100bb4:	85 c0                	test   %eax,%eax
80100bb6:	0f 84 72 01 00 00    	je     80100d2e <exec+0x37e>
80100bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bbf:	31 f6                	xor    %esi,%esi
80100bc1:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100bc4:	83 c1 04             	add    $0x4,%ecx
80100bc7:	eb 0f                	jmp    80100bd8 <exec+0x228>
80100bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bd0:	83 c1 04             	add    $0x4,%ecx
    if(argc >= MAXARG)
80100bd3:	83 fe 20             	cmp    $0x20,%esi
80100bd6:	74 a0                	je     80100b78 <exec+0x1c8>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bd8:	89 04 24             	mov    %eax,(%esp)
80100bdb:	89 8d f0 fe ff ff    	mov    %ecx,-0x110(%ebp)
80100be1:	e8 9a 3c 00 00       	call   80104880 <strlen>
80100be6:	f7 d0                	not    %eax
80100be8:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bea:	8b 07                	mov    (%edi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bec:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bef:	89 04 24             	mov    %eax,(%esp)
80100bf2:	e8 89 3c 00 00       	call   80104880 <strlen>
80100bf7:	83 c0 01             	add    $0x1,%eax
80100bfa:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bfe:	8b 07                	mov    (%edi),%eax
80100c00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c04:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c08:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c0e:	89 04 24             	mov    %eax,(%esp)
80100c11:	e8 0a 64 00 00       	call   80107020 <copyout>
80100c16:	85 c0                	test   %eax,%eax
80100c18:	0f 88 5a ff ff ff    	js     80100b78 <exec+0x1c8>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c1e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c24:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c2a:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c31:	83 c6 01             	add    $0x1,%esi
80100c34:	8b 01                	mov    (%ecx),%eax
80100c36:	89 cf                	mov    %ecx,%edi
80100c38:	85 c0                	test   %eax,%eax
80100c3a:	75 94                	jne    80100bd0 <exec+0x220>
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c3c:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c43:	89 d9                	mov    %ebx,%ecx
80100c45:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c47:	83 c0 0c             	add    $0xc,%eax
80100c4a:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c4c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c50:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c56:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c5e:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c65:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c69:	89 04 24             	mov    %eax,(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c6c:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c73:	ff ff ff 
  ustack[1] = argc;
80100c76:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c7c:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c82:	e8 99 63 00 00       	call   80107020 <copyout>
80100c87:	85 c0                	test   %eax,%eax
80100c89:	0f 88 e9 fe ff ff    	js     80100b78 <exec+0x1c8>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c8f:	8b 45 08             	mov    0x8(%ebp),%eax
80100c92:	0f b6 10             	movzbl (%eax),%edx
80100c95:	84 d2                	test   %dl,%dl
80100c97:	74 19                	je     80100cb2 <exec+0x302>
80100c99:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c9c:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100c9f:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ca2:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ca5:	0f 44 c8             	cmove  %eax,%ecx
80100ca8:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cab:	84 d2                	test   %dl,%dl
80100cad:	75 f0                	jne    80100c9f <exec+0x2ef>
80100caf:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cb2:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cbc:	00 
80100cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cc7:	83 c0 6c             	add    $0x6c,%eax
80100cca:	89 04 24             	mov    %eax,(%esp)
80100ccd:	e8 6e 3b 00 00       	call   80104840 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cd2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100cd8:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cde:	8b 70 04             	mov    0x4(%eax),%esi
  proc->pgdir = pgdir;
80100ce1:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
80100ce4:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100cea:	89 08                	mov    %ecx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100cec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cf2:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100cf8:	8b 50 18             	mov    0x18(%eax),%edx
80100cfb:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100cfe:	8b 50 18             	mov    0x18(%eax),%edx
80100d01:	89 5a 44             	mov    %ebx,0x44(%edx)
  proc->priority = 2;
80100d04:	c7 40 7c 02 00 00 00 	movl   $0x2,0x7c(%eax)
  switchuvm(proc);
80100d0b:	89 04 24             	mov    %eax,(%esp)
80100d0e:	e8 3d 5e 00 00       	call   80106b50 <switchuvm>
  freevm(oldpgdir);
80100d13:	89 34 24             	mov    %esi,(%esp)
80100d16:	e8 25 61 00 00       	call   80106e40 <freevm>
  return 0;
80100d1b:	31 c0                	xor    %eax,%eax
80100d1d:	e9 f1 fc ff ff       	jmp    80100a13 <exec+0x63>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d22:	bf 00 20 00 00       	mov    $0x2000,%edi
80100d27:	31 f6                	xor    %esi,%esi
80100d29:	e9 1d fe ff ff       	jmp    80100b4b <exec+0x19b>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d2e:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100d34:	31 f6                	xor    %esi,%esi
80100d36:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d3c:	e9 fb fe ff ff       	jmp    80100c3c <exec+0x28c>
80100d41:	66 90                	xchg   %ax,%ax
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	c7 44 24 04 49 71 10 	movl   $0x80107149,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100d65:	e8 f6 36 00 00       	call   80104460 <initlock>
}
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100d83:	e8 58 37 00 00       	call   801044e0 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100db0:	e8 5b 38 00 00       	call   80104610 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100db5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100db8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100dc7:	e8 44 38 00 00       	call   80104610 <release>
  return 0;
}
80100dcc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100dcf:	31 c0                	xor    %eax,%eax
}
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100df1:	e8 ea 36 00 00       	call   801044e0 <acquire>
  if(f->ref < 1)
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e03:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e0a:	e8 01 38 00 00       	call   80104610 <release>
  return f;
}
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e17:	c7 04 24 50 71 10 80 	movl   $0x80107150,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100e43:	e8 98 36 00 00       	call   801044e0 <acquire>
  if(f->ref < 1)
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
    release(&ftable.lock);
80100e5d:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6b:	e9 a0 37 00 00       	jmp    80104610 <release>
    return;
  }
  ff = *f;
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e85:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e8f:	e8 7c 37 00 00       	call   80104610 <release>

  if(ff.type == FD_PIPE)
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 f8 24 00 00       	call   801033b0 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ec0:	e8 cb 1c 00 00       	call   80102b90 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 00 09 00 00       	call   801017d0 <iput>
    end_op();
  }
}
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ed7:	e9 24 1d 00 00       	jmp    80102c00 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100edc:	c7 04 24 58 71 10 80 	movl   $0x80107158,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 b6 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 04 0a 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 69 08 00 00       	call   80101790 <iunlock>
    return 0;
  }
  return -1;
}
80100f27:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f2a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
    ilock(f->ip);
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 51 07 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 c7 09 00 00       	call   80101950 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 f3 07 00 00       	call   80101790 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb5:	e9 a6 25 00 00       	jmp    80103560 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fc7:	c7 04 24 62 71 10 80 	movl   $0x80107162,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 57 07 00 00       	call   80101790 <iunlock>
      end_op();
80101039:	e8 c2 1b 00 00       	call   80102c00 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101049:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101063:	e8 28 1b 00 00       	call   80102b90 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 4d 06 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 be 09 00 00       	call   80101a50 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 ec 06 00 00       	call   80101790 <iunlock>
      end_op();
801010a4:	e8 57 1b 00 00       	call   80102c00 <end_op>

      if(r < 0)
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 5f 23 00 00       	jmp    80103440 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	c7 04 24 6b 71 10 80 	movl   $0x8010716b,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ed:	c7 04 24 71 71 10 80 	movl   $0x80107171,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 2c             	sub    $0x2c,%esp
80101109:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010110c:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101111:	85 c0                	test   %eax,%eax
80101113:	0f 84 8c 00 00 00    	je     801011a5 <balloc+0xa5>
80101119:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101120:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101123:	89 f0                	mov    %esi,%eax
80101125:	c1 f8 0c             	sar    $0xc,%eax
80101128:	03 05 f8 09 11 80    	add    0x801109f8,%eax
8010112e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101132:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101135:	89 04 24             	mov    %eax,(%esp)
80101138:	e8 93 ef ff ff       	call   801000d0 <bread>
8010113d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101140:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101145:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101148:	31 c0                	xor    %eax,%eax
8010114a:	eb 33                	jmp    8010117f <balloc+0x7f>
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101150:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101153:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101155:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	bf 01 00 00 00       	mov    $0x1,%edi
80101162:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101164:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101169:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116b:	0f b6 fb             	movzbl %bl,%edi
8010116e:	85 cf                	test   %ecx,%edi
80101170:	74 46                	je     801011b8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101172:	83 c0 01             	add    $0x1,%eax
80101175:	83 c6 01             	add    $0x1,%esi
80101178:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010117d:	74 05                	je     80101184 <balloc+0x84>
8010117f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101182:	72 cc                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101187:	89 04 24             	mov    %eax,(%esp)
8010118a:	e8 51 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101196:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101199:	3b 05 e0 09 11 80    	cmp    0x801109e0,%eax
8010119f:	0f 82 7b ff ff ff    	jb     80101120 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011a5:	c7 04 24 7b 71 10 80 	movl   $0x8010717b,(%esp)
801011ac:	e8 af f1 ff ff       	call   80100360 <panic>
801011b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	09 d9                	or     %ebx,%ecx
801011ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011bd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011c1:	89 1c 24             	mov    %ebx,(%esp)
801011c4:	e8 67 1b 00 00       	call   80102d30 <log_write>
        brelse(bp);
801011c9:	89 1c 24             	mov    %ebx,(%esp)
801011cc:	e8 0f f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011d4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011d8:	89 04 24             	mov    %eax,(%esp)
801011db:	e8 f0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011e0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011e7:	00 
801011e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011ef:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011f5:	89 04 24             	mov    %eax,(%esp)
801011f8:	e8 63 34 00 00       	call   80104660 <memset>
  log_write(bp);
801011fd:	89 1c 24             	mov    %ebx,(%esp)
80101200:	e8 2b 1b 00 00       	call   80102d30 <log_write>
  brelse(bp);
80101205:	89 1c 24             	mov    %ebx,(%esp)
80101208:	e8 d3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010120d:	83 c4 2c             	add    $0x2c,%esp
80101210:	89 f0                	mov    %esi,%eax
80101212:	5b                   	pop    %ebx
80101213:	5e                   	pop    %esi
80101214:	5f                   	pop    %edi
80101215:	5d                   	pop    %ebp
80101216:	c3                   	ret    
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	89 c7                	mov    %eax,%edi
80101226:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101227:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101229:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010122f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101232:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101239:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010123c:	e8 9f 32 00 00       	call   801044e0 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101241:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101244:	eb 14                	jmp    8010125a <iget+0x3a>
80101246:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101248:	85 f6                	test   %esi,%esi
8010124a:	74 3c                	je     80101288 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101252:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101258:	74 46                	je     801012a0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010125d:	85 c9                	test   %ecx,%ecx
8010125f:	7e e7                	jle    80101248 <iget+0x28>
80101261:	39 3b                	cmp    %edi,(%ebx)
80101263:	75 e3                	jne    80101248 <iget+0x28>
80101265:	39 53 04             	cmp    %edx,0x4(%ebx)
80101268:	75 de                	jne    80101248 <iget+0x28>
      ip->ref++;
8010126a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010126d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010126f:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101276:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101279:	e8 92 33 00 00       	call   80104610 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010127e:	83 c4 1c             	add    $0x1c,%esp
80101281:	89 f0                	mov    %esi,%eax
80101283:	5b                   	pop    %ebx
80101284:	5e                   	pop    %esi
80101285:	5f                   	pop    %edi
80101286:	5d                   	pop    %ebp
80101287:	c3                   	ret    
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101299:	75 bf                	jne    8010125a <iget+0x3a>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 29                	je     801012cd <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012a4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012a9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801012b0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012b7:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801012be:	e8 4d 33 00 00       	call   80104610 <release>

  return ip;
}
801012c3:	83 c4 1c             	add    $0x1c,%esp
801012c6:	89 f0                	mov    %esi,%eax
801012c8:	5b                   	pop    %ebx
801012c9:	5e                   	pop    %esi
801012ca:	5f                   	pop    %edi
801012cb:	5d                   	pop    %ebp
801012cc:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012cd:	c7 04 24 91 71 10 80 	movl   $0x80107191,(%esp)
801012d4:	e8 87 f0 ff ff       	call   80100360 <panic>
801012d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c3                	mov    %eax,%ebx
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 66                	je     80101360 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	83 c4 1c             	add    $0x1c,%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101308:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
8010130b:	83 fe 7f             	cmp    $0x7f,%esi
8010130e:	77 77                	ja     80101387 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101310:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101316:	85 c0                	test   %eax,%eax
80101318:	74 5e                	je     80101378 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010131e:	8b 03                	mov    (%ebx),%eax
80101320:	89 04 24             	mov    %eax,(%esp)
80101323:	e8 a8 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101328:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010132c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010132e:	8b 32                	mov    (%edx),%esi
80101330:	85 f6                	test   %esi,%esi
80101332:	75 19                	jne    8010134d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101334:	8b 03                	mov    (%ebx),%eax
80101336:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101339:	e8 c2 fd ff ff       	call   80101100 <balloc>
8010133e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101341:	89 02                	mov    %eax,(%edx)
80101343:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101345:	89 3c 24             	mov    %edi,(%esp)
80101348:	e8 e3 19 00 00       	call   80102d30 <log_write>
    }
    brelse(bp);
8010134d:	89 3c 24             	mov    %edi,(%esp)
80101350:	e8 8b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101355:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101358:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	5b                   	pop    %ebx
8010135b:	5e                   	pop    %esi
8010135c:	5f                   	pop    %edi
8010135d:	5d                   	pop    %ebp
8010135e:	c3                   	ret    
8010135f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101360:	8b 03                	mov    (%ebx),%eax
80101362:	e8 99 fd ff ff       	call   80101100 <balloc>
80101367:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010136a:	83 c4 1c             	add    $0x1c,%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101378:	8b 03                	mov    (%ebx),%eax
8010137a:	e8 81 fd ff ff       	call   80101100 <balloc>
8010137f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101385:	eb 93                	jmp    8010131a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101387:	c7 04 24 a1 71 10 80 	movl   $0x801071a1,(%esp)
8010138e:	e8 cd ef ff ff       	call   80100360 <panic>
80101393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	56                   	push   %esi
801013a4:	53                   	push   %ebx
801013a5:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013a8:	8b 45 08             	mov    0x8(%ebp),%eax
801013ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013b2:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013b6:	89 04 24             	mov    %eax,(%esp)
801013b9:	e8 12 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013be:	89 34 24             	mov    %esi,(%esp)
801013c1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013c8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013c9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013cb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801013d2:	e8 29 33 00 00       	call   80104700 <memmove>
  brelse(bp);
801013d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013da:	83 c4 10             	add    $0x10,%esp
801013dd:	5b                   	pop    %ebx
801013de:	5e                   	pop    %esi
801013df:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013e0:	e9 fb ed ff ff       	jmp    801001e0 <brelse>
801013e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	89 d7                	mov    %edx,%edi
801013f6:	56                   	push   %esi
801013f7:	53                   	push   %ebx
801013f8:	89 c3                	mov    %eax,%ebx
801013fa:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013fd:	89 04 24             	mov    %eax,(%esp)
80101400:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
80101407:	80 
80101408:	e8 93 ff ff ff       	call   801013a0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010140d:	89 fa                	mov    %edi,%edx
8010140f:	c1 ea 0c             	shr    $0xc,%edx
80101412:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101418:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010141b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101420:	89 54 24 04          	mov    %edx,0x4(%esp)
80101424:	e8 a7 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101429:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010142b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101431:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101433:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101436:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101439:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010143b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010143d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101442:	0f b6 c8             	movzbl %al,%ecx
80101445:	85 d9                	test   %ebx,%ecx
80101447:	74 20                	je     80101469 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101449:	f7 d3                	not    %ebx
8010144b:	21 c3                	and    %eax,%ebx
8010144d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 d7 18 00 00       	call   80102d30 <log_write>
  brelse(bp);
80101459:	89 34 24             	mov    %esi,(%esp)
8010145c:	e8 7f ed ff ff       	call   801001e0 <brelse>
}
80101461:	83 c4 1c             	add    $0x1c,%esp
80101464:	5b                   	pop    %ebx
80101465:	5e                   	pop    %esi
80101466:	5f                   	pop    %edi
80101467:	5d                   	pop    %ebp
80101468:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101469:	c7 04 24 b4 71 10 80 	movl   $0x801071b4,(%esp)
80101470:	e8 eb ee ff ff       	call   80100360 <panic>
80101475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101489:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010148c:	c7 44 24 04 c7 71 10 	movl   $0x801071c7,0x4(%esp)
80101493:	80 
80101494:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010149b:	e8 c0 2f 00 00       	call   80104460 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	89 1c 24             	mov    %ebx,(%esp)
801014a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a9:	c7 44 24 04 ce 71 10 	movl   $0x801071ce,0x4(%esp)
801014b0:	80 
801014b1:	e8 9a 2e 00 00       	call   80104350 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014b6:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014bc:	75 e2                	jne    801014a0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
801014be:	8b 45 08             	mov    0x8(%ebp),%eax
801014c1:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
801014c8:	80 
801014c9:	89 04 24             	mov    %eax,(%esp)
801014cc:	e8 cf fe ff ff       	call   801013a0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014d1:	a1 f8 09 11 80       	mov    0x801109f8,%eax
801014d6:	c7 04 24 24 72 10 80 	movl   $0x80107224,(%esp)
801014dd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014e1:	a1 f4 09 11 80       	mov    0x801109f4,%eax
801014e6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ea:	a1 f0 09 11 80       	mov    0x801109f0,%eax
801014ef:	89 44 24 14          	mov    %eax,0x14(%esp)
801014f3:	a1 ec 09 11 80       	mov    0x801109ec,%eax
801014f8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014fc:	a1 e8 09 11 80       	mov    0x801109e8,%eax
80101501:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101505:	a1 e4 09 11 80       	mov    0x801109e4,%eax
8010150a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010150e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101513:	89 44 24 04          	mov    %eax,0x4(%esp)
80101517:	e8 34 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010151c:	83 c4 24             	add    $0x24,%esp
8010151f:	5b                   	pop    %ebx
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
80101522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 2c             	sub    $0x2c,%esp
80101539:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101543:	8b 7d 08             	mov    0x8(%ebp),%edi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	0f 86 a2 00 00 00    	jbe    801015f1 <ialloc+0xc1>
8010154f:	be 01 00 00 00       	mov    $0x1,%esi
80101554:	bb 01 00 00 00       	mov    $0x1,%ebx
80101559:	eb 1a                	jmp    80101575 <ialloc+0x45>
8010155b:	90                   	nop
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101560:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101563:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101566:	e8 75 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010156b:	89 de                	mov    %ebx,%esi
8010156d:	3b 1d e8 09 11 80    	cmp    0x801109e8,%ebx
80101573:	73 7c                	jae    801015f1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101575:	89 f0                	mov    %esi,%eax
80101577:	c1 e8 03             	shr    $0x3,%eax
8010157a:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101580:	89 3c 24             	mov    %edi,(%esp)
80101583:	89 44 24 04          	mov    %eax,0x4(%esp)
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010158e:	89 f0                	mov    %esi,%eax
80101590:	83 e0 07             	and    $0x7,%eax
80101593:	c1 e0 06             	shl    $0x6,%eax
80101596:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010159a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010159e:	75 c0                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a0:	89 0c 24             	mov    %ecx,(%esp)
801015a3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015aa:	00 
801015ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015b2:	00 
801015b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	e8 a2 30 00 00       	call   80104660 <memset>
      dip->type = type;
801015be:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015cb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ce:	89 14 24             	mov    %edx,(%esp)
801015d1:	e8 5a 17 00 00       	call   80102d30 <log_write>
      brelse(bp);
801015d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015d9:	89 14 24             	mov    %edx,(%esp)
801015dc:	e8 ff eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015e4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015e7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e9:	5e                   	pop    %esi
801015ea:	5f                   	pop    %edi
801015eb:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015ec:	e9 2f fc ff ff       	jmp    80101220 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015f1:	c7 04 24 d4 71 10 80 	movl   $0x801071d4,(%esp)
801015f8:	e8 63 ed ff ff       	call   80100360 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	83 ec 10             	sub    $0x10,%esp
80101608:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010161a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010161e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101621:	89 04 24             	mov    %eax,(%esp)
80101624:	e8 a7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101629:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010162c:	83 e2 07             	and    $0x7,%edx
8010162f:	c1 e2 06             	shl    $0x6,%edx
80101632:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101636:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101638:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010163f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101643:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101647:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010164b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010164f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101653:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101657:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010165b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010165e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101661:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101665:	89 14 24             	mov    %edx,(%esp)
80101668:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010166f:	00 
80101670:	e8 8b 30 00 00       	call   80104700 <memmove>
  log_write(bp);
80101675:	89 34 24             	mov    %esi,(%esp)
80101678:	e8 b3 16 00 00       	call   80102d30 <log_write>
  brelse(bp);
8010167d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101680:	83 c4 10             	add    $0x10,%esp
80101683:	5b                   	pop    %ebx
80101684:	5e                   	pop    %esi
80101685:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101686:	e9 55 eb ff ff       	jmp    801001e0 <brelse>
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 14             	sub    $0x14,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801016a1:	e8 3a 2e 00 00       	call   801044e0 <acquire>
  ip->ref++;
801016a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016aa:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801016b1:	e8 5a 2f 00 00       	call   80104610 <release>
  return ip;
}
801016b6:	83 c4 14             	add    $0x14,%esp
801016b9:	89 d8                	mov    %ebx,%eax
801016bb:	5b                   	pop    %ebx
801016bc:	5d                   	pop    %ebp
801016bd:	c3                   	ret    
801016be:	66 90                	xchg   %ax,%ax

801016c0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	83 ec 10             	sub    $0x10,%esp
801016c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016cb:	85 db                	test   %ebx,%ebx
801016cd:	0f 84 b0 00 00 00    	je     80101783 <ilock+0xc3>
801016d3:	8b 43 08             	mov    0x8(%ebx),%eax
801016d6:	85 c0                	test   %eax,%eax
801016d8:	0f 8e a5 00 00 00    	jle    80101783 <ilock+0xc3>
    panic("ilock");

  acquiresleep(&ip->lock);
801016de:	8d 43 0c             	lea    0xc(%ebx),%eax
801016e1:	89 04 24             	mov    %eax,(%esp)
801016e4:	e8 a7 2c 00 00       	call   80104390 <acquiresleep>

  if(!(ip->flags & I_VALID)){
801016e9:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
801016ed:	74 09                	je     801016f8 <ilock+0x38>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016ef:	83 c4 10             	add    $0x10,%esp
801016f2:	5b                   	pop    %ebx
801016f3:	5e                   	pop    %esi
801016f4:	5d                   	pop    %ebp
801016f5:	c3                   	ret    
801016f6:	66 90                	xchg   %ax,%ax
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
801016fb:	c1 e8 03             	shr    $0x3,%eax
801016fe:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101704:	89 44 24 04          	mov    %eax,0x4(%esp)
80101708:	8b 03                	mov    (%ebx),%eax
8010170a:	89 04 24             	mov    %eax,(%esp)
8010170d:	e8 be e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101712:	8b 53 04             	mov    0x4(%ebx),%edx
80101715:	83 e2 07             	and    $0x7,%edx
80101718:	c1 e2 06             	shl    $0x6,%edx
8010171b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101721:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101724:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101727:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010172b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010172f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101733:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101737:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010173b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010173f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101743:	8b 42 fc             	mov    -0x4(%edx),%eax
80101746:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101749:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010174c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101750:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101757:	00 
80101758:	89 04 24             	mov    %eax,(%esp)
8010175b:	e8 a0 2f 00 00       	call   80104700 <memmove>
    brelse(bp);
80101760:	89 34 24             	mov    %esi,(%esp)
80101763:	e8 78 ea ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
80101768:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
8010176c:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101771:	0f 85 78 ff ff ff    	jne    801016ef <ilock+0x2f>
      panic("ilock: no type");
80101777:	c7 04 24 ec 71 10 80 	movl   $0x801071ec,(%esp)
8010177e:	e8 dd eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101783:	c7 04 24 e6 71 10 80 	movl   $0x801071e6,(%esp)
8010178a:	e8 d1 eb ff ff       	call   80100360 <panic>
8010178f:	90                   	nop

80101790 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	83 ec 10             	sub    $0x10,%esp
80101798:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010179b:	85 db                	test   %ebx,%ebx
8010179d:	74 24                	je     801017c3 <iunlock+0x33>
8010179f:	8d 73 0c             	lea    0xc(%ebx),%esi
801017a2:	89 34 24             	mov    %esi,(%esp)
801017a5:	e8 86 2c 00 00       	call   80104430 <holdingsleep>
801017aa:	85 c0                	test   %eax,%eax
801017ac:	74 15                	je     801017c3 <iunlock+0x33>
801017ae:	8b 43 08             	mov    0x8(%ebx),%eax
801017b1:	85 c0                	test   %eax,%eax
801017b3:	7e 0e                	jle    801017c3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017b5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	5b                   	pop    %ebx
801017bc:	5e                   	pop    %esi
801017bd:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017be:	e9 2d 2c 00 00       	jmp    801043f0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017c3:	c7 04 24 fb 71 10 80 	movl   $0x801071fb,(%esp)
801017ca:	e8 91 eb ff ff       	call   80100360 <panic>
801017cf:	90                   	nop

801017d0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 1c             	sub    $0x1c,%esp
801017d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
801017dc:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801017e3:	e8 f8 2c 00 00       	call   801044e0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017e8:	8b 46 08             	mov    0x8(%esi),%eax
801017eb:	83 f8 01             	cmp    $0x1,%eax
801017ee:	74 20                	je     80101810 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
801017f0:	83 e8 01             	sub    $0x1,%eax
801017f3:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
801017f6:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
801017fd:	83 c4 1c             	add    $0x1c,%esp
80101800:	5b                   	pop    %ebx
80101801:	5e                   	pop    %esi
80101802:	5f                   	pop    %edi
80101803:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
80101804:	e9 07 2e 00 00       	jmp    80104610 <release>
80101809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101810:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
80101814:	74 da                	je     801017f0 <iput+0x20>
80101816:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
8010181b:	75 d3                	jne    801017f0 <iput+0x20>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
8010181d:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101824:	89 f3                	mov    %esi,%ebx
80101826:	e8 e5 2d 00 00       	call   80104610 <release>
8010182b:	8d 7e 30             	lea    0x30(%esi),%edi
8010182e:	eb 07                	jmp    80101837 <iput+0x67>
80101830:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101833:	39 fb                	cmp    %edi,%ebx
80101835:	74 19                	je     80101850 <iput+0x80>
    if(ip->addrs[i]){
80101837:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010183a:	85 d2                	test   %edx,%edx
8010183c:	74 f2                	je     80101830 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
8010183e:	8b 06                	mov    (%esi),%eax
80101840:	e8 ab fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101845:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010184c:	eb e2                	jmp    80101830 <iput+0x60>
8010184e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101850:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101856:	85 c0                	test   %eax,%eax
80101858:	75 3e                	jne    80101898 <iput+0xc8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010185a:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101861:	89 34 24             	mov    %esi,(%esp)
80101864:	e8 97 fd ff ff       	call   80101600 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
80101869:	31 c0                	xor    %eax,%eax
8010186b:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
8010186f:	89 34 24             	mov    %esi,(%esp)
80101872:	e8 89 fd ff ff       	call   80101600 <iupdate>
    acquire(&icache.lock);
80101877:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010187e:	e8 5d 2c 00 00       	call   801044e0 <acquire>
80101883:	8b 46 08             	mov    0x8(%esi),%eax
    ip->flags = 0;
80101886:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
8010188d:	e9 5e ff ff ff       	jmp    801017f0 <iput+0x20>
80101892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101898:	89 44 24 04          	mov    %eax,0x4(%esp)
8010189c:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010189e:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	89 04 24             	mov    %eax,(%esp)
801018a3:	e8 28 e8 ff ff       	call   801000d0 <bread>
801018a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018ab:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
801018ae:	31 c0                	xor    %eax,%eax
801018b0:	eb 13                	jmp    801018c5 <iput+0xf5>
801018b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018b8:	83 c3 01             	add    $0x1,%ebx
801018bb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018c1:	89 d8                	mov    %ebx,%eax
801018c3:	74 10                	je     801018d5 <iput+0x105>
      if(a[j])
801018c5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018c8:	85 d2                	test   %edx,%edx
801018ca:	74 ec                	je     801018b8 <iput+0xe8>
        bfree(ip->dev, a[j]);
801018cc:	8b 06                	mov    (%esi),%eax
801018ce:	e8 1d fb ff ff       	call   801013f0 <bfree>
801018d3:	eb e3                	jmp    801018b8 <iput+0xe8>
    }
    brelse(bp);
801018d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018d8:	89 04 24             	mov    %eax,(%esp)
801018db:	e8 00 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018e0:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e6:	8b 06                	mov    (%esi),%eax
801018e8:	e8 03 fb ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018ed:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f4:	00 00 00 
801018f7:	e9 5e ff ff ff       	jmp    8010185a <iput+0x8a>
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101900 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 14             	sub    $0x14,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	89 1c 24             	mov    %ebx,(%esp)
8010190d:	e8 7e fe ff ff       	call   80101790 <iunlock>
  iput(ip);
80101912:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101915:	83 c4 14             	add    $0x14,%esp
80101918:	5b                   	pop    %ebx
80101919:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010191a:	e9 b1 fe ff ff       	jmp    801017d0 <iput>
8010191f:	90                   	nop

80101920 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 2c             	sub    $0x2c,%esp
80101959:	8b 45 0c             	mov    0xc(%ebp),%eax
8010195c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
80101962:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101965:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101968:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010196d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101970:	0f 84 aa 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101976:	8b 47 58             	mov    0x58(%edi),%eax
80101979:	39 f0                	cmp    %esi,%eax
8010197b:	0f 82 c7 00 00 00    	jb     80101a48 <readi+0xf8>
80101981:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101984:	89 da                	mov    %ebx,%edx
80101986:	01 f2                	add    %esi,%edx
80101988:	0f 82 ba 00 00 00    	jb     80101a48 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010198e:	89 c1                	mov    %eax,%ecx
80101990:	29 f1                	sub    %esi,%ecx
80101992:	39 d0                	cmp    %edx,%eax
80101994:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101997:	31 c0                	xor    %eax,%eax
80101999:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010199b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199e:	74 70                	je     80101a10 <readi+0xc0>
801019a0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019a3:	89 c7                	mov    %eax,%edi
801019a5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019a8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019ab:	89 f2                	mov    %esi,%edx
801019ad:	c1 ea 09             	shr    $0x9,%edx
801019b0:	89 d8                	mov    %ebx,%eax
801019b2:	e8 29 f9 ff ff       	call   801012e0 <bmap>
801019b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019bb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019bd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c2:	89 04 24             	mov    %eax,(%esp)
801019c5:	e8 06 e7 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019cd:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019d1:	89 f0                	mov    %esi,%eax
801019d3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019d8:	29 c3                	sub    %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019da:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019de:	39 cb                	cmp    %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019e7:	0f 47 d9             	cmova  %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019ea:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ee:	01 df                	add    %ebx,%edi
801019f0:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019f5:	89 04 24             	mov    %eax,(%esp)
801019f8:	e8 03 2d 00 00       	call   80104700 <memmove>
    brelse(bp);
801019fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a00:	89 14 24             	mov    %edx,(%esp)
80101a03:	e8 d8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a08:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a0e:	77 98                	ja     801019a8 <readi+0x58>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a13:	83 c4 2c             	add    $0x2c,%esp
80101a16:	5b                   	pop    %ebx
80101a17:	5e                   	pop    %esi
80101a18:	5f                   	pop    %edi
80101a19:	5d                   	pop    %ebp
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 1e                	ja     80101a48 <readi+0xf8>
80101a2a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 13                	je     80101a48 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a35:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a38:	89 75 10             	mov    %esi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a3b:	83 c4 2c             	add    $0x2c,%esp
80101a3e:	5b                   	pop    %ebx
80101a3f:	5e                   	pop    %esi
80101a40:	5f                   	pop    %edi
80101a41:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a42:	ff e0                	jmp    *%eax
80101a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a4d:	eb c4                	jmp    80101a13 <readi+0xc3>
80101a4f:	90                   	nop

80101a50 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 2c             	sub    $0x2c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a70:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 e3 00 00 00    	jb     80101b68 <writei+0x118>
80101a85:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a88:	89 c8                	mov    %ecx,%eax
80101a8a:	01 f0                	add    %esi,%eax
80101a8c:	0f 82 d6 00 00 00    	jb     80101b68 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a92:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a97:	0f 87 cb 00 00 00    	ja     80101b68 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9d:	85 c9                	test   %ecx,%ecx
80101a9f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa6:	74 77                	je     80101b1f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aab:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aad:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab2:	c1 ea 09             	shr    $0x9,%edx
80101ab5:	89 f8                	mov    %edi,%eax
80101ab7:	e8 24 f8 ff ff       	call   801012e0 <bmap>
80101abc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ac0:	8b 07                	mov    (%edi),%eax
80101ac2:	89 04 24             	mov    %eax,(%esp)
80101ac5:	e8 06 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101acd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ad0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad5:	89 f0                	mov    %esi,%eax
80101ad7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101adc:	29 c3                	sub    %eax,%ebx
80101ade:	39 cb                	cmp    %ecx,%ebx
80101ae0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ae3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae7:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ae9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101aed:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101af1:	89 04 24             	mov    %eax,(%esp)
80101af4:	e8 07 2c 00 00       	call   80104700 <memmove>
    log_write(bp);
80101af9:	89 3c 24             	mov    %edi,(%esp)
80101afc:	e8 2f 12 00 00       	call   80102d30 <log_write>
    brelse(bp);
80101b01:	89 3c 24             	mov    %edi,(%esp)
80101b04:	e8 d7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b09:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b0f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b12:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b15:	77 91                	ja     80101aa8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b17:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b1d:	72 39                	jb     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b22:	83 c4 2c             	add    $0x2c,%esp
80101b25:	5b                   	pop    %ebx
80101b26:	5e                   	pop    %esi
80101b27:	5f                   	pop    %edi
80101b28:	5d                   	pop    %ebp
80101b29:	c3                   	ret    
80101b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 2e                	ja     80101b68 <writei+0x118>
80101b3a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 23                	je     80101b68 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b48:	83 c4 2c             	add    $0x2c,%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b5e:	89 04 24             	mov    %eax,(%esp)
80101b61:	e8 9a fa ff ff       	call   80101600 <iupdate>
80101b66:	eb b7                	jmp    80101b1f <writei+0xcf>
  }
  return n;
}
80101b68:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b70:	5b                   	pop    %ebx
80101b71:	5e                   	pop    %esi
80101b72:	5f                   	pop    %edi
80101b73:	5d                   	pop    %ebp
80101b74:	c3                   	ret    
80101b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b89:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b90:	00 
80101b91:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b95:	8b 45 08             	mov    0x8(%ebp),%eax
80101b98:	89 04 24             	mov    %eax,(%esp)
80101b9b:	e8 e0 2b 00 00       	call   80104780 <strncmp>
}
80101ba0:	c9                   	leave  
80101ba1:	c3                   	ret    
80101ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 2c             	sub    $0x2c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 97 00 00 00    	jne    80101c5e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	75 0d                	jne    80101be0 <dirlookup+0x30>
80101bd3:	eb 73                	jmp    80101c48 <dirlookup+0x98>
80101bd5:	8d 76 00             	lea    0x0(%esi),%esi
80101bd8:	83 c7 10             	add    $0x10,%edi
80101bdb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bde:	76 68                	jbe    80101c48 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101be7:	00 
80101be8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bec:	89 74 24 04          	mov    %esi,0x4(%esp)
80101bf0:	89 1c 24             	mov    %ebx,(%esp)
80101bf3:	e8 58 fd ff ff       	call   80101950 <readi>
80101bf8:	83 f8 10             	cmp    $0x10,%eax
80101bfb:	75 55                	jne    80101c52 <dirlookup+0xa2>
      panic("dirlink read");
    if(de.inum == 0)
80101bfd:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c02:	74 d4                	je     80101bd8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c04:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c0e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c15:	00 
80101c16:	89 04 24             	mov    %eax,(%esp)
80101c19:	e8 62 2b 00 00       	call   80104780 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c1e:	85 c0                	test   %eax,%eax
80101c20:	75 b6                	jne    80101bd8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c22:	8b 45 10             	mov    0x10(%ebp),%eax
80101c25:	85 c0                	test   %eax,%eax
80101c27:	74 05                	je     80101c2e <dirlookup+0x7e>
        *poff = off;
80101c29:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c32:	8b 03                	mov    (%ebx),%eax
80101c34:	e8 e7 f5 ff ff       	call   80101220 <iget>
    }
  }

  return 0;
}
80101c39:	83 c4 2c             	add    $0x2c,%esp
80101c3c:	5b                   	pop    %ebx
80101c3d:	5e                   	pop    %esi
80101c3e:	5f                   	pop    %edi
80101c3f:	5d                   	pop    %ebp
80101c40:	c3                   	ret    
80101c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c48:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c4b:	31 c0                	xor    %eax,%eax
}
80101c4d:	5b                   	pop    %ebx
80101c4e:	5e                   	pop    %esi
80101c4f:	5f                   	pop    %edi
80101c50:	5d                   	pop    %ebp
80101c51:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101c52:	c7 04 24 15 72 10 80 	movl   $0x80107215,(%esp)
80101c59:	e8 02 e7 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c5e:	c7 04 24 03 72 10 80 	movl   $0x80107203,(%esp)
80101c65:	e8 f6 e6 ff ff       	call   80100360 <panic>
80101c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	89 cf                	mov    %ecx,%edi
80101c76:	56                   	push   %esi
80101c77:	53                   	push   %ebx
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c83:	0f 84 51 01 00 00    	je     80101dda <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101c8f:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c92:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101c99:	e8 42 28 00 00       	call   801044e0 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101ca9:	e8 62 29 00 00       	call   80104610 <release>
80101cae:	eb 03                	jmp    80101cb3 <namex+0x43>
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cb0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cb3:	0f b6 03             	movzbl (%ebx),%eax
80101cb6:	3c 2f                	cmp    $0x2f,%al
80101cb8:	74 f6                	je     80101cb0 <namex+0x40>
    path++;
  if(*path == 0)
80101cba:	84 c0                	test   %al,%al
80101cbc:	0f 84 ed 00 00 00    	je     80101daf <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cc2:	0f b6 03             	movzbl (%ebx),%eax
80101cc5:	89 da                	mov    %ebx,%edx
80101cc7:	84 c0                	test   %al,%al
80101cc9:	0f 84 b1 00 00 00    	je     80101d80 <namex+0x110>
80101ccf:	3c 2f                	cmp    $0x2f,%al
80101cd1:	75 0f                	jne    80101ce2 <namex+0x72>
80101cd3:	e9 a8 00 00 00       	jmp    80101d80 <namex+0x110>
80101cd8:	3c 2f                	cmp    $0x2f,%al
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ce0:	74 0a                	je     80101cec <namex+0x7c>
    path++;
80101ce2:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101ce5:	0f b6 02             	movzbl (%edx),%eax
80101ce8:	84 c0                	test   %al,%al
80101cea:	75 ec                	jne    80101cd8 <namex+0x68>
80101cec:	89 d1                	mov    %edx,%ecx
80101cee:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cf0:	83 f9 0d             	cmp    $0xd,%ecx
80101cf3:	0f 8e 8f 00 00 00    	jle    80101d88 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cf9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101cfd:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d04:	00 
80101d05:	89 3c 24             	mov    %edi,(%esp)
80101d08:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d0b:	e8 f0 29 00 00       	call   80104700 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d13:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d15:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d18:	75 0e                	jne    80101d28 <namex+0xb8>
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	89 34 24             	mov    %esi,(%esp)
80101d2b:	e8 90 f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101d30:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d35:	0f 85 85 00 00 00    	jne    80101dc0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d3e:	85 d2                	test   %edx,%edx
80101d40:	74 09                	je     80101d4b <namex+0xdb>
80101d42:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d45:	0f 84 a5 00 00 00    	je     80101df0 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d52:	00 
80101d53:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d57:	89 34 24             	mov    %esi,(%esp)
80101d5a:	e8 51 fe ff ff       	call   80101bb0 <dirlookup>
80101d5f:	85 c0                	test   %eax,%eax
80101d61:	74 5d                	je     80101dc0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d63:	89 34 24             	mov    %esi,(%esp)
80101d66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d69:	e8 22 fa ff ff       	call   80101790 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 5a fa ff ff       	call   801017d0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	89 c6                	mov    %eax,%esi
80101d7b:	e9 33 ff ff ff       	jmp    80101cb3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d80:	31 c9                	xor    %ecx,%ecx
80101d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d88:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d8c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d90:	89 3c 24             	mov    %edi,(%esp)
80101d93:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d96:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d99:	e8 62 29 00 00       	call   80104700 <memmove>
    name[len] = 0;
80101d9e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101da8:	89 d3                	mov    %edx,%ebx
80101daa:	e9 66 ff ff ff       	jmp    80101d15 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101daf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101db2:	85 c0                	test   %eax,%eax
80101db4:	75 4c                	jne    80101e02 <namex+0x192>
80101db6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101db8:	83 c4 2c             	add    $0x2c,%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5f                   	pop    %edi
80101dbe:	5d                   	pop    %ebp
80101dbf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dc0:	89 34 24             	mov    %esi,(%esp)
80101dc3:	e8 c8 f9 ff ff       	call   80101790 <iunlock>
  iput(ip);
80101dc8:	89 34 24             	mov    %esi,(%esp)
80101dcb:	e8 00 fa ff ff       	call   801017d0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101dd3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd5:	5b                   	pop    %ebx
80101dd6:	5e                   	pop    %esi
80101dd7:	5f                   	pop    %edi
80101dd8:	5d                   	pop    %ebp
80101dd9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dda:	ba 01 00 00 00       	mov    $0x1,%edx
80101ddf:	b8 01 00 00 00       	mov    $0x1,%eax
80101de4:	e8 37 f4 ff ff       	call   80101220 <iget>
80101de9:	89 c6                	mov    %eax,%esi
80101deb:	e9 c3 fe ff ff       	jmp    80101cb3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101df0:	89 34 24             	mov    %esi,(%esp)
80101df3:	e8 98 f9 ff ff       	call   80101790 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101df8:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101dfb:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dfd:	5b                   	pop    %ebx
80101dfe:	5e                   	pop    %esi
80101dff:	5f                   	pop    %edi
80101e00:	5d                   	pop    %ebp
80101e01:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e02:	89 34 24             	mov    %esi,(%esp)
80101e05:	e8 c6 f9 ff ff       	call   801017d0 <iput>
    return 0;
80101e0a:	31 c0                	xor    %eax,%eax
80101e0c:	eb aa                	jmp    80101db8 <namex+0x148>
80101e0e:	66 90                	xchg   %ax,%ax

80101e10 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 2c             	sub    $0x2c,%esp
80101e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e26:	00 
80101e27:	89 1c 24             	mov    %ebx,(%esp)
80101e2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e2e:	e8 7d fd ff ff       	call   80101bb0 <dirlookup>
80101e33:	85 c0                	test   %eax,%eax
80101e35:	0f 85 8b 00 00 00    	jne    80101ec6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e3e:	31 ff                	xor    %edi,%edi
80101e40:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e43:	85 c0                	test   %eax,%eax
80101e45:	75 13                	jne    80101e5a <dirlink+0x4a>
80101e47:	eb 35                	jmp    80101e7e <dirlink+0x6e>
80101e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e50:	8d 57 10             	lea    0x10(%edi),%edx
80101e53:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e56:	89 d7                	mov    %edx,%edi
80101e58:	76 24                	jbe    80101e7e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e61:	00 
80101e62:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e66:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e6a:	89 1c 24             	mov    %ebx,(%esp)
80101e6d:	e8 de fa ff ff       	call   80101950 <readi>
80101e72:	83 f8 10             	cmp    $0x10,%eax
80101e75:	75 5e                	jne    80101ed5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101e77:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7c:	75 d2                	jne    80101e50 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e81:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e88:	00 
80101e89:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e8d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e90:	89 04 24             	mov    %eax,(%esp)
80101e93:	e8 58 29 00 00       	call   801047f0 <strncpy>
  de.inum = inum;
80101e98:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ea2:	00 
80101ea3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ea7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eab:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101eae:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb2:	e8 99 fb ff ff       	call   80101a50 <writei>
80101eb7:	83 f8 10             	cmp    $0x10,%eax
80101eba:	75 25                	jne    80101ee1 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101ebc:	31 c0                	xor    %eax,%eax
}
80101ebe:	83 c4 2c             	add    $0x2c,%esp
80101ec1:	5b                   	pop    %ebx
80101ec2:	5e                   	pop    %esi
80101ec3:	5f                   	pop    %edi
80101ec4:	5d                   	pop    %ebp
80101ec5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ec6:	89 04 24             	mov    %eax,(%esp)
80101ec9:	e8 02 f9 ff ff       	call   801017d0 <iput>
    return -1;
80101ece:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed3:	eb e9                	jmp    80101ebe <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ed5:	c7 04 24 15 72 10 80 	movl   $0x80107215,(%esp)
80101edc:	e8 7f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ee1:	c7 04 24 4e 78 10 80 	movl   $0x8010784e,(%esp)
80101ee8:	e8 73 e4 ff ff       	call   80100360 <panic>
80101eed:	8d 76 00             	lea    0x0(%esi),%esi

80101ef0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	56                   	push   %esi
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	53                   	push   %ebx
80101f37:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f3a:	85 c0                	test   %eax,%eax
80101f3c:	0f 84 99 00 00 00    	je     80101fdb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f42:	8b 48 08             	mov    0x8(%eax),%ecx
80101f45:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f4b:	0f 87 7e 00 00 00    	ja     80101fcf <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f51:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f56:	66 90                	xchg   %ax,%ax
80101f58:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f59:	83 e0 c0             	and    $0xffffffc0,%eax
80101f5c:	3c 40                	cmp    $0x40,%al
80101f5e:	75 f8                	jne    80101f58 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f60:	31 db                	xor    %ebx,%ebx
80101f62:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f67:	89 d8                	mov    %ebx,%eax
80101f69:	ee                   	out    %al,(%dx)
80101f6a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f74:	ee                   	out    %al,(%dx)
80101f75:	0f b6 c1             	movzbl %cl,%eax
80101f78:	b2 f3                	mov    $0xf3,%dl
80101f7a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f7b:	89 c8                	mov    %ecx,%eax
80101f7d:	b2 f4                	mov    $0xf4,%dl
80101f7f:	c1 f8 08             	sar    $0x8,%eax
80101f82:	ee                   	out    %al,(%dx)
80101f83:	b2 f5                	mov    $0xf5,%dl
80101f85:	89 d8                	mov    %ebx,%eax
80101f87:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f88:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8c:	b2 f6                	mov    $0xf6,%dl
80101f8e:	83 e0 01             	and    $0x1,%eax
80101f91:	c1 e0 04             	shl    $0x4,%eax
80101f94:	83 c8 e0             	or     $0xffffffe0,%eax
80101f97:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f98:	f6 06 04             	testb  $0x4,(%esi)
80101f9b:	75 13                	jne    80101fb0 <idestart+0x80>
80101f9d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	5b                   	pop    %ebx
80101fac:	5e                   	pop    %esi
80101fad:	5d                   	pop    %ebp
80101fae:	c3                   	ret    
80101faf:	90                   	nop
80101fb0:	b2 f7                	mov    $0xf7,%dl
80101fb2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fb7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fb8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fbd:	83 c6 5c             	add    $0x5c,%esi
80101fc0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fc5:	fc                   	cld    
80101fc6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5d                   	pop    %ebp
80101fce:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fcf:	c7 04 24 80 72 10 80 	movl   $0x80107280,(%esp)
80101fd6:	e8 85 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fdb:	c7 04 24 77 72 10 80 	movl   $0x80107277,(%esp)
80101fe2:	e8 79 e3 ff ff       	call   80100360 <panic>
80101fe7:	89 f6                	mov    %esi,%esi
80101fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ff0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80101ff6:	c7 44 24 04 92 72 10 	movl   $0x80107292,0x4(%esp)
80101ffd:	80 
80101ffe:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102005:	e8 56 24 00 00       	call   80104460 <initlock>
  picenable(IRQ_IDE);
8010200a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102011:	e8 ea 11 00 00       	call   80103200 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102016:	a1 80 2d 11 80       	mov    0x80112d80,%eax
8010201b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102022:	83 e8 01             	sub    $0x1,%eax
80102025:	89 44 24 04          	mov    %eax,0x4(%esp)
80102029:	e8 82 02 00 00       	call   801022b0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102033:	90                   	nop
80102034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102038:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102039:	83 e0 c0             	and    $0xffffffc0,%eax
8010203c:	3c 40                	cmp    $0x40,%al
8010203e:	75 f8                	jne    80102038 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102040:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102045:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204a:	ee                   	out    %al,(%dx)
8010204b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102050:	b2 f7                	mov    $0xf7,%dl
80102052:	eb 09                	jmp    8010205d <ideinit+0x6d>
80102054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102058:	83 e9 01             	sub    $0x1,%ecx
8010205b:	74 0f                	je     8010206c <ideinit+0x7c>
8010205d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010205e:	84 c0                	test   %al,%al
80102060:	74 f6                	je     80102058 <ideinit+0x68>
      havedisk1 = 1;
80102062:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102069:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010206c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102071:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102076:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102077:	c9                   	leave  
80102078:	c3                   	ret    
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102080 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102090:	e8 4b 24 00 00       	call   801044e0 <acquire>
  if((b = idequeue) == 0){
80102095:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010209b:	85 db                	test   %ebx,%ebx
8010209d:	74 30                	je     801020cf <ideintr+0x4f>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
8010209f:	8b 43 58             	mov    0x58(%ebx),%eax
801020a2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a7:	8b 33                	mov    (%ebx),%esi
801020a9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020af:	74 37                	je     801020e8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020b1:	83 e6 fb             	and    $0xfffffffb,%esi
801020b4:	83 ce 02             	or     $0x2,%esi
801020b7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020b9:	89 1c 24             	mov    %ebx,(%esp)
801020bc:	e8 2f 1f 00 00       	call   80103ff0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020c1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020c6:	85 c0                	test   %eax,%eax
801020c8:	74 05                	je     801020cf <ideintr+0x4f>
    idestart(idequeue);
801020ca:	e8 61 fe ff ff       	call   80101f30 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
801020cf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020d6:	e8 35 25 00 00       	call   80104610 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020db:	83 c4 1c             	add    $0x1c,%esp
801020de:	5b                   	pop    %ebx
801020df:	5e                   	pop    %esi
801020e0:	5f                   	pop    %edi
801020e1:	5d                   	pop    %ebp
801020e2:	c3                   	ret    
801020e3:	90                   	nop
801020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ed:	8d 76 00             	lea    0x0(%esi),%esi
801020f0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f1:	89 c1                	mov    %eax,%ecx
801020f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020f6:	80 f9 40             	cmp    $0x40,%cl
801020f9:	75 f5                	jne    801020f0 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020fb:	a8 21                	test   $0x21,%al
801020fd:	75 b2                	jne    801020b1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102102:	b9 80 00 00 00       	mov    $0x80,%ecx
80102107:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210c:	fc                   	cld    
8010210d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010210f:	8b 33                	mov    (%ebx),%esi
80102111:	eb 9e                	jmp    801020b1 <ideintr+0x31>
80102113:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 14             	sub    $0x14,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	89 04 24             	mov    %eax,(%esp)
80102130:	e8 fb 22 00 00       	call   80104430 <holdingsleep>
80102135:	85 c0                	test   %eax,%eax
80102137:	0f 84 9e 00 00 00    	je     801021db <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213d:	8b 03                	mov    (%ebx),%eax
8010213f:	83 e0 06             	and    $0x6,%eax
80102142:	83 f8 02             	cmp    $0x2,%eax
80102145:	0f 84 a8 00 00 00    	je     801021f3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214b:	8b 53 04             	mov    0x4(%ebx),%edx
8010214e:	85 d2                	test   %edx,%edx
80102150:	74 0d                	je     8010215f <iderw+0x3f>
80102152:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102157:	85 c0                	test   %eax,%eax
80102159:	0f 84 88 00 00 00    	je     801021e7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010215f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102166:	e8 75 23 00 00       	call   801044e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102170:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102177:	85 c0                	test   %eax,%eax
80102179:	75 07                	jne    80102182 <iderw+0x62>
8010217b:	eb 4e                	jmp    801021cb <iderw+0xab>
8010217d:	8d 76 00             	lea    0x0(%esi),%esi
80102180:	89 d0                	mov    %edx,%eax
80102182:	8b 50 58             	mov    0x58(%eax),%edx
80102185:	85 d2                	test   %edx,%edx
80102187:	75 f7                	jne    80102180 <iderw+0x60>
80102189:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010218c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010218e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102194:	74 3c                	je     801021d2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102196:	8b 03                	mov    (%ebx),%eax
80102198:	83 e0 06             	and    $0x6,%eax
8010219b:	83 f8 02             	cmp    $0x2,%eax
8010219e:	74 1a                	je     801021ba <iderw+0x9a>
    sleep(b, &idelock);
801021a0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021a7:	80 
801021a8:	89 1c 24             	mov    %ebx,(%esp)
801021ab:	e8 90 1c 00 00       	call   80103e40 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021b0:	8b 13                	mov    (%ebx),%edx
801021b2:	83 e2 06             	and    $0x6,%edx
801021b5:	83 fa 02             	cmp    $0x2,%edx
801021b8:	75 e6                	jne    801021a0 <iderw+0x80>
    sleep(b, &idelock);
  }

  release(&idelock);
801021ba:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021c1:	83 c4 14             	add    $0x14,%esp
801021c4:	5b                   	pop    %ebx
801021c5:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
801021c6:	e9 45 24 00 00       	jmp    80104610 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021cb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021d0:	eb ba                	jmp    8010218c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021d2:	89 d8                	mov    %ebx,%eax
801021d4:	e8 57 fd ff ff       	call   80101f30 <idestart>
801021d9:	eb bb                	jmp    80102196 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021db:	c7 04 24 96 72 10 80 	movl   $0x80107296,(%esp)
801021e2:	e8 79 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021e7:	c7 04 24 c1 72 10 80 	movl   $0x801072c1,(%esp)
801021ee:	e8 6d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021f3:	c7 04 24 ac 72 10 80 	movl   $0x801072ac,(%esp)
801021fa:	e8 61 e1 ff ff       	call   80100360 <panic>
801021ff:	90                   	nop

80102200 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
80102200:	a1 84 27 11 80       	mov    0x80112784,%eax
80102205:	85 c0                	test   %eax,%eax
80102207:	0f 84 9b 00 00 00    	je     801022a8 <ioapicinit+0xa8>
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010220d:	55                   	push   %ebp
8010220e:	89 e5                	mov    %esp,%ebp
80102210:	56                   	push   %esi
80102211:	53                   	push   %ebx
80102212:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102215:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
8010221c:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010221f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102226:	00 00 00 
  return ioapic->data;
80102229:	8b 15 54 26 11 80    	mov    0x80112654,%edx
8010222f:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102232:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102238:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010223e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102245:	c1 e8 10             	shr    $0x10,%eax
80102248:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010224b:	8b 43 10             	mov    0x10(%ebx),%eax
  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
8010224e:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102251:	39 c2                	cmp    %eax,%edx
80102253:	74 12                	je     80102267 <ioapicinit+0x67>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102255:	c7 04 24 e0 72 10 80 	movl   $0x801072e0,(%esp)
8010225c:	e8 ef e3 ff ff       	call   80100650 <cprintf>
80102261:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
80102267:	ba 10 00 00 00       	mov    $0x10,%edx
8010226c:	31 c0                	xor    %eax,%eax
8010226e:	eb 02                	jmp    80102272 <ioapicinit+0x72>
80102270:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102272:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
80102274:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
8010227a:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010227d:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102283:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102286:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102289:	8d 4a 01             	lea    0x1(%edx),%ecx
8010228c:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010228f:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102291:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102297:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102299:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022a0:	7d ce                	jge    80102270 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022a2:	83 c4 10             	add    $0x10,%esp
801022a5:	5b                   	pop    %ebx
801022a6:	5e                   	pop    %esi
801022a7:	5d                   	pop    %ebp
801022a8:	f3 c3                	repz ret 
801022aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
801022b0:	8b 15 84 27 11 80    	mov    0x80112784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022b6:	55                   	push   %ebp
801022b7:	89 e5                	mov    %esp,%ebp
801022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801022bc:	85 d2                	test   %edx,%edx
801022be:	74 29                	je     801022e9 <ioapicenable+0x39>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022c0:	8d 48 20             	lea    0x20(%eax),%ecx
801022c3:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c7:	a1 54 26 11 80       	mov    0x80112654,%eax
801022cc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801022ce:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d3:	83 c2 01             	add    $0x1,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022d6:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022dc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801022de:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e3:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022e6:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022e9:	5d                   	pop    %ebp
801022ea:	c3                   	ret    
801022eb:	66 90                	xchg   %ax,%ax
801022ed:	66 90                	xchg   %ax,%ax
801022ef:	90                   	nop

801022f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 14             	sub    $0x14,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102300:	75 7c                	jne    8010237e <kfree+0x8e>
80102302:	81 fb 28 57 11 80    	cmp    $0x80115728,%ebx
80102308:	72 74                	jb     8010237e <kfree+0x8e>
8010230a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102310:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102315:	77 67                	ja     8010237e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102317:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010231e:	00 
8010231f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102326:	00 
80102327:	89 1c 24             	mov    %ebx,(%esp)
8010232a:	e8 31 23 00 00       	call   80104660 <memset>

  if(kmem.use_lock)
8010232f:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102335:	85 d2                	test   %edx,%edx
80102337:	75 37                	jne    80102370 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102339:	a1 98 26 11 80       	mov    0x80112698,%eax
8010233e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102340:	a1 94 26 11 80       	mov    0x80112694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102345:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
8010234b:	85 c0                	test   %eax,%eax
8010234d:	75 09                	jne    80102358 <kfree+0x68>
    release(&kmem.lock);
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
80102354:	c3                   	ret    
80102355:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102358:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102364:	e9 a7 22 00 00       	jmp    80104610 <release>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102370:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102377:	e8 64 21 00 00       	call   801044e0 <acquire>
8010237c:	eb bb                	jmp    80102339 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010237e:	c7 04 24 12 73 10 80 	movl   $0x80107312,(%esp)
80102385:	e8 d6 df ff ff       	call   80100360 <panic>
8010238a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102390 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	56                   	push   %esi
80102394:	53                   	push   %ebx
80102395:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102398:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010239b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010239e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023a4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023aa:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023b0:	39 de                	cmp    %ebx,%esi
801023b2:	73 08                	jae    801023bc <freerange+0x2c>
801023b4:	eb 18                	jmp    801023ce <freerange+0x3e>
801023b6:	66 90                	xchg   %ax,%ax
801023b8:	89 da                	mov    %ebx,%edx
801023ba:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023bc:	89 14 24             	mov    %edx,(%esp)
801023bf:	e8 2c ff ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ca:	39 f0                	cmp    %esi,%eax
801023cc:	76 ea                	jbe    801023b8 <freerange+0x28>
    kfree(p);
}
801023ce:	83 c4 10             	add    $0x10,%esp
801023d1:	5b                   	pop    %ebx
801023d2:	5e                   	pop    %esi
801023d3:	5d                   	pop    %ebp
801023d4:	c3                   	ret    
801023d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023e0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
801023e5:	83 ec 10             	sub    $0x10,%esp
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023eb:	c7 44 24 04 18 73 10 	movl   $0x80107318,0x4(%esp)
801023f2:	80 
801023f3:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801023fa:	e8 61 20 00 00       	call   80104460 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ff:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102402:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102409:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010240c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102412:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102418:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010241e:	39 de                	cmp    %ebx,%esi
80102420:	73 0a                	jae    8010242c <kinit1+0x4c>
80102422:	eb 1a                	jmp    8010243e <kinit1+0x5e>
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102428:	89 da                	mov    %ebx,%edx
8010242a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010242c:	89 14 24             	mov    %edx,(%esp)
8010242f:	e8 bc fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102434:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010243a:	39 c6                	cmp    %eax,%esi
8010243c:	73 ea                	jae    80102428 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	5b                   	pop    %ebx
80102442:	5e                   	pop    %esi
80102443:	5d                   	pop    %ebp
80102444:	c3                   	ret    
80102445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
80102455:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102458:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010245b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010245e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102464:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 08                	jae    8010247c <kinit2+0x2c>
80102474:	eb 18                	jmp    8010248e <kinit2+0x3e>
80102476:	66 90                	xchg   %ax,%ax
80102478:	89 da                	mov    %ebx,%edx
8010247a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010247c:	89 14 24             	mov    %edx,(%esp)
8010247f:	e8 6c fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102484:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010248a:	39 c6                	cmp    %eax,%esi
8010248c:	73 ea                	jae    80102478 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010248e:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
80102495:	00 00 00 
}
80102498:	83 c4 10             	add    $0x10,%esp
8010249b:	5b                   	pop    %ebx
8010249c:	5e                   	pop    %esi
8010249d:	5d                   	pop    %ebp
8010249e:	c3                   	ret    
8010249f:	90                   	nop

801024a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024a7:	a1 94 26 11 80       	mov    0x80112694,%eax
801024ac:	85 c0                	test   %eax,%eax
801024ae:	75 30                	jne    801024e0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024b0:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
801024b6:	85 db                	test   %ebx,%ebx
801024b8:	74 08                	je     801024c2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ba:	8b 13                	mov    (%ebx),%edx
801024bc:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
801024c2:	85 c0                	test   %eax,%eax
801024c4:	74 0c                	je     801024d2 <kalloc+0x32>
    release(&kmem.lock);
801024c6:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801024cd:	e8 3e 21 00 00       	call   80104610 <release>
  return (char*)r;
}
801024d2:	83 c4 14             	add    $0x14,%esp
801024d5:	89 d8                	mov    %ebx,%eax
801024d7:	5b                   	pop    %ebx
801024d8:	5d                   	pop    %ebp
801024d9:	c3                   	ret    
801024da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024e0:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801024e7:	e8 f4 1f 00 00       	call   801044e0 <acquire>
801024ec:	a1 94 26 11 80       	mov    0x80112694,%eax
801024f1:	eb bd                	jmp    801024b0 <kalloc+0x10>
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102500:	ba 64 00 00 00       	mov    $0x64,%edx
80102505:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102506:	a8 01                	test   $0x1,%al
80102508:	0f 84 ba 00 00 00    	je     801025c8 <kbdgetc+0xc8>
8010250e:	b2 60                	mov    $0x60,%dl
80102510:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102511:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102514:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010251a:	0f 84 88 00 00 00    	je     801025a8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102520:	84 c0                	test   %al,%al
80102522:	79 2c                	jns    80102550 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102524:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010252a:	f6 c2 40             	test   $0x40,%dl
8010252d:	75 05                	jne    80102534 <kbdgetc+0x34>
8010252f:	89 c1                	mov    %eax,%ecx
80102531:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102534:	0f b6 81 40 74 10 80 	movzbl -0x7fef8bc0(%ecx),%eax
8010253b:	83 c8 40             	or     $0x40,%eax
8010253e:	0f b6 c0             	movzbl %al,%eax
80102541:	f7 d0                	not    %eax
80102543:	21 d0                	and    %edx,%eax
80102545:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010254a:	31 c0                	xor    %eax,%eax
8010254c:	c3                   	ret    
8010254d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	53                   	push   %ebx
80102554:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010255a:	f6 c3 40             	test   $0x40,%bl
8010255d:	74 09                	je     80102568 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010255f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102562:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102565:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102568:	0f b6 91 40 74 10 80 	movzbl -0x7fef8bc0(%ecx),%edx
  shift ^= togglecode[data];
8010256f:	0f b6 81 40 73 10 80 	movzbl -0x7fef8cc0(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102576:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102578:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010257a:	89 d0                	mov    %edx,%eax
8010257c:	83 e0 03             	and    $0x3,%eax
8010257f:	8b 04 85 20 73 10 80 	mov    -0x7fef8ce0(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102586:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010258c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010258f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102593:	74 0b                	je     801025a0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102595:	8d 50 9f             	lea    -0x61(%eax),%edx
80102598:	83 fa 19             	cmp    $0x19,%edx
8010259b:	77 1b                	ja     801025b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010259d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a0:	5b                   	pop    %ebx
801025a1:	5d                   	pop    %ebp
801025a2:	c3                   	ret    
801025a3:	90                   	nop
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025a8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025af:	31 c0                	xor    %eax,%eax
801025b1:	c3                   	ret    
801025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025bb:	8d 50 20             	lea    0x20(%eax),%edx
801025be:	83 f9 19             	cmp    $0x19,%ecx
801025c1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025c4:	eb da                	jmp    801025a0 <kbdgetc+0xa0>
801025c6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax

801025d0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025d6:	c7 04 24 00 25 10 80 	movl   $0x80102500,(%esp)
801025dd:	e8 ce e1 ff ff       	call   801007b0 <consoleintr>
}
801025e2:	c9                   	leave  
801025e3:	c3                   	ret    
801025e4:	66 90                	xchg   %ax,%ax
801025e6:	66 90                	xchg   %ax,%ax
801025e8:	66 90                	xchg   %ax,%ax
801025ea:	66 90                	xchg   %ax,%ax
801025ec:	66 90                	xchg   %ax,%ax
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801025f0:	55                   	push   %ebp
801025f1:	89 c1                	mov    %eax,%ecx
801025f3:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f5:	ba 70 00 00 00       	mov    $0x70,%edx
801025fa:	53                   	push   %ebx
801025fb:	31 c0                	xor    %eax,%eax
801025fd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025fe:	bb 71 00 00 00       	mov    $0x71,%ebx
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102606:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 01                	mov    %eax,(%ecx)
8010260d:	b8 02 00 00 00       	mov    $0x2,%eax
80102612:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102613:	89 da                	mov    %ebx,%edx
80102615:	ec                   	in     (%dx),%al
80102616:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102619:	b2 70                	mov    $0x70,%dl
8010261b:	89 41 04             	mov    %eax,0x4(%ecx)
8010261e:	b8 04 00 00 00       	mov    $0x4,%eax
80102623:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102624:	89 da                	mov    %ebx,%edx
80102626:	ec                   	in     (%dx),%al
80102627:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262a:	b2 70                	mov    $0x70,%dl
8010262c:	89 41 08             	mov    %eax,0x8(%ecx)
8010262f:	b8 07 00 00 00       	mov    $0x7,%eax
80102634:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102635:	89 da                	mov    %ebx,%edx
80102637:	ec                   	in     (%dx),%al
80102638:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263b:	b2 70                	mov    $0x70,%dl
8010263d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102640:	b8 08 00 00 00       	mov    $0x8,%eax
80102645:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102646:	89 da                	mov    %ebx,%edx
80102648:	ec                   	in     (%dx),%al
80102649:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264c:	b2 70                	mov    $0x70,%dl
8010264e:	89 41 10             	mov    %eax,0x10(%ecx)
80102651:	b8 09 00 00 00       	mov    $0x9,%eax
80102656:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102657:	89 da                	mov    %ebx,%edx
80102659:	ec                   	in     (%dx),%al
8010265a:	0f b6 d8             	movzbl %al,%ebx
8010265d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102660:	5b                   	pop    %ebx
80102661:	5d                   	pop    %ebp
80102662:	c3                   	ret    
80102663:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102670:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c0 00 00 00    	je     80102740 <lapicinit+0xd0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026b1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026be:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 6f                	ja     80102748 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e3:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f0:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fd:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102728:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010272e:	80 e6 10             	and    $0x10,%dh
80102731:	75 f5                	jne    80102728 <lapicinit+0xb8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102733:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010273a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102740:	5d                   	pop    %ebp
80102741:	c3                   	ret    
80102742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102748:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010274f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102752:	8b 50 20             	mov    0x20(%eax),%edx
80102755:	eb 82                	jmp    801026d9 <lapicinit+0x69>
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	56                   	push   %esi
80102764:	53                   	push   %ebx
80102765:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102768:	9c                   	pushf  
80102769:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010276a:	f6 c4 02             	test   $0x2,%ah
8010276d:	74 12                	je     80102781 <cpunum+0x21>
    static int n;
    if(n++ == 0)
8010276f:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80102774:	8d 50 01             	lea    0x1(%eax),%edx
80102777:	85 c0                	test   %eax,%eax
80102779:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
8010277f:	74 4a                	je     801027cb <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
80102781:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102786:	85 c0                	test   %eax,%eax
80102788:	74 5d                	je     801027e7 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
8010278a:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010278d:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102793:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102796:	85 f6                	test   %esi,%esi
80102798:	7e 56                	jle    801027f0 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
8010279a:	0f b6 05 a0 27 11 80 	movzbl 0x801127a0,%eax
801027a1:	39 d8                	cmp    %ebx,%eax
801027a3:	74 42                	je     801027e7 <cpunum+0x87>
801027a5:	ba 5c 28 11 80       	mov    $0x8011285c,%edx

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
801027aa:	31 c0                	xor    %eax,%eax
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b0:	83 c0 01             	add    $0x1,%eax
801027b3:	39 f0                	cmp    %esi,%eax
801027b5:	74 39                	je     801027f0 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027b7:	0f b6 0a             	movzbl (%edx),%ecx
801027ba:	81 c2 bc 00 00 00    	add    $0xbc,%edx
801027c0:	39 d9                	cmp    %ebx,%ecx
801027c2:	75 ec                	jne    801027b0 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
801027c4:	83 c4 10             	add    $0x10,%esp
801027c7:	5b                   	pop    %ebx
801027c8:	5e                   	pop    %esi
801027c9:	5d                   	pop    %ebp
801027ca:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
801027cb:	8b 45 04             	mov    0x4(%ebp),%eax
801027ce:	c7 04 24 40 75 10 80 	movl   $0x80107540,(%esp)
801027d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801027d9:	e8 72 de ff ff       	call   80100650 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
801027de:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027e3:	85 c0                	test   %eax,%eax
801027e5:	75 a3                	jne    8010278a <cpunum+0x2a>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
801027e7:	83 c4 10             	add    $0x10,%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
801027ea:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
801027ec:	5b                   	pop    %ebx
801027ed:	5e                   	pop    %esi
801027ee:	5d                   	pop    %ebp
801027ef:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
801027f0:	c7 04 24 6c 75 10 80 	movl   $0x8010756c,(%esp)
801027f7:	e8 64 db ff ff       	call   80100360 <panic>
801027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102800 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102800:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102805:	55                   	push   %ebp
80102806:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102808:	85 c0                	test   %eax,%eax
8010280a:	74 0d                	je     80102819 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102813:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102816:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102819:	5d                   	pop    %ebp
8010281a:	c3                   	ret    
8010281b:	90                   	nop
8010281c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102820 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
}
80102823:	5d                   	pop    %ebp
80102824:	c3                   	ret    
80102825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102830 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102830:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102831:	ba 70 00 00 00       	mov    $0x70,%edx
80102836:	89 e5                	mov    %esp,%ebp
80102838:	b8 0f 00 00 00       	mov    $0xf,%eax
8010283d:	53                   	push   %ebx
8010283e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102841:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102844:	ee                   	out    %al,(%dx)
80102845:	b8 0a 00 00 00       	mov    $0xa,%eax
8010284a:	b2 71                	mov    $0x71,%dl
8010284c:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010284d:	31 c0                	xor    %eax,%eax
8010284f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102855:	89 d8                	mov    %ebx,%eax
80102857:	c1 e8 04             	shr    $0x4,%eax
8010285a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102860:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102865:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102868:	c1 eb 0c             	shr    $0xc,%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010286b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102871:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102874:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010287b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102881:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102888:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288b:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010288e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102894:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102897:	89 da                	mov    %ebx,%edx
80102899:	80 ce 06             	or     $0x6,%dh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010289c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a2:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028a5:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028ab:	8b 48 20             	mov    0x20(%eax),%ecx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028ae:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801028b7:	5b                   	pop    %ebx
801028b8:	5d                   	pop    %ebp
801028b9:	c3                   	ret    
801028ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028c0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028c0:	55                   	push   %ebp
801028c1:	ba 70 00 00 00       	mov    $0x70,%edx
801028c6:	89 e5                	mov    %esp,%ebp
801028c8:	b8 0b 00 00 00       	mov    $0xb,%eax
801028cd:	57                   	push   %edi
801028ce:	56                   	push   %esi
801028cf:	53                   	push   %ebx
801028d0:	83 ec 4c             	sub    $0x4c,%esp
801028d3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d4:	b2 71                	mov    $0x71,%dl
801028d6:	ec                   	in     (%dx),%al
801028d7:	88 45 b7             	mov    %al,-0x49(%ebp)
801028da:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801028dd:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
801028e1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801028e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e8:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801028ed:	89 d8                	mov    %ebx,%eax
801028ef:	e8 fc fc ff ff       	call   801025f0 <fill_rtcdate>
801028f4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028f9:	89 f2                	mov    %esi,%edx
801028fb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fc:	ba 71 00 00 00       	mov    $0x71,%edx
80102901:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102902:	84 c0                	test   %al,%al
80102904:	78 e7                	js     801028ed <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102906:	89 f8                	mov    %edi,%eax
80102908:	e8 e3 fc ff ff       	call   801025f0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010290d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102914:	00 
80102915:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102919:	89 1c 24             	mov    %ebx,(%esp)
8010291c:	e8 8f 1d 00 00       	call   801046b0 <memcmp>
80102921:	85 c0                	test   %eax,%eax
80102923:	75 c3                	jne    801028e8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102925:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102929:	75 78                	jne    801029a3 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010292b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010292e:	89 c2                	mov    %eax,%edx
80102930:	83 e0 0f             	and    $0xf,%eax
80102933:	c1 ea 04             	shr    $0x4,%edx
80102936:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102939:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010293c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010293f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102942:	89 c2                	mov    %eax,%edx
80102944:	83 e0 0f             	and    $0xf,%eax
80102947:	c1 ea 04             	shr    $0x4,%edx
8010294a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010294d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102950:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102953:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102956:	89 c2                	mov    %eax,%edx
80102958:	83 e0 0f             	and    $0xf,%eax
8010295b:	c1 ea 04             	shr    $0x4,%edx
8010295e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102961:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102964:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102967:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010296a:	89 c2                	mov    %eax,%edx
8010296c:	83 e0 0f             	and    $0xf,%eax
8010296f:	c1 ea 04             	shr    $0x4,%edx
80102972:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102975:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102978:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010297b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010297e:	89 c2                	mov    %eax,%edx
80102980:	83 e0 0f             	and    $0xf,%eax
80102983:	c1 ea 04             	shr    $0x4,%edx
80102986:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102989:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010298c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010298f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102992:	89 c2                	mov    %eax,%edx
80102994:	83 e0 0f             	and    $0xf,%eax
80102997:	c1 ea 04             	shr    $0x4,%edx
8010299a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299d:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a0:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801029a6:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029a9:	89 01                	mov    %eax,(%ecx)
801029ab:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029ae:	89 41 04             	mov    %eax,0x4(%ecx)
801029b1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029b4:	89 41 08             	mov    %eax,0x8(%ecx)
801029b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ba:	89 41 0c             	mov    %eax,0xc(%ecx)
801029bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029c0:	89 41 10             	mov    %eax,0x10(%ecx)
801029c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c6:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
801029c9:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
801029d0:	83 c4 4c             	add    $0x4c,%esp
801029d3:	5b                   	pop    %ebx
801029d4:	5e                   	pop    %esi
801029d5:	5f                   	pop    %edi
801029d6:	5d                   	pop    %ebp
801029d7:	c3                   	ret    
801029d8:	66 90                	xchg   %ax,%ax
801029da:	66 90                	xchg   %ax,%ax
801029dc:	66 90                	xchg   %ax,%ax
801029de:	66 90                	xchg   %ax,%ax

801029e0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029e0:	55                   	push   %ebp
801029e1:	89 e5                	mov    %esp,%ebp
801029e3:	57                   	push   %edi
801029e4:	56                   	push   %esi
801029e5:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029e6:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029e8:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029eb:	a1 e8 26 11 80       	mov    0x801126e8,%eax
801029f0:	85 c0                	test   %eax,%eax
801029f2:	7e 78                	jle    80102a6c <install_trans+0x8c>
801029f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029f8:	a1 d4 26 11 80       	mov    0x801126d4,%eax
801029fd:	01 d8                	add    %ebx,%eax
801029ff:	83 c0 01             	add    $0x1,%eax
80102a02:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a06:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a0b:	89 04 24             	mov    %eax,(%esp)
80102a0e:	e8 bd d6 ff ff       	call   801000d0 <bread>
80102a13:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a15:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a1c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a23:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a28:	89 04 24             	mov    %eax,(%esp)
80102a2b:	e8 a0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a30:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a37:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a38:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a3a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a41:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a44:	89 04 24             	mov    %eax,(%esp)
80102a47:	e8 b4 1c 00 00       	call   80104700 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a4c:	89 34 24             	mov    %esi,(%esp)
80102a4f:	e8 4c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a54:	89 3c 24             	mov    %edi,(%esp)
80102a57:	e8 84 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a5c:	89 34 24             	mov    %esi,(%esp)
80102a5f:	e8 7c d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a64:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102a6a:	7f 8c                	jg     801029f8 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a6c:	83 c4 1c             	add    $0x1c,%esp
80102a6f:	5b                   	pop    %ebx
80102a70:	5e                   	pop    %esi
80102a71:	5f                   	pop    %edi
80102a72:	5d                   	pop    %ebp
80102a73:	c3                   	ret    
80102a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	57                   	push   %edi
80102a84:	56                   	push   %esi
80102a85:	53                   	push   %ebx
80102a86:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a89:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a92:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102a97:	89 04 24             	mov    %eax,(%esp)
80102a9a:	e8 31 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a9f:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102aa5:	31 d2                	xor    %edx,%edx
80102aa7:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aa9:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102aab:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102aae:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ab1:	7e 17                	jle    80102aca <write_head+0x4a>
80102ab3:	90                   	nop
80102ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ab8:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102abf:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ac3:	83 c2 01             	add    $0x1,%edx
80102ac6:	39 da                	cmp    %ebx,%edx
80102ac8:	75 ee                	jne    80102ab8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102aca:	89 3c 24             	mov    %edi,(%esp)
80102acd:	e8 ce d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ad2:	89 3c 24             	mov    %edi,(%esp)
80102ad5:	e8 06 d7 ff ff       	call   801001e0 <brelse>
}
80102ada:	83 c4 1c             	add    $0x1c,%esp
80102add:	5b                   	pop    %ebx
80102ade:	5e                   	pop    %esi
80102adf:	5f                   	pop    %edi
80102ae0:	5d                   	pop    %ebp
80102ae1:	c3                   	ret    
80102ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102af0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102af0:	55                   	push   %ebp
80102af1:	89 e5                	mov    %esp,%ebp
80102af3:	56                   	push   %esi
80102af4:	53                   	push   %ebx
80102af5:	83 ec 30             	sub    $0x30,%esp
80102af8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102afb:	c7 44 24 04 7c 75 10 	movl   $0x8010757c,0x4(%esp)
80102b02:	80 
80102b03:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102b0a:	e8 51 19 00 00       	call   80104460 <initlock>
  readsb(dev, &sb);
80102b0f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b12:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b16:	89 1c 24             	mov    %ebx,(%esp)
80102b19:	e8 82 e8 ff ff       	call   801013a0 <readsb>
  log.start = sb.logstart;
80102b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b21:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b24:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b27:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b2d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b31:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b37:	a3 d4 26 11 80       	mov    %eax,0x801126d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b3c:	e8 8f d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b41:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b43:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b46:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b49:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b4b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102b51:	7e 17                	jle    80102b6a <initlog+0x7a>
80102b53:	90                   	nop
80102b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b58:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b5c:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b63:	83 c2 01             	add    $0x1,%edx
80102b66:	39 da                	cmp    %ebx,%edx
80102b68:	75 ee                	jne    80102b58 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b6a:	89 04 24             	mov    %eax,(%esp)
80102b6d:	e8 6e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b72:	e8 69 fe ff ff       	call   801029e0 <install_trans>
  log.lh.n = 0;
80102b77:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102b7e:	00 00 00 
  write_head(); // clear the log
80102b81:	e8 fa fe ff ff       	call   80102a80 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b86:	83 c4 30             	add    $0x30,%esp
80102b89:	5b                   	pop    %ebx
80102b8a:	5e                   	pop    %esi
80102b8b:	5d                   	pop    %ebp
80102b8c:	c3                   	ret    
80102b8d:	8d 76 00             	lea    0x0(%esi),%esi

80102b90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b96:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102b9d:	e8 3e 19 00 00       	call   801044e0 <acquire>
80102ba2:	eb 18                	jmp    80102bbc <begin_op+0x2c>
80102ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ba8:	c7 44 24 04 a0 26 11 	movl   $0x801126a0,0x4(%esp)
80102baf:	80 
80102bb0:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102bb7:	e8 84 12 00 00       	call   80103e40 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bbc:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102bc1:	85 c0                	test   %eax,%eax
80102bc3:	75 e3                	jne    80102ba8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bc5:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102bca:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102bd0:	83 c0 01             	add    $0x1,%eax
80102bd3:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bd6:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bd9:	83 fa 1e             	cmp    $0x1e,%edx
80102bdc:	7f ca                	jg     80102ba8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bde:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102be5:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102bea:	e8 21 1a 00 00       	call   80104610 <release>
      break;
    }
  }
}
80102bef:	c9                   	leave  
80102bf0:	c3                   	ret    
80102bf1:	eb 0d                	jmp    80102c00 <end_op>
80102bf3:	90                   	nop
80102bf4:	90                   	nop
80102bf5:	90                   	nop
80102bf6:	90                   	nop
80102bf7:	90                   	nop
80102bf8:	90                   	nop
80102bf9:	90                   	nop
80102bfa:	90                   	nop
80102bfb:	90                   	nop
80102bfc:	90                   	nop
80102bfd:	90                   	nop
80102bfe:	90                   	nop
80102bff:	90                   	nop

80102c00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c00:	55                   	push   %ebp
80102c01:	89 e5                	mov    %esp,%ebp
80102c03:	57                   	push   %edi
80102c04:	56                   	push   %esi
80102c05:	53                   	push   %ebx
80102c06:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c09:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c10:	e8 cb 18 00 00       	call   801044e0 <acquire>
  log.outstanding -= 1;
80102c15:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c1a:	8b 15 e0 26 11 80    	mov    0x801126e0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c20:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c23:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c25:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102c2a:	0f 85 f3 00 00 00    	jne    80102d23 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c30:	85 c0                	test   %eax,%eax
80102c32:	0f 85 cb 00 00 00    	jne    80102d03 <end_op+0x103>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c38:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c3f:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c41:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c48:	00 00 00 
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4b:	e8 c0 19 00 00       	call   80104610 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c50:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c55:	85 c0                	test   %eax,%eax
80102c57:	0f 8e 90 00 00 00    	jle    80102ced <end_op+0xed>
80102c5d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c60:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c65:	01 d8                	add    %ebx,%eax
80102c67:	83 c0 01             	add    $0x1,%eax
80102c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c6e:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102c73:	89 04 24             	mov    %eax,(%esp)
80102c76:	e8 55 d4 ff ff       	call   801000d0 <bread>
80102c7b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c7d:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c84:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c87:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c8b:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102c90:	89 04 24             	mov    %eax,(%esp)
80102c93:	e8 38 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c98:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c9f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ca0:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca2:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ca9:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cac:	89 04 24             	mov    %eax,(%esp)
80102caf:	e8 4c 1a 00 00       	call   80104700 <memmove>
    bwrite(to);  // write the log
80102cb4:	89 34 24             	mov    %esi,(%esp)
80102cb7:	e8 e4 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cbc:	89 3c 24             	mov    %edi,(%esp)
80102cbf:	e8 1c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cc4:	89 34 24             	mov    %esi,(%esp)
80102cc7:	e8 14 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ccc:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102cd2:	7c 8c                	jl     80102c60 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cd4:	e8 a7 fd ff ff       	call   80102a80 <write_head>
    install_trans(); // Now install writes to home locations
80102cd9:	e8 02 fd ff ff       	call   801029e0 <install_trans>
    log.lh.n = 0;
80102cde:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102ce5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ce8:	e8 93 fd ff ff       	call   80102a80 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102ced:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102cf4:	e8 e7 17 00 00       	call   801044e0 <acquire>
    log.committing = 0;
80102cf9:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102d00:	00 00 00 
    wakeup(&log);
80102d03:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d0a:	e8 e1 12 00 00       	call   80103ff0 <wakeup>
    release(&log.lock);
80102d0f:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d16:	e8 f5 18 00 00       	call   80104610 <release>
  }
}
80102d1b:	83 c4 1c             	add    $0x1c,%esp
80102d1e:	5b                   	pop    %ebx
80102d1f:	5e                   	pop    %esi
80102d20:	5f                   	pop    %edi
80102d21:	5d                   	pop    %ebp
80102d22:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d23:	c7 04 24 80 75 10 80 	movl   $0x80107580,(%esp)
80102d2a:	e8 31 d6 ff ff       	call   80100360 <panic>
80102d2f:	90                   	nop

80102d30 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d37:	a1 e8 26 11 80       	mov    0x801126e8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d3f:	83 f8 1d             	cmp    $0x1d,%eax
80102d42:	0f 8f 98 00 00 00    	jg     80102de0 <log_write+0xb0>
80102d48:	8b 0d d8 26 11 80    	mov    0x801126d8,%ecx
80102d4e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d51:	39 d0                	cmp    %edx,%eax
80102d53:	0f 8d 87 00 00 00    	jge    80102de0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d59:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d5e:	85 c0                	test   %eax,%eax
80102d60:	0f 8e 86 00 00 00    	jle    80102dec <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d66:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d6d:	e8 6e 17 00 00       	call   801044e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d72:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102d78:	83 fa 00             	cmp    $0x0,%edx
80102d7b:	7e 54                	jle    80102dd1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d7d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d80:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d82:	39 0d ec 26 11 80    	cmp    %ecx,0x801126ec
80102d88:	75 0f                	jne    80102d99 <log_write+0x69>
80102d8a:	eb 3c                	jmp    80102dc8 <log_write+0x98>
80102d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d90:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102d97:	74 2f                	je     80102dc8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d99:	83 c0 01             	add    $0x1,%eax
80102d9c:	39 d0                	cmp    %edx,%eax
80102d9e:	75 f0                	jne    80102d90 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102da0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102da7:	83 c2 01             	add    $0x1,%edx
80102daa:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102db0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102db3:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102dba:	83 c4 14             	add    $0x14,%esp
80102dbd:	5b                   	pop    %ebx
80102dbe:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dbf:	e9 4c 18 00 00       	jmp    80104610 <release>
80102dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102dc8:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102dcf:	eb df                	jmp    80102db0 <log_write+0x80>
80102dd1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dd4:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102dd9:	75 d5                	jne    80102db0 <log_write+0x80>
80102ddb:	eb ca                	jmp    80102da7 <log_write+0x77>
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102de0:	c7 04 24 8f 75 10 80 	movl   $0x8010758f,(%esp)
80102de7:	e8 74 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102dec:	c7 04 24 a5 75 10 80 	movl   $0x801075a5,(%esp)
80102df3:	e8 68 d5 ff ff       	call   80100360 <panic>
80102df8:	66 90                	xchg   %ax,%ax
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102e06:	e8 55 f9 ff ff       	call   80102760 <cpunum>
80102e0b:	c7 04 24 c0 75 10 80 	movl   $0x801075c0,(%esp)
80102e12:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e16:	e8 35 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102e1b:	e8 20 2b 00 00       	call   80105940 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102e20:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e27:	b8 01 00 00 00       	mov    $0x1,%eax
80102e2c:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102e33:	e8 b8 0c 00 00       	call   80103af0 <scheduler>
80102e38:	90                   	nop
80102e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e40 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e46:	e8 e5 3c 00 00       	call   80106b30 <switchkvm>
  seginit();
80102e4b:	e8 00 3b 00 00       	call   80106950 <seginit>
  lapicinit();
80102e50:	e8 1b f8 ff ff       	call   80102670 <lapicinit>
  mpmain();
80102e55:	e8 a6 ff ff ff       	call   80102e00 <mpmain>
80102e5a:	66 90                	xchg   %ax,%ax
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	53                   	push   %ebx
80102e64:	83 e4 f0             	and    $0xfffffff0,%esp
80102e67:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e6a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e71:	80 
80102e72:	c7 04 24 28 57 11 80 	movl   $0x80115728,(%esp)
80102e79:	e8 62 f5 ff ff       	call   801023e0 <kinit1>
  kvmalloc();      // kernel page table
80102e7e:	e8 8d 3c 00 00       	call   80106b10 <kvmalloc>
  mpinit();        // detect other processors
80102e83:	e8 a8 01 00 00       	call   80103030 <mpinit>
  lapicinit();     // interrupt controller
80102e88:	e8 e3 f7 ff ff       	call   80102670 <lapicinit>
80102e8d:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80102e90:	e8 bb 3a 00 00       	call   80106950 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102e95:	e8 c6 f8 ff ff       	call   80102760 <cpunum>
80102e9a:	c7 04 24 d1 75 10 80 	movl   $0x801075d1,(%esp)
80102ea1:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ea5:	e8 a6 d7 ff ff       	call   80100650 <cprintf>
  picinit();       // another interrupt controller
80102eaa:	e8 81 03 00 00       	call   80103230 <picinit>
  ioapicinit();    // another interrupt controller
80102eaf:	e8 4c f3 ff ff       	call   80102200 <ioapicinit>
  consoleinit();   // console hardware
80102eb4:	e8 97 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102eb9:	e8 a2 2d 00 00       	call   80105c60 <uartinit>
80102ebe:	66 90                	xchg   %ax,%ax
  pinit();         // process table
80102ec0:	e8 ab 08 00 00       	call   80103770 <pinit>
  tvinit();        // trap vectors
80102ec5:	e8 d6 29 00 00       	call   801058a0 <tvinit>
  binit();         // buffer cache
80102eca:	e8 71 d1 ff ff       	call   80100040 <binit>
80102ecf:	90                   	nop
  fileinit();      // file table
80102ed0:	e8 7b de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk
80102ed5:	e8 16 f1 ff ff       	call   80101ff0 <ideinit>
  if(!ismp)
80102eda:	a1 84 27 11 80       	mov    0x80112784,%eax
80102edf:	85 c0                	test   %eax,%eax
80102ee1:	0f 84 ca 00 00 00    	je     80102fb1 <main+0x151>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ee7:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102eee:	00 

  for(c = cpus; c < cpus+ncpu; c++){
80102eef:	bb a0 27 11 80       	mov    $0x801127a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ef4:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102efb:	80 
80102efc:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102f03:	e8 f8 17 00 00       	call   80104700 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f08:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f0f:	00 00 00 
80102f12:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f17:	39 d8                	cmp    %ebx,%eax
80102f19:	76 78                	jbe    80102f93 <main+0x133>
80102f1b:	90                   	nop
80102f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
80102f20:	e8 3b f8 ff ff       	call   80102760 <cpunum>
80102f25:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102f2b:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f30:	39 c3                	cmp    %eax,%ebx
80102f32:	74 46                	je     80102f7a <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f34:	e8 67 f5 ff ff       	call   801024a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f39:	c7 05 f8 6f 00 80 40 	movl   $0x80102e40,0x80006ff8
80102f40:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f43:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f4a:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f4d:	05 00 10 00 00       	add    $0x1000,%eax
80102f52:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f57:	0f b6 03             	movzbl (%ebx),%eax
80102f5a:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f61:	00 
80102f62:	89 04 24             	mov    %eax,(%esp)
80102f65:	e8 c6 f8 ff ff       	call   80102830 <lapicstartap>
80102f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f70:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102f76:	85 c0                	test   %eax,%eax
80102f78:	74 f6                	je     80102f70 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f7a:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f81:	00 00 00 
80102f84:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102f8a:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f8f:	39 c3                	cmp    %eax,%ebx
80102f91:	72 8d                	jb     80102f20 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f93:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f9a:	8e 
80102f9b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102fa2:	e8 a9 f4 ff ff       	call   80102450 <kinit2>
  userinit();      // first user process
80102fa7:	e8 e4 07 00 00       	call   80103790 <userinit>
  mpmain();        // finish this processor's setup
80102fac:	e8 4f fe ff ff       	call   80102e00 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80102fb1:	e8 8a 28 00 00       	call   80105840 <timerinit>
80102fb6:	e9 2c ff ff ff       	jmp    80102ee7 <main+0x87>
80102fbb:	66 90                	xchg   %ax,%ax
80102fbd:	66 90                	xchg   %ax,%ax
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fc4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fca:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102fcb:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fce:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd1:	39 de                	cmp    %ebx,%esi
80102fd3:	73 3c                	jae    80103011 <mpsearch1+0x51>
80102fd5:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fd8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fdf:	00 
80102fe0:	c7 44 24 04 e8 75 10 	movl   $0x801075e8,0x4(%esp)
80102fe7:	80 
80102fe8:	89 34 24             	mov    %esi,(%esp)
80102feb:	e8 c0 16 00 00       	call   801046b0 <memcmp>
80102ff0:	85 c0                	test   %eax,%eax
80102ff2:	75 16                	jne    8010300a <mpsearch1+0x4a>
80102ff4:	31 c9                	xor    %ecx,%ecx
80102ff6:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102ff8:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102ffc:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102fff:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103001:	83 fa 10             	cmp    $0x10,%edx
80103004:	75 f2                	jne    80102ff8 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103006:	84 c9                	test   %cl,%cl
80103008:	74 10                	je     8010301a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
8010300a:	83 c6 10             	add    $0x10,%esi
8010300d:	39 f3                	cmp    %esi,%ebx
8010300f:	77 c7                	ja     80102fd8 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80103011:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103014:	31 c0                	xor    %eax,%eax
}
80103016:	5b                   	pop    %ebx
80103017:	5e                   	pop    %esi
80103018:	5d                   	pop    %ebp
80103019:	c3                   	ret    
8010301a:	83 c4 10             	add    $0x10,%esp
8010301d:	89 f0                	mov    %esi,%eax
8010301f:	5b                   	pop    %ebx
80103020:	5e                   	pop    %esi
80103021:	5d                   	pop    %ebp
80103022:	c3                   	ret    
80103023:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103030 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	57                   	push   %edi
80103034:	56                   	push   %esi
80103035:	53                   	push   %ebx
80103036:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103039:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103040:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103047:	c1 e0 08             	shl    $0x8,%eax
8010304a:	09 d0                	or     %edx,%eax
8010304c:	c1 e0 04             	shl    $0x4,%eax
8010304f:	85 c0                	test   %eax,%eax
80103051:	75 1b                	jne    8010306e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103053:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010305a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103061:	c1 e0 08             	shl    $0x8,%eax
80103064:	09 d0                	or     %edx,%eax
80103066:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103069:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010306e:	ba 00 04 00 00       	mov    $0x400,%edx
80103073:	e8 48 ff ff ff       	call   80102fc0 <mpsearch1>
80103078:	85 c0                	test   %eax,%eax
8010307a:	89 c7                	mov    %eax,%edi
8010307c:	0f 84 4e 01 00 00    	je     801031d0 <mpinit+0x1a0>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103082:	8b 77 04             	mov    0x4(%edi),%esi
80103085:	85 f6                	test   %esi,%esi
80103087:	0f 84 ce 00 00 00    	je     8010315b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010308d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103093:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010309a:	00 
8010309b:	c7 44 24 04 ed 75 10 	movl   $0x801075ed,0x4(%esp)
801030a2:	80 
801030a3:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801030a9:	e8 02 16 00 00       	call   801046b0 <memcmp>
801030ae:	85 c0                	test   %eax,%eax
801030b0:	0f 85 a5 00 00 00    	jne    8010315b <mpinit+0x12b>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801030b6:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801030bd:	3c 04                	cmp    $0x4,%al
801030bf:	0f 85 29 01 00 00    	jne    801031ee <mpinit+0x1be>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030c5:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030cc:	85 c0                	test   %eax,%eax
801030ce:	74 1d                	je     801030ed <mpinit+0xbd>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
801030d0:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
801030d2:	31 d2                	xor    %edx,%edx
801030d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030d8:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
801030df:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030e0:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801030e3:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030e5:	39 d0                	cmp    %edx,%eax
801030e7:	7f ef                	jg     801030d8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030e9:	84 c9                	test   %cl,%cl
801030eb:	75 6e                	jne    8010315b <mpinit+0x12b>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030ed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801030f0:	85 db                	test   %ebx,%ebx
801030f2:	74 67                	je     8010315b <mpinit+0x12b>
    return;
  ismp = 1;
801030f4:	c7 05 84 27 11 80 01 	movl   $0x1,0x80112784
801030fb:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801030fe:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103104:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103109:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
80103110:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103116:	01 d9                	add    %ebx,%ecx
80103118:	39 c8                	cmp    %ecx,%eax
8010311a:	0f 83 90 00 00 00    	jae    801031b0 <mpinit+0x180>
    switch(*p){
80103120:	80 38 04             	cmpb   $0x4,(%eax)
80103123:	77 7b                	ja     801031a0 <mpinit+0x170>
80103125:	0f b6 10             	movzbl (%eax),%edx
80103128:	ff 24 95 f4 75 10 80 	jmp    *-0x7fef8a0c(,%edx,4)
8010312f:	90                   	nop
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103130:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103133:	39 c1                	cmp    %eax,%ecx
80103135:	77 e9                	ja     80103120 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103137:	a1 84 27 11 80       	mov    0x80112784,%eax
8010313c:	85 c0                	test   %eax,%eax
8010313e:	75 70                	jne    801031b0 <mpinit+0x180>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103140:	c7 05 80 2d 11 80 01 	movl   $0x1,0x80112d80
80103147:	00 00 00 
    lapic = 0;
8010314a:	c7 05 9c 26 11 80 00 	movl   $0x0,0x8011269c
80103151:	00 00 00 
    ioapicid = 0;
80103154:	c6 05 80 27 11 80 00 	movb   $0x0,0x80112780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010315b:	83 c4 1c             	add    $0x1c,%esp
8010315e:	5b                   	pop    %ebx
8010315f:	5e                   	pop    %esi
80103160:	5f                   	pop    %edi
80103161:	5d                   	pop    %ebp
80103162:	c3                   	ret    
80103163:	90                   	nop
80103164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103168:	8b 15 80 2d 11 80    	mov    0x80112d80,%edx
8010316e:	83 fa 07             	cmp    $0x7,%edx
80103171:	7f 17                	jg     8010318a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103173:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
80103177:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
        ncpu++;
8010317d:	83 05 80 2d 11 80 01 	addl   $0x1,0x80112d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103184:	88 9a a0 27 11 80    	mov    %bl,-0x7feed860(%edx)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010318a:	83 c0 14             	add    $0x14,%eax
      continue;
8010318d:	eb a4                	jmp    80103133 <mpinit+0x103>
8010318f:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103190:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103194:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103197:	88 15 80 27 11 80    	mov    %dl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
8010319d:	eb 94                	jmp    80103133 <mpinit+0x103>
8010319f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031a0:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
801031a7:	00 00 00 
      break;
801031aa:	eb 87                	jmp    80103133 <mpinit+0x103>
801031ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
801031b0:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801031b4:	74 a5                	je     8010315b <mpinit+0x12b>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031b6:	ba 22 00 00 00       	mov    $0x22,%edx
801031bb:	b8 70 00 00 00       	mov    $0x70,%eax
801031c0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031c1:	b2 23                	mov    $0x23,%dl
801031c3:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031c4:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031c7:	ee                   	out    %al,(%dx)
  }
}
801031c8:	83 c4 1c             	add    $0x1c,%esp
801031cb:	5b                   	pop    %ebx
801031cc:	5e                   	pop    %esi
801031cd:	5f                   	pop    %edi
801031ce:	5d                   	pop    %ebp
801031cf:	c3                   	ret    
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031df:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031e1:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031e3:	0f 85 99 fe ff ff    	jne    80103082 <mpinit+0x52>
801031e9:	e9 6d ff ff ff       	jmp    8010315b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
801031ee:	3c 01                	cmp    $0x1,%al
801031f0:	0f 84 cf fe ff ff    	je     801030c5 <mpinit+0x95>
801031f6:	e9 60 ff ff ff       	jmp    8010315b <mpinit+0x12b>
801031fb:	66 90                	xchg   %ax,%ax
801031fd:	66 90                	xchg   %ax,%ax
801031ff:	90                   	nop

80103200 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103200:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103201:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103206:	89 e5                	mov    %esp,%ebp
80103208:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
8010320d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103210:	d3 c0                	rol    %cl,%eax
80103212:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80103219:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
8010321f:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
80103220:	66 c1 e8 08          	shr    $0x8,%ax
80103224:	b2 a1                	mov    $0xa1,%dl
80103226:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
80103227:	5d                   	pop    %ebp
80103228:	c3                   	ret    
80103229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103230 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103230:	55                   	push   %ebp
80103231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103236:	89 e5                	mov    %esp,%ebp
80103238:	57                   	push   %edi
80103239:	56                   	push   %esi
8010323a:	53                   	push   %ebx
8010323b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103240:	89 da                	mov    %ebx,%edx
80103242:	ee                   	out    %al,(%dx)
80103243:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103248:	89 ca                	mov    %ecx,%edx
8010324a:	ee                   	out    %al,(%dx)
8010324b:	bf 11 00 00 00       	mov    $0x11,%edi
80103250:	be 20 00 00 00       	mov    $0x20,%esi
80103255:	89 f8                	mov    %edi,%eax
80103257:	89 f2                	mov    %esi,%edx
80103259:	ee                   	out    %al,(%dx)
8010325a:	b8 20 00 00 00       	mov    $0x20,%eax
8010325f:	89 da                	mov    %ebx,%edx
80103261:	ee                   	out    %al,(%dx)
80103262:	b8 04 00 00 00       	mov    $0x4,%eax
80103267:	ee                   	out    %al,(%dx)
80103268:	b8 03 00 00 00       	mov    $0x3,%eax
8010326d:	ee                   	out    %al,(%dx)
8010326e:	b3 a0                	mov    $0xa0,%bl
80103270:	89 f8                	mov    %edi,%eax
80103272:	89 da                	mov    %ebx,%edx
80103274:	ee                   	out    %al,(%dx)
80103275:	b8 28 00 00 00       	mov    $0x28,%eax
8010327a:	89 ca                	mov    %ecx,%edx
8010327c:	ee                   	out    %al,(%dx)
8010327d:	b8 02 00 00 00       	mov    $0x2,%eax
80103282:	ee                   	out    %al,(%dx)
80103283:	b8 03 00 00 00       	mov    $0x3,%eax
80103288:	ee                   	out    %al,(%dx)
80103289:	bf 68 00 00 00       	mov    $0x68,%edi
8010328e:	89 f2                	mov    %esi,%edx
80103290:	89 f8                	mov    %edi,%eax
80103292:	ee                   	out    %al,(%dx)
80103293:	b9 0a 00 00 00       	mov    $0xa,%ecx
80103298:	89 c8                	mov    %ecx,%eax
8010329a:	ee                   	out    %al,(%dx)
8010329b:	89 f8                	mov    %edi,%eax
8010329d:	89 da                	mov    %ebx,%edx
8010329f:	ee                   	out    %al,(%dx)
801032a0:	89 c8                	mov    %ecx,%eax
801032a2:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
801032a3:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
801032aa:	66 83 f8 ff          	cmp    $0xffff,%ax
801032ae:	74 0a                	je     801032ba <picinit+0x8a>
801032b0:	b2 21                	mov    $0x21,%dl
801032b2:	ee                   	out    %al,(%dx)
static void
picsetmask(ushort mask)
{
  irqmask = mask;
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
801032b3:	66 c1 e8 08          	shr    $0x8,%ax
801032b7:	b2 a1                	mov    $0xa1,%dl
801032b9:	ee                   	out    %al,(%dx)
  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    picsetmask(irqmask);
}
801032ba:	5b                   	pop    %ebx
801032bb:	5e                   	pop    %esi
801032bc:	5f                   	pop    %edi
801032bd:	5d                   	pop    %ebp
801032be:	c3                   	ret    
801032bf:	90                   	nop

801032c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	57                   	push   %edi
801032c4:	56                   	push   %esi
801032c5:	53                   	push   %ebx
801032c6:	83 ec 1c             	sub    $0x1c,%esp
801032c9:	8b 75 08             	mov    0x8(%ebp),%esi
801032cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801032d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032db:	e8 90 da ff ff       	call   80100d70 <filealloc>
801032e0:	85 c0                	test   %eax,%eax
801032e2:	89 06                	mov    %eax,(%esi)
801032e4:	0f 84 a4 00 00 00    	je     8010338e <pipealloc+0xce>
801032ea:	e8 81 da ff ff       	call   80100d70 <filealloc>
801032ef:	85 c0                	test   %eax,%eax
801032f1:	89 03                	mov    %eax,(%ebx)
801032f3:	0f 84 87 00 00 00    	je     80103380 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032f9:	e8 a2 f1 ff ff       	call   801024a0 <kalloc>
801032fe:	85 c0                	test   %eax,%eax
80103300:	89 c7                	mov    %eax,%edi
80103302:	74 7c                	je     80103380 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103304:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010330b:	00 00 00 
  p->writeopen = 1;
8010330e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103315:	00 00 00 
  p->nwrite = 0;
80103318:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010331f:	00 00 00 
  p->nread = 0;
80103322:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103329:	00 00 00 
  initlock(&p->lock, "pipe");
8010332c:	89 04 24             	mov    %eax,(%esp)
8010332f:	c7 44 24 04 08 76 10 	movl   $0x80107608,0x4(%esp)
80103336:	80 
80103337:	e8 24 11 00 00       	call   80104460 <initlock>
  (*f0)->type = FD_PIPE;
8010333c:	8b 06                	mov    (%esi),%eax
8010333e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103344:	8b 06                	mov    (%esi),%eax
80103346:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010334a:	8b 06                	mov    (%esi),%eax
8010334c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103350:	8b 06                	mov    (%esi),%eax
80103352:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103355:	8b 03                	mov    (%ebx),%eax
80103357:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010335d:	8b 03                	mov    (%ebx),%eax
8010335f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103363:	8b 03                	mov    (%ebx),%eax
80103365:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103369:	8b 03                	mov    (%ebx),%eax
  return 0;
8010336b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010336d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103370:	83 c4 1c             	add    $0x1c,%esp
80103373:	89 d8                	mov    %ebx,%eax
80103375:	5b                   	pop    %ebx
80103376:	5e                   	pop    %esi
80103377:	5f                   	pop    %edi
80103378:	5d                   	pop    %ebp
80103379:	c3                   	ret    
8010337a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103380:	8b 06                	mov    (%esi),%eax
80103382:	85 c0                	test   %eax,%eax
80103384:	74 08                	je     8010338e <pipealloc+0xce>
    fileclose(*f0);
80103386:	89 04 24             	mov    %eax,(%esp)
80103389:	e8 a2 da ff ff       	call   80100e30 <fileclose>
  if(*f1)
8010338e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103390:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103395:	85 c0                	test   %eax,%eax
80103397:	74 d7                	je     80103370 <pipealloc+0xb0>
    fileclose(*f1);
80103399:	89 04 24             	mov    %eax,(%esp)
8010339c:	e8 8f da ff ff       	call   80100e30 <fileclose>
  return -1;
}
801033a1:	83 c4 1c             	add    $0x1c,%esp
801033a4:	89 d8                	mov    %ebx,%eax
801033a6:	5b                   	pop    %ebx
801033a7:	5e                   	pop    %esi
801033a8:	5f                   	pop    %edi
801033a9:	5d                   	pop    %ebp
801033aa:	c3                   	ret    
801033ab:	90                   	nop
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033b0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	56                   	push   %esi
801033b4:	53                   	push   %ebx
801033b5:	83 ec 10             	sub    $0x10,%esp
801033b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033be:	89 1c 24             	mov    %ebx,(%esp)
801033c1:	e8 1a 11 00 00       	call   801044e0 <acquire>
  if(writable){
801033c6:	85 f6                	test   %esi,%esi
801033c8:	74 3e                	je     80103408 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801033ca:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801033d0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033d7:	00 00 00 
    wakeup(&p->nread);
801033da:	89 04 24             	mov    %eax,(%esp)
801033dd:	e8 0e 0c 00 00       	call   80103ff0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033e2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033e8:	85 d2                	test   %edx,%edx
801033ea:	75 0a                	jne    801033f6 <pipeclose+0x46>
801033ec:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033f2:	85 c0                	test   %eax,%eax
801033f4:	74 32                	je     80103428 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	5b                   	pop    %ebx
801033fd:	5e                   	pop    %esi
801033fe:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033ff:	e9 0c 12 00 00       	jmp    80104610 <release>
80103404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103408:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
8010340e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103415:	00 00 00 
    wakeup(&p->nwrite);
80103418:	89 04 24             	mov    %eax,(%esp)
8010341b:	e8 d0 0b 00 00       	call   80103ff0 <wakeup>
80103420:	eb c0                	jmp    801033e2 <pipeclose+0x32>
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103428:	89 1c 24             	mov    %ebx,(%esp)
8010342b:	e8 e0 11 00 00       	call   80104610 <release>
    kfree((char*)p);
80103430:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103433:	83 c4 10             	add    $0x10,%esp
80103436:	5b                   	pop    %ebx
80103437:	5e                   	pop    %esi
80103438:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103439:	e9 b2 ee ff ff       	jmp    801022f0 <kfree>
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 1c             	sub    $0x1c,%esp
80103449:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010344c:	89 3c 24             	mov    %edi,(%esp)
8010344f:	e8 8c 10 00 00       	call   801044e0 <acquire>
  for(i = 0; i < n; i++){
80103454:	8b 45 10             	mov    0x10(%ebp),%eax
80103457:	85 c0                	test   %eax,%eax
80103459:	0f 8e c2 00 00 00    	jle    80103521 <pipewrite+0xe1>
8010345f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103462:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
80103468:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
8010346e:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103474:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103477:	03 45 10             	add    0x10(%ebp),%eax
8010347a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010347d:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103483:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80103489:	39 d1                	cmp    %edx,%ecx
8010348b:	0f 85 c4 00 00 00    	jne    80103555 <pipewrite+0x115>
      if(p->readopen == 0 || proc->killed){
80103491:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
80103497:	85 d2                	test   %edx,%edx
80103499:	0f 84 a1 00 00 00    	je     80103540 <pipewrite+0x100>
8010349f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801034a6:	8b 42 24             	mov    0x24(%edx),%eax
801034a9:	85 c0                	test   %eax,%eax
801034ab:	74 22                	je     801034cf <pipewrite+0x8f>
801034ad:	e9 8e 00 00 00       	jmp    80103540 <pipewrite+0x100>
801034b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034b8:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
801034be:	85 c0                	test   %eax,%eax
801034c0:	74 7e                	je     80103540 <pipewrite+0x100>
801034c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801034c8:	8b 48 24             	mov    0x24(%eax),%ecx
801034cb:	85 c9                	test   %ecx,%ecx
801034cd:	75 71                	jne    80103540 <pipewrite+0x100>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034cf:	89 34 24             	mov    %esi,(%esp)
801034d2:	e8 19 0b 00 00       	call   80103ff0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
801034db:	89 1c 24             	mov    %ebx,(%esp)
801034de:	e8 5d 09 00 00       	call   80103e40 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034e3:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801034e9:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801034ef:	05 00 02 00 00       	add    $0x200,%eax
801034f4:	39 c2                	cmp    %eax,%edx
801034f6:	74 c0                	je     801034b8 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034fb:	8d 4a 01             	lea    0x1(%edx),%ecx
801034fe:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103504:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
8010350a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010350e:	0f b6 00             	movzbl (%eax),%eax
80103511:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103515:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103518:	3b 45 e0             	cmp    -0x20(%ebp),%eax
8010351b:	0f 85 5c ff ff ff    	jne    8010347d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103521:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
80103527:	89 14 24             	mov    %edx,(%esp)
8010352a:	e8 c1 0a 00 00       	call   80103ff0 <wakeup>
  release(&p->lock);
8010352f:	89 3c 24             	mov    %edi,(%esp)
80103532:	e8 d9 10 00 00       	call   80104610 <release>
  return n;
80103537:	8b 45 10             	mov    0x10(%ebp),%eax
8010353a:	eb 11                	jmp    8010354d <pipewrite+0x10d>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103540:	89 3c 24             	mov    %edi,(%esp)
80103543:	e8 c8 10 00 00       	call   80104610 <release>
        return -1;
80103548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010354d:	83 c4 1c             	add    $0x1c,%esp
80103550:	5b                   	pop    %ebx
80103551:	5e                   	pop    %esi
80103552:	5f                   	pop    %edi
80103553:	5d                   	pop    %ebp
80103554:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103555:	89 ca                	mov    %ecx,%edx
80103557:	eb 9f                	jmp    801034f8 <pipewrite+0xb8>
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103560 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	57                   	push   %edi
80103564:	56                   	push   %esi
80103565:	53                   	push   %ebx
80103566:	83 ec 1c             	sub    $0x1c,%esp
80103569:	8b 75 08             	mov    0x8(%ebp),%esi
8010356c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010356f:	89 34 24             	mov    %esi,(%esp)
80103572:	e8 69 0f 00 00       	call   801044e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103577:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010357d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103583:	75 5b                	jne    801035e0 <piperead+0x80>
80103585:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010358b:	85 db                	test   %ebx,%ebx
8010358d:	74 51                	je     801035e0 <piperead+0x80>
8010358f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103595:	eb 25                	jmp    801035bc <piperead+0x5c>
80103597:	90                   	nop
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103598:	89 74 24 04          	mov    %esi,0x4(%esp)
8010359c:	89 1c 24             	mov    %ebx,(%esp)
8010359f:	e8 9c 08 00 00       	call   80103e40 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035a4:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801035aa:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801035b0:	75 2e                	jne    801035e0 <piperead+0x80>
801035b2:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035b8:	85 d2                	test   %edx,%edx
801035ba:	74 24                	je     801035e0 <piperead+0x80>
    if(proc->killed){
801035bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801035c2:	8b 48 24             	mov    0x24(%eax),%ecx
801035c5:	85 c9                	test   %ecx,%ecx
801035c7:	74 cf                	je     80103598 <piperead+0x38>
      release(&p->lock);
801035c9:	89 34 24             	mov    %esi,(%esp)
801035cc:	e8 3f 10 00 00       	call   80104610 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035d1:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
801035d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035d9:	5b                   	pop    %ebx
801035da:	5e                   	pop    %esi
801035db:	5f                   	pop    %edi
801035dc:	5d                   	pop    %ebp
801035dd:	c3                   	ret    
801035de:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035e0:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
801035e3:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035e5:	85 d2                	test   %edx,%edx
801035e7:	7f 2b                	jg     80103614 <piperead+0xb4>
801035e9:	eb 31                	jmp    8010361c <piperead+0xbc>
801035eb:	90                   	nop
801035ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035f0:	8d 48 01             	lea    0x1(%eax),%ecx
801035f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801035f8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801035fe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103603:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103606:	83 c3 01             	add    $0x1,%ebx
80103609:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010360c:	74 0e                	je     8010361c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010360e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103614:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010361a:	75 d4                	jne    801035f0 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010361c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103622:	89 04 24             	mov    %eax,(%esp)
80103625:	e8 c6 09 00 00       	call   80103ff0 <wakeup>
  release(&p->lock);
8010362a:	89 34 24             	mov    %esi,(%esp)
8010362d:	e8 de 0f 00 00       	call   80104610 <release>
  return i;
}
80103632:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
80103635:	89 d8                	mov    %ebx,%eax
}
80103637:	5b                   	pop    %ebx
80103638:	5e                   	pop    %esi
80103639:	5f                   	pop    %edi
8010363a:	5d                   	pop    %ebp
8010363b:	c3                   	ret    
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103644:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103649:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010364c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103653:	e8 88 0e 00 00       	call   801044e0 <acquire>
80103658:	eb 18                	jmp    80103672 <allocproc+0x32>
8010365a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103660:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103666:	81 fb d4 4e 11 80    	cmp    $0x80114ed4,%ebx
8010366c:	0f 84 8e 00 00 00    	je     80103700 <allocproc+0xc0>
    if(p->state == UNUSED)
80103672:	8b 43 0c             	mov    0xc(%ebx),%eax
80103675:	85 c0                	test   %eax,%eax
80103677:	75 e7                	jne    80103660 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103679:	a1 0c a0 10 80       	mov    0x8010a00c,%eax
  p->priority = 10;
  p->tickets =10;

  release(&ptable.lock);
8010367e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103685:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
  p->priority = 10;
8010368c:	c7 43 7c 0a 00 00 00 	movl   $0xa,0x7c(%ebx)
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103693:	8d 50 01             	lea    0x1(%eax),%edx
80103696:	89 15 0c a0 10 80    	mov    %edx,0x8010a00c
8010369c:	89 43 10             	mov    %eax,0x10(%ebx)
  p->priority = 10;
  p->tickets =10;
8010369f:	c7 83 80 00 00 00 0a 	movl   $0xa,0x80(%ebx)
801036a6:	00 00 00 

  release(&ptable.lock);
801036a9:	e8 62 0f 00 00       	call   80104610 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036ae:	e8 ed ed ff ff       	call   801024a0 <kalloc>
801036b3:	85 c0                	test   %eax,%eax
801036b5:	89 43 08             	mov    %eax,0x8(%ebx)
801036b8:	74 5a                	je     80103714 <allocproc+0xd4>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036ba:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801036c0:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036c5:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801036c8:	c7 40 14 8d 58 10 80 	movl   $0x8010588d,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036cf:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801036d6:	00 
801036d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801036de:	00 
801036df:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801036e2:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036e5:	e8 76 0f 00 00       	call   80104660 <memset>
  p->context->eip = (uint)forkret;
801036ea:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036ed:	c7 40 10 20 37 10 80 	movl   $0x80103720,0x10(%eax)

  return p;
801036f4:	89 d8                	mov    %ebx,%eax
}
801036f6:	83 c4 14             	add    $0x14,%esp
801036f9:	5b                   	pop    %ebx
801036fa:	5d                   	pop    %ebp
801036fb:	c3                   	ret    
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103700:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103707:	e8 04 0f 00 00       	call   80104610 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
8010370c:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
8010370f:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103711:	5b                   	pop    %ebx
80103712:	5d                   	pop    %ebp
80103713:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103714:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010371b:	eb d9                	jmp    801036f6 <allocproc+0xb6>
8010371d:	8d 76 00             	lea    0x0(%esi),%esi

80103720 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103726:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010372d:	e8 de 0e 00 00       	call   80104610 <release>

  if (first) {
80103732:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103737:	85 c0                	test   %eax,%eax
80103739:	75 05                	jne    80103740 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010373b:	c9                   	leave  
8010373c:	c3                   	ret    
8010373d:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103740:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103747:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010374e:	00 00 00 
    iinit(ROOTDEV);
80103751:	e8 2a dd ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103756:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010375d:	e8 8e f3 ff ff       	call   80102af0 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103762:	c9                   	leave  
80103763:	c3                   	ret    
80103764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010376a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103770 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103776:	c7 44 24 04 0d 76 10 	movl   $0x8010760d,0x4(%esp)
8010377d:	80 
8010377e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103785:	e8 d6 0c 00 00       	call   80104460 <initlock>
}
8010378a:	c9                   	leave  
8010378b:	c3                   	ret    
8010378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103790 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
80103794:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103797:	e8 a4 fe ff ff       	call   80103640 <allocproc>
8010379c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010379e:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
801037a3:	e8 e8 32 00 00       	call   80106a90 <setupkvm>
801037a8:	85 c0                	test   %eax,%eax
801037aa:	89 43 04             	mov    %eax,0x4(%ebx)
801037ad:	0f 84 d4 00 00 00    	je     80103887 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037b3:	89 04 24             	mov    %eax,(%esp)
801037b6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801037bd:	00 
801037be:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801037c5:	80 
801037c6:	e8 25 34 00 00       	call   80106bf0 <inituvm>
  p->sz = PGSIZE;
801037cb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801037d1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801037d8:	00 
801037d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801037e0:	00 
801037e1:	8b 43 18             	mov    0x18(%ebx),%eax
801037e4:	89 04 24             	mov    %eax,(%esp)
801037e7:	e8 74 0e 00 00       	call   80104660 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037ec:	8b 43 18             	mov    0x18(%ebx),%eax
801037ef:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037f4:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037f9:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037fd:	8b 43 18             	mov    0x18(%ebx),%eax
80103800:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103804:	8b 43 18             	mov    0x18(%ebx),%eax
80103807:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010380b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010380f:	8b 43 18             	mov    0x18(%ebx),%eax
80103812:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103816:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010381a:	8b 43 18             	mov    0x18(%ebx),%eax
8010381d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103824:	8b 43 18             	mov    0x18(%ebx),%eax
80103827:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010382e:	8b 43 18             	mov    0x18(%ebx),%eax
80103831:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103838:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010383b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103842:	00 
80103843:	c7 44 24 04 2d 76 10 	movl   $0x8010762d,0x4(%esp)
8010384a:	80 
8010384b:	89 04 24             	mov    %eax,(%esp)
8010384e:	e8 ed 0f 00 00       	call   80104840 <safestrcpy>
  p->cwd = namei("/");
80103853:	c7 04 24 36 76 10 80 	movl   $0x80107636,(%esp)
8010385a:	e8 91 e6 ff ff       	call   80101ef0 <namei>
8010385f:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103862:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103869:	e8 72 0c 00 00       	call   801044e0 <acquire>

  p->state = RUNNABLE;
8010386e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103875:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010387c:	e8 8f 0d 00 00       	call   80104610 <release>
}
80103881:	83 c4 14             	add    $0x14,%esp
80103884:	5b                   	pop    %ebx
80103885:	5d                   	pop    %ebp
80103886:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103887:	c7 04 24 14 76 10 80 	movl   $0x80107614,(%esp)
8010388e:	e8 cd ca ff ff       	call   80100360 <panic>
80103893:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038a0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
801038a6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
801038b0:	8b 02                	mov    (%edx),%eax
  if(n > 0){
801038b2:	83 f9 00             	cmp    $0x0,%ecx
801038b5:	7e 39                	jle    801038f0 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801038b7:	01 c1                	add    %eax,%ecx
801038b9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801038bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801038c1:	8b 42 04             	mov    0x4(%edx),%eax
801038c4:	89 04 24             	mov    %eax,(%esp)
801038c7:	e8 64 34 00 00       	call   80106d30 <allocuvm>
801038cc:	85 c0                	test   %eax,%eax
801038ce:	74 40                	je     80103910 <growproc+0x70>
801038d0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
801038d7:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
801038d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801038df:	89 04 24             	mov    %eax,(%esp)
801038e2:	e8 69 32 00 00       	call   80106b50 <switchuvm>
  return 0;
801038e7:	31 c0                	xor    %eax,%eax
}
801038e9:	c9                   	leave  
801038ea:	c3                   	ret    
801038eb:	90                   	nop
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801038f0:	74 e5                	je     801038d7 <growproc+0x37>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801038f2:	01 c1                	add    %eax,%ecx
801038f4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801038f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801038fc:	8b 42 04             	mov    0x4(%edx),%eax
801038ff:	89 04 24             	mov    %eax,(%esp)
80103902:	e8 19 35 00 00       	call   80106e20 <deallocuvm>
80103907:	85 c0                	test   %eax,%eax
80103909:	75 c5                	jne    801038d0 <growproc+0x30>
8010390b:	90                   	nop
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
80103910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
80103915:	c9                   	leave  
80103916:	c3                   	ret    
80103917:	89 f6                	mov    %esi,%esi
80103919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103920 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	57                   	push   %edi
80103924:	56                   	push   %esi
80103925:	53                   	push   %ebx
80103926:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80103929:	e8 12 fd ff ff       	call   80103640 <allocproc>
8010392e:	85 c0                	test   %eax,%eax
80103930:	89 c3                	mov    %eax,%ebx
80103932:	0f 84 d5 00 00 00    	je     80103a0d <fork+0xed>
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103938:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010393e:	8b 10                	mov    (%eax),%edx
80103940:	89 54 24 04          	mov    %edx,0x4(%esp)
80103944:	8b 40 04             	mov    0x4(%eax),%eax
80103947:	89 04 24             	mov    %eax,(%esp)
8010394a:	e8 a1 35 00 00       	call   80106ef0 <copyuvm>
8010394f:	85 c0                	test   %eax,%eax
80103951:	89 43 04             	mov    %eax,0x4(%ebx)
80103954:	0f 84 ba 00 00 00    	je     80103a14 <fork+0xf4>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
8010395a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103960:	b9 13 00 00 00       	mov    $0x13,%ecx
80103965:	8b 7b 18             	mov    0x18(%ebx),%edi
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103968:	8b 00                	mov    (%eax),%eax
8010396a:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
8010396c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103972:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103975:	8b 70 18             	mov    0x18(%eax),%esi
80103978:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010397a:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010397c:	8b 43 18             	mov    0x18(%ebx),%eax
8010397f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103986:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
8010398d:	8d 76 00             	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103990:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103994:	85 c0                	test   %eax,%eax
80103996:	74 13                	je     801039ab <fork+0x8b>
      np->ofile[i] = filedup(proc->ofile[i]);
80103998:	89 04 24             	mov    %eax,(%esp)
8010399b:	e8 40 d4 ff ff       	call   80100de0 <filedup>
801039a0:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
801039a4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039ab:	83 c6 01             	add    $0x1,%esi
801039ae:	83 fe 10             	cmp    $0x10,%esi
801039b1:	75 dd                	jne    80103990 <fork+0x70>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801039b3:	8b 42 68             	mov    0x68(%edx),%eax
801039b6:	89 04 24             	mov    %eax,(%esp)
801039b9:	e8 d2 dc ff ff       	call   80101690 <idup>
801039be:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801039c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801039c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801039ce:	00 
801039cf:	83 c0 6c             	add    $0x6c,%eax
801039d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801039d6:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039d9:	89 04 24             	mov    %eax,(%esp)
801039dc:	e8 5f 0e 00 00       	call   80104840 <safestrcpy>

  pid = np->pid;
801039e1:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
801039e4:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801039eb:	e8 f0 0a 00 00       	call   801044e0 <acquire>

  np->state = RUNNABLE;
801039f0:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801039f7:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801039fe:	e8 0d 0c 00 00       	call   80104610 <release>

  return pid;
80103a03:	89 f0                	mov    %esi,%eax
}
80103a05:	83 c4 1c             	add    $0x1c,%esp
80103a08:	5b                   	pop    %ebx
80103a09:	5e                   	pop    %esi
80103a0a:	5f                   	pop    %edi
80103a0b:	5d                   	pop    %ebp
80103a0c:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a12:	eb f1                	jmp    80103a05 <fork+0xe5>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103a14:	8b 43 08             	mov    0x8(%ebx),%eax
80103a17:	89 04 24             	mov    %eax,(%esp)
80103a1a:	e8 d1 e8 ff ff       	call   801022f0 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103a1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103a24:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103a2b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103a32:	eb d1                	jmp    80103a05 <fork+0xe5>
80103a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a40 <getTotalLottery>:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.

int getTotalLottery(void){
80103a40:	55                   	push   %ebp
 struct proc *p;
 int tickets_sum = 0;
80103a41:	31 c0                	xor    %eax,%eax
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.

int getTotalLottery(void){
80103a43:	89 e5                	mov    %esp,%ebp
 struct proc *p;
 int tickets_sum = 0;
 for(p = ptable.proc;p<&ptable.proc[NPROC];p++){
80103a45:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80103a4a:	eb 12                	jmp    80103a5e <getTotalLottery+0x1e>
80103a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a50:	81 c2 84 00 00 00    	add    $0x84,%edx
80103a56:	81 fa d4 4e 11 80    	cmp    $0x80114ed4,%edx
80103a5c:	74 1a                	je     80103a78 <getTotalLottery+0x38>
  if(p->state == RUNNABLE)
80103a5e:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103a62:	75 ec                	jne    80103a50 <getTotalLottery+0x10>
     tickets_sum += p->tickets;
80103a64:	03 82 80 00 00 00    	add    0x80(%edx),%eax
//      via swtch back to the scheduler.

int getTotalLottery(void){
 struct proc *p;
 int tickets_sum = 0;
 for(p = ptable.proc;p<&ptable.proc[NPROC];p++){
80103a6a:	81 c2 84 00 00 00    	add    $0x84,%edx
80103a70:	81 fa d4 4e 11 80    	cmp    $0x80114ed4,%edx
80103a76:	75 e6                	jne    80103a5e <getTotalLottery+0x1e>
  if(p->state == RUNNABLE)
     tickets_sum += p->tickets;
  }
  return tickets_sum;
}
80103a78:	5d                   	pop    %ebp
80103a79:	c3                   	ret    
80103a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a80 <lottery_Total>:

int lottery_Total(void){
80103a80:	55                   	push   %ebp
   struct proc *p;
  int ticket_aggregate=0;
80103a81:	31 c0                	xor    %eax,%eax
     tickets_sum += p->tickets;
  }
  return tickets_sum;
}

int lottery_Total(void){
80103a83:	89 e5                	mov    %esp,%ebp
   struct proc *p;
  int ticket_aggregate=0;

//loop over process table and increment total tickets if a runnable process is found 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a85:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80103a8a:	eb 12                	jmp    80103a9e <lottery_Total+0x1e>
80103a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a90:	81 c2 84 00 00 00    	add    $0x84,%edx
80103a96:	81 fa d4 4e 11 80    	cmp    $0x80114ed4,%edx
80103a9c:	74 1a                	je     80103ab8 <lottery_Total+0x38>
  {
    if(p->state==RUNNABLE){
80103a9e:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103aa2:	75 ec                	jne    80103a90 <lottery_Total+0x10>
     ticket_aggregate+=p->tickets;
80103aa4:	03 82 80 00 00 00    	add    0x80(%edx),%eax
int lottery_Total(void){
   struct proc *p;
  int ticket_aggregate=0;

//loop over process table and increment total tickets if a runnable process is found 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103aaa:	81 c2 84 00 00 00    	add    $0x84,%edx
80103ab0:	81 fa d4 4e 11 80    	cmp    $0x80114ed4,%edx
80103ab6:	75 e6                	jne    80103a9e <lottery_Total+0x1e>
    if(p->state==RUNNABLE){
     ticket_aggregate+=p->tickets;
    }
  }
  return ticket_aggregate;          // returning total number of tickets for runnable processes
}
80103ab8:	5d                   	pop    %ebp
80103ab9:	c3                   	ret    
80103aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ac0 <random_at_most>:
unsigned int xorshift_state = 12345;

int
chr()
{
    xorshift_state ^= (xorshift_state << 13);
80103ac0:	8b 15 08 a0 10 80    	mov    0x8010a008,%edx
  }
  return ticket_aggregate;          // returning total number of tickets for runnable processes
}


int random_at_most(int max) {
80103ac6:	55                   	push   %ebp
80103ac7:	89 e5                	mov    %esp,%ebp
   return (chr() % (max + 1));
80103ac9:	8b 4d 08             	mov    0x8(%ebp),%ecx
unsigned int xorshift_state = 12345;

int
chr()
{
    xorshift_state ^= (xorshift_state << 13);
80103acc:	89 d0                	mov    %edx,%eax
80103ace:	c1 e0 0d             	shl    $0xd,%eax
80103ad1:	31 d0                	xor    %edx,%eax
    xorshift_state ^= (xorshift_state >> 17);
80103ad3:	89 c2                	mov    %eax,%edx
  return ticket_aggregate;          // returning total number of tickets for runnable processes
}


int random_at_most(int max) {
   return (chr() % (max + 1));
80103ad5:	83 c1 01             	add    $0x1,%ecx

int
chr()
{
    xorshift_state ^= (xorshift_state << 13);
    xorshift_state ^= (xorshift_state >> 17);
80103ad8:	c1 ea 11             	shr    $0x11,%edx
80103adb:	31 c2                	xor    %eax,%edx
    xorshift_state ^= (xorshift_state << 5);
80103add:	89 d0                	mov    %edx,%eax
80103adf:	c1 e0 05             	shl    $0x5,%eax
80103ae2:	31 d0                	xor    %edx,%eax
  return ticket_aggregate;          // returning total number of tickets for runnable processes
}


int random_at_most(int max) {
   return (chr() % (max + 1));
80103ae4:	99                   	cltd   
int
chr()
{
    xorshift_state ^= (xorshift_state << 13);
    xorshift_state ^= (xorshift_state >> 17);
    xorshift_state ^= (xorshift_state << 5);
80103ae5:	a3 08 a0 10 80       	mov    %eax,0x8010a008
  return ticket_aggregate;          // returning total number of tickets for runnable processes
}


int random_at_most(int max) {
   return (chr() % (max + 1));
80103aea:	f7 f9                	idiv   %ecx
}
80103aec:	5d                   	pop    %ebp
80103aed:	89 d0                	mov    %edx,%eax
80103aef:	c3                   	ret    

80103af0 <scheduler>:

void
scheduler(void)
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	57                   	push   %edi
80103af4:	56                   	push   %esi
80103af5:	53                   	push   %ebx
80103af6:	83 ec 1c             	sub    $0x1c,%esp
    struct proc *p, *p1;
    struct cpu *c = cpu;
80103af9:	65 8b 35 00 00 00 00 	mov    %gs:0x0,%esi
80103b00:	8d 46 04             	lea    0x4(%esi),%eax
    c->proc = 0;
80103b03:	c7 86 b8 00 00 00 00 	movl   $0x0,0xb8(%esi)
80103b0a:	00 00 00 
80103b0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
}

static inline void
sti(void)
{
  asm volatile("sti");
80103b10:	fb                   	sti    
        // Enable interrupts on this processor.
        sti();
        struct proc *highP;

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80103b11:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103b18:	e8 c3 09 00 00       	call   801044e0 <acquire>
  return tickets_sum;
}

int lottery_Total(void){
   struct proc *p;
  int ticket_aggregate=0;
80103b1d:	31 c9                	xor    %ecx,%ecx

//loop over process table and increment total tickets if a runnable process is found 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b1f:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103b24:	eb 0e                	jmp    80103b34 <scheduler+0x44>
80103b26:	66 90                	xchg   %ax,%ax
80103b28:	05 84 00 00 00       	add    $0x84,%eax
80103b2d:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80103b32:	74 18                	je     80103b4c <scheduler+0x5c>
  {
    if(p->state==RUNNABLE){
80103b34:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103b38:	75 ee                	jne    80103b28 <scheduler+0x38>
     ticket_aggregate+=p->tickets;
80103b3a:	03 88 80 00 00 00    	add    0x80(%eax),%ecx
int lottery_Total(void){
   struct proc *p;
  int ticket_aggregate=0;

//loop over process table and increment total tickets if a runnable process is found 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b40:	05 84 00 00 00       	add    $0x84,%eax
80103b45:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80103b4a:	75 e8                	jne    80103b34 <scheduler+0x44>
unsigned int xorshift_state = 12345;

int
chr()
{
    xorshift_state ^= (xorshift_state << 13);
80103b4c:	8b 15 08 a0 10 80    	mov    0x8010a008,%edx
  return ticket_aggregate;          // returning total number of tickets for runnable processes
}


int random_at_most(int max) {
   return (chr() % (max + 1));
80103b52:	83 c1 01             	add    $0x1,%ecx
        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        // Reset variables to start from the beginning of the process queue
        golden_ticket = 0;
        count = 0;
80103b55:	31 ff                	xor    %edi,%edi
unsigned int xorshift_state = 12345;

int
chr()
{
    xorshift_state ^= (xorshift_state << 13);
80103b57:	89 d0                	mov    %edx,%eax
80103b59:	c1 e0 0d             	shl    $0xd,%eax
80103b5c:	31 d0                	xor    %edx,%eax
    xorshift_state ^= (xorshift_state >> 17);
80103b5e:	89 c2                	mov    %eax,%edx
80103b60:	c1 ea 11             	shr    $0x11,%edx
80103b63:	31 c2                	xor    %eax,%edx
    xorshift_state ^= (xorshift_state << 5);
80103b65:	89 d0                	mov    %edx,%eax
80103b67:	c1 e0 05             	shl    $0x5,%eax
80103b6a:	31 d0                	xor    %edx,%eax
  return ticket_aggregate;          // returning total number of tickets for runnable processes
}


int random_at_most(int max) {
   return (chr() % (max + 1));
80103b6c:	99                   	cltd   
int
chr()
{
    xorshift_state ^= (xorshift_state << 13);
    xorshift_state ^= (xorshift_state >> 17);
    xorshift_state ^= (xorshift_state << 5);
80103b6d:	a3 08 a0 10 80       	mov    %eax,0x8010a008
  return ticket_aggregate;          // returning total number of tickets for runnable processes
}


int random_at_most(int max) {
   return (chr() % (max + 1));
80103b72:	f7 f9                	idiv   %ecx
        total_no_tickets = lottery_Total();

        // Pick a random ticket from total available tickets
        golden_ticket = random_at_most(total_no_tickets);

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103b74:	b9 d4 2d 11 80       	mov    $0x80112dd4,%ecx
80103b79:	eb 13                	jmp    80103b8e <scheduler+0x9e>
80103b7b:	90                   	nop
80103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b80:	81 c1 84 00 00 00    	add    $0x84,%ecx
80103b86:	81 f9 d4 4e 11 80    	cmp    $0x80114ed4,%ecx
80103b8c:	74 7c                	je     80103c0a <scheduler+0x11a>
            if (p->state != RUNNABLE)
80103b8e:	83 79 0c 03          	cmpl   $0x3,0xc(%ecx)
80103b92:	75 ec                	jne    80103b80 <scheduler+0x90>
80103b94:	89 cb                	mov    %ecx,%ebx
80103b96:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103b9b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103b9e:	eb 0c                	jmp    80103bac <scheduler+0xbc>
                continue;

            highP = p;

            for (p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++) {
80103ba0:	05 84 00 00 00       	add    $0x84,%eax
80103ba5:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80103baa:	74 1b                	je     80103bc7 <scheduler+0xd7>
                if (p1->state != RUNNABLE)
80103bac:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103bb0:	75 ee                	jne    80103ba0 <scheduler+0xb0>
80103bb2:	8b 50 7c             	mov    0x7c(%eax),%edx
80103bb5:	39 53 7c             	cmp    %edx,0x7c(%ebx)
80103bb8:	0f 4f d8             	cmovg  %eax,%ebx
            if (p->state != RUNNABLE)
                continue;

            highP = p;

            for (p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++) {
80103bbb:	05 84 00 00 00       	add    $0x84,%eax
80103bc0:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80103bc5:	75 e5                	jne    80103bac <scheduler+0xbc>
80103bc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
                if (highP->priority > p1->priority)   // Larger value, lower priority
                    highP = p1;
            }

            // Find the process which holds the lottery winning ticket
            if ((count + p->tickets) < golden_ticket) {
80103bca:	03 b9 80 00 00 00    	add    0x80(%ecx),%edi
80103bd0:	39 d7                	cmp    %edx,%edi
80103bd2:	7c ac                	jl     80103b80 <scheduler+0x90>

            // Add a print statement to show the scheduled process's PID and golden ticket
            //cprintf("Process with PID %d is running with a golden ticket of %d\n", p->pid, golden_ticket);

            p = highP;
            c->proc = p;
80103bd4:	89 9e b8 00 00 00    	mov    %ebx,0xb8(%esi)
            switchuvm(p);
80103bda:	89 1c 24             	mov    %ebx,(%esp)
80103bdd:	e8 6e 2f 00 00       	call   80106b50 <switchuvm>
            p->state = RUNNING;

            swtch(&(c->scheduler), p->context);
80103be2:	8b 43 1c             	mov    0x1c(%ebx),%eax
            //cprintf("Process with PID %d is running with a golden ticket of %d\n", p->pid, golden_ticket);

            p = highP;
            c->proc = p;
            switchuvm(p);
            p->state = RUNNING;
80103be5:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)

            swtch(&(c->scheduler), p->context);
80103bec:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103bf3:	89 04 24             	mov    %eax,(%esp)
80103bf6:	e8 a0 0c 00 00       	call   8010489b <swtch>
            switchkvm();
80103bfb:	e8 30 2f 00 00       	call   80106b30 <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
80103c00:	c7 86 b8 00 00 00 00 	movl   $0x0,0xb8(%esi)
80103c07:	00 00 00 
            break;
        }
        release(&ptable.lock);
80103c0a:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103c11:	e8 fa 09 00 00       	call   80104610 <release>
    }
80103c16:	e9 f5 fe ff ff       	jmp    80103b10 <scheduler+0x20>
80103c1b:	90                   	nop
80103c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c20 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	53                   	push   %ebx
80103c24:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80103c27:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103c2e:	e8 3d 09 00 00       	call   80104570 <holding>
80103c33:	85 c0                	test   %eax,%eax
80103c35:	74 4d                	je     80103c84 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103c37:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c3d:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
80103c44:	75 62                	jne    80103ca8 <sched+0x88>
    panic("sched locks");
  if(proc->state == RUNNING)
80103c46:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c4d:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
80103c51:	74 49                	je     80103c9c <sched+0x7c>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c53:	9c                   	pushf  
80103c54:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103c55:	80 e5 02             	and    $0x2,%ch
80103c58:	75 36                	jne    80103c90 <sched+0x70>
    panic("sched interruptible");
  intena = cpu->intena;
80103c5a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  swtch(&proc->context, cpu->scheduler);
80103c60:	83 c2 1c             	add    $0x1c,%edx
80103c63:	8b 40 04             	mov    0x4(%eax),%eax
80103c66:	89 14 24             	mov    %edx,(%esp)
80103c69:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c6d:	e8 29 0c 00 00       	call   8010489b <swtch>
  cpu->intena = intena;
80103c72:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c78:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103c7e:	83 c4 14             	add    $0x14,%esp
80103c81:	5b                   	pop    %ebx
80103c82:	5d                   	pop    %ebp
80103c83:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103c84:	c7 04 24 38 76 10 80 	movl   $0x80107638,(%esp)
80103c8b:	e8 d0 c6 ff ff       	call   80100360 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103c90:	c7 04 24 64 76 10 80 	movl   $0x80107664,(%esp)
80103c97:	e8 c4 c6 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103c9c:	c7 04 24 56 76 10 80 	movl   $0x80107656,(%esp)
80103ca3:	e8 b8 c6 ff ff       	call   80100360 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103ca8:	c7 04 24 4a 76 10 80 	movl   $0x8010764a,(%esp)
80103caf:	e8 ac c6 ff ff       	call   80100360 <panic>
80103cb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103cc0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	56                   	push   %esi
80103cc4:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103cc5:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103cc7:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80103cca:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103cd1:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
80103cd7:	0f 84 0b 01 00 00    	je     80103de8 <exit+0x128>
80103cdd:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103ce0:	8d 73 08             	lea    0x8(%ebx),%esi
80103ce3:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103ce7:	85 c0                	test   %eax,%eax
80103ce9:	74 17                	je     80103d02 <exit+0x42>
      fileclose(proc->ofile[fd]);
80103ceb:	89 04 24             	mov    %eax,(%esp)
80103cee:	e8 3d d1 ff ff       	call   80100e30 <fileclose>
      proc->ofile[fd] = 0;
80103cf3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103cfa:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103d01:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103d02:	83 c3 01             	add    $0x1,%ebx
80103d05:	83 fb 10             	cmp    $0x10,%ebx
80103d08:	75 d6                	jne    80103ce0 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103d0a:	e8 81 ee ff ff       	call   80102b90 <begin_op>
  iput(proc->cwd);
80103d0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d15:	8b 40 68             	mov    0x68(%eax),%eax
80103d18:	89 04 24             	mov    %eax,(%esp)
80103d1b:	e8 b0 da ff ff       	call   801017d0 <iput>
  end_op();
80103d20:	e8 db ee ff ff       	call   80102c00 <end_op>
  proc->cwd = 0;
80103d25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d2b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103d32:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103d39:	e8 a2 07 00 00       	call   801044e0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103d3e:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d45:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103d4a:	8b 51 14             	mov    0x14(%ecx),%edx
80103d4d:	eb 0d                	jmp    80103d5c <exit+0x9c>
80103d4f:	90                   	nop
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d50:	05 84 00 00 00       	add    $0x84,%eax
80103d55:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80103d5a:	74 1e                	je     80103d7a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80103d5c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d60:	75 ee                	jne    80103d50 <exit+0x90>
80103d62:	3b 50 20             	cmp    0x20(%eax),%edx
80103d65:	75 e9                	jne    80103d50 <exit+0x90>
      p->state = RUNNABLE;
80103d67:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d6e:	05 84 00 00 00       	add    $0x84,%eax
80103d73:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80103d78:	75 e2                	jne    80103d5c <exit+0x9c>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103d7a:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103d80:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80103d85:	eb 0f                	jmp    80103d96 <exit+0xd6>
80103d87:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d88:	81 c2 84 00 00 00    	add    $0x84,%edx
80103d8e:	81 fa d4 4e 11 80    	cmp    $0x80114ed4,%edx
80103d94:	74 3a                	je     80103dd0 <exit+0x110>
    if(p->parent == proc){
80103d96:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103d99:	75 ed                	jne    80103d88 <exit+0xc8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103d9b:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103d9f:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
80103da2:	75 e4                	jne    80103d88 <exit+0xc8>
80103da4:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103da9:	eb 11                	jmp    80103dbc <exit+0xfc>
80103dab:	90                   	nop
80103dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103db0:	05 84 00 00 00       	add    $0x84,%eax
80103db5:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80103dba:	74 cc                	je     80103d88 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103dbc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dc0:	75 ee                	jne    80103db0 <exit+0xf0>
80103dc2:	3b 58 20             	cmp    0x20(%eax),%ebx
80103dc5:	75 e9                	jne    80103db0 <exit+0xf0>
      p->state = RUNNABLE;
80103dc7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103dce:	eb e0                	jmp    80103db0 <exit+0xf0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103dd0:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  sched();
80103dd7:	e8 44 fe ff ff       	call   80103c20 <sched>
  panic("zombie exit");
80103ddc:	c7 04 24 85 76 10 80 	movl   $0x80107685,(%esp)
80103de3:	e8 78 c5 ff ff       	call   80100360 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103de8:	c7 04 24 78 76 10 80 	movl   $0x80107678,(%esp)
80103def:	e8 6c c5 ff ff       	call   80100360 <panic>
80103df4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e00 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e06:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103e0d:	e8 ce 06 00 00       	call   801044e0 <acquire>
  proc->state = RUNNABLE;
80103e12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e18:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103e1f:	e8 fc fd ff ff       	call   80103c20 <sched>
  release(&ptable.lock);
80103e24:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103e2b:	e8 e0 07 00 00       	call   80104610 <release>
}
80103e30:	c9                   	leave  
80103e31:	c3                   	ret    
80103e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e40 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	56                   	push   %esi
80103e44:	53                   	push   %ebx
80103e45:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
80103e48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e4e:	8b 75 08             	mov    0x8(%ebp),%esi
80103e51:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103e54:	85 c0                	test   %eax,%eax
80103e56:	0f 84 8b 00 00 00    	je     80103ee7 <sleep+0xa7>
    panic("sleep");

  if(lk == 0)
80103e5c:	85 db                	test   %ebx,%ebx
80103e5e:	74 7b                	je     80103edb <sleep+0x9b>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e60:	81 fb a0 2d 11 80    	cmp    $0x80112da0,%ebx
80103e66:	74 50                	je     80103eb8 <sleep+0x78>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e68:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103e6f:	e8 6c 06 00 00       	call   801044e0 <acquire>
    release(lk);
80103e74:	89 1c 24             	mov    %ebx,(%esp)
80103e77:	e8 94 07 00 00       	call   80104610 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103e7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e82:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103e85:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103e8c:	e8 8f fd ff ff       	call   80103c20 <sched>

  // Tidy up.
  proc->chan = 0;
80103e91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e97:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103e9e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ea5:	e8 66 07 00 00       	call   80104610 <release>
    acquire(lk);
80103eaa:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
80103ead:	83 c4 10             	add    $0x10,%esp
80103eb0:	5b                   	pop    %ebx
80103eb1:	5e                   	pop    %esi
80103eb2:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103eb3:	e9 28 06 00 00       	jmp    801044e0 <acquire>
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103eb8:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103ebb:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103ec2:	e8 59 fd ff ff       	call   80103c20 <sched>

  // Tidy up.
  proc->chan = 0;
80103ec7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ecd:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103ed4:	83 c4 10             	add    $0x10,%esp
80103ed7:	5b                   	pop    %ebx
80103ed8:	5e                   	pop    %esi
80103ed9:	5d                   	pop    %ebp
80103eda:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103edb:	c7 04 24 97 76 10 80 	movl   $0x80107697,(%esp)
80103ee2:	e8 79 c4 ff ff       	call   80100360 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103ee7:	c7 04 24 91 76 10 80 	movl   $0x80107691,(%esp)
80103eee:	e8 6d c4 ff ff       	call   80100360 <panic>
80103ef3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f00 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	56                   	push   %esi
80103f04:	53                   	push   %ebx
80103f05:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103f08:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f0f:	e8 cc 05 00 00       	call   801044e0 <acquire>
80103f14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103f1a:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f1c:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103f21:	eb 13                	jmp    80103f36 <wait+0x36>
80103f23:	90                   	nop
80103f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f28:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103f2e:	81 fb d4 4e 11 80    	cmp    $0x80114ed4,%ebx
80103f34:	74 22                	je     80103f58 <wait+0x58>
      if(p->parent != proc)
80103f36:	39 43 14             	cmp    %eax,0x14(%ebx)
80103f39:	75 ed                	jne    80103f28 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103f3b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f3f:	74 34                	je     80103f75 <wait+0x75>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f41:	81 c3 84 00 00 00    	add    $0x84,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103f47:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f4c:	81 fb d4 4e 11 80    	cmp    $0x80114ed4,%ebx
80103f52:	75 e2                	jne    80103f36 <wait+0x36>
80103f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103f58:	85 d2                	test   %edx,%edx
80103f5a:	74 6e                	je     80103fca <wait+0xca>
80103f5c:	8b 50 24             	mov    0x24(%eax),%edx
80103f5f:	85 d2                	test   %edx,%edx
80103f61:	75 67                	jne    80103fca <wait+0xca>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103f63:	c7 44 24 04 a0 2d 11 	movl   $0x80112da0,0x4(%esp)
80103f6a:	80 
80103f6b:	89 04 24             	mov    %eax,(%esp)
80103f6e:	e8 cd fe ff ff       	call   80103e40 <sleep>
  }
80103f73:	eb 9f                	jmp    80103f14 <wait+0x14>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103f75:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103f78:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f7b:	89 04 24             	mov    %eax,(%esp)
80103f7e:	e8 6d e3 ff ff       	call   801022f0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103f83:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103f86:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f8d:	89 04 24             	mov    %eax,(%esp)
80103f90:	e8 ab 2e 00 00       	call   80106e40 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103f95:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103f9c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fa3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103faa:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fae:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fb5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fbc:	e8 4f 06 00 00       	call   80104610 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fc1:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103fc4:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fc6:	5b                   	pop    %ebx
80103fc7:	5e                   	pop    %esi
80103fc8:	5d                   	pop    %ebp
80103fc9:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80103fca:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103fd1:	e8 3a 06 00 00       	call   80104610 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fd6:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80103fd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fde:	5b                   	pop    %ebx
80103fdf:	5e                   	pop    %esi
80103fe0:	5d                   	pop    %ebp
80103fe1:	c3                   	ret    
80103fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ff0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 14             	sub    $0x14,%esp
80103ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103ffa:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104001:	e8 da 04 00 00       	call   801044e0 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104006:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010400b:	eb 0f                	jmp    8010401c <wakeup+0x2c>
8010400d:	8d 76 00             	lea    0x0(%esi),%esi
80104010:	05 84 00 00 00       	add    $0x84,%eax
80104015:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
8010401a:	74 24                	je     80104040 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
8010401c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104020:	75 ee                	jne    80104010 <wakeup+0x20>
80104022:	3b 58 20             	cmp    0x20(%eax),%ebx
80104025:	75 e9                	jne    80104010 <wakeup+0x20>
      p->state = RUNNABLE;
80104027:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010402e:	05 84 00 00 00       	add    $0x84,%eax
80104033:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80104038:	75 e2                	jne    8010401c <wakeup+0x2c>
8010403a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104040:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80104047:	83 c4 14             	add    $0x14,%esp
8010404a:	5b                   	pop    %ebx
8010404b:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010404c:	e9 bf 05 00 00       	jmp    80104610 <release>
80104051:	eb 0d                	jmp    80104060 <kill>
80104053:	90                   	nop
80104054:	90                   	nop
80104055:	90                   	nop
80104056:	90                   	nop
80104057:	90                   	nop
80104058:	90                   	nop
80104059:	90                   	nop
8010405a:	90                   	nop
8010405b:	90                   	nop
8010405c:	90                   	nop
8010405d:	90                   	nop
8010405e:	90                   	nop
8010405f:	90                   	nop

80104060 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 14             	sub    $0x14,%esp
80104067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010406a:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104071:	e8 6a 04 00 00       	call   801044e0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104076:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010407b:	eb 0f                	jmp    8010408c <kill+0x2c>
8010407d:	8d 76 00             	lea    0x0(%esi),%esi
80104080:	05 84 00 00 00       	add    $0x84,%eax
80104085:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
8010408a:	74 3c                	je     801040c8 <kill+0x68>
    if(p->pid == pid){
8010408c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010408f:	75 ef                	jne    80104080 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104091:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104095:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010409c:	74 1a                	je     801040b8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010409e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801040a5:	e8 66 05 00 00       	call   80104610 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801040aa:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
801040ad:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801040af:	5b                   	pop    %ebx
801040b0:	5d                   	pop    %ebp
801040b1:	c3                   	ret    
801040b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801040b8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040bf:	eb dd                	jmp    8010409e <kill+0x3e>
801040c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801040c8:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801040cf:	e8 3c 05 00 00       	call   80104610 <release>
  return -1;
}
801040d4:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
801040d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040dc:	5b                   	pop    %ebx
801040dd:	5d                   	pop    %ebp
801040de:	c3                   	ret    
801040df:	90                   	nop

801040e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	57                   	push   %edi
801040e4:	56                   	push   %esi
801040e5:	53                   	push   %ebx
801040e6:	bb 40 2e 11 80       	mov    $0x80112e40,%ebx
801040eb:	83 ec 5c             	sub    $0x5c,%esp
801040ee:	8d 75 e8             	lea    -0x18(%ebp),%esi
801040f1:	eb 23                	jmp    80104116 <procdump+0x36>
801040f3:	90                   	nop
801040f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040f8:	c7 04 24 e6 75 10 80 	movl   $0x801075e6,(%esp)
801040ff:	e8 4c c5 ff ff       	call   80100650 <cprintf>
80104104:	81 c3 84 00 00 00    	add    $0x84,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010410a:	81 fb 40 4f 11 80    	cmp    $0x80114f40,%ebx
80104110:	0f 84 92 00 00 00    	je     801041a8 <procdump+0xc8>
    if(p->state == UNUSED)
80104116:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104119:	85 c0                	test   %eax,%eax
8010411b:	74 e7                	je     80104104 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010411d:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104120:	ba a8 76 10 80       	mov    $0x801076a8,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104125:	77 11                	ja     80104138 <procdump+0x58>
80104127:	8b 14 85 50 77 10 80 	mov    -0x7fef88b0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
8010412e:	b8 a8 76 10 80       	mov    $0x801076a8,%eax
80104133:	85 d2                	test   %edx,%edx
80104135:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name,p->tickets);
80104138:	8b 43 14             	mov    0x14(%ebx),%eax
8010413b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010413f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104143:	c7 04 24 ac 76 10 80 	movl   $0x801076ac,(%esp)
8010414a:	89 44 24 10          	mov    %eax,0x10(%esp)
8010414e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104151:	89 44 24 04          	mov    %eax,0x4(%esp)
80104155:	e8 f6 c4 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
8010415a:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010415e:	75 98                	jne    801040f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104160:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104163:	89 44 24 04          	mov    %eax,0x4(%esp)
80104167:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010416a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010416d:	8b 40 0c             	mov    0xc(%eax),%eax
80104170:	83 c0 08             	add    $0x8,%eax
80104173:	89 04 24             	mov    %eax,(%esp)
80104176:	e8 05 03 00 00       	call   80104480 <getcallerpcs>
8010417b:	90                   	nop
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104180:	8b 17                	mov    (%edi),%edx
80104182:	85 d2                	test   %edx,%edx
80104184:	0f 84 6e ff ff ff    	je     801040f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
8010418a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010418e:	83 c7 04             	add    $0x4,%edi
80104191:	c7 04 24 09 71 10 80 	movl   $0x80107109,(%esp)
80104198:	e8 b3 c4 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name,p->tickets);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010419d:	39 f7                	cmp    %esi,%edi
8010419f:	75 df                	jne    80104180 <procdump+0xa0>
801041a1:	e9 52 ff ff ff       	jmp    801040f8 <procdump+0x18>
801041a6:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801041a8:	83 c4 5c             	add    $0x5c,%esp
801041ab:	5b                   	pop    %ebx
801041ac:	5e                   	pop    %esi
801041ad:	5f                   	pop    %edi
801041ae:	5d                   	pop    %ebp
801041af:	90                   	nop
801041b0:	c3                   	ret    
801041b1:	eb 0d                	jmp    801041c0 <cps>
801041b3:	90                   	nop
801041b4:	90                   	nop
801041b5:	90                   	nop
801041b6:	90                   	nop
801041b7:	90                   	nop
801041b8:	90                   	nop
801041b9:	90                   	nop
801041ba:	90                   	nop
801041bb:	90                   	nop
801041bc:	90                   	nop
801041bd:	90                   	nop
801041be:	90                   	nop
801041bf:	90                   	nop

801041c0 <cps>:


int
cps()
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 14             	sub    $0x14,%esp
}

static inline void
sti(void)
{
  asm volatile("sti");
801041c7:	fb                   	sti    
struct proc *p;
//Enables interrupts on this processor.
sti();

//Loop over process table looking for process with pid.
acquire(&ptable.lock);
801041c8:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801041cf:	bb 40 2e 11 80       	mov    $0x80112e40,%ebx
801041d4:	e8 07 03 00 00       	call   801044e0 <acquire>
cprintf("name \t pid \t state \t priority \n");
801041d9:	c7 04 24 30 77 10 80 	movl   $0x80107730,(%esp)
801041e0:	e8 6b c4 ff ff       	call   80100650 <cprintf>
801041e5:	eb 19                	jmp    80104200 <cps+0x40>
801041e7:	90                   	nop
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  if(p->state == SLEEPING)
	  cprintf("%s \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->priority);
	else if(p->state == RUNNING)
801041e8:	83 f8 04             	cmp    $0x4,%eax
801041eb:	74 63                	je     80104250 <cps+0x90>
 	  cprintf("%s \t %d \t RUNNING \t %d \n ", p->name,p->pid,p->priority);
	else if(p->state == RUNNABLE)
801041ed:	83 f8 03             	cmp    $0x3,%eax
801041f0:	74 7e                	je     80104270 <cps+0xb0>
801041f2:	81 c3 84 00 00 00    	add    $0x84,%ebx
sti();

//Loop over process table looking for process with pid.
acquire(&ptable.lock);
cprintf("name \t pid \t state \t priority \n");
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f8:	81 fb 40 4f 11 80    	cmp    $0x80114f40,%ebx
801041fe:	74 38                	je     80104238 <cps+0x78>
  if(p->state == SLEEPING)
80104200:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104203:	83 f8 02             	cmp    $0x2,%eax
80104206:	75 e0                	jne    801041e8 <cps+0x28>
	  cprintf("%s \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->priority);
80104208:	8b 43 10             	mov    0x10(%ebx),%eax
8010420b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010420f:	81 c3 84 00 00 00    	add    $0x84,%ebx
80104215:	c7 04 24 b5 76 10 80 	movl   $0x801076b5,(%esp)
8010421c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80104220:	8b 83 20 ff ff ff    	mov    -0xe0(%ebx),%eax
80104226:	89 44 24 08          	mov    %eax,0x8(%esp)
8010422a:	e8 21 c4 ff ff       	call   80100650 <cprintf>
sti();

//Loop over process table looking for process with pid.
acquire(&ptable.lock);
cprintf("name \t pid \t state \t priority \n");
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010422f:	81 fb 40 4f 11 80    	cmp    $0x80114f40,%ebx
80104235:	75 c9                	jne    80104200 <cps+0x40>
80104237:	90                   	nop
	else if(p->state == RUNNING)
 	  cprintf("%s \t %d \t RUNNING \t %d \n ", p->name,p->pid,p->priority);
	else if(p->state == RUNNABLE)
 	  cprintf("%s \t %d \t RUNNABLE \t %d \n ", p->name,p->pid,p->priority);
}
release(&ptable.lock);
80104238:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010423f:	e8 cc 03 00 00       	call   80104610 <release>
return 22;
}
80104244:	83 c4 14             	add    $0x14,%esp
80104247:	b8 16 00 00 00       	mov    $0x16,%eax
8010424c:	5b                   	pop    %ebx
8010424d:	5d                   	pop    %ebp
8010424e:	c3                   	ret    
8010424f:	90                   	nop
cprintf("name \t pid \t state \t priority \n");
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  if(p->state == SLEEPING)
	  cprintf("%s \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->priority);
	else if(p->state == RUNNING)
 	  cprintf("%s \t %d \t RUNNING \t %d \n ", p->name,p->pid,p->priority);
80104250:	8b 43 10             	mov    0x10(%ebx),%eax
80104253:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104257:	c7 04 24 d0 76 10 80 	movl   $0x801076d0,(%esp)
8010425e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80104262:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104265:	89 44 24 08          	mov    %eax,0x8(%esp)
80104269:	e8 e2 c3 ff ff       	call   80100650 <cprintf>
8010426e:	eb 82                	jmp    801041f2 <cps+0x32>
	else if(p->state == RUNNABLE)
 	  cprintf("%s \t %d \t RUNNABLE \t %d \n ", p->name,p->pid,p->priority);
80104270:	8b 43 10             	mov    0x10(%ebx),%eax
80104273:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104277:	c7 04 24 ea 76 10 80 	movl   $0x801076ea,(%esp)
8010427e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80104282:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104285:	89 44 24 08          	mov    %eax,0x8(%esp)
80104289:	e8 c2 c3 ff ff       	call   80100650 <cprintf>
8010428e:	e9 5f ff ff ff       	jmp    801041f2 <cps+0x32>
80104293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042a0 <chpr>:
return 22;
}

int 
chpr(int pid, int priority)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	56                   	push   %esi
801042a4:	53                   	push   %ebx
801042a5:	83 ec 10             	sub    $0x10,%esp
801042a8:	8b 75 0c             	mov    0xc(%ebp),%esi
801042ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;
    int found = 0;
    if (priority < -20 || priority > 19) {
801042ae:	8d 46 14             	lea    0x14(%esi),%eax
801042b1:	83 f8 27             	cmp    $0x27,%eax
801042b4:	77 56                	ja     8010430c <chpr+0x6c>
        return -1; // Invalid priority
    }
    
    acquire(&ptable.lock);
801042b6:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801042bd:	e8 1e 02 00 00       	call   801044e0 <acquire>
    
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042c2:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
801042c7:	eb 13                	jmp    801042dc <chpr+0x3c>
801042c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042d0:	05 84 00 00 00       	add    $0x84,%eax
801042d5:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
801042da:	74 24                	je     80104300 <chpr+0x60>
        if (p->pid == pid) {
801042dc:	39 58 10             	cmp    %ebx,0x10(%eax)
801042df:	75 ef                	jne    801042d0 <chpr+0x30>
            p->priority = priority;
801042e1:	89 70 7c             	mov    %esi,0x7c(%eax)
            found = 1;
            break;
        }
    }
    
    release(&ptable.lock);
801042e4:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801042eb:	e8 20 03 00 00       	call   80104610 <release>
    }
    
    
    
    return 0; // Success
}
801042f0:	83 c4 10             	add    $0x10,%esp
        return -1; // Process not found
    }
    
    
    
    return 0; // Success
801042f3:	31 c0                	xor    %eax,%eax
}
801042f5:	5b                   	pop    %ebx
801042f6:	5e                   	pop    %esi
801042f7:	5d                   	pop    %ebp
801042f8:	c3                   	ret    
801042f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            found = 1;
            break;
        }
    }
    
    release(&ptable.lock);
80104300:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104307:	e8 04 03 00 00       	call   80104610 <release>
    }
    
    
    
    return 0; // Success
}
8010430c:	83 c4 10             	add    $0x10,%esp
    }
    
    release(&ptable.lock);
    
    if (!found) {
        return -1; // Process not found
8010430f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    
    
    
    return 0; // Success
}
80104314:	5b                   	pop    %ebx
80104315:	5e                   	pop    %esi
80104316:	5d                   	pop    %ebp
80104317:	c3                   	ret    
80104318:	90                   	nop
80104319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104320 <chr>:
unsigned int xorshift_state = 12345;

int
chr()
{
    xorshift_state ^= (xorshift_state << 13);
80104320:	8b 15 08 a0 10 80    	mov    0x8010a008,%edx
}
unsigned int xorshift_state = 12345;

int
chr()
{
80104326:	55                   	push   %ebp
80104327:	89 e5                	mov    %esp,%ebp
    xorshift_state ^= (xorshift_state << 13);
    xorshift_state ^= (xorshift_state >> 17);
    xorshift_state ^= (xorshift_state << 5);
    return xorshift_state;
}
80104329:	5d                   	pop    %ebp
unsigned int xorshift_state = 12345;

int
chr()
{
    xorshift_state ^= (xorshift_state << 13);
8010432a:	89 d0                	mov    %edx,%eax
8010432c:	c1 e0 0d             	shl    $0xd,%eax
8010432f:	31 d0                	xor    %edx,%eax
    xorshift_state ^= (xorshift_state >> 17);
80104331:	89 c2                	mov    %eax,%edx
80104333:	c1 ea 11             	shr    $0x11,%edx
80104336:	31 c2                	xor    %eax,%edx
    xorshift_state ^= (xorshift_state << 5);
80104338:	89 d0                	mov    %edx,%eax
8010433a:	c1 e0 05             	shl    $0x5,%eax
8010433d:	31 d0                	xor    %edx,%eax
8010433f:	a3 08 a0 10 80       	mov    %eax,0x8010a008
    return xorshift_state;
}
80104344:	c3                   	ret    
80104345:	66 90                	xchg   %ax,%ax
80104347:	66 90                	xchg   %ax,%ax
80104349:	66 90                	xchg   %ax,%ax
8010434b:	66 90                	xchg   %ax,%ax
8010434d:	66 90                	xchg   %ax,%ax
8010434f:	90                   	nop

80104350 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 14             	sub    $0x14,%esp
80104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010435a:	c7 44 24 04 68 77 10 	movl   $0x80107768,0x4(%esp)
80104361:	80 
80104362:	8d 43 04             	lea    0x4(%ebx),%eax
80104365:	89 04 24             	mov    %eax,(%esp)
80104368:	e8 f3 00 00 00       	call   80104460 <initlock>
  lk->name = name;
8010436d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104370:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104376:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010437d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104380:	83 c4 14             	add    $0x14,%esp
80104383:	5b                   	pop    %ebx
80104384:	5d                   	pop    %ebp
80104385:	c3                   	ret    
80104386:	8d 76 00             	lea    0x0(%esi),%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104390 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	56                   	push   %esi
80104394:	53                   	push   %ebx
80104395:	83 ec 10             	sub    $0x10,%esp
80104398:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010439b:	8d 73 04             	lea    0x4(%ebx),%esi
8010439e:	89 34 24             	mov    %esi,(%esp)
801043a1:	e8 3a 01 00 00       	call   801044e0 <acquire>
  while (lk->locked) {
801043a6:	8b 13                	mov    (%ebx),%edx
801043a8:	85 d2                	test   %edx,%edx
801043aa:	74 16                	je     801043c2 <acquiresleep+0x32>
801043ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801043b0:	89 74 24 04          	mov    %esi,0x4(%esp)
801043b4:	89 1c 24             	mov    %ebx,(%esp)
801043b7:	e8 84 fa ff ff       	call   80103e40 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801043bc:	8b 03                	mov    (%ebx),%eax
801043be:	85 c0                	test   %eax,%eax
801043c0:	75 ee                	jne    801043b0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801043c2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
801043c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043ce:	8b 40 10             	mov    0x10(%eax),%eax
801043d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043d7:	83 c4 10             	add    $0x10,%esp
801043da:	5b                   	pop    %ebx
801043db:	5e                   	pop    %esi
801043dc:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
801043dd:	e9 2e 02 00 00       	jmp    80104610 <release>
801043e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043f0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
801043f5:	83 ec 10             	sub    $0x10,%esp
801043f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043fb:	8d 73 04             	lea    0x4(%ebx),%esi
801043fe:	89 34 24             	mov    %esi,(%esp)
80104401:	e8 da 00 00 00       	call   801044e0 <acquire>
  lk->locked = 0;
80104406:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010440c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104413:	89 1c 24             	mov    %ebx,(%esp)
80104416:	e8 d5 fb ff ff       	call   80103ff0 <wakeup>
  release(&lk->lk);
8010441b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010441e:	83 c4 10             	add    $0x10,%esp
80104421:	5b                   	pop    %ebx
80104422:	5e                   	pop    %esi
80104423:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104424:	e9 e7 01 00 00       	jmp    80104610 <release>
80104429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104430 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
80104435:	83 ec 10             	sub    $0x10,%esp
80104438:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010443b:	8d 73 04             	lea    0x4(%ebx),%esi
8010443e:	89 34 24             	mov    %esi,(%esp)
80104441:	e8 9a 00 00 00       	call   801044e0 <acquire>
  r = lk->locked;
80104446:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104448:	89 34 24             	mov    %esi,(%esp)
8010444b:	e8 c0 01 00 00       	call   80104610 <release>
  return r;
}
80104450:	83 c4 10             	add    $0x10,%esp
80104453:	89 d8                	mov    %ebx,%eax
80104455:	5b                   	pop    %ebx
80104456:	5e                   	pop    %esi
80104457:	5d                   	pop    %ebp
80104458:	c3                   	ret    
80104459:	66 90                	xchg   %ax,%ax
8010445b:	66 90                	xchg   %ax,%ax
8010445d:	66 90                	xchg   %ax,%ax
8010445f:	90                   	nop

80104460 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104466:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010446f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104472:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104479:	5d                   	pop    %ebp
8010447a:	c3                   	ret    
8010447b:	90                   	nop
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104480 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104483:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104486:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104489:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010448a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010448d:	31 c0                	xor    %eax,%eax
8010448f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104490:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104496:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010449c:	77 1a                	ja     801044b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010449e:	8b 5a 04             	mov    0x4(%edx),%ebx
801044a1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044a4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801044a7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044a9:	83 f8 0a             	cmp    $0xa,%eax
801044ac:	75 e2                	jne    80104490 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044ae:	5b                   	pop    %ebx
801044af:	5d                   	pop    %ebp
801044b0:	c3                   	ret    
801044b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801044b8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801044bf:	83 c0 01             	add    $0x1,%eax
801044c2:	83 f8 0a             	cmp    $0xa,%eax
801044c5:	74 e7                	je     801044ae <getcallerpcs+0x2e>
    pcs[i] = 0;
801044c7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801044ce:	83 c0 01             	add    $0x1,%eax
801044d1:	83 f8 0a             	cmp    $0xa,%eax
801044d4:	75 e2                	jne    801044b8 <getcallerpcs+0x38>
801044d6:	eb d6                	jmp    801044ae <getcallerpcs+0x2e>
801044d8:	90                   	nop
801044d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044e0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044e6:	9c                   	pushf  
801044e7:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801044e8:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801044e9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801044ef:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801044f5:	85 d2                	test   %edx,%edx
801044f7:	75 0c                	jne    80104505 <acquire+0x25>
    cpu->intena = eflags & FL_IF;
801044f9:	81 e1 00 02 00 00    	and    $0x200,%ecx
801044ff:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
80104505:	83 c2 01             	add    $0x1,%edx
80104508:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
8010450e:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104511:	8b 0a                	mov    (%edx),%ecx
80104513:	85 c9                	test   %ecx,%ecx
80104515:	74 05                	je     8010451c <acquire+0x3c>
80104517:	3b 42 08             	cmp    0x8(%edx),%eax
8010451a:	74 3e                	je     8010455a <acquire+0x7a>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010451c:	b9 01 00 00 00       	mov    $0x1,%ecx
80104521:	eb 08                	jmp    8010452b <acquire+0x4b>
80104523:	90                   	nop
80104524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104528:	8b 55 08             	mov    0x8(%ebp),%edx
8010452b:	89 c8                	mov    %ecx,%eax
8010452d:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104530:	85 c0                	test   %eax,%eax
80104532:	75 f4                	jne    80104528 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104534:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104539:	8b 45 08             	mov    0x8(%ebp),%eax
8010453c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  getcallerpcs(&lk, lk->pcs);
80104543:	83 c0 0c             	add    $0xc,%eax
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104546:	89 50 fc             	mov    %edx,-0x4(%eax)
  getcallerpcs(&lk, lk->pcs);
80104549:	89 44 24 04          	mov    %eax,0x4(%esp)
8010454d:	8d 45 08             	lea    0x8(%ebp),%eax
80104550:	89 04 24             	mov    %eax,(%esp)
80104553:	e8 28 ff ff ff       	call   80104480 <getcallerpcs>
}
80104558:	c9                   	leave  
80104559:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
8010455a:	c7 04 24 73 77 10 80 	movl   $0x80107773,(%esp)
80104561:	e8 fa bd ff ff       	call   80100360 <panic>
80104566:	8d 76 00             	lea    0x0(%esi),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104570:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
80104571:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104573:	89 e5                	mov    %esp,%ebp
80104575:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104578:	8b 0a                	mov    (%edx),%ecx
8010457a:	85 c9                	test   %ecx,%ecx
8010457c:	74 0f                	je     8010458d <holding+0x1d>
8010457e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104584:	39 42 08             	cmp    %eax,0x8(%edx)
80104587:	0f 94 c0             	sete   %al
8010458a:	0f b6 c0             	movzbl %al,%eax
}
8010458d:	5d                   	pop    %ebp
8010458e:	c3                   	ret    
8010458f:	90                   	nop

80104590 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104593:	9c                   	pushf  
80104594:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104595:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104596:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010459c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801045a2:	85 d2                	test   %edx,%edx
801045a4:	75 0c                	jne    801045b2 <pushcli+0x22>
    cpu->intena = eflags & FL_IF;
801045a6:	81 e1 00 02 00 00    	and    $0x200,%ecx
801045ac:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
801045b2:	83 c2 01             	add    $0x1,%edx
801045b5:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
801045bb:	5d                   	pop    %ebp
801045bc:	c3                   	ret    
801045bd:	8d 76 00             	lea    0x0(%esi),%esi

801045c0 <popcli>:

void
popcli(void)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045c6:	9c                   	pushf  
801045c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045c8:	f6 c4 02             	test   $0x2,%ah
801045cb:	75 34                	jne    80104601 <popcli+0x41>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
801045cd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801045d3:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
801045d9:	8d 51 ff             	lea    -0x1(%ecx),%edx
801045dc:	85 d2                	test   %edx,%edx
801045de:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801045e4:	78 0f                	js     801045f5 <popcli+0x35>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
801045e6:	75 0b                	jne    801045f3 <popcli+0x33>
801045e8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801045ee:	85 c0                	test   %eax,%eax
801045f0:	74 01                	je     801045f3 <popcli+0x33>
}

static inline void
sti(void)
{
  asm volatile("sti");
801045f2:	fb                   	sti    
    sti();
}
801045f3:	c9                   	leave  
801045f4:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
801045f5:	c7 04 24 92 77 10 80 	movl   $0x80107792,(%esp)
801045fc:	e8 5f bd ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104601:	c7 04 24 7b 77 10 80 	movl   $0x8010777b,(%esp)
80104608:	e8 53 bd ff ff       	call   80100360 <panic>
8010460d:	8d 76 00             	lea    0x0(%esi),%esi

80104610 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	83 ec 18             	sub    $0x18,%esp
80104616:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104619:	8b 10                	mov    (%eax),%edx
8010461b:	85 d2                	test   %edx,%edx
8010461d:	74 0c                	je     8010462b <release+0x1b>
8010461f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104626:	39 50 08             	cmp    %edx,0x8(%eax)
80104629:	74 0d                	je     80104638 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010462b:	c7 04 24 99 77 10 80 	movl   $0x80107799,(%esp)
80104632:	e8 29 bd ff ff       	call   80100360 <panic>
80104637:	90                   	nop

  lk->pcs[0] = 0;
80104638:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010463f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104646:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010464b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
80104651:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104652:	e9 69 ff ff ff       	jmp    801045c0 <popcli>
80104657:	66 90                	xchg   %ax,%ax
80104659:	66 90                	xchg   %ax,%ax
8010465b:	66 90                	xchg   %ax,%ax
8010465d:	66 90                	xchg   %ax,%ax
8010465f:	90                   	nop

80104660 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	8b 55 08             	mov    0x8(%ebp),%edx
80104666:	57                   	push   %edi
80104667:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010466a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010466b:	f6 c2 03             	test   $0x3,%dl
8010466e:	75 05                	jne    80104675 <memset+0x15>
80104670:	f6 c1 03             	test   $0x3,%cl
80104673:	74 13                	je     80104688 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104675:	89 d7                	mov    %edx,%edi
80104677:	8b 45 0c             	mov    0xc(%ebp),%eax
8010467a:	fc                   	cld    
8010467b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010467d:	5b                   	pop    %ebx
8010467e:	89 d0                	mov    %edx,%eax
80104680:	5f                   	pop    %edi
80104681:	5d                   	pop    %ebp
80104682:	c3                   	ret    
80104683:	90                   	nop
80104684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104688:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010468c:	c1 e9 02             	shr    $0x2,%ecx
8010468f:	89 f8                	mov    %edi,%eax
80104691:	89 fb                	mov    %edi,%ebx
80104693:	c1 e0 18             	shl    $0x18,%eax
80104696:	c1 e3 10             	shl    $0x10,%ebx
80104699:	09 d8                	or     %ebx,%eax
8010469b:	09 f8                	or     %edi,%eax
8010469d:	c1 e7 08             	shl    $0x8,%edi
801046a0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801046a2:	89 d7                	mov    %edx,%edi
801046a4:	fc                   	cld    
801046a5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046a7:	5b                   	pop    %ebx
801046a8:	89 d0                	mov    %edx,%eax
801046aa:	5f                   	pop    %edi
801046ab:	5d                   	pop    %ebp
801046ac:	c3                   	ret    
801046ad:	8d 76 00             	lea    0x0(%esi),%esi

801046b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	8b 45 10             	mov    0x10(%ebp),%eax
801046b6:	57                   	push   %edi
801046b7:	56                   	push   %esi
801046b8:	8b 75 0c             	mov    0xc(%ebp),%esi
801046bb:	53                   	push   %ebx
801046bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046bf:	85 c0                	test   %eax,%eax
801046c1:	8d 78 ff             	lea    -0x1(%eax),%edi
801046c4:	74 26                	je     801046ec <memcmp+0x3c>
    if(*s1 != *s2)
801046c6:	0f b6 03             	movzbl (%ebx),%eax
801046c9:	31 d2                	xor    %edx,%edx
801046cb:	0f b6 0e             	movzbl (%esi),%ecx
801046ce:	38 c8                	cmp    %cl,%al
801046d0:	74 16                	je     801046e8 <memcmp+0x38>
801046d2:	eb 24                	jmp    801046f8 <memcmp+0x48>
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046d8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801046dd:	83 c2 01             	add    $0x1,%edx
801046e0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801046e4:	38 c8                	cmp    %cl,%al
801046e6:	75 10                	jne    801046f8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046e8:	39 fa                	cmp    %edi,%edx
801046ea:	75 ec                	jne    801046d8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801046ec:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801046ed:	31 c0                	xor    %eax,%eax
}
801046ef:	5e                   	pop    %esi
801046f0:	5f                   	pop    %edi
801046f1:	5d                   	pop    %ebp
801046f2:	c3                   	ret    
801046f3:	90                   	nop
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046f8:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801046f9:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801046fb:	5e                   	pop    %esi
801046fc:	5f                   	pop    %edi
801046fd:	5d                   	pop    %ebp
801046fe:	c3                   	ret    
801046ff:	90                   	nop

80104700 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	8b 45 08             	mov    0x8(%ebp),%eax
80104707:	56                   	push   %esi
80104708:	8b 75 0c             	mov    0xc(%ebp),%esi
8010470b:	53                   	push   %ebx
8010470c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010470f:	39 c6                	cmp    %eax,%esi
80104711:	73 35                	jae    80104748 <memmove+0x48>
80104713:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104716:	39 c8                	cmp    %ecx,%eax
80104718:	73 2e                	jae    80104748 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010471a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010471c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010471f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104722:	74 1b                	je     8010473f <memmove+0x3f>
80104724:	f7 db                	neg    %ebx
80104726:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104729:	01 fb                	add    %edi,%ebx
8010472b:	90                   	nop
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104730:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104734:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104737:	83 ea 01             	sub    $0x1,%edx
8010473a:	83 fa ff             	cmp    $0xffffffff,%edx
8010473d:	75 f1                	jne    80104730 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010473f:	5b                   	pop    %ebx
80104740:	5e                   	pop    %esi
80104741:	5f                   	pop    %edi
80104742:	5d                   	pop    %ebp
80104743:	c3                   	ret    
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104748:	31 d2                	xor    %edx,%edx
8010474a:	85 db                	test   %ebx,%ebx
8010474c:	74 f1                	je     8010473f <memmove+0x3f>
8010474e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104750:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104754:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104757:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010475a:	39 da                	cmp    %ebx,%edx
8010475c:	75 f2                	jne    80104750 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010475e:	5b                   	pop    %ebx
8010475f:	5e                   	pop    %esi
80104760:	5f                   	pop    %edi
80104761:	5d                   	pop    %ebp
80104762:	c3                   	ret    
80104763:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104770 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104773:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104774:	e9 87 ff ff ff       	jmp    80104700 <memmove>
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104780 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	8b 75 10             	mov    0x10(%ebp),%esi
80104787:	53                   	push   %ebx
80104788:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010478b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010478e:	85 f6                	test   %esi,%esi
80104790:	74 30                	je     801047c2 <strncmp+0x42>
80104792:	0f b6 01             	movzbl (%ecx),%eax
80104795:	84 c0                	test   %al,%al
80104797:	74 2f                	je     801047c8 <strncmp+0x48>
80104799:	0f b6 13             	movzbl (%ebx),%edx
8010479c:	38 d0                	cmp    %dl,%al
8010479e:	75 46                	jne    801047e6 <strncmp+0x66>
801047a0:	8d 51 01             	lea    0x1(%ecx),%edx
801047a3:	01 ce                	add    %ecx,%esi
801047a5:	eb 14                	jmp    801047bb <strncmp+0x3b>
801047a7:	90                   	nop
801047a8:	0f b6 02             	movzbl (%edx),%eax
801047ab:	84 c0                	test   %al,%al
801047ad:	74 31                	je     801047e0 <strncmp+0x60>
801047af:	0f b6 19             	movzbl (%ecx),%ebx
801047b2:	83 c2 01             	add    $0x1,%edx
801047b5:	38 d8                	cmp    %bl,%al
801047b7:	75 17                	jne    801047d0 <strncmp+0x50>
    n--, p++, q++;
801047b9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801047bb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801047bd:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801047c0:	75 e6                	jne    801047a8 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801047c2:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801047c3:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801047c5:	5e                   	pop    %esi
801047c6:	5d                   	pop    %ebp
801047c7:	c3                   	ret    
801047c8:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801047cb:	31 c0                	xor    %eax,%eax
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047d0:	0f b6 d3             	movzbl %bl,%edx
801047d3:	29 d0                	sub    %edx,%eax
}
801047d5:	5b                   	pop    %ebx
801047d6:	5e                   	pop    %esi
801047d7:	5d                   	pop    %ebp
801047d8:	c3                   	ret    
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047e0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801047e4:	eb ea                	jmp    801047d0 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801047e6:	89 d3                	mov    %edx,%ebx
801047e8:	eb e6                	jmp    801047d0 <strncmp+0x50>
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047f0 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	8b 45 08             	mov    0x8(%ebp),%eax
801047f6:	56                   	push   %esi
801047f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047fa:	53                   	push   %ebx
801047fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801047fe:	89 c2                	mov    %eax,%edx
80104800:	eb 19                	jmp    8010481b <strncpy+0x2b>
80104802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104808:	83 c3 01             	add    $0x1,%ebx
8010480b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010480f:	83 c2 01             	add    $0x1,%edx
80104812:	84 c9                	test   %cl,%cl
80104814:	88 4a ff             	mov    %cl,-0x1(%edx)
80104817:	74 09                	je     80104822 <strncpy+0x32>
80104819:	89 f1                	mov    %esi,%ecx
8010481b:	85 c9                	test   %ecx,%ecx
8010481d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104820:	7f e6                	jg     80104808 <strncpy+0x18>
    ;
  while(n-- > 0)
80104822:	31 c9                	xor    %ecx,%ecx
80104824:	85 f6                	test   %esi,%esi
80104826:	7e 0f                	jle    80104837 <strncpy+0x47>
    *s++ = 0;
80104828:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010482c:	89 f3                	mov    %esi,%ebx
8010482e:	83 c1 01             	add    $0x1,%ecx
80104831:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104833:	85 db                	test   %ebx,%ebx
80104835:	7f f1                	jg     80104828 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104837:	5b                   	pop    %ebx
80104838:	5e                   	pop    %esi
80104839:	5d                   	pop    %ebp
8010483a:	c3                   	ret    
8010483b:	90                   	nop
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104840 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104846:	56                   	push   %esi
80104847:	8b 45 08             	mov    0x8(%ebp),%eax
8010484a:	53                   	push   %ebx
8010484b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010484e:	85 c9                	test   %ecx,%ecx
80104850:	7e 26                	jle    80104878 <safestrcpy+0x38>
80104852:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104856:	89 c1                	mov    %eax,%ecx
80104858:	eb 17                	jmp    80104871 <safestrcpy+0x31>
8010485a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104860:	83 c2 01             	add    $0x1,%edx
80104863:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104867:	83 c1 01             	add    $0x1,%ecx
8010486a:	84 db                	test   %bl,%bl
8010486c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010486f:	74 04                	je     80104875 <safestrcpy+0x35>
80104871:	39 f2                	cmp    %esi,%edx
80104873:	75 eb                	jne    80104860 <safestrcpy+0x20>
    ;
  *s = 0;
80104875:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104878:	5b                   	pop    %ebx
80104879:	5e                   	pop    %esi
8010487a:	5d                   	pop    %ebp
8010487b:	c3                   	ret    
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104880 <strlen>:

int
strlen(const char *s)
{
80104880:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104881:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104883:	89 e5                	mov    %esp,%ebp
80104885:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104888:	80 3a 00             	cmpb   $0x0,(%edx)
8010488b:	74 0c                	je     80104899 <strlen+0x19>
8010488d:	8d 76 00             	lea    0x0(%esi),%esi
80104890:	83 c0 01             	add    $0x1,%eax
80104893:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104897:	75 f7                	jne    80104890 <strlen+0x10>
    ;
  return n;
}
80104899:	5d                   	pop    %ebp
8010489a:	c3                   	ret    

8010489b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010489b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010489f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801048a3:	55                   	push   %ebp
  pushl %ebx
801048a4:	53                   	push   %ebx
  pushl %esi
801048a5:	56                   	push   %esi
  pushl %edi
801048a6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048a7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048a9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801048ab:	5f                   	pop    %edi
  popl %esi
801048ac:	5e                   	pop    %esi
  popl %ebx
801048ad:	5b                   	pop    %ebx
  popl %ebp
801048ae:	5d                   	pop    %ebp
  ret
801048af:	c3                   	ret    

801048b0 <fetchint>:

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801048b0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048b7:	55                   	push   %ebp
801048b8:	89 e5                	mov    %esp,%ebp
801048ba:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
801048bd:	8b 12                	mov    (%edx),%edx
801048bf:	39 c2                	cmp    %eax,%edx
801048c1:	76 15                	jbe    801048d8 <fetchint+0x28>
801048c3:	8d 48 04             	lea    0x4(%eax),%ecx
801048c6:	39 ca                	cmp    %ecx,%edx
801048c8:	72 0e                	jb     801048d8 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
801048ca:	8b 10                	mov    (%eax),%edx
801048cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801048cf:	89 10                	mov    %edx,(%eax)
  return 0;
801048d1:	31 c0                	xor    %eax,%eax
}
801048d3:	5d                   	pop    %ebp
801048d4:	c3                   	ret    
801048d5:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
801048d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
801048dd:	5d                   	pop    %ebp
801048de:	c3                   	ret    
801048df:	90                   	nop

801048e0 <fetchstr>:
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801048e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048e6:	55                   	push   %ebp
801048e7:	89 e5                	mov    %esp,%ebp
801048e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
801048ec:	39 08                	cmp    %ecx,(%eax)
801048ee:	76 2c                	jbe    8010491c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801048f0:	8b 55 0c             	mov    0xc(%ebp),%edx
801048f3:	89 c8                	mov    %ecx,%eax
801048f5:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801048f7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048fe:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104900:	39 d1                	cmp    %edx,%ecx
80104902:	73 18                	jae    8010491c <fetchstr+0x3c>
    if(*s == 0)
80104904:	80 39 00             	cmpb   $0x0,(%ecx)
80104907:	75 0c                	jne    80104915 <fetchstr+0x35>
80104909:	eb 1d                	jmp    80104928 <fetchstr+0x48>
8010490b:	90                   	nop
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104910:	80 38 00             	cmpb   $0x0,(%eax)
80104913:	74 13                	je     80104928 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104915:	83 c0 01             	add    $0x1,%eax
80104918:	39 c2                	cmp    %eax,%edx
8010491a:	77 f4                	ja     80104910 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
8010491c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104921:	5d                   	pop    %ebp
80104922:	c3                   	ret    
80104923:	90                   	nop
80104924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
80104928:	29 c8                	sub    %ecx,%eax
  return -1;
}
8010492a:	5d                   	pop    %ebp
8010492b:	c3                   	ret    
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104930 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104930:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104937:	55                   	push   %ebp
80104938:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010493a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010493d:	8b 42 18             	mov    0x18(%edx),%eax

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104940:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104942:	8b 40 44             	mov    0x44(%eax),%eax
80104945:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104948:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010494b:	39 d1                	cmp    %edx,%ecx
8010494d:	73 19                	jae    80104968 <argint+0x38>
8010494f:	8d 48 08             	lea    0x8(%eax),%ecx
80104952:	39 ca                	cmp    %ecx,%edx
80104954:	72 12                	jb     80104968 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80104956:	8b 50 04             	mov    0x4(%eax),%edx
80104959:	8b 45 0c             	mov    0xc(%ebp),%eax
8010495c:	89 10                	mov    %edx,(%eax)
  return 0;
8010495e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104960:	5d                   	pop    %ebp
80104961:	c3                   	ret    
80104962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104968:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
8010496d:	5d                   	pop    %ebp
8010496e:	c3                   	ret    
8010496f:	90                   	nop

80104970 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104970:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104976:	55                   	push   %ebp
80104977:	89 e5                	mov    %esp,%ebp
80104979:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010497a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010497d:	8b 50 18             	mov    0x18(%eax),%edx
80104980:	8b 52 44             	mov    0x44(%edx),%edx
80104983:	8d 0c 8a             	lea    (%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104986:	8b 10                	mov    (%eax),%edx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
80104988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010498d:	8d 59 04             	lea    0x4(%ecx),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104990:	39 d3                	cmp    %edx,%ebx
80104992:	73 25                	jae    801049b9 <argptr+0x49>
80104994:	8d 59 08             	lea    0x8(%ecx),%ebx
80104997:	39 da                	cmp    %ebx,%edx
80104999:	72 1e                	jb     801049b9 <argptr+0x49>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
8010499b:	8b 5d 10             	mov    0x10(%ebp),%ebx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
8010499e:	8b 49 04             	mov    0x4(%ecx),%ecx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
801049a1:	85 db                	test   %ebx,%ebx
801049a3:	78 14                	js     801049b9 <argptr+0x49>
801049a5:	39 d1                	cmp    %edx,%ecx
801049a7:	73 10                	jae    801049b9 <argptr+0x49>
801049a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
801049ac:	01 cb                	add    %ecx,%ebx
801049ae:	39 d3                	cmp    %edx,%ebx
801049b0:	77 07                	ja     801049b9 <argptr+0x49>
    return -1;
  *pp = (char*)i;
801049b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801049b5:	89 08                	mov    %ecx,(%eax)
  return 0;
801049b7:	31 c0                	xor    %eax,%eax
}
801049b9:	5b                   	pop    %ebx
801049ba:	5d                   	pop    %ebp
801049bb:	c3                   	ret    
801049bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049c0 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801049c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801049c6:	55                   	push   %ebp
801049c7:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801049c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049cc:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801049cf:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801049d1:	8b 52 44             	mov    0x44(%edx),%edx
801049d4:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
801049d7:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801049da:	39 c1                	cmp    %eax,%ecx
801049dc:	73 07                	jae    801049e5 <argstr+0x25>
801049de:	8d 4a 08             	lea    0x8(%edx),%ecx
801049e1:	39 c8                	cmp    %ecx,%eax
801049e3:	73 0b                	jae    801049f0 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801049e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801049ea:	5d                   	pop    %ebp
801049eb:	c3                   	ret    
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
801049f0:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801049f3:	39 c1                	cmp    %eax,%ecx
801049f5:	73 ee                	jae    801049e5 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
801049f7:	8b 55 0c             	mov    0xc(%ebp),%edx
801049fa:	89 c8                	mov    %ecx,%eax
801049fc:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801049fe:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a05:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104a07:	39 d1                	cmp    %edx,%ecx
80104a09:	73 da                	jae    801049e5 <argstr+0x25>
    if(*s == 0)
80104a0b:	80 39 00             	cmpb   $0x0,(%ecx)
80104a0e:	75 12                	jne    80104a22 <argstr+0x62>
80104a10:	eb 1e                	jmp    80104a30 <argstr+0x70>
80104a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a18:	80 38 00             	cmpb   $0x0,(%eax)
80104a1b:	90                   	nop
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a20:	74 0e                	je     80104a30 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104a22:	83 c0 01             	add    $0x1,%eax
80104a25:	39 c2                	cmp    %eax,%edx
80104a27:	77 ef                	ja     80104a18 <argstr+0x58>
80104a29:	eb ba                	jmp    801049e5 <argstr+0x25>
80104a2b:	90                   	nop
80104a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
80104a30:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104a32:	5d                   	pop    %ebp
80104a33:	c3                   	ret    
80104a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a40 <syscall>:
[SYS_chr]    sys_chr,
};

void
syscall(void)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80104a47:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a4e:	8b 5a 18             	mov    0x18(%edx),%ebx
80104a51:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a54:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104a57:	83 f9 18             	cmp    $0x18,%ecx
80104a5a:	77 1c                	ja     80104a78 <syscall+0x38>
80104a5c:	8b 0c 85 c0 77 10 80 	mov    -0x7fef8840(,%eax,4),%ecx
80104a63:	85 c9                	test   %ecx,%ecx
80104a65:	74 11                	je     80104a78 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104a67:	ff d1                	call   *%ecx
80104a69:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
80104a6c:	83 c4 14             	add    $0x14,%esp
80104a6f:	5b                   	pop    %ebx
80104a70:	5d                   	pop    %ebp
80104a71:	c3                   	ret    
80104a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104a78:	89 44 24 0c          	mov    %eax,0xc(%esp)
            proc->pid, proc->name, num);
80104a7c:	8d 42 6c             	lea    0x6c(%edx),%eax
80104a7f:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104a83:	8b 42 10             	mov    0x10(%edx),%eax
80104a86:	c7 04 24 a1 77 10 80 	movl   $0x801077a1,(%esp)
80104a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a91:	e8 ba bb ff ff       	call   80100650 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80104a96:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a9c:	8b 40 18             	mov    0x18(%eax),%eax
80104a9f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104aa6:	83 c4 14             	add    $0x14,%esp
80104aa9:	5b                   	pop    %ebx
80104aaa:	5d                   	pop    %ebp
80104aab:	c3                   	ret    
80104aac:	66 90                	xchg   %ax,%ax
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	56                   	push   %esi
80104ab5:	53                   	push   %ebx
80104ab6:	83 ec 4c             	sub    $0x4c,%esp
80104ab9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104abc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104abf:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104ac2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104ac6:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ac9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104acc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104acf:	e8 3c d4 ff ff       	call   80101f10 <nameiparent>
80104ad4:	85 c0                	test   %eax,%eax
80104ad6:	89 c7                	mov    %eax,%edi
80104ad8:	0f 84 da 00 00 00    	je     80104bb8 <create+0x108>
    return 0;
  ilock(dp);
80104ade:	89 04 24             	mov    %eax,(%esp)
80104ae1:	e8 da cb ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104ae6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104ae9:	89 44 24 08          	mov    %eax,0x8(%esp)
80104aed:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104af1:	89 3c 24             	mov    %edi,(%esp)
80104af4:	e8 b7 d0 ff ff       	call   80101bb0 <dirlookup>
80104af9:	85 c0                	test   %eax,%eax
80104afb:	89 c6                	mov    %eax,%esi
80104afd:	74 41                	je     80104b40 <create+0x90>
    iunlockput(dp);
80104aff:	89 3c 24             	mov    %edi,(%esp)
80104b02:	e8 f9 cd ff ff       	call   80101900 <iunlockput>
    ilock(ip);
80104b07:	89 34 24             	mov    %esi,(%esp)
80104b0a:	e8 b1 cb ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b0f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104b14:	75 12                	jne    80104b28 <create+0x78>
80104b16:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b1b:	89 f0                	mov    %esi,%eax
80104b1d:	75 09                	jne    80104b28 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b1f:	83 c4 4c             	add    $0x4c,%esp
80104b22:	5b                   	pop    %ebx
80104b23:	5e                   	pop    %esi
80104b24:	5f                   	pop    %edi
80104b25:	5d                   	pop    %ebp
80104b26:	c3                   	ret    
80104b27:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104b28:	89 34 24             	mov    %esi,(%esp)
80104b2b:	e8 d0 cd ff ff       	call   80101900 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b30:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104b33:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b35:	5b                   	pop    %ebx
80104b36:	5e                   	pop    %esi
80104b37:	5f                   	pop    %edi
80104b38:	5d                   	pop    %ebp
80104b39:	c3                   	ret    
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104b40:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104b44:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b48:	8b 07                	mov    (%edi),%eax
80104b4a:	89 04 24             	mov    %eax,(%esp)
80104b4d:	e8 de c9 ff ff       	call   80101530 <ialloc>
80104b52:	85 c0                	test   %eax,%eax
80104b54:	89 c6                	mov    %eax,%esi
80104b56:	0f 84 bf 00 00 00    	je     80104c1b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
80104b5c:	89 04 24             	mov    %eax,(%esp)
80104b5f:	e8 5c cb ff ff       	call   801016c0 <ilock>
  ip->major = major;
80104b64:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104b68:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104b6c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104b70:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104b74:	b8 01 00 00 00       	mov    $0x1,%eax
80104b79:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104b7d:	89 34 24             	mov    %esi,(%esp)
80104b80:	e8 7b ca ff ff       	call   80101600 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104b85:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104b8a:	74 34                	je     80104bc0 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104b8c:	8b 46 04             	mov    0x4(%esi),%eax
80104b8f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104b93:	89 3c 24             	mov    %edi,(%esp)
80104b96:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b9a:	e8 71 d2 ff ff       	call   80101e10 <dirlink>
80104b9f:	85 c0                	test   %eax,%eax
80104ba1:	78 6c                	js     80104c0f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80104ba3:	89 3c 24             	mov    %edi,(%esp)
80104ba6:	e8 55 cd ff ff       	call   80101900 <iunlockput>

  return ip;
}
80104bab:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104bae:	89 f0                	mov    %esi,%eax
}
80104bb0:	5b                   	pop    %ebx
80104bb1:	5e                   	pop    %esi
80104bb2:	5f                   	pop    %edi
80104bb3:	5d                   	pop    %ebp
80104bb4:	c3                   	ret    
80104bb5:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104bb8:	31 c0                	xor    %eax,%eax
80104bba:	e9 60 ff ff ff       	jmp    80104b1f <create+0x6f>
80104bbf:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104bc0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104bc5:	89 3c 24             	mov    %edi,(%esp)
80104bc8:	e8 33 ca ff ff       	call   80101600 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104bcd:	8b 46 04             	mov    0x4(%esi),%eax
80104bd0:	c7 44 24 04 44 78 10 	movl   $0x80107844,0x4(%esp)
80104bd7:	80 
80104bd8:	89 34 24             	mov    %esi,(%esp)
80104bdb:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bdf:	e8 2c d2 ff ff       	call   80101e10 <dirlink>
80104be4:	85 c0                	test   %eax,%eax
80104be6:	78 1b                	js     80104c03 <create+0x153>
80104be8:	8b 47 04             	mov    0x4(%edi),%eax
80104beb:	c7 44 24 04 43 78 10 	movl   $0x80107843,0x4(%esp)
80104bf2:	80 
80104bf3:	89 34 24             	mov    %esi,(%esp)
80104bf6:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bfa:	e8 11 d2 ff ff       	call   80101e10 <dirlink>
80104bff:	85 c0                	test   %eax,%eax
80104c01:	79 89                	jns    80104b8c <create+0xdc>
      panic("create dots");
80104c03:	c7 04 24 37 78 10 80 	movl   $0x80107837,(%esp)
80104c0a:	e8 51 b7 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104c0f:	c7 04 24 46 78 10 80 	movl   $0x80107846,(%esp)
80104c16:	e8 45 b7 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104c1b:	c7 04 24 28 78 10 80 	movl   $0x80107828,(%esp)
80104c22:	e8 39 b7 ff ff       	call   80100360 <panic>
80104c27:	89 f6                	mov    %esi,%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	89 c6                	mov    %eax,%esi
80104c36:	53                   	push   %ebx
80104c37:	89 d3                	mov    %edx,%ebx
80104c39:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104c3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c43:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c4a:	e8 e1 fc ff ff       	call   80104930 <argint>
80104c4f:	85 c0                	test   %eax,%eax
80104c51:	78 35                	js     80104c88 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104c53:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104c56:	83 f9 0f             	cmp    $0xf,%ecx
80104c59:	77 2d                	ja     80104c88 <argfd.constprop.0+0x58>
80104c5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c61:	8b 44 88 28          	mov    0x28(%eax,%ecx,4),%eax
80104c65:	85 c0                	test   %eax,%eax
80104c67:	74 1f                	je     80104c88 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104c69:	85 f6                	test   %esi,%esi
80104c6b:	74 02                	je     80104c6f <argfd.constprop.0+0x3f>
    *pfd = fd;
80104c6d:	89 0e                	mov    %ecx,(%esi)
  if(pf)
80104c6f:	85 db                	test   %ebx,%ebx
80104c71:	74 0d                	je     80104c80 <argfd.constprop.0+0x50>
    *pf = f;
80104c73:	89 03                	mov    %eax,(%ebx)
  return 0;
80104c75:	31 c0                	xor    %eax,%eax
}
80104c77:	83 c4 20             	add    $0x20,%esp
80104c7a:	5b                   	pop    %ebx
80104c7b:	5e                   	pop    %esi
80104c7c:	5d                   	pop    %ebp
80104c7d:	c3                   	ret    
80104c7e:	66 90                	xchg   %ax,%ax
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104c80:	31 c0                	xor    %eax,%eax
80104c82:	eb f3                	jmp    80104c77 <argfd.constprop.0+0x47>
80104c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104c88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c8d:	eb e8                	jmp    80104c77 <argfd.constprop.0+0x47>
80104c8f:	90                   	nop

80104c90 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104c90:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104c91:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104c93:	89 e5                	mov    %esp,%ebp
80104c95:	53                   	push   %ebx
80104c96:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104c99:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c9c:	e8 8f ff ff ff       	call   80104c30 <argfd.constprop.0>
80104ca1:	85 c0                	test   %eax,%eax
80104ca3:	78 1b                	js     80104cc0 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104ca5:	8b 55 f4             	mov    -0xc(%ebp),%edx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104ca8:	31 db                	xor    %ebx,%ebx
80104caa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    if(proc->ofile[fd] == 0){
80104cb0:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104cb4:	85 c9                	test   %ecx,%ecx
80104cb6:	74 18                	je     80104cd0 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104cb8:	83 c3 01             	add    $0x1,%ebx
80104cbb:	83 fb 10             	cmp    $0x10,%ebx
80104cbe:	75 f0                	jne    80104cb0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104cc0:	83 c4 24             	add    $0x24,%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104cc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104cc8:	5b                   	pop    %ebx
80104cc9:	5d                   	pop    %ebp
80104cca:	c3                   	ret    
80104ccb:	90                   	nop
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104cd0:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104cd4:	89 14 24             	mov    %edx,(%esp)
80104cd7:	e8 04 c1 ff ff       	call   80100de0 <filedup>
  return fd;
}
80104cdc:	83 c4 24             	add    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104cdf:	89 d8                	mov    %ebx,%eax
}
80104ce1:	5b                   	pop    %ebx
80104ce2:	5d                   	pop    %ebp
80104ce3:	c3                   	ret    
80104ce4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104cf0 <sys_read>:

int
sys_read(void)
{
80104cf0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cf1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104cf3:	89 e5                	mov    %esp,%ebp
80104cf5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cf8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cfb:	e8 30 ff ff ff       	call   80104c30 <argfd.constprop.0>
80104d00:	85 c0                	test   %eax,%eax
80104d02:	78 54                	js     80104d58 <sys_read+0x68>
80104d04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d07:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d0b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104d12:	e8 19 fc ff ff       	call   80104930 <argint>
80104d17:	85 c0                	test   %eax,%eax
80104d19:	78 3d                	js     80104d58 <sys_read+0x68>
80104d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d25:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d29:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d30:	e8 3b fc ff ff       	call   80104970 <argptr>
80104d35:	85 c0                	test   %eax,%eax
80104d37:	78 1f                	js     80104d58 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d3c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d43:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d4a:	89 04 24             	mov    %eax,(%esp)
80104d4d:	e8 ee c1 ff ff       	call   80100f40 <fileread>
}
80104d52:	c9                   	leave  
80104d53:	c3                   	ret    
80104d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104d5d:	c9                   	leave  
80104d5e:	c3                   	ret    
80104d5f:	90                   	nop

80104d60 <sys_write>:

int
sys_write(void)
{
80104d60:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d61:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104d63:	89 e5                	mov    %esp,%ebp
80104d65:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d6b:	e8 c0 fe ff ff       	call   80104c30 <argfd.constprop.0>
80104d70:	85 c0                	test   %eax,%eax
80104d72:	78 54                	js     80104dc8 <sys_write+0x68>
80104d74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d77:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d7b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104d82:	e8 a9 fb ff ff       	call   80104930 <argint>
80104d87:	85 c0                	test   %eax,%eax
80104d89:	78 3d                	js     80104dc8 <sys_write+0x68>
80104d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d95:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104da0:	e8 cb fb ff ff       	call   80104970 <argptr>
80104da5:	85 c0                	test   %eax,%eax
80104da7:	78 1f                	js     80104dc8 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dac:	89 44 24 08          	mov    %eax,0x8(%esp)
80104db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104dba:	89 04 24             	mov    %eax,(%esp)
80104dbd:	e8 1e c2 ff ff       	call   80100fe0 <filewrite>
}
80104dc2:	c9                   	leave  
80104dc3:	c3                   	ret    
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104dc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104dcd:	c9                   	leave  
80104dce:	c3                   	ret    
80104dcf:	90                   	nop

80104dd0 <sys_close>:

int
sys_close(void)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104dd6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104dd9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ddc:	e8 4f fe ff ff       	call   80104c30 <argfd.constprop.0>
80104de1:	85 c0                	test   %eax,%eax
80104de3:	78 23                	js     80104e08 <sys_close+0x38>
    return -1;
  proc->ofile[fd] = 0;
80104de5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104de8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dee:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104df5:	00 
  fileclose(f);
80104df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df9:	89 04 24             	mov    %eax,(%esp)
80104dfc:	e8 2f c0 ff ff       	call   80100e30 <fileclose>
  return 0;
80104e01:	31 c0                	xor    %eax,%eax
}
80104e03:	c9                   	leave  
80104e04:	c3                   	ret    
80104e05:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104e08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104e0d:	c9                   	leave  
80104e0e:	c3                   	ret    
80104e0f:	90                   	nop

80104e10 <sys_fstat>:

int
sys_fstat(void)
{
80104e10:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e11:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104e13:	89 e5                	mov    %esp,%ebp
80104e15:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e18:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e1b:	e8 10 fe ff ff       	call   80104c30 <argfd.constprop.0>
80104e20:	85 c0                	test   %eax,%eax
80104e22:	78 34                	js     80104e58 <sys_fstat+0x48>
80104e24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e27:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104e2e:	00 
80104e2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e3a:	e8 31 fb ff ff       	call   80104970 <argptr>
80104e3f:	85 c0                	test   %eax,%eax
80104e41:	78 15                	js     80104e58 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e46:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e4d:	89 04 24             	mov    %eax,(%esp)
80104e50:	e8 9b c0 ff ff       	call   80100ef0 <filestat>
}
80104e55:	c9                   	leave  
80104e56:	c3                   	ret    
80104e57:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104e5d:	c9                   	leave  
80104e5e:	c3                   	ret    
80104e5f:	90                   	nop

80104e60 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	57                   	push   %edi
80104e64:	56                   	push   %esi
80104e65:	53                   	push   %ebx
80104e66:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e69:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e77:	e8 44 fb ff ff       	call   801049c0 <argstr>
80104e7c:	85 c0                	test   %eax,%eax
80104e7e:	0f 88 e6 00 00 00    	js     80104f6a <sys_link+0x10a>
80104e84:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e92:	e8 29 fb ff ff       	call   801049c0 <argstr>
80104e97:	85 c0                	test   %eax,%eax
80104e99:	0f 88 cb 00 00 00    	js     80104f6a <sys_link+0x10a>
    return -1;

  begin_op();
80104e9f:	e8 ec dc ff ff       	call   80102b90 <begin_op>
  if((ip = namei(old)) == 0){
80104ea4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104ea7:	89 04 24             	mov    %eax,(%esp)
80104eaa:	e8 41 d0 ff ff       	call   80101ef0 <namei>
80104eaf:	85 c0                	test   %eax,%eax
80104eb1:	89 c3                	mov    %eax,%ebx
80104eb3:	0f 84 ac 00 00 00    	je     80104f65 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104eb9:	89 04 24             	mov    %eax,(%esp)
80104ebc:	e8 ff c7 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
80104ec1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ec6:	0f 84 91 00 00 00    	je     80104f5d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104ecc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104ed1:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104ed4:	89 1c 24             	mov    %ebx,(%esp)
80104ed7:	e8 24 c7 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
80104edc:	89 1c 24             	mov    %ebx,(%esp)
80104edf:	e8 ac c8 ff ff       	call   80101790 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104ee4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104ee7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104eeb:	89 04 24             	mov    %eax,(%esp)
80104eee:	e8 1d d0 ff ff       	call   80101f10 <nameiparent>
80104ef3:	85 c0                	test   %eax,%eax
80104ef5:	89 c6                	mov    %eax,%esi
80104ef7:	74 4f                	je     80104f48 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104ef9:	89 04 24             	mov    %eax,(%esp)
80104efc:	e8 bf c7 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f01:	8b 03                	mov    (%ebx),%eax
80104f03:	39 06                	cmp    %eax,(%esi)
80104f05:	75 39                	jne    80104f40 <sys_link+0xe0>
80104f07:	8b 43 04             	mov    0x4(%ebx),%eax
80104f0a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104f0e:	89 34 24             	mov    %esi,(%esp)
80104f11:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f15:	e8 f6 ce ff ff       	call   80101e10 <dirlink>
80104f1a:	85 c0                	test   %eax,%eax
80104f1c:	78 22                	js     80104f40 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104f1e:	89 34 24             	mov    %esi,(%esp)
80104f21:	e8 da c9 ff ff       	call   80101900 <iunlockput>
  iput(ip);
80104f26:	89 1c 24             	mov    %ebx,(%esp)
80104f29:	e8 a2 c8 ff ff       	call   801017d0 <iput>

  end_op();
80104f2e:	e8 cd dc ff ff       	call   80102c00 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104f33:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104f36:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104f38:	5b                   	pop    %ebx
80104f39:	5e                   	pop    %esi
80104f3a:	5f                   	pop    %edi
80104f3b:	5d                   	pop    %ebp
80104f3c:	c3                   	ret    
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104f40:	89 34 24             	mov    %esi,(%esp)
80104f43:	e8 b8 c9 ff ff       	call   80101900 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104f48:	89 1c 24             	mov    %ebx,(%esp)
80104f4b:	e8 70 c7 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
80104f50:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f55:	89 1c 24             	mov    %ebx,(%esp)
80104f58:	e8 a3 c6 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104f5d:	89 1c 24             	mov    %ebx,(%esp)
80104f60:	e8 9b c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104f65:	e8 96 dc ff ff       	call   80102c00 <end_op>
  return -1;
}
80104f6a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104f6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f72:	5b                   	pop    %ebx
80104f73:	5e                   	pop    %esi
80104f74:	5f                   	pop    %edi
80104f75:	5d                   	pop    %ebp
80104f76:	c3                   	ret    
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f80 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	57                   	push   %edi
80104f84:	56                   	push   %esi
80104f85:	53                   	push   %ebx
80104f86:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104f89:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104f8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f97:	e8 24 fa ff ff       	call   801049c0 <argstr>
80104f9c:	85 c0                	test   %eax,%eax
80104f9e:	0f 88 76 01 00 00    	js     8010511a <sys_unlink+0x19a>
    return -1;

  begin_op();
80104fa4:	e8 e7 db ff ff       	call   80102b90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104fa9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104fac:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104faf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104fb3:	89 04 24             	mov    %eax,(%esp)
80104fb6:	e8 55 cf ff ff       	call   80101f10 <nameiparent>
80104fbb:	85 c0                	test   %eax,%eax
80104fbd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104fc0:	0f 84 4f 01 00 00    	je     80105115 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104fc6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104fc9:	89 34 24             	mov    %esi,(%esp)
80104fcc:	e8 ef c6 ff ff       	call   801016c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104fd1:	c7 44 24 04 44 78 10 	movl   $0x80107844,0x4(%esp)
80104fd8:	80 
80104fd9:	89 1c 24             	mov    %ebx,(%esp)
80104fdc:	e8 9f cb ff ff       	call   80101b80 <namecmp>
80104fe1:	85 c0                	test   %eax,%eax
80104fe3:	0f 84 21 01 00 00    	je     8010510a <sys_unlink+0x18a>
80104fe9:	c7 44 24 04 43 78 10 	movl   $0x80107843,0x4(%esp)
80104ff0:	80 
80104ff1:	89 1c 24             	mov    %ebx,(%esp)
80104ff4:	e8 87 cb ff ff       	call   80101b80 <namecmp>
80104ff9:	85 c0                	test   %eax,%eax
80104ffb:	0f 84 09 01 00 00    	je     8010510a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105001:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105004:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105008:	89 44 24 08          	mov    %eax,0x8(%esp)
8010500c:	89 34 24             	mov    %esi,(%esp)
8010500f:	e8 9c cb ff ff       	call   80101bb0 <dirlookup>
80105014:	85 c0                	test   %eax,%eax
80105016:	89 c3                	mov    %eax,%ebx
80105018:	0f 84 ec 00 00 00    	je     8010510a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
8010501e:	89 04 24             	mov    %eax,(%esp)
80105021:	e8 9a c6 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
80105026:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010502b:	0f 8e 24 01 00 00    	jle    80105155 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105031:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105036:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105039:	74 7d                	je     801050b8 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010503b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105042:	00 
80105043:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010504a:	00 
8010504b:	89 34 24             	mov    %esi,(%esp)
8010504e:	e8 0d f6 ff ff       	call   80104660 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105053:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105056:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010505d:	00 
8010505e:	89 74 24 04          	mov    %esi,0x4(%esp)
80105062:	89 44 24 08          	mov    %eax,0x8(%esp)
80105066:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105069:	89 04 24             	mov    %eax,(%esp)
8010506c:	e8 df c9 ff ff       	call   80101a50 <writei>
80105071:	83 f8 10             	cmp    $0x10,%eax
80105074:	0f 85 cf 00 00 00    	jne    80105149 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010507a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010507f:	0f 84 a3 00 00 00    	je     80105128 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105085:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105088:	89 04 24             	mov    %eax,(%esp)
8010508b:	e8 70 c8 ff ff       	call   80101900 <iunlockput>

  ip->nlink--;
80105090:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105095:	89 1c 24             	mov    %ebx,(%esp)
80105098:	e8 63 c5 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
8010509d:	89 1c 24             	mov    %ebx,(%esp)
801050a0:	e8 5b c8 ff ff       	call   80101900 <iunlockput>

  end_op();
801050a5:	e8 56 db ff ff       	call   80102c00 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801050aa:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
801050ad:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801050af:	5b                   	pop    %ebx
801050b0:	5e                   	pop    %esi
801050b1:	5f                   	pop    %edi
801050b2:	5d                   	pop    %ebp
801050b3:	c3                   	ret    
801050b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801050b8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801050bc:	0f 86 79 ff ff ff    	jbe    8010503b <sys_unlink+0xbb>
801050c2:	bf 20 00 00 00       	mov    $0x20,%edi
801050c7:	eb 15                	jmp    801050de <sys_unlink+0x15e>
801050c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050d0:	8d 57 10             	lea    0x10(%edi),%edx
801050d3:	3b 53 58             	cmp    0x58(%ebx),%edx
801050d6:	0f 83 5f ff ff ff    	jae    8010503b <sys_unlink+0xbb>
801050dc:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050de:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801050e5:	00 
801050e6:	89 7c 24 08          	mov    %edi,0x8(%esp)
801050ea:	89 74 24 04          	mov    %esi,0x4(%esp)
801050ee:	89 1c 24             	mov    %ebx,(%esp)
801050f1:	e8 5a c8 ff ff       	call   80101950 <readi>
801050f6:	83 f8 10             	cmp    $0x10,%eax
801050f9:	75 42                	jne    8010513d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
801050fb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105100:	74 ce                	je     801050d0 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105102:	89 1c 24             	mov    %ebx,(%esp)
80105105:	e8 f6 c7 ff ff       	call   80101900 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
8010510a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010510d:	89 04 24             	mov    %eax,(%esp)
80105110:	e8 eb c7 ff ff       	call   80101900 <iunlockput>
  end_op();
80105115:	e8 e6 da ff ff       	call   80102c00 <end_op>
  return -1;
}
8010511a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
8010511d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105122:	5b                   	pop    %ebx
80105123:	5e                   	pop    %esi
80105124:	5f                   	pop    %edi
80105125:	5d                   	pop    %ebp
80105126:	c3                   	ret    
80105127:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105128:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010512b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105130:	89 04 24             	mov    %eax,(%esp)
80105133:	e8 c8 c4 ff ff       	call   80101600 <iupdate>
80105138:	e9 48 ff ff ff       	jmp    80105085 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010513d:	c7 04 24 68 78 10 80 	movl   $0x80107868,(%esp)
80105144:	e8 17 b2 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105149:	c7 04 24 7a 78 10 80 	movl   $0x8010787a,(%esp)
80105150:	e8 0b b2 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105155:	c7 04 24 56 78 10 80 	movl   $0x80107856,(%esp)
8010515c:	e8 ff b1 ff ff       	call   80100360 <panic>
80105161:	eb 0d                	jmp    80105170 <sys_open>
80105163:	90                   	nop
80105164:	90                   	nop
80105165:	90                   	nop
80105166:	90                   	nop
80105167:	90                   	nop
80105168:	90                   	nop
80105169:	90                   	nop
8010516a:	90                   	nop
8010516b:	90                   	nop
8010516c:	90                   	nop
8010516d:	90                   	nop
8010516e:	90                   	nop
8010516f:	90                   	nop

80105170 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
80105175:	53                   	push   %ebx
80105176:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105179:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010517c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105180:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105187:	e8 34 f8 ff ff       	call   801049c0 <argstr>
8010518c:	85 c0                	test   %eax,%eax
8010518e:	0f 88 81 00 00 00    	js     80105215 <sys_open+0xa5>
80105194:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105197:	89 44 24 04          	mov    %eax,0x4(%esp)
8010519b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051a2:	e8 89 f7 ff ff       	call   80104930 <argint>
801051a7:	85 c0                	test   %eax,%eax
801051a9:	78 6a                	js     80105215 <sys_open+0xa5>
    return -1;

  begin_op();
801051ab:	e8 e0 d9 ff ff       	call   80102b90 <begin_op>

  if(omode & O_CREATE){
801051b0:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801051b4:	75 72                	jne    80105228 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801051b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051b9:	89 04 24             	mov    %eax,(%esp)
801051bc:	e8 2f cd ff ff       	call   80101ef0 <namei>
801051c1:	85 c0                	test   %eax,%eax
801051c3:	89 c7                	mov    %eax,%edi
801051c5:	74 49                	je     80105210 <sys_open+0xa0>
      end_op();
      return -1;
    }
    ilock(ip);
801051c7:	89 04 24             	mov    %eax,(%esp)
801051ca:	e8 f1 c4 ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801051cf:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
801051d4:	0f 84 ae 00 00 00    	je     80105288 <sys_open+0x118>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051da:	e8 91 bb ff ff       	call   80100d70 <filealloc>
801051df:	85 c0                	test   %eax,%eax
801051e1:	89 c6                	mov    %eax,%esi
801051e3:	74 23                	je     80105208 <sys_open+0x98>
801051e5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051ec:	31 db                	xor    %ebx,%ebx
801051ee:	66 90                	xchg   %ax,%ax
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801051f0:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
801051f4:	85 c0                	test   %eax,%eax
801051f6:	74 50                	je     80105248 <sys_open+0xd8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801051f8:	83 c3 01             	add    $0x1,%ebx
801051fb:	83 fb 10             	cmp    $0x10,%ebx
801051fe:	75 f0                	jne    801051f0 <sys_open+0x80>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105200:	89 34 24             	mov    %esi,(%esp)
80105203:	e8 28 bc ff ff       	call   80100e30 <fileclose>
    iunlockput(ip);
80105208:	89 3c 24             	mov    %edi,(%esp)
8010520b:	e8 f0 c6 ff ff       	call   80101900 <iunlockput>
    end_op();
80105210:	e8 eb d9 ff ff       	call   80102c00 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105215:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010521d:	5b                   	pop    %ebx
8010521e:	5e                   	pop    %esi
8010521f:	5f                   	pop    %edi
80105220:	5d                   	pop    %ebp
80105221:	c3                   	ret    
80105222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105228:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010522b:	31 c9                	xor    %ecx,%ecx
8010522d:	ba 02 00 00 00       	mov    $0x2,%edx
80105232:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105239:	e8 72 f8 ff ff       	call   80104ab0 <create>
    if(ip == 0){
8010523e:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105240:	89 c7                	mov    %eax,%edi
    if(ip == 0){
80105242:	75 96                	jne    801051da <sys_open+0x6a>
80105244:	eb ca                	jmp    80105210 <sys_open+0xa0>
80105246:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105248:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010524c:	89 3c 24             	mov    %edi,(%esp)
8010524f:	e8 3c c5 ff ff       	call   80101790 <iunlock>
  end_op();
80105254:	e8 a7 d9 ff ff       	call   80102c00 <end_op>

  f->type = FD_INODE;
80105259:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010525f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105262:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80105265:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
8010526c:	89 d0                	mov    %edx,%eax
8010526e:	83 e0 01             	and    $0x1,%eax
80105271:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105274:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105277:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
8010527a:	89 d8                	mov    %ebx,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010527c:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
}
80105280:	83 c4 2c             	add    $0x2c,%esp
80105283:	5b                   	pop    %ebx
80105284:	5e                   	pop    %esi
80105285:	5f                   	pop    %edi
80105286:	5d                   	pop    %ebp
80105287:	c3                   	ret    
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105288:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010528b:	85 d2                	test   %edx,%edx
8010528d:	0f 84 47 ff ff ff    	je     801051da <sys_open+0x6a>
80105293:	e9 70 ff ff ff       	jmp    80105208 <sys_open+0x98>
80105298:	90                   	nop
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052a0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052a6:	e8 e5 d8 ff ff       	call   80102b90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801052ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801052b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052b9:	e8 02 f7 ff ff       	call   801049c0 <argstr>
801052be:	85 c0                	test   %eax,%eax
801052c0:	78 2e                	js     801052f0 <sys_mkdir+0x50>
801052c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c5:	31 c9                	xor    %ecx,%ecx
801052c7:	ba 01 00 00 00       	mov    $0x1,%edx
801052cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052d3:	e8 d8 f7 ff ff       	call   80104ab0 <create>
801052d8:	85 c0                	test   %eax,%eax
801052da:	74 14                	je     801052f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052dc:	89 04 24             	mov    %eax,(%esp)
801052df:	e8 1c c6 ff ff       	call   80101900 <iunlockput>
  end_op();
801052e4:	e8 17 d9 ff ff       	call   80102c00 <end_op>
  return 0;
801052e9:	31 c0                	xor    %eax,%eax
}
801052eb:	c9                   	leave  
801052ec:	c3                   	ret    
801052ed:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801052f0:	e8 0b d9 ff ff       	call   80102c00 <end_op>
    return -1;
801052f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801052fa:	c9                   	leave  
801052fb:	c3                   	ret    
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_mknod>:

int
sys_mknod(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105306:	e8 85 d8 ff ff       	call   80102b90 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010530b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010530e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105312:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105319:	e8 a2 f6 ff ff       	call   801049c0 <argstr>
8010531e:	85 c0                	test   %eax,%eax
80105320:	78 5e                	js     80105380 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105322:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105325:	89 44 24 04          	mov    %eax,0x4(%esp)
80105329:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105330:	e8 fb f5 ff ff       	call   80104930 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105335:	85 c0                	test   %eax,%eax
80105337:	78 47                	js     80105380 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105339:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010533c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105340:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105347:	e8 e4 f5 ff ff       	call   80104930 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010534c:	85 c0                	test   %eax,%eax
8010534e:	78 30                	js     80105380 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105350:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105354:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105359:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010535d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105360:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105363:	e8 48 f7 ff ff       	call   80104ab0 <create>
80105368:	85 c0                	test   %eax,%eax
8010536a:	74 14                	je     80105380 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010536c:	89 04 24             	mov    %eax,(%esp)
8010536f:	e8 8c c5 ff ff       	call   80101900 <iunlockput>
  end_op();
80105374:	e8 87 d8 ff ff       	call   80102c00 <end_op>
  return 0;
80105379:	31 c0                	xor    %eax,%eax
}
8010537b:	c9                   	leave  
8010537c:	c3                   	ret    
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105380:	e8 7b d8 ff ff       	call   80102c00 <end_op>
    return -1;
80105385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010538a:	c9                   	leave  
8010538b:	c3                   	ret    
8010538c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105390 <sys_chdir>:

int
sys_chdir(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	53                   	push   %ebx
80105394:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105397:	e8 f4 d7 ff ff       	call   80102b90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010539c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010539f:	89 44 24 04          	mov    %eax,0x4(%esp)
801053a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053aa:	e8 11 f6 ff ff       	call   801049c0 <argstr>
801053af:	85 c0                	test   %eax,%eax
801053b1:	78 5a                	js     8010540d <sys_chdir+0x7d>
801053b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b6:	89 04 24             	mov    %eax,(%esp)
801053b9:	e8 32 cb ff ff       	call   80101ef0 <namei>
801053be:	85 c0                	test   %eax,%eax
801053c0:	89 c3                	mov    %eax,%ebx
801053c2:	74 49                	je     8010540d <sys_chdir+0x7d>
    end_op();
    return -1;
  }
  ilock(ip);
801053c4:	89 04 24             	mov    %eax,(%esp)
801053c7:	e8 f4 c2 ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
801053cc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
801053d1:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
801053d4:	75 32                	jne    80105408 <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801053d6:	e8 b5 c3 ff ff       	call   80101790 <iunlock>
  iput(proc->cwd);
801053db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053e1:	8b 40 68             	mov    0x68(%eax),%eax
801053e4:	89 04 24             	mov    %eax,(%esp)
801053e7:	e8 e4 c3 ff ff       	call   801017d0 <iput>
  end_op();
801053ec:	e8 0f d8 ff ff       	call   80102c00 <end_op>
  proc->cwd = ip;
801053f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053f7:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
}
801053fa:	83 c4 24             	add    $0x24,%esp
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
801053fd:	31 c0                	xor    %eax,%eax
}
801053ff:	5b                   	pop    %ebx
80105400:	5d                   	pop    %ebp
80105401:	c3                   	ret    
80105402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105408:	e8 f3 c4 ff ff       	call   80101900 <iunlockput>
    end_op();
8010540d:	e8 ee d7 ff ff       	call   80102c00 <end_op>
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
80105412:	83 c4 24             	add    $0x24,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
80105415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
8010541a:	5b                   	pop    %ebx
8010541b:	5d                   	pop    %ebp
8010541c:	c3                   	ret    
8010541d:	8d 76 00             	lea    0x0(%esi),%esi

80105420 <sys_exec>:

int
sys_exec(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	57                   	push   %edi
80105424:	56                   	push   %esi
80105425:	53                   	push   %ebx
80105426:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010542c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105432:	89 44 24 04          	mov    %eax,0x4(%esp)
80105436:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010543d:	e8 7e f5 ff ff       	call   801049c0 <argstr>
80105442:	85 c0                	test   %eax,%eax
80105444:	0f 88 84 00 00 00    	js     801054ce <sys_exec+0xae>
8010544a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105450:	89 44 24 04          	mov    %eax,0x4(%esp)
80105454:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010545b:	e8 d0 f4 ff ff       	call   80104930 <argint>
80105460:	85 c0                	test   %eax,%eax
80105462:	78 6a                	js     801054ce <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105464:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010546a:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010546c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105473:	00 
80105474:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010547a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105481:	00 
80105482:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105488:	89 04 24             	mov    %eax,(%esp)
8010548b:	e8 d0 f1 ff ff       	call   80104660 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105490:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105496:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010549a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010549d:	89 04 24             	mov    %eax,(%esp)
801054a0:	e8 0b f4 ff ff       	call   801048b0 <fetchint>
801054a5:	85 c0                	test   %eax,%eax
801054a7:	78 25                	js     801054ce <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801054a9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801054af:	85 c0                	test   %eax,%eax
801054b1:	74 2d                	je     801054e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801054b3:	89 74 24 04          	mov    %esi,0x4(%esp)
801054b7:	89 04 24             	mov    %eax,(%esp)
801054ba:	e8 21 f4 ff ff       	call   801048e0 <fetchstr>
801054bf:	85 c0                	test   %eax,%eax
801054c1:	78 0b                	js     801054ce <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801054c3:	83 c3 01             	add    $0x1,%ebx
801054c6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801054c9:	83 fb 20             	cmp    $0x20,%ebx
801054cc:	75 c2                	jne    80105490 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801054ce:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801054d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801054d9:	5b                   	pop    %ebx
801054da:	5e                   	pop    %esi
801054db:	5f                   	pop    %edi
801054dc:	5d                   	pop    %ebp
801054dd:	c3                   	ret    
801054de:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801054e0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801054e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801054ea:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801054f0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801054f7:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801054fb:	89 04 24             	mov    %eax,(%esp)
801054fe:	e8 ad b4 ff ff       	call   801009b0 <exec>
}
80105503:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105509:	5b                   	pop    %ebx
8010550a:	5e                   	pop    %esi
8010550b:	5f                   	pop    %edi
8010550c:	5d                   	pop    %ebp
8010550d:	c3                   	ret    
8010550e:	66 90                	xchg   %ax,%ax

80105510 <sys_pipe>:

int
sys_pipe(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
80105515:	53                   	push   %ebx
80105516:	83 ec 2c             	sub    $0x2c,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105519:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010551c:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105523:	00 
80105524:	89 44 24 04          	mov    %eax,0x4(%esp)
80105528:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010552f:	e8 3c f4 ff ff       	call   80104970 <argptr>
80105534:	85 c0                	test   %eax,%eax
80105536:	78 7a                	js     801055b2 <sys_pipe+0xa2>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105538:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010553b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010553f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105542:	89 04 24             	mov    %eax,(%esp)
80105545:	e8 76 dd ff ff       	call   801032c0 <pipealloc>
8010554a:	85 c0                	test   %eax,%eax
8010554c:	78 64                	js     801055b2 <sys_pipe+0xa2>
8010554e:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105555:	31 c0                	xor    %eax,%eax
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105557:	8b 5d e0             	mov    -0x20(%ebp),%ebx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
8010555a:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
8010555e:	85 d2                	test   %edx,%edx
80105560:	74 16                	je     80105578 <sys_pipe+0x68>
80105562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105568:	83 c0 01             	add    $0x1,%eax
8010556b:	83 f8 10             	cmp    $0x10,%eax
8010556e:	74 2f                	je     8010559f <sys_pipe+0x8f>
    if(proc->ofile[fd] == 0){
80105570:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105574:	85 d2                	test   %edx,%edx
80105576:	75 f0                	jne    80105568 <sys_pipe+0x58>
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105578:	8b 7d e4             	mov    -0x1c(%ebp),%edi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
8010557b:	8d 70 08             	lea    0x8(%eax),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010557e:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105580:	89 5c b1 08          	mov    %ebx,0x8(%ecx,%esi,4)
80105584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105588:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
8010558d:	74 31                	je     801055c0 <sys_pipe+0xb0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010558f:	83 c2 01             	add    $0x1,%edx
80105592:	83 fa 10             	cmp    $0x10,%edx
80105595:	75 f1                	jne    80105588 <sys_pipe+0x78>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
80105597:	c7 44 b1 08 00 00 00 	movl   $0x0,0x8(%ecx,%esi,4)
8010559e:	00 
    fileclose(rf);
8010559f:	89 1c 24             	mov    %ebx,(%esp)
801055a2:	e8 89 b8 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
801055a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801055aa:	89 04 24             	mov    %eax,(%esp)
801055ad:	e8 7e b8 ff ff       	call   80100e30 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801055b2:	83 c4 2c             	add    $0x2c,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801055b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801055ba:	5b                   	pop    %ebx
801055bb:	5e                   	pop    %esi
801055bc:	5f                   	pop    %edi
801055bd:	5d                   	pop    %ebp
801055be:	c3                   	ret    
801055bf:	90                   	nop
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801055c0:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801055c4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801055c7:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
801055c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801055cf:	83 c4 2c             	add    $0x2c,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801055d2:	31 c0                	xor    %eax,%eax
}
801055d4:	5b                   	pop    %ebx
801055d5:	5e                   	pop    %esi
801055d6:	5f                   	pop    %edi
801055d7:	5d                   	pop    %ebp
801055d8:	c3                   	ret    
801055d9:	66 90                	xchg   %ax,%ax
801055db:	66 90                	xchg   %ax,%ax
801055dd:	66 90                	xchg   %ax,%ax
801055df:	90                   	nop

801055e0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801055e3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801055e4:	e9 37 e3 ff ff       	jmp    80103920 <fork>
801055e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055f0 <sys_exit>:
}

int
sys_exit(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801055f6:	e8 c5 e6 ff ff       	call   80103cc0 <exit>
  return 0;  // not reached
}
801055fb:	31 c0                	xor    %eax,%eax
801055fd:	c9                   	leave  
801055fe:	c3                   	ret    
801055ff:	90                   	nop

80105600 <sys_wait>:

int
sys_wait(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105603:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105604:	e9 f7 e8 ff ff       	jmp    80103f00 <wait>
80105609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_kill>:
}

int
sys_kill(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105616:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105619:	89 44 24 04          	mov    %eax,0x4(%esp)
8010561d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105624:	e8 07 f3 ff ff       	call   80104930 <argint>
80105629:	85 c0                	test   %eax,%eax
8010562b:	78 13                	js     80105640 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010562d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105630:	89 04 24             	mov    %eax,(%esp)
80105633:	e8 28 ea ff ff       	call   80104060 <kill>
}
80105638:	c9                   	leave  
80105639:	c3                   	ret    
8010563a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105645:	c9                   	leave  
80105646:	c3                   	ret    
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105650 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105650:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80105656:	55                   	push   %ebp
80105657:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
80105659:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
8010565a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010565d:	c3                   	ret    
8010565e:	66 90                	xchg   %ax,%ax

80105660 <sys_sbrk>:

int
sys_sbrk(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	53                   	push   %ebx
80105664:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105667:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010566e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105675:	e8 b6 f2 ff ff       	call   80104930 <argint>
8010567a:	85 c0                	test   %eax,%eax
8010567c:	78 22                	js     801056a0 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
8010567e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
80105684:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
80105687:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105689:	89 14 24             	mov    %edx,(%esp)
8010568c:	e8 0f e2 ff ff       	call   801038a0 <growproc>
80105691:	85 c0                	test   %eax,%eax
80105693:	78 0b                	js     801056a0 <sys_sbrk+0x40>
    return -1;
  return addr;
80105695:	89 d8                	mov    %ebx,%eax
}
80105697:	83 c4 24             	add    $0x24,%esp
8010569a:	5b                   	pop    %ebx
8010569b:	5d                   	pop    %ebp
8010569c:	c3                   	ret    
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801056a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a5:	eb f0                	jmp    80105697 <sys_sbrk+0x37>
801056a7:	89 f6                	mov    %esi,%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056b0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	53                   	push   %ebx
801056b4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801056b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801056be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056c5:	e8 66 f2 ff ff       	call   80104930 <argint>
801056ca:	85 c0                	test   %eax,%eax
801056cc:	78 7e                	js     8010574c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801056ce:	c7 04 24 e0 4e 11 80 	movl   $0x80114ee0,(%esp)
801056d5:	e8 06 ee ff ff       	call   801044e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801056da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801056dd:	8b 1d 20 57 11 80    	mov    0x80115720,%ebx
  while(ticks - ticks0 < n){
801056e3:	85 d2                	test   %edx,%edx
801056e5:	75 29                	jne    80105710 <sys_sleep+0x60>
801056e7:	eb 4f                	jmp    80105738 <sys_sleep+0x88>
801056e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801056f0:	c7 44 24 04 e0 4e 11 	movl   $0x80114ee0,0x4(%esp)
801056f7:	80 
801056f8:	c7 04 24 20 57 11 80 	movl   $0x80115720,(%esp)
801056ff:	e8 3c e7 ff ff       	call   80103e40 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105704:	a1 20 57 11 80       	mov    0x80115720,%eax
80105709:	29 d8                	sub    %ebx,%eax
8010570b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010570e:	73 28                	jae    80105738 <sys_sleep+0x88>
    if(proc->killed){
80105710:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105716:	8b 40 24             	mov    0x24(%eax),%eax
80105719:	85 c0                	test   %eax,%eax
8010571b:	74 d3                	je     801056f0 <sys_sleep+0x40>
      release(&tickslock);
8010571d:	c7 04 24 e0 4e 11 80 	movl   $0x80114ee0,(%esp)
80105724:	e8 e7 ee ff ff       	call   80104610 <release>
      return -1;
80105729:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010572e:	83 c4 24             	add    $0x24,%esp
80105731:	5b                   	pop    %ebx
80105732:	5d                   	pop    %ebp
80105733:	c3                   	ret    
80105734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105738:	c7 04 24 e0 4e 11 80 	movl   $0x80114ee0,(%esp)
8010573f:	e8 cc ee ff ff       	call   80104610 <release>
  return 0;
}
80105744:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105747:	31 c0                	xor    %eax,%eax
}
80105749:	5b                   	pop    %ebx
8010574a:	5d                   	pop    %ebp
8010574b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
8010574c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105751:	eb db                	jmp    8010572e <sys_sleep+0x7e>
80105753:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105760 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	53                   	push   %ebx
80105764:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105767:	c7 04 24 e0 4e 11 80 	movl   $0x80114ee0,(%esp)
8010576e:	e8 6d ed ff ff       	call   801044e0 <acquire>
  xticks = ticks;
80105773:	8b 1d 20 57 11 80    	mov    0x80115720,%ebx
  release(&tickslock);
80105779:	c7 04 24 e0 4e 11 80 	movl   $0x80114ee0,(%esp)
80105780:	e8 8b ee ff ff       	call   80104610 <release>
  return xticks;
}
80105785:	83 c4 14             	add    $0x14,%esp
80105788:	89 d8                	mov    %ebx,%eax
8010578a:	5b                   	pop    %ebx
8010578b:	5d                   	pop    %ebp
8010578c:	c3                   	ret    
8010578d:	8d 76 00             	lea    0x0(%esi),%esi

80105790 <sys_cps>:

int
sys_cps(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
  return cps();
}
80105793:	5d                   	pop    %ebp
}

int
sys_cps(void)
{
  return cps();
80105794:	e9 27 ea ff ff       	jmp    801041c0 <cps>
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_chpr>:
}

int
sys_chpr(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	83 ec 28             	sub    $0x28,%esp
  int pid, pr;
  if(argint(0, &pid) < 0)
801057a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057b4:	e8 77 f1 ff ff       	call   80104930 <argint>
801057b9:	85 c0                	test   %eax,%eax
801057bb:	78 2b                	js     801057e8 <sys_chpr+0x48>
    return -1;
  if(argint(1, &pr) < 0)
801057bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801057c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057cb:	e8 60 f1 ff ff       	call   80104930 <argint>
801057d0:	85 c0                	test   %eax,%eax
801057d2:	78 14                	js     801057e8 <sys_chpr+0x48>
    return -1;

  return chpr(pid, pr);
801057d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801057db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057de:	89 04 24             	mov    %eax,(%esp)
801057e1:	e8 ba ea ff ff       	call   801042a0 <chpr>
}
801057e6:	c9                   	leave  
801057e7:	c3                   	ret    
int
sys_chpr(void)
{
  int pid, pr;
  if(argint(0, &pid) < 0)
    return -1;
801057e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(argint(1, &pr) < 0)
    return -1;

  return chpr(pid, pr);
}
801057ed:	c9                   	leave  
801057ee:	c3                   	ret    
801057ef:	90                   	nop

801057f0 <sys_settickets>:
#define MAX_TICKETS 100


// In sysproc.c
int
sys_settickets(void) {
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 28             	sub    $0x28,%esp
    int ticket_number;

    if (argint(0, &ticket_number) < 0) {
801057f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801057fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105804:	e8 27 f1 ff ff       	call   80104930 <argint>
80105809:	85 c0                	test   %eax,%eax
8010580b:	78 1b                	js     80105828 <sys_settickets+0x38>
        return -1; // Return an error code for an invalid argument
    }

    if (ticket_number < 0 || ticket_number > MAX_TICKETS) {
8010580d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105810:	83 f8 64             	cmp    $0x64,%eax
80105813:	77 13                	ja     80105828 <sys_settickets+0x38>
        return -1; // Return an error code for out-of-bounds tickets
    }

    proc->tickets = ticket_number;
80105815:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010581c:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
    return 0;
80105822:	31 c0                	xor    %eax,%eax
}
80105824:	c9                   	leave  
80105825:	c3                   	ret    
80105826:	66 90                	xchg   %ax,%ax
int
sys_settickets(void) {
    int ticket_number;

    if (argint(0, &ticket_number) < 0) {
        return -1; // Return an error code for an invalid argument
80105828:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        return -1; // Return an error code for out-of-bounds tickets
    }

    proc->tickets = ticket_number;
    return 0;
}
8010582d:	c9                   	leave  
8010582e:	c3                   	ret    
8010582f:	90                   	nop

80105830 <sys_chr>:

int
sys_chr(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
  return chr();
}
80105833:	5d                   	pop    %ebp
}

int
sys_chr(void)
{
  return chr();
80105834:	e9 e7 ea ff ff       	jmp    80104320 <chr>
80105839:	66 90                	xchg   %ax,%ax
8010583b:	66 90                	xchg   %ax,%ax
8010583d:	66 90                	xchg   %ax,%ax
8010583f:	90                   	nop

80105840 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105840:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105841:	ba 43 00 00 00       	mov    $0x43,%edx
80105846:	89 e5                	mov    %esp,%ebp
80105848:	b8 34 00 00 00       	mov    $0x34,%eax
8010584d:	83 ec 18             	sub    $0x18,%esp
80105850:	ee                   	out    %al,(%dx)
80105851:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
80105856:	b2 40                	mov    $0x40,%dl
80105858:	ee                   	out    %al,(%dx)
80105859:	b8 2e 00 00 00       	mov    $0x2e,%eax
8010585e:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
8010585f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105866:	e8 95 d9 ff ff       	call   80103200 <picenable>
}
8010586b:	c9                   	leave  
8010586c:	c3                   	ret    

8010586d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010586d:	1e                   	push   %ds
  pushl %es
8010586e:	06                   	push   %es
  pushl %fs
8010586f:	0f a0                	push   %fs
  pushl %gs
80105871:	0f a8                	push   %gs
  pushal
80105873:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105874:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105878:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010587a:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010587c:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105880:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105882:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105884:	54                   	push   %esp
  call trap
80105885:	e8 e6 00 00 00       	call   80105970 <trap>
  addl $4, %esp
8010588a:	83 c4 04             	add    $0x4,%esp

8010588d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010588d:	61                   	popa   
  popl %gs
8010588e:	0f a9                	pop    %gs
  popl %fs
80105890:	0f a1                	pop    %fs
  popl %es
80105892:	07                   	pop    %es
  popl %ds
80105893:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105894:	83 c4 08             	add    $0x8,%esp
  iret
80105897:	cf                   	iret   
80105898:	66 90                	xchg   %ax,%ax
8010589a:	66 90                	xchg   %ax,%ax
8010589c:	66 90                	xchg   %ax,%ax
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801058a0:	31 c0                	xor    %eax,%eax
801058a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801058a8:	8b 14 85 10 a0 10 80 	mov    -0x7fef5ff0(,%eax,4),%edx
801058af:	b9 08 00 00 00       	mov    $0x8,%ecx
801058b4:	66 89 0c c5 22 4f 11 	mov    %cx,-0x7feeb0de(,%eax,8)
801058bb:	80 
801058bc:	c6 04 c5 24 4f 11 80 	movb   $0x0,-0x7feeb0dc(,%eax,8)
801058c3:	00 
801058c4:	c6 04 c5 25 4f 11 80 	movb   $0x8e,-0x7feeb0db(,%eax,8)
801058cb:	8e 
801058cc:	66 89 14 c5 20 4f 11 	mov    %dx,-0x7feeb0e0(,%eax,8)
801058d3:	80 
801058d4:	c1 ea 10             	shr    $0x10,%edx
801058d7:	66 89 14 c5 26 4f 11 	mov    %dx,-0x7feeb0da(,%eax,8)
801058de:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801058df:	83 c0 01             	add    $0x1,%eax
801058e2:	3d 00 01 00 00       	cmp    $0x100,%eax
801058e7:	75 bf                	jne    801058a8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058e9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058ea:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058ef:	89 e5                	mov    %esp,%ebp
801058f1:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058f4:	a1 10 a1 10 80       	mov    0x8010a110,%eax

  initlock(&tickslock, "time");
801058f9:	c7 44 24 04 89 78 10 	movl   $0x80107889,0x4(%esp)
80105900:	80 
80105901:	c7 04 24 e0 4e 11 80 	movl   $0x80114ee0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105908:	66 89 15 22 51 11 80 	mov    %dx,0x80115122
8010590f:	66 a3 20 51 11 80    	mov    %ax,0x80115120
80105915:	c1 e8 10             	shr    $0x10,%eax
80105918:	c6 05 24 51 11 80 00 	movb   $0x0,0x80115124
8010591f:	c6 05 25 51 11 80 ef 	movb   $0xef,0x80115125
80105926:	66 a3 26 51 11 80    	mov    %ax,0x80115126

  initlock(&tickslock, "time");
8010592c:	e8 2f eb ff ff       	call   80104460 <initlock>
}
80105931:	c9                   	leave  
80105932:	c3                   	ret    
80105933:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105940 <idtinit>:

void
idtinit(void)
{
80105940:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105941:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105946:	89 e5                	mov    %esp,%ebp
80105948:	83 ec 10             	sub    $0x10,%esp
8010594b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010594f:	b8 20 4f 11 80       	mov    $0x80114f20,%eax
80105954:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105958:	c1 e8 10             	shr    $0x10,%eax
8010595b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010595f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105962:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105970 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	57                   	push   %edi
80105974:	56                   	push   %esi
80105975:	53                   	push   %ebx
80105976:	83 ec 2c             	sub    $0x2c,%esp
80105979:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010597c:	8b 43 30             	mov    0x30(%ebx),%eax
8010597f:	83 f8 40             	cmp    $0x40,%eax
80105982:	0f 84 00 01 00 00    	je     80105a88 <trap+0x118>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105988:	83 e8 20             	sub    $0x20,%eax
8010598b:	83 f8 1f             	cmp    $0x1f,%eax
8010598e:	77 60                	ja     801059f0 <trap+0x80>
80105990:	ff 24 85 30 79 10 80 	jmp    *-0x7fef86d0(,%eax,4)
80105997:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105998:	e8 c3 cd ff ff       	call   80102760 <cpunum>
8010599d:	85 c0                	test   %eax,%eax
8010599f:	90                   	nop
801059a0:	0f 84 d2 01 00 00    	je     80105b78 <trap+0x208>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
801059a6:	e8 55 ce ff ff       	call   80102800 <lapiceoi>
801059ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801059b1:	85 c0                	test   %eax,%eax
801059b3:	74 2d                	je     801059e2 <trap+0x72>
801059b5:	8b 50 24             	mov    0x24(%eax),%edx
801059b8:	85 d2                	test   %edx,%edx
801059ba:	0f 85 9c 00 00 00    	jne    80105a5c <trap+0xec>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801059c0:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801059c4:	0f 84 86 01 00 00    	je     80105b50 <trap+0x1e0>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801059ca:	8b 40 24             	mov    0x24(%eax),%eax
801059cd:	85 c0                	test   %eax,%eax
801059cf:	74 11                	je     801059e2 <trap+0x72>
801059d1:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059d5:	83 e0 03             	and    $0x3,%eax
801059d8:	66 83 f8 03          	cmp    $0x3,%ax
801059dc:	0f 84 d0 00 00 00    	je     80105ab2 <trap+0x142>
    exit();
}
801059e2:	83 c4 2c             	add    $0x2c,%esp
801059e5:	5b                   	pop    %ebx
801059e6:	5e                   	pop    %esi
801059e7:	5f                   	pop    %edi
801059e8:	5d                   	pop    %ebp
801059e9:	c3                   	ret    
801059ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801059f0:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
801059f7:	85 c9                	test   %ecx,%ecx
801059f9:	0f 84 a9 01 00 00    	je     80105ba8 <trap+0x238>
801059ff:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a03:	0f 84 9f 01 00 00    	je     80105ba8 <trap+0x238>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a09:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a0c:	8b 73 38             	mov    0x38(%ebx),%esi
80105a0f:	e8 4c cd ff ff       	call   80102760 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105a14:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a1b:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
80105a1f:	89 74 24 18          	mov    %esi,0x18(%esp)
80105a23:	89 44 24 14          	mov    %eax,0x14(%esp)
80105a27:	8b 43 34             	mov    0x34(%ebx),%eax
80105a2a:	89 44 24 10          	mov    %eax,0x10(%esp)
80105a2e:	8b 43 30             	mov    0x30(%ebx),%eax
80105a31:	89 44 24 0c          	mov    %eax,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105a35:	8d 42 6c             	lea    0x6c(%edx),%eax
80105a38:	89 44 24 08          	mov    %eax,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a3c:	8b 42 10             	mov    0x10(%edx),%eax
80105a3f:	c7 04 24 ec 78 10 80 	movl   $0x801078ec,(%esp)
80105a46:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a4a:	e8 01 ac ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
80105a4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a55:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105a5c:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105a60:	83 e2 03             	and    $0x3,%edx
80105a63:	66 83 fa 03          	cmp    $0x3,%dx
80105a67:	0f 85 53 ff ff ff    	jne    801059c0 <trap+0x50>
    exit();
80105a6d:	e8 4e e2 ff ff       	call   80103cc0 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105a72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a78:	85 c0                	test   %eax,%eax
80105a7a:	0f 85 40 ff ff ff    	jne    801059c0 <trap+0x50>
80105a80:	e9 5d ff ff ff       	jmp    801059e2 <trap+0x72>
80105a85:	8d 76 00             	lea    0x0(%esi),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105a88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a8e:	8b 70 24             	mov    0x24(%eax),%esi
80105a91:	85 f6                	test   %esi,%esi
80105a93:	0f 85 a7 00 00 00    	jne    80105b40 <trap+0x1d0>
      exit();
    proc->tf = tf;
80105a99:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105a9c:	e8 9f ef ff ff       	call   80104a40 <syscall>
    if(proc->killed)
80105aa1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105aa7:	8b 58 24             	mov    0x24(%eax),%ebx
80105aaa:	85 db                	test   %ebx,%ebx
80105aac:	0f 84 30 ff ff ff    	je     801059e2 <trap+0x72>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105ab2:	83 c4 2c             	add    $0x2c,%esp
80105ab5:	5b                   	pop    %ebx
80105ab6:	5e                   	pop    %esi
80105ab7:	5f                   	pop    %edi
80105ab8:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105ab9:	e9 02 e2 ff ff       	jmp    80103cc0 <exit>
80105abe:	66 90                	xchg   %ax,%ax
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105ac0:	e8 0b cb ff ff       	call   801025d0 <kbdintr>
    lapiceoi();
80105ac5:	e8 36 cd ff ff       	call   80102800 <lapiceoi>
80105aca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105ad0:	e9 dc fe ff ff       	jmp    801059b1 <trap+0x41>
80105ad5:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ad8:	e8 a3 c5 ff ff       	call   80102080 <ideintr>
    lapiceoi();
80105add:	e8 1e cd ff ff       	call   80102800 <lapiceoi>
80105ae2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105ae8:	e9 c4 fe ff ff       	jmp    801059b1 <trap+0x41>
80105aed:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105af0:	e8 1b 02 00 00       	call   80105d10 <uartintr>
    lapiceoi();
80105af5:	e8 06 cd ff ff       	call   80102800 <lapiceoi>
80105afa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105b00:	e9 ac fe ff ff       	jmp    801059b1 <trap+0x41>
80105b05:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b08:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b0b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b0f:	e8 4c cc ff ff       	call   80102760 <cpunum>
80105b14:	c7 04 24 94 78 10 80 	movl   $0x80107894,(%esp)
80105b1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105b1f:	89 74 24 08          	mov    %esi,0x8(%esp)
80105b23:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b27:	e8 24 ab ff ff       	call   80100650 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80105b2c:	e8 cf cc ff ff       	call   80102800 <lapiceoi>
80105b31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105b37:	e9 75 fe ff ff       	jmp    801059b1 <trap+0x41>
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105b40:	e8 7b e1 ff ff       	call   80103cc0 <exit>
80105b45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b4b:	e9 49 ff ff ff       	jmp    80105a99 <trap+0x129>
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105b50:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b54:	0f 85 70 fe ff ff    	jne    801059ca <trap+0x5a>
    yield();
80105b5a:	e8 a1 e2 ff ff       	call   80103e00 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105b5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b65:	85 c0                	test   %eax,%eax
80105b67:	0f 85 5d fe ff ff    	jne    801059ca <trap+0x5a>
80105b6d:	e9 70 fe ff ff       	jmp    801059e2 <trap+0x72>
80105b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105b78:	c7 04 24 e0 4e 11 80 	movl   $0x80114ee0,(%esp)
80105b7f:	e8 5c e9 ff ff       	call   801044e0 <acquire>
      ticks++;
      wakeup(&ticks);
80105b84:	c7 04 24 20 57 11 80 	movl   $0x80115720,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
80105b8b:	83 05 20 57 11 80 01 	addl   $0x1,0x80115720
      wakeup(&ticks);
80105b92:	e8 59 e4 ff ff       	call   80103ff0 <wakeup>
      release(&tickslock);
80105b97:	c7 04 24 e0 4e 11 80 	movl   $0x80114ee0,(%esp)
80105b9e:	e8 6d ea ff ff       	call   80104610 <release>
80105ba3:	e9 fe fd ff ff       	jmp    801059a6 <trap+0x36>
80105ba8:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105bab:	8b 73 38             	mov    0x38(%ebx),%esi
80105bae:	e8 ad cb ff ff       	call   80102760 <cpunum>
80105bb3:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105bb7:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105bbb:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bbf:	8b 43 30             	mov    0x30(%ebx),%eax
80105bc2:	c7 04 24 b8 78 10 80 	movl   $0x801078b8,(%esp)
80105bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bcd:	e8 7e aa ff ff       	call   80100650 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105bd2:	c7 04 24 8e 78 10 80 	movl   $0x8010788e,(%esp)
80105bd9:	e8 82 a7 ff ff       	call   80100360 <panic>
80105bde:	66 90                	xchg   %ax,%ax

80105be0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105be0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105be5:	55                   	push   %ebp
80105be6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105be8:	85 c0                	test   %eax,%eax
80105bea:	74 14                	je     80105c00 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105bec:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105bf1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105bf2:	a8 01                	test   $0x1,%al
80105bf4:	74 0a                	je     80105c00 <uartgetc+0x20>
80105bf6:	b2 f8                	mov    $0xf8,%dl
80105bf8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105bf9:	0f b6 c0             	movzbl %al,%eax
}
80105bfc:	5d                   	pop    %ebp
80105bfd:	c3                   	ret    
80105bfe:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105c05:	5d                   	pop    %ebp
80105c06:	c3                   	ret    
80105c07:	89 f6                	mov    %esi,%esi
80105c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c10 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105c10:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80105c15:	85 c0                	test   %eax,%eax
80105c17:	74 3f                	je     80105c58 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105c19:	55                   	push   %ebp
80105c1a:	89 e5                	mov    %esp,%ebp
80105c1c:	56                   	push   %esi
80105c1d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105c22:	53                   	push   %ebx
  int i;

  if(!uart)
80105c23:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105c28:	83 ec 10             	sub    $0x10,%esp
80105c2b:	eb 14                	jmp    80105c41 <uartputc+0x31>
80105c2d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105c30:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105c37:	e8 e4 cb ff ff       	call   80102820 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105c3c:	83 eb 01             	sub    $0x1,%ebx
80105c3f:	74 07                	je     80105c48 <uartputc+0x38>
80105c41:	89 f2                	mov    %esi,%edx
80105c43:	ec                   	in     (%dx),%al
80105c44:	a8 20                	test   $0x20,%al
80105c46:	74 e8                	je     80105c30 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105c48:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c4c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c51:	ee                   	out    %al,(%dx)
}
80105c52:	83 c4 10             	add    $0x10,%esp
80105c55:	5b                   	pop    %ebx
80105c56:	5e                   	pop    %esi
80105c57:	5d                   	pop    %ebp
80105c58:	f3 c3                	repz ret 
80105c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c60 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105c60:	55                   	push   %ebp
80105c61:	31 c9                	xor    %ecx,%ecx
80105c63:	89 e5                	mov    %esp,%ebp
80105c65:	89 c8                	mov    %ecx,%eax
80105c67:	57                   	push   %edi
80105c68:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105c6d:	56                   	push   %esi
80105c6e:	89 fa                	mov    %edi,%edx
80105c70:	53                   	push   %ebx
80105c71:	83 ec 1c             	sub    $0x1c,%esp
80105c74:	ee                   	out    %al,(%dx)
80105c75:	be fb 03 00 00       	mov    $0x3fb,%esi
80105c7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c7f:	89 f2                	mov    %esi,%edx
80105c81:	ee                   	out    %al,(%dx)
80105c82:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c87:	b2 f8                	mov    $0xf8,%dl
80105c89:	ee                   	out    %al,(%dx)
80105c8a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105c8f:	89 c8                	mov    %ecx,%eax
80105c91:	89 da                	mov    %ebx,%edx
80105c93:	ee                   	out    %al,(%dx)
80105c94:	b8 03 00 00 00       	mov    $0x3,%eax
80105c99:	89 f2                	mov    %esi,%edx
80105c9b:	ee                   	out    %al,(%dx)
80105c9c:	b2 fc                	mov    $0xfc,%dl
80105c9e:	89 c8                	mov    %ecx,%eax
80105ca0:	ee                   	out    %al,(%dx)
80105ca1:	b8 01 00 00 00       	mov    $0x1,%eax
80105ca6:	89 da                	mov    %ebx,%edx
80105ca8:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ca9:	b2 fd                	mov    $0xfd,%dl
80105cab:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105cac:	3c ff                	cmp    $0xff,%al
80105cae:	74 52                	je     80105d02 <uartinit+0xa2>
    return;
  uart = 1;
80105cb0:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105cb7:	00 00 00 
80105cba:	89 fa                	mov    %edi,%edx
80105cbc:	ec                   	in     (%dx),%al
80105cbd:	b2 f8                	mov    $0xf8,%dl
80105cbf:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105cc0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105cc7:	bb b0 79 10 80       	mov    $0x801079b0,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105ccc:	e8 2f d5 ff ff       	call   80103200 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105cd1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105cd8:	00 
80105cd9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105ce0:	e8 cb c5 ff ff       	call   801022b0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105ce5:	b8 78 00 00 00       	mov    $0x78,%eax
80105cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc(*p);
80105cf0:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105cf3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105cf6:	e8 15 ff ff ff       	call   80105c10 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105cfb:	0f be 03             	movsbl (%ebx),%eax
80105cfe:	84 c0                	test   %al,%al
80105d00:	75 ee                	jne    80105cf0 <uartinit+0x90>
    uartputc(*p);
}
80105d02:	83 c4 1c             	add    $0x1c,%esp
80105d05:	5b                   	pop    %ebx
80105d06:	5e                   	pop    %esi
80105d07:	5f                   	pop    %edi
80105d08:	5d                   	pop    %ebp
80105d09:	c3                   	ret    
80105d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d10 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105d16:	c7 04 24 e0 5b 10 80 	movl   $0x80105be0,(%esp)
80105d1d:	e8 8e aa ff ff       	call   801007b0 <consoleintr>
}
80105d22:	c9                   	leave  
80105d23:	c3                   	ret    

80105d24 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105d24:	6a 00                	push   $0x0
  pushl $0
80105d26:	6a 00                	push   $0x0
  jmp alltraps
80105d28:	e9 40 fb ff ff       	jmp    8010586d <alltraps>

80105d2d <vector1>:
.globl vector1
vector1:
  pushl $0
80105d2d:	6a 00                	push   $0x0
  pushl $1
80105d2f:	6a 01                	push   $0x1
  jmp alltraps
80105d31:	e9 37 fb ff ff       	jmp    8010586d <alltraps>

80105d36 <vector2>:
.globl vector2
vector2:
  pushl $0
80105d36:	6a 00                	push   $0x0
  pushl $2
80105d38:	6a 02                	push   $0x2
  jmp alltraps
80105d3a:	e9 2e fb ff ff       	jmp    8010586d <alltraps>

80105d3f <vector3>:
.globl vector3
vector3:
  pushl $0
80105d3f:	6a 00                	push   $0x0
  pushl $3
80105d41:	6a 03                	push   $0x3
  jmp alltraps
80105d43:	e9 25 fb ff ff       	jmp    8010586d <alltraps>

80105d48 <vector4>:
.globl vector4
vector4:
  pushl $0
80105d48:	6a 00                	push   $0x0
  pushl $4
80105d4a:	6a 04                	push   $0x4
  jmp alltraps
80105d4c:	e9 1c fb ff ff       	jmp    8010586d <alltraps>

80105d51 <vector5>:
.globl vector5
vector5:
  pushl $0
80105d51:	6a 00                	push   $0x0
  pushl $5
80105d53:	6a 05                	push   $0x5
  jmp alltraps
80105d55:	e9 13 fb ff ff       	jmp    8010586d <alltraps>

80105d5a <vector6>:
.globl vector6
vector6:
  pushl $0
80105d5a:	6a 00                	push   $0x0
  pushl $6
80105d5c:	6a 06                	push   $0x6
  jmp alltraps
80105d5e:	e9 0a fb ff ff       	jmp    8010586d <alltraps>

80105d63 <vector7>:
.globl vector7
vector7:
  pushl $0
80105d63:	6a 00                	push   $0x0
  pushl $7
80105d65:	6a 07                	push   $0x7
  jmp alltraps
80105d67:	e9 01 fb ff ff       	jmp    8010586d <alltraps>

80105d6c <vector8>:
.globl vector8
vector8:
  pushl $8
80105d6c:	6a 08                	push   $0x8
  jmp alltraps
80105d6e:	e9 fa fa ff ff       	jmp    8010586d <alltraps>

80105d73 <vector9>:
.globl vector9
vector9:
  pushl $0
80105d73:	6a 00                	push   $0x0
  pushl $9
80105d75:	6a 09                	push   $0x9
  jmp alltraps
80105d77:	e9 f1 fa ff ff       	jmp    8010586d <alltraps>

80105d7c <vector10>:
.globl vector10
vector10:
  pushl $10
80105d7c:	6a 0a                	push   $0xa
  jmp alltraps
80105d7e:	e9 ea fa ff ff       	jmp    8010586d <alltraps>

80105d83 <vector11>:
.globl vector11
vector11:
  pushl $11
80105d83:	6a 0b                	push   $0xb
  jmp alltraps
80105d85:	e9 e3 fa ff ff       	jmp    8010586d <alltraps>

80105d8a <vector12>:
.globl vector12
vector12:
  pushl $12
80105d8a:	6a 0c                	push   $0xc
  jmp alltraps
80105d8c:	e9 dc fa ff ff       	jmp    8010586d <alltraps>

80105d91 <vector13>:
.globl vector13
vector13:
  pushl $13
80105d91:	6a 0d                	push   $0xd
  jmp alltraps
80105d93:	e9 d5 fa ff ff       	jmp    8010586d <alltraps>

80105d98 <vector14>:
.globl vector14
vector14:
  pushl $14
80105d98:	6a 0e                	push   $0xe
  jmp alltraps
80105d9a:	e9 ce fa ff ff       	jmp    8010586d <alltraps>

80105d9f <vector15>:
.globl vector15
vector15:
  pushl $0
80105d9f:	6a 00                	push   $0x0
  pushl $15
80105da1:	6a 0f                	push   $0xf
  jmp alltraps
80105da3:	e9 c5 fa ff ff       	jmp    8010586d <alltraps>

80105da8 <vector16>:
.globl vector16
vector16:
  pushl $0
80105da8:	6a 00                	push   $0x0
  pushl $16
80105daa:	6a 10                	push   $0x10
  jmp alltraps
80105dac:	e9 bc fa ff ff       	jmp    8010586d <alltraps>

80105db1 <vector17>:
.globl vector17
vector17:
  pushl $17
80105db1:	6a 11                	push   $0x11
  jmp alltraps
80105db3:	e9 b5 fa ff ff       	jmp    8010586d <alltraps>

80105db8 <vector18>:
.globl vector18
vector18:
  pushl $0
80105db8:	6a 00                	push   $0x0
  pushl $18
80105dba:	6a 12                	push   $0x12
  jmp alltraps
80105dbc:	e9 ac fa ff ff       	jmp    8010586d <alltraps>

80105dc1 <vector19>:
.globl vector19
vector19:
  pushl $0
80105dc1:	6a 00                	push   $0x0
  pushl $19
80105dc3:	6a 13                	push   $0x13
  jmp alltraps
80105dc5:	e9 a3 fa ff ff       	jmp    8010586d <alltraps>

80105dca <vector20>:
.globl vector20
vector20:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $20
80105dcc:	6a 14                	push   $0x14
  jmp alltraps
80105dce:	e9 9a fa ff ff       	jmp    8010586d <alltraps>

80105dd3 <vector21>:
.globl vector21
vector21:
  pushl $0
80105dd3:	6a 00                	push   $0x0
  pushl $21
80105dd5:	6a 15                	push   $0x15
  jmp alltraps
80105dd7:	e9 91 fa ff ff       	jmp    8010586d <alltraps>

80105ddc <vector22>:
.globl vector22
vector22:
  pushl $0
80105ddc:	6a 00                	push   $0x0
  pushl $22
80105dde:	6a 16                	push   $0x16
  jmp alltraps
80105de0:	e9 88 fa ff ff       	jmp    8010586d <alltraps>

80105de5 <vector23>:
.globl vector23
vector23:
  pushl $0
80105de5:	6a 00                	push   $0x0
  pushl $23
80105de7:	6a 17                	push   $0x17
  jmp alltraps
80105de9:	e9 7f fa ff ff       	jmp    8010586d <alltraps>

80105dee <vector24>:
.globl vector24
vector24:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $24
80105df0:	6a 18                	push   $0x18
  jmp alltraps
80105df2:	e9 76 fa ff ff       	jmp    8010586d <alltraps>

80105df7 <vector25>:
.globl vector25
vector25:
  pushl $0
80105df7:	6a 00                	push   $0x0
  pushl $25
80105df9:	6a 19                	push   $0x19
  jmp alltraps
80105dfb:	e9 6d fa ff ff       	jmp    8010586d <alltraps>

80105e00 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e00:	6a 00                	push   $0x0
  pushl $26
80105e02:	6a 1a                	push   $0x1a
  jmp alltraps
80105e04:	e9 64 fa ff ff       	jmp    8010586d <alltraps>

80105e09 <vector27>:
.globl vector27
vector27:
  pushl $0
80105e09:	6a 00                	push   $0x0
  pushl $27
80105e0b:	6a 1b                	push   $0x1b
  jmp alltraps
80105e0d:	e9 5b fa ff ff       	jmp    8010586d <alltraps>

80105e12 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $28
80105e14:	6a 1c                	push   $0x1c
  jmp alltraps
80105e16:	e9 52 fa ff ff       	jmp    8010586d <alltraps>

80105e1b <vector29>:
.globl vector29
vector29:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $29
80105e1d:	6a 1d                	push   $0x1d
  jmp alltraps
80105e1f:	e9 49 fa ff ff       	jmp    8010586d <alltraps>

80105e24 <vector30>:
.globl vector30
vector30:
  pushl $0
80105e24:	6a 00                	push   $0x0
  pushl $30
80105e26:	6a 1e                	push   $0x1e
  jmp alltraps
80105e28:	e9 40 fa ff ff       	jmp    8010586d <alltraps>

80105e2d <vector31>:
.globl vector31
vector31:
  pushl $0
80105e2d:	6a 00                	push   $0x0
  pushl $31
80105e2f:	6a 1f                	push   $0x1f
  jmp alltraps
80105e31:	e9 37 fa ff ff       	jmp    8010586d <alltraps>

80105e36 <vector32>:
.globl vector32
vector32:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $32
80105e38:	6a 20                	push   $0x20
  jmp alltraps
80105e3a:	e9 2e fa ff ff       	jmp    8010586d <alltraps>

80105e3f <vector33>:
.globl vector33
vector33:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $33
80105e41:	6a 21                	push   $0x21
  jmp alltraps
80105e43:	e9 25 fa ff ff       	jmp    8010586d <alltraps>

80105e48 <vector34>:
.globl vector34
vector34:
  pushl $0
80105e48:	6a 00                	push   $0x0
  pushl $34
80105e4a:	6a 22                	push   $0x22
  jmp alltraps
80105e4c:	e9 1c fa ff ff       	jmp    8010586d <alltraps>

80105e51 <vector35>:
.globl vector35
vector35:
  pushl $0
80105e51:	6a 00                	push   $0x0
  pushl $35
80105e53:	6a 23                	push   $0x23
  jmp alltraps
80105e55:	e9 13 fa ff ff       	jmp    8010586d <alltraps>

80105e5a <vector36>:
.globl vector36
vector36:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $36
80105e5c:	6a 24                	push   $0x24
  jmp alltraps
80105e5e:	e9 0a fa ff ff       	jmp    8010586d <alltraps>

80105e63 <vector37>:
.globl vector37
vector37:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $37
80105e65:	6a 25                	push   $0x25
  jmp alltraps
80105e67:	e9 01 fa ff ff       	jmp    8010586d <alltraps>

80105e6c <vector38>:
.globl vector38
vector38:
  pushl $0
80105e6c:	6a 00                	push   $0x0
  pushl $38
80105e6e:	6a 26                	push   $0x26
  jmp alltraps
80105e70:	e9 f8 f9 ff ff       	jmp    8010586d <alltraps>

80105e75 <vector39>:
.globl vector39
vector39:
  pushl $0
80105e75:	6a 00                	push   $0x0
  pushl $39
80105e77:	6a 27                	push   $0x27
  jmp alltraps
80105e79:	e9 ef f9 ff ff       	jmp    8010586d <alltraps>

80105e7e <vector40>:
.globl vector40
vector40:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $40
80105e80:	6a 28                	push   $0x28
  jmp alltraps
80105e82:	e9 e6 f9 ff ff       	jmp    8010586d <alltraps>

80105e87 <vector41>:
.globl vector41
vector41:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $41
80105e89:	6a 29                	push   $0x29
  jmp alltraps
80105e8b:	e9 dd f9 ff ff       	jmp    8010586d <alltraps>

80105e90 <vector42>:
.globl vector42
vector42:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $42
80105e92:	6a 2a                	push   $0x2a
  jmp alltraps
80105e94:	e9 d4 f9 ff ff       	jmp    8010586d <alltraps>

80105e99 <vector43>:
.globl vector43
vector43:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $43
80105e9b:	6a 2b                	push   $0x2b
  jmp alltraps
80105e9d:	e9 cb f9 ff ff       	jmp    8010586d <alltraps>

80105ea2 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $44
80105ea4:	6a 2c                	push   $0x2c
  jmp alltraps
80105ea6:	e9 c2 f9 ff ff       	jmp    8010586d <alltraps>

80105eab <vector45>:
.globl vector45
vector45:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $45
80105ead:	6a 2d                	push   $0x2d
  jmp alltraps
80105eaf:	e9 b9 f9 ff ff       	jmp    8010586d <alltraps>

80105eb4 <vector46>:
.globl vector46
vector46:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $46
80105eb6:	6a 2e                	push   $0x2e
  jmp alltraps
80105eb8:	e9 b0 f9 ff ff       	jmp    8010586d <alltraps>

80105ebd <vector47>:
.globl vector47
vector47:
  pushl $0
80105ebd:	6a 00                	push   $0x0
  pushl $47
80105ebf:	6a 2f                	push   $0x2f
  jmp alltraps
80105ec1:	e9 a7 f9 ff ff       	jmp    8010586d <alltraps>

80105ec6 <vector48>:
.globl vector48
vector48:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $48
80105ec8:	6a 30                	push   $0x30
  jmp alltraps
80105eca:	e9 9e f9 ff ff       	jmp    8010586d <alltraps>

80105ecf <vector49>:
.globl vector49
vector49:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $49
80105ed1:	6a 31                	push   $0x31
  jmp alltraps
80105ed3:	e9 95 f9 ff ff       	jmp    8010586d <alltraps>

80105ed8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $50
80105eda:	6a 32                	push   $0x32
  jmp alltraps
80105edc:	e9 8c f9 ff ff       	jmp    8010586d <alltraps>

80105ee1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105ee1:	6a 00                	push   $0x0
  pushl $51
80105ee3:	6a 33                	push   $0x33
  jmp alltraps
80105ee5:	e9 83 f9 ff ff       	jmp    8010586d <alltraps>

80105eea <vector52>:
.globl vector52
vector52:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $52
80105eec:	6a 34                	push   $0x34
  jmp alltraps
80105eee:	e9 7a f9 ff ff       	jmp    8010586d <alltraps>

80105ef3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $53
80105ef5:	6a 35                	push   $0x35
  jmp alltraps
80105ef7:	e9 71 f9 ff ff       	jmp    8010586d <alltraps>

80105efc <vector54>:
.globl vector54
vector54:
  pushl $0
80105efc:	6a 00                	push   $0x0
  pushl $54
80105efe:	6a 36                	push   $0x36
  jmp alltraps
80105f00:	e9 68 f9 ff ff       	jmp    8010586d <alltraps>

80105f05 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f05:	6a 00                	push   $0x0
  pushl $55
80105f07:	6a 37                	push   $0x37
  jmp alltraps
80105f09:	e9 5f f9 ff ff       	jmp    8010586d <alltraps>

80105f0e <vector56>:
.globl vector56
vector56:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $56
80105f10:	6a 38                	push   $0x38
  jmp alltraps
80105f12:	e9 56 f9 ff ff       	jmp    8010586d <alltraps>

80105f17 <vector57>:
.globl vector57
vector57:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $57
80105f19:	6a 39                	push   $0x39
  jmp alltraps
80105f1b:	e9 4d f9 ff ff       	jmp    8010586d <alltraps>

80105f20 <vector58>:
.globl vector58
vector58:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $58
80105f22:	6a 3a                	push   $0x3a
  jmp alltraps
80105f24:	e9 44 f9 ff ff       	jmp    8010586d <alltraps>

80105f29 <vector59>:
.globl vector59
vector59:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $59
80105f2b:	6a 3b                	push   $0x3b
  jmp alltraps
80105f2d:	e9 3b f9 ff ff       	jmp    8010586d <alltraps>

80105f32 <vector60>:
.globl vector60
vector60:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $60
80105f34:	6a 3c                	push   $0x3c
  jmp alltraps
80105f36:	e9 32 f9 ff ff       	jmp    8010586d <alltraps>

80105f3b <vector61>:
.globl vector61
vector61:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $61
80105f3d:	6a 3d                	push   $0x3d
  jmp alltraps
80105f3f:	e9 29 f9 ff ff       	jmp    8010586d <alltraps>

80105f44 <vector62>:
.globl vector62
vector62:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $62
80105f46:	6a 3e                	push   $0x3e
  jmp alltraps
80105f48:	e9 20 f9 ff ff       	jmp    8010586d <alltraps>

80105f4d <vector63>:
.globl vector63
vector63:
  pushl $0
80105f4d:	6a 00                	push   $0x0
  pushl $63
80105f4f:	6a 3f                	push   $0x3f
  jmp alltraps
80105f51:	e9 17 f9 ff ff       	jmp    8010586d <alltraps>

80105f56 <vector64>:
.globl vector64
vector64:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $64
80105f58:	6a 40                	push   $0x40
  jmp alltraps
80105f5a:	e9 0e f9 ff ff       	jmp    8010586d <alltraps>

80105f5f <vector65>:
.globl vector65
vector65:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $65
80105f61:	6a 41                	push   $0x41
  jmp alltraps
80105f63:	e9 05 f9 ff ff       	jmp    8010586d <alltraps>

80105f68 <vector66>:
.globl vector66
vector66:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $66
80105f6a:	6a 42                	push   $0x42
  jmp alltraps
80105f6c:	e9 fc f8 ff ff       	jmp    8010586d <alltraps>

80105f71 <vector67>:
.globl vector67
vector67:
  pushl $0
80105f71:	6a 00                	push   $0x0
  pushl $67
80105f73:	6a 43                	push   $0x43
  jmp alltraps
80105f75:	e9 f3 f8 ff ff       	jmp    8010586d <alltraps>

80105f7a <vector68>:
.globl vector68
vector68:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $68
80105f7c:	6a 44                	push   $0x44
  jmp alltraps
80105f7e:	e9 ea f8 ff ff       	jmp    8010586d <alltraps>

80105f83 <vector69>:
.globl vector69
vector69:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $69
80105f85:	6a 45                	push   $0x45
  jmp alltraps
80105f87:	e9 e1 f8 ff ff       	jmp    8010586d <alltraps>

80105f8c <vector70>:
.globl vector70
vector70:
  pushl $0
80105f8c:	6a 00                	push   $0x0
  pushl $70
80105f8e:	6a 46                	push   $0x46
  jmp alltraps
80105f90:	e9 d8 f8 ff ff       	jmp    8010586d <alltraps>

80105f95 <vector71>:
.globl vector71
vector71:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $71
80105f97:	6a 47                	push   $0x47
  jmp alltraps
80105f99:	e9 cf f8 ff ff       	jmp    8010586d <alltraps>

80105f9e <vector72>:
.globl vector72
vector72:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $72
80105fa0:	6a 48                	push   $0x48
  jmp alltraps
80105fa2:	e9 c6 f8 ff ff       	jmp    8010586d <alltraps>

80105fa7 <vector73>:
.globl vector73
vector73:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $73
80105fa9:	6a 49                	push   $0x49
  jmp alltraps
80105fab:	e9 bd f8 ff ff       	jmp    8010586d <alltraps>

80105fb0 <vector74>:
.globl vector74
vector74:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $74
80105fb2:	6a 4a                	push   $0x4a
  jmp alltraps
80105fb4:	e9 b4 f8 ff ff       	jmp    8010586d <alltraps>

80105fb9 <vector75>:
.globl vector75
vector75:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $75
80105fbb:	6a 4b                	push   $0x4b
  jmp alltraps
80105fbd:	e9 ab f8 ff ff       	jmp    8010586d <alltraps>

80105fc2 <vector76>:
.globl vector76
vector76:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $76
80105fc4:	6a 4c                	push   $0x4c
  jmp alltraps
80105fc6:	e9 a2 f8 ff ff       	jmp    8010586d <alltraps>

80105fcb <vector77>:
.globl vector77
vector77:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $77
80105fcd:	6a 4d                	push   $0x4d
  jmp alltraps
80105fcf:	e9 99 f8 ff ff       	jmp    8010586d <alltraps>

80105fd4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $78
80105fd6:	6a 4e                	push   $0x4e
  jmp alltraps
80105fd8:	e9 90 f8 ff ff       	jmp    8010586d <alltraps>

80105fdd <vector79>:
.globl vector79
vector79:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $79
80105fdf:	6a 4f                	push   $0x4f
  jmp alltraps
80105fe1:	e9 87 f8 ff ff       	jmp    8010586d <alltraps>

80105fe6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $80
80105fe8:	6a 50                	push   $0x50
  jmp alltraps
80105fea:	e9 7e f8 ff ff       	jmp    8010586d <alltraps>

80105fef <vector81>:
.globl vector81
vector81:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $81
80105ff1:	6a 51                	push   $0x51
  jmp alltraps
80105ff3:	e9 75 f8 ff ff       	jmp    8010586d <alltraps>

80105ff8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $82
80105ffa:	6a 52                	push   $0x52
  jmp alltraps
80105ffc:	e9 6c f8 ff ff       	jmp    8010586d <alltraps>

80106001 <vector83>:
.globl vector83
vector83:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $83
80106003:	6a 53                	push   $0x53
  jmp alltraps
80106005:	e9 63 f8 ff ff       	jmp    8010586d <alltraps>

8010600a <vector84>:
.globl vector84
vector84:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $84
8010600c:	6a 54                	push   $0x54
  jmp alltraps
8010600e:	e9 5a f8 ff ff       	jmp    8010586d <alltraps>

80106013 <vector85>:
.globl vector85
vector85:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $85
80106015:	6a 55                	push   $0x55
  jmp alltraps
80106017:	e9 51 f8 ff ff       	jmp    8010586d <alltraps>

8010601c <vector86>:
.globl vector86
vector86:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $86
8010601e:	6a 56                	push   $0x56
  jmp alltraps
80106020:	e9 48 f8 ff ff       	jmp    8010586d <alltraps>

80106025 <vector87>:
.globl vector87
vector87:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $87
80106027:	6a 57                	push   $0x57
  jmp alltraps
80106029:	e9 3f f8 ff ff       	jmp    8010586d <alltraps>

8010602e <vector88>:
.globl vector88
vector88:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $88
80106030:	6a 58                	push   $0x58
  jmp alltraps
80106032:	e9 36 f8 ff ff       	jmp    8010586d <alltraps>

80106037 <vector89>:
.globl vector89
vector89:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $89
80106039:	6a 59                	push   $0x59
  jmp alltraps
8010603b:	e9 2d f8 ff ff       	jmp    8010586d <alltraps>

80106040 <vector90>:
.globl vector90
vector90:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $90
80106042:	6a 5a                	push   $0x5a
  jmp alltraps
80106044:	e9 24 f8 ff ff       	jmp    8010586d <alltraps>

80106049 <vector91>:
.globl vector91
vector91:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $91
8010604b:	6a 5b                	push   $0x5b
  jmp alltraps
8010604d:	e9 1b f8 ff ff       	jmp    8010586d <alltraps>

80106052 <vector92>:
.globl vector92
vector92:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $92
80106054:	6a 5c                	push   $0x5c
  jmp alltraps
80106056:	e9 12 f8 ff ff       	jmp    8010586d <alltraps>

8010605b <vector93>:
.globl vector93
vector93:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $93
8010605d:	6a 5d                	push   $0x5d
  jmp alltraps
8010605f:	e9 09 f8 ff ff       	jmp    8010586d <alltraps>

80106064 <vector94>:
.globl vector94
vector94:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $94
80106066:	6a 5e                	push   $0x5e
  jmp alltraps
80106068:	e9 00 f8 ff ff       	jmp    8010586d <alltraps>

8010606d <vector95>:
.globl vector95
vector95:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $95
8010606f:	6a 5f                	push   $0x5f
  jmp alltraps
80106071:	e9 f7 f7 ff ff       	jmp    8010586d <alltraps>

80106076 <vector96>:
.globl vector96
vector96:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $96
80106078:	6a 60                	push   $0x60
  jmp alltraps
8010607a:	e9 ee f7 ff ff       	jmp    8010586d <alltraps>

8010607f <vector97>:
.globl vector97
vector97:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $97
80106081:	6a 61                	push   $0x61
  jmp alltraps
80106083:	e9 e5 f7 ff ff       	jmp    8010586d <alltraps>

80106088 <vector98>:
.globl vector98
vector98:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $98
8010608a:	6a 62                	push   $0x62
  jmp alltraps
8010608c:	e9 dc f7 ff ff       	jmp    8010586d <alltraps>

80106091 <vector99>:
.globl vector99
vector99:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $99
80106093:	6a 63                	push   $0x63
  jmp alltraps
80106095:	e9 d3 f7 ff ff       	jmp    8010586d <alltraps>

8010609a <vector100>:
.globl vector100
vector100:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $100
8010609c:	6a 64                	push   $0x64
  jmp alltraps
8010609e:	e9 ca f7 ff ff       	jmp    8010586d <alltraps>

801060a3 <vector101>:
.globl vector101
vector101:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $101
801060a5:	6a 65                	push   $0x65
  jmp alltraps
801060a7:	e9 c1 f7 ff ff       	jmp    8010586d <alltraps>

801060ac <vector102>:
.globl vector102
vector102:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $102
801060ae:	6a 66                	push   $0x66
  jmp alltraps
801060b0:	e9 b8 f7 ff ff       	jmp    8010586d <alltraps>

801060b5 <vector103>:
.globl vector103
vector103:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $103
801060b7:	6a 67                	push   $0x67
  jmp alltraps
801060b9:	e9 af f7 ff ff       	jmp    8010586d <alltraps>

801060be <vector104>:
.globl vector104
vector104:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $104
801060c0:	6a 68                	push   $0x68
  jmp alltraps
801060c2:	e9 a6 f7 ff ff       	jmp    8010586d <alltraps>

801060c7 <vector105>:
.globl vector105
vector105:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $105
801060c9:	6a 69                	push   $0x69
  jmp alltraps
801060cb:	e9 9d f7 ff ff       	jmp    8010586d <alltraps>

801060d0 <vector106>:
.globl vector106
vector106:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $106
801060d2:	6a 6a                	push   $0x6a
  jmp alltraps
801060d4:	e9 94 f7 ff ff       	jmp    8010586d <alltraps>

801060d9 <vector107>:
.globl vector107
vector107:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $107
801060db:	6a 6b                	push   $0x6b
  jmp alltraps
801060dd:	e9 8b f7 ff ff       	jmp    8010586d <alltraps>

801060e2 <vector108>:
.globl vector108
vector108:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $108
801060e4:	6a 6c                	push   $0x6c
  jmp alltraps
801060e6:	e9 82 f7 ff ff       	jmp    8010586d <alltraps>

801060eb <vector109>:
.globl vector109
vector109:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $109
801060ed:	6a 6d                	push   $0x6d
  jmp alltraps
801060ef:	e9 79 f7 ff ff       	jmp    8010586d <alltraps>

801060f4 <vector110>:
.globl vector110
vector110:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $110
801060f6:	6a 6e                	push   $0x6e
  jmp alltraps
801060f8:	e9 70 f7 ff ff       	jmp    8010586d <alltraps>

801060fd <vector111>:
.globl vector111
vector111:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $111
801060ff:	6a 6f                	push   $0x6f
  jmp alltraps
80106101:	e9 67 f7 ff ff       	jmp    8010586d <alltraps>

80106106 <vector112>:
.globl vector112
vector112:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $112
80106108:	6a 70                	push   $0x70
  jmp alltraps
8010610a:	e9 5e f7 ff ff       	jmp    8010586d <alltraps>

8010610f <vector113>:
.globl vector113
vector113:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $113
80106111:	6a 71                	push   $0x71
  jmp alltraps
80106113:	e9 55 f7 ff ff       	jmp    8010586d <alltraps>

80106118 <vector114>:
.globl vector114
vector114:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $114
8010611a:	6a 72                	push   $0x72
  jmp alltraps
8010611c:	e9 4c f7 ff ff       	jmp    8010586d <alltraps>

80106121 <vector115>:
.globl vector115
vector115:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $115
80106123:	6a 73                	push   $0x73
  jmp alltraps
80106125:	e9 43 f7 ff ff       	jmp    8010586d <alltraps>

8010612a <vector116>:
.globl vector116
vector116:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $116
8010612c:	6a 74                	push   $0x74
  jmp alltraps
8010612e:	e9 3a f7 ff ff       	jmp    8010586d <alltraps>

80106133 <vector117>:
.globl vector117
vector117:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $117
80106135:	6a 75                	push   $0x75
  jmp alltraps
80106137:	e9 31 f7 ff ff       	jmp    8010586d <alltraps>

8010613c <vector118>:
.globl vector118
vector118:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $118
8010613e:	6a 76                	push   $0x76
  jmp alltraps
80106140:	e9 28 f7 ff ff       	jmp    8010586d <alltraps>

80106145 <vector119>:
.globl vector119
vector119:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $119
80106147:	6a 77                	push   $0x77
  jmp alltraps
80106149:	e9 1f f7 ff ff       	jmp    8010586d <alltraps>

8010614e <vector120>:
.globl vector120
vector120:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $120
80106150:	6a 78                	push   $0x78
  jmp alltraps
80106152:	e9 16 f7 ff ff       	jmp    8010586d <alltraps>

80106157 <vector121>:
.globl vector121
vector121:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $121
80106159:	6a 79                	push   $0x79
  jmp alltraps
8010615b:	e9 0d f7 ff ff       	jmp    8010586d <alltraps>

80106160 <vector122>:
.globl vector122
vector122:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $122
80106162:	6a 7a                	push   $0x7a
  jmp alltraps
80106164:	e9 04 f7 ff ff       	jmp    8010586d <alltraps>

80106169 <vector123>:
.globl vector123
vector123:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $123
8010616b:	6a 7b                	push   $0x7b
  jmp alltraps
8010616d:	e9 fb f6 ff ff       	jmp    8010586d <alltraps>

80106172 <vector124>:
.globl vector124
vector124:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $124
80106174:	6a 7c                	push   $0x7c
  jmp alltraps
80106176:	e9 f2 f6 ff ff       	jmp    8010586d <alltraps>

8010617b <vector125>:
.globl vector125
vector125:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $125
8010617d:	6a 7d                	push   $0x7d
  jmp alltraps
8010617f:	e9 e9 f6 ff ff       	jmp    8010586d <alltraps>

80106184 <vector126>:
.globl vector126
vector126:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $126
80106186:	6a 7e                	push   $0x7e
  jmp alltraps
80106188:	e9 e0 f6 ff ff       	jmp    8010586d <alltraps>

8010618d <vector127>:
.globl vector127
vector127:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $127
8010618f:	6a 7f                	push   $0x7f
  jmp alltraps
80106191:	e9 d7 f6 ff ff       	jmp    8010586d <alltraps>

80106196 <vector128>:
.globl vector128
vector128:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $128
80106198:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010619d:	e9 cb f6 ff ff       	jmp    8010586d <alltraps>

801061a2 <vector129>:
.globl vector129
vector129:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $129
801061a4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801061a9:	e9 bf f6 ff ff       	jmp    8010586d <alltraps>

801061ae <vector130>:
.globl vector130
vector130:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $130
801061b0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801061b5:	e9 b3 f6 ff ff       	jmp    8010586d <alltraps>

801061ba <vector131>:
.globl vector131
vector131:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $131
801061bc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801061c1:	e9 a7 f6 ff ff       	jmp    8010586d <alltraps>

801061c6 <vector132>:
.globl vector132
vector132:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $132
801061c8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801061cd:	e9 9b f6 ff ff       	jmp    8010586d <alltraps>

801061d2 <vector133>:
.globl vector133
vector133:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $133
801061d4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801061d9:	e9 8f f6 ff ff       	jmp    8010586d <alltraps>

801061de <vector134>:
.globl vector134
vector134:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $134
801061e0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801061e5:	e9 83 f6 ff ff       	jmp    8010586d <alltraps>

801061ea <vector135>:
.globl vector135
vector135:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $135
801061ec:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801061f1:	e9 77 f6 ff ff       	jmp    8010586d <alltraps>

801061f6 <vector136>:
.globl vector136
vector136:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $136
801061f8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801061fd:	e9 6b f6 ff ff       	jmp    8010586d <alltraps>

80106202 <vector137>:
.globl vector137
vector137:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $137
80106204:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106209:	e9 5f f6 ff ff       	jmp    8010586d <alltraps>

8010620e <vector138>:
.globl vector138
vector138:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $138
80106210:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106215:	e9 53 f6 ff ff       	jmp    8010586d <alltraps>

8010621a <vector139>:
.globl vector139
vector139:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $139
8010621c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106221:	e9 47 f6 ff ff       	jmp    8010586d <alltraps>

80106226 <vector140>:
.globl vector140
vector140:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $140
80106228:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010622d:	e9 3b f6 ff ff       	jmp    8010586d <alltraps>

80106232 <vector141>:
.globl vector141
vector141:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $141
80106234:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106239:	e9 2f f6 ff ff       	jmp    8010586d <alltraps>

8010623e <vector142>:
.globl vector142
vector142:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $142
80106240:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106245:	e9 23 f6 ff ff       	jmp    8010586d <alltraps>

8010624a <vector143>:
.globl vector143
vector143:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $143
8010624c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106251:	e9 17 f6 ff ff       	jmp    8010586d <alltraps>

80106256 <vector144>:
.globl vector144
vector144:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $144
80106258:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010625d:	e9 0b f6 ff ff       	jmp    8010586d <alltraps>

80106262 <vector145>:
.globl vector145
vector145:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $145
80106264:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106269:	e9 ff f5 ff ff       	jmp    8010586d <alltraps>

8010626e <vector146>:
.globl vector146
vector146:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $146
80106270:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106275:	e9 f3 f5 ff ff       	jmp    8010586d <alltraps>

8010627a <vector147>:
.globl vector147
vector147:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $147
8010627c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106281:	e9 e7 f5 ff ff       	jmp    8010586d <alltraps>

80106286 <vector148>:
.globl vector148
vector148:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $148
80106288:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010628d:	e9 db f5 ff ff       	jmp    8010586d <alltraps>

80106292 <vector149>:
.globl vector149
vector149:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $149
80106294:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106299:	e9 cf f5 ff ff       	jmp    8010586d <alltraps>

8010629e <vector150>:
.globl vector150
vector150:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $150
801062a0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801062a5:	e9 c3 f5 ff ff       	jmp    8010586d <alltraps>

801062aa <vector151>:
.globl vector151
vector151:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $151
801062ac:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801062b1:	e9 b7 f5 ff ff       	jmp    8010586d <alltraps>

801062b6 <vector152>:
.globl vector152
vector152:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $152
801062b8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801062bd:	e9 ab f5 ff ff       	jmp    8010586d <alltraps>

801062c2 <vector153>:
.globl vector153
vector153:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $153
801062c4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801062c9:	e9 9f f5 ff ff       	jmp    8010586d <alltraps>

801062ce <vector154>:
.globl vector154
vector154:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $154
801062d0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801062d5:	e9 93 f5 ff ff       	jmp    8010586d <alltraps>

801062da <vector155>:
.globl vector155
vector155:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $155
801062dc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801062e1:	e9 87 f5 ff ff       	jmp    8010586d <alltraps>

801062e6 <vector156>:
.globl vector156
vector156:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $156
801062e8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801062ed:	e9 7b f5 ff ff       	jmp    8010586d <alltraps>

801062f2 <vector157>:
.globl vector157
vector157:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $157
801062f4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801062f9:	e9 6f f5 ff ff       	jmp    8010586d <alltraps>

801062fe <vector158>:
.globl vector158
vector158:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $158
80106300:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106305:	e9 63 f5 ff ff       	jmp    8010586d <alltraps>

8010630a <vector159>:
.globl vector159
vector159:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $159
8010630c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106311:	e9 57 f5 ff ff       	jmp    8010586d <alltraps>

80106316 <vector160>:
.globl vector160
vector160:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $160
80106318:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010631d:	e9 4b f5 ff ff       	jmp    8010586d <alltraps>

80106322 <vector161>:
.globl vector161
vector161:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $161
80106324:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106329:	e9 3f f5 ff ff       	jmp    8010586d <alltraps>

8010632e <vector162>:
.globl vector162
vector162:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $162
80106330:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106335:	e9 33 f5 ff ff       	jmp    8010586d <alltraps>

8010633a <vector163>:
.globl vector163
vector163:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $163
8010633c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106341:	e9 27 f5 ff ff       	jmp    8010586d <alltraps>

80106346 <vector164>:
.globl vector164
vector164:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $164
80106348:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010634d:	e9 1b f5 ff ff       	jmp    8010586d <alltraps>

80106352 <vector165>:
.globl vector165
vector165:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $165
80106354:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106359:	e9 0f f5 ff ff       	jmp    8010586d <alltraps>

8010635e <vector166>:
.globl vector166
vector166:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $166
80106360:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106365:	e9 03 f5 ff ff       	jmp    8010586d <alltraps>

8010636a <vector167>:
.globl vector167
vector167:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $167
8010636c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106371:	e9 f7 f4 ff ff       	jmp    8010586d <alltraps>

80106376 <vector168>:
.globl vector168
vector168:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $168
80106378:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010637d:	e9 eb f4 ff ff       	jmp    8010586d <alltraps>

80106382 <vector169>:
.globl vector169
vector169:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $169
80106384:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106389:	e9 df f4 ff ff       	jmp    8010586d <alltraps>

8010638e <vector170>:
.globl vector170
vector170:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $170
80106390:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106395:	e9 d3 f4 ff ff       	jmp    8010586d <alltraps>

8010639a <vector171>:
.globl vector171
vector171:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $171
8010639c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801063a1:	e9 c7 f4 ff ff       	jmp    8010586d <alltraps>

801063a6 <vector172>:
.globl vector172
vector172:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $172
801063a8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801063ad:	e9 bb f4 ff ff       	jmp    8010586d <alltraps>

801063b2 <vector173>:
.globl vector173
vector173:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $173
801063b4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801063b9:	e9 af f4 ff ff       	jmp    8010586d <alltraps>

801063be <vector174>:
.globl vector174
vector174:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $174
801063c0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801063c5:	e9 a3 f4 ff ff       	jmp    8010586d <alltraps>

801063ca <vector175>:
.globl vector175
vector175:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $175
801063cc:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801063d1:	e9 97 f4 ff ff       	jmp    8010586d <alltraps>

801063d6 <vector176>:
.globl vector176
vector176:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $176
801063d8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801063dd:	e9 8b f4 ff ff       	jmp    8010586d <alltraps>

801063e2 <vector177>:
.globl vector177
vector177:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $177
801063e4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801063e9:	e9 7f f4 ff ff       	jmp    8010586d <alltraps>

801063ee <vector178>:
.globl vector178
vector178:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $178
801063f0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801063f5:	e9 73 f4 ff ff       	jmp    8010586d <alltraps>

801063fa <vector179>:
.globl vector179
vector179:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $179
801063fc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106401:	e9 67 f4 ff ff       	jmp    8010586d <alltraps>

80106406 <vector180>:
.globl vector180
vector180:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $180
80106408:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010640d:	e9 5b f4 ff ff       	jmp    8010586d <alltraps>

80106412 <vector181>:
.globl vector181
vector181:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $181
80106414:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106419:	e9 4f f4 ff ff       	jmp    8010586d <alltraps>

8010641e <vector182>:
.globl vector182
vector182:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $182
80106420:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106425:	e9 43 f4 ff ff       	jmp    8010586d <alltraps>

8010642a <vector183>:
.globl vector183
vector183:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $183
8010642c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106431:	e9 37 f4 ff ff       	jmp    8010586d <alltraps>

80106436 <vector184>:
.globl vector184
vector184:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $184
80106438:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010643d:	e9 2b f4 ff ff       	jmp    8010586d <alltraps>

80106442 <vector185>:
.globl vector185
vector185:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $185
80106444:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106449:	e9 1f f4 ff ff       	jmp    8010586d <alltraps>

8010644e <vector186>:
.globl vector186
vector186:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $186
80106450:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106455:	e9 13 f4 ff ff       	jmp    8010586d <alltraps>

8010645a <vector187>:
.globl vector187
vector187:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $187
8010645c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106461:	e9 07 f4 ff ff       	jmp    8010586d <alltraps>

80106466 <vector188>:
.globl vector188
vector188:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $188
80106468:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010646d:	e9 fb f3 ff ff       	jmp    8010586d <alltraps>

80106472 <vector189>:
.globl vector189
vector189:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $189
80106474:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106479:	e9 ef f3 ff ff       	jmp    8010586d <alltraps>

8010647e <vector190>:
.globl vector190
vector190:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $190
80106480:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106485:	e9 e3 f3 ff ff       	jmp    8010586d <alltraps>

8010648a <vector191>:
.globl vector191
vector191:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $191
8010648c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106491:	e9 d7 f3 ff ff       	jmp    8010586d <alltraps>

80106496 <vector192>:
.globl vector192
vector192:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $192
80106498:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010649d:	e9 cb f3 ff ff       	jmp    8010586d <alltraps>

801064a2 <vector193>:
.globl vector193
vector193:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $193
801064a4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801064a9:	e9 bf f3 ff ff       	jmp    8010586d <alltraps>

801064ae <vector194>:
.globl vector194
vector194:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $194
801064b0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801064b5:	e9 b3 f3 ff ff       	jmp    8010586d <alltraps>

801064ba <vector195>:
.globl vector195
vector195:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $195
801064bc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801064c1:	e9 a7 f3 ff ff       	jmp    8010586d <alltraps>

801064c6 <vector196>:
.globl vector196
vector196:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $196
801064c8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801064cd:	e9 9b f3 ff ff       	jmp    8010586d <alltraps>

801064d2 <vector197>:
.globl vector197
vector197:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $197
801064d4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801064d9:	e9 8f f3 ff ff       	jmp    8010586d <alltraps>

801064de <vector198>:
.globl vector198
vector198:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $198
801064e0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801064e5:	e9 83 f3 ff ff       	jmp    8010586d <alltraps>

801064ea <vector199>:
.globl vector199
vector199:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $199
801064ec:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801064f1:	e9 77 f3 ff ff       	jmp    8010586d <alltraps>

801064f6 <vector200>:
.globl vector200
vector200:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $200
801064f8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801064fd:	e9 6b f3 ff ff       	jmp    8010586d <alltraps>

80106502 <vector201>:
.globl vector201
vector201:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $201
80106504:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106509:	e9 5f f3 ff ff       	jmp    8010586d <alltraps>

8010650e <vector202>:
.globl vector202
vector202:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $202
80106510:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106515:	e9 53 f3 ff ff       	jmp    8010586d <alltraps>

8010651a <vector203>:
.globl vector203
vector203:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $203
8010651c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106521:	e9 47 f3 ff ff       	jmp    8010586d <alltraps>

80106526 <vector204>:
.globl vector204
vector204:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $204
80106528:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010652d:	e9 3b f3 ff ff       	jmp    8010586d <alltraps>

80106532 <vector205>:
.globl vector205
vector205:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $205
80106534:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106539:	e9 2f f3 ff ff       	jmp    8010586d <alltraps>

8010653e <vector206>:
.globl vector206
vector206:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $206
80106540:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106545:	e9 23 f3 ff ff       	jmp    8010586d <alltraps>

8010654a <vector207>:
.globl vector207
vector207:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $207
8010654c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106551:	e9 17 f3 ff ff       	jmp    8010586d <alltraps>

80106556 <vector208>:
.globl vector208
vector208:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $208
80106558:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010655d:	e9 0b f3 ff ff       	jmp    8010586d <alltraps>

80106562 <vector209>:
.globl vector209
vector209:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $209
80106564:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106569:	e9 ff f2 ff ff       	jmp    8010586d <alltraps>

8010656e <vector210>:
.globl vector210
vector210:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $210
80106570:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106575:	e9 f3 f2 ff ff       	jmp    8010586d <alltraps>

8010657a <vector211>:
.globl vector211
vector211:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $211
8010657c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106581:	e9 e7 f2 ff ff       	jmp    8010586d <alltraps>

80106586 <vector212>:
.globl vector212
vector212:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $212
80106588:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010658d:	e9 db f2 ff ff       	jmp    8010586d <alltraps>

80106592 <vector213>:
.globl vector213
vector213:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $213
80106594:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106599:	e9 cf f2 ff ff       	jmp    8010586d <alltraps>

8010659e <vector214>:
.globl vector214
vector214:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $214
801065a0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801065a5:	e9 c3 f2 ff ff       	jmp    8010586d <alltraps>

801065aa <vector215>:
.globl vector215
vector215:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $215
801065ac:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801065b1:	e9 b7 f2 ff ff       	jmp    8010586d <alltraps>

801065b6 <vector216>:
.globl vector216
vector216:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $216
801065b8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801065bd:	e9 ab f2 ff ff       	jmp    8010586d <alltraps>

801065c2 <vector217>:
.globl vector217
vector217:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $217
801065c4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801065c9:	e9 9f f2 ff ff       	jmp    8010586d <alltraps>

801065ce <vector218>:
.globl vector218
vector218:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $218
801065d0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801065d5:	e9 93 f2 ff ff       	jmp    8010586d <alltraps>

801065da <vector219>:
.globl vector219
vector219:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $219
801065dc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801065e1:	e9 87 f2 ff ff       	jmp    8010586d <alltraps>

801065e6 <vector220>:
.globl vector220
vector220:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $220
801065e8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801065ed:	e9 7b f2 ff ff       	jmp    8010586d <alltraps>

801065f2 <vector221>:
.globl vector221
vector221:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $221
801065f4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801065f9:	e9 6f f2 ff ff       	jmp    8010586d <alltraps>

801065fe <vector222>:
.globl vector222
vector222:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $222
80106600:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106605:	e9 63 f2 ff ff       	jmp    8010586d <alltraps>

8010660a <vector223>:
.globl vector223
vector223:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $223
8010660c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106611:	e9 57 f2 ff ff       	jmp    8010586d <alltraps>

80106616 <vector224>:
.globl vector224
vector224:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $224
80106618:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010661d:	e9 4b f2 ff ff       	jmp    8010586d <alltraps>

80106622 <vector225>:
.globl vector225
vector225:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $225
80106624:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106629:	e9 3f f2 ff ff       	jmp    8010586d <alltraps>

8010662e <vector226>:
.globl vector226
vector226:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $226
80106630:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106635:	e9 33 f2 ff ff       	jmp    8010586d <alltraps>

8010663a <vector227>:
.globl vector227
vector227:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $227
8010663c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106641:	e9 27 f2 ff ff       	jmp    8010586d <alltraps>

80106646 <vector228>:
.globl vector228
vector228:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $228
80106648:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010664d:	e9 1b f2 ff ff       	jmp    8010586d <alltraps>

80106652 <vector229>:
.globl vector229
vector229:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $229
80106654:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106659:	e9 0f f2 ff ff       	jmp    8010586d <alltraps>

8010665e <vector230>:
.globl vector230
vector230:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $230
80106660:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106665:	e9 03 f2 ff ff       	jmp    8010586d <alltraps>

8010666a <vector231>:
.globl vector231
vector231:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $231
8010666c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106671:	e9 f7 f1 ff ff       	jmp    8010586d <alltraps>

80106676 <vector232>:
.globl vector232
vector232:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $232
80106678:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010667d:	e9 eb f1 ff ff       	jmp    8010586d <alltraps>

80106682 <vector233>:
.globl vector233
vector233:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $233
80106684:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106689:	e9 df f1 ff ff       	jmp    8010586d <alltraps>

8010668e <vector234>:
.globl vector234
vector234:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $234
80106690:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106695:	e9 d3 f1 ff ff       	jmp    8010586d <alltraps>

8010669a <vector235>:
.globl vector235
vector235:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $235
8010669c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801066a1:	e9 c7 f1 ff ff       	jmp    8010586d <alltraps>

801066a6 <vector236>:
.globl vector236
vector236:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $236
801066a8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801066ad:	e9 bb f1 ff ff       	jmp    8010586d <alltraps>

801066b2 <vector237>:
.globl vector237
vector237:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $237
801066b4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801066b9:	e9 af f1 ff ff       	jmp    8010586d <alltraps>

801066be <vector238>:
.globl vector238
vector238:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $238
801066c0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801066c5:	e9 a3 f1 ff ff       	jmp    8010586d <alltraps>

801066ca <vector239>:
.globl vector239
vector239:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $239
801066cc:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801066d1:	e9 97 f1 ff ff       	jmp    8010586d <alltraps>

801066d6 <vector240>:
.globl vector240
vector240:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $240
801066d8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801066dd:	e9 8b f1 ff ff       	jmp    8010586d <alltraps>

801066e2 <vector241>:
.globl vector241
vector241:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $241
801066e4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801066e9:	e9 7f f1 ff ff       	jmp    8010586d <alltraps>

801066ee <vector242>:
.globl vector242
vector242:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $242
801066f0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801066f5:	e9 73 f1 ff ff       	jmp    8010586d <alltraps>

801066fa <vector243>:
.globl vector243
vector243:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $243
801066fc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106701:	e9 67 f1 ff ff       	jmp    8010586d <alltraps>

80106706 <vector244>:
.globl vector244
vector244:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $244
80106708:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010670d:	e9 5b f1 ff ff       	jmp    8010586d <alltraps>

80106712 <vector245>:
.globl vector245
vector245:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $245
80106714:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106719:	e9 4f f1 ff ff       	jmp    8010586d <alltraps>

8010671e <vector246>:
.globl vector246
vector246:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $246
80106720:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106725:	e9 43 f1 ff ff       	jmp    8010586d <alltraps>

8010672a <vector247>:
.globl vector247
vector247:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $247
8010672c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106731:	e9 37 f1 ff ff       	jmp    8010586d <alltraps>

80106736 <vector248>:
.globl vector248
vector248:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $248
80106738:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010673d:	e9 2b f1 ff ff       	jmp    8010586d <alltraps>

80106742 <vector249>:
.globl vector249
vector249:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $249
80106744:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106749:	e9 1f f1 ff ff       	jmp    8010586d <alltraps>

8010674e <vector250>:
.globl vector250
vector250:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $250
80106750:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106755:	e9 13 f1 ff ff       	jmp    8010586d <alltraps>

8010675a <vector251>:
.globl vector251
vector251:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $251
8010675c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106761:	e9 07 f1 ff ff       	jmp    8010586d <alltraps>

80106766 <vector252>:
.globl vector252
vector252:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $252
80106768:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010676d:	e9 fb f0 ff ff       	jmp    8010586d <alltraps>

80106772 <vector253>:
.globl vector253
vector253:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $253
80106774:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106779:	e9 ef f0 ff ff       	jmp    8010586d <alltraps>

8010677e <vector254>:
.globl vector254
vector254:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $254
80106780:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106785:	e9 e3 f0 ff ff       	jmp    8010586d <alltraps>

8010678a <vector255>:
.globl vector255
vector255:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $255
8010678c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106791:	e9 d7 f0 ff ff       	jmp    8010586d <alltraps>
80106796:	66 90                	xchg   %ax,%ax
80106798:	66 90                	xchg   %ax,%ax
8010679a:	66 90                	xchg   %ax,%ax
8010679c:	66 90                	xchg   %ax,%ax
8010679e:	66 90                	xchg   %ax,%ax

801067a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
801067a3:	57                   	push   %edi
801067a4:	56                   	push   %esi
801067a5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801067a7:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801067aa:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801067ab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801067ae:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801067b1:	8b 1f                	mov    (%edi),%ebx
801067b3:	f6 c3 01             	test   $0x1,%bl
801067b6:	74 28                	je     801067e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801067b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801067be:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801067c4:	c1 ee 0a             	shr    $0xa,%esi
}
801067c7:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801067ca:	89 f2                	mov    %esi,%edx
801067cc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801067d2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801067d5:	5b                   	pop    %ebx
801067d6:	5e                   	pop    %esi
801067d7:	5f                   	pop    %edi
801067d8:	5d                   	pop    %ebp
801067d9:	c3                   	ret    
801067da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801067e0:	85 c9                	test   %ecx,%ecx
801067e2:	74 34                	je     80106818 <walkpgdir+0x78>
801067e4:	e8 b7 bc ff ff       	call   801024a0 <kalloc>
801067e9:	85 c0                	test   %eax,%eax
801067eb:	89 c3                	mov    %eax,%ebx
801067ed:	74 29                	je     80106818 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801067ef:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801067f6:	00 
801067f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067fe:	00 
801067ff:	89 04 24             	mov    %eax,(%esp)
80106802:	e8 59 de ff ff       	call   80104660 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106807:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010680d:	83 c8 07             	or     $0x7,%eax
80106810:	89 07                	mov    %eax,(%edi)
80106812:	eb b0                	jmp    801067c4 <walkpgdir+0x24>
80106814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
80106818:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
8010681b:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
8010681d:	5b                   	pop    %ebx
8010681e:	5e                   	pop    %esi
8010681f:	5f                   	pop    %edi
80106820:	5d                   	pop    %ebp
80106821:	c3                   	ret    
80106822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106830 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	57                   	push   %edi
80106834:	56                   	push   %esi
80106835:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106836:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106838:	83 ec 1c             	sub    $0x1c,%esp
8010683b:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010683e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106844:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106847:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010684b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010684e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106852:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106859:	29 df                	sub    %ebx,%edi
8010685b:	eb 18                	jmp    80106875 <mappages+0x45>
8010685d:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106860:	f6 00 01             	testb  $0x1,(%eax)
80106863:	75 3d                	jne    801068a2 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106865:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106868:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010686b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010686d:	74 29                	je     80106898 <mappages+0x68>
      break;
    a += PGSIZE;
8010686f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106875:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106878:	b9 01 00 00 00       	mov    $0x1,%ecx
8010687d:	89 da                	mov    %ebx,%edx
8010687f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106882:	e8 19 ff ff ff       	call   801067a0 <walkpgdir>
80106887:	85 c0                	test   %eax,%eax
80106889:	75 d5                	jne    80106860 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010688b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010688e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106893:	5b                   	pop    %ebx
80106894:	5e                   	pop    %esi
80106895:	5f                   	pop    %edi
80106896:	5d                   	pop    %ebp
80106897:	c3                   	ret    
80106898:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010689b:	31 c0                	xor    %eax,%eax
}
8010689d:	5b                   	pop    %ebx
8010689e:	5e                   	pop    %esi
8010689f:	5f                   	pop    %edi
801068a0:	5d                   	pop    %ebp
801068a1:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801068a2:	c7 04 24 b8 79 10 80 	movl   $0x801079b8,(%esp)
801068a9:	e8 b2 9a ff ff       	call   80100360 <panic>
801068ae:	66 90                	xchg   %ax,%ax

801068b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	57                   	push   %edi
801068b4:	89 c7                	mov    %eax,%edi
801068b6:	56                   	push   %esi
801068b7:	89 d6                	mov    %edx,%esi
801068b9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801068ba:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068c0:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801068c3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801068c9:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801068ce:	72 3b                	jb     8010690b <deallocuvm.part.0+0x5b>
801068d0:	eb 5e                	jmp    80106930 <deallocuvm.part.0+0x80>
801068d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
801068d8:	8b 10                	mov    (%eax),%edx
801068da:	f6 c2 01             	test   $0x1,%dl
801068dd:	74 22                	je     80106901 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801068df:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801068e5:	74 54                	je     8010693b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
801068e7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801068ed:	89 14 24             	mov    %edx,(%esp)
801068f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068f3:	e8 f8 b9 ff ff       	call   801022f0 <kfree>
      *pte = 0;
801068f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106901:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106907:	39 f3                	cmp    %esi,%ebx
80106909:	73 25                	jae    80106930 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010690b:	31 c9                	xor    %ecx,%ecx
8010690d:	89 da                	mov    %ebx,%edx
8010690f:	89 f8                	mov    %edi,%eax
80106911:	e8 8a fe ff ff       	call   801067a0 <walkpgdir>
    if(!pte)
80106916:	85 c0                	test   %eax,%eax
80106918:	75 be                	jne    801068d8 <deallocuvm.part.0+0x28>
      a += (NPTENTRIES - 1) * PGSIZE;
8010691a:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106920:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106926:	39 f3                	cmp    %esi,%ebx
80106928:	72 e1                	jb     8010690b <deallocuvm.part.0+0x5b>
8010692a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106930:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106933:	83 c4 1c             	add    $0x1c,%esp
80106936:	5b                   	pop    %ebx
80106937:	5e                   	pop    %esi
80106938:	5f                   	pop    %edi
80106939:	5d                   	pop    %ebp
8010693a:	c3                   	ret    
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010693b:	c7 04 24 12 73 10 80 	movl   $0x80107312,(%esp)
80106942:	e8 19 9a ff ff       	call   80100360 <panic>
80106947:	89 f6                	mov    %esi,%esi
80106949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106950 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106956:	e8 05 be ff ff       	call   80102760 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010695b:	31 c9                	xor    %ecx,%ecx
8010695d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106962:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106968:	05 a0 27 11 80       	add    $0x801127a0,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010696d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106971:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106976:	66 89 48 7a          	mov    %cx,0x7a(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010697a:	31 c9                	xor    %ecx,%ecx
8010697c:	66 89 90 80 00 00 00 	mov    %dx,0x80(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106983:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106988:	66 89 88 82 00 00 00 	mov    %cx,0x82(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010698f:	31 c9                	xor    %ecx,%ecx
80106991:	66 89 90 90 00 00 00 	mov    %dx,0x90(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106998:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010699d:	66 89 88 92 00 00 00 	mov    %cx,0x92(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801069a4:	31 c9                	xor    %ecx,%ecx
801069a6:	66 89 90 98 00 00 00 	mov    %dx,0x98(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801069ad:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801069b3:	66 89 88 9a 00 00 00 	mov    %cx,0x9a(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801069ba:	31 c9                	xor    %ecx,%ecx
801069bc:	66 89 88 88 00 00 00 	mov    %cx,0x88(%eax)
801069c3:	89 d1                	mov    %edx,%ecx
801069c5:	c1 e9 10             	shr    $0x10,%ecx
801069c8:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
801069cf:	c1 ea 18             	shr    $0x18,%edx
801069d2:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801069d8:	b9 37 00 00 00       	mov    $0x37,%ecx
801069dd:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801069e3:	8d 50 70             	lea    0x70(%eax),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069e6:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
801069ea:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069ee:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
801069f5:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801069fc:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
80106a03:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a0a:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
80106a11:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106a18:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
80106a1f:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
80106a26:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
80106a2a:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a2e:	c1 ea 10             	shr    $0x10,%edx
80106a31:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106a35:	8d 55 f2             	lea    -0xe(%ebp),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a38:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80106a3c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a40:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80106a47:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a4e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80106a55:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a5c:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80106a63:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
80106a6a:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80106a6d:	ba 18 00 00 00       	mov    $0x18,%edx
80106a72:	8e ea                	mov    %edx,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
80106a74:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106a7b:	00 00 00 00 

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
80106a7f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
}
80106a85:	c9                   	leave  
80106a86:	c3                   	ret    
80106a87:	89 f6                	mov    %esi,%esi
80106a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a90 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	56                   	push   %esi
80106a94:	53                   	push   %ebx
80106a95:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106a98:	e8 03 ba ff ff       	call   801024a0 <kalloc>
80106a9d:	85 c0                	test   %eax,%eax
80106a9f:	89 c6                	mov    %eax,%esi
80106aa1:	74 55                	je     80106af8 <setupkvm+0x68>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106aa3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106aaa:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106aab:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106ab0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ab7:	00 
80106ab8:	89 04 24             	mov    %eax,(%esp)
80106abb:	e8 a0 db ff ff       	call   80104660 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ac0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106ac3:	8b 43 04             	mov    0x4(%ebx),%eax
80106ac6:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106ac9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106acd:	8b 13                	mov    (%ebx),%edx
80106acf:	89 04 24             	mov    %eax,(%esp)
80106ad2:	29 c1                	sub    %eax,%ecx
80106ad4:	89 f0                	mov    %esi,%eax
80106ad6:	e8 55 fd ff ff       	call   80106830 <mappages>
80106adb:	85 c0                	test   %eax,%eax
80106add:	78 19                	js     80106af8 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106adf:	83 c3 10             	add    $0x10,%ebx
80106ae2:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ae8:	72 d6                	jb     80106ac0 <setupkvm+0x30>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106aea:	83 c4 10             	add    $0x10,%esp
80106aed:	89 f0                	mov    %esi,%eax
80106aef:	5b                   	pop    %ebx
80106af0:	5e                   	pop    %esi
80106af1:	5d                   	pop    %ebp
80106af2:	c3                   	ret    
80106af3:	90                   	nop
80106af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106af8:	83 c4 10             	add    $0x10,%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106afb:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106afd:	5b                   	pop    %ebx
80106afe:	5e                   	pop    %esi
80106aff:	5d                   	pop    %ebp
80106b00:	c3                   	ret    
80106b01:	eb 0d                	jmp    80106b10 <kvmalloc>
80106b03:	90                   	nop
80106b04:	90                   	nop
80106b05:	90                   	nop
80106b06:	90                   	nop
80106b07:	90                   	nop
80106b08:	90                   	nop
80106b09:	90                   	nop
80106b0a:	90                   	nop
80106b0b:	90                   	nop
80106b0c:	90                   	nop
80106b0d:	90                   	nop
80106b0e:	90                   	nop
80106b0f:	90                   	nop

80106b10 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106b16:	e8 75 ff ff ff       	call   80106a90 <setupkvm>
80106b1b:	a3 24 57 11 80       	mov    %eax,0x80115724
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b20:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b25:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106b28:	c9                   	leave  
80106b29:	c3                   	ret    
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b30 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b30:	a1 24 57 11 80       	mov    0x80115724,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106b35:	55                   	push   %ebp
80106b36:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b38:	05 00 00 00 80       	add    $0x80000000,%eax
80106b3d:	0f 22 d8             	mov    %eax,%cr3
}
80106b40:	5d                   	pop    %ebp
80106b41:	c3                   	ret    
80106b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b50 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	53                   	push   %ebx
80106b54:	83 ec 14             	sub    $0x14,%esp
80106b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106b5a:	e8 31 da ff ff       	call   80104590 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106b5f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106b65:	b9 67 00 00 00       	mov    $0x67,%ecx
80106b6a:	8d 50 08             	lea    0x8(%eax),%edx
80106b6d:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106b74:	89 d1                	mov    %edx,%ecx
80106b76:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106b7d:	c1 ea 18             	shr    $0x18,%edx
80106b80:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106b86:	ba 10 00 00 00       	mov    $0x10,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106b8b:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
80106b92:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
80106b95:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80106b9c:	66 89 50 10          	mov    %dx,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106ba0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106ba7:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106bad:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106bb2:	8b 52 08             	mov    0x8(%edx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106bb5:	66 89 48 6e          	mov    %cx,0x6e(%eax)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106bb9:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106bbf:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106bc2:	b8 30 00 00 00       	mov    $0x30,%eax
80106bc7:	0f 00 d8             	ltr    %ax
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
80106bca:	8b 43 04             	mov    0x4(%ebx),%eax
80106bcd:	85 c0                	test   %eax,%eax
80106bcf:	74 12                	je     80106be3 <switchuvm+0x93>
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106bd1:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bd6:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106bd9:	83 c4 14             	add    $0x14,%esp
80106bdc:	5b                   	pop    %ebx
80106bdd:	5d                   	pop    %ebp
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106bde:	e9 dd d9 ff ff       	jmp    801045c0 <popcli>
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106be3:	c7 04 24 be 79 10 80 	movl   $0x801079be,(%esp)
80106bea:	e8 71 97 ff ff       	call   80100360 <panic>
80106bef:	90                   	nop

80106bf0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
80106bf6:	83 ec 1c             	sub    $0x1c,%esp
80106bf9:	8b 75 10             	mov    0x10(%ebp),%esi
80106bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80106bff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106c02:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106c08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106c0b:	77 54                	ja     80106c61 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
80106c0d:	e8 8e b8 ff ff       	call   801024a0 <kalloc>
  memset(mem, 0, PGSIZE);
80106c12:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c19:	00 
80106c1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c21:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106c22:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c24:	89 04 24             	mov    %eax,(%esp)
80106c27:	e8 34 da ff ff       	call   80104660 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c2c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c32:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c37:	89 04 24             	mov    %eax,(%esp)
80106c3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c3d:	31 d2                	xor    %edx,%edx
80106c3f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106c46:	00 
80106c47:	e8 e4 fb ff ff       	call   80106830 <mappages>
  memmove(mem, init, sz);
80106c4c:	89 75 10             	mov    %esi,0x10(%ebp)
80106c4f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106c52:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106c55:	83 c4 1c             	add    $0x1c,%esp
80106c58:	5b                   	pop    %ebx
80106c59:	5e                   	pop    %esi
80106c5a:	5f                   	pop    %edi
80106c5b:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106c5c:	e9 9f da ff ff       	jmp    80104700 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106c61:	c7 04 24 d2 79 10 80 	movl   $0x801079d2,(%esp)
80106c68:	e8 f3 96 ff ff       	call   80100360 <panic>
80106c6d:	8d 76 00             	lea    0x0(%esi),%esi

80106c70 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	57                   	push   %edi
80106c74:	56                   	push   %esi
80106c75:	53                   	push   %ebx
80106c76:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106c79:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106c80:	0f 85 98 00 00 00    	jne    80106d1e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106c86:	8b 75 18             	mov    0x18(%ebp),%esi
80106c89:	31 db                	xor    %ebx,%ebx
80106c8b:	85 f6                	test   %esi,%esi
80106c8d:	75 1a                	jne    80106ca9 <loaduvm+0x39>
80106c8f:	eb 77                	jmp    80106d08 <loaduvm+0x98>
80106c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c9e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106ca4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106ca7:	76 5f                	jbe    80106d08 <loaduvm+0x98>
80106ca9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106cac:	31 c9                	xor    %ecx,%ecx
80106cae:	8b 45 08             	mov    0x8(%ebp),%eax
80106cb1:	01 da                	add    %ebx,%edx
80106cb3:	e8 e8 fa ff ff       	call   801067a0 <walkpgdir>
80106cb8:	85 c0                	test   %eax,%eax
80106cba:	74 56                	je     80106d12 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106cbc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106cbe:	bf 00 10 00 00       	mov    $0x1000,%edi
80106cc3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106cc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106ccb:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106cd1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cd4:	05 00 00 00 80       	add    $0x80000000,%eax
80106cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cdd:	8b 45 10             	mov    0x10(%ebp),%eax
80106ce0:	01 d9                	add    %ebx,%ecx
80106ce2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106ce6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106cea:	89 04 24             	mov    %eax,(%esp)
80106ced:	e8 5e ac ff ff       	call   80101950 <readi>
80106cf2:	39 f8                	cmp    %edi,%eax
80106cf4:	74 a2                	je     80106c98 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106cf6:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106cfe:	5b                   	pop    %ebx
80106cff:	5e                   	pop    %esi
80106d00:	5f                   	pop    %edi
80106d01:	5d                   	pop    %ebp
80106d02:	c3                   	ret    
80106d03:	90                   	nop
80106d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d08:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106d0b:	31 c0                	xor    %eax,%eax
}
80106d0d:	5b                   	pop    %ebx
80106d0e:	5e                   	pop    %esi
80106d0f:	5f                   	pop    %edi
80106d10:	5d                   	pop    %ebp
80106d11:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106d12:	c7 04 24 ec 79 10 80 	movl   $0x801079ec,(%esp)
80106d19:	e8 42 96 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106d1e:	c7 04 24 90 7a 10 80 	movl   $0x80107a90,(%esp)
80106d25:	e8 36 96 ff ff       	call   80100360 <panic>
80106d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d30 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	57                   	push   %edi
80106d34:	56                   	push   %esi
80106d35:	53                   	push   %ebx
80106d36:	83 ec 1c             	sub    $0x1c,%esp
80106d39:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106d3c:	85 ff                	test   %edi,%edi
80106d3e:	0f 88 7e 00 00 00    	js     80106dc2 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
80106d44:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106d4a:	72 78                	jb     80106dc4 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106d4c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d52:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106d58:	39 df                	cmp    %ebx,%edi
80106d5a:	77 4a                	ja     80106da6 <allocuvm+0x76>
80106d5c:	eb 72                	jmp    80106dd0 <allocuvm+0xa0>
80106d5e:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106d60:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106d67:	00 
80106d68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106d6f:	00 
80106d70:	89 04 24             	mov    %eax,(%esp)
80106d73:	e8 e8 d8 ff ff       	call   80104660 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d78:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d7e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d83:	89 04 24             	mov    %eax,(%esp)
80106d86:	8b 45 08             	mov    0x8(%ebp),%eax
80106d89:	89 da                	mov    %ebx,%edx
80106d8b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106d92:	00 
80106d93:	e8 98 fa ff ff       	call   80106830 <mappages>
80106d98:	85 c0                	test   %eax,%eax
80106d9a:	78 44                	js     80106de0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106d9c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106da2:	39 df                	cmp    %ebx,%edi
80106da4:	76 2a                	jbe    80106dd0 <allocuvm+0xa0>
    mem = kalloc();
80106da6:	e8 f5 b6 ff ff       	call   801024a0 <kalloc>
    if(mem == 0){
80106dab:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106dad:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106daf:	75 af                	jne    80106d60 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106db1:	c7 04 24 0a 7a 10 80 	movl   $0x80107a0a,(%esp)
80106db8:	e8 93 98 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106dbd:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106dc0:	77 48                	ja     80106e0a <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106dc2:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106dc4:	83 c4 1c             	add    $0x1c,%esp
80106dc7:	5b                   	pop    %ebx
80106dc8:	5e                   	pop    %esi
80106dc9:	5f                   	pop    %edi
80106dca:	5d                   	pop    %ebp
80106dcb:	c3                   	ret    
80106dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106dd0:	83 c4 1c             	add    $0x1c,%esp
80106dd3:	89 f8                	mov    %edi,%eax
80106dd5:	5b                   	pop    %ebx
80106dd6:	5e                   	pop    %esi
80106dd7:	5f                   	pop    %edi
80106dd8:	5d                   	pop    %ebp
80106dd9:	c3                   	ret    
80106dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106de0:	c7 04 24 22 7a 10 80 	movl   $0x80107a22,(%esp)
80106de7:	e8 64 98 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106dec:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106def:	76 0d                	jbe    80106dfe <allocuvm+0xce>
80106df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106df4:	89 fa                	mov    %edi,%edx
80106df6:	8b 45 08             	mov    0x8(%ebp),%eax
80106df9:	e8 b2 fa ff ff       	call   801068b0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106dfe:	89 34 24             	mov    %esi,(%esp)
80106e01:	e8 ea b4 ff ff       	call   801022f0 <kfree>
      return 0;
80106e06:	31 c0                	xor    %eax,%eax
80106e08:	eb ba                	jmp    80106dc4 <allocuvm+0x94>
80106e0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e0d:	89 fa                	mov    %edi,%edx
80106e0f:	8b 45 08             	mov    0x8(%ebp),%eax
80106e12:	e8 99 fa ff ff       	call   801068b0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106e17:	31 c0                	xor    %eax,%eax
80106e19:	eb a9                	jmp    80106dc4 <allocuvm+0x94>
80106e1b:	90                   	nop
80106e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e20 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e26:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e29:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106e2c:	39 d1                	cmp    %edx,%ecx
80106e2e:	73 08                	jae    80106e38 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106e30:	5d                   	pop    %ebp
80106e31:	e9 7a fa ff ff       	jmp    801068b0 <deallocuvm.part.0>
80106e36:	66 90                	xchg   %ax,%ax
80106e38:	89 d0                	mov    %edx,%eax
80106e3a:	5d                   	pop    %ebp
80106e3b:	c3                   	ret    
80106e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	56                   	push   %esi
80106e44:	53                   	push   %ebx
80106e45:	83 ec 10             	sub    $0x10,%esp
80106e48:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e4b:	85 f6                	test   %esi,%esi
80106e4d:	74 59                	je     80106ea8 <freevm+0x68>
80106e4f:	31 c9                	xor    %ecx,%ecx
80106e51:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e56:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e58:	31 db                	xor    %ebx,%ebx
80106e5a:	e8 51 fa ff ff       	call   801068b0 <deallocuvm.part.0>
80106e5f:	eb 12                	jmp    80106e73 <freevm+0x33>
80106e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e68:	83 c3 01             	add    $0x1,%ebx
80106e6b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106e71:	74 27                	je     80106e9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e73:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106e76:	f6 c2 01             	test   $0x1,%dl
80106e79:	74 ed                	je     80106e68 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e7b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e81:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e84:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106e8a:	89 14 24             	mov    %edx,(%esp)
80106e8d:	e8 5e b4 ff ff       	call   801022f0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e92:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106e98:	75 d9                	jne    80106e73 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106e9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e9d:	83 c4 10             	add    $0x10,%esp
80106ea0:	5b                   	pop    %ebx
80106ea1:	5e                   	pop    %esi
80106ea2:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106ea3:	e9 48 b4 ff ff       	jmp    801022f0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106ea8:	c7 04 24 3e 7a 10 80 	movl   $0x80107a3e,(%esp)
80106eaf:	e8 ac 94 ff ff       	call   80100360 <panic>
80106eb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ec0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ec0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ec1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ec3:	89 e5                	mov    %esp,%ebp
80106ec5:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ec8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ece:	e8 cd f8 ff ff       	call   801067a0 <walkpgdir>
  if(pte == 0)
80106ed3:	85 c0                	test   %eax,%eax
80106ed5:	74 05                	je     80106edc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ed7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106eda:	c9                   	leave  
80106edb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106edc:	c7 04 24 4f 7a 10 80 	movl   $0x80107a4f,(%esp)
80106ee3:	e8 78 94 ff ff       	call   80100360 <panic>
80106ee8:	90                   	nop
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ef0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
80106ef6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106ef9:	e8 92 fb ff ff       	call   80106a90 <setupkvm>
80106efe:	85 c0                	test   %eax,%eax
80106f00:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f03:	0f 84 b2 00 00 00    	je     80106fbb <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f09:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f0c:	85 c0                	test   %eax,%eax
80106f0e:	0f 84 9c 00 00 00    	je     80106fb0 <copyuvm+0xc0>
80106f14:	31 db                	xor    %ebx,%ebx
80106f16:	eb 48                	jmp    80106f60 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106f18:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106f1e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106f25:	00 
80106f26:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106f2a:	89 04 24             	mov    %eax,(%esp)
80106f2d:	e8 ce d7 ff ff       	call   80104700 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106f32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f35:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106f3b:	89 14 24             	mov    %edx,(%esp)
80106f3e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f43:	89 da                	mov    %ebx,%edx
80106f45:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f4c:	e8 df f8 ff ff       	call   80106830 <mappages>
80106f51:	85 c0                	test   %eax,%eax
80106f53:	78 41                	js     80106f96 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f55:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f5b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106f5e:	76 50                	jbe    80106fb0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f60:	8b 45 08             	mov    0x8(%ebp),%eax
80106f63:	31 c9                	xor    %ecx,%ecx
80106f65:	89 da                	mov    %ebx,%edx
80106f67:	e8 34 f8 ff ff       	call   801067a0 <walkpgdir>
80106f6c:	85 c0                	test   %eax,%eax
80106f6e:	74 5b                	je     80106fcb <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106f70:	8b 30                	mov    (%eax),%esi
80106f72:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106f78:	74 45                	je     80106fbf <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106f7a:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106f7c:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106f82:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106f85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106f8b:	e8 10 b5 ff ff       	call   801024a0 <kalloc>
80106f90:	85 c0                	test   %eax,%eax
80106f92:	89 c6                	mov    %eax,%esi
80106f94:	75 82                	jne    80106f18 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f99:	89 04 24             	mov    %eax,(%esp)
80106f9c:	e8 9f fe ff ff       	call   80106e40 <freevm>
  return 0;
80106fa1:	31 c0                	xor    %eax,%eax
}
80106fa3:	83 c4 2c             	add    $0x2c,%esp
80106fa6:	5b                   	pop    %ebx
80106fa7:	5e                   	pop    %esi
80106fa8:	5f                   	pop    %edi
80106fa9:	5d                   	pop    %ebp
80106faa:	c3                   	ret    
80106fab:	90                   	nop
80106fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fb3:	83 c4 2c             	add    $0x2c,%esp
80106fb6:	5b                   	pop    %ebx
80106fb7:	5e                   	pop    %esi
80106fb8:	5f                   	pop    %edi
80106fb9:	5d                   	pop    %ebp
80106fba:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106fbb:	31 c0                	xor    %eax,%eax
80106fbd:	eb e4                	jmp    80106fa3 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106fbf:	c7 04 24 73 7a 10 80 	movl   $0x80107a73,(%esp)
80106fc6:	e8 95 93 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106fcb:	c7 04 24 59 7a 10 80 	movl   $0x80107a59,(%esp)
80106fd2:	e8 89 93 ff ff       	call   80100360 <panic>
80106fd7:	89 f6                	mov    %esi,%esi
80106fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fe0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106fe0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106fe1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106fe3:	89 e5                	mov    %esp,%ebp
80106fe5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106feb:	8b 45 08             	mov    0x8(%ebp),%eax
80106fee:	e8 ad f7 ff ff       	call   801067a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106ff3:	8b 00                	mov    (%eax),%eax
80106ff5:	89 c2                	mov    %eax,%edx
80106ff7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106ffa:	83 fa 05             	cmp    $0x5,%edx
80106ffd:	75 11                	jne    80107010 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106fff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107004:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107009:	c9                   	leave  
8010700a:	c3                   	ret    
8010700b:	90                   	nop
8010700c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107010:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107012:	c9                   	leave  
80107013:	c3                   	ret    
80107014:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010701a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107020 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	57                   	push   %edi
80107024:	56                   	push   %esi
80107025:	53                   	push   %ebx
80107026:	83 ec 1c             	sub    $0x1c,%esp
80107029:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010702c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010702f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107032:	85 db                	test   %ebx,%ebx
80107034:	75 3a                	jne    80107070 <copyout+0x50>
80107036:	eb 68                	jmp    801070a0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107038:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010703b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010703d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107041:	29 ca                	sub    %ecx,%edx
80107043:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107049:	39 da                	cmp    %ebx,%edx
8010704b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010704e:	29 f1                	sub    %esi,%ecx
80107050:	01 c8                	add    %ecx,%eax
80107052:	89 54 24 08          	mov    %edx,0x8(%esp)
80107056:	89 04 24             	mov    %eax,(%esp)
80107059:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010705c:	e8 9f d6 ff ff       	call   80104700 <memmove>
    len -= n;
    buf += n;
80107061:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80107064:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
8010706a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010706c:	29 d3                	sub    %edx,%ebx
8010706e:	74 30                	je     801070a0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80107070:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107073:	89 ce                	mov    %ecx,%esi
80107075:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010707b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010707f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107082:	89 04 24             	mov    %eax,(%esp)
80107085:	e8 56 ff ff ff       	call   80106fe0 <uva2ka>
    if(pa0 == 0)
8010708a:	85 c0                	test   %eax,%eax
8010708c:	75 aa                	jne    80107038 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010708e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107096:	5b                   	pop    %ebx
80107097:	5e                   	pop    %esi
80107098:	5f                   	pop    %edi
80107099:	5d                   	pop    %ebp
8010709a:	c3                   	ret    
8010709b:	90                   	nop
8010709c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070a0:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801070a3:	31 c0                	xor    %eax,%eax
}
801070a5:	5b                   	pop    %ebx
801070a6:	5e                   	pop    %esi
801070a7:	5f                   	pop    %edi
801070a8:	5d                   	pop    %ebp
801070a9:	c3                   	ret    
