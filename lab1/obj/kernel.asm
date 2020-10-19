
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	53                   	push   %ebx
  100004:	83 ec 14             	sub    $0x14,%esp
  100007:	e8 74 02 00 00       	call   100280 <__x86.get_pc_thunk.bx>
  10000c:	81 c3 44 e9 00 00    	add    $0xe944,%ebx
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100012:	c7 c0 c0 fd 10 00    	mov    $0x10fdc0,%eax
  100018:	89 c2                	mov    %eax,%edx
  10001a:	c7 c0 50 e9 10 00    	mov    $0x10e950,%eax
  100020:	29 c2                	sub    %eax,%edx
  100022:	89 d0                	mov    %edx,%eax
  100024:	83 ec 04             	sub    $0x4,%esp
  100027:	50                   	push   %eax
  100028:	6a 00                	push   $0x0
  10002a:	c7 c0 50 e9 10 00    	mov    $0x10e950,%eax
  100030:	50                   	push   %eax
  100031:	e8 12 31 00 00       	call   103148 <memset>
  100036:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100039:	e8 1e 18 00 00       	call   10185c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10003e:	8d 83 24 50 ff ff    	lea    -0xafdc(%ebx),%eax
  100044:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100047:	83 ec 08             	sub    $0x8,%esp
  10004a:	ff 75 f4             	pushl  -0xc(%ebp)
  10004d:	8d 83 40 50 ff ff    	lea    -0xafc0(%ebx),%eax
  100053:	50                   	push   %eax
  100054:	e8 9a 02 00 00       	call   1002f3 <cprintf>
  100059:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  10005c:	e8 ba 09 00 00       	call   100a1b <print_kerninfo>

    grade_backtrace();
  100061:	e8 98 00 00 00       	call   1000fe <grade_backtrace>

    pmm_init();                 // init physical memory management
  100066:	e8 3d 2d 00 00       	call   102da8 <pmm_init>

    pic_init();                 // init interrupt controller
  10006b:	e8 7b 19 00 00       	call   1019eb <pic_init>
    idt_init();                 // init interrupt descriptor table
  100070:	e8 0d 1b 00 00       	call   101b82 <idt_init>

    clock_init();               // init clock interrupt
  100075:	e8 de 0e 00 00       	call   100f58 <clock_init>
    intr_enable();              // enable irq interrupt
  10007a:	e8 b4 1a 00 00       	call   101b33 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10007f:	eb fe                	jmp    10007f <kern_init+0x7f>

00100081 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100081:	55                   	push   %ebp
  100082:	89 e5                	mov    %esp,%ebp
  100084:	53                   	push   %ebx
  100085:	83 ec 04             	sub    $0x4,%esp
  100088:	e8 ef 01 00 00       	call   10027c <__x86.get_pc_thunk.ax>
  10008d:	05 c3 e8 00 00       	add    $0xe8c3,%eax
    mon_backtrace(0, NULL, NULL);
  100092:	83 ec 04             	sub    $0x4,%esp
  100095:	6a 00                	push   $0x0
  100097:	6a 00                	push   $0x0
  100099:	6a 00                	push   $0x0
  10009b:	89 c3                	mov    %eax,%ebx
  10009d:	e8 93 0e 00 00       	call   100f35 <mon_backtrace>
  1000a2:	83 c4 10             	add    $0x10,%esp
}
  1000a5:	90                   	nop
  1000a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000a9:	c9                   	leave  
  1000aa:	c3                   	ret    

001000ab <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000ab:	55                   	push   %ebp
  1000ac:	89 e5                	mov    %esp,%ebp
  1000ae:	53                   	push   %ebx
  1000af:	83 ec 04             	sub    $0x4,%esp
  1000b2:	e8 c5 01 00 00       	call   10027c <__x86.get_pc_thunk.ax>
  1000b7:	05 99 e8 00 00       	add    $0xe899,%eax
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000bc:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000c2:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000c8:	51                   	push   %ecx
  1000c9:	52                   	push   %edx
  1000ca:	53                   	push   %ebx
  1000cb:	50                   	push   %eax
  1000cc:	e8 b0 ff ff ff       	call   100081 <grade_backtrace2>
  1000d1:	83 c4 10             	add    $0x10,%esp
}
  1000d4:	90                   	nop
  1000d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000d8:	c9                   	leave  
  1000d9:	c3                   	ret    

001000da <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000da:	55                   	push   %ebp
  1000db:	89 e5                	mov    %esp,%ebp
  1000dd:	83 ec 08             	sub    $0x8,%esp
  1000e0:	e8 97 01 00 00       	call   10027c <__x86.get_pc_thunk.ax>
  1000e5:	05 6b e8 00 00       	add    $0xe86b,%eax
    grade_backtrace1(arg0, arg2);
  1000ea:	83 ec 08             	sub    $0x8,%esp
  1000ed:	ff 75 10             	pushl  0x10(%ebp)
  1000f0:	ff 75 08             	pushl  0x8(%ebp)
  1000f3:	e8 b3 ff ff ff       	call   1000ab <grade_backtrace1>
  1000f8:	83 c4 10             	add    $0x10,%esp
}
  1000fb:	90                   	nop
  1000fc:	c9                   	leave  
  1000fd:	c3                   	ret    

001000fe <grade_backtrace>:

void
grade_backtrace(void) {
  1000fe:	55                   	push   %ebp
  1000ff:	89 e5                	mov    %esp,%ebp
  100101:	83 ec 08             	sub    $0x8,%esp
  100104:	e8 73 01 00 00       	call   10027c <__x86.get_pc_thunk.ax>
  100109:	05 47 e8 00 00       	add    $0xe847,%eax
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010e:	8d 80 b0 16 ff ff    	lea    -0xe950(%eax),%eax
  100114:	83 ec 04             	sub    $0x4,%esp
  100117:	68 00 00 ff ff       	push   $0xffff0000
  10011c:	50                   	push   %eax
  10011d:	6a 00                	push   $0x0
  10011f:	e8 b6 ff ff ff       	call   1000da <grade_backtrace0>
  100124:	83 c4 10             	add    $0x10,%esp
}
  100127:	90                   	nop
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	53                   	push   %ebx
  10012e:	83 ec 14             	sub    $0x14,%esp
  100131:	e8 4a 01 00 00       	call   100280 <__x86.get_pc_thunk.bx>
  100136:	81 c3 1a e8 00 00    	add    $0xe81a,%ebx
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10014c:	0f b7 c0             	movzwl %ax,%eax
  10014f:	83 e0 03             	and    $0x3,%eax
  100152:	89 c2                	mov    %eax,%edx
  100154:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  10015a:	83 ec 04             	sub    $0x4,%esp
  10015d:	52                   	push   %edx
  10015e:	50                   	push   %eax
  10015f:	8d 83 45 50 ff ff    	lea    -0xafbb(%ebx),%eax
  100165:	50                   	push   %eax
  100166:	e8 88 01 00 00       	call   1002f3 <cprintf>
  10016b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10016e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100172:	0f b7 d0             	movzwl %ax,%edx
  100175:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  10017b:	83 ec 04             	sub    $0x4,%esp
  10017e:	52                   	push   %edx
  10017f:	50                   	push   %eax
  100180:	8d 83 53 50 ff ff    	lea    -0xafad(%ebx),%eax
  100186:	50                   	push   %eax
  100187:	e8 67 01 00 00       	call   1002f3 <cprintf>
  10018c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  10018f:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100193:	0f b7 d0             	movzwl %ax,%edx
  100196:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  10019c:	83 ec 04             	sub    $0x4,%esp
  10019f:	52                   	push   %edx
  1001a0:	50                   	push   %eax
  1001a1:	8d 83 61 50 ff ff    	lea    -0xaf9f(%ebx),%eax
  1001a7:	50                   	push   %eax
  1001a8:	e8 46 01 00 00       	call   1002f3 <cprintf>
  1001ad:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  1001b0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b4:	0f b7 d0             	movzwl %ax,%edx
  1001b7:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  1001bd:	83 ec 04             	sub    $0x4,%esp
  1001c0:	52                   	push   %edx
  1001c1:	50                   	push   %eax
  1001c2:	8d 83 6f 50 ff ff    	lea    -0xaf91(%ebx),%eax
  1001c8:	50                   	push   %eax
  1001c9:	e8 25 01 00 00       	call   1002f3 <cprintf>
  1001ce:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d5:	0f b7 d0             	movzwl %ax,%edx
  1001d8:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  1001de:	83 ec 04             	sub    $0x4,%esp
  1001e1:	52                   	push   %edx
  1001e2:	50                   	push   %eax
  1001e3:	8d 83 7d 50 ff ff    	lea    -0xaf83(%ebx),%eax
  1001e9:	50                   	push   %eax
  1001ea:	e8 04 01 00 00       	call   1002f3 <cprintf>
  1001ef:	83 c4 10             	add    $0x10,%esp
    round ++;
  1001f2:	8b 83 70 01 00 00    	mov    0x170(%ebx),%eax
  1001f8:	83 c0 01             	add    $0x1,%eax
  1001fb:	89 83 70 01 00 00    	mov    %eax,0x170(%ebx)
}
  100201:	90                   	nop
  100202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100205:	c9                   	leave  
  100206:	c3                   	ret    

00100207 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  100207:	55                   	push   %ebp
  100208:	89 e5                	mov    %esp,%ebp
  10020a:	e8 6d 00 00 00       	call   10027c <__x86.get_pc_thunk.ax>
  10020f:	05 41 e7 00 00       	add    $0xe741,%eax
    //LAB1 CHALLENGE 1 : TODO
}
  100214:	90                   	nop
  100215:	5d                   	pop    %ebp
  100216:	c3                   	ret    

00100217 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100217:	55                   	push   %ebp
  100218:	89 e5                	mov    %esp,%ebp
  10021a:	e8 5d 00 00 00       	call   10027c <__x86.get_pc_thunk.ax>
  10021f:	05 31 e7 00 00       	add    $0xe731,%eax
    //LAB1 CHALLENGE 1 :  TODO
}
  100224:	90                   	nop
  100225:	5d                   	pop    %ebp
  100226:	c3                   	ret    

00100227 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100227:	55                   	push   %ebp
  100228:	89 e5                	mov    %esp,%ebp
  10022a:	53                   	push   %ebx
  10022b:	83 ec 04             	sub    $0x4,%esp
  10022e:	e8 4d 00 00 00       	call   100280 <__x86.get_pc_thunk.bx>
  100233:	81 c3 1d e7 00 00    	add    $0xe71d,%ebx
    lab1_print_cur_status();
  100239:	e8 ec fe ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10023e:	83 ec 0c             	sub    $0xc,%esp
  100241:	8d 83 8c 50 ff ff    	lea    -0xaf74(%ebx),%eax
  100247:	50                   	push   %eax
  100248:	e8 a6 00 00 00       	call   1002f3 <cprintf>
  10024d:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  100250:	e8 b2 ff ff ff       	call   100207 <lab1_switch_to_user>
    lab1_print_cur_status();
  100255:	e8 d0 fe ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10025a:	83 ec 0c             	sub    $0xc,%esp
  10025d:	8d 83 ac 50 ff ff    	lea    -0xaf54(%ebx),%eax
  100263:	50                   	push   %eax
  100264:	e8 8a 00 00 00       	call   1002f3 <cprintf>
  100269:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  10026c:	e8 a6 ff ff ff       	call   100217 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100271:	e8 b4 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100276:	90                   	nop
  100277:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10027a:	c9                   	leave  
  10027b:	c3                   	ret    

0010027c <__x86.get_pc_thunk.ax>:
  10027c:	8b 04 24             	mov    (%esp),%eax
  10027f:	c3                   	ret    

00100280 <__x86.get_pc_thunk.bx>:
  100280:	8b 1c 24             	mov    (%esp),%ebx
  100283:	c3                   	ret    

00100284 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100284:	55                   	push   %ebp
  100285:	89 e5                	mov    %esp,%ebp
  100287:	53                   	push   %ebx
  100288:	83 ec 04             	sub    $0x4,%esp
  10028b:	e8 ec ff ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100290:	05 c0 e6 00 00       	add    $0xe6c0,%eax
    cons_putc(c);
  100295:	83 ec 0c             	sub    $0xc,%esp
  100298:	ff 75 08             	pushl  0x8(%ebp)
  10029b:	89 c3                	mov    %eax,%ebx
  10029d:	e8 fd 15 00 00       	call   10189f <cons_putc>
  1002a2:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  1002a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002a8:	8b 00                	mov    (%eax),%eax
  1002aa:	8d 50 01             	lea    0x1(%eax),%edx
  1002ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002b0:	89 10                	mov    %edx,(%eax)
}
  1002b2:	90                   	nop
  1002b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1002b6:	c9                   	leave  
  1002b7:	c3                   	ret    

001002b8 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002b8:	55                   	push   %ebp
  1002b9:	89 e5                	mov    %esp,%ebp
  1002bb:	53                   	push   %ebx
  1002bc:	83 ec 14             	sub    $0x14,%esp
  1002bf:	e8 b8 ff ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1002c4:	05 8c e6 00 00       	add    $0xe68c,%eax
    int cnt = 0;
  1002c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002d0:	ff 75 0c             	pushl  0xc(%ebp)
  1002d3:	ff 75 08             	pushl  0x8(%ebp)
  1002d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1002d9:	52                   	push   %edx
  1002da:	8d 90 34 19 ff ff    	lea    -0xe6cc(%eax),%edx
  1002e0:	52                   	push   %edx
  1002e1:	89 c3                	mov    %eax,%ebx
  1002e3:	e8 ee 31 00 00       	call   1034d6 <vprintfmt>
  1002e8:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1002f1:	c9                   	leave  
  1002f2:	c3                   	ret    

001002f3 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002f3:	55                   	push   %ebp
  1002f4:	89 e5                	mov    %esp,%ebp
  1002f6:	83 ec 18             	sub    $0x18,%esp
  1002f9:	e8 7e ff ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1002fe:	05 52 e6 00 00       	add    $0xe652,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100303:	8d 45 0c             	lea    0xc(%ebp),%eax
  100306:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10030c:	83 ec 08             	sub    $0x8,%esp
  10030f:	50                   	push   %eax
  100310:	ff 75 08             	pushl  0x8(%ebp)
  100313:	e8 a0 ff ff ff       	call   1002b8 <vcprintf>
  100318:	83 c4 10             	add    $0x10,%esp
  10031b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10031e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100321:	c9                   	leave  
  100322:	c3                   	ret    

00100323 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100323:	55                   	push   %ebp
  100324:	89 e5                	mov    %esp,%ebp
  100326:	53                   	push   %ebx
  100327:	83 ec 04             	sub    $0x4,%esp
  10032a:	e8 4d ff ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10032f:	05 21 e6 00 00       	add    $0xe621,%eax
    cons_putc(c);
  100334:	83 ec 0c             	sub    $0xc,%esp
  100337:	ff 75 08             	pushl  0x8(%ebp)
  10033a:	89 c3                	mov    %eax,%ebx
  10033c:	e8 5e 15 00 00       	call   10189f <cons_putc>
  100341:	83 c4 10             	add    $0x10,%esp
}
  100344:	90                   	nop
  100345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100348:	c9                   	leave  
  100349:	c3                   	ret    

0010034a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034a:	55                   	push   %ebp
  10034b:	89 e5                	mov    %esp,%ebp
  10034d:	83 ec 18             	sub    $0x18,%esp
  100350:	e8 27 ff ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100355:	05 fb e5 00 00       	add    $0xe5fb,%eax
    int cnt = 0;
  10035a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100361:	eb 14                	jmp    100377 <cputs+0x2d>
        cputch(c, &cnt);
  100363:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100367:	83 ec 08             	sub    $0x8,%esp
  10036a:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10036d:	52                   	push   %edx
  10036e:	50                   	push   %eax
  10036f:	e8 10 ff ff ff       	call   100284 <cputch>
  100374:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  100377:	8b 45 08             	mov    0x8(%ebp),%eax
  10037a:	8d 50 01             	lea    0x1(%eax),%edx
  10037d:	89 55 08             	mov    %edx,0x8(%ebp)
  100380:	0f b6 00             	movzbl (%eax),%eax
  100383:	88 45 f7             	mov    %al,-0x9(%ebp)
  100386:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10038a:	75 d7                	jne    100363 <cputs+0x19>
    }
    cputch('\n', &cnt);
  10038c:	83 ec 08             	sub    $0x8,%esp
  10038f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100392:	50                   	push   %eax
  100393:	6a 0a                	push   $0xa
  100395:	e8 ea fe ff ff       	call   100284 <cputch>
  10039a:	83 c4 10             	add    $0x10,%esp
    return cnt;
  10039d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003a0:	c9                   	leave  
  1003a1:	c3                   	ret    

001003a2 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003a2:	55                   	push   %ebp
  1003a3:	89 e5                	mov    %esp,%ebp
  1003a5:	53                   	push   %ebx
  1003a6:	83 ec 14             	sub    $0x14,%esp
  1003a9:	e8 d2 fe ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  1003ae:	81 c3 a2 e5 00 00    	add    $0xe5a2,%ebx
    int c;
    while ((c = cons_getc()) == 0)
  1003b4:	e8 20 15 00 00       	call   1018d9 <cons_getc>
  1003b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003c0:	74 f2                	je     1003b4 <getchar+0x12>
        /* do nothing */;
    return c;
  1003c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003c5:	83 c4 14             	add    $0x14,%esp
  1003c8:	5b                   	pop    %ebx
  1003c9:	5d                   	pop    %ebp
  1003ca:	c3                   	ret    

001003cb <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1003cb:	55                   	push   %ebp
  1003cc:	89 e5                	mov    %esp,%ebp
  1003ce:	53                   	push   %ebx
  1003cf:	83 ec 14             	sub    $0x14,%esp
  1003d2:	e8 a9 fe ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  1003d7:	81 c3 79 e5 00 00    	add    $0xe579,%ebx
    if (prompt != NULL) {
  1003dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1003e1:	74 15                	je     1003f8 <readline+0x2d>
        cprintf("%s", prompt);
  1003e3:	83 ec 08             	sub    $0x8,%esp
  1003e6:	ff 75 08             	pushl  0x8(%ebp)
  1003e9:	8d 83 cb 50 ff ff    	lea    -0xaf35(%ebx),%eax
  1003ef:	50                   	push   %eax
  1003f0:	e8 fe fe ff ff       	call   1002f3 <cprintf>
  1003f5:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  1003f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  1003ff:	e8 9e ff ff ff       	call   1003a2 <getchar>
  100404:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100407:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10040b:	79 0a                	jns    100417 <readline+0x4c>
            return NULL;
  10040d:	b8 00 00 00 00       	mov    $0x0,%eax
  100412:	e9 87 00 00 00       	jmp    10049e <readline+0xd3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100417:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10041b:	7e 2c                	jle    100449 <readline+0x7e>
  10041d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100424:	7f 23                	jg     100449 <readline+0x7e>
            cputchar(c);
  100426:	83 ec 0c             	sub    $0xc,%esp
  100429:	ff 75 f0             	pushl  -0x10(%ebp)
  10042c:	e8 f2 fe ff ff       	call   100323 <cputchar>
  100431:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100437:	8d 50 01             	lea    0x1(%eax),%edx
  10043a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10043d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100440:	88 94 03 90 01 00 00 	mov    %dl,0x190(%ebx,%eax,1)
  100447:	eb 50                	jmp    100499 <readline+0xce>
        }
        else if (c == '\b' && i > 0) {
  100449:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10044d:	75 1a                	jne    100469 <readline+0x9e>
  10044f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100453:	7e 14                	jle    100469 <readline+0x9e>
            cputchar(c);
  100455:	83 ec 0c             	sub    $0xc,%esp
  100458:	ff 75 f0             	pushl  -0x10(%ebp)
  10045b:	e8 c3 fe ff ff       	call   100323 <cputchar>
  100460:	83 c4 10             	add    $0x10,%esp
            i --;
  100463:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100467:	eb 30                	jmp    100499 <readline+0xce>
        }
        else if (c == '\n' || c == '\r') {
  100469:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10046d:	74 06                	je     100475 <readline+0xaa>
  10046f:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100473:	75 8a                	jne    1003ff <readline+0x34>
            cputchar(c);
  100475:	83 ec 0c             	sub    $0xc,%esp
  100478:	ff 75 f0             	pushl  -0x10(%ebp)
  10047b:	e8 a3 fe ff ff       	call   100323 <cputchar>
  100480:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  100483:	8d 93 90 01 00 00    	lea    0x190(%ebx),%edx
  100489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10048c:	01 d0                	add    %edx,%eax
  10048e:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100491:	8d 83 90 01 00 00    	lea    0x190(%ebx),%eax
  100497:	eb 05                	jmp    10049e <readline+0xd3>
        c = getchar();
  100499:	e9 61 ff ff ff       	jmp    1003ff <readline+0x34>
        }
    }
}
  10049e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1004a1:	c9                   	leave  
  1004a2:	c3                   	ret    

001004a3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1004a3:	55                   	push   %ebp
  1004a4:	89 e5                	mov    %esp,%ebp
  1004a6:	53                   	push   %ebx
  1004a7:	83 ec 14             	sub    $0x14,%esp
  1004aa:	e8 d1 fd ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  1004af:	81 c3 a1 e4 00 00    	add    $0xe4a1,%ebx
    if (is_panic) {
  1004b5:	8b 83 90 05 00 00    	mov    0x590(%ebx),%eax
  1004bb:	85 c0                	test   %eax,%eax
  1004bd:	75 4e                	jne    10050d <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1004bf:	c7 83 90 05 00 00 01 	movl   $0x1,0x590(%ebx)
  1004c6:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1004c9:	8d 45 14             	lea    0x14(%ebp),%eax
  1004cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1004cf:	83 ec 04             	sub    $0x4,%esp
  1004d2:	ff 75 0c             	pushl  0xc(%ebp)
  1004d5:	ff 75 08             	pushl  0x8(%ebp)
  1004d8:	8d 83 ce 50 ff ff    	lea    -0xaf32(%ebx),%eax
  1004de:	50                   	push   %eax
  1004df:	e8 0f fe ff ff       	call   1002f3 <cprintf>
  1004e4:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004ea:	83 ec 08             	sub    $0x8,%esp
  1004ed:	50                   	push   %eax
  1004ee:	ff 75 10             	pushl  0x10(%ebp)
  1004f1:	e8 c2 fd ff ff       	call   1002b8 <vcprintf>
  1004f6:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1004f9:	83 ec 0c             	sub    $0xc,%esp
  1004fc:	8d 83 ea 50 ff ff    	lea    -0xaf16(%ebx),%eax
  100502:	50                   	push   %eax
  100503:	e8 eb fd ff ff       	call   1002f3 <cprintf>
  100508:	83 c4 10             	add    $0x10,%esp
  10050b:	eb 01                	jmp    10050e <__panic+0x6b>
        goto panic_dead;
  10050d:	90                   	nop
    va_end(ap);

panic_dead:
    intr_disable();
  10050e:	e8 31 16 00 00       	call   101b44 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100513:	83 ec 0c             	sub    $0xc,%esp
  100516:	6a 00                	push   $0x0
  100518:	e8 fe 08 00 00       	call   100e1b <kmonitor>
  10051d:	83 c4 10             	add    $0x10,%esp
  100520:	eb f1                	jmp    100513 <__panic+0x70>

00100522 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100522:	55                   	push   %ebp
  100523:	89 e5                	mov    %esp,%ebp
  100525:	53                   	push   %ebx
  100526:	83 ec 14             	sub    $0x14,%esp
  100529:	e8 52 fd ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  10052e:	81 c3 22 e4 00 00    	add    $0xe422,%ebx
    va_list ap;
    va_start(ap, fmt);
  100534:	8d 45 14             	lea    0x14(%ebp),%eax
  100537:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10053a:	83 ec 04             	sub    $0x4,%esp
  10053d:	ff 75 0c             	pushl  0xc(%ebp)
  100540:	ff 75 08             	pushl  0x8(%ebp)
  100543:	8d 83 ec 50 ff ff    	lea    -0xaf14(%ebx),%eax
  100549:	50                   	push   %eax
  10054a:	e8 a4 fd ff ff       	call   1002f3 <cprintf>
  10054f:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100555:	83 ec 08             	sub    $0x8,%esp
  100558:	50                   	push   %eax
  100559:	ff 75 10             	pushl  0x10(%ebp)
  10055c:	e8 57 fd ff ff       	call   1002b8 <vcprintf>
  100561:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100564:	83 ec 0c             	sub    $0xc,%esp
  100567:	8d 83 ea 50 ff ff    	lea    -0xaf16(%ebx),%eax
  10056d:	50                   	push   %eax
  10056e:	e8 80 fd ff ff       	call   1002f3 <cprintf>
  100573:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100576:	90                   	nop
  100577:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10057a:	c9                   	leave  
  10057b:	c3                   	ret    

0010057c <is_kernel_panic>:

bool
is_kernel_panic(void) {
  10057c:	55                   	push   %ebp
  10057d:	89 e5                	mov    %esp,%ebp
  10057f:	e8 f8 fc ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100584:	05 cc e3 00 00       	add    $0xe3cc,%eax
    return is_panic;
  100589:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
}
  10058f:	5d                   	pop    %ebp
  100590:	c3                   	ret    

00100591 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100591:	55                   	push   %ebp
  100592:	89 e5                	mov    %esp,%ebp
  100594:	83 ec 20             	sub    $0x20,%esp
  100597:	e8 e0 fc ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10059c:	05 b4 e3 00 00       	add    $0xe3b4,%eax
    int l = *region_left, r = *region_right, any_matches = 0;
  1005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a4:	8b 00                	mov    (%eax),%eax
  1005a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ac:	8b 00                	mov    (%eax),%eax
  1005ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1005b8:	e9 d2 00 00 00       	jmp    10068f <stab_binsearch+0xfe>
        int true_m = (l + r) / 2, m = true_m;
  1005bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1005c3:	01 d0                	add    %edx,%eax
  1005c5:	89 c2                	mov    %eax,%edx
  1005c7:	c1 ea 1f             	shr    $0x1f,%edx
  1005ca:	01 d0                	add    %edx,%eax
  1005cc:	d1 f8                	sar    %eax
  1005ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1005d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005d4:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1005d7:	eb 04                	jmp    1005dd <stab_binsearch+0x4c>
            m --;
  1005d9:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005e3:	7c 1f                	jl     100604 <stab_binsearch+0x73>
  1005e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005e8:	89 d0                	mov    %edx,%eax
  1005ea:	01 c0                	add    %eax,%eax
  1005ec:	01 d0                	add    %edx,%eax
  1005ee:	c1 e0 02             	shl    $0x2,%eax
  1005f1:	89 c2                	mov    %eax,%edx
  1005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f6:	01 d0                	add    %edx,%eax
  1005f8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005fc:	0f b6 c0             	movzbl %al,%eax
  1005ff:	39 45 14             	cmp    %eax,0x14(%ebp)
  100602:	75 d5                	jne    1005d9 <stab_binsearch+0x48>
        }
        if (m < l) {    // no match in [l, m]
  100604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100607:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10060a:	7d 0b                	jge    100617 <stab_binsearch+0x86>
            l = true_m + 1;
  10060c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10060f:	83 c0 01             	add    $0x1,%eax
  100612:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100615:	eb 78                	jmp    10068f <stab_binsearch+0xfe>
        }

        // actual binary search
        any_matches = 1;
  100617:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10061e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100621:	89 d0                	mov    %edx,%eax
  100623:	01 c0                	add    %eax,%eax
  100625:	01 d0                	add    %edx,%eax
  100627:	c1 e0 02             	shl    $0x2,%eax
  10062a:	89 c2                	mov    %eax,%edx
  10062c:	8b 45 08             	mov    0x8(%ebp),%eax
  10062f:	01 d0                	add    %edx,%eax
  100631:	8b 40 08             	mov    0x8(%eax),%eax
  100634:	39 45 18             	cmp    %eax,0x18(%ebp)
  100637:	76 13                	jbe    10064c <stab_binsearch+0xbb>
            *region_left = m;
  100639:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10063f:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100644:	83 c0 01             	add    $0x1,%eax
  100647:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10064a:	eb 43                	jmp    10068f <stab_binsearch+0xfe>
        } else if (stabs[m].n_value > addr) {
  10064c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10064f:	89 d0                	mov    %edx,%eax
  100651:	01 c0                	add    %eax,%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	c1 e0 02             	shl    $0x2,%eax
  100658:	89 c2                	mov    %eax,%edx
  10065a:	8b 45 08             	mov    0x8(%ebp),%eax
  10065d:	01 d0                	add    %edx,%eax
  10065f:	8b 40 08             	mov    0x8(%eax),%eax
  100662:	39 45 18             	cmp    %eax,0x18(%ebp)
  100665:	73 16                	jae    10067d <stab_binsearch+0xec>
            *region_right = m - 1;
  100667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10066a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10066d:	8b 45 10             	mov    0x10(%ebp),%eax
  100670:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100675:	83 e8 01             	sub    $0x1,%eax
  100678:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10067b:	eb 12                	jmp    10068f <stab_binsearch+0xfe>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10067d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100680:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100683:	89 10                	mov    %edx,(%eax)
            l = m;
  100685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100688:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10068b:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  10068f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100692:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100695:	0f 8e 22 ff ff ff    	jle    1005bd <stab_binsearch+0x2c>
        }
    }

    if (!any_matches) {
  10069b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10069f:	75 0f                	jne    1006b0 <stab_binsearch+0x11f>
        *region_right = *region_left - 1;
  1006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a4:	8b 00                	mov    (%eax),%eax
  1006a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1006a9:	8b 45 10             	mov    0x10(%ebp),%eax
  1006ac:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1006ae:	eb 3f                	jmp    1006ef <stab_binsearch+0x15e>
        l = *region_right;
  1006b0:	8b 45 10             	mov    0x10(%ebp),%eax
  1006b3:	8b 00                	mov    (%eax),%eax
  1006b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1006b8:	eb 04                	jmp    1006be <stab_binsearch+0x12d>
  1006ba:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1006be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c1:	8b 00                	mov    (%eax),%eax
  1006c3:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1006c6:	7e 1f                	jle    1006e7 <stab_binsearch+0x156>
  1006c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1006cb:	89 d0                	mov    %edx,%eax
  1006cd:	01 c0                	add    %eax,%eax
  1006cf:	01 d0                	add    %edx,%eax
  1006d1:	c1 e0 02             	shl    $0x2,%eax
  1006d4:	89 c2                	mov    %eax,%edx
  1006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d9:	01 d0                	add    %edx,%eax
  1006db:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1006df:	0f b6 c0             	movzbl %al,%eax
  1006e2:	39 45 14             	cmp    %eax,0x14(%ebp)
  1006e5:	75 d3                	jne    1006ba <stab_binsearch+0x129>
        *region_left = l;
  1006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1006ed:	89 10                	mov    %edx,(%eax)
}
  1006ef:	90                   	nop
  1006f0:	c9                   	leave  
  1006f1:	c3                   	ret    

001006f2 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1006f2:	55                   	push   %ebp
  1006f3:	89 e5                	mov    %esp,%ebp
  1006f5:	53                   	push   %ebx
  1006f6:	83 ec 34             	sub    $0x34,%esp
  1006f9:	e8 82 fb ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  1006fe:	81 c3 52 e2 00 00    	add    $0xe252,%ebx
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100704:	8b 45 0c             	mov    0xc(%ebp),%eax
  100707:	8d 93 0c 51 ff ff    	lea    -0xaef4(%ebx),%edx
  10070d:	89 10                	mov    %edx,(%eax)
    info->eip_line = 0;
  10070f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100712:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100719:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071c:	8d 93 0c 51 ff ff    	lea    -0xaef4(%ebx),%edx
  100722:	89 50 08             	mov    %edx,0x8(%eax)
    info->eip_fn_namelen = 9;
  100725:	8b 45 0c             	mov    0xc(%ebp),%eax
  100728:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10072f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100732:	8b 55 08             	mov    0x8(%ebp),%edx
  100735:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100738:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100742:	c7 c0 f0 41 10 00    	mov    $0x1041f0,%eax
  100748:	89 45 f4             	mov    %eax,-0xc(%ebp)
    stab_end = __STAB_END__;
  10074b:	c7 c0 94 be 10 00    	mov    $0x10be94,%eax
  100751:	89 45 f0             	mov    %eax,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100754:	c7 c0 95 be 10 00    	mov    $0x10be95,%eax
  10075a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10075d:	c7 c0 64 df 10 00    	mov    $0x10df64,%eax
  100763:	89 45 e8             	mov    %eax,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100769:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10076c:	76 0d                	jbe    10077b <debuginfo_eip+0x89>
  10076e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100771:	83 e8 01             	sub    $0x1,%eax
  100774:	0f b6 00             	movzbl (%eax),%eax
  100777:	84 c0                	test   %al,%al
  100779:	74 0a                	je     100785 <debuginfo_eip+0x93>
        return -1;
  10077b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100780:	e9 91 02 00 00       	jmp    100a16 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100785:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10078c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	29 c2                	sub    %eax,%edx
  100794:	89 d0                	mov    %edx,%eax
  100796:	c1 f8 02             	sar    $0x2,%eax
  100799:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10079f:	83 e8 01             	sub    $0x1,%eax
  1007a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1007a5:	ff 75 08             	pushl  0x8(%ebp)
  1007a8:	6a 64                	push   $0x64
  1007aa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1007ad:	50                   	push   %eax
  1007ae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1007b1:	50                   	push   %eax
  1007b2:	ff 75 f4             	pushl  -0xc(%ebp)
  1007b5:	e8 d7 fd ff ff       	call   100591 <stab_binsearch>
  1007ba:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  1007bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007c0:	85 c0                	test   %eax,%eax
  1007c2:	75 0a                	jne    1007ce <debuginfo_eip+0xdc>
        return -1;
  1007c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007c9:	e9 48 02 00 00       	jmp    100a16 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1007ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1007d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1007da:	ff 75 08             	pushl  0x8(%ebp)
  1007dd:	6a 24                	push   $0x24
  1007df:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1007e2:	50                   	push   %eax
  1007e3:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1007e6:	50                   	push   %eax
  1007e7:	ff 75 f4             	pushl  -0xc(%ebp)
  1007ea:	e8 a2 fd ff ff       	call   100591 <stab_binsearch>
  1007ef:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1007f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f8:	39 c2                	cmp    %eax,%edx
  1007fa:	7f 7c                	jg     100878 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1007fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007ff:	89 c2                	mov    %eax,%edx
  100801:	89 d0                	mov    %edx,%eax
  100803:	01 c0                	add    %eax,%eax
  100805:	01 d0                	add    %edx,%eax
  100807:	c1 e0 02             	shl    $0x2,%eax
  10080a:	89 c2                	mov    %eax,%edx
  10080c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10080f:	01 d0                	add    %edx,%eax
  100811:	8b 00                	mov    (%eax),%eax
  100813:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100816:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100819:	29 d1                	sub    %edx,%ecx
  10081b:	89 ca                	mov    %ecx,%edx
  10081d:	39 d0                	cmp    %edx,%eax
  10081f:	73 22                	jae    100843 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100821:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100824:	89 c2                	mov    %eax,%edx
  100826:	89 d0                	mov    %edx,%eax
  100828:	01 c0                	add    %eax,%eax
  10082a:	01 d0                	add    %edx,%eax
  10082c:	c1 e0 02             	shl    $0x2,%eax
  10082f:	89 c2                	mov    %eax,%edx
  100831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100834:	01 d0                	add    %edx,%eax
  100836:	8b 10                	mov    (%eax),%edx
  100838:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10083b:	01 c2                	add    %eax,%edx
  10083d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100840:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100843:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100846:	89 c2                	mov    %eax,%edx
  100848:	89 d0                	mov    %edx,%eax
  10084a:	01 c0                	add    %eax,%eax
  10084c:	01 d0                	add    %edx,%eax
  10084e:	c1 e0 02             	shl    $0x2,%eax
  100851:	89 c2                	mov    %eax,%edx
  100853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100856:	01 d0                	add    %edx,%eax
  100858:	8b 50 08             	mov    0x8(%eax),%edx
  10085b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10085e:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100861:	8b 45 0c             	mov    0xc(%ebp),%eax
  100864:	8b 40 10             	mov    0x10(%eax),%eax
  100867:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10086a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10086d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100870:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100873:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100876:	eb 15                	jmp    10088d <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100878:	8b 45 0c             	mov    0xc(%ebp),%eax
  10087b:	8b 55 08             	mov    0x8(%ebp),%edx
  10087e:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100884:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100887:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10088a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10088d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100890:	8b 40 08             	mov    0x8(%eax),%eax
  100893:	83 ec 08             	sub    $0x8,%esp
  100896:	6a 3a                	push   $0x3a
  100898:	50                   	push   %eax
  100899:	e8 0a 27 00 00       	call   102fa8 <strfind>
  10089e:	83 c4 10             	add    $0x10,%esp
  1008a1:	89 c2                	mov    %eax,%edx
  1008a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008a6:	8b 40 08             	mov    0x8(%eax),%eax
  1008a9:	29 c2                	sub    %eax,%edx
  1008ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ae:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1008b1:	83 ec 0c             	sub    $0xc,%esp
  1008b4:	ff 75 08             	pushl  0x8(%ebp)
  1008b7:	6a 44                	push   $0x44
  1008b9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1008bc:	50                   	push   %eax
  1008bd:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1008c0:	50                   	push   %eax
  1008c1:	ff 75 f4             	pushl  -0xc(%ebp)
  1008c4:	e8 c8 fc ff ff       	call   100591 <stab_binsearch>
  1008c9:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1008cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1008d2:	39 c2                	cmp    %eax,%edx
  1008d4:	7f 24                	jg     1008fa <debuginfo_eip+0x208>
        info->eip_line = stabs[rline].n_desc;
  1008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1008d9:	89 c2                	mov    %eax,%edx
  1008db:	89 d0                	mov    %edx,%eax
  1008dd:	01 c0                	add    %eax,%eax
  1008df:	01 d0                	add    %edx,%eax
  1008e1:	c1 e0 02             	shl    $0x2,%eax
  1008e4:	89 c2                	mov    %eax,%edx
  1008e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e9:	01 d0                	add    %edx,%eax
  1008eb:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1008ef:	0f b7 d0             	movzwl %ax,%edx
  1008f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f5:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1008f8:	eb 13                	jmp    10090d <debuginfo_eip+0x21b>
        return -1;
  1008fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1008ff:	e9 12 01 00 00       	jmp    100a16 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100904:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100907:	83 e8 01             	sub    $0x1,%eax
  10090a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10090d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100913:	39 c2                	cmp    %eax,%edx
  100915:	7c 56                	jl     10096d <debuginfo_eip+0x27b>
           && stabs[lline].n_type != N_SOL
  100917:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10091a:	89 c2                	mov    %eax,%edx
  10091c:	89 d0                	mov    %edx,%eax
  10091e:	01 c0                	add    %eax,%eax
  100920:	01 d0                	add    %edx,%eax
  100922:	c1 e0 02             	shl    $0x2,%eax
  100925:	89 c2                	mov    %eax,%edx
  100927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10092a:	01 d0                	add    %edx,%eax
  10092c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100930:	3c 84                	cmp    $0x84,%al
  100932:	74 39                	je     10096d <debuginfo_eip+0x27b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100934:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100937:	89 c2                	mov    %eax,%edx
  100939:	89 d0                	mov    %edx,%eax
  10093b:	01 c0                	add    %eax,%eax
  10093d:	01 d0                	add    %edx,%eax
  10093f:	c1 e0 02             	shl    $0x2,%eax
  100942:	89 c2                	mov    %eax,%edx
  100944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100947:	01 d0                	add    %edx,%eax
  100949:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10094d:	3c 64                	cmp    $0x64,%al
  10094f:	75 b3                	jne    100904 <debuginfo_eip+0x212>
  100951:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100954:	89 c2                	mov    %eax,%edx
  100956:	89 d0                	mov    %edx,%eax
  100958:	01 c0                	add    %eax,%eax
  10095a:	01 d0                	add    %edx,%eax
  10095c:	c1 e0 02             	shl    $0x2,%eax
  10095f:	89 c2                	mov    %eax,%edx
  100961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100964:	01 d0                	add    %edx,%eax
  100966:	8b 40 08             	mov    0x8(%eax),%eax
  100969:	85 c0                	test   %eax,%eax
  10096b:	74 97                	je     100904 <debuginfo_eip+0x212>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10096d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100973:	39 c2                	cmp    %eax,%edx
  100975:	7c 46                	jl     1009bd <debuginfo_eip+0x2cb>
  100977:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10097a:	89 c2                	mov    %eax,%edx
  10097c:	89 d0                	mov    %edx,%eax
  10097e:	01 c0                	add    %eax,%eax
  100980:	01 d0                	add    %edx,%eax
  100982:	c1 e0 02             	shl    $0x2,%eax
  100985:	89 c2                	mov    %eax,%edx
  100987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10098a:	01 d0                	add    %edx,%eax
  10098c:	8b 00                	mov    (%eax),%eax
  10098e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100991:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100994:	29 d1                	sub    %edx,%ecx
  100996:	89 ca                	mov    %ecx,%edx
  100998:	39 d0                	cmp    %edx,%eax
  10099a:	73 21                	jae    1009bd <debuginfo_eip+0x2cb>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10099c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10099f:	89 c2                	mov    %eax,%edx
  1009a1:	89 d0                	mov    %edx,%eax
  1009a3:	01 c0                	add    %eax,%eax
  1009a5:	01 d0                	add    %edx,%eax
  1009a7:	c1 e0 02             	shl    $0x2,%eax
  1009aa:	89 c2                	mov    %eax,%edx
  1009ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009af:	01 d0                	add    %edx,%eax
  1009b1:	8b 10                	mov    (%eax),%edx
  1009b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1009b6:	01 c2                	add    %eax,%edx
  1009b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1009bb:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1009bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1009c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1009c3:	39 c2                	cmp    %eax,%edx
  1009c5:	7d 4a                	jge    100a11 <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  1009c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009ca:	83 c0 01             	add    $0x1,%eax
  1009cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1009d0:	eb 18                	jmp    1009ea <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1009d5:	8b 40 14             	mov    0x14(%eax),%eax
  1009d8:	8d 50 01             	lea    0x1(%eax),%edx
  1009db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1009de:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1009e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1009e4:	83 c0 01             	add    $0x1,%eax
  1009e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1009ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1009ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1009f0:	39 c2                	cmp    %eax,%edx
  1009f2:	7d 1d                	jge    100a11 <debuginfo_eip+0x31f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1009f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1009f7:	89 c2                	mov    %eax,%edx
  1009f9:	89 d0                	mov    %edx,%eax
  1009fb:	01 c0                	add    %eax,%eax
  1009fd:	01 d0                	add    %edx,%eax
  1009ff:	c1 e0 02             	shl    $0x2,%eax
  100a02:	89 c2                	mov    %eax,%edx
  100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a07:	01 d0                	add    %edx,%eax
  100a09:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100a0d:	3c a0                	cmp    $0xa0,%al
  100a0f:	74 c1                	je     1009d2 <debuginfo_eip+0x2e0>
        }
    }
    return 0;
  100a11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100a19:	c9                   	leave  
  100a1a:	c3                   	ret    

00100a1b <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100a1b:	55                   	push   %ebp
  100a1c:	89 e5                	mov    %esp,%ebp
  100a1e:	53                   	push   %ebx
  100a1f:	83 ec 04             	sub    $0x4,%esp
  100a22:	e8 59 f8 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100a27:	81 c3 29 df 00 00    	add    $0xdf29,%ebx
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100a2d:	83 ec 0c             	sub    $0xc,%esp
  100a30:	8d 83 16 51 ff ff    	lea    -0xaeea(%ebx),%eax
  100a36:	50                   	push   %eax
  100a37:	e8 b7 f8 ff ff       	call   1002f3 <cprintf>
  100a3c:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100a3f:	83 ec 08             	sub    $0x8,%esp
  100a42:	c7 c0 00 00 10 00    	mov    $0x100000,%eax
  100a48:	50                   	push   %eax
  100a49:	8d 83 2f 51 ff ff    	lea    -0xaed1(%ebx),%eax
  100a4f:	50                   	push   %eax
  100a50:	e8 9e f8 ff ff       	call   1002f3 <cprintf>
  100a55:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100a58:	83 ec 08             	sub    $0x8,%esp
  100a5b:	c7 c0 74 39 10 00    	mov    $0x103974,%eax
  100a61:	50                   	push   %eax
  100a62:	8d 83 47 51 ff ff    	lea    -0xaeb9(%ebx),%eax
  100a68:	50                   	push   %eax
  100a69:	e8 85 f8 ff ff       	call   1002f3 <cprintf>
  100a6e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100a71:	83 ec 08             	sub    $0x8,%esp
  100a74:	c7 c0 50 e9 10 00    	mov    $0x10e950,%eax
  100a7a:	50                   	push   %eax
  100a7b:	8d 83 5f 51 ff ff    	lea    -0xaea1(%ebx),%eax
  100a81:	50                   	push   %eax
  100a82:	e8 6c f8 ff ff       	call   1002f3 <cprintf>
  100a87:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100a8a:	83 ec 08             	sub    $0x8,%esp
  100a8d:	c7 c0 c0 fd 10 00    	mov    $0x10fdc0,%eax
  100a93:	50                   	push   %eax
  100a94:	8d 83 77 51 ff ff    	lea    -0xae89(%ebx),%eax
  100a9a:	50                   	push   %eax
  100a9b:	e8 53 f8 ff ff       	call   1002f3 <cprintf>
  100aa0:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100aa3:	c7 c0 c0 fd 10 00    	mov    $0x10fdc0,%eax
  100aa9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100aaf:	c7 c0 00 00 10 00    	mov    $0x100000,%eax
  100ab5:	29 c2                	sub    %eax,%edx
  100ab7:	89 d0                	mov    %edx,%eax
  100ab9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100abf:	85 c0                	test   %eax,%eax
  100ac1:	0f 48 c2             	cmovs  %edx,%eax
  100ac4:	c1 f8 0a             	sar    $0xa,%eax
  100ac7:	83 ec 08             	sub    $0x8,%esp
  100aca:	50                   	push   %eax
  100acb:	8d 83 90 51 ff ff    	lea    -0xae70(%ebx),%eax
  100ad1:	50                   	push   %eax
  100ad2:	e8 1c f8 ff ff       	call   1002f3 <cprintf>
  100ad7:	83 c4 10             	add    $0x10,%esp
}
  100ada:	90                   	nop
  100adb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100ade:	c9                   	leave  
  100adf:	c3                   	ret    

00100ae0 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100ae0:	55                   	push   %ebp
  100ae1:	89 e5                	mov    %esp,%ebp
  100ae3:	53                   	push   %ebx
  100ae4:	81 ec 24 01 00 00    	sub    $0x124,%esp
  100aea:	e8 91 f7 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100aef:	81 c3 61 de 00 00    	add    $0xde61,%ebx
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100af5:	83 ec 08             	sub    $0x8,%esp
  100af8:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100afb:	50                   	push   %eax
  100afc:	ff 75 08             	pushl  0x8(%ebp)
  100aff:	e8 ee fb ff ff       	call   1006f2 <debuginfo_eip>
  100b04:	83 c4 10             	add    $0x10,%esp
  100b07:	85 c0                	test   %eax,%eax
  100b09:	74 17                	je     100b22 <print_debuginfo+0x42>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100b0b:	83 ec 08             	sub    $0x8,%esp
  100b0e:	ff 75 08             	pushl  0x8(%ebp)
  100b11:	8d 83 ba 51 ff ff    	lea    -0xae46(%ebx),%eax
  100b17:	50                   	push   %eax
  100b18:	e8 d6 f7 ff ff       	call   1002f3 <cprintf>
  100b1d:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100b20:	eb 67                	jmp    100b89 <print_debuginfo+0xa9>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100b22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b29:	eb 1c                	jmp    100b47 <print_debuginfo+0x67>
            fnname[j] = info.eip_fn_name[j];
  100b2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b31:	01 d0                	add    %edx,%eax
  100b33:	0f b6 00             	movzbl (%eax),%eax
  100b36:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100b3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b3f:	01 ca                	add    %ecx,%edx
  100b41:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100b43:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b4a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100b4d:	7c dc                	jl     100b2b <print_debuginfo+0x4b>
        fnname[j] = '\0';
  100b4f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b58:	01 d0                	add    %edx,%eax
  100b5a:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100b60:	8b 55 08             	mov    0x8(%ebp),%edx
  100b63:	89 d1                	mov    %edx,%ecx
  100b65:	29 c1                	sub    %eax,%ecx
  100b67:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100b6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100b6d:	83 ec 0c             	sub    $0xc,%esp
  100b70:	51                   	push   %ecx
  100b71:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100b77:	51                   	push   %ecx
  100b78:	52                   	push   %edx
  100b79:	50                   	push   %eax
  100b7a:	8d 83 d6 51 ff ff    	lea    -0xae2a(%ebx),%eax
  100b80:	50                   	push   %eax
  100b81:	e8 6d f7 ff ff       	call   1002f3 <cprintf>
  100b86:	83 c4 20             	add    $0x20,%esp
}
  100b89:	90                   	nop
  100b8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100b8d:	c9                   	leave  
  100b8e:	c3                   	ret    

00100b8f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100b8f:	55                   	push   %ebp
  100b90:	89 e5                	mov    %esp,%ebp
  100b92:	83 ec 10             	sub    $0x10,%esp
  100b95:	e8 e2 f6 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100b9a:	05 b6 dd 00 00       	add    $0xddb6,%eax
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100b9f:	8b 45 04             	mov    0x4(%ebp),%eax
  100ba2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100ba5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100ba8:	c9                   	leave  
  100ba9:	c3                   	ret    

00100baa <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100baa:	55                   	push   %ebp
  100bab:	89 e5                	mov    %esp,%ebp
  100bad:	53                   	push   %ebx
  100bae:	83 ec 24             	sub    $0x24,%esp
  100bb1:	e8 ca f6 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100bb6:	81 c3 9a dd 00 00    	add    $0xdd9a,%ebx
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100bbc:	89 e8                	mov    %ebp,%eax
  100bbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100bc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	//（1）(2）
	uint32_t ebp = read_ebp();
  100bc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();	//找到 base pointer
  100bc7:	e8 c3 ff ff ff       	call   100b8f <read_eip>
  100bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//(3)
	int i,j;//why????
	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)//没到底
  100bcf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100bd6:	e9 93 00 00 00       	jmp    100c6e <print_stackframe+0xc4>
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip); 
  100bdb:	83 ec 04             	sub    $0x4,%esp
  100bde:	ff 75 f0             	pushl  -0x10(%ebp)
  100be1:	ff 75 f4             	pushl  -0xc(%ebp)
  100be4:	8d 83 e8 51 ff ff    	lea    -0xae18(%ebx),%eax
  100bea:	50                   	push   %eax
  100beb:	e8 03 f7 ff ff       	call   1002f3 <cprintf>
  100bf0:	83 c4 10             	add    $0x10,%esp
		uint32_t *args = (uint32_t *)ebp + 2; //参数的首地址 == (uint32_t *)(ebp+8)
  100bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bf6:	83 c0 08             	add    $0x8,%eax
  100bf9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (j = 0; j < 4; j++) 
  100bfc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100c03:	eb 28                	jmp    100c2d <print_stackframe+0x83>
		{
		    cprintf("0x%08x ", args[j]); //打印4个参数
  100c05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100c12:	01 d0                	add    %edx,%eax
  100c14:	8b 00                	mov    (%eax),%eax
  100c16:	83 ec 08             	sub    $0x8,%esp
  100c19:	50                   	push   %eax
  100c1a:	8d 83 04 52 ff ff    	lea    -0xadfc(%ebx),%eax
  100c20:	50                   	push   %eax
  100c21:	e8 cd f6 ff ff       	call   1002f3 <cprintf>
  100c26:	83 c4 10             	add    $0x10,%esp
		for (j = 0; j < 4; j++) 
  100c29:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100c2d:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100c31:	7e d2                	jle    100c05 <print_stackframe+0x5b>
		}
		cprintf("\n");
  100c33:	83 ec 0c             	sub    $0xc,%esp
  100c36:	8d 83 0c 52 ff ff    	lea    -0xadf4(%ebx),%eax
  100c3c:	50                   	push   %eax
  100c3d:	e8 b1 f6 ff ff       	call   1002f3 <cprintf>
  100c42:	83 c4 10             	add    $0x10,%esp
		print_debuginfo(eip - 1);  //打印函数信息(???原理)
  100c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100c48:	83 e8 01             	sub    $0x1,%eax
  100c4b:	83 ec 0c             	sub    $0xc,%esp
  100c4e:	50                   	push   %eax
  100c4f:	e8 8c fe ff ff       	call   100ae0 <print_debuginfo>
  100c54:	83 c4 10             	add    $0x10,%esp
		eip = ((uint32_t *)ebp)[1]; //强行4字节，更新eip
  100c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c5a:	83 c0 04             	add    $0x4,%eax
  100c5d:	8b 00                	mov    (%eax),%eax
  100c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = ((uint32_t *)ebp)[0]; //更新ebp
  100c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c65:	8b 00                	mov    (%eax),%eax
  100c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)//没到底
  100c6a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100c6e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100c72:	7f 0a                	jg     100c7e <print_stackframe+0xd4>
  100c74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c78:	0f 85 5d ff ff ff    	jne    100bdb <print_stackframe+0x31>
	}
	
	
	
	
}
  100c7e:	90                   	nop
  100c7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100c82:	c9                   	leave  
  100c83:	c3                   	ret    

00100c84 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100c84:	55                   	push   %ebp
  100c85:	89 e5                	mov    %esp,%ebp
  100c87:	53                   	push   %ebx
  100c88:	83 ec 14             	sub    $0x14,%esp
  100c8b:	e8 f0 f5 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100c90:	81 c3 c0 dc 00 00    	add    $0xdcc0,%ebx
    int argc = 0;
  100c96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c9d:	eb 0c                	jmp    100cab <parse+0x27>
            *buf ++ = '\0';
  100c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  100ca2:	8d 50 01             	lea    0x1(%eax),%edx
  100ca5:	89 55 08             	mov    %edx,0x8(%ebp)
  100ca8:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100cab:	8b 45 08             	mov    0x8(%ebp),%eax
  100cae:	0f b6 00             	movzbl (%eax),%eax
  100cb1:	84 c0                	test   %al,%al
  100cb3:	74 20                	je     100cd5 <parse+0x51>
  100cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  100cb8:	0f b6 00             	movzbl (%eax),%eax
  100cbb:	0f be c0             	movsbl %al,%eax
  100cbe:	83 ec 08             	sub    $0x8,%esp
  100cc1:	50                   	push   %eax
  100cc2:	8d 83 90 52 ff ff    	lea    -0xad70(%ebx),%eax
  100cc8:	50                   	push   %eax
  100cc9:	e8 9d 22 00 00       	call   102f6b <strchr>
  100cce:	83 c4 10             	add    $0x10,%esp
  100cd1:	85 c0                	test   %eax,%eax
  100cd3:	75 ca                	jne    100c9f <parse+0x1b>
        }
        if (*buf == '\0') {
  100cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd8:	0f b6 00             	movzbl (%eax),%eax
  100cdb:	84 c0                	test   %al,%al
  100cdd:	74 69                	je     100d48 <parse+0xc4>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100cdf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ce3:	75 14                	jne    100cf9 <parse+0x75>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ce5:	83 ec 08             	sub    $0x8,%esp
  100ce8:	6a 10                	push   $0x10
  100cea:	8d 83 95 52 ff ff    	lea    -0xad6b(%ebx),%eax
  100cf0:	50                   	push   %eax
  100cf1:	e8 fd f5 ff ff       	call   1002f3 <cprintf>
  100cf6:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cfc:	8d 50 01             	lea    0x1(%eax),%edx
  100cff:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100d02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d0c:	01 c2                	add    %eax,%edx
  100d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100d11:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100d13:	eb 04                	jmp    100d19 <parse+0x95>
            buf ++;
  100d15:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100d19:	8b 45 08             	mov    0x8(%ebp),%eax
  100d1c:	0f b6 00             	movzbl (%eax),%eax
  100d1f:	84 c0                	test   %al,%al
  100d21:	74 88                	je     100cab <parse+0x27>
  100d23:	8b 45 08             	mov    0x8(%ebp),%eax
  100d26:	0f b6 00             	movzbl (%eax),%eax
  100d29:	0f be c0             	movsbl %al,%eax
  100d2c:	83 ec 08             	sub    $0x8,%esp
  100d2f:	50                   	push   %eax
  100d30:	8d 83 90 52 ff ff    	lea    -0xad70(%ebx),%eax
  100d36:	50                   	push   %eax
  100d37:	e8 2f 22 00 00       	call   102f6b <strchr>
  100d3c:	83 c4 10             	add    $0x10,%esp
  100d3f:	85 c0                	test   %eax,%eax
  100d41:	74 d2                	je     100d15 <parse+0x91>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100d43:	e9 63 ff ff ff       	jmp    100cab <parse+0x27>
            break;
  100d48:	90                   	nop
        }
    }
    return argc;
  100d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100d4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100d4f:	c9                   	leave  
  100d50:	c3                   	ret    

00100d51 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100d51:	55                   	push   %ebp
  100d52:	89 e5                	mov    %esp,%ebp
  100d54:	56                   	push   %esi
  100d55:	53                   	push   %ebx
  100d56:	83 ec 50             	sub    $0x50,%esp
  100d59:	e8 22 f5 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100d5e:	81 c3 f2 db 00 00    	add    $0xdbf2,%ebx
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100d64:	83 ec 08             	sub    $0x8,%esp
  100d67:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100d6a:	50                   	push   %eax
  100d6b:	ff 75 08             	pushl  0x8(%ebp)
  100d6e:	e8 11 ff ff ff       	call   100c84 <parse>
  100d73:	83 c4 10             	add    $0x10,%esp
  100d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100d79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100d7d:	75 0a                	jne    100d89 <runcmd+0x38>
        return 0;
  100d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  100d84:	e9 8b 00 00 00       	jmp    100e14 <runcmd+0xc3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d90:	eb 5f                	jmp    100df1 <runcmd+0xa0>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100d92:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100d95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d98:	8d b3 10 00 00 00    	lea    0x10(%ebx),%esi
  100d9e:	89 d0                	mov    %edx,%eax
  100da0:	01 c0                	add    %eax,%eax
  100da2:	01 d0                	add    %edx,%eax
  100da4:	c1 e0 02             	shl    $0x2,%eax
  100da7:	01 f0                	add    %esi,%eax
  100da9:	8b 00                	mov    (%eax),%eax
  100dab:	83 ec 08             	sub    $0x8,%esp
  100dae:	51                   	push   %ecx
  100daf:	50                   	push   %eax
  100db0:	e8 02 21 00 00       	call   102eb7 <strcmp>
  100db5:	83 c4 10             	add    $0x10,%esp
  100db8:	85 c0                	test   %eax,%eax
  100dba:	75 31                	jne    100ded <runcmd+0x9c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100dbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100dbf:	8d 8b 18 00 00 00    	lea    0x18(%ebx),%ecx
  100dc5:	89 d0                	mov    %edx,%eax
  100dc7:	01 c0                	add    %eax,%eax
  100dc9:	01 d0                	add    %edx,%eax
  100dcb:	c1 e0 02             	shl    $0x2,%eax
  100dce:	01 c8                	add    %ecx,%eax
  100dd0:	8b 10                	mov    (%eax),%edx
  100dd2:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100dd5:	83 c0 04             	add    $0x4,%eax
  100dd8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100ddb:	83 e9 01             	sub    $0x1,%ecx
  100dde:	83 ec 04             	sub    $0x4,%esp
  100de1:	ff 75 0c             	pushl  0xc(%ebp)
  100de4:	50                   	push   %eax
  100de5:	51                   	push   %ecx
  100de6:	ff d2                	call   *%edx
  100de8:	83 c4 10             	add    $0x10,%esp
  100deb:	eb 27                	jmp    100e14 <runcmd+0xc3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100ded:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100df4:	83 f8 02             	cmp    $0x2,%eax
  100df7:	76 99                	jbe    100d92 <runcmd+0x41>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100df9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100dfc:	83 ec 08             	sub    $0x8,%esp
  100dff:	50                   	push   %eax
  100e00:	8d 83 b3 52 ff ff    	lea    -0xad4d(%ebx),%eax
  100e06:	50                   	push   %eax
  100e07:	e8 e7 f4 ff ff       	call   1002f3 <cprintf>
  100e0c:	83 c4 10             	add    $0x10,%esp
    return 0;
  100e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100e17:	5b                   	pop    %ebx
  100e18:	5e                   	pop    %esi
  100e19:	5d                   	pop    %ebp
  100e1a:	c3                   	ret    

00100e1b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100e1b:	55                   	push   %ebp
  100e1c:	89 e5                	mov    %esp,%ebp
  100e1e:	53                   	push   %ebx
  100e1f:	83 ec 14             	sub    $0x14,%esp
  100e22:	e8 59 f4 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100e27:	81 c3 29 db 00 00    	add    $0xdb29,%ebx
    cprintf("Welcome to the kernel debug monitor!!\n");
  100e2d:	83 ec 0c             	sub    $0xc,%esp
  100e30:	8d 83 cc 52 ff ff    	lea    -0xad34(%ebx),%eax
  100e36:	50                   	push   %eax
  100e37:	e8 b7 f4 ff ff       	call   1002f3 <cprintf>
  100e3c:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100e3f:	83 ec 0c             	sub    $0xc,%esp
  100e42:	8d 83 f4 52 ff ff    	lea    -0xad0c(%ebx),%eax
  100e48:	50                   	push   %eax
  100e49:	e8 a5 f4 ff ff       	call   1002f3 <cprintf>
  100e4e:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100e51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e55:	74 0e                	je     100e65 <kmonitor+0x4a>
        print_trapframe(tf);
  100e57:	83 ec 0c             	sub    $0xc,%esp
  100e5a:	ff 75 08             	pushl  0x8(%ebp)
  100e5d:	e8 11 0f 00 00       	call   101d73 <print_trapframe>
  100e62:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100e65:	83 ec 0c             	sub    $0xc,%esp
  100e68:	8d 83 19 53 ff ff    	lea    -0xace7(%ebx),%eax
  100e6e:	50                   	push   %eax
  100e6f:	e8 57 f5 ff ff       	call   1003cb <readline>
  100e74:	83 c4 10             	add    $0x10,%esp
  100e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100e7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100e7e:	74 e5                	je     100e65 <kmonitor+0x4a>
            if (runcmd(buf, tf) < 0) {
  100e80:	83 ec 08             	sub    $0x8,%esp
  100e83:	ff 75 08             	pushl  0x8(%ebp)
  100e86:	ff 75 f4             	pushl  -0xc(%ebp)
  100e89:	e8 c3 fe ff ff       	call   100d51 <runcmd>
  100e8e:	83 c4 10             	add    $0x10,%esp
  100e91:	85 c0                	test   %eax,%eax
  100e93:	78 02                	js     100e97 <kmonitor+0x7c>
        if ((buf = readline("K> ")) != NULL) {
  100e95:	eb ce                	jmp    100e65 <kmonitor+0x4a>
                break;
  100e97:	90                   	nop
            }
        }
    }
}
  100e98:	90                   	nop
  100e99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100e9c:	c9                   	leave  
  100e9d:	c3                   	ret    

00100e9e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100e9e:	55                   	push   %ebp
  100e9f:	89 e5                	mov    %esp,%ebp
  100ea1:	56                   	push   %esi
  100ea2:	53                   	push   %ebx
  100ea3:	83 ec 10             	sub    $0x10,%esp
  100ea6:	e8 d5 f3 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100eab:	81 c3 a5 da 00 00    	add    $0xdaa5,%ebx
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100eb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100eb8:	eb 44                	jmp    100efe <mon_help+0x60>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ebd:	8d 8b 14 00 00 00    	lea    0x14(%ebx),%ecx
  100ec3:	89 d0                	mov    %edx,%eax
  100ec5:	01 c0                	add    %eax,%eax
  100ec7:	01 d0                	add    %edx,%eax
  100ec9:	c1 e0 02             	shl    $0x2,%eax
  100ecc:	01 c8                	add    %ecx,%eax
  100ece:	8b 08                	mov    (%eax),%ecx
  100ed0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ed3:	8d b3 10 00 00 00    	lea    0x10(%ebx),%esi
  100ed9:	89 d0                	mov    %edx,%eax
  100edb:	01 c0                	add    %eax,%eax
  100edd:	01 d0                	add    %edx,%eax
  100edf:	c1 e0 02             	shl    $0x2,%eax
  100ee2:	01 f0                	add    %esi,%eax
  100ee4:	8b 00                	mov    (%eax),%eax
  100ee6:	83 ec 04             	sub    $0x4,%esp
  100ee9:	51                   	push   %ecx
  100eea:	50                   	push   %eax
  100eeb:	8d 83 1d 53 ff ff    	lea    -0xace3(%ebx),%eax
  100ef1:	50                   	push   %eax
  100ef2:	e8 fc f3 ff ff       	call   1002f3 <cprintf>
  100ef7:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100efa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f01:	83 f8 02             	cmp    $0x2,%eax
  100f04:	76 b4                	jbe    100eba <mon_help+0x1c>
    }
    return 0;
  100f06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100f0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100f0e:	5b                   	pop    %ebx
  100f0f:	5e                   	pop    %esi
  100f10:	5d                   	pop    %ebp
  100f11:	c3                   	ret    

00100f12 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100f12:	55                   	push   %ebp
  100f13:	89 e5                	mov    %esp,%ebp
  100f15:	53                   	push   %ebx
  100f16:	83 ec 04             	sub    $0x4,%esp
  100f19:	e8 5e f3 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100f1e:	05 32 da 00 00       	add    $0xda32,%eax
    print_kerninfo();
  100f23:	89 c3                	mov    %eax,%ebx
  100f25:	e8 f1 fa ff ff       	call   100a1b <print_kerninfo>
    return 0;
  100f2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100f2f:	83 c4 04             	add    $0x4,%esp
  100f32:	5b                   	pop    %ebx
  100f33:	5d                   	pop    %ebp
  100f34:	c3                   	ret    

00100f35 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100f35:	55                   	push   %ebp
  100f36:	89 e5                	mov    %esp,%ebp
  100f38:	53                   	push   %ebx
  100f39:	83 ec 04             	sub    $0x4,%esp
  100f3c:	e8 3b f3 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100f41:	05 0f da 00 00       	add    $0xda0f,%eax
    print_stackframe();
  100f46:	89 c3                	mov    %eax,%ebx
  100f48:	e8 5d fc ff ff       	call   100baa <print_stackframe>
    return 0;
  100f4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100f52:	83 c4 04             	add    $0x4,%esp
  100f55:	5b                   	pop    %ebx
  100f56:	5d                   	pop    %ebp
  100f57:	c3                   	ret    

00100f58 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100f58:	55                   	push   %ebp
  100f59:	89 e5                	mov    %esp,%ebp
  100f5b:	53                   	push   %ebx
  100f5c:	83 ec 14             	sub    $0x14,%esp
  100f5f:	e8 1c f3 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  100f64:	81 c3 ec d9 00 00    	add    $0xd9ec,%ebx
  100f6a:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100f70:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f74:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f78:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f7c:	ee                   	out    %al,(%dx)
  100f7d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100f83:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100f87:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f8b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f8f:	ee                   	out    %al,(%dx)
  100f90:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100f96:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100f9a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f9e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100fa2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100fa3:	c7 c0 a8 f9 10 00    	mov    $0x10f9a8,%eax
  100fa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("++ setup timer interrupts\n");
  100faf:	83 ec 0c             	sub    $0xc,%esp
  100fb2:	8d 83 26 53 ff ff    	lea    -0xacda(%ebx),%eax
  100fb8:	50                   	push   %eax
  100fb9:	e8 35 f3 ff ff       	call   1002f3 <cprintf>
  100fbe:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100fc1:	83 ec 0c             	sub    $0xc,%esp
  100fc4:	6a 00                	push   $0x0
  100fc6:	e8 e7 09 00 00       	call   1019b2 <pic_enable>
  100fcb:	83 c4 10             	add    $0x10,%esp
}
  100fce:	90                   	nop
  100fcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100fd2:	c9                   	leave  
  100fd3:	c3                   	ret    

00100fd4 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100fd4:	55                   	push   %ebp
  100fd5:	89 e5                	mov    %esp,%ebp
  100fd7:	83 ec 10             	sub    $0x10,%esp
  100fda:	e8 9d f2 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  100fdf:	05 71 d9 00 00       	add    $0xd971,%eax
  100fe4:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fea:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fee:	89 c2                	mov    %eax,%edx
  100ff0:	ec                   	in     (%dx),%al
  100ff1:	88 45 f1             	mov    %al,-0xf(%ebp)
  100ff4:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100ffa:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ffe:	89 c2                	mov    %eax,%edx
  101000:	ec                   	in     (%dx),%al
  101001:	88 45 f5             	mov    %al,-0xb(%ebp)
  101004:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  10100a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10100e:	89 c2                	mov    %eax,%edx
  101010:	ec                   	in     (%dx),%al
  101011:	88 45 f9             	mov    %al,-0x7(%ebp)
  101014:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  10101a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10101e:	89 c2                	mov    %eax,%edx
  101020:	ec                   	in     (%dx),%al
  101021:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  101024:	90                   	nop
  101025:	c9                   	leave  
  101026:	c3                   	ret    

00101027 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  101027:	55                   	push   %ebp
  101028:	89 e5                	mov    %esp,%ebp
  10102a:	83 ec 20             	sub    $0x20,%esp
  10102d:	e8 17 09 00 00       	call   101949 <__x86.get_pc_thunk.cx>
  101032:	81 c1 1e d9 00 00    	add    $0xd91e,%ecx
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  101038:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  10103f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101042:	0f b7 00             	movzwl (%eax),%eax
  101045:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  101049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10104c:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  101051:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101054:	0f b7 00             	movzwl (%eax),%eax
  101057:	66 3d 5a a5          	cmp    $0xa55a,%ax
  10105b:	74 12                	je     10106f <cga_init+0x48>
        cp = (uint16_t*)MONO_BUF;
  10105d:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  101064:	66 c7 81 b6 05 00 00 	movw   $0x3b4,0x5b6(%ecx)
  10106b:	b4 03 
  10106d:	eb 13                	jmp    101082 <cga_init+0x5b>
    } else {
        *cp = was;
  10106f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101072:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101076:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  101079:	66 c7 81 b6 05 00 00 	movw   $0x3d4,0x5b6(%ecx)
  101080:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  101082:	0f b7 81 b6 05 00 00 	movzwl 0x5b6(%ecx),%eax
  101089:	0f b7 c0             	movzwl %ax,%eax
  10108c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101090:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101094:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101098:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10109c:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  10109d:	0f b7 81 b6 05 00 00 	movzwl 0x5b6(%ecx),%eax
  1010a4:	83 c0 01             	add    $0x1,%eax
  1010a7:	0f b7 c0             	movzwl %ax,%eax
  1010aa:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1010ae:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  1010b2:	89 c2                	mov    %eax,%edx
  1010b4:	ec                   	in     (%dx),%al
  1010b5:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  1010b8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1010bc:	0f b6 c0             	movzbl %al,%eax
  1010bf:	c1 e0 08             	shl    $0x8,%eax
  1010c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  1010c5:	0f b7 81 b6 05 00 00 	movzwl 0x5b6(%ecx),%eax
  1010cc:	0f b7 c0             	movzwl %ax,%eax
  1010cf:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1010d3:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010d7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010db:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010df:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  1010e0:	0f b7 81 b6 05 00 00 	movzwl 0x5b6(%ecx),%eax
  1010e7:	83 c0 01             	add    $0x1,%eax
  1010ea:	0f b7 c0             	movzwl %ax,%eax
  1010ed:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1010f1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1010f5:	89 c2                	mov    %eax,%edx
  1010f7:	ec                   	in     (%dx),%al
  1010f8:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  1010fb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010ff:	0f b6 c0             	movzbl %al,%eax
  101102:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  101105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101108:	89 81 b0 05 00 00    	mov    %eax,0x5b0(%ecx)
    crt_pos = pos;
  10110e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101111:	66 89 81 b4 05 00 00 	mov    %ax,0x5b4(%ecx)
}
  101118:	90                   	nop
  101119:	c9                   	leave  
  10111a:	c3                   	ret    

0010111b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  10111b:	55                   	push   %ebp
  10111c:	89 e5                	mov    %esp,%ebp
  10111e:	53                   	push   %ebx
  10111f:	83 ec 34             	sub    $0x34,%esp
  101122:	e8 22 08 00 00       	call   101949 <__x86.get_pc_thunk.cx>
  101127:	81 c1 29 d8 00 00    	add    $0xd829,%ecx
  10112d:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  101133:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101137:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10113b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10113f:	ee                   	out    %al,(%dx)
  101140:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  101146:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  10114a:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10114e:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101152:	ee                   	out    %al,(%dx)
  101153:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  101159:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  10115d:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101161:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101165:	ee                   	out    %al,(%dx)
  101166:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  10116c:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  101170:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101174:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101178:	ee                   	out    %al,(%dx)
  101179:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  10117f:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  101183:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101187:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10118b:	ee                   	out    %al,(%dx)
  10118c:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101192:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  101196:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10119a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10119e:	ee                   	out    %al,(%dx)
  10119f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  1011a5:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  1011a9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011ad:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1011b1:	ee                   	out    %al,(%dx)
  1011b2:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1011b8:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  1011bc:	89 c2                	mov    %eax,%edx
  1011be:	ec                   	in     (%dx),%al
  1011bf:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  1011c2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  1011c6:	3c ff                	cmp    $0xff,%al
  1011c8:	0f 95 c0             	setne  %al
  1011cb:	0f b6 c0             	movzbl %al,%eax
  1011ce:	89 81 b8 05 00 00    	mov    %eax,0x5b8(%ecx)
  1011d4:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1011da:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1011de:	89 c2                	mov    %eax,%edx
  1011e0:	ec                   	in     (%dx),%al
  1011e1:	88 45 f1             	mov    %al,-0xf(%ebp)
  1011e4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1011ea:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1011ee:	89 c2                	mov    %eax,%edx
  1011f0:	ec                   	in     (%dx),%al
  1011f1:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  1011f4:	8b 81 b8 05 00 00    	mov    0x5b8(%ecx),%eax
  1011fa:	85 c0                	test   %eax,%eax
  1011fc:	74 0f                	je     10120d <serial_init+0xf2>
        pic_enable(IRQ_COM1);
  1011fe:	83 ec 0c             	sub    $0xc,%esp
  101201:	6a 04                	push   $0x4
  101203:	89 cb                	mov    %ecx,%ebx
  101205:	e8 a8 07 00 00       	call   1019b2 <pic_enable>
  10120a:	83 c4 10             	add    $0x10,%esp
    }
}
  10120d:	90                   	nop
  10120e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101211:	c9                   	leave  
  101212:	c3                   	ret    

00101213 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101213:	55                   	push   %ebp
  101214:	89 e5                	mov    %esp,%ebp
  101216:	83 ec 20             	sub    $0x20,%esp
  101219:	e8 5e f0 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10121e:	05 32 d7 00 00       	add    $0xd732,%eax
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10122a:	eb 09                	jmp    101235 <lpt_putc_sub+0x22>
        delay();
  10122c:	e8 a3 fd ff ff       	call   100fd4 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101231:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101235:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10123b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10123f:	89 c2                	mov    %eax,%edx
  101241:	ec                   	in     (%dx),%al
  101242:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101245:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101249:	84 c0                	test   %al,%al
  10124b:	78 09                	js     101256 <lpt_putc_sub+0x43>
  10124d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101254:	7e d6                	jle    10122c <lpt_putc_sub+0x19>
    }
    outb(LPTPORT + 0, c);
  101256:	8b 45 08             	mov    0x8(%ebp),%eax
  101259:	0f b6 c0             	movzbl %al,%eax
  10125c:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101262:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101265:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101269:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10126d:	ee                   	out    %al,(%dx)
  10126e:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101274:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101278:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10127c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101280:	ee                   	out    %al,(%dx)
  101281:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101287:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  10128b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10128f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101293:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101294:	90                   	nop
  101295:	c9                   	leave  
  101296:	c3                   	ret    

00101297 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101297:	55                   	push   %ebp
  101298:	89 e5                	mov    %esp,%ebp
  10129a:	e8 dd ef ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10129f:	05 b1 d6 00 00       	add    $0xd6b1,%eax
    if (c != '\b') {
  1012a4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012a8:	74 0d                	je     1012b7 <lpt_putc+0x20>
        lpt_putc_sub(c);
  1012aa:	ff 75 08             	pushl  0x8(%ebp)
  1012ad:	e8 61 ff ff ff       	call   101213 <lpt_putc_sub>
  1012b2:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1012b5:	eb 1e                	jmp    1012d5 <lpt_putc+0x3e>
        lpt_putc_sub('\b');
  1012b7:	6a 08                	push   $0x8
  1012b9:	e8 55 ff ff ff       	call   101213 <lpt_putc_sub>
  1012be:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  1012c1:	6a 20                	push   $0x20
  1012c3:	e8 4b ff ff ff       	call   101213 <lpt_putc_sub>
  1012c8:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  1012cb:	6a 08                	push   $0x8
  1012cd:	e8 41 ff ff ff       	call   101213 <lpt_putc_sub>
  1012d2:	83 c4 04             	add    $0x4,%esp
}
  1012d5:	90                   	nop
  1012d6:	c9                   	leave  
  1012d7:	c3                   	ret    

001012d8 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1012d8:	55                   	push   %ebp
  1012d9:	89 e5                	mov    %esp,%ebp
  1012db:	56                   	push   %esi
  1012dc:	53                   	push   %ebx
  1012dd:	83 ec 20             	sub    $0x20,%esp
  1012e0:	e8 9b ef ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  1012e5:	81 c3 6b d6 00 00    	add    $0xd66b,%ebx
    // set black on white
    if (!(c & ~0xFF)) {
  1012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ee:	b0 00                	mov    $0x0,%al
  1012f0:	85 c0                	test   %eax,%eax
  1012f2:	75 07                	jne    1012fb <cga_putc+0x23>
        c |= 0x0700;
  1012f4:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1012fe:	0f b6 c0             	movzbl %al,%eax
  101301:	83 f8 0a             	cmp    $0xa,%eax
  101304:	74 54                	je     10135a <cga_putc+0x82>
  101306:	83 f8 0d             	cmp    $0xd,%eax
  101309:	74 60                	je     10136b <cga_putc+0x93>
  10130b:	83 f8 08             	cmp    $0x8,%eax
  10130e:	0f 85 92 00 00 00    	jne    1013a6 <cga_putc+0xce>
    case '\b':
        if (crt_pos > 0) {
  101314:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  10131b:	66 85 c0             	test   %ax,%ax
  10131e:	0f 84 a8 00 00 00    	je     1013cc <cga_putc+0xf4>
            crt_pos --;
  101324:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  10132b:	83 e8 01             	sub    $0x1,%eax
  10132e:	66 89 83 b4 05 00 00 	mov    %ax,0x5b4(%ebx)
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101335:	8b 45 08             	mov    0x8(%ebp),%eax
  101338:	b0 00                	mov    $0x0,%al
  10133a:	83 c8 20             	or     $0x20,%eax
  10133d:	89 c1                	mov    %eax,%ecx
  10133f:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  101345:	0f b7 93 b4 05 00 00 	movzwl 0x5b4(%ebx),%edx
  10134c:	0f b7 d2             	movzwl %dx,%edx
  10134f:	01 d2                	add    %edx,%edx
  101351:	01 d0                	add    %edx,%eax
  101353:	89 ca                	mov    %ecx,%edx
  101355:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  101358:	eb 72                	jmp    1013cc <cga_putc+0xf4>
    case '\n':
        crt_pos += CRT_COLS;
  10135a:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  101361:	83 c0 50             	add    $0x50,%eax
  101364:	66 89 83 b4 05 00 00 	mov    %ax,0x5b4(%ebx)
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10136b:	0f b7 b3 b4 05 00 00 	movzwl 0x5b4(%ebx),%esi
  101372:	0f b7 8b b4 05 00 00 	movzwl 0x5b4(%ebx),%ecx
  101379:	0f b7 c1             	movzwl %cx,%eax
  10137c:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101382:	c1 e8 10             	shr    $0x10,%eax
  101385:	89 c2                	mov    %eax,%edx
  101387:	66 c1 ea 06          	shr    $0x6,%dx
  10138b:	89 d0                	mov    %edx,%eax
  10138d:	c1 e0 02             	shl    $0x2,%eax
  101390:	01 d0                	add    %edx,%eax
  101392:	c1 e0 04             	shl    $0x4,%eax
  101395:	29 c1                	sub    %eax,%ecx
  101397:	89 ca                	mov    %ecx,%edx
  101399:	89 f0                	mov    %esi,%eax
  10139b:	29 d0                	sub    %edx,%eax
  10139d:	66 89 83 b4 05 00 00 	mov    %ax,0x5b4(%ebx)
        break;
  1013a4:	eb 27                	jmp    1013cd <cga_putc+0xf5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1013a6:	8b 8b b0 05 00 00    	mov    0x5b0(%ebx),%ecx
  1013ac:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  1013b3:	8d 50 01             	lea    0x1(%eax),%edx
  1013b6:	66 89 93 b4 05 00 00 	mov    %dx,0x5b4(%ebx)
  1013bd:	0f b7 c0             	movzwl %ax,%eax
  1013c0:	01 c0                	add    %eax,%eax
  1013c2:	01 c8                	add    %ecx,%eax
  1013c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1013c7:	66 89 10             	mov    %dx,(%eax)
        break;
  1013ca:	eb 01                	jmp    1013cd <cga_putc+0xf5>
        break;
  1013cc:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1013cd:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  1013d4:	66 3d cf 07          	cmp    $0x7cf,%ax
  1013d8:	76 5d                	jbe    101437 <cga_putc+0x15f>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1013da:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  1013e0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1013e6:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  1013ec:	83 ec 04             	sub    $0x4,%esp
  1013ef:	68 00 0f 00 00       	push   $0xf00
  1013f4:	52                   	push   %edx
  1013f5:	50                   	push   %eax
  1013f6:	e8 97 1d 00 00       	call   103192 <memmove>
  1013fb:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1013fe:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101405:	eb 16                	jmp    10141d <cga_putc+0x145>
            crt_buf[i] = 0x0700 | ' ';
  101407:	8b 83 b0 05 00 00    	mov    0x5b0(%ebx),%eax
  10140d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101410:	01 d2                	add    %edx,%edx
  101412:	01 d0                	add    %edx,%eax
  101414:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101419:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10141d:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101424:	7e e1                	jle    101407 <cga_putc+0x12f>
        }
        crt_pos -= CRT_COLS;
  101426:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  10142d:	83 e8 50             	sub    $0x50,%eax
  101430:	66 89 83 b4 05 00 00 	mov    %ax,0x5b4(%ebx)
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101437:	0f b7 83 b6 05 00 00 	movzwl 0x5b6(%ebx),%eax
  10143e:	0f b7 c0             	movzwl %ax,%eax
  101441:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101445:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  101449:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10144d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101451:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101452:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  101459:	66 c1 e8 08          	shr    $0x8,%ax
  10145d:	0f b6 c0             	movzbl %al,%eax
  101460:	0f b7 93 b6 05 00 00 	movzwl 0x5b6(%ebx),%edx
  101467:	83 c2 01             	add    $0x1,%edx
  10146a:	0f b7 d2             	movzwl %dx,%edx
  10146d:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101471:	88 45 e9             	mov    %al,-0x17(%ebp)
  101474:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101478:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10147c:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10147d:	0f b7 83 b6 05 00 00 	movzwl 0x5b6(%ebx),%eax
  101484:	0f b7 c0             	movzwl %ax,%eax
  101487:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10148b:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  10148f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101493:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101497:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101498:	0f b7 83 b4 05 00 00 	movzwl 0x5b4(%ebx),%eax
  10149f:	0f b6 c0             	movzbl %al,%eax
  1014a2:	0f b7 93 b6 05 00 00 	movzwl 0x5b6(%ebx),%edx
  1014a9:	83 c2 01             	add    $0x1,%edx
  1014ac:	0f b7 d2             	movzwl %dx,%edx
  1014af:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1014b3:	88 45 f1             	mov    %al,-0xf(%ebp)
  1014b6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1014ba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1014be:	ee                   	out    %al,(%dx)
}
  1014bf:	90                   	nop
  1014c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1014c3:	5b                   	pop    %ebx
  1014c4:	5e                   	pop    %esi
  1014c5:	5d                   	pop    %ebp
  1014c6:	c3                   	ret    

001014c7 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1014c7:	55                   	push   %ebp
  1014c8:	89 e5                	mov    %esp,%ebp
  1014ca:	83 ec 10             	sub    $0x10,%esp
  1014cd:	e8 aa ed ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1014d2:	05 7e d4 00 00       	add    $0xd47e,%eax
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1014d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1014de:	eb 09                	jmp    1014e9 <serial_putc_sub+0x22>
        delay();
  1014e0:	e8 ef fa ff ff       	call   100fd4 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1014e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1014e9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014ef:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1014f3:	89 c2                	mov    %eax,%edx
  1014f5:	ec                   	in     (%dx),%al
  1014f6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1014f9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1014fd:	0f b6 c0             	movzbl %al,%eax
  101500:	83 e0 20             	and    $0x20,%eax
  101503:	85 c0                	test   %eax,%eax
  101505:	75 09                	jne    101510 <serial_putc_sub+0x49>
  101507:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10150e:	7e d0                	jle    1014e0 <serial_putc_sub+0x19>
    }
    outb(COM1 + COM_TX, c);
  101510:	8b 45 08             	mov    0x8(%ebp),%eax
  101513:	0f b6 c0             	movzbl %al,%eax
  101516:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10151c:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10151f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101523:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101527:	ee                   	out    %al,(%dx)
}
  101528:	90                   	nop
  101529:	c9                   	leave  
  10152a:	c3                   	ret    

0010152b <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10152b:	55                   	push   %ebp
  10152c:	89 e5                	mov    %esp,%ebp
  10152e:	e8 49 ed ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101533:	05 1d d4 00 00       	add    $0xd41d,%eax
    if (c != '\b') {
  101538:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10153c:	74 0d                	je     10154b <serial_putc+0x20>
        serial_putc_sub(c);
  10153e:	ff 75 08             	pushl  0x8(%ebp)
  101541:	e8 81 ff ff ff       	call   1014c7 <serial_putc_sub>
  101546:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101549:	eb 1e                	jmp    101569 <serial_putc+0x3e>
        serial_putc_sub('\b');
  10154b:	6a 08                	push   $0x8
  10154d:	e8 75 ff ff ff       	call   1014c7 <serial_putc_sub>
  101552:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101555:	6a 20                	push   $0x20
  101557:	e8 6b ff ff ff       	call   1014c7 <serial_putc_sub>
  10155c:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  10155f:	6a 08                	push   $0x8
  101561:	e8 61 ff ff ff       	call   1014c7 <serial_putc_sub>
  101566:	83 c4 04             	add    $0x4,%esp
}
  101569:	90                   	nop
  10156a:	c9                   	leave  
  10156b:	c3                   	ret    

0010156c <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10156c:	55                   	push   %ebp
  10156d:	89 e5                	mov    %esp,%ebp
  10156f:	53                   	push   %ebx
  101570:	83 ec 14             	sub    $0x14,%esp
  101573:	e8 08 ed ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  101578:	81 c3 d8 d3 00 00    	add    $0xd3d8,%ebx
    int c;
    while ((c = (*proc)()) != -1) {
  10157e:	eb 36                	jmp    1015b6 <cons_intr+0x4a>
        if (c != 0) {
  101580:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101584:	74 30                	je     1015b6 <cons_intr+0x4a>
            cons.buf[cons.wpos ++] = c;
  101586:	8b 83 d4 07 00 00    	mov    0x7d4(%ebx),%eax
  10158c:	8d 50 01             	lea    0x1(%eax),%edx
  10158f:	89 93 d4 07 00 00    	mov    %edx,0x7d4(%ebx)
  101595:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101598:	88 94 03 d0 05 00 00 	mov    %dl,0x5d0(%ebx,%eax,1)
            if (cons.wpos == CONSBUFSIZE) {
  10159f:	8b 83 d4 07 00 00    	mov    0x7d4(%ebx),%eax
  1015a5:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015aa:	75 0a                	jne    1015b6 <cons_intr+0x4a>
                cons.wpos = 0;
  1015ac:	c7 83 d4 07 00 00 00 	movl   $0x0,0x7d4(%ebx)
  1015b3:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b9:	ff d0                	call   *%eax
  1015bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1015be:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1015c2:	75 bc                	jne    101580 <cons_intr+0x14>
            }
        }
    }
}
  1015c4:	90                   	nop
  1015c5:	83 c4 14             	add    $0x14,%esp
  1015c8:	5b                   	pop    %ebx
  1015c9:	5d                   	pop    %ebp
  1015ca:	c3                   	ret    

001015cb <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1015cb:	55                   	push   %ebp
  1015cc:	89 e5                	mov    %esp,%ebp
  1015ce:	83 ec 10             	sub    $0x10,%esp
  1015d1:	e8 a6 ec ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1015d6:	05 7a d3 00 00       	add    $0xd37a,%eax
  1015db:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1015e1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1015e5:	89 c2                	mov    %eax,%edx
  1015e7:	ec                   	in     (%dx),%al
  1015e8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1015eb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1015ef:	0f b6 c0             	movzbl %al,%eax
  1015f2:	83 e0 01             	and    $0x1,%eax
  1015f5:	85 c0                	test   %eax,%eax
  1015f7:	75 07                	jne    101600 <serial_proc_data+0x35>
        return -1;
  1015f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1015fe:	eb 2a                	jmp    10162a <serial_proc_data+0x5f>
  101600:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101606:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10160a:	89 c2                	mov    %eax,%edx
  10160c:	ec                   	in     (%dx),%al
  10160d:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101610:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101614:	0f b6 c0             	movzbl %al,%eax
  101617:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10161a:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10161e:	75 07                	jne    101627 <serial_proc_data+0x5c>
        c = '\b';
  101620:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101627:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10162a:	c9                   	leave  
  10162b:	c3                   	ret    

0010162c <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10162c:	55                   	push   %ebp
  10162d:	89 e5                	mov    %esp,%ebp
  10162f:	83 ec 08             	sub    $0x8,%esp
  101632:	e8 45 ec ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101637:	05 19 d3 00 00       	add    $0xd319,%eax
    if (serial_exists) {
  10163c:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  101642:	85 d2                	test   %edx,%edx
  101644:	74 12                	je     101658 <serial_intr+0x2c>
        cons_intr(serial_proc_data);
  101646:	83 ec 0c             	sub    $0xc,%esp
  101649:	8d 80 7b 2c ff ff    	lea    -0xd385(%eax),%eax
  10164f:	50                   	push   %eax
  101650:	e8 17 ff ff ff       	call   10156c <cons_intr>
  101655:	83 c4 10             	add    $0x10,%esp
    }
}
  101658:	90                   	nop
  101659:	c9                   	leave  
  10165a:	c3                   	ret    

0010165b <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10165b:	55                   	push   %ebp
  10165c:	89 e5                	mov    %esp,%ebp
  10165e:	53                   	push   %ebx
  10165f:	83 ec 24             	sub    $0x24,%esp
  101662:	e8 e2 02 00 00       	call   101949 <__x86.get_pc_thunk.cx>
  101667:	81 c1 e9 d2 00 00    	add    $0xd2e9,%ecx
  10166d:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101673:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101677:	89 c2                	mov    %eax,%edx
  101679:	ec                   	in     (%dx),%al
  10167a:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10167d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101681:	0f b6 c0             	movzbl %al,%eax
  101684:	83 e0 01             	and    $0x1,%eax
  101687:	85 c0                	test   %eax,%eax
  101689:	75 0a                	jne    101695 <kbd_proc_data+0x3a>
        return -1;
  10168b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101690:	e9 73 01 00 00       	jmp    101808 <kbd_proc_data+0x1ad>
  101695:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10169b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10169f:	89 c2                	mov    %eax,%edx
  1016a1:	ec                   	in     (%dx),%al
  1016a2:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1016a5:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1016a9:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1016ac:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1016b0:	75 19                	jne    1016cb <kbd_proc_data+0x70>
        // E0 escape character
        shift |= E0ESC;
  1016b2:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  1016b8:	83 c8 40             	or     $0x40,%eax
  1016bb:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)
        return 0;
  1016c1:	b8 00 00 00 00       	mov    $0x0,%eax
  1016c6:	e9 3d 01 00 00       	jmp    101808 <kbd_proc_data+0x1ad>
    } else if (data & 0x80) {
  1016cb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1016cf:	84 c0                	test   %al,%al
  1016d1:	79 4b                	jns    10171e <kbd_proc_data+0xc3>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1016d3:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  1016d9:	83 e0 40             	and    $0x40,%eax
  1016dc:	85 c0                	test   %eax,%eax
  1016de:	75 09                	jne    1016e9 <kbd_proc_data+0x8e>
  1016e0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1016e4:	83 e0 7f             	and    $0x7f,%eax
  1016e7:	eb 04                	jmp    1016ed <kbd_proc_data+0x92>
  1016e9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1016ed:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1016f0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1016f4:	0f b6 84 01 b0 f6 ff 	movzbl -0x950(%ecx,%eax,1),%eax
  1016fb:	ff 
  1016fc:	83 c8 40             	or     $0x40,%eax
  1016ff:	0f b6 c0             	movzbl %al,%eax
  101702:	f7 d0                	not    %eax
  101704:	89 c2                	mov    %eax,%edx
  101706:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  10170c:	21 d0                	and    %edx,%eax
  10170e:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)
        return 0;
  101714:	b8 00 00 00 00       	mov    $0x0,%eax
  101719:	e9 ea 00 00 00       	jmp    101808 <kbd_proc_data+0x1ad>
    } else if (shift & E0ESC) {
  10171e:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  101724:	83 e0 40             	and    $0x40,%eax
  101727:	85 c0                	test   %eax,%eax
  101729:	74 13                	je     10173e <kbd_proc_data+0xe3>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10172b:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10172f:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  101735:	83 e0 bf             	and    $0xffffffbf,%eax
  101738:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)
    }

    shift |= shiftcode[data];
  10173e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101742:	0f b6 84 01 b0 f6 ff 	movzbl -0x950(%ecx,%eax,1),%eax
  101749:	ff 
  10174a:	0f b6 d0             	movzbl %al,%edx
  10174d:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  101753:	09 d0                	or     %edx,%eax
  101755:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)
    shift ^= togglecode[data];
  10175b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10175f:	0f b6 84 01 b0 f7 ff 	movzbl -0x850(%ecx,%eax,1),%eax
  101766:	ff 
  101767:	0f b6 d0             	movzbl %al,%edx
  10176a:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  101770:	31 d0                	xor    %edx,%eax
  101772:	89 81 d8 07 00 00    	mov    %eax,0x7d8(%ecx)

    c = charcode[shift & (CTL | SHIFT)][data];
  101778:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  10177e:	83 e0 03             	and    $0x3,%eax
  101781:	8b 94 81 34 00 00 00 	mov    0x34(%ecx,%eax,4),%edx
  101788:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10178c:	01 d0                	add    %edx,%eax
  10178e:	0f b6 00             	movzbl (%eax),%eax
  101791:	0f b6 c0             	movzbl %al,%eax
  101794:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101797:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  10179d:	83 e0 08             	and    $0x8,%eax
  1017a0:	85 c0                	test   %eax,%eax
  1017a2:	74 22                	je     1017c6 <kbd_proc_data+0x16b>
        if ('a' <= c && c <= 'z')
  1017a4:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1017a8:	7e 0c                	jle    1017b6 <kbd_proc_data+0x15b>
  1017aa:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1017ae:	7f 06                	jg     1017b6 <kbd_proc_data+0x15b>
            c += 'A' - 'a';
  1017b0:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1017b4:	eb 10                	jmp    1017c6 <kbd_proc_data+0x16b>
        else if ('A' <= c && c <= 'Z')
  1017b6:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1017ba:	7e 0a                	jle    1017c6 <kbd_proc_data+0x16b>
  1017bc:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1017c0:	7f 04                	jg     1017c6 <kbd_proc_data+0x16b>
            c += 'a' - 'A';
  1017c2:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1017c6:	8b 81 d8 07 00 00    	mov    0x7d8(%ecx),%eax
  1017cc:	f7 d0                	not    %eax
  1017ce:	83 e0 06             	and    $0x6,%eax
  1017d1:	85 c0                	test   %eax,%eax
  1017d3:	75 30                	jne    101805 <kbd_proc_data+0x1aa>
  1017d5:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1017dc:	75 27                	jne    101805 <kbd_proc_data+0x1aa>
        cprintf("Rebooting!\n");
  1017de:	83 ec 0c             	sub    $0xc,%esp
  1017e1:	8d 81 41 53 ff ff    	lea    -0xacbf(%ecx),%eax
  1017e7:	50                   	push   %eax
  1017e8:	89 cb                	mov    %ecx,%ebx
  1017ea:	e8 04 eb ff ff       	call   1002f3 <cprintf>
  1017ef:	83 c4 10             	add    $0x10,%esp
  1017f2:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1017f8:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017fc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101800:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101804:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101805:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10180b:	c9                   	leave  
  10180c:	c3                   	ret    

0010180d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10180d:	55                   	push   %ebp
  10180e:	89 e5                	mov    %esp,%ebp
  101810:	83 ec 08             	sub    $0x8,%esp
  101813:	e8 64 ea ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101818:	05 38 d1 00 00       	add    $0xd138,%eax
    cons_intr(kbd_proc_data);
  10181d:	83 ec 0c             	sub    $0xc,%esp
  101820:	8d 80 0b 2d ff ff    	lea    -0xd2f5(%eax),%eax
  101826:	50                   	push   %eax
  101827:	e8 40 fd ff ff       	call   10156c <cons_intr>
  10182c:	83 c4 10             	add    $0x10,%esp
}
  10182f:	90                   	nop
  101830:	c9                   	leave  
  101831:	c3                   	ret    

00101832 <kbd_init>:

static void
kbd_init(void) {
  101832:	55                   	push   %ebp
  101833:	89 e5                	mov    %esp,%ebp
  101835:	53                   	push   %ebx
  101836:	83 ec 04             	sub    $0x4,%esp
  101839:	e8 42 ea ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  10183e:	81 c3 12 d1 00 00    	add    $0xd112,%ebx
    // drain the kbd buffer
    kbd_intr();
  101844:	e8 c4 ff ff ff       	call   10180d <kbd_intr>
    pic_enable(IRQ_KBD);
  101849:	83 ec 0c             	sub    $0xc,%esp
  10184c:	6a 01                	push   $0x1
  10184e:	e8 5f 01 00 00       	call   1019b2 <pic_enable>
  101853:	83 c4 10             	add    $0x10,%esp
}
  101856:	90                   	nop
  101857:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10185a:	c9                   	leave  
  10185b:	c3                   	ret    

0010185c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10185c:	55                   	push   %ebp
  10185d:	89 e5                	mov    %esp,%ebp
  10185f:	53                   	push   %ebx
  101860:	83 ec 04             	sub    $0x4,%esp
  101863:	e8 18 ea ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  101868:	81 c3 e8 d0 00 00    	add    $0xd0e8,%ebx
    cga_init();
  10186e:	e8 b4 f7 ff ff       	call   101027 <cga_init>
    serial_init();
  101873:	e8 a3 f8 ff ff       	call   10111b <serial_init>
    kbd_init();
  101878:	e8 b5 ff ff ff       	call   101832 <kbd_init>
    if (!serial_exists) {
  10187d:	8b 83 b8 05 00 00    	mov    0x5b8(%ebx),%eax
  101883:	85 c0                	test   %eax,%eax
  101885:	75 12                	jne    101899 <cons_init+0x3d>
        cprintf("serial port does not exist!!\n");
  101887:	83 ec 0c             	sub    $0xc,%esp
  10188a:	8d 83 4d 53 ff ff    	lea    -0xacb3(%ebx),%eax
  101890:	50                   	push   %eax
  101891:	e8 5d ea ff ff       	call   1002f3 <cprintf>
  101896:	83 c4 10             	add    $0x10,%esp
    }
}
  101899:	90                   	nop
  10189a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10189d:	c9                   	leave  
  10189e:	c3                   	ret    

0010189f <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10189f:	55                   	push   %ebp
  1018a0:	89 e5                	mov    %esp,%ebp
  1018a2:	83 ec 08             	sub    $0x8,%esp
  1018a5:	e8 d2 e9 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1018aa:	05 a6 d0 00 00       	add    $0xd0a6,%eax
    lpt_putc(c);
  1018af:	ff 75 08             	pushl  0x8(%ebp)
  1018b2:	e8 e0 f9 ff ff       	call   101297 <lpt_putc>
  1018b7:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1018ba:	83 ec 0c             	sub    $0xc,%esp
  1018bd:	ff 75 08             	pushl  0x8(%ebp)
  1018c0:	e8 13 fa ff ff       	call   1012d8 <cga_putc>
  1018c5:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1018c8:	83 ec 0c             	sub    $0xc,%esp
  1018cb:	ff 75 08             	pushl  0x8(%ebp)
  1018ce:	e8 58 fc ff ff       	call   10152b <serial_putc>
  1018d3:	83 c4 10             	add    $0x10,%esp
}
  1018d6:	90                   	nop
  1018d7:	c9                   	leave  
  1018d8:	c3                   	ret    

001018d9 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1018d9:	55                   	push   %ebp
  1018da:	89 e5                	mov    %esp,%ebp
  1018dc:	53                   	push   %ebx
  1018dd:	83 ec 14             	sub    $0x14,%esp
  1018e0:	e8 9b e9 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  1018e5:	81 c3 6b d0 00 00    	add    $0xd06b,%ebx
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1018eb:	e8 3c fd ff ff       	call   10162c <serial_intr>
    kbd_intr();
  1018f0:	e8 18 ff ff ff       	call   10180d <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1018f5:	8b 93 d0 07 00 00    	mov    0x7d0(%ebx),%edx
  1018fb:	8b 83 d4 07 00 00    	mov    0x7d4(%ebx),%eax
  101901:	39 c2                	cmp    %eax,%edx
  101903:	74 39                	je     10193e <cons_getc+0x65>
        c = cons.buf[cons.rpos ++];
  101905:	8b 83 d0 07 00 00    	mov    0x7d0(%ebx),%eax
  10190b:	8d 50 01             	lea    0x1(%eax),%edx
  10190e:	89 93 d0 07 00 00    	mov    %edx,0x7d0(%ebx)
  101914:	0f b6 84 03 d0 05 00 	movzbl 0x5d0(%ebx,%eax,1),%eax
  10191b:	00 
  10191c:	0f b6 c0             	movzbl %al,%eax
  10191f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101922:	8b 83 d0 07 00 00    	mov    0x7d0(%ebx),%eax
  101928:	3d 00 02 00 00       	cmp    $0x200,%eax
  10192d:	75 0a                	jne    101939 <cons_getc+0x60>
            cons.rpos = 0;
  10192f:	c7 83 d0 07 00 00 00 	movl   $0x0,0x7d0(%ebx)
  101936:	00 00 00 
        }
        return c;
  101939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10193c:	eb 05                	jmp    101943 <cons_getc+0x6a>
    }
    return 0;
  10193e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101943:	83 c4 14             	add    $0x14,%esp
  101946:	5b                   	pop    %ebx
  101947:	5d                   	pop    %ebp
  101948:	c3                   	ret    

00101949 <__x86.get_pc_thunk.cx>:
  101949:	8b 0c 24             	mov    (%esp),%ecx
  10194c:	c3                   	ret    

0010194d <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10194d:	55                   	push   %ebp
  10194e:	89 e5                	mov    %esp,%ebp
  101950:	83 ec 14             	sub    $0x14,%esp
  101953:	e8 24 e9 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101958:	05 f8 cf 00 00       	add    $0xcff8,%eax
  10195d:	8b 55 08             	mov    0x8(%ebp),%edx
  101960:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
    irq_mask = mask;
  101964:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101968:	66 89 90 b0 fb ff ff 	mov    %dx,-0x450(%eax)
    if (did_init) {
  10196f:	8b 80 dc 07 00 00    	mov    0x7dc(%eax),%eax
  101975:	85 c0                	test   %eax,%eax
  101977:	74 36                	je     1019af <pic_setmask+0x62>
        outb(IO_PIC1 + 1, mask);
  101979:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10197d:	0f b6 c0             	movzbl %al,%eax
  101980:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101986:	88 45 f9             	mov    %al,-0x7(%ebp)
  101989:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10198d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101991:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101992:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101996:	66 c1 e8 08          	shr    $0x8,%ax
  10199a:	0f b6 c0             	movzbl %al,%eax
  10199d:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1019a3:	88 45 fd             	mov    %al,-0x3(%ebp)
  1019a6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1019aa:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1019ae:	ee                   	out    %al,(%dx)
    }
}
  1019af:	90                   	nop
  1019b0:	c9                   	leave  
  1019b1:	c3                   	ret    

001019b2 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1019b2:	55                   	push   %ebp
  1019b3:	89 e5                	mov    %esp,%ebp
  1019b5:	53                   	push   %ebx
  1019b6:	e8 c1 e8 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1019bb:	05 95 cf 00 00       	add    $0xcf95,%eax
    pic_setmask(irq_mask & ~(1 << irq));
  1019c0:	8b 55 08             	mov    0x8(%ebp),%edx
  1019c3:	bb 01 00 00 00       	mov    $0x1,%ebx
  1019c8:	89 d1                	mov    %edx,%ecx
  1019ca:	d3 e3                	shl    %cl,%ebx
  1019cc:	89 da                	mov    %ebx,%edx
  1019ce:	f7 d2                	not    %edx
  1019d0:	0f b7 80 b0 fb ff ff 	movzwl -0x450(%eax),%eax
  1019d7:	21 d0                	and    %edx,%eax
  1019d9:	0f b7 c0             	movzwl %ax,%eax
  1019dc:	50                   	push   %eax
  1019dd:	e8 6b ff ff ff       	call   10194d <pic_setmask>
  1019e2:	83 c4 04             	add    $0x4,%esp
}
  1019e5:	90                   	nop
  1019e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1019e9:	c9                   	leave  
  1019ea:	c3                   	ret    

001019eb <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1019eb:	55                   	push   %ebp
  1019ec:	89 e5                	mov    %esp,%ebp
  1019ee:	83 ec 40             	sub    $0x40,%esp
  1019f1:	e8 53 ff ff ff       	call   101949 <__x86.get_pc_thunk.cx>
  1019f6:	81 c1 5a cf 00 00    	add    $0xcf5a,%ecx
    did_init = 1;
  1019fc:	c7 81 dc 07 00 00 01 	movl   $0x1,0x7dc(%ecx)
  101a03:	00 00 00 
  101a06:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101a0c:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  101a10:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101a14:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101a18:	ee                   	out    %al,(%dx)
  101a19:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101a1f:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  101a23:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101a27:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101a2b:	ee                   	out    %al,(%dx)
  101a2c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101a32:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  101a36:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101a3a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101a3e:	ee                   	out    %al,(%dx)
  101a3f:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101a45:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101a49:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101a4d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101a51:	ee                   	out    %al,(%dx)
  101a52:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101a58:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101a5c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101a60:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101a64:	ee                   	out    %al,(%dx)
  101a65:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101a6b:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  101a6f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101a73:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101a77:	ee                   	out    %al,(%dx)
  101a78:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101a7e:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  101a82:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101a86:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101a8a:	ee                   	out    %al,(%dx)
  101a8b:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101a91:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101a95:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101a99:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101a9d:	ee                   	out    %al,(%dx)
  101a9e:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101aa4:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101aa8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101aac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101ab0:	ee                   	out    %al,(%dx)
  101ab1:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101ab7:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101abb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101abf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101ac3:	ee                   	out    %al,(%dx)
  101ac4:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101aca:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101ace:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101ad2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101ad6:	ee                   	out    %al,(%dx)
  101ad7:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101add:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  101ae1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101ae5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101ae9:	ee                   	out    %al,(%dx)
  101aea:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101af0:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101af4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101af8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101afc:	ee                   	out    %al,(%dx)
  101afd:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101b03:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101b07:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101b0b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101b0f:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101b10:	0f b7 81 b0 fb ff ff 	movzwl -0x450(%ecx),%eax
  101b17:	66 83 f8 ff          	cmp    $0xffff,%ax
  101b1b:	74 13                	je     101b30 <pic_init+0x145>
        pic_setmask(irq_mask);
  101b1d:	0f b7 81 b0 fb ff ff 	movzwl -0x450(%ecx),%eax
  101b24:	0f b7 c0             	movzwl %ax,%eax
  101b27:	50                   	push   %eax
  101b28:	e8 20 fe ff ff       	call   10194d <pic_setmask>
  101b2d:	83 c4 04             	add    $0x4,%esp
    }
}
  101b30:	90                   	nop
  101b31:	c9                   	leave  
  101b32:	c3                   	ret    

00101b33 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101b33:	55                   	push   %ebp
  101b34:	89 e5                	mov    %esp,%ebp
  101b36:	e8 41 e7 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101b3b:	05 15 ce 00 00       	add    $0xce15,%eax
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101b40:	fb                   	sti    
    sti();
}
  101b41:	90                   	nop
  101b42:	5d                   	pop    %ebp
  101b43:	c3                   	ret    

00101b44 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101b44:	55                   	push   %ebp
  101b45:	89 e5                	mov    %esp,%ebp
  101b47:	e8 30 e7 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101b4c:	05 04 ce 00 00       	add    $0xce04,%eax
}

static inline void
cli(void) {
    asm volatile ("cli");
  101b51:	fa                   	cli    
    cli();
}
  101b52:	90                   	nop
  101b53:	5d                   	pop    %ebp
  101b54:	c3                   	ret    

00101b55 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101b55:	55                   	push   %ebp
  101b56:	89 e5                	mov    %esp,%ebp
  101b58:	53                   	push   %ebx
  101b59:	83 ec 04             	sub    $0x4,%esp
  101b5c:	e8 1b e7 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101b61:	05 ef cd 00 00       	add    $0xcdef,%eax
    cprintf("%d ticks\n",TICK_NUM);
  101b66:	83 ec 08             	sub    $0x8,%esp
  101b69:	6a 64                	push   $0x64
  101b6b:	8d 90 6b 53 ff ff    	lea    -0xac95(%eax),%edx
  101b71:	52                   	push   %edx
  101b72:	89 c3                	mov    %eax,%ebx
  101b74:	e8 7a e7 ff ff       	call   1002f3 <cprintf>
  101b79:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101b7c:	90                   	nop
  101b7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101b80:	c9                   	leave  
  101b81:	c3                   	ret    

00101b82 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101b82:	55                   	push   %ebp
  101b83:	89 e5                	mov    %esp,%ebp
  101b85:	83 ec 10             	sub    $0x10,%esp
  101b88:	e8 ef e6 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101b8d:	05 c3 cd 00 00       	add    $0xcdc3,%eax
      */

    extern uintptr_t __vectors[];

    int i;
    for (i = 0; i < 256; i++) {
  101b92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101b99:	e9 c7 00 00 00       	jmp    101c65 <idt_init+0xe3>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101b9e:	c7 c2 02 e5 10 00    	mov    $0x10e502,%edx
  101ba4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  101ba7:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
  101baa:	89 d1                	mov    %edx,%ecx
  101bac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101baf:	66 89 8c d0 f0 07 00 	mov    %cx,0x7f0(%eax,%edx,8)
  101bb6:	00 
  101bb7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101bba:	66 c7 84 d0 f2 07 00 	movw   $0x8,0x7f2(%eax,%edx,8)
  101bc1:	00 08 00 
  101bc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101bc7:	0f b6 8c d0 f4 07 00 	movzbl 0x7f4(%eax,%edx,8),%ecx
  101bce:	00 
  101bcf:	83 e1 e0             	and    $0xffffffe0,%ecx
  101bd2:	88 8c d0 f4 07 00 00 	mov    %cl,0x7f4(%eax,%edx,8)
  101bd9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101bdc:	0f b6 8c d0 f4 07 00 	movzbl 0x7f4(%eax,%edx,8),%ecx
  101be3:	00 
  101be4:	83 e1 1f             	and    $0x1f,%ecx
  101be7:	88 8c d0 f4 07 00 00 	mov    %cl,0x7f4(%eax,%edx,8)
  101bee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101bf1:	0f b6 8c d0 f5 07 00 	movzbl 0x7f5(%eax,%edx,8),%ecx
  101bf8:	00 
  101bf9:	83 e1 f0             	and    $0xfffffff0,%ecx
  101bfc:	83 c9 0e             	or     $0xe,%ecx
  101bff:	88 8c d0 f5 07 00 00 	mov    %cl,0x7f5(%eax,%edx,8)
  101c06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101c09:	0f b6 8c d0 f5 07 00 	movzbl 0x7f5(%eax,%edx,8),%ecx
  101c10:	00 
  101c11:	83 e1 ef             	and    $0xffffffef,%ecx
  101c14:	88 8c d0 f5 07 00 00 	mov    %cl,0x7f5(%eax,%edx,8)
  101c1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101c1e:	0f b6 8c d0 f5 07 00 	movzbl 0x7f5(%eax,%edx,8),%ecx
  101c25:	00 
  101c26:	83 e1 9f             	and    $0xffffff9f,%ecx
  101c29:	88 8c d0 f5 07 00 00 	mov    %cl,0x7f5(%eax,%edx,8)
  101c30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101c33:	0f b6 8c d0 f5 07 00 	movzbl 0x7f5(%eax,%edx,8),%ecx
  101c3a:	00 
  101c3b:	83 c9 80             	or     $0xffffff80,%ecx
  101c3e:	88 8c d0 f5 07 00 00 	mov    %cl,0x7f5(%eax,%edx,8)
  101c45:	c7 c2 02 e5 10 00    	mov    $0x10e502,%edx
  101c4b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  101c4e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
  101c51:	c1 ea 10             	shr    $0x10,%edx
  101c54:	89 d1                	mov    %edx,%ecx
  101c56:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101c59:	66 89 8c d0 f6 07 00 	mov    %cx,0x7f6(%eax,%edx,8)
  101c60:	00 
    for (i = 0; i < 256; i++) {
  101c61:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101c65:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101c6c:	0f 8e 2c ff ff ff    	jle    101b9e <idt_init+0x1c>
    }
    SETGATE(idt[T_SWITCH_TOK], 1, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101c72:	c7 c2 02 e5 10 00    	mov    $0x10e502,%edx
  101c78:	8b 92 e4 01 00 00    	mov    0x1e4(%edx),%edx
  101c7e:	66 89 90 b8 0b 00 00 	mov    %dx,0xbb8(%eax)
  101c85:	66 c7 80 ba 0b 00 00 	movw   $0x8,0xbba(%eax)
  101c8c:	08 00 
  101c8e:	0f b6 90 bc 0b 00 00 	movzbl 0xbbc(%eax),%edx
  101c95:	83 e2 e0             	and    $0xffffffe0,%edx
  101c98:	88 90 bc 0b 00 00    	mov    %dl,0xbbc(%eax)
  101c9e:	0f b6 90 bc 0b 00 00 	movzbl 0xbbc(%eax),%edx
  101ca5:	83 e2 1f             	and    $0x1f,%edx
  101ca8:	88 90 bc 0b 00 00    	mov    %dl,0xbbc(%eax)
  101cae:	0f b6 90 bd 0b 00 00 	movzbl 0xbbd(%eax),%edx
  101cb5:	83 ca 0f             	or     $0xf,%edx
  101cb8:	88 90 bd 0b 00 00    	mov    %dl,0xbbd(%eax)
  101cbe:	0f b6 90 bd 0b 00 00 	movzbl 0xbbd(%eax),%edx
  101cc5:	83 e2 ef             	and    $0xffffffef,%edx
  101cc8:	88 90 bd 0b 00 00    	mov    %dl,0xbbd(%eax)
  101cce:	0f b6 90 bd 0b 00 00 	movzbl 0xbbd(%eax),%edx
  101cd5:	83 ca 60             	or     $0x60,%edx
  101cd8:	88 90 bd 0b 00 00    	mov    %dl,0xbbd(%eax)
  101cde:	0f b6 90 bd 0b 00 00 	movzbl 0xbbd(%eax),%edx
  101ce5:	83 ca 80             	or     $0xffffff80,%edx
  101ce8:	88 90 bd 0b 00 00    	mov    %dl,0xbbd(%eax)
  101cee:	c7 c2 02 e5 10 00    	mov    $0x10e502,%edx
  101cf4:	8b 92 e4 01 00 00    	mov    0x1e4(%edx),%edx
  101cfa:	c1 ea 10             	shr    $0x10,%edx
  101cfd:	66 89 90 be 0b 00 00 	mov    %dx,0xbbe(%eax)
  101d04:	8d 80 50 00 00 00    	lea    0x50(%eax),%eax
  101d0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101d0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101d10:	0f 01 18             	lidtl  (%eax)

    lidt(&idt_pd);
}
  101d13:	90                   	nop
  101d14:	c9                   	leave  
  101d15:	c3                   	ret    

00101d16 <trapname>:

static const char *
trapname(int trapno) {
  101d16:	55                   	push   %ebp
  101d17:	89 e5                	mov    %esp,%ebp
  101d19:	e8 5e e5 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101d1e:	05 32 cc 00 00       	add    $0xcc32,%eax
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101d23:	8b 55 08             	mov    0x8(%ebp),%edx
  101d26:	83 fa 13             	cmp    $0x13,%edx
  101d29:	77 0c                	ja     101d37 <trapname+0x21>
        return excnames[trapno];
  101d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  101d2e:	8b 84 90 f0 00 00 00 	mov    0xf0(%eax,%edx,4),%eax
  101d35:	eb 1a                	jmp    101d51 <trapname+0x3b>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101d37:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101d3b:	7e 0e                	jle    101d4b <trapname+0x35>
  101d3d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101d41:	7f 08                	jg     101d4b <trapname+0x35>
        return "Hardware Interrupt";
  101d43:	8d 80 75 53 ff ff    	lea    -0xac8b(%eax),%eax
  101d49:	eb 06                	jmp    101d51 <trapname+0x3b>
    }
    return "(unknown trap)";
  101d4b:	8d 80 88 53 ff ff    	lea    -0xac78(%eax),%eax
}
  101d51:	5d                   	pop    %ebp
  101d52:	c3                   	ret    

00101d53 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101d53:	55                   	push   %ebp
  101d54:	89 e5                	mov    %esp,%ebp
  101d56:	e8 21 e5 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  101d5b:	05 f5 cb 00 00       	add    $0xcbf5,%eax
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101d60:	8b 45 08             	mov    0x8(%ebp),%eax
  101d63:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d67:	66 83 f8 08          	cmp    $0x8,%ax
  101d6b:	0f 94 c0             	sete   %al
  101d6e:	0f b6 c0             	movzbl %al,%eax
}
  101d71:	5d                   	pop    %ebp
  101d72:	c3                   	ret    

00101d73 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101d73:	55                   	push   %ebp
  101d74:	89 e5                	mov    %esp,%ebp
  101d76:	53                   	push   %ebx
  101d77:	83 ec 14             	sub    $0x14,%esp
  101d7a:	e8 01 e5 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  101d7f:	81 c3 d1 cb 00 00    	add    $0xcbd1,%ebx
    cprintf("trapframe at %p\n", tf);
  101d85:	83 ec 08             	sub    $0x8,%esp
  101d88:	ff 75 08             	pushl  0x8(%ebp)
  101d8b:	8d 83 c9 53 ff ff    	lea    -0xac37(%ebx),%eax
  101d91:	50                   	push   %eax
  101d92:	e8 5c e5 ff ff       	call   1002f3 <cprintf>
  101d97:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9d:	83 ec 0c             	sub    $0xc,%esp
  101da0:	50                   	push   %eax
  101da1:	e8 d3 01 00 00       	call   101f79 <print_regs>
  101da6:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101da9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dac:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101db0:	0f b7 c0             	movzwl %ax,%eax
  101db3:	83 ec 08             	sub    $0x8,%esp
  101db6:	50                   	push   %eax
  101db7:	8d 83 da 53 ff ff    	lea    -0xac26(%ebx),%eax
  101dbd:	50                   	push   %eax
  101dbe:	e8 30 e5 ff ff       	call   1002f3 <cprintf>
  101dc3:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc9:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101dcd:	0f b7 c0             	movzwl %ax,%eax
  101dd0:	83 ec 08             	sub    $0x8,%esp
  101dd3:	50                   	push   %eax
  101dd4:	8d 83 ed 53 ff ff    	lea    -0xac13(%ebx),%eax
  101dda:	50                   	push   %eax
  101ddb:	e8 13 e5 ff ff       	call   1002f3 <cprintf>
  101de0:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101de3:	8b 45 08             	mov    0x8(%ebp),%eax
  101de6:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101dea:	0f b7 c0             	movzwl %ax,%eax
  101ded:	83 ec 08             	sub    $0x8,%esp
  101df0:	50                   	push   %eax
  101df1:	8d 83 00 54 ff ff    	lea    -0xac00(%ebx),%eax
  101df7:	50                   	push   %eax
  101df8:	e8 f6 e4 ff ff       	call   1002f3 <cprintf>
  101dfd:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101e00:	8b 45 08             	mov    0x8(%ebp),%eax
  101e03:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101e07:	0f b7 c0             	movzwl %ax,%eax
  101e0a:	83 ec 08             	sub    $0x8,%esp
  101e0d:	50                   	push   %eax
  101e0e:	8d 83 13 54 ff ff    	lea    -0xabed(%ebx),%eax
  101e14:	50                   	push   %eax
  101e15:	e8 d9 e4 ff ff       	call   1002f3 <cprintf>
  101e1a:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e20:	8b 40 30             	mov    0x30(%eax),%eax
  101e23:	83 ec 0c             	sub    $0xc,%esp
  101e26:	50                   	push   %eax
  101e27:	e8 ea fe ff ff       	call   101d16 <trapname>
  101e2c:	83 c4 10             	add    $0x10,%esp
  101e2f:	89 c2                	mov    %eax,%edx
  101e31:	8b 45 08             	mov    0x8(%ebp),%eax
  101e34:	8b 40 30             	mov    0x30(%eax),%eax
  101e37:	83 ec 04             	sub    $0x4,%esp
  101e3a:	52                   	push   %edx
  101e3b:	50                   	push   %eax
  101e3c:	8d 83 26 54 ff ff    	lea    -0xabda(%ebx),%eax
  101e42:	50                   	push   %eax
  101e43:	e8 ab e4 ff ff       	call   1002f3 <cprintf>
  101e48:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4e:	8b 40 34             	mov    0x34(%eax),%eax
  101e51:	83 ec 08             	sub    $0x8,%esp
  101e54:	50                   	push   %eax
  101e55:	8d 83 38 54 ff ff    	lea    -0xabc8(%ebx),%eax
  101e5b:	50                   	push   %eax
  101e5c:	e8 92 e4 ff ff       	call   1002f3 <cprintf>
  101e61:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101e64:	8b 45 08             	mov    0x8(%ebp),%eax
  101e67:	8b 40 38             	mov    0x38(%eax),%eax
  101e6a:	83 ec 08             	sub    $0x8,%esp
  101e6d:	50                   	push   %eax
  101e6e:	8d 83 47 54 ff ff    	lea    -0xabb9(%ebx),%eax
  101e74:	50                   	push   %eax
  101e75:	e8 79 e4 ff ff       	call   1002f3 <cprintf>
  101e7a:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e80:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e84:	0f b7 c0             	movzwl %ax,%eax
  101e87:	83 ec 08             	sub    $0x8,%esp
  101e8a:	50                   	push   %eax
  101e8b:	8d 83 56 54 ff ff    	lea    -0xabaa(%ebx),%eax
  101e91:	50                   	push   %eax
  101e92:	e8 5c e4 ff ff       	call   1002f3 <cprintf>
  101e97:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9d:	8b 40 40             	mov    0x40(%eax),%eax
  101ea0:	83 ec 08             	sub    $0x8,%esp
  101ea3:	50                   	push   %eax
  101ea4:	8d 83 69 54 ff ff    	lea    -0xab97(%ebx),%eax
  101eaa:	50                   	push   %eax
  101eab:	e8 43 e4 ff ff       	call   1002f3 <cprintf>
  101eb0:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101eb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101eba:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ec1:	eb 41                	jmp    101f04 <print_trapframe+0x191>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec6:	8b 50 40             	mov    0x40(%eax),%edx
  101ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ecc:	21 d0                	and    %edx,%eax
  101ece:	85 c0                	test   %eax,%eax
  101ed0:	74 2b                	je     101efd <print_trapframe+0x18a>
  101ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ed5:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
  101edc:	85 c0                	test   %eax,%eax
  101ede:	74 1d                	je     101efd <print_trapframe+0x18a>
            cprintf("%s,", IA32flags[i]);
  101ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ee3:	8b 84 83 70 00 00 00 	mov    0x70(%ebx,%eax,4),%eax
  101eea:	83 ec 08             	sub    $0x8,%esp
  101eed:	50                   	push   %eax
  101eee:	8d 83 78 54 ff ff    	lea    -0xab88(%ebx),%eax
  101ef4:	50                   	push   %eax
  101ef5:	e8 f9 e3 ff ff       	call   1002f3 <cprintf>
  101efa:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101efd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101f01:	d1 65 f0             	shll   -0x10(%ebp)
  101f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f07:	83 f8 17             	cmp    $0x17,%eax
  101f0a:	76 b7                	jbe    101ec3 <print_trapframe+0x150>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0f:	8b 40 40             	mov    0x40(%eax),%eax
  101f12:	c1 e8 0c             	shr    $0xc,%eax
  101f15:	83 e0 03             	and    $0x3,%eax
  101f18:	83 ec 08             	sub    $0x8,%esp
  101f1b:	50                   	push   %eax
  101f1c:	8d 83 7c 54 ff ff    	lea    -0xab84(%ebx),%eax
  101f22:	50                   	push   %eax
  101f23:	e8 cb e3 ff ff       	call   1002f3 <cprintf>
  101f28:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101f2b:	83 ec 0c             	sub    $0xc,%esp
  101f2e:	ff 75 08             	pushl  0x8(%ebp)
  101f31:	e8 1d fe ff ff       	call   101d53 <trap_in_kernel>
  101f36:	83 c4 10             	add    $0x10,%esp
  101f39:	85 c0                	test   %eax,%eax
  101f3b:	75 36                	jne    101f73 <print_trapframe+0x200>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f40:	8b 40 44             	mov    0x44(%eax),%eax
  101f43:	83 ec 08             	sub    $0x8,%esp
  101f46:	50                   	push   %eax
  101f47:	8d 83 85 54 ff ff    	lea    -0xab7b(%ebx),%eax
  101f4d:	50                   	push   %eax
  101f4e:	e8 a0 e3 ff ff       	call   1002f3 <cprintf>
  101f53:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101f56:	8b 45 08             	mov    0x8(%ebp),%eax
  101f59:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101f5d:	0f b7 c0             	movzwl %ax,%eax
  101f60:	83 ec 08             	sub    $0x8,%esp
  101f63:	50                   	push   %eax
  101f64:	8d 83 94 54 ff ff    	lea    -0xab6c(%ebx),%eax
  101f6a:	50                   	push   %eax
  101f6b:	e8 83 e3 ff ff       	call   1002f3 <cprintf>
  101f70:	83 c4 10             	add    $0x10,%esp
    }
}
  101f73:	90                   	nop
  101f74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101f77:	c9                   	leave  
  101f78:	c3                   	ret    

00101f79 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101f79:	55                   	push   %ebp
  101f7a:	89 e5                	mov    %esp,%ebp
  101f7c:	53                   	push   %ebx
  101f7d:	83 ec 04             	sub    $0x4,%esp
  101f80:	e8 fb e2 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  101f85:	81 c3 cb c9 00 00    	add    $0xc9cb,%ebx
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8e:	8b 00                	mov    (%eax),%eax
  101f90:	83 ec 08             	sub    $0x8,%esp
  101f93:	50                   	push   %eax
  101f94:	8d 83 a7 54 ff ff    	lea    -0xab59(%ebx),%eax
  101f9a:	50                   	push   %eax
  101f9b:	e8 53 e3 ff ff       	call   1002f3 <cprintf>
  101fa0:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa6:	8b 40 04             	mov    0x4(%eax),%eax
  101fa9:	83 ec 08             	sub    $0x8,%esp
  101fac:	50                   	push   %eax
  101fad:	8d 83 b6 54 ff ff    	lea    -0xab4a(%ebx),%eax
  101fb3:	50                   	push   %eax
  101fb4:	e8 3a e3 ff ff       	call   1002f3 <cprintf>
  101fb9:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101fbf:	8b 40 08             	mov    0x8(%eax),%eax
  101fc2:	83 ec 08             	sub    $0x8,%esp
  101fc5:	50                   	push   %eax
  101fc6:	8d 83 c5 54 ff ff    	lea    -0xab3b(%ebx),%eax
  101fcc:	50                   	push   %eax
  101fcd:	e8 21 e3 ff ff       	call   1002f3 <cprintf>
  101fd2:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd8:	8b 40 0c             	mov    0xc(%eax),%eax
  101fdb:	83 ec 08             	sub    $0x8,%esp
  101fde:	50                   	push   %eax
  101fdf:	8d 83 d4 54 ff ff    	lea    -0xab2c(%ebx),%eax
  101fe5:	50                   	push   %eax
  101fe6:	e8 08 e3 ff ff       	call   1002f3 <cprintf>
  101feb:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101fee:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff1:	8b 40 10             	mov    0x10(%eax),%eax
  101ff4:	83 ec 08             	sub    $0x8,%esp
  101ff7:	50                   	push   %eax
  101ff8:	8d 83 e3 54 ff ff    	lea    -0xab1d(%ebx),%eax
  101ffe:	50                   	push   %eax
  101fff:	e8 ef e2 ff ff       	call   1002f3 <cprintf>
  102004:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  102007:	8b 45 08             	mov    0x8(%ebp),%eax
  10200a:	8b 40 14             	mov    0x14(%eax),%eax
  10200d:	83 ec 08             	sub    $0x8,%esp
  102010:	50                   	push   %eax
  102011:	8d 83 f2 54 ff ff    	lea    -0xab0e(%ebx),%eax
  102017:	50                   	push   %eax
  102018:	e8 d6 e2 ff ff       	call   1002f3 <cprintf>
  10201d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  102020:	8b 45 08             	mov    0x8(%ebp),%eax
  102023:	8b 40 18             	mov    0x18(%eax),%eax
  102026:	83 ec 08             	sub    $0x8,%esp
  102029:	50                   	push   %eax
  10202a:	8d 83 01 55 ff ff    	lea    -0xaaff(%ebx),%eax
  102030:	50                   	push   %eax
  102031:	e8 bd e2 ff ff       	call   1002f3 <cprintf>
  102036:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  102039:	8b 45 08             	mov    0x8(%ebp),%eax
  10203c:	8b 40 1c             	mov    0x1c(%eax),%eax
  10203f:	83 ec 08             	sub    $0x8,%esp
  102042:	50                   	push   %eax
  102043:	8d 83 10 55 ff ff    	lea    -0xaaf0(%ebx),%eax
  102049:	50                   	push   %eax
  10204a:	e8 a4 e2 ff ff       	call   1002f3 <cprintf>
  10204f:	83 c4 10             	add    $0x10,%esp
}
  102052:	90                   	nop
  102053:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102056:	c9                   	leave  
  102057:	c3                   	ret    

00102058 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  102058:	55                   	push   %ebp
  102059:	89 e5                	mov    %esp,%ebp
  10205b:	53                   	push   %ebx
  10205c:	83 ec 14             	sub    $0x14,%esp
  10205f:	e8 1c e2 ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  102064:	81 c3 ec c8 00 00    	add    $0xc8ec,%ebx
    char c;

    switch (tf->tf_trapno) {
  10206a:	8b 45 08             	mov    0x8(%ebp),%eax
  10206d:	8b 40 30             	mov    0x30(%eax),%eax
  102070:	83 f8 2f             	cmp    $0x2f,%eax
  102073:	77 21                	ja     102096 <trap_dispatch+0x3e>
  102075:	83 f8 2e             	cmp    $0x2e,%eax
  102078:	0f 83 0c 01 00 00    	jae    10218a <trap_dispatch+0x132>
  10207e:	83 f8 21             	cmp    $0x21,%eax
  102081:	0f 84 88 00 00 00    	je     10210f <trap_dispatch+0xb7>
  102087:	83 f8 24             	cmp    $0x24,%eax
  10208a:	74 5d                	je     1020e9 <trap_dispatch+0x91>
  10208c:	83 f8 20             	cmp    $0x20,%eax
  10208f:	74 16                	je     1020a7 <trap_dispatch+0x4f>
  102091:	e9 ba 00 00 00       	jmp    102150 <trap_dispatch+0xf8>
  102096:	83 e8 78             	sub    $0x78,%eax
  102099:	83 f8 01             	cmp    $0x1,%eax
  10209c:	0f 87 ae 00 00 00    	ja     102150 <trap_dispatch+0xf8>
  1020a2:	e9 8e 00 00 00       	jmp    102135 <trap_dispatch+0xdd>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  1020a7:	c7 c0 a8 f9 10 00    	mov    $0x10f9a8,%eax
  1020ad:	8b 00                	mov    (%eax),%eax
  1020af:	8d 50 01             	lea    0x1(%eax),%edx
  1020b2:	c7 c0 a8 f9 10 00    	mov    $0x10f9a8,%eax
  1020b8:	89 10                	mov    %edx,(%eax)
        if (ticks % TICK_NUM == 0) {
  1020ba:	c7 c0 a8 f9 10 00    	mov    $0x10f9a8,%eax
  1020c0:	8b 08                	mov    (%eax),%ecx
  1020c2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  1020c7:	89 c8                	mov    %ecx,%eax
  1020c9:	f7 e2                	mul    %edx
  1020cb:	89 d0                	mov    %edx,%eax
  1020cd:	c1 e8 05             	shr    $0x5,%eax
  1020d0:	6b c0 64             	imul   $0x64,%eax,%eax
  1020d3:	29 c1                	sub    %eax,%ecx
  1020d5:	89 c8                	mov    %ecx,%eax
  1020d7:	85 c0                	test   %eax,%eax
  1020d9:	0f 85 ae 00 00 00    	jne    10218d <trap_dispatch+0x135>
            print_ticks();
  1020df:	e8 71 fa ff ff       	call   101b55 <print_ticks>
        }
        
        break;
  1020e4:	e9 a4 00 00 00       	jmp    10218d <trap_dispatch+0x135>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  1020e9:	e8 eb f7 ff ff       	call   1018d9 <cons_getc>
  1020ee:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  1020f1:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  1020f5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1020f9:	83 ec 04             	sub    $0x4,%esp
  1020fc:	52                   	push   %edx
  1020fd:	50                   	push   %eax
  1020fe:	8d 83 1f 55 ff ff    	lea    -0xaae1(%ebx),%eax
  102104:	50                   	push   %eax
  102105:	e8 e9 e1 ff ff       	call   1002f3 <cprintf>
  10210a:	83 c4 10             	add    $0x10,%esp
        break;
  10210d:	eb 7f                	jmp    10218e <trap_dispatch+0x136>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  10210f:	e8 c5 f7 ff ff       	call   1018d9 <cons_getc>
  102114:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  102117:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  10211b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10211f:	83 ec 04             	sub    $0x4,%esp
  102122:	52                   	push   %edx
  102123:	50                   	push   %eax
  102124:	8d 83 31 55 ff ff    	lea    -0xaacf(%ebx),%eax
  10212a:	50                   	push   %eax
  10212b:	e8 c3 e1 ff ff       	call   1002f3 <cprintf>
  102130:	83 c4 10             	add    $0x10,%esp
        break;
  102133:	eb 59                	jmp    10218e <trap_dispatch+0x136>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  102135:	83 ec 04             	sub    $0x4,%esp
  102138:	8d 83 40 55 ff ff    	lea    -0xaac0(%ebx),%eax
  10213e:	50                   	push   %eax
  10213f:	68 b1 00 00 00       	push   $0xb1
  102144:	8d 83 50 55 ff ff    	lea    -0xaab0(%ebx),%eax
  10214a:	50                   	push   %eax
  10214b:	e8 53 e3 ff ff       	call   1004a3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  102150:	8b 45 08             	mov    0x8(%ebp),%eax
  102153:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102157:	0f b7 c0             	movzwl %ax,%eax
  10215a:	83 e0 03             	and    $0x3,%eax
  10215d:	85 c0                	test   %eax,%eax
  10215f:	75 2d                	jne    10218e <trap_dispatch+0x136>
            print_trapframe(tf);
  102161:	83 ec 0c             	sub    $0xc,%esp
  102164:	ff 75 08             	pushl  0x8(%ebp)
  102167:	e8 07 fc ff ff       	call   101d73 <print_trapframe>
  10216c:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  10216f:	83 ec 04             	sub    $0x4,%esp
  102172:	8d 83 61 55 ff ff    	lea    -0xaa9f(%ebx),%eax
  102178:	50                   	push   %eax
  102179:	68 bb 00 00 00       	push   $0xbb
  10217e:	8d 83 50 55 ff ff    	lea    -0xaab0(%ebx),%eax
  102184:	50                   	push   %eax
  102185:	e8 19 e3 ff ff       	call   1004a3 <__panic>
        break;
  10218a:	90                   	nop
  10218b:	eb 01                	jmp    10218e <trap_dispatch+0x136>
        break;
  10218d:	90                   	nop
        }
    }
}
  10218e:	90                   	nop
  10218f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102192:	c9                   	leave  
  102193:	c3                   	ret    

00102194 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102194:	55                   	push   %ebp
  102195:	89 e5                	mov    %esp,%ebp
  102197:	83 ec 08             	sub    $0x8,%esp
  10219a:	e8 dd e0 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10219f:	05 b1 c7 00 00       	add    $0xc7b1,%eax
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  1021a4:	83 ec 0c             	sub    $0xc,%esp
  1021a7:	ff 75 08             	pushl  0x8(%ebp)
  1021aa:	e8 a9 fe ff ff       	call   102058 <trap_dispatch>
  1021af:	83 c4 10             	add    $0x10,%esp
}
  1021b2:	90                   	nop
  1021b3:	c9                   	leave  
  1021b4:	c3                   	ret    

001021b5 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $0
  1021b7:	6a 00                	push   $0x0
  jmp __alltraps
  1021b9:	e9 67 0a 00 00       	jmp    102c25 <__alltraps>

001021be <vector1>:
.globl vector1
vector1:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $1
  1021c0:	6a 01                	push   $0x1
  jmp __alltraps
  1021c2:	e9 5e 0a 00 00       	jmp    102c25 <__alltraps>

001021c7 <vector2>:
.globl vector2
vector2:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $2
  1021c9:	6a 02                	push   $0x2
  jmp __alltraps
  1021cb:	e9 55 0a 00 00       	jmp    102c25 <__alltraps>

001021d0 <vector3>:
.globl vector3
vector3:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $3
  1021d2:	6a 03                	push   $0x3
  jmp __alltraps
  1021d4:	e9 4c 0a 00 00       	jmp    102c25 <__alltraps>

001021d9 <vector4>:
.globl vector4
vector4:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $4
  1021db:	6a 04                	push   $0x4
  jmp __alltraps
  1021dd:	e9 43 0a 00 00       	jmp    102c25 <__alltraps>

001021e2 <vector5>:
.globl vector5
vector5:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $5
  1021e4:	6a 05                	push   $0x5
  jmp __alltraps
  1021e6:	e9 3a 0a 00 00       	jmp    102c25 <__alltraps>

001021eb <vector6>:
.globl vector6
vector6:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $6
  1021ed:	6a 06                	push   $0x6
  jmp __alltraps
  1021ef:	e9 31 0a 00 00       	jmp    102c25 <__alltraps>

001021f4 <vector7>:
.globl vector7
vector7:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $7
  1021f6:	6a 07                	push   $0x7
  jmp __alltraps
  1021f8:	e9 28 0a 00 00       	jmp    102c25 <__alltraps>

001021fd <vector8>:
.globl vector8
vector8:
  pushl $8
  1021fd:	6a 08                	push   $0x8
  jmp __alltraps
  1021ff:	e9 21 0a 00 00       	jmp    102c25 <__alltraps>

00102204 <vector9>:
.globl vector9
vector9:
  pushl $9
  102204:	6a 09                	push   $0x9
  jmp __alltraps
  102206:	e9 1a 0a 00 00       	jmp    102c25 <__alltraps>

0010220b <vector10>:
.globl vector10
vector10:
  pushl $10
  10220b:	6a 0a                	push   $0xa
  jmp __alltraps
  10220d:	e9 13 0a 00 00       	jmp    102c25 <__alltraps>

00102212 <vector11>:
.globl vector11
vector11:
  pushl $11
  102212:	6a 0b                	push   $0xb
  jmp __alltraps
  102214:	e9 0c 0a 00 00       	jmp    102c25 <__alltraps>

00102219 <vector12>:
.globl vector12
vector12:
  pushl $12
  102219:	6a 0c                	push   $0xc
  jmp __alltraps
  10221b:	e9 05 0a 00 00       	jmp    102c25 <__alltraps>

00102220 <vector13>:
.globl vector13
vector13:
  pushl $13
  102220:	6a 0d                	push   $0xd
  jmp __alltraps
  102222:	e9 fe 09 00 00       	jmp    102c25 <__alltraps>

00102227 <vector14>:
.globl vector14
vector14:
  pushl $14
  102227:	6a 0e                	push   $0xe
  jmp __alltraps
  102229:	e9 f7 09 00 00       	jmp    102c25 <__alltraps>

0010222e <vector15>:
.globl vector15
vector15:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $15
  102230:	6a 0f                	push   $0xf
  jmp __alltraps
  102232:	e9 ee 09 00 00       	jmp    102c25 <__alltraps>

00102237 <vector16>:
.globl vector16
vector16:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $16
  102239:	6a 10                	push   $0x10
  jmp __alltraps
  10223b:	e9 e5 09 00 00       	jmp    102c25 <__alltraps>

00102240 <vector17>:
.globl vector17
vector17:
  pushl $17
  102240:	6a 11                	push   $0x11
  jmp __alltraps
  102242:	e9 de 09 00 00       	jmp    102c25 <__alltraps>

00102247 <vector18>:
.globl vector18
vector18:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $18
  102249:	6a 12                	push   $0x12
  jmp __alltraps
  10224b:	e9 d5 09 00 00       	jmp    102c25 <__alltraps>

00102250 <vector19>:
.globl vector19
vector19:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $19
  102252:	6a 13                	push   $0x13
  jmp __alltraps
  102254:	e9 cc 09 00 00       	jmp    102c25 <__alltraps>

00102259 <vector20>:
.globl vector20
vector20:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $20
  10225b:	6a 14                	push   $0x14
  jmp __alltraps
  10225d:	e9 c3 09 00 00       	jmp    102c25 <__alltraps>

00102262 <vector21>:
.globl vector21
vector21:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $21
  102264:	6a 15                	push   $0x15
  jmp __alltraps
  102266:	e9 ba 09 00 00       	jmp    102c25 <__alltraps>

0010226b <vector22>:
.globl vector22
vector22:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $22
  10226d:	6a 16                	push   $0x16
  jmp __alltraps
  10226f:	e9 b1 09 00 00       	jmp    102c25 <__alltraps>

00102274 <vector23>:
.globl vector23
vector23:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $23
  102276:	6a 17                	push   $0x17
  jmp __alltraps
  102278:	e9 a8 09 00 00       	jmp    102c25 <__alltraps>

0010227d <vector24>:
.globl vector24
vector24:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $24
  10227f:	6a 18                	push   $0x18
  jmp __alltraps
  102281:	e9 9f 09 00 00       	jmp    102c25 <__alltraps>

00102286 <vector25>:
.globl vector25
vector25:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $25
  102288:	6a 19                	push   $0x19
  jmp __alltraps
  10228a:	e9 96 09 00 00       	jmp    102c25 <__alltraps>

0010228f <vector26>:
.globl vector26
vector26:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $26
  102291:	6a 1a                	push   $0x1a
  jmp __alltraps
  102293:	e9 8d 09 00 00       	jmp    102c25 <__alltraps>

00102298 <vector27>:
.globl vector27
vector27:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $27
  10229a:	6a 1b                	push   $0x1b
  jmp __alltraps
  10229c:	e9 84 09 00 00       	jmp    102c25 <__alltraps>

001022a1 <vector28>:
.globl vector28
vector28:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $28
  1022a3:	6a 1c                	push   $0x1c
  jmp __alltraps
  1022a5:	e9 7b 09 00 00       	jmp    102c25 <__alltraps>

001022aa <vector29>:
.globl vector29
vector29:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $29
  1022ac:	6a 1d                	push   $0x1d
  jmp __alltraps
  1022ae:	e9 72 09 00 00       	jmp    102c25 <__alltraps>

001022b3 <vector30>:
.globl vector30
vector30:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $30
  1022b5:	6a 1e                	push   $0x1e
  jmp __alltraps
  1022b7:	e9 69 09 00 00       	jmp    102c25 <__alltraps>

001022bc <vector31>:
.globl vector31
vector31:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $31
  1022be:	6a 1f                	push   $0x1f
  jmp __alltraps
  1022c0:	e9 60 09 00 00       	jmp    102c25 <__alltraps>

001022c5 <vector32>:
.globl vector32
vector32:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $32
  1022c7:	6a 20                	push   $0x20
  jmp __alltraps
  1022c9:	e9 57 09 00 00       	jmp    102c25 <__alltraps>

001022ce <vector33>:
.globl vector33
vector33:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $33
  1022d0:	6a 21                	push   $0x21
  jmp __alltraps
  1022d2:	e9 4e 09 00 00       	jmp    102c25 <__alltraps>

001022d7 <vector34>:
.globl vector34
vector34:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $34
  1022d9:	6a 22                	push   $0x22
  jmp __alltraps
  1022db:	e9 45 09 00 00       	jmp    102c25 <__alltraps>

001022e0 <vector35>:
.globl vector35
vector35:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $35
  1022e2:	6a 23                	push   $0x23
  jmp __alltraps
  1022e4:	e9 3c 09 00 00       	jmp    102c25 <__alltraps>

001022e9 <vector36>:
.globl vector36
vector36:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $36
  1022eb:	6a 24                	push   $0x24
  jmp __alltraps
  1022ed:	e9 33 09 00 00       	jmp    102c25 <__alltraps>

001022f2 <vector37>:
.globl vector37
vector37:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $37
  1022f4:	6a 25                	push   $0x25
  jmp __alltraps
  1022f6:	e9 2a 09 00 00       	jmp    102c25 <__alltraps>

001022fb <vector38>:
.globl vector38
vector38:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $38
  1022fd:	6a 26                	push   $0x26
  jmp __alltraps
  1022ff:	e9 21 09 00 00       	jmp    102c25 <__alltraps>

00102304 <vector39>:
.globl vector39
vector39:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $39
  102306:	6a 27                	push   $0x27
  jmp __alltraps
  102308:	e9 18 09 00 00       	jmp    102c25 <__alltraps>

0010230d <vector40>:
.globl vector40
vector40:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $40
  10230f:	6a 28                	push   $0x28
  jmp __alltraps
  102311:	e9 0f 09 00 00       	jmp    102c25 <__alltraps>

00102316 <vector41>:
.globl vector41
vector41:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $41
  102318:	6a 29                	push   $0x29
  jmp __alltraps
  10231a:	e9 06 09 00 00       	jmp    102c25 <__alltraps>

0010231f <vector42>:
.globl vector42
vector42:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $42
  102321:	6a 2a                	push   $0x2a
  jmp __alltraps
  102323:	e9 fd 08 00 00       	jmp    102c25 <__alltraps>

00102328 <vector43>:
.globl vector43
vector43:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $43
  10232a:	6a 2b                	push   $0x2b
  jmp __alltraps
  10232c:	e9 f4 08 00 00       	jmp    102c25 <__alltraps>

00102331 <vector44>:
.globl vector44
vector44:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $44
  102333:	6a 2c                	push   $0x2c
  jmp __alltraps
  102335:	e9 eb 08 00 00       	jmp    102c25 <__alltraps>

0010233a <vector45>:
.globl vector45
vector45:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $45
  10233c:	6a 2d                	push   $0x2d
  jmp __alltraps
  10233e:	e9 e2 08 00 00       	jmp    102c25 <__alltraps>

00102343 <vector46>:
.globl vector46
vector46:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $46
  102345:	6a 2e                	push   $0x2e
  jmp __alltraps
  102347:	e9 d9 08 00 00       	jmp    102c25 <__alltraps>

0010234c <vector47>:
.globl vector47
vector47:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $47
  10234e:	6a 2f                	push   $0x2f
  jmp __alltraps
  102350:	e9 d0 08 00 00       	jmp    102c25 <__alltraps>

00102355 <vector48>:
.globl vector48
vector48:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $48
  102357:	6a 30                	push   $0x30
  jmp __alltraps
  102359:	e9 c7 08 00 00       	jmp    102c25 <__alltraps>

0010235e <vector49>:
.globl vector49
vector49:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $49
  102360:	6a 31                	push   $0x31
  jmp __alltraps
  102362:	e9 be 08 00 00       	jmp    102c25 <__alltraps>

00102367 <vector50>:
.globl vector50
vector50:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $50
  102369:	6a 32                	push   $0x32
  jmp __alltraps
  10236b:	e9 b5 08 00 00       	jmp    102c25 <__alltraps>

00102370 <vector51>:
.globl vector51
vector51:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $51
  102372:	6a 33                	push   $0x33
  jmp __alltraps
  102374:	e9 ac 08 00 00       	jmp    102c25 <__alltraps>

00102379 <vector52>:
.globl vector52
vector52:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $52
  10237b:	6a 34                	push   $0x34
  jmp __alltraps
  10237d:	e9 a3 08 00 00       	jmp    102c25 <__alltraps>

00102382 <vector53>:
.globl vector53
vector53:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $53
  102384:	6a 35                	push   $0x35
  jmp __alltraps
  102386:	e9 9a 08 00 00       	jmp    102c25 <__alltraps>

0010238b <vector54>:
.globl vector54
vector54:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $54
  10238d:	6a 36                	push   $0x36
  jmp __alltraps
  10238f:	e9 91 08 00 00       	jmp    102c25 <__alltraps>

00102394 <vector55>:
.globl vector55
vector55:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $55
  102396:	6a 37                	push   $0x37
  jmp __alltraps
  102398:	e9 88 08 00 00       	jmp    102c25 <__alltraps>

0010239d <vector56>:
.globl vector56
vector56:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $56
  10239f:	6a 38                	push   $0x38
  jmp __alltraps
  1023a1:	e9 7f 08 00 00       	jmp    102c25 <__alltraps>

001023a6 <vector57>:
.globl vector57
vector57:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $57
  1023a8:	6a 39                	push   $0x39
  jmp __alltraps
  1023aa:	e9 76 08 00 00       	jmp    102c25 <__alltraps>

001023af <vector58>:
.globl vector58
vector58:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $58
  1023b1:	6a 3a                	push   $0x3a
  jmp __alltraps
  1023b3:	e9 6d 08 00 00       	jmp    102c25 <__alltraps>

001023b8 <vector59>:
.globl vector59
vector59:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $59
  1023ba:	6a 3b                	push   $0x3b
  jmp __alltraps
  1023bc:	e9 64 08 00 00       	jmp    102c25 <__alltraps>

001023c1 <vector60>:
.globl vector60
vector60:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $60
  1023c3:	6a 3c                	push   $0x3c
  jmp __alltraps
  1023c5:	e9 5b 08 00 00       	jmp    102c25 <__alltraps>

001023ca <vector61>:
.globl vector61
vector61:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $61
  1023cc:	6a 3d                	push   $0x3d
  jmp __alltraps
  1023ce:	e9 52 08 00 00       	jmp    102c25 <__alltraps>

001023d3 <vector62>:
.globl vector62
vector62:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $62
  1023d5:	6a 3e                	push   $0x3e
  jmp __alltraps
  1023d7:	e9 49 08 00 00       	jmp    102c25 <__alltraps>

001023dc <vector63>:
.globl vector63
vector63:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $63
  1023de:	6a 3f                	push   $0x3f
  jmp __alltraps
  1023e0:	e9 40 08 00 00       	jmp    102c25 <__alltraps>

001023e5 <vector64>:
.globl vector64
vector64:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $64
  1023e7:	6a 40                	push   $0x40
  jmp __alltraps
  1023e9:	e9 37 08 00 00       	jmp    102c25 <__alltraps>

001023ee <vector65>:
.globl vector65
vector65:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $65
  1023f0:	6a 41                	push   $0x41
  jmp __alltraps
  1023f2:	e9 2e 08 00 00       	jmp    102c25 <__alltraps>

001023f7 <vector66>:
.globl vector66
vector66:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $66
  1023f9:	6a 42                	push   $0x42
  jmp __alltraps
  1023fb:	e9 25 08 00 00       	jmp    102c25 <__alltraps>

00102400 <vector67>:
.globl vector67
vector67:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $67
  102402:	6a 43                	push   $0x43
  jmp __alltraps
  102404:	e9 1c 08 00 00       	jmp    102c25 <__alltraps>

00102409 <vector68>:
.globl vector68
vector68:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $68
  10240b:	6a 44                	push   $0x44
  jmp __alltraps
  10240d:	e9 13 08 00 00       	jmp    102c25 <__alltraps>

00102412 <vector69>:
.globl vector69
vector69:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $69
  102414:	6a 45                	push   $0x45
  jmp __alltraps
  102416:	e9 0a 08 00 00       	jmp    102c25 <__alltraps>

0010241b <vector70>:
.globl vector70
vector70:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $70
  10241d:	6a 46                	push   $0x46
  jmp __alltraps
  10241f:	e9 01 08 00 00       	jmp    102c25 <__alltraps>

00102424 <vector71>:
.globl vector71
vector71:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $71
  102426:	6a 47                	push   $0x47
  jmp __alltraps
  102428:	e9 f8 07 00 00       	jmp    102c25 <__alltraps>

0010242d <vector72>:
.globl vector72
vector72:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $72
  10242f:	6a 48                	push   $0x48
  jmp __alltraps
  102431:	e9 ef 07 00 00       	jmp    102c25 <__alltraps>

00102436 <vector73>:
.globl vector73
vector73:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $73
  102438:	6a 49                	push   $0x49
  jmp __alltraps
  10243a:	e9 e6 07 00 00       	jmp    102c25 <__alltraps>

0010243f <vector74>:
.globl vector74
vector74:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $74
  102441:	6a 4a                	push   $0x4a
  jmp __alltraps
  102443:	e9 dd 07 00 00       	jmp    102c25 <__alltraps>

00102448 <vector75>:
.globl vector75
vector75:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $75
  10244a:	6a 4b                	push   $0x4b
  jmp __alltraps
  10244c:	e9 d4 07 00 00       	jmp    102c25 <__alltraps>

00102451 <vector76>:
.globl vector76
vector76:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $76
  102453:	6a 4c                	push   $0x4c
  jmp __alltraps
  102455:	e9 cb 07 00 00       	jmp    102c25 <__alltraps>

0010245a <vector77>:
.globl vector77
vector77:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $77
  10245c:	6a 4d                	push   $0x4d
  jmp __alltraps
  10245e:	e9 c2 07 00 00       	jmp    102c25 <__alltraps>

00102463 <vector78>:
.globl vector78
vector78:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $78
  102465:	6a 4e                	push   $0x4e
  jmp __alltraps
  102467:	e9 b9 07 00 00       	jmp    102c25 <__alltraps>

0010246c <vector79>:
.globl vector79
vector79:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $79
  10246e:	6a 4f                	push   $0x4f
  jmp __alltraps
  102470:	e9 b0 07 00 00       	jmp    102c25 <__alltraps>

00102475 <vector80>:
.globl vector80
vector80:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $80
  102477:	6a 50                	push   $0x50
  jmp __alltraps
  102479:	e9 a7 07 00 00       	jmp    102c25 <__alltraps>

0010247e <vector81>:
.globl vector81
vector81:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $81
  102480:	6a 51                	push   $0x51
  jmp __alltraps
  102482:	e9 9e 07 00 00       	jmp    102c25 <__alltraps>

00102487 <vector82>:
.globl vector82
vector82:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $82
  102489:	6a 52                	push   $0x52
  jmp __alltraps
  10248b:	e9 95 07 00 00       	jmp    102c25 <__alltraps>

00102490 <vector83>:
.globl vector83
vector83:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $83
  102492:	6a 53                	push   $0x53
  jmp __alltraps
  102494:	e9 8c 07 00 00       	jmp    102c25 <__alltraps>

00102499 <vector84>:
.globl vector84
vector84:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $84
  10249b:	6a 54                	push   $0x54
  jmp __alltraps
  10249d:	e9 83 07 00 00       	jmp    102c25 <__alltraps>

001024a2 <vector85>:
.globl vector85
vector85:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $85
  1024a4:	6a 55                	push   $0x55
  jmp __alltraps
  1024a6:	e9 7a 07 00 00       	jmp    102c25 <__alltraps>

001024ab <vector86>:
.globl vector86
vector86:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $86
  1024ad:	6a 56                	push   $0x56
  jmp __alltraps
  1024af:	e9 71 07 00 00       	jmp    102c25 <__alltraps>

001024b4 <vector87>:
.globl vector87
vector87:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $87
  1024b6:	6a 57                	push   $0x57
  jmp __alltraps
  1024b8:	e9 68 07 00 00       	jmp    102c25 <__alltraps>

001024bd <vector88>:
.globl vector88
vector88:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $88
  1024bf:	6a 58                	push   $0x58
  jmp __alltraps
  1024c1:	e9 5f 07 00 00       	jmp    102c25 <__alltraps>

001024c6 <vector89>:
.globl vector89
vector89:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $89
  1024c8:	6a 59                	push   $0x59
  jmp __alltraps
  1024ca:	e9 56 07 00 00       	jmp    102c25 <__alltraps>

001024cf <vector90>:
.globl vector90
vector90:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $90
  1024d1:	6a 5a                	push   $0x5a
  jmp __alltraps
  1024d3:	e9 4d 07 00 00       	jmp    102c25 <__alltraps>

001024d8 <vector91>:
.globl vector91
vector91:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $91
  1024da:	6a 5b                	push   $0x5b
  jmp __alltraps
  1024dc:	e9 44 07 00 00       	jmp    102c25 <__alltraps>

001024e1 <vector92>:
.globl vector92
vector92:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $92
  1024e3:	6a 5c                	push   $0x5c
  jmp __alltraps
  1024e5:	e9 3b 07 00 00       	jmp    102c25 <__alltraps>

001024ea <vector93>:
.globl vector93
vector93:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $93
  1024ec:	6a 5d                	push   $0x5d
  jmp __alltraps
  1024ee:	e9 32 07 00 00       	jmp    102c25 <__alltraps>

001024f3 <vector94>:
.globl vector94
vector94:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $94
  1024f5:	6a 5e                	push   $0x5e
  jmp __alltraps
  1024f7:	e9 29 07 00 00       	jmp    102c25 <__alltraps>

001024fc <vector95>:
.globl vector95
vector95:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $95
  1024fe:	6a 5f                	push   $0x5f
  jmp __alltraps
  102500:	e9 20 07 00 00       	jmp    102c25 <__alltraps>

00102505 <vector96>:
.globl vector96
vector96:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $96
  102507:	6a 60                	push   $0x60
  jmp __alltraps
  102509:	e9 17 07 00 00       	jmp    102c25 <__alltraps>

0010250e <vector97>:
.globl vector97
vector97:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $97
  102510:	6a 61                	push   $0x61
  jmp __alltraps
  102512:	e9 0e 07 00 00       	jmp    102c25 <__alltraps>

00102517 <vector98>:
.globl vector98
vector98:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $98
  102519:	6a 62                	push   $0x62
  jmp __alltraps
  10251b:	e9 05 07 00 00       	jmp    102c25 <__alltraps>

00102520 <vector99>:
.globl vector99
vector99:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $99
  102522:	6a 63                	push   $0x63
  jmp __alltraps
  102524:	e9 fc 06 00 00       	jmp    102c25 <__alltraps>

00102529 <vector100>:
.globl vector100
vector100:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $100
  10252b:	6a 64                	push   $0x64
  jmp __alltraps
  10252d:	e9 f3 06 00 00       	jmp    102c25 <__alltraps>

00102532 <vector101>:
.globl vector101
vector101:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $101
  102534:	6a 65                	push   $0x65
  jmp __alltraps
  102536:	e9 ea 06 00 00       	jmp    102c25 <__alltraps>

0010253b <vector102>:
.globl vector102
vector102:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $102
  10253d:	6a 66                	push   $0x66
  jmp __alltraps
  10253f:	e9 e1 06 00 00       	jmp    102c25 <__alltraps>

00102544 <vector103>:
.globl vector103
vector103:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $103
  102546:	6a 67                	push   $0x67
  jmp __alltraps
  102548:	e9 d8 06 00 00       	jmp    102c25 <__alltraps>

0010254d <vector104>:
.globl vector104
vector104:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $104
  10254f:	6a 68                	push   $0x68
  jmp __alltraps
  102551:	e9 cf 06 00 00       	jmp    102c25 <__alltraps>

00102556 <vector105>:
.globl vector105
vector105:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $105
  102558:	6a 69                	push   $0x69
  jmp __alltraps
  10255a:	e9 c6 06 00 00       	jmp    102c25 <__alltraps>

0010255f <vector106>:
.globl vector106
vector106:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $106
  102561:	6a 6a                	push   $0x6a
  jmp __alltraps
  102563:	e9 bd 06 00 00       	jmp    102c25 <__alltraps>

00102568 <vector107>:
.globl vector107
vector107:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $107
  10256a:	6a 6b                	push   $0x6b
  jmp __alltraps
  10256c:	e9 b4 06 00 00       	jmp    102c25 <__alltraps>

00102571 <vector108>:
.globl vector108
vector108:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $108
  102573:	6a 6c                	push   $0x6c
  jmp __alltraps
  102575:	e9 ab 06 00 00       	jmp    102c25 <__alltraps>

0010257a <vector109>:
.globl vector109
vector109:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $109
  10257c:	6a 6d                	push   $0x6d
  jmp __alltraps
  10257e:	e9 a2 06 00 00       	jmp    102c25 <__alltraps>

00102583 <vector110>:
.globl vector110
vector110:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $110
  102585:	6a 6e                	push   $0x6e
  jmp __alltraps
  102587:	e9 99 06 00 00       	jmp    102c25 <__alltraps>

0010258c <vector111>:
.globl vector111
vector111:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $111
  10258e:	6a 6f                	push   $0x6f
  jmp __alltraps
  102590:	e9 90 06 00 00       	jmp    102c25 <__alltraps>

00102595 <vector112>:
.globl vector112
vector112:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $112
  102597:	6a 70                	push   $0x70
  jmp __alltraps
  102599:	e9 87 06 00 00       	jmp    102c25 <__alltraps>

0010259e <vector113>:
.globl vector113
vector113:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $113
  1025a0:	6a 71                	push   $0x71
  jmp __alltraps
  1025a2:	e9 7e 06 00 00       	jmp    102c25 <__alltraps>

001025a7 <vector114>:
.globl vector114
vector114:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $114
  1025a9:	6a 72                	push   $0x72
  jmp __alltraps
  1025ab:	e9 75 06 00 00       	jmp    102c25 <__alltraps>

001025b0 <vector115>:
.globl vector115
vector115:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $115
  1025b2:	6a 73                	push   $0x73
  jmp __alltraps
  1025b4:	e9 6c 06 00 00       	jmp    102c25 <__alltraps>

001025b9 <vector116>:
.globl vector116
vector116:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $116
  1025bb:	6a 74                	push   $0x74
  jmp __alltraps
  1025bd:	e9 63 06 00 00       	jmp    102c25 <__alltraps>

001025c2 <vector117>:
.globl vector117
vector117:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $117
  1025c4:	6a 75                	push   $0x75
  jmp __alltraps
  1025c6:	e9 5a 06 00 00       	jmp    102c25 <__alltraps>

001025cb <vector118>:
.globl vector118
vector118:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $118
  1025cd:	6a 76                	push   $0x76
  jmp __alltraps
  1025cf:	e9 51 06 00 00       	jmp    102c25 <__alltraps>

001025d4 <vector119>:
.globl vector119
vector119:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $119
  1025d6:	6a 77                	push   $0x77
  jmp __alltraps
  1025d8:	e9 48 06 00 00       	jmp    102c25 <__alltraps>

001025dd <vector120>:
.globl vector120
vector120:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $120
  1025df:	6a 78                	push   $0x78
  jmp __alltraps
  1025e1:	e9 3f 06 00 00       	jmp    102c25 <__alltraps>

001025e6 <vector121>:
.globl vector121
vector121:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $121
  1025e8:	6a 79                	push   $0x79
  jmp __alltraps
  1025ea:	e9 36 06 00 00       	jmp    102c25 <__alltraps>

001025ef <vector122>:
.globl vector122
vector122:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $122
  1025f1:	6a 7a                	push   $0x7a
  jmp __alltraps
  1025f3:	e9 2d 06 00 00       	jmp    102c25 <__alltraps>

001025f8 <vector123>:
.globl vector123
vector123:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $123
  1025fa:	6a 7b                	push   $0x7b
  jmp __alltraps
  1025fc:	e9 24 06 00 00       	jmp    102c25 <__alltraps>

00102601 <vector124>:
.globl vector124
vector124:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $124
  102603:	6a 7c                	push   $0x7c
  jmp __alltraps
  102605:	e9 1b 06 00 00       	jmp    102c25 <__alltraps>

0010260a <vector125>:
.globl vector125
vector125:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $125
  10260c:	6a 7d                	push   $0x7d
  jmp __alltraps
  10260e:	e9 12 06 00 00       	jmp    102c25 <__alltraps>

00102613 <vector126>:
.globl vector126
vector126:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $126
  102615:	6a 7e                	push   $0x7e
  jmp __alltraps
  102617:	e9 09 06 00 00       	jmp    102c25 <__alltraps>

0010261c <vector127>:
.globl vector127
vector127:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $127
  10261e:	6a 7f                	push   $0x7f
  jmp __alltraps
  102620:	e9 00 06 00 00       	jmp    102c25 <__alltraps>

00102625 <vector128>:
.globl vector128
vector128:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $128
  102627:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10262c:	e9 f4 05 00 00       	jmp    102c25 <__alltraps>

00102631 <vector129>:
.globl vector129
vector129:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $129
  102633:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102638:	e9 e8 05 00 00       	jmp    102c25 <__alltraps>

0010263d <vector130>:
.globl vector130
vector130:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $130
  10263f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102644:	e9 dc 05 00 00       	jmp    102c25 <__alltraps>

00102649 <vector131>:
.globl vector131
vector131:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $131
  10264b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102650:	e9 d0 05 00 00       	jmp    102c25 <__alltraps>

00102655 <vector132>:
.globl vector132
vector132:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $132
  102657:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10265c:	e9 c4 05 00 00       	jmp    102c25 <__alltraps>

00102661 <vector133>:
.globl vector133
vector133:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $133
  102663:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102668:	e9 b8 05 00 00       	jmp    102c25 <__alltraps>

0010266d <vector134>:
.globl vector134
vector134:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $134
  10266f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102674:	e9 ac 05 00 00       	jmp    102c25 <__alltraps>

00102679 <vector135>:
.globl vector135
vector135:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $135
  10267b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102680:	e9 a0 05 00 00       	jmp    102c25 <__alltraps>

00102685 <vector136>:
.globl vector136
vector136:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $136
  102687:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10268c:	e9 94 05 00 00       	jmp    102c25 <__alltraps>

00102691 <vector137>:
.globl vector137
vector137:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $137
  102693:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102698:	e9 88 05 00 00       	jmp    102c25 <__alltraps>

0010269d <vector138>:
.globl vector138
vector138:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $138
  10269f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1026a4:	e9 7c 05 00 00       	jmp    102c25 <__alltraps>

001026a9 <vector139>:
.globl vector139
vector139:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $139
  1026ab:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1026b0:	e9 70 05 00 00       	jmp    102c25 <__alltraps>

001026b5 <vector140>:
.globl vector140
vector140:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $140
  1026b7:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1026bc:	e9 64 05 00 00       	jmp    102c25 <__alltraps>

001026c1 <vector141>:
.globl vector141
vector141:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $141
  1026c3:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1026c8:	e9 58 05 00 00       	jmp    102c25 <__alltraps>

001026cd <vector142>:
.globl vector142
vector142:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $142
  1026cf:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1026d4:	e9 4c 05 00 00       	jmp    102c25 <__alltraps>

001026d9 <vector143>:
.globl vector143
vector143:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $143
  1026db:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1026e0:	e9 40 05 00 00       	jmp    102c25 <__alltraps>

001026e5 <vector144>:
.globl vector144
vector144:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $144
  1026e7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1026ec:	e9 34 05 00 00       	jmp    102c25 <__alltraps>

001026f1 <vector145>:
.globl vector145
vector145:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $145
  1026f3:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1026f8:	e9 28 05 00 00       	jmp    102c25 <__alltraps>

001026fd <vector146>:
.globl vector146
vector146:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $146
  1026ff:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102704:	e9 1c 05 00 00       	jmp    102c25 <__alltraps>

00102709 <vector147>:
.globl vector147
vector147:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $147
  10270b:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102710:	e9 10 05 00 00       	jmp    102c25 <__alltraps>

00102715 <vector148>:
.globl vector148
vector148:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $148
  102717:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10271c:	e9 04 05 00 00       	jmp    102c25 <__alltraps>

00102721 <vector149>:
.globl vector149
vector149:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $149
  102723:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102728:	e9 f8 04 00 00       	jmp    102c25 <__alltraps>

0010272d <vector150>:
.globl vector150
vector150:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $150
  10272f:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102734:	e9 ec 04 00 00       	jmp    102c25 <__alltraps>

00102739 <vector151>:
.globl vector151
vector151:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $151
  10273b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102740:	e9 e0 04 00 00       	jmp    102c25 <__alltraps>

00102745 <vector152>:
.globl vector152
vector152:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $152
  102747:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10274c:	e9 d4 04 00 00       	jmp    102c25 <__alltraps>

00102751 <vector153>:
.globl vector153
vector153:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $153
  102753:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102758:	e9 c8 04 00 00       	jmp    102c25 <__alltraps>

0010275d <vector154>:
.globl vector154
vector154:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $154
  10275f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102764:	e9 bc 04 00 00       	jmp    102c25 <__alltraps>

00102769 <vector155>:
.globl vector155
vector155:
  pushl $0
  102769:	6a 00                	push   $0x0
  pushl $155
  10276b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102770:	e9 b0 04 00 00       	jmp    102c25 <__alltraps>

00102775 <vector156>:
.globl vector156
vector156:
  pushl $0
  102775:	6a 00                	push   $0x0
  pushl $156
  102777:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10277c:	e9 a4 04 00 00       	jmp    102c25 <__alltraps>

00102781 <vector157>:
.globl vector157
vector157:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $157
  102783:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102788:	e9 98 04 00 00       	jmp    102c25 <__alltraps>

0010278d <vector158>:
.globl vector158
vector158:
  pushl $0
  10278d:	6a 00                	push   $0x0
  pushl $158
  10278f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102794:	e9 8c 04 00 00       	jmp    102c25 <__alltraps>

00102799 <vector159>:
.globl vector159
vector159:
  pushl $0
  102799:	6a 00                	push   $0x0
  pushl $159
  10279b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1027a0:	e9 80 04 00 00       	jmp    102c25 <__alltraps>

001027a5 <vector160>:
.globl vector160
vector160:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $160
  1027a7:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1027ac:	e9 74 04 00 00       	jmp    102c25 <__alltraps>

001027b1 <vector161>:
.globl vector161
vector161:
  pushl $0
  1027b1:	6a 00                	push   $0x0
  pushl $161
  1027b3:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1027b8:	e9 68 04 00 00       	jmp    102c25 <__alltraps>

001027bd <vector162>:
.globl vector162
vector162:
  pushl $0
  1027bd:	6a 00                	push   $0x0
  pushl $162
  1027bf:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1027c4:	e9 5c 04 00 00       	jmp    102c25 <__alltraps>

001027c9 <vector163>:
.globl vector163
vector163:
  pushl $0
  1027c9:	6a 00                	push   $0x0
  pushl $163
  1027cb:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1027d0:	e9 50 04 00 00       	jmp    102c25 <__alltraps>

001027d5 <vector164>:
.globl vector164
vector164:
  pushl $0
  1027d5:	6a 00                	push   $0x0
  pushl $164
  1027d7:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1027dc:	e9 44 04 00 00       	jmp    102c25 <__alltraps>

001027e1 <vector165>:
.globl vector165
vector165:
  pushl $0
  1027e1:	6a 00                	push   $0x0
  pushl $165
  1027e3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1027e8:	e9 38 04 00 00       	jmp    102c25 <__alltraps>

001027ed <vector166>:
.globl vector166
vector166:
  pushl $0
  1027ed:	6a 00                	push   $0x0
  pushl $166
  1027ef:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1027f4:	e9 2c 04 00 00       	jmp    102c25 <__alltraps>

001027f9 <vector167>:
.globl vector167
vector167:
  pushl $0
  1027f9:	6a 00                	push   $0x0
  pushl $167
  1027fb:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102800:	e9 20 04 00 00       	jmp    102c25 <__alltraps>

00102805 <vector168>:
.globl vector168
vector168:
  pushl $0
  102805:	6a 00                	push   $0x0
  pushl $168
  102807:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10280c:	e9 14 04 00 00       	jmp    102c25 <__alltraps>

00102811 <vector169>:
.globl vector169
vector169:
  pushl $0
  102811:	6a 00                	push   $0x0
  pushl $169
  102813:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102818:	e9 08 04 00 00       	jmp    102c25 <__alltraps>

0010281d <vector170>:
.globl vector170
vector170:
  pushl $0
  10281d:	6a 00                	push   $0x0
  pushl $170
  10281f:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102824:	e9 fc 03 00 00       	jmp    102c25 <__alltraps>

00102829 <vector171>:
.globl vector171
vector171:
  pushl $0
  102829:	6a 00                	push   $0x0
  pushl $171
  10282b:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102830:	e9 f0 03 00 00       	jmp    102c25 <__alltraps>

00102835 <vector172>:
.globl vector172
vector172:
  pushl $0
  102835:	6a 00                	push   $0x0
  pushl $172
  102837:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10283c:	e9 e4 03 00 00       	jmp    102c25 <__alltraps>

00102841 <vector173>:
.globl vector173
vector173:
  pushl $0
  102841:	6a 00                	push   $0x0
  pushl $173
  102843:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102848:	e9 d8 03 00 00       	jmp    102c25 <__alltraps>

0010284d <vector174>:
.globl vector174
vector174:
  pushl $0
  10284d:	6a 00                	push   $0x0
  pushl $174
  10284f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102854:	e9 cc 03 00 00       	jmp    102c25 <__alltraps>

00102859 <vector175>:
.globl vector175
vector175:
  pushl $0
  102859:	6a 00                	push   $0x0
  pushl $175
  10285b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102860:	e9 c0 03 00 00       	jmp    102c25 <__alltraps>

00102865 <vector176>:
.globl vector176
vector176:
  pushl $0
  102865:	6a 00                	push   $0x0
  pushl $176
  102867:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10286c:	e9 b4 03 00 00       	jmp    102c25 <__alltraps>

00102871 <vector177>:
.globl vector177
vector177:
  pushl $0
  102871:	6a 00                	push   $0x0
  pushl $177
  102873:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102878:	e9 a8 03 00 00       	jmp    102c25 <__alltraps>

0010287d <vector178>:
.globl vector178
vector178:
  pushl $0
  10287d:	6a 00                	push   $0x0
  pushl $178
  10287f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102884:	e9 9c 03 00 00       	jmp    102c25 <__alltraps>

00102889 <vector179>:
.globl vector179
vector179:
  pushl $0
  102889:	6a 00                	push   $0x0
  pushl $179
  10288b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102890:	e9 90 03 00 00       	jmp    102c25 <__alltraps>

00102895 <vector180>:
.globl vector180
vector180:
  pushl $0
  102895:	6a 00                	push   $0x0
  pushl $180
  102897:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10289c:	e9 84 03 00 00       	jmp    102c25 <__alltraps>

001028a1 <vector181>:
.globl vector181
vector181:
  pushl $0
  1028a1:	6a 00                	push   $0x0
  pushl $181
  1028a3:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1028a8:	e9 78 03 00 00       	jmp    102c25 <__alltraps>

001028ad <vector182>:
.globl vector182
vector182:
  pushl $0
  1028ad:	6a 00                	push   $0x0
  pushl $182
  1028af:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1028b4:	e9 6c 03 00 00       	jmp    102c25 <__alltraps>

001028b9 <vector183>:
.globl vector183
vector183:
  pushl $0
  1028b9:	6a 00                	push   $0x0
  pushl $183
  1028bb:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1028c0:	e9 60 03 00 00       	jmp    102c25 <__alltraps>

001028c5 <vector184>:
.globl vector184
vector184:
  pushl $0
  1028c5:	6a 00                	push   $0x0
  pushl $184
  1028c7:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1028cc:	e9 54 03 00 00       	jmp    102c25 <__alltraps>

001028d1 <vector185>:
.globl vector185
vector185:
  pushl $0
  1028d1:	6a 00                	push   $0x0
  pushl $185
  1028d3:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1028d8:	e9 48 03 00 00       	jmp    102c25 <__alltraps>

001028dd <vector186>:
.globl vector186
vector186:
  pushl $0
  1028dd:	6a 00                	push   $0x0
  pushl $186
  1028df:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1028e4:	e9 3c 03 00 00       	jmp    102c25 <__alltraps>

001028e9 <vector187>:
.globl vector187
vector187:
  pushl $0
  1028e9:	6a 00                	push   $0x0
  pushl $187
  1028eb:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1028f0:	e9 30 03 00 00       	jmp    102c25 <__alltraps>

001028f5 <vector188>:
.globl vector188
vector188:
  pushl $0
  1028f5:	6a 00                	push   $0x0
  pushl $188
  1028f7:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1028fc:	e9 24 03 00 00       	jmp    102c25 <__alltraps>

00102901 <vector189>:
.globl vector189
vector189:
  pushl $0
  102901:	6a 00                	push   $0x0
  pushl $189
  102903:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102908:	e9 18 03 00 00       	jmp    102c25 <__alltraps>

0010290d <vector190>:
.globl vector190
vector190:
  pushl $0
  10290d:	6a 00                	push   $0x0
  pushl $190
  10290f:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102914:	e9 0c 03 00 00       	jmp    102c25 <__alltraps>

00102919 <vector191>:
.globl vector191
vector191:
  pushl $0
  102919:	6a 00                	push   $0x0
  pushl $191
  10291b:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102920:	e9 00 03 00 00       	jmp    102c25 <__alltraps>

00102925 <vector192>:
.globl vector192
vector192:
  pushl $0
  102925:	6a 00                	push   $0x0
  pushl $192
  102927:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10292c:	e9 f4 02 00 00       	jmp    102c25 <__alltraps>

00102931 <vector193>:
.globl vector193
vector193:
  pushl $0
  102931:	6a 00                	push   $0x0
  pushl $193
  102933:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102938:	e9 e8 02 00 00       	jmp    102c25 <__alltraps>

0010293d <vector194>:
.globl vector194
vector194:
  pushl $0
  10293d:	6a 00                	push   $0x0
  pushl $194
  10293f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102944:	e9 dc 02 00 00       	jmp    102c25 <__alltraps>

00102949 <vector195>:
.globl vector195
vector195:
  pushl $0
  102949:	6a 00                	push   $0x0
  pushl $195
  10294b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102950:	e9 d0 02 00 00       	jmp    102c25 <__alltraps>

00102955 <vector196>:
.globl vector196
vector196:
  pushl $0
  102955:	6a 00                	push   $0x0
  pushl $196
  102957:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10295c:	e9 c4 02 00 00       	jmp    102c25 <__alltraps>

00102961 <vector197>:
.globl vector197
vector197:
  pushl $0
  102961:	6a 00                	push   $0x0
  pushl $197
  102963:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102968:	e9 b8 02 00 00       	jmp    102c25 <__alltraps>

0010296d <vector198>:
.globl vector198
vector198:
  pushl $0
  10296d:	6a 00                	push   $0x0
  pushl $198
  10296f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102974:	e9 ac 02 00 00       	jmp    102c25 <__alltraps>

00102979 <vector199>:
.globl vector199
vector199:
  pushl $0
  102979:	6a 00                	push   $0x0
  pushl $199
  10297b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102980:	e9 a0 02 00 00       	jmp    102c25 <__alltraps>

00102985 <vector200>:
.globl vector200
vector200:
  pushl $0
  102985:	6a 00                	push   $0x0
  pushl $200
  102987:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10298c:	e9 94 02 00 00       	jmp    102c25 <__alltraps>

00102991 <vector201>:
.globl vector201
vector201:
  pushl $0
  102991:	6a 00                	push   $0x0
  pushl $201
  102993:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102998:	e9 88 02 00 00       	jmp    102c25 <__alltraps>

0010299d <vector202>:
.globl vector202
vector202:
  pushl $0
  10299d:	6a 00                	push   $0x0
  pushl $202
  10299f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1029a4:	e9 7c 02 00 00       	jmp    102c25 <__alltraps>

001029a9 <vector203>:
.globl vector203
vector203:
  pushl $0
  1029a9:	6a 00                	push   $0x0
  pushl $203
  1029ab:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1029b0:	e9 70 02 00 00       	jmp    102c25 <__alltraps>

001029b5 <vector204>:
.globl vector204
vector204:
  pushl $0
  1029b5:	6a 00                	push   $0x0
  pushl $204
  1029b7:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1029bc:	e9 64 02 00 00       	jmp    102c25 <__alltraps>

001029c1 <vector205>:
.globl vector205
vector205:
  pushl $0
  1029c1:	6a 00                	push   $0x0
  pushl $205
  1029c3:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1029c8:	e9 58 02 00 00       	jmp    102c25 <__alltraps>

001029cd <vector206>:
.globl vector206
vector206:
  pushl $0
  1029cd:	6a 00                	push   $0x0
  pushl $206
  1029cf:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1029d4:	e9 4c 02 00 00       	jmp    102c25 <__alltraps>

001029d9 <vector207>:
.globl vector207
vector207:
  pushl $0
  1029d9:	6a 00                	push   $0x0
  pushl $207
  1029db:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1029e0:	e9 40 02 00 00       	jmp    102c25 <__alltraps>

001029e5 <vector208>:
.globl vector208
vector208:
  pushl $0
  1029e5:	6a 00                	push   $0x0
  pushl $208
  1029e7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1029ec:	e9 34 02 00 00       	jmp    102c25 <__alltraps>

001029f1 <vector209>:
.globl vector209
vector209:
  pushl $0
  1029f1:	6a 00                	push   $0x0
  pushl $209
  1029f3:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1029f8:	e9 28 02 00 00       	jmp    102c25 <__alltraps>

001029fd <vector210>:
.globl vector210
vector210:
  pushl $0
  1029fd:	6a 00                	push   $0x0
  pushl $210
  1029ff:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102a04:	e9 1c 02 00 00       	jmp    102c25 <__alltraps>

00102a09 <vector211>:
.globl vector211
vector211:
  pushl $0
  102a09:	6a 00                	push   $0x0
  pushl $211
  102a0b:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102a10:	e9 10 02 00 00       	jmp    102c25 <__alltraps>

00102a15 <vector212>:
.globl vector212
vector212:
  pushl $0
  102a15:	6a 00                	push   $0x0
  pushl $212
  102a17:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102a1c:	e9 04 02 00 00       	jmp    102c25 <__alltraps>

00102a21 <vector213>:
.globl vector213
vector213:
  pushl $0
  102a21:	6a 00                	push   $0x0
  pushl $213
  102a23:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102a28:	e9 f8 01 00 00       	jmp    102c25 <__alltraps>

00102a2d <vector214>:
.globl vector214
vector214:
  pushl $0
  102a2d:	6a 00                	push   $0x0
  pushl $214
  102a2f:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102a34:	e9 ec 01 00 00       	jmp    102c25 <__alltraps>

00102a39 <vector215>:
.globl vector215
vector215:
  pushl $0
  102a39:	6a 00                	push   $0x0
  pushl $215
  102a3b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102a40:	e9 e0 01 00 00       	jmp    102c25 <__alltraps>

00102a45 <vector216>:
.globl vector216
vector216:
  pushl $0
  102a45:	6a 00                	push   $0x0
  pushl $216
  102a47:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102a4c:	e9 d4 01 00 00       	jmp    102c25 <__alltraps>

00102a51 <vector217>:
.globl vector217
vector217:
  pushl $0
  102a51:	6a 00                	push   $0x0
  pushl $217
  102a53:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102a58:	e9 c8 01 00 00       	jmp    102c25 <__alltraps>

00102a5d <vector218>:
.globl vector218
vector218:
  pushl $0
  102a5d:	6a 00                	push   $0x0
  pushl $218
  102a5f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102a64:	e9 bc 01 00 00       	jmp    102c25 <__alltraps>

00102a69 <vector219>:
.globl vector219
vector219:
  pushl $0
  102a69:	6a 00                	push   $0x0
  pushl $219
  102a6b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102a70:	e9 b0 01 00 00       	jmp    102c25 <__alltraps>

00102a75 <vector220>:
.globl vector220
vector220:
  pushl $0
  102a75:	6a 00                	push   $0x0
  pushl $220
  102a77:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102a7c:	e9 a4 01 00 00       	jmp    102c25 <__alltraps>

00102a81 <vector221>:
.globl vector221
vector221:
  pushl $0
  102a81:	6a 00                	push   $0x0
  pushl $221
  102a83:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102a88:	e9 98 01 00 00       	jmp    102c25 <__alltraps>

00102a8d <vector222>:
.globl vector222
vector222:
  pushl $0
  102a8d:	6a 00                	push   $0x0
  pushl $222
  102a8f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102a94:	e9 8c 01 00 00       	jmp    102c25 <__alltraps>

00102a99 <vector223>:
.globl vector223
vector223:
  pushl $0
  102a99:	6a 00                	push   $0x0
  pushl $223
  102a9b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102aa0:	e9 80 01 00 00       	jmp    102c25 <__alltraps>

00102aa5 <vector224>:
.globl vector224
vector224:
  pushl $0
  102aa5:	6a 00                	push   $0x0
  pushl $224
  102aa7:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102aac:	e9 74 01 00 00       	jmp    102c25 <__alltraps>

00102ab1 <vector225>:
.globl vector225
vector225:
  pushl $0
  102ab1:	6a 00                	push   $0x0
  pushl $225
  102ab3:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102ab8:	e9 68 01 00 00       	jmp    102c25 <__alltraps>

00102abd <vector226>:
.globl vector226
vector226:
  pushl $0
  102abd:	6a 00                	push   $0x0
  pushl $226
  102abf:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102ac4:	e9 5c 01 00 00       	jmp    102c25 <__alltraps>

00102ac9 <vector227>:
.globl vector227
vector227:
  pushl $0
  102ac9:	6a 00                	push   $0x0
  pushl $227
  102acb:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102ad0:	e9 50 01 00 00       	jmp    102c25 <__alltraps>

00102ad5 <vector228>:
.globl vector228
vector228:
  pushl $0
  102ad5:	6a 00                	push   $0x0
  pushl $228
  102ad7:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102adc:	e9 44 01 00 00       	jmp    102c25 <__alltraps>

00102ae1 <vector229>:
.globl vector229
vector229:
  pushl $0
  102ae1:	6a 00                	push   $0x0
  pushl $229
  102ae3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102ae8:	e9 38 01 00 00       	jmp    102c25 <__alltraps>

00102aed <vector230>:
.globl vector230
vector230:
  pushl $0
  102aed:	6a 00                	push   $0x0
  pushl $230
  102aef:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102af4:	e9 2c 01 00 00       	jmp    102c25 <__alltraps>

00102af9 <vector231>:
.globl vector231
vector231:
  pushl $0
  102af9:	6a 00                	push   $0x0
  pushl $231
  102afb:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102b00:	e9 20 01 00 00       	jmp    102c25 <__alltraps>

00102b05 <vector232>:
.globl vector232
vector232:
  pushl $0
  102b05:	6a 00                	push   $0x0
  pushl $232
  102b07:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102b0c:	e9 14 01 00 00       	jmp    102c25 <__alltraps>

00102b11 <vector233>:
.globl vector233
vector233:
  pushl $0
  102b11:	6a 00                	push   $0x0
  pushl $233
  102b13:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102b18:	e9 08 01 00 00       	jmp    102c25 <__alltraps>

00102b1d <vector234>:
.globl vector234
vector234:
  pushl $0
  102b1d:	6a 00                	push   $0x0
  pushl $234
  102b1f:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102b24:	e9 fc 00 00 00       	jmp    102c25 <__alltraps>

00102b29 <vector235>:
.globl vector235
vector235:
  pushl $0
  102b29:	6a 00                	push   $0x0
  pushl $235
  102b2b:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102b30:	e9 f0 00 00 00       	jmp    102c25 <__alltraps>

00102b35 <vector236>:
.globl vector236
vector236:
  pushl $0
  102b35:	6a 00                	push   $0x0
  pushl $236
  102b37:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102b3c:	e9 e4 00 00 00       	jmp    102c25 <__alltraps>

00102b41 <vector237>:
.globl vector237
vector237:
  pushl $0
  102b41:	6a 00                	push   $0x0
  pushl $237
  102b43:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102b48:	e9 d8 00 00 00       	jmp    102c25 <__alltraps>

00102b4d <vector238>:
.globl vector238
vector238:
  pushl $0
  102b4d:	6a 00                	push   $0x0
  pushl $238
  102b4f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102b54:	e9 cc 00 00 00       	jmp    102c25 <__alltraps>

00102b59 <vector239>:
.globl vector239
vector239:
  pushl $0
  102b59:	6a 00                	push   $0x0
  pushl $239
  102b5b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102b60:	e9 c0 00 00 00       	jmp    102c25 <__alltraps>

00102b65 <vector240>:
.globl vector240
vector240:
  pushl $0
  102b65:	6a 00                	push   $0x0
  pushl $240
  102b67:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102b6c:	e9 b4 00 00 00       	jmp    102c25 <__alltraps>

00102b71 <vector241>:
.globl vector241
vector241:
  pushl $0
  102b71:	6a 00                	push   $0x0
  pushl $241
  102b73:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102b78:	e9 a8 00 00 00       	jmp    102c25 <__alltraps>

00102b7d <vector242>:
.globl vector242
vector242:
  pushl $0
  102b7d:	6a 00                	push   $0x0
  pushl $242
  102b7f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102b84:	e9 9c 00 00 00       	jmp    102c25 <__alltraps>

00102b89 <vector243>:
.globl vector243
vector243:
  pushl $0
  102b89:	6a 00                	push   $0x0
  pushl $243
  102b8b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102b90:	e9 90 00 00 00       	jmp    102c25 <__alltraps>

00102b95 <vector244>:
.globl vector244
vector244:
  pushl $0
  102b95:	6a 00                	push   $0x0
  pushl $244
  102b97:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102b9c:	e9 84 00 00 00       	jmp    102c25 <__alltraps>

00102ba1 <vector245>:
.globl vector245
vector245:
  pushl $0
  102ba1:	6a 00                	push   $0x0
  pushl $245
  102ba3:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102ba8:	e9 78 00 00 00       	jmp    102c25 <__alltraps>

00102bad <vector246>:
.globl vector246
vector246:
  pushl $0
  102bad:	6a 00                	push   $0x0
  pushl $246
  102baf:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102bb4:	e9 6c 00 00 00       	jmp    102c25 <__alltraps>

00102bb9 <vector247>:
.globl vector247
vector247:
  pushl $0
  102bb9:	6a 00                	push   $0x0
  pushl $247
  102bbb:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102bc0:	e9 60 00 00 00       	jmp    102c25 <__alltraps>

00102bc5 <vector248>:
.globl vector248
vector248:
  pushl $0
  102bc5:	6a 00                	push   $0x0
  pushl $248
  102bc7:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102bcc:	e9 54 00 00 00       	jmp    102c25 <__alltraps>

00102bd1 <vector249>:
.globl vector249
vector249:
  pushl $0
  102bd1:	6a 00                	push   $0x0
  pushl $249
  102bd3:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102bd8:	e9 48 00 00 00       	jmp    102c25 <__alltraps>

00102bdd <vector250>:
.globl vector250
vector250:
  pushl $0
  102bdd:	6a 00                	push   $0x0
  pushl $250
  102bdf:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102be4:	e9 3c 00 00 00       	jmp    102c25 <__alltraps>

00102be9 <vector251>:
.globl vector251
vector251:
  pushl $0
  102be9:	6a 00                	push   $0x0
  pushl $251
  102beb:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102bf0:	e9 30 00 00 00       	jmp    102c25 <__alltraps>

00102bf5 <vector252>:
.globl vector252
vector252:
  pushl $0
  102bf5:	6a 00                	push   $0x0
  pushl $252
  102bf7:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102bfc:	e9 24 00 00 00       	jmp    102c25 <__alltraps>

00102c01 <vector253>:
.globl vector253
vector253:
  pushl $0
  102c01:	6a 00                	push   $0x0
  pushl $253
  102c03:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102c08:	e9 18 00 00 00       	jmp    102c25 <__alltraps>

00102c0d <vector254>:
.globl vector254
vector254:
  pushl $0
  102c0d:	6a 00                	push   $0x0
  pushl $254
  102c0f:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102c14:	e9 0c 00 00 00       	jmp    102c25 <__alltraps>

00102c19 <vector255>:
.globl vector255
vector255:
  pushl $0
  102c19:	6a 00                	push   $0x0
  pushl $255
  102c1b:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102c20:	e9 00 00 00 00       	jmp    102c25 <__alltraps>

00102c25 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102c25:	1e                   	push   %ds
    pushl %es
  102c26:	06                   	push   %es
    pushl %fs
  102c27:	0f a0                	push   %fs
    pushl %gs
  102c29:	0f a8                	push   %gs
    pushal
  102c2b:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102c2c:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102c31:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102c33:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102c35:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102c36:	e8 59 f5 ff ff       	call   102194 <trap>

    # pop the pushed stack pointer
    popl %esp
  102c3b:	5c                   	pop    %esp

00102c3c <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102c3c:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102c3d:	0f a9                	pop    %gs
    popl %fs
  102c3f:	0f a1                	pop    %fs
    popl %es
  102c41:	07                   	pop    %es
    popl %ds
  102c42:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102c43:	83 c4 08             	add    $0x8,%esp
    iret
  102c46:	cf                   	iret   

00102c47 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102c47:	55                   	push   %ebp
  102c48:	89 e5                	mov    %esp,%ebp
  102c4a:	e8 2d d6 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102c4f:	05 01 bd 00 00       	add    $0xbd01,%eax
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102c54:	8b 45 08             	mov    0x8(%ebp),%eax
  102c57:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102c5a:	b8 23 00 00 00       	mov    $0x23,%eax
  102c5f:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102c61:	b8 23 00 00 00       	mov    $0x23,%eax
  102c66:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102c68:	b8 10 00 00 00       	mov    $0x10,%eax
  102c6d:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102c6f:	b8 10 00 00 00       	mov    $0x10,%eax
  102c74:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102c76:	b8 10 00 00 00       	mov    $0x10,%eax
  102c7b:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102c7d:	ea 84 2c 10 00 08 00 	ljmp   $0x8,$0x102c84
}
  102c84:	90                   	nop
  102c85:	5d                   	pop    %ebp
  102c86:	c3                   	ret    

00102c87 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102c87:	55                   	push   %ebp
  102c88:	89 e5                	mov    %esp,%ebp
  102c8a:	83 ec 10             	sub    $0x10,%esp
  102c8d:	e8 ea d5 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102c92:	05 be bc 00 00       	add    $0xbcbe,%eax
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102c97:	c7 c2 c0 f9 10 00    	mov    $0x10f9c0,%edx
  102c9d:	81 c2 00 04 00 00    	add    $0x400,%edx
  102ca3:	89 90 f4 0f 00 00    	mov    %edx,0xff4(%eax)
    ts.ts_ss0 = KERNEL_DS;
  102ca9:	66 c7 80 f8 0f 00 00 	movw   $0x10,0xff8(%eax)
  102cb0:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102cb2:	66 c7 80 f8 ff ff ff 	movw   $0x68,-0x8(%eax)
  102cb9:	68 00 
  102cbb:	8d 90 f0 0f 00 00    	lea    0xff0(%eax),%edx
  102cc1:	66 89 90 fa ff ff ff 	mov    %dx,-0x6(%eax)
  102cc8:	8d 90 f0 0f 00 00    	lea    0xff0(%eax),%edx
  102cce:	c1 ea 10             	shr    $0x10,%edx
  102cd1:	88 90 fc ff ff ff    	mov    %dl,-0x4(%eax)
  102cd7:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102cde:	83 e2 f0             	and    $0xfffffff0,%edx
  102ce1:	83 ca 09             	or     $0x9,%edx
  102ce4:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)
  102cea:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102cf1:	83 ca 10             	or     $0x10,%edx
  102cf4:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)
  102cfa:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102d01:	83 e2 9f             	and    $0xffffff9f,%edx
  102d04:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)
  102d0a:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102d11:	83 ca 80             	or     $0xffffff80,%edx
  102d14:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)
  102d1a:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102d21:	83 e2 f0             	and    $0xfffffff0,%edx
  102d24:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102d2a:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102d31:	83 e2 ef             	and    $0xffffffef,%edx
  102d34:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102d3a:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102d41:	83 e2 df             	and    $0xffffffdf,%edx
  102d44:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102d4a:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102d51:	83 ca 40             	or     $0x40,%edx
  102d54:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102d5a:	0f b6 90 fe ff ff ff 	movzbl -0x2(%eax),%edx
  102d61:	83 e2 7f             	and    $0x7f,%edx
  102d64:	88 90 fe ff ff ff    	mov    %dl,-0x2(%eax)
  102d6a:	8d 90 f0 0f 00 00    	lea    0xff0(%eax),%edx
  102d70:	c1 ea 18             	shr    $0x18,%edx
  102d73:	88 90 ff ff ff ff    	mov    %dl,-0x1(%eax)
    gdt[SEG_TSS].sd_s = 0;
  102d79:	0f b6 90 fd ff ff ff 	movzbl -0x3(%eax),%edx
  102d80:	83 e2 ef             	and    $0xffffffef,%edx
  102d83:	88 90 fd ff ff ff    	mov    %dl,-0x3(%eax)

    // reload all segment registers
    lgdt(&gdt_pd);
  102d89:	8d 80 d0 00 00 00    	lea    0xd0(%eax),%eax
  102d8f:	50                   	push   %eax
  102d90:	e8 b2 fe ff ff       	call   102c47 <lgdt>
  102d95:	83 c4 04             	add    $0x4,%esp
  102d98:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102d9e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102da2:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102da5:	90                   	nop
  102da6:	c9                   	leave  
  102da7:	c3                   	ret    

00102da8 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102da8:	55                   	push   %ebp
  102da9:	89 e5                	mov    %esp,%ebp
  102dab:	e8 cc d4 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102db0:	05 a0 bb 00 00       	add    $0xbba0,%eax
    gdt_init();
  102db5:	e8 cd fe ff ff       	call   102c87 <gdt_init>
}
  102dba:	90                   	nop
  102dbb:	5d                   	pop    %ebp
  102dbc:	c3                   	ret    

00102dbd <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102dbd:	55                   	push   %ebp
  102dbe:	89 e5                	mov    %esp,%ebp
  102dc0:	83 ec 10             	sub    $0x10,%esp
  102dc3:	e8 b4 d4 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102dc8:	05 88 bb 00 00       	add    $0xbb88,%eax
    size_t cnt = 0;
  102dcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102dd4:	eb 04                	jmp    102dda <strlen+0x1d>
        cnt ++;
  102dd6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  102dda:	8b 45 08             	mov    0x8(%ebp),%eax
  102ddd:	8d 50 01             	lea    0x1(%eax),%edx
  102de0:	89 55 08             	mov    %edx,0x8(%ebp)
  102de3:	0f b6 00             	movzbl (%eax),%eax
  102de6:	84 c0                	test   %al,%al
  102de8:	75 ec                	jne    102dd6 <strlen+0x19>
    }
    return cnt;
  102dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ded:	c9                   	leave  
  102dee:	c3                   	ret    

00102def <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102def:	55                   	push   %ebp
  102df0:	89 e5                	mov    %esp,%ebp
  102df2:	83 ec 10             	sub    $0x10,%esp
  102df5:	e8 82 d4 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102dfa:	05 56 bb 00 00       	add    $0xbb56,%eax
    size_t cnt = 0;
  102dff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102e06:	eb 04                	jmp    102e0c <strnlen+0x1d>
        cnt ++;
  102e08:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102e0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e0f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102e12:	73 10                	jae    102e24 <strnlen+0x35>
  102e14:	8b 45 08             	mov    0x8(%ebp),%eax
  102e17:	8d 50 01             	lea    0x1(%eax),%edx
  102e1a:	89 55 08             	mov    %edx,0x8(%ebp)
  102e1d:	0f b6 00             	movzbl (%eax),%eax
  102e20:	84 c0                	test   %al,%al
  102e22:	75 e4                	jne    102e08 <strnlen+0x19>
    }
    return cnt;
  102e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102e27:	c9                   	leave  
  102e28:	c3                   	ret    

00102e29 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102e29:	55                   	push   %ebp
  102e2a:	89 e5                	mov    %esp,%ebp
  102e2c:	57                   	push   %edi
  102e2d:	56                   	push   %esi
  102e2e:	83 ec 20             	sub    $0x20,%esp
  102e31:	e8 46 d4 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102e36:	05 1a bb 00 00       	add    $0xbb1a,%eax
  102e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e44:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102e47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e4d:	89 d1                	mov    %edx,%ecx
  102e4f:	89 c2                	mov    %eax,%edx
  102e51:	89 ce                	mov    %ecx,%esi
  102e53:	89 d7                	mov    %edx,%edi
  102e55:	ac                   	lods   %ds:(%esi),%al
  102e56:	aa                   	stos   %al,%es:(%edi)
  102e57:	84 c0                	test   %al,%al
  102e59:	75 fa                	jne    102e55 <strcpy+0x2c>
  102e5b:	89 fa                	mov    %edi,%edx
  102e5d:	89 f1                	mov    %esi,%ecx
  102e5f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102e62:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102e65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102e6b:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102e6c:	83 c4 20             	add    $0x20,%esp
  102e6f:	5e                   	pop    %esi
  102e70:	5f                   	pop    %edi
  102e71:	5d                   	pop    %ebp
  102e72:	c3                   	ret    

00102e73 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102e73:	55                   	push   %ebp
  102e74:	89 e5                	mov    %esp,%ebp
  102e76:	83 ec 10             	sub    $0x10,%esp
  102e79:	e8 fe d3 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102e7e:	05 d2 ba 00 00       	add    $0xbad2,%eax
    char *p = dst;
  102e83:	8b 45 08             	mov    0x8(%ebp),%eax
  102e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102e89:	eb 21                	jmp    102eac <strncpy+0x39>
        if ((*p = *src) != '\0') {
  102e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e8e:	0f b6 10             	movzbl (%eax),%edx
  102e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e94:	88 10                	mov    %dl,(%eax)
  102e96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e99:	0f b6 00             	movzbl (%eax),%eax
  102e9c:	84 c0                	test   %al,%al
  102e9e:	74 04                	je     102ea4 <strncpy+0x31>
            src ++;
  102ea0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102ea4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102ea8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102eac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102eb0:	75 d9                	jne    102e8b <strncpy+0x18>
    }
    return dst;
  102eb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102eb5:	c9                   	leave  
  102eb6:	c3                   	ret    

00102eb7 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102eb7:	55                   	push   %ebp
  102eb8:	89 e5                	mov    %esp,%ebp
  102eba:	57                   	push   %edi
  102ebb:	56                   	push   %esi
  102ebc:	83 ec 20             	sub    $0x20,%esp
  102ebf:	e8 b8 d3 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102ec4:	05 8c ba 00 00       	add    $0xba8c,%eax
  102ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ed2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102edb:	89 d1                	mov    %edx,%ecx
  102edd:	89 c2                	mov    %eax,%edx
  102edf:	89 ce                	mov    %ecx,%esi
  102ee1:	89 d7                	mov    %edx,%edi
  102ee3:	ac                   	lods   %ds:(%esi),%al
  102ee4:	ae                   	scas   %es:(%edi),%al
  102ee5:	75 08                	jne    102eef <strcmp+0x38>
  102ee7:	84 c0                	test   %al,%al
  102ee9:	75 f8                	jne    102ee3 <strcmp+0x2c>
  102eeb:	31 c0                	xor    %eax,%eax
  102eed:	eb 04                	jmp    102ef3 <strcmp+0x3c>
  102eef:	19 c0                	sbb    %eax,%eax
  102ef1:	0c 01                	or     $0x1,%al
  102ef3:	89 fa                	mov    %edi,%edx
  102ef5:	89 f1                	mov    %esi,%ecx
  102ef7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102efa:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102efd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102f03:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102f04:	83 c4 20             	add    $0x20,%esp
  102f07:	5e                   	pop    %esi
  102f08:	5f                   	pop    %edi
  102f09:	5d                   	pop    %ebp
  102f0a:	c3                   	ret    

00102f0b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102f0b:	55                   	push   %ebp
  102f0c:	89 e5                	mov    %esp,%ebp
  102f0e:	e8 69 d3 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102f13:	05 3d ba 00 00       	add    $0xba3d,%eax
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102f18:	eb 0c                	jmp    102f26 <strncmp+0x1b>
        n --, s1 ++, s2 ++;
  102f1a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102f1e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102f22:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102f26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f2a:	74 1a                	je     102f46 <strncmp+0x3b>
  102f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2f:	0f b6 00             	movzbl (%eax),%eax
  102f32:	84 c0                	test   %al,%al
  102f34:	74 10                	je     102f46 <strncmp+0x3b>
  102f36:	8b 45 08             	mov    0x8(%ebp),%eax
  102f39:	0f b6 10             	movzbl (%eax),%edx
  102f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3f:	0f b6 00             	movzbl (%eax),%eax
  102f42:	38 c2                	cmp    %al,%dl
  102f44:	74 d4                	je     102f1a <strncmp+0xf>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102f46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f4a:	74 18                	je     102f64 <strncmp+0x59>
  102f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4f:	0f b6 00             	movzbl (%eax),%eax
  102f52:	0f b6 d0             	movzbl %al,%edx
  102f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f58:	0f b6 00             	movzbl (%eax),%eax
  102f5b:	0f b6 c0             	movzbl %al,%eax
  102f5e:	29 c2                	sub    %eax,%edx
  102f60:	89 d0                	mov    %edx,%eax
  102f62:	eb 05                	jmp    102f69 <strncmp+0x5e>
  102f64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f69:	5d                   	pop    %ebp
  102f6a:	c3                   	ret    

00102f6b <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102f6b:	55                   	push   %ebp
  102f6c:	89 e5                	mov    %esp,%ebp
  102f6e:	83 ec 04             	sub    $0x4,%esp
  102f71:	e8 06 d3 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102f76:	05 da b9 00 00       	add    $0xb9da,%eax
  102f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f7e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102f81:	eb 14                	jmp    102f97 <strchr+0x2c>
        if (*s == c) {
  102f83:	8b 45 08             	mov    0x8(%ebp),%eax
  102f86:	0f b6 00             	movzbl (%eax),%eax
  102f89:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102f8c:	75 05                	jne    102f93 <strchr+0x28>
            return (char *)s;
  102f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f91:	eb 13                	jmp    102fa6 <strchr+0x3b>
        }
        s ++;
  102f93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102f97:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9a:	0f b6 00             	movzbl (%eax),%eax
  102f9d:	84 c0                	test   %al,%al
  102f9f:	75 e2                	jne    102f83 <strchr+0x18>
    }
    return NULL;
  102fa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102fa6:	c9                   	leave  
  102fa7:	c3                   	ret    

00102fa8 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102fa8:	55                   	push   %ebp
  102fa9:	89 e5                	mov    %esp,%ebp
  102fab:	83 ec 04             	sub    $0x4,%esp
  102fae:	e8 c9 d2 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102fb3:	05 9d b9 00 00       	add    $0xb99d,%eax
  102fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fbb:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102fbe:	eb 0f                	jmp    102fcf <strfind+0x27>
        if (*s == c) {
  102fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc3:	0f b6 00             	movzbl (%eax),%eax
  102fc6:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102fc9:	74 10                	je     102fdb <strfind+0x33>
            break;
        }
        s ++;
  102fcb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd2:	0f b6 00             	movzbl (%eax),%eax
  102fd5:	84 c0                	test   %al,%al
  102fd7:	75 e7                	jne    102fc0 <strfind+0x18>
  102fd9:	eb 01                	jmp    102fdc <strfind+0x34>
            break;
  102fdb:	90                   	nop
    }
    return (char *)s;
  102fdc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102fdf:	c9                   	leave  
  102fe0:	c3                   	ret    

00102fe1 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102fe1:	55                   	push   %ebp
  102fe2:	89 e5                	mov    %esp,%ebp
  102fe4:	83 ec 10             	sub    $0x10,%esp
  102fe7:	e8 90 d2 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  102fec:	05 64 b9 00 00       	add    $0xb964,%eax
    int neg = 0;
  102ff1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102ff8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102fff:	eb 04                	jmp    103005 <strtol+0x24>
        s ++;
  103001:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  103005:	8b 45 08             	mov    0x8(%ebp),%eax
  103008:	0f b6 00             	movzbl (%eax),%eax
  10300b:	3c 20                	cmp    $0x20,%al
  10300d:	74 f2                	je     103001 <strtol+0x20>
  10300f:	8b 45 08             	mov    0x8(%ebp),%eax
  103012:	0f b6 00             	movzbl (%eax),%eax
  103015:	3c 09                	cmp    $0x9,%al
  103017:	74 e8                	je     103001 <strtol+0x20>
    }

    // plus/minus sign
    if (*s == '+') {
  103019:	8b 45 08             	mov    0x8(%ebp),%eax
  10301c:	0f b6 00             	movzbl (%eax),%eax
  10301f:	3c 2b                	cmp    $0x2b,%al
  103021:	75 06                	jne    103029 <strtol+0x48>
        s ++;
  103023:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103027:	eb 15                	jmp    10303e <strtol+0x5d>
    }
    else if (*s == '-') {
  103029:	8b 45 08             	mov    0x8(%ebp),%eax
  10302c:	0f b6 00             	movzbl (%eax),%eax
  10302f:	3c 2d                	cmp    $0x2d,%al
  103031:	75 0b                	jne    10303e <strtol+0x5d>
        s ++, neg = 1;
  103033:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103037:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10303e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103042:	74 06                	je     10304a <strtol+0x69>
  103044:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  103048:	75 24                	jne    10306e <strtol+0x8d>
  10304a:	8b 45 08             	mov    0x8(%ebp),%eax
  10304d:	0f b6 00             	movzbl (%eax),%eax
  103050:	3c 30                	cmp    $0x30,%al
  103052:	75 1a                	jne    10306e <strtol+0x8d>
  103054:	8b 45 08             	mov    0x8(%ebp),%eax
  103057:	83 c0 01             	add    $0x1,%eax
  10305a:	0f b6 00             	movzbl (%eax),%eax
  10305d:	3c 78                	cmp    $0x78,%al
  10305f:	75 0d                	jne    10306e <strtol+0x8d>
        s += 2, base = 16;
  103061:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103065:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10306c:	eb 2a                	jmp    103098 <strtol+0xb7>
    }
    else if (base == 0 && s[0] == '0') {
  10306e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103072:	75 17                	jne    10308b <strtol+0xaa>
  103074:	8b 45 08             	mov    0x8(%ebp),%eax
  103077:	0f b6 00             	movzbl (%eax),%eax
  10307a:	3c 30                	cmp    $0x30,%al
  10307c:	75 0d                	jne    10308b <strtol+0xaa>
        s ++, base = 8;
  10307e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103082:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103089:	eb 0d                	jmp    103098 <strtol+0xb7>
    }
    else if (base == 0) {
  10308b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10308f:	75 07                	jne    103098 <strtol+0xb7>
        base = 10;
  103091:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103098:	8b 45 08             	mov    0x8(%ebp),%eax
  10309b:	0f b6 00             	movzbl (%eax),%eax
  10309e:	3c 2f                	cmp    $0x2f,%al
  1030a0:	7e 1b                	jle    1030bd <strtol+0xdc>
  1030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a5:	0f b6 00             	movzbl (%eax),%eax
  1030a8:	3c 39                	cmp    $0x39,%al
  1030aa:	7f 11                	jg     1030bd <strtol+0xdc>
            dig = *s - '0';
  1030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1030af:	0f b6 00             	movzbl (%eax),%eax
  1030b2:	0f be c0             	movsbl %al,%eax
  1030b5:	83 e8 30             	sub    $0x30,%eax
  1030b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030bb:	eb 48                	jmp    103105 <strtol+0x124>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c0:	0f b6 00             	movzbl (%eax),%eax
  1030c3:	3c 60                	cmp    $0x60,%al
  1030c5:	7e 1b                	jle    1030e2 <strtol+0x101>
  1030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ca:	0f b6 00             	movzbl (%eax),%eax
  1030cd:	3c 7a                	cmp    $0x7a,%al
  1030cf:	7f 11                	jg     1030e2 <strtol+0x101>
            dig = *s - 'a' + 10;
  1030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d4:	0f b6 00             	movzbl (%eax),%eax
  1030d7:	0f be c0             	movsbl %al,%eax
  1030da:	83 e8 57             	sub    $0x57,%eax
  1030dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030e0:	eb 23                	jmp    103105 <strtol+0x124>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e5:	0f b6 00             	movzbl (%eax),%eax
  1030e8:	3c 40                	cmp    $0x40,%al
  1030ea:	7e 3c                	jle    103128 <strtol+0x147>
  1030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ef:	0f b6 00             	movzbl (%eax),%eax
  1030f2:	3c 5a                	cmp    $0x5a,%al
  1030f4:	7f 32                	jg     103128 <strtol+0x147>
            dig = *s - 'A' + 10;
  1030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f9:	0f b6 00             	movzbl (%eax),%eax
  1030fc:	0f be c0             	movsbl %al,%eax
  1030ff:	83 e8 37             	sub    $0x37,%eax
  103102:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103108:	3b 45 10             	cmp    0x10(%ebp),%eax
  10310b:	7d 1a                	jge    103127 <strtol+0x146>
            break;
        }
        s ++, val = (val * base) + dig;
  10310d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103111:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103114:	0f af 45 10          	imul   0x10(%ebp),%eax
  103118:	89 c2                	mov    %eax,%edx
  10311a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10311d:	01 d0                	add    %edx,%eax
  10311f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  103122:	e9 71 ff ff ff       	jmp    103098 <strtol+0xb7>
            break;
  103127:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  103128:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10312c:	74 08                	je     103136 <strtol+0x155>
        *endptr = (char *) s;
  10312e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103131:	8b 55 08             	mov    0x8(%ebp),%edx
  103134:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  103136:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10313a:	74 07                	je     103143 <strtol+0x162>
  10313c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10313f:	f7 d8                	neg    %eax
  103141:	eb 03                	jmp    103146 <strtol+0x165>
  103143:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103146:	c9                   	leave  
  103147:	c3                   	ret    

00103148 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103148:	55                   	push   %ebp
  103149:	89 e5                	mov    %esp,%ebp
  10314b:	57                   	push   %edi
  10314c:	83 ec 24             	sub    $0x24,%esp
  10314f:	e8 28 d1 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  103154:	05 fc b7 00 00       	add    $0xb7fc,%eax
  103159:	8b 45 0c             	mov    0xc(%ebp),%eax
  10315c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10315f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103163:	8b 55 08             	mov    0x8(%ebp),%edx
  103166:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103169:	88 45 f7             	mov    %al,-0x9(%ebp)
  10316c:	8b 45 10             	mov    0x10(%ebp),%eax
  10316f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103172:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103175:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103179:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10317c:	89 d7                	mov    %edx,%edi
  10317e:	f3 aa                	rep stos %al,%es:(%edi)
  103180:	89 fa                	mov    %edi,%edx
  103182:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103185:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103188:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10318b:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10318c:	83 c4 24             	add    $0x24,%esp
  10318f:	5f                   	pop    %edi
  103190:	5d                   	pop    %ebp
  103191:	c3                   	ret    

00103192 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103192:	55                   	push   %ebp
  103193:	89 e5                	mov    %esp,%ebp
  103195:	57                   	push   %edi
  103196:	56                   	push   %esi
  103197:	53                   	push   %ebx
  103198:	83 ec 30             	sub    $0x30,%esp
  10319b:	e8 dc d0 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1031a0:	05 b0 b7 00 00       	add    $0xb7b0,%eax
  1031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031b1:	8b 45 10             	mov    0x10(%ebp),%eax
  1031b4:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1031b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1031bd:	73 42                	jae    103201 <memmove+0x6f>
  1031bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1031c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1031cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1031d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1031d4:	c1 e8 02             	shr    $0x2,%eax
  1031d7:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1031d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1031dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031df:	89 d7                	mov    %edx,%edi
  1031e1:	89 c6                	mov    %eax,%esi
  1031e3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1031e5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1031e8:	83 e1 03             	and    $0x3,%ecx
  1031eb:	74 02                	je     1031ef <memmove+0x5d>
  1031ed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1031ef:	89 f0                	mov    %esi,%eax
  1031f1:	89 fa                	mov    %edi,%edx
  1031f3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1031f6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1031f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  1031fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  1031ff:	eb 36                	jmp    103237 <memmove+0xa5>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103201:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103204:	8d 50 ff             	lea    -0x1(%eax),%edx
  103207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10320a:	01 c2                	add    %eax,%edx
  10320c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10320f:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103215:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103218:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10321b:	89 c1                	mov    %eax,%ecx
  10321d:	89 d8                	mov    %ebx,%eax
  10321f:	89 d6                	mov    %edx,%esi
  103221:	89 c7                	mov    %eax,%edi
  103223:	fd                   	std    
  103224:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103226:	fc                   	cld    
  103227:	89 f8                	mov    %edi,%eax
  103229:	89 f2                	mov    %esi,%edx
  10322b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10322e:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103231:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  103234:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103237:	83 c4 30             	add    $0x30,%esp
  10323a:	5b                   	pop    %ebx
  10323b:	5e                   	pop    %esi
  10323c:	5f                   	pop    %edi
  10323d:	5d                   	pop    %ebp
  10323e:	c3                   	ret    

0010323f <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10323f:	55                   	push   %ebp
  103240:	89 e5                	mov    %esp,%ebp
  103242:	57                   	push   %edi
  103243:	56                   	push   %esi
  103244:	83 ec 20             	sub    $0x20,%esp
  103247:	e8 30 d0 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10324c:	05 04 b7 00 00       	add    $0xb704,%eax
  103251:	8b 45 08             	mov    0x8(%ebp),%eax
  103254:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103257:	8b 45 0c             	mov    0xc(%ebp),%eax
  10325a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10325d:	8b 45 10             	mov    0x10(%ebp),%eax
  103260:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103266:	c1 e8 02             	shr    $0x2,%eax
  103269:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10326b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10326e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103271:	89 d7                	mov    %edx,%edi
  103273:	89 c6                	mov    %eax,%esi
  103275:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103277:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10327a:	83 e1 03             	and    $0x3,%ecx
  10327d:	74 02                	je     103281 <memcpy+0x42>
  10327f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103281:	89 f0                	mov    %esi,%eax
  103283:	89 fa                	mov    %edi,%edx
  103285:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103288:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10328b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10328e:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  103291:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103292:	83 c4 20             	add    $0x20,%esp
  103295:	5e                   	pop    %esi
  103296:	5f                   	pop    %edi
  103297:	5d                   	pop    %ebp
  103298:	c3                   	ret    

00103299 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103299:	55                   	push   %ebp
  10329a:	89 e5                	mov    %esp,%ebp
  10329c:	83 ec 10             	sub    $0x10,%esp
  10329f:	e8 d8 cf ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1032a4:	05 ac b6 00 00       	add    $0xb6ac,%eax
    const char *s1 = (const char *)v1;
  1032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1032af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1032b5:	eb 30                	jmp    1032e7 <memcmp+0x4e>
        if (*s1 != *s2) {
  1032b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1032ba:	0f b6 10             	movzbl (%eax),%edx
  1032bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032c0:	0f b6 00             	movzbl (%eax),%eax
  1032c3:	38 c2                	cmp    %al,%dl
  1032c5:	74 18                	je     1032df <memcmp+0x46>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1032c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1032ca:	0f b6 00             	movzbl (%eax),%eax
  1032cd:	0f b6 d0             	movzbl %al,%edx
  1032d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032d3:	0f b6 00             	movzbl (%eax),%eax
  1032d6:	0f b6 c0             	movzbl %al,%eax
  1032d9:	29 c2                	sub    %eax,%edx
  1032db:	89 d0                	mov    %edx,%eax
  1032dd:	eb 1a                	jmp    1032f9 <memcmp+0x60>
        }
        s1 ++, s2 ++;
  1032df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1032e3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  1032e7:	8b 45 10             	mov    0x10(%ebp),%eax
  1032ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  1032ed:	89 55 10             	mov    %edx,0x10(%ebp)
  1032f0:	85 c0                	test   %eax,%eax
  1032f2:	75 c3                	jne    1032b7 <memcmp+0x1e>
    }
    return 0;
  1032f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032f9:	c9                   	leave  
  1032fa:	c3                   	ret    

001032fb <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1032fb:	55                   	push   %ebp
  1032fc:	89 e5                	mov    %esp,%ebp
  1032fe:	53                   	push   %ebx
  1032ff:	83 ec 34             	sub    $0x34,%esp
  103302:	e8 79 cf ff ff       	call   100280 <__x86.get_pc_thunk.bx>
  103307:	81 c3 49 b6 00 00    	add    $0xb649,%ebx
  10330d:	8b 45 10             	mov    0x10(%ebp),%eax
  103310:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103313:	8b 45 14             	mov    0x14(%ebp),%eax
  103316:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  103319:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10331c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10331f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103322:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  103325:	8b 45 18             	mov    0x18(%ebp),%eax
  103328:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10332b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10332e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103331:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103334:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10333a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10333d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103341:	74 1c                	je     10335f <printnum+0x64>
  103343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103346:	ba 00 00 00 00       	mov    $0x0,%edx
  10334b:	f7 75 e4             	divl   -0x1c(%ebp)
  10334e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  103351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103354:	ba 00 00 00 00       	mov    $0x0,%edx
  103359:	f7 75 e4             	divl   -0x1c(%ebp)
  10335c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10335f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103362:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103365:	f7 75 e4             	divl   -0x1c(%ebp)
  103368:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10336b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10336e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103371:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103374:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103377:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10337a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10337d:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  103380:	8b 45 18             	mov    0x18(%ebp),%eax
  103383:	ba 00 00 00 00       	mov    $0x0,%edx
  103388:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  10338b:	72 41                	jb     1033ce <printnum+0xd3>
  10338d:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  103390:	77 05                	ja     103397 <printnum+0x9c>
  103392:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103395:	72 37                	jb     1033ce <printnum+0xd3>
        printnum(putch, putdat, result, base, width - 1, padc);
  103397:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10339a:	83 e8 01             	sub    $0x1,%eax
  10339d:	83 ec 04             	sub    $0x4,%esp
  1033a0:	ff 75 20             	pushl  0x20(%ebp)
  1033a3:	50                   	push   %eax
  1033a4:	ff 75 18             	pushl  0x18(%ebp)
  1033a7:	ff 75 ec             	pushl  -0x14(%ebp)
  1033aa:	ff 75 e8             	pushl  -0x18(%ebp)
  1033ad:	ff 75 0c             	pushl  0xc(%ebp)
  1033b0:	ff 75 08             	pushl  0x8(%ebp)
  1033b3:	e8 43 ff ff ff       	call   1032fb <printnum>
  1033b8:	83 c4 20             	add    $0x20,%esp
  1033bb:	eb 1b                	jmp    1033d8 <printnum+0xdd>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1033bd:	83 ec 08             	sub    $0x8,%esp
  1033c0:	ff 75 0c             	pushl  0xc(%ebp)
  1033c3:	ff 75 20             	pushl  0x20(%ebp)
  1033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c9:	ff d0                	call   *%eax
  1033cb:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  1033ce:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1033d2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1033d6:	7f e5                	jg     1033bd <printnum+0xc2>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1033d8:	8d 93 22 57 ff ff    	lea    -0xa8de(%ebx),%edx
  1033de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1033e1:	01 d0                	add    %edx,%eax
  1033e3:	0f b6 00             	movzbl (%eax),%eax
  1033e6:	0f be c0             	movsbl %al,%eax
  1033e9:	83 ec 08             	sub    $0x8,%esp
  1033ec:	ff 75 0c             	pushl  0xc(%ebp)
  1033ef:	50                   	push   %eax
  1033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f3:	ff d0                	call   *%eax
  1033f5:	83 c4 10             	add    $0x10,%esp
}
  1033f8:	90                   	nop
  1033f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1033fc:	c9                   	leave  
  1033fd:	c3                   	ret    

001033fe <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1033fe:	55                   	push   %ebp
  1033ff:	89 e5                	mov    %esp,%ebp
  103401:	e8 76 ce ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  103406:	05 4a b5 00 00       	add    $0xb54a,%eax
    if (lflag >= 2) {
  10340b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10340f:	7e 14                	jle    103425 <getuint+0x27>
        return va_arg(*ap, unsigned long long);
  103411:	8b 45 08             	mov    0x8(%ebp),%eax
  103414:	8b 00                	mov    (%eax),%eax
  103416:	8d 48 08             	lea    0x8(%eax),%ecx
  103419:	8b 55 08             	mov    0x8(%ebp),%edx
  10341c:	89 0a                	mov    %ecx,(%edx)
  10341e:	8b 50 04             	mov    0x4(%eax),%edx
  103421:	8b 00                	mov    (%eax),%eax
  103423:	eb 30                	jmp    103455 <getuint+0x57>
    }
    else if (lflag) {
  103425:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103429:	74 16                	je     103441 <getuint+0x43>
        return va_arg(*ap, unsigned long);
  10342b:	8b 45 08             	mov    0x8(%ebp),%eax
  10342e:	8b 00                	mov    (%eax),%eax
  103430:	8d 48 04             	lea    0x4(%eax),%ecx
  103433:	8b 55 08             	mov    0x8(%ebp),%edx
  103436:	89 0a                	mov    %ecx,(%edx)
  103438:	8b 00                	mov    (%eax),%eax
  10343a:	ba 00 00 00 00       	mov    $0x0,%edx
  10343f:	eb 14                	jmp    103455 <getuint+0x57>
    }
    else {
        return va_arg(*ap, unsigned int);
  103441:	8b 45 08             	mov    0x8(%ebp),%eax
  103444:	8b 00                	mov    (%eax),%eax
  103446:	8d 48 04             	lea    0x4(%eax),%ecx
  103449:	8b 55 08             	mov    0x8(%ebp),%edx
  10344c:	89 0a                	mov    %ecx,(%edx)
  10344e:	8b 00                	mov    (%eax),%eax
  103450:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  103455:	5d                   	pop    %ebp
  103456:	c3                   	ret    

00103457 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103457:	55                   	push   %ebp
  103458:	89 e5                	mov    %esp,%ebp
  10345a:	e8 1d ce ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10345f:	05 f1 b4 00 00       	add    $0xb4f1,%eax
    if (lflag >= 2) {
  103464:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103468:	7e 14                	jle    10347e <getint+0x27>
        return va_arg(*ap, long long);
  10346a:	8b 45 08             	mov    0x8(%ebp),%eax
  10346d:	8b 00                	mov    (%eax),%eax
  10346f:	8d 48 08             	lea    0x8(%eax),%ecx
  103472:	8b 55 08             	mov    0x8(%ebp),%edx
  103475:	89 0a                	mov    %ecx,(%edx)
  103477:	8b 50 04             	mov    0x4(%eax),%edx
  10347a:	8b 00                	mov    (%eax),%eax
  10347c:	eb 28                	jmp    1034a6 <getint+0x4f>
    }
    else if (lflag) {
  10347e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103482:	74 12                	je     103496 <getint+0x3f>
        return va_arg(*ap, long);
  103484:	8b 45 08             	mov    0x8(%ebp),%eax
  103487:	8b 00                	mov    (%eax),%eax
  103489:	8d 48 04             	lea    0x4(%eax),%ecx
  10348c:	8b 55 08             	mov    0x8(%ebp),%edx
  10348f:	89 0a                	mov    %ecx,(%edx)
  103491:	8b 00                	mov    (%eax),%eax
  103493:	99                   	cltd   
  103494:	eb 10                	jmp    1034a6 <getint+0x4f>
    }
    else {
        return va_arg(*ap, int);
  103496:	8b 45 08             	mov    0x8(%ebp),%eax
  103499:	8b 00                	mov    (%eax),%eax
  10349b:	8d 48 04             	lea    0x4(%eax),%ecx
  10349e:	8b 55 08             	mov    0x8(%ebp),%edx
  1034a1:	89 0a                	mov    %ecx,(%edx)
  1034a3:	8b 00                	mov    (%eax),%eax
  1034a5:	99                   	cltd   
    }
}
  1034a6:	5d                   	pop    %ebp
  1034a7:	c3                   	ret    

001034a8 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1034a8:	55                   	push   %ebp
  1034a9:	89 e5                	mov    %esp,%ebp
  1034ab:	83 ec 18             	sub    $0x18,%esp
  1034ae:	e8 c9 cd ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1034b3:	05 9d b4 00 00       	add    $0xb49d,%eax
    va_list ap;

    va_start(ap, fmt);
  1034b8:	8d 45 14             	lea    0x14(%ebp),%eax
  1034bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1034be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034c1:	50                   	push   %eax
  1034c2:	ff 75 10             	pushl  0x10(%ebp)
  1034c5:	ff 75 0c             	pushl  0xc(%ebp)
  1034c8:	ff 75 08             	pushl  0x8(%ebp)
  1034cb:	e8 06 00 00 00       	call   1034d6 <vprintfmt>
  1034d0:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1034d3:	90                   	nop
  1034d4:	c9                   	leave  
  1034d5:	c3                   	ret    

001034d6 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1034d6:	55                   	push   %ebp
  1034d7:	89 e5                	mov    %esp,%ebp
  1034d9:	57                   	push   %edi
  1034da:	56                   	push   %esi
  1034db:	53                   	push   %ebx
  1034dc:	83 ec 2c             	sub    $0x2c,%esp
  1034df:	e8 8c 04 00 00       	call   103970 <__x86.get_pc_thunk.di>
  1034e4:	81 c7 6c b4 00 00    	add    $0xb46c,%edi
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1034ea:	eb 17                	jmp    103503 <vprintfmt+0x2d>
            if (ch == '\0') {
  1034ec:	85 db                	test   %ebx,%ebx
  1034ee:	0f 84 9a 03 00 00    	je     10388e <.L24+0x2d>
                return;
            }
            putch(ch, putdat);
  1034f4:	83 ec 08             	sub    $0x8,%esp
  1034f7:	ff 75 0c             	pushl  0xc(%ebp)
  1034fa:	53                   	push   %ebx
  1034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1034fe:	ff d0                	call   *%eax
  103500:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103503:	8b 45 10             	mov    0x10(%ebp),%eax
  103506:	8d 50 01             	lea    0x1(%eax),%edx
  103509:	89 55 10             	mov    %edx,0x10(%ebp)
  10350c:	0f b6 00             	movzbl (%eax),%eax
  10350f:	0f b6 d8             	movzbl %al,%ebx
  103512:	83 fb 25             	cmp    $0x25,%ebx
  103515:	75 d5                	jne    1034ec <vprintfmt+0x16>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103517:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
        width = precision = -1;
  10351b:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  103522:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103525:	89 45 d8             	mov    %eax,-0x28(%ebp)
        lflag = altflag = 0;
  103528:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  10352f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103532:	89 45 d0             	mov    %eax,-0x30(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103535:	8b 45 10             	mov    0x10(%ebp),%eax
  103538:	8d 50 01             	lea    0x1(%eax),%edx
  10353b:	89 55 10             	mov    %edx,0x10(%ebp)
  10353e:	0f b6 00             	movzbl (%eax),%eax
  103541:	0f b6 d8             	movzbl %al,%ebx
  103544:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103547:	83 f8 55             	cmp    $0x55,%eax
  10354a:	0f 87 11 03 00 00    	ja     103861 <.L24>
  103550:	c1 e0 02             	shl    $0x2,%eax
  103553:	8b 84 38 48 57 ff ff 	mov    -0xa8b8(%eax,%edi,1),%eax
  10355a:	01 f8                	add    %edi,%eax
  10355c:	ff e0                	jmp    *%eax

0010355e <.L29>:

        // flag to pad on the right
        case '-':
            padc = '-';
  10355e:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
            goto reswitch;
  103562:	eb d1                	jmp    103535 <vprintfmt+0x5f>

00103564 <.L31>:

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103564:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
            goto reswitch;
  103568:	eb cb                	jmp    103535 <vprintfmt+0x5f>

0010356a <.L32>:

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10356a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
                precision = precision * 10 + ch - '0';
  103571:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103574:	89 d0                	mov    %edx,%eax
  103576:	c1 e0 02             	shl    $0x2,%eax
  103579:	01 d0                	add    %edx,%eax
  10357b:	01 c0                	add    %eax,%eax
  10357d:	01 d8                	add    %ebx,%eax
  10357f:	83 e8 30             	sub    $0x30,%eax
  103582:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                ch = *fmt;
  103585:	8b 45 10             	mov    0x10(%ebp),%eax
  103588:	0f b6 00             	movzbl (%eax),%eax
  10358b:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10358e:	83 fb 2f             	cmp    $0x2f,%ebx
  103591:	7e 39                	jle    1035cc <.L25+0xc>
  103593:	83 fb 39             	cmp    $0x39,%ebx
  103596:	7f 34                	jg     1035cc <.L25+0xc>
            for (precision = 0; ; ++ fmt) {
  103598:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  10359c:	eb d3                	jmp    103571 <.L32+0x7>

0010359e <.L28>:
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10359e:	8b 45 14             	mov    0x14(%ebp),%eax
  1035a1:	8d 50 04             	lea    0x4(%eax),%edx
  1035a4:	89 55 14             	mov    %edx,0x14(%ebp)
  1035a7:	8b 00                	mov    (%eax),%eax
  1035a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            goto process_precision;
  1035ac:	eb 1f                	jmp    1035cd <.L25+0xd>

001035ae <.L30>:

        case '.':
            if (width < 0)
  1035ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1035b2:	79 81                	jns    103535 <vprintfmt+0x5f>
                width = 0;
  1035b4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
            goto reswitch;
  1035bb:	e9 75 ff ff ff       	jmp    103535 <vprintfmt+0x5f>

001035c0 <.L25>:

        case '#':
            altflag = 1;
  1035c0:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
            goto reswitch;
  1035c7:	e9 69 ff ff ff       	jmp    103535 <vprintfmt+0x5f>
            goto process_precision;
  1035cc:	90                   	nop

        process_precision:
            if (width < 0)
  1035cd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1035d1:	0f 89 5e ff ff ff    	jns    103535 <vprintfmt+0x5f>
                width = precision, precision = -1;
  1035d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1035da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1035dd:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
            goto reswitch;
  1035e4:	e9 4c ff ff ff       	jmp    103535 <vprintfmt+0x5f>

001035e9 <.L36>:

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1035e9:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
            goto reswitch;
  1035ed:	e9 43 ff ff ff       	jmp    103535 <vprintfmt+0x5f>

001035f2 <.L33>:

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1035f2:	8b 45 14             	mov    0x14(%ebp),%eax
  1035f5:	8d 50 04             	lea    0x4(%eax),%edx
  1035f8:	89 55 14             	mov    %edx,0x14(%ebp)
  1035fb:	8b 00                	mov    (%eax),%eax
  1035fd:	83 ec 08             	sub    $0x8,%esp
  103600:	ff 75 0c             	pushl  0xc(%ebp)
  103603:	50                   	push   %eax
  103604:	8b 45 08             	mov    0x8(%ebp),%eax
  103607:	ff d0                	call   *%eax
  103609:	83 c4 10             	add    $0x10,%esp
            break;
  10360c:	e9 78 02 00 00       	jmp    103889 <.L24+0x28>

00103611 <.L35>:

        // error message
        case 'e':
            err = va_arg(ap, int);
  103611:	8b 45 14             	mov    0x14(%ebp),%eax
  103614:	8d 50 04             	lea    0x4(%eax),%edx
  103617:	89 55 14             	mov    %edx,0x14(%ebp)
  10361a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10361c:	85 db                	test   %ebx,%ebx
  10361e:	79 02                	jns    103622 <.L35+0x11>
                err = -err;
  103620:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103622:	83 fb 06             	cmp    $0x6,%ebx
  103625:	7f 0b                	jg     103632 <.L35+0x21>
  103627:	8b b4 9f 40 01 00 00 	mov    0x140(%edi,%ebx,4),%esi
  10362e:	85 f6                	test   %esi,%esi
  103630:	75 1b                	jne    10364d <.L35+0x3c>
                printfmt(putch, putdat, "error %d", err);
  103632:	53                   	push   %ebx
  103633:	8d 87 33 57 ff ff    	lea    -0xa8cd(%edi),%eax
  103639:	50                   	push   %eax
  10363a:	ff 75 0c             	pushl  0xc(%ebp)
  10363d:	ff 75 08             	pushl  0x8(%ebp)
  103640:	e8 63 fe ff ff       	call   1034a8 <printfmt>
  103645:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103648:	e9 3c 02 00 00       	jmp    103889 <.L24+0x28>
                printfmt(putch, putdat, "%s", p);
  10364d:	56                   	push   %esi
  10364e:	8d 87 3c 57 ff ff    	lea    -0xa8c4(%edi),%eax
  103654:	50                   	push   %eax
  103655:	ff 75 0c             	pushl  0xc(%ebp)
  103658:	ff 75 08             	pushl  0x8(%ebp)
  10365b:	e8 48 fe ff ff       	call   1034a8 <printfmt>
  103660:	83 c4 10             	add    $0x10,%esp
            break;
  103663:	e9 21 02 00 00       	jmp    103889 <.L24+0x28>

00103668 <.L39>:

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103668:	8b 45 14             	mov    0x14(%ebp),%eax
  10366b:	8d 50 04             	lea    0x4(%eax),%edx
  10366e:	89 55 14             	mov    %edx,0x14(%ebp)
  103671:	8b 30                	mov    (%eax),%esi
  103673:	85 f6                	test   %esi,%esi
  103675:	75 06                	jne    10367d <.L39+0x15>
                p = "(null)";
  103677:	8d b7 3f 57 ff ff    	lea    -0xa8c1(%edi),%esi
            }
            if (width > 0 && padc != '-') {
  10367d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  103681:	7e 78                	jle    1036fb <.L39+0x93>
  103683:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  103687:	74 72                	je     1036fb <.L39+0x93>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103689:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10368c:	83 ec 08             	sub    $0x8,%esp
  10368f:	50                   	push   %eax
  103690:	56                   	push   %esi
  103691:	89 fb                	mov    %edi,%ebx
  103693:	e8 57 f7 ff ff       	call   102def <strnlen>
  103698:	83 c4 10             	add    $0x10,%esp
  10369b:	89 c2                	mov    %eax,%edx
  10369d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1036a0:	29 d0                	sub    %edx,%eax
  1036a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1036a5:	eb 17                	jmp    1036be <.L39+0x56>
                    putch(padc, putdat);
  1036a7:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  1036ab:	83 ec 08             	sub    $0x8,%esp
  1036ae:	ff 75 0c             	pushl  0xc(%ebp)
  1036b1:	50                   	push   %eax
  1036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1036b5:	ff d0                	call   *%eax
  1036b7:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  1036ba:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  1036be:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1036c2:	7f e3                	jg     1036a7 <.L39+0x3f>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1036c4:	eb 35                	jmp    1036fb <.L39+0x93>
                if (altflag && (ch < ' ' || ch > '~')) {
  1036c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1036ca:	74 1c                	je     1036e8 <.L39+0x80>
  1036cc:	83 fb 1f             	cmp    $0x1f,%ebx
  1036cf:	7e 05                	jle    1036d6 <.L39+0x6e>
  1036d1:	83 fb 7e             	cmp    $0x7e,%ebx
  1036d4:	7e 12                	jle    1036e8 <.L39+0x80>
                    putch('?', putdat);
  1036d6:	83 ec 08             	sub    $0x8,%esp
  1036d9:	ff 75 0c             	pushl  0xc(%ebp)
  1036dc:	6a 3f                	push   $0x3f
  1036de:	8b 45 08             	mov    0x8(%ebp),%eax
  1036e1:	ff d0                	call   *%eax
  1036e3:	83 c4 10             	add    $0x10,%esp
  1036e6:	eb 0f                	jmp    1036f7 <.L39+0x8f>
                }
                else {
                    putch(ch, putdat);
  1036e8:	83 ec 08             	sub    $0x8,%esp
  1036eb:	ff 75 0c             	pushl  0xc(%ebp)
  1036ee:	53                   	push   %ebx
  1036ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1036f2:	ff d0                	call   *%eax
  1036f4:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1036f7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  1036fb:	89 f0                	mov    %esi,%eax
  1036fd:	8d 70 01             	lea    0x1(%eax),%esi
  103700:	0f b6 00             	movzbl (%eax),%eax
  103703:	0f be d8             	movsbl %al,%ebx
  103706:	85 db                	test   %ebx,%ebx
  103708:	74 26                	je     103730 <.L39+0xc8>
  10370a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  10370e:	78 b6                	js     1036c6 <.L39+0x5e>
  103710:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  103714:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  103718:	79 ac                	jns    1036c6 <.L39+0x5e>
                }
            }
            for (; width > 0; width --) {
  10371a:	eb 14                	jmp    103730 <.L39+0xc8>
                putch(' ', putdat);
  10371c:	83 ec 08             	sub    $0x8,%esp
  10371f:	ff 75 0c             	pushl  0xc(%ebp)
  103722:	6a 20                	push   $0x20
  103724:	8b 45 08             	mov    0x8(%ebp),%eax
  103727:	ff d0                	call   *%eax
  103729:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  10372c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  103730:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  103734:	7f e6                	jg     10371c <.L39+0xb4>
            }
            break;
  103736:	e9 4e 01 00 00       	jmp    103889 <.L24+0x28>

0010373b <.L34>:

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10373b:	83 ec 08             	sub    $0x8,%esp
  10373e:	ff 75 d0             	pushl  -0x30(%ebp)
  103741:	8d 45 14             	lea    0x14(%ebp),%eax
  103744:	50                   	push   %eax
  103745:	e8 0d fd ff ff       	call   103457 <getint>
  10374a:	83 c4 10             	add    $0x10,%esp
  10374d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103750:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            if ((long long)num < 0) {
  103753:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103756:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103759:	85 d2                	test   %edx,%edx
  10375b:	79 23                	jns    103780 <.L34+0x45>
                putch('-', putdat);
  10375d:	83 ec 08             	sub    $0x8,%esp
  103760:	ff 75 0c             	pushl  0xc(%ebp)
  103763:	6a 2d                	push   $0x2d
  103765:	8b 45 08             	mov    0x8(%ebp),%eax
  103768:	ff d0                	call   *%eax
  10376a:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  10376d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103770:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103773:	f7 d8                	neg    %eax
  103775:	83 d2 00             	adc    $0x0,%edx
  103778:	f7 da                	neg    %edx
  10377a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10377d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            }
            base = 10;
  103780:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
  103787:	e9 9f 00 00 00       	jmp    10382b <.L41+0x1f>

0010378c <.L40>:

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10378c:	83 ec 08             	sub    $0x8,%esp
  10378f:	ff 75 d0             	pushl  -0x30(%ebp)
  103792:	8d 45 14             	lea    0x14(%ebp),%eax
  103795:	50                   	push   %eax
  103796:	e8 63 fc ff ff       	call   1033fe <getuint>
  10379b:	83 c4 10             	add    $0x10,%esp
  10379e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1037a1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 10;
  1037a4:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
            goto number;
  1037ab:	eb 7e                	jmp    10382b <.L41+0x1f>

001037ad <.L37>:

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1037ad:	83 ec 08             	sub    $0x8,%esp
  1037b0:	ff 75 d0             	pushl  -0x30(%ebp)
  1037b3:	8d 45 14             	lea    0x14(%ebp),%eax
  1037b6:	50                   	push   %eax
  1037b7:	e8 42 fc ff ff       	call   1033fe <getuint>
  1037bc:	83 c4 10             	add    $0x10,%esp
  1037bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1037c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 8;
  1037c5:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
            goto number;
  1037cc:	eb 5d                	jmp    10382b <.L41+0x1f>

001037ce <.L38>:

        // pointer
        case 'p':
            putch('0', putdat);
  1037ce:	83 ec 08             	sub    $0x8,%esp
  1037d1:	ff 75 0c             	pushl  0xc(%ebp)
  1037d4:	6a 30                	push   $0x30
  1037d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1037d9:	ff d0                	call   *%eax
  1037db:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  1037de:	83 ec 08             	sub    $0x8,%esp
  1037e1:	ff 75 0c             	pushl  0xc(%ebp)
  1037e4:	6a 78                	push   $0x78
  1037e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1037e9:	ff d0                	call   *%eax
  1037eb:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1037ee:	8b 45 14             	mov    0x14(%ebp),%eax
  1037f1:	8d 50 04             	lea    0x4(%eax),%edx
  1037f4:	89 55 14             	mov    %edx,0x14(%ebp)
  1037f7:	8b 00                	mov    (%eax),%eax
  1037f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1037fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            base = 16;
  103803:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
            goto number;
  10380a:	eb 1f                	jmp    10382b <.L41+0x1f>

0010380c <.L41>:

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10380c:	83 ec 08             	sub    $0x8,%esp
  10380f:	ff 75 d0             	pushl  -0x30(%ebp)
  103812:	8d 45 14             	lea    0x14(%ebp),%eax
  103815:	50                   	push   %eax
  103816:	e8 e3 fb ff ff       	call   1033fe <getuint>
  10381b:	83 c4 10             	add    $0x10,%esp
  10381e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103821:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            base = 16;
  103824:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10382b:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  10382f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103832:	83 ec 04             	sub    $0x4,%esp
  103835:	52                   	push   %edx
  103836:	ff 75 d8             	pushl  -0x28(%ebp)
  103839:	50                   	push   %eax
  10383a:	ff 75 e4             	pushl  -0x1c(%ebp)
  10383d:	ff 75 e0             	pushl  -0x20(%ebp)
  103840:	ff 75 0c             	pushl  0xc(%ebp)
  103843:	ff 75 08             	pushl  0x8(%ebp)
  103846:	e8 b0 fa ff ff       	call   1032fb <printnum>
  10384b:	83 c4 20             	add    $0x20,%esp
            break;
  10384e:	eb 39                	jmp    103889 <.L24+0x28>

00103850 <.L27>:

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103850:	83 ec 08             	sub    $0x8,%esp
  103853:	ff 75 0c             	pushl  0xc(%ebp)
  103856:	53                   	push   %ebx
  103857:	8b 45 08             	mov    0x8(%ebp),%eax
  10385a:	ff d0                	call   *%eax
  10385c:	83 c4 10             	add    $0x10,%esp
            break;
  10385f:	eb 28                	jmp    103889 <.L24+0x28>

00103861 <.L24>:

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103861:	83 ec 08             	sub    $0x8,%esp
  103864:	ff 75 0c             	pushl  0xc(%ebp)
  103867:	6a 25                	push   $0x25
  103869:	8b 45 08             	mov    0x8(%ebp),%eax
  10386c:	ff d0                	call   *%eax
  10386e:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  103871:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103875:	eb 04                	jmp    10387b <.L24+0x1a>
  103877:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10387b:	8b 45 10             	mov    0x10(%ebp),%eax
  10387e:	83 e8 01             	sub    $0x1,%eax
  103881:	0f b6 00             	movzbl (%eax),%eax
  103884:	3c 25                	cmp    $0x25,%al
  103886:	75 ef                	jne    103877 <.L24+0x16>
                /* do nothing */;
            break;
  103888:	90                   	nop
    while (1) {
  103889:	e9 5c fc ff ff       	jmp    1034ea <vprintfmt+0x14>
                return;
  10388e:	90                   	nop
        }
    }
}
  10388f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  103892:	5b                   	pop    %ebx
  103893:	5e                   	pop    %esi
  103894:	5f                   	pop    %edi
  103895:	5d                   	pop    %ebp
  103896:	c3                   	ret    

00103897 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103897:	55                   	push   %ebp
  103898:	89 e5                	mov    %esp,%ebp
  10389a:	e8 dd c9 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  10389f:	05 b1 b0 00 00       	add    $0xb0b1,%eax
    b->cnt ++;
  1038a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038a7:	8b 40 08             	mov    0x8(%eax),%eax
  1038aa:	8d 50 01             	lea    0x1(%eax),%edx
  1038ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038b0:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1038b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038b6:	8b 10                	mov    (%eax),%edx
  1038b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038bb:	8b 40 04             	mov    0x4(%eax),%eax
  1038be:	39 c2                	cmp    %eax,%edx
  1038c0:	73 12                	jae    1038d4 <sprintputch+0x3d>
        *b->buf ++ = ch;
  1038c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038c5:	8b 00                	mov    (%eax),%eax
  1038c7:	8d 48 01             	lea    0x1(%eax),%ecx
  1038ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  1038cd:	89 0a                	mov    %ecx,(%edx)
  1038cf:	8b 55 08             	mov    0x8(%ebp),%edx
  1038d2:	88 10                	mov    %dl,(%eax)
    }
}
  1038d4:	90                   	nop
  1038d5:	5d                   	pop    %ebp
  1038d6:	c3                   	ret    

001038d7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1038d7:	55                   	push   %ebp
  1038d8:	89 e5                	mov    %esp,%ebp
  1038da:	83 ec 18             	sub    $0x18,%esp
  1038dd:	e8 9a c9 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  1038e2:	05 6e b0 00 00       	add    $0xb06e,%eax
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1038e7:	8d 45 14             	lea    0x14(%ebp),%eax
  1038ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1038ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038f0:	50                   	push   %eax
  1038f1:	ff 75 10             	pushl  0x10(%ebp)
  1038f4:	ff 75 0c             	pushl  0xc(%ebp)
  1038f7:	ff 75 08             	pushl  0x8(%ebp)
  1038fa:	e8 0b 00 00 00       	call   10390a <vsnprintf>
  1038ff:	83 c4 10             	add    $0x10,%esp
  103902:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103905:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103908:	c9                   	leave  
  103909:	c3                   	ret    

0010390a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10390a:	55                   	push   %ebp
  10390b:	89 e5                	mov    %esp,%ebp
  10390d:	83 ec 18             	sub    $0x18,%esp
  103910:	e8 67 c9 ff ff       	call   10027c <__x86.get_pc_thunk.ax>
  103915:	05 3b b0 00 00       	add    $0xb03b,%eax
    struct sprintbuf b = {str, str + size - 1, 0};
  10391a:	8b 55 08             	mov    0x8(%ebp),%edx
  10391d:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103920:	8b 55 0c             	mov    0xc(%ebp),%edx
  103923:	8d 4a ff             	lea    -0x1(%edx),%ecx
  103926:	8b 55 08             	mov    0x8(%ebp),%edx
  103929:	01 ca                	add    %ecx,%edx
  10392b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10392e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103935:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103939:	74 0a                	je     103945 <vsnprintf+0x3b>
  10393b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10393e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103941:	39 d1                	cmp    %edx,%ecx
  103943:	76 07                	jbe    10394c <vsnprintf+0x42>
        return -E_INVAL;
  103945:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10394a:	eb 22                	jmp    10396e <vsnprintf+0x64>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10394c:	ff 75 14             	pushl  0x14(%ebp)
  10394f:	ff 75 10             	pushl  0x10(%ebp)
  103952:	8d 55 ec             	lea    -0x14(%ebp),%edx
  103955:	52                   	push   %edx
  103956:	8d 80 47 4f ff ff    	lea    -0xb0b9(%eax),%eax
  10395c:	50                   	push   %eax
  10395d:	e8 74 fb ff ff       	call   1034d6 <vprintfmt>
  103962:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103965:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103968:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10396b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10396e:	c9                   	leave  
  10396f:	c3                   	ret    

00103970 <__x86.get_pc_thunk.di>:
  103970:	8b 3c 24             	mov    (%esp),%edi
  103973:	c3                   	ret    
