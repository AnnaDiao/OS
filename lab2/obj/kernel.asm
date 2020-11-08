
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 a0 11 00 	lgdtl  0x11a018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 a0 11 c0       	mov    $0xc011a000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba ac 23 2a c0       	mov    $0xc02a23ac,%edx
c0100035:	b8 36 aa 11 c0       	mov    $0xc011aa36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 aa 11 c0 	movl   $0xc011aa36,(%esp)
c0100051:	e8 74 71 00 00       	call   c01071ca <memset>

    cons_init();                // init the console
c0100056:	e8 71 15 00 00       	call   c01015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 60 73 10 c0 	movl   $0xc0107360,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 7c 73 10 c0 	movl   $0xc010737c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 eb 55 00 00       	call   c010566f <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 ac 16 00 00       	call   c0101735 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 fe 17 00 00       	call   c010188c <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 ef 0c 00 00       	call   c0100d82 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 0b 16 00 00       	call   c01016a3 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 f8 0b 00 00       	call   c0100cb4 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 81 73 10 c0 	movl   $0xc0107381,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 8f 73 10 c0 	movl   $0xc010738f,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 9d 73 10 c0 	movl   $0xc010739d,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 ab 73 10 c0 	movl   $0xc01073ab,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 b9 73 10 c0 	movl   $0xc01073b9,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 aa 11 c0       	mov    0xc011aa40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 aa 11 c0       	mov    %eax,0xc011aa40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 c8 73 10 c0 	movl   $0xc01073c8,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 e8 73 10 c0 	movl   $0xc01073e8,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 07 74 10 c0 	movl   $0xc0107407,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 aa 11 c0    	mov    %dl,-0x3fee55a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 aa 11 c0       	add    $0xc011aa60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 aa 11 c0       	mov    $0xc011aa60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 fe 12 00 00       	call   c01015f8 <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 ac 66 00 00       	call   c01069e3 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 85 12 00 00       	call   c01015f8 <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 65 12 00 00       	call   c0101634 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 0c 74 10 c0    	movl   $0xc010740c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 0c 74 10 c0 	movl   $0xc010740c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 f4 87 10 c0 	movl   $0xc01087f4,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 0c 4e 11 c0 	movl   $0xc0114e0c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 0d 4e 11 c0 	movl   $0xc0114e0d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 e7 7b 11 c0 	movl   $0xc0117be7,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 52 69 00 00       	call   c010703e <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 16 74 10 c0 	movl   $0xc0107416,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 2f 74 10 c0 	movl   $0xc010742f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 53 73 10 	movl   $0xc0107353,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 47 74 10 c0 	movl   $0xc0107447,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 aa 11 	movl   $0xc011aa36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 5f 74 10 c0 	movl   $0xc010745f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 ac 23 2a 	movl   $0xc02a23ac,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 77 74 10 c0 	movl   $0xc0107477,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 ac 23 2a c0       	mov    $0xc02a23ac,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 90 74 10 c0 	movl   $0xc0107490,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 ba 74 10 c0 	movl   $0xc01074ba,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 d6 74 10 c0 	movl   $0xc01074d6,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 88 00 00 00       	jmp    c0100a67 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ed:	c7 04 24 e8 74 10 c0 	movl   $0xc01074e8,(%esp)
c01009f4:	e8 43 f9 ff ff       	call   c010033c <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c01009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fc:	83 c0 08             	add    $0x8,%eax
c01009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a09:	eb 25                	jmp    c0100a30 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a18:	01 d0                	add    %edx,%eax
c0100a1a:	8b 00                	mov    (%eax),%eax
c0100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a20:	c7 04 24 04 75 10 c0 	movl   $0xc0107504,(%esp)
c0100a27:	e8 10 f9 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a34:	7e d5                	jle    c0100a0b <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a36:	c7 04 24 0c 75 10 c0 	movl   $0xc010750c,(%esp)
c0100a3d:	e8 fa f8 ff ff       	call   c010033c <cprintf>
        print_debuginfo(eip - 1);
c0100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a45:	83 e8 01             	sub    $0x1,%eax
c0100a48:	89 04 24             	mov    %eax,(%esp)
c0100a4b:	e8 b6 fe ff ff       	call   c0100906 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a53:	83 c0 04             	add    $0x4,%eax
c0100a56:	8b 00                	mov    (%eax),%eax
c0100a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5e:	8b 00                	mov    (%eax),%eax
c0100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a6b:	74 0a                	je     c0100a77 <print_stackframe+0xbd>
c0100a6d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a71:	0f 8e 68 ff ff ff    	jle    c01009df <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a77:	c9                   	leave  
c0100a78:	c3                   	ret    

c0100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a79:	55                   	push   %ebp
c0100a7a:	89 e5                	mov    %esp,%ebp
c0100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a86:	eb 0c                	jmp    c0100a94 <parse+0x1b>
            *buf ++ = '\0';
c0100a88:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a8b:	8d 50 01             	lea    0x1(%eax),%edx
c0100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a91:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a97:	0f b6 00             	movzbl (%eax),%eax
c0100a9a:	84 c0                	test   %al,%al
c0100a9c:	74 1d                	je     c0100abb <parse+0x42>
c0100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa1:	0f b6 00             	movzbl (%eax),%eax
c0100aa4:	0f be c0             	movsbl %al,%eax
c0100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aab:	c7 04 24 90 75 10 c0 	movl   $0xc0107590,(%esp)
c0100ab2:	e8 54 65 00 00       	call   c010700b <strchr>
c0100ab7:	85 c0                	test   %eax,%eax
c0100ab9:	75 cd                	jne    c0100a88 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abe:	0f b6 00             	movzbl (%eax),%eax
c0100ac1:	84 c0                	test   %al,%al
c0100ac3:	75 02                	jne    c0100ac7 <parse+0x4e>
            break;
c0100ac5:	eb 67                	jmp    c0100b2e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ac7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100acb:	75 14                	jne    c0100ae1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100acd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad4:	00 
c0100ad5:	c7 04 24 95 75 10 c0 	movl   $0xc0107595,(%esp)
c0100adc:	e8 5b f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae4:	8d 50 01             	lea    0x1(%eax),%edx
c0100ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af4:	01 c2                	add    %eax,%edx
c0100af6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100afb:	eb 04                	jmp    c0100b01 <parse+0x88>
            buf ++;
c0100afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b01:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b04:	0f b6 00             	movzbl (%eax),%eax
c0100b07:	84 c0                	test   %al,%al
c0100b09:	74 1d                	je     c0100b28 <parse+0xaf>
c0100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0e:	0f b6 00             	movzbl (%eax),%eax
c0100b11:	0f be c0             	movsbl %al,%eax
c0100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b18:	c7 04 24 90 75 10 c0 	movl   $0xc0107590,(%esp)
c0100b1f:	e8 e7 64 00 00       	call   c010700b <strchr>
c0100b24:	85 c0                	test   %eax,%eax
c0100b26:	74 d5                	je     c0100afd <parse+0x84>
            buf ++;
        }
    }
c0100b28:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b29:	e9 66 ff ff ff       	jmp    c0100a94 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b31:	c9                   	leave  
c0100b32:	c3                   	ret    

c0100b33 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b33:	55                   	push   %ebp
c0100b34:	89 e5                	mov    %esp,%ebp
c0100b36:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b39:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b40:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b43:	89 04 24             	mov    %eax,(%esp)
c0100b46:	e8 2e ff ff ff       	call   c0100a79 <parse>
c0100b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b52:	75 0a                	jne    c0100b5e <runcmd+0x2b>
        return 0;
c0100b54:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b59:	e9 85 00 00 00       	jmp    c0100be3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b65:	eb 5c                	jmp    c0100bc3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b67:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b6d:	89 d0                	mov    %edx,%eax
c0100b6f:	01 c0                	add    %eax,%eax
c0100b71:	01 d0                	add    %edx,%eax
c0100b73:	c1 e0 02             	shl    $0x2,%eax
c0100b76:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c0100b7b:	8b 00                	mov    (%eax),%eax
c0100b7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b81:	89 04 24             	mov    %eax,(%esp)
c0100b84:	e8 e3 63 00 00       	call   c0106f6c <strcmp>
c0100b89:	85 c0                	test   %eax,%eax
c0100b8b:	75 32                	jne    c0100bbf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b90:	89 d0                	mov    %edx,%eax
c0100b92:	01 c0                	add    %eax,%eax
c0100b94:	01 d0                	add    %edx,%eax
c0100b96:	c1 e0 02             	shl    $0x2,%eax
c0100b99:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c0100b9e:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100ba4:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100baa:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bae:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb1:	83 c2 04             	add    $0x4,%edx
c0100bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bb8:	89 0c 24             	mov    %ecx,(%esp)
c0100bbb:	ff d0                	call   *%eax
c0100bbd:	eb 24                	jmp    c0100be3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc6:	83 f8 02             	cmp    $0x2,%eax
c0100bc9:	76 9c                	jbe    c0100b67 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd2:	c7 04 24 b3 75 10 c0 	movl   $0xc01075b3,(%esp)
c0100bd9:	e8 5e f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be3:	c9                   	leave  
c0100be4:	c3                   	ret    

c0100be5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100be5:	55                   	push   %ebp
c0100be6:	89 e5                	mov    %esp,%ebp
c0100be8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100beb:	c7 04 24 cc 75 10 c0 	movl   $0xc01075cc,(%esp)
c0100bf2:	e8 45 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bf7:	c7 04 24 f4 75 10 c0 	movl   $0xc01075f4,(%esp)
c0100bfe:	e8 39 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c07:	74 0b                	je     c0100c14 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0c:	89 04 24             	mov    %eax,(%esp)
c0100c0f:	e8 b1 0d 00 00       	call   c01019c5 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c14:	c7 04 24 19 76 10 c0 	movl   $0xc0107619,(%esp)
c0100c1b:	e8 13 f6 ff ff       	call   c0100233 <readline>
c0100c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c27:	74 18                	je     c0100c41 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c33:	89 04 24             	mov    %eax,(%esp)
c0100c36:	e8 f8 fe ff ff       	call   c0100b33 <runcmd>
c0100c3b:	85 c0                	test   %eax,%eax
c0100c3d:	79 02                	jns    c0100c41 <kmonitor+0x5c>
                break;
c0100c3f:	eb 02                	jmp    c0100c43 <kmonitor+0x5e>
            }
        }
    }
c0100c41:	eb d1                	jmp    c0100c14 <kmonitor+0x2f>
}
c0100c43:	c9                   	leave  
c0100c44:	c3                   	ret    

c0100c45 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c45:	55                   	push   %ebp
c0100c46:	89 e5                	mov    %esp,%ebp
c0100c48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c52:	eb 3f                	jmp    c0100c93 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c57:	89 d0                	mov    %edx,%eax
c0100c59:	01 c0                	add    %eax,%eax
c0100c5b:	01 d0                	add    %edx,%eax
c0100c5d:	c1 e0 02             	shl    $0x2,%eax
c0100c60:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c0100c65:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6b:	89 d0                	mov    %edx,%eax
c0100c6d:	01 c0                	add    %eax,%eax
c0100c6f:	01 d0                	add    %edx,%eax
c0100c71:	c1 e0 02             	shl    $0x2,%eax
c0100c74:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c0100c79:	8b 00                	mov    (%eax),%eax
c0100c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c83:	c7 04 24 1d 76 10 c0 	movl   $0xc010761d,(%esp)
c0100c8a:	e8 ad f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c96:	83 f8 02             	cmp    $0x2,%eax
c0100c99:	76 b9                	jbe    c0100c54 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca0:	c9                   	leave  
c0100ca1:	c3                   	ret    

c0100ca2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca2:	55                   	push   %ebp
c0100ca3:	89 e5                	mov    %esp,%ebp
c0100ca5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ca8:	e8 c3 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb2:	c9                   	leave  
c0100cb3:	c3                   	ret    

c0100cb4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cb4:	55                   	push   %ebp
c0100cb5:	89 e5                	mov    %esp,%ebp
c0100cb7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cba:	e8 fb fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc4:	c9                   	leave  
c0100cc5:	c3                   	ret    

c0100cc6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cc6:	55                   	push   %ebp
c0100cc7:	89 e5                	mov    %esp,%ebp
c0100cc9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ccc:	a1 60 ae 11 c0       	mov    0xc011ae60,%eax
c0100cd1:	85 c0                	test   %eax,%eax
c0100cd3:	74 02                	je     c0100cd7 <__panic+0x11>
        goto panic_dead;
c0100cd5:	eb 48                	jmp    c0100d1f <__panic+0x59>
    }
    is_panic = 1;
c0100cd7:	c7 05 60 ae 11 c0 01 	movl   $0x1,0xc011ae60
c0100cde:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce1:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cea:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf5:	c7 04 24 26 76 10 c0 	movl   $0xc0107626,(%esp)
c0100cfc:	e8 3b f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d08:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d0b:	89 04 24             	mov    %eax,(%esp)
c0100d0e:	e8 f6 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d13:	c7 04 24 42 76 10 c0 	movl   $0xc0107642,(%esp)
c0100d1a:	e8 1d f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d1f:	e8 85 09 00 00       	call   c01016a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d2b:	e8 b5 fe ff ff       	call   c0100be5 <kmonitor>
    }
c0100d30:	eb f2                	jmp    c0100d24 <__panic+0x5e>

c0100d32 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d32:	55                   	push   %ebp
c0100d33:	89 e5                	mov    %esp,%ebp
c0100d35:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d38:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d41:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d45:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d4c:	c7 04 24 44 76 10 c0 	movl   $0xc0107644,(%esp)
c0100d53:	e8 e4 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d62:	89 04 24             	mov    %eax,(%esp)
c0100d65:	e8 9f f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d6a:	c7 04 24 42 76 10 c0 	movl   $0xc0107642,(%esp)
c0100d71:	e8 c6 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d76:	c9                   	leave  
c0100d77:	c3                   	ret    

c0100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d78:	55                   	push   %ebp
c0100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d7b:	a1 60 ae 11 c0       	mov    0xc011ae60,%eax
}
c0100d80:	5d                   	pop    %ebp
c0100d81:	c3                   	ret    

c0100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d82:	55                   	push   %ebp
c0100d83:	89 e5                	mov    %esp,%ebp
c0100d85:	83 ec 28             	sub    $0x28,%esp
c0100d88:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d8e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d9a:	ee                   	out    %al,(%dx)
c0100d9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da1:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100da5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100da9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dad:	ee                   	out    %al,(%dx)
c0100dae:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100db8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc1:	c7 05 4c b9 11 c0 00 	movl   $0x0,0xc011b94c
c0100dc8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dcb:	c7 04 24 62 76 10 c0 	movl   $0xc0107662,(%esp)
c0100dd2:	e8 65 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dde:	e8 24 09 00 00       	call   c0101707 <pic_enable>
}
c0100de3:	c9                   	leave  
c0100de4:	c3                   	ret    

c0100de5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100de5:	55                   	push   %ebp
c0100de6:	89 e5                	mov    %esp,%ebp
c0100de8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100deb:	9c                   	pushf  
c0100dec:	58                   	pop    %eax
c0100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df3:	25 00 02 00 00       	and    $0x200,%eax
c0100df8:	85 c0                	test   %eax,%eax
c0100dfa:	74 0c                	je     c0100e08 <__intr_save+0x23>
        intr_disable();
c0100dfc:	e8 a8 08 00 00       	call   c01016a9 <intr_disable>
        return 1;
c0100e01:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e06:	eb 05                	jmp    c0100e0d <__intr_save+0x28>
    }
    return 0;
c0100e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e0d:	c9                   	leave  
c0100e0e:	c3                   	ret    

c0100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e0f:	55                   	push   %ebp
c0100e10:	89 e5                	mov    %esp,%ebp
c0100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e19:	74 05                	je     c0100e20 <__intr_restore+0x11>
        intr_enable();
c0100e1b:	e8 83 08 00 00       	call   c01016a3 <intr_enable>
    }
}
c0100e20:	c9                   	leave  
c0100e21:	c3                   	ret    

c0100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e22:	55                   	push   %ebp
c0100e23:	89 e5                	mov    %esp,%ebp
c0100e25:	83 ec 10             	sub    $0x10,%esp
c0100e28:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e32:	89 c2                	mov    %eax,%edx
c0100e34:	ec                   	in     (%dx),%al
c0100e35:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e42:	89 c2                	mov    %eax,%edx
c0100e44:	ec                   	in     (%dx),%al
c0100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e48:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e52:	89 c2                	mov    %eax,%edx
c0100e54:	ec                   	in     (%dx),%al
c0100e55:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e58:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e62:	89 c2                	mov    %eax,%edx
c0100e64:	ec                   	in     (%dx),%al
c0100e65:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e68:	c9                   	leave  
c0100e69:	c3                   	ret    

c0100e6a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e6a:	55                   	push   %ebp
c0100e6b:	89 e5                	mov    %esp,%ebp
c0100e6d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e70:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7a:	0f b7 00             	movzwl (%eax),%eax
c0100e7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e84:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8c:	0f b7 00             	movzwl (%eax),%eax
c0100e8f:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e93:	74 12                	je     c0100ea7 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e95:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e9c:	66 c7 05 86 ae 11 c0 	movw   $0x3b4,0xc011ae86
c0100ea3:	b4 03 
c0100ea5:	eb 13                	jmp    c0100eba <cga_init+0x50>
    } else {
        *cp = was;
c0100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eaa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eae:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb1:	66 c7 05 86 ae 11 c0 	movw   $0x3d4,0xc011ae86
c0100eb8:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eba:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0100ec1:	0f b7 c0             	movzwl %ax,%eax
c0100ec4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ec8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ecc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ed5:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0100edc:	83 c0 01             	add    $0x1,%eax
c0100edf:	0f b7 c0             	movzwl %ax,%eax
c0100ee2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100eea:	89 c2                	mov    %eax,%edx
c0100eec:	ec                   	in     (%dx),%al
c0100eed:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ef4:	0f b6 c0             	movzbl %al,%eax
c0100ef7:	c1 e0 08             	shl    $0x8,%eax
c0100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100efd:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0100f04:	0f b7 c0             	movzwl %ax,%eax
c0100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f0b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f0f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f13:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f17:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f18:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0100f1f:	83 c0 01             	add    $0x1,%eax
c0100f22:	0f b7 c0             	movzwl %ax,%eax
c0100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f29:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f2d:	89 c2                	mov    %eax,%edx
c0100f2f:	ec                   	in     (%dx),%al
c0100f30:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f33:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f37:	0f b6 c0             	movzbl %al,%eax
c0100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f40:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    crt_pos = pos;
c0100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f48:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
}
c0100f4e:	c9                   	leave  
c0100f4f:	c3                   	ret    

c0100f50 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f50:	55                   	push   %ebp
c0100f51:	89 e5                	mov    %esp,%ebp
c0100f53:	83 ec 48             	sub    $0x48,%esp
c0100f56:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f5c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f60:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f68:	ee                   	out    %al,(%dx)
c0100f69:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f6f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f73:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f77:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f7b:	ee                   	out    %al,(%dx)
c0100f7c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f82:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8e:	ee                   	out    %al,(%dx)
c0100f8f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f99:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f9d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa1:	ee                   	out    %al,(%dx)
c0100fa2:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fa8:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fb4:	ee                   	out    %al,(%dx)
c0100fb5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fbb:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fc7:	ee                   	out    %al,(%dx)
c0100fc8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fce:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fd6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fda:	ee                   	out    %al,(%dx)
c0100fdb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fe5:	89 c2                	mov    %eax,%edx
c0100fe7:	ec                   	in     (%dx),%al
c0100fe8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100feb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fef:	3c ff                	cmp    $0xff,%al
c0100ff1:	0f 95 c0             	setne  %al
c0100ff4:	0f b6 c0             	movzbl %al,%eax
c0100ff7:	a3 88 ae 11 c0       	mov    %eax,0xc011ae88
c0100ffc:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101002:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101006:	89 c2                	mov    %eax,%edx
c0101008:	ec                   	in     (%dx),%al
c0101009:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010100c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101012:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101016:	89 c2                	mov    %eax,%edx
c0101018:	ec                   	in     (%dx),%al
c0101019:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010101c:	a1 88 ae 11 c0       	mov    0xc011ae88,%eax
c0101021:	85 c0                	test   %eax,%eax
c0101023:	74 0c                	je     c0101031 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010102c:	e8 d6 06 00 00       	call   c0101707 <pic_enable>
    }
}
c0101031:	c9                   	leave  
c0101032:	c3                   	ret    

c0101033 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101033:	55                   	push   %ebp
c0101034:	89 e5                	mov    %esp,%ebp
c0101036:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101040:	eb 09                	jmp    c010104b <lpt_putc_sub+0x18>
        delay();
c0101042:	e8 db fd ff ff       	call   c0100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101047:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010104b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101051:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101055:	89 c2                	mov    %eax,%edx
c0101057:	ec                   	in     (%dx),%al
c0101058:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010105b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010105f:	84 c0                	test   %al,%al
c0101061:	78 09                	js     c010106c <lpt_putc_sub+0x39>
c0101063:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010106a:	7e d6                	jle    c0101042 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010106c:	8b 45 08             	mov    0x8(%ebp),%eax
c010106f:	0f b6 c0             	movzbl %al,%eax
c0101072:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101078:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101083:	ee                   	out    %al,(%dx)
c0101084:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010108a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010108e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101092:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101096:	ee                   	out    %al,(%dx)
c0101097:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c010109d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010a9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010aa:	c9                   	leave  
c01010ab:	c3                   	ret    

c01010ac <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010ac:	55                   	push   %ebp
c01010ad:	89 e5                	mov    %esp,%ebp
c01010af:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b6:	74 0d                	je     c01010c5 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01010bb:	89 04 24             	mov    %eax,(%esp)
c01010be:	e8 70 ff ff ff       	call   c0101033 <lpt_putc_sub>
c01010c3:	eb 24                	jmp    c01010e9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010cc:	e8 62 ff ff ff       	call   c0101033 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010d8:	e8 56 ff ff ff       	call   c0101033 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e4:	e8 4a ff ff ff       	call   c0101033 <lpt_putc_sub>
    }
}
c01010e9:	c9                   	leave  
c01010ea:	c3                   	ret    

c01010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010eb:	55                   	push   %ebp
c01010ec:	89 e5                	mov    %esp,%ebp
c01010ee:	53                   	push   %ebx
c01010ef:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f5:	b0 00                	mov    $0x0,%al
c01010f7:	85 c0                	test   %eax,%eax
c01010f9:	75 07                	jne    c0101102 <cga_putc+0x17>
        c |= 0x0700;
c01010fb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101102:	8b 45 08             	mov    0x8(%ebp),%eax
c0101105:	0f b6 c0             	movzbl %al,%eax
c0101108:	83 f8 0a             	cmp    $0xa,%eax
c010110b:	74 4c                	je     c0101159 <cga_putc+0x6e>
c010110d:	83 f8 0d             	cmp    $0xd,%eax
c0101110:	74 57                	je     c0101169 <cga_putc+0x7e>
c0101112:	83 f8 08             	cmp    $0x8,%eax
c0101115:	0f 85 88 00 00 00    	jne    c01011a3 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010111b:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c0101122:	66 85 c0             	test   %ax,%ax
c0101125:	74 30                	je     c0101157 <cga_putc+0x6c>
            crt_pos --;
c0101127:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c010112e:	83 e8 01             	sub    $0x1,%eax
c0101131:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101137:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010113c:	0f b7 15 84 ae 11 c0 	movzwl 0xc011ae84,%edx
c0101143:	0f b7 d2             	movzwl %dx,%edx
c0101146:	01 d2                	add    %edx,%edx
c0101148:	01 c2                	add    %eax,%edx
c010114a:	8b 45 08             	mov    0x8(%ebp),%eax
c010114d:	b0 00                	mov    $0x0,%al
c010114f:	83 c8 20             	or     $0x20,%eax
c0101152:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101155:	eb 72                	jmp    c01011c9 <cga_putc+0xde>
c0101157:	eb 70                	jmp    c01011c9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101159:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c0101160:	83 c0 50             	add    $0x50,%eax
c0101163:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101169:	0f b7 1d 84 ae 11 c0 	movzwl 0xc011ae84,%ebx
c0101170:	0f b7 0d 84 ae 11 c0 	movzwl 0xc011ae84,%ecx
c0101177:	0f b7 c1             	movzwl %cx,%eax
c010117a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101180:	c1 e8 10             	shr    $0x10,%eax
c0101183:	89 c2                	mov    %eax,%edx
c0101185:	66 c1 ea 06          	shr    $0x6,%dx
c0101189:	89 d0                	mov    %edx,%eax
c010118b:	c1 e0 02             	shl    $0x2,%eax
c010118e:	01 d0                	add    %edx,%eax
c0101190:	c1 e0 04             	shl    $0x4,%eax
c0101193:	29 c1                	sub    %eax,%ecx
c0101195:	89 ca                	mov    %ecx,%edx
c0101197:	89 d8                	mov    %ebx,%eax
c0101199:	29 d0                	sub    %edx,%eax
c010119b:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
        break;
c01011a1:	eb 26                	jmp    c01011c9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a3:	8b 0d 80 ae 11 c0    	mov    0xc011ae80,%ecx
c01011a9:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c01011b0:	8d 50 01             	lea    0x1(%eax),%edx
c01011b3:	66 89 15 84 ae 11 c0 	mov    %dx,0xc011ae84
c01011ba:	0f b7 c0             	movzwl %ax,%eax
c01011bd:	01 c0                	add    %eax,%eax
c01011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c5:	66 89 02             	mov    %ax,(%edx)
        break;
c01011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011c9:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c01011d0:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d4:	76 5b                	jbe    c0101231 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011d6:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01011db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e1:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01011e6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011ed:	00 
c01011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f2:	89 04 24             	mov    %eax,(%esp)
c01011f5:	e8 0f 60 00 00       	call   c0107209 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011fa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101201:	eb 15                	jmp    c0101218 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101203:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0101208:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010120b:	01 d2                	add    %edx,%edx
c010120d:	01 d0                	add    %edx,%eax
c010120f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101218:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010121f:	7e e2                	jle    c0101203 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101221:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c0101228:	83 e8 50             	sub    $0x50,%eax
c010122b:	66 a3 84 ae 11 c0    	mov    %ax,0xc011ae84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101231:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c0101238:	0f b7 c0             	movzwl %ax,%eax
c010123b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010123f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101243:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101247:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010124c:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c0101253:	66 c1 e8 08          	shr    $0x8,%ax
c0101257:	0f b6 c0             	movzbl %al,%eax
c010125a:	0f b7 15 86 ae 11 c0 	movzwl 0xc011ae86,%edx
c0101261:	83 c2 01             	add    $0x1,%edx
c0101264:	0f b7 d2             	movzwl %dx,%edx
c0101267:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010126b:	88 45 ed             	mov    %al,-0x13(%ebp)
c010126e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101272:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101276:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101277:	0f b7 05 86 ae 11 c0 	movzwl 0xc011ae86,%eax
c010127e:	0f b7 c0             	movzwl %ax,%eax
c0101281:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101285:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101289:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010128d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101291:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101292:	0f b7 05 84 ae 11 c0 	movzwl 0xc011ae84,%eax
c0101299:	0f b6 c0             	movzbl %al,%eax
c010129c:	0f b7 15 86 ae 11 c0 	movzwl 0xc011ae86,%edx
c01012a3:	83 c2 01             	add    $0x1,%edx
c01012a6:	0f b7 d2             	movzwl %dx,%edx
c01012a9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ad:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012b8:	ee                   	out    %al,(%dx)
}
c01012b9:	83 c4 34             	add    $0x34,%esp
c01012bc:	5b                   	pop    %ebx
c01012bd:	5d                   	pop    %ebp
c01012be:	c3                   	ret    

c01012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012bf:	55                   	push   %ebp
c01012c0:	89 e5                	mov    %esp,%ebp
c01012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012cc:	eb 09                	jmp    c01012d7 <serial_putc_sub+0x18>
        delay();
c01012ce:	e8 4f fb ff ff       	call   c0100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e1:	89 c2                	mov    %eax,%edx
c01012e3:	ec                   	in     (%dx),%al
c01012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012eb:	0f b6 c0             	movzbl %al,%eax
c01012ee:	83 e0 20             	and    $0x20,%eax
c01012f1:	85 c0                	test   %eax,%eax
c01012f3:	75 09                	jne    c01012fe <serial_putc_sub+0x3f>
c01012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012fc:	7e d0                	jle    c01012ce <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101301:	0f b6 c0             	movzbl %al,%eax
c0101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010130a:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101315:	ee                   	out    %al,(%dx)
}
c0101316:	c9                   	leave  
c0101317:	c3                   	ret    

c0101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101318:	55                   	push   %ebp
c0101319:	89 e5                	mov    %esp,%ebp
c010131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101322:	74 0d                	je     c0101331 <serial_putc+0x19>
        serial_putc_sub(c);
c0101324:	8b 45 08             	mov    0x8(%ebp),%eax
c0101327:	89 04 24             	mov    %eax,(%esp)
c010132a:	e8 90 ff ff ff       	call   c01012bf <serial_putc_sub>
c010132f:	eb 24                	jmp    c0101355 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101338:	e8 82 ff ff ff       	call   c01012bf <serial_putc_sub>
        serial_putc_sub(' ');
c010133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101344:	e8 76 ff ff ff       	call   c01012bf <serial_putc_sub>
        serial_putc_sub('\b');
c0101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101350:	e8 6a ff ff ff       	call   c01012bf <serial_putc_sub>
    }
}
c0101355:	c9                   	leave  
c0101356:	c3                   	ret    

c0101357 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101357:	55                   	push   %ebp
c0101358:	89 e5                	mov    %esp,%ebp
c010135a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010135d:	eb 33                	jmp    c0101392 <cons_intr+0x3b>
        if (c != 0) {
c010135f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101363:	74 2d                	je     c0101392 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101365:	a1 a4 b0 11 c0       	mov    0xc011b0a4,%eax
c010136a:	8d 50 01             	lea    0x1(%eax),%edx
c010136d:	89 15 a4 b0 11 c0    	mov    %edx,0xc011b0a4
c0101373:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101376:	88 90 a0 ae 11 c0    	mov    %dl,-0x3fee5160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010137c:	a1 a4 b0 11 c0       	mov    0xc011b0a4,%eax
c0101381:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101386:	75 0a                	jne    c0101392 <cons_intr+0x3b>
                cons.wpos = 0;
c0101388:	c7 05 a4 b0 11 c0 00 	movl   $0x0,0xc011b0a4
c010138f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101392:	8b 45 08             	mov    0x8(%ebp),%eax
c0101395:	ff d0                	call   *%eax
c0101397:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010139a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010139e:	75 bf                	jne    c010135f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a0:	c9                   	leave  
c01013a1:	c3                   	ret    

c01013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a2:	55                   	push   %ebp
c01013a3:	89 e5                	mov    %esp,%ebp
c01013a5:	83 ec 10             	sub    $0x10,%esp
c01013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b2:	89 c2                	mov    %eax,%edx
c01013b4:	ec                   	in     (%dx),%al
c01013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013bc:	0f b6 c0             	movzbl %al,%eax
c01013bf:	83 e0 01             	and    $0x1,%eax
c01013c2:	85 c0                	test   %eax,%eax
c01013c4:	75 07                	jne    c01013cd <serial_proc_data+0x2b>
        return -1;
c01013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013cb:	eb 2a                	jmp    c01013f7 <serial_proc_data+0x55>
c01013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013d7:	89 c2                	mov    %eax,%edx
c01013d9:	ec                   	in     (%dx),%al
c01013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e1:	0f b6 c0             	movzbl %al,%eax
c01013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013eb:	75 07                	jne    c01013f4 <serial_proc_data+0x52>
        c = '\b';
c01013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013f7:	c9                   	leave  
c01013f8:	c3                   	ret    

c01013f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013f9:	55                   	push   %ebp
c01013fa:	89 e5                	mov    %esp,%ebp
c01013fc:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013ff:	a1 88 ae 11 c0       	mov    0xc011ae88,%eax
c0101404:	85 c0                	test   %eax,%eax
c0101406:	74 0c                	je     c0101414 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101408:	c7 04 24 a2 13 10 c0 	movl   $0xc01013a2,(%esp)
c010140f:	e8 43 ff ff ff       	call   c0101357 <cons_intr>
    }
}
c0101414:	c9                   	leave  
c0101415:	c3                   	ret    

c0101416 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101416:	55                   	push   %ebp
c0101417:	89 e5                	mov    %esp,%ebp
c0101419:	83 ec 38             	sub    $0x38,%esp
c010141c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101422:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101426:	89 c2                	mov    %eax,%edx
c0101428:	ec                   	in     (%dx),%al
c0101429:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010142c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101430:	0f b6 c0             	movzbl %al,%eax
c0101433:	83 e0 01             	and    $0x1,%eax
c0101436:	85 c0                	test   %eax,%eax
c0101438:	75 0a                	jne    c0101444 <kbd_proc_data+0x2e>
        return -1;
c010143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010143f:	e9 59 01 00 00       	jmp    c010159d <kbd_proc_data+0x187>
c0101444:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010144e:	89 c2                	mov    %eax,%edx
c0101450:	ec                   	in     (%dx),%al
c0101451:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101454:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101458:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010145b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010145f:	75 17                	jne    c0101478 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101461:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101466:	83 c8 40             	or     $0x40,%eax
c0101469:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8
        return 0;
c010146e:	b8 00 00 00 00       	mov    $0x0,%eax
c0101473:	e9 25 01 00 00       	jmp    c010159d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147c:	84 c0                	test   %al,%al
c010147e:	79 47                	jns    c01014c7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101480:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101485:	83 e0 40             	and    $0x40,%eax
c0101488:	85 c0                	test   %eax,%eax
c010148a:	75 09                	jne    c0101495 <kbd_proc_data+0x7f>
c010148c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101490:	83 e0 7f             	and    $0x7f,%eax
c0101493:	eb 04                	jmp    c0101499 <kbd_proc_data+0x83>
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a0:	0f b6 80 60 a0 11 c0 	movzbl -0x3fee5fa0(%eax),%eax
c01014a7:	83 c8 40             	or     $0x40,%eax
c01014aa:	0f b6 c0             	movzbl %al,%eax
c01014ad:	f7 d0                	not    %eax
c01014af:	89 c2                	mov    %eax,%edx
c01014b1:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c01014b6:	21 d0                	and    %edx,%eax
c01014b8:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8
        return 0;
c01014bd:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c2:	e9 d6 00 00 00       	jmp    c010159d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014c7:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c01014cc:	83 e0 40             	and    $0x40,%eax
c01014cf:	85 c0                	test   %eax,%eax
c01014d1:	74 11                	je     c01014e4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014d7:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c01014dc:	83 e0 bf             	and    $0xffffffbf,%eax
c01014df:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8
    }

    shift |= shiftcode[data];
c01014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e8:	0f b6 80 60 a0 11 c0 	movzbl -0x3fee5fa0(%eax),%eax
c01014ef:	0f b6 d0             	movzbl %al,%edx
c01014f2:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c01014f7:	09 d0                	or     %edx,%eax
c01014f9:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8
    shift ^= togglecode[data];
c01014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101502:	0f b6 80 60 a1 11 c0 	movzbl -0x3fee5ea0(%eax),%eax
c0101509:	0f b6 d0             	movzbl %al,%edx
c010150c:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101511:	31 d0                	xor    %edx,%eax
c0101513:	a3 a8 b0 11 c0       	mov    %eax,0xc011b0a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101518:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c010151d:	83 e0 03             	and    $0x3,%eax
c0101520:	8b 14 85 60 a5 11 c0 	mov    -0x3fee5aa0(,%eax,4),%edx
c0101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152b:	01 d0                	add    %edx,%eax
c010152d:	0f b6 00             	movzbl (%eax),%eax
c0101530:	0f b6 c0             	movzbl %al,%eax
c0101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101536:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c010153b:	83 e0 08             	and    $0x8,%eax
c010153e:	85 c0                	test   %eax,%eax
c0101540:	74 22                	je     c0101564 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101546:	7e 0c                	jle    c0101554 <kbd_proc_data+0x13e>
c0101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010154c:	7f 06                	jg     c0101554 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101552:	eb 10                	jmp    c0101564 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101558:	7e 0a                	jle    c0101564 <kbd_proc_data+0x14e>
c010155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010155e:	7f 04                	jg     c0101564 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101564:	a1 a8 b0 11 c0       	mov    0xc011b0a8,%eax
c0101569:	f7 d0                	not    %eax
c010156b:	83 e0 06             	and    $0x6,%eax
c010156e:	85 c0                	test   %eax,%eax
c0101570:	75 28                	jne    c010159a <kbd_proc_data+0x184>
c0101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101579:	75 1f                	jne    c010159a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010157b:	c7 04 24 7d 76 10 c0 	movl   $0xc010767d,(%esp)
c0101582:	e8 b5 ed ff ff       	call   c010033c <cprintf>
c0101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101595:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101599:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010159d:	c9                   	leave  
c010159e:	c3                   	ret    

c010159f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010159f:	55                   	push   %ebp
c01015a0:	89 e5                	mov    %esp,%ebp
c01015a2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015a5:	c7 04 24 16 14 10 c0 	movl   $0xc0101416,(%esp)
c01015ac:	e8 a6 fd ff ff       	call   c0101357 <cons_intr>
}
c01015b1:	c9                   	leave  
c01015b2:	c3                   	ret    

c01015b3 <kbd_init>:

static void
kbd_init(void) {
c01015b3:	55                   	push   %ebp
c01015b4:	89 e5                	mov    %esp,%ebp
c01015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015b9:	e8 e1 ff ff ff       	call   c010159f <kbd_intr>
    pic_enable(IRQ_KBD);
c01015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015c5:	e8 3d 01 00 00       	call   c0101707 <pic_enable>
}
c01015ca:	c9                   	leave  
c01015cb:	c3                   	ret    

c01015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015cc:	55                   	push   %ebp
c01015cd:	89 e5                	mov    %esp,%ebp
c01015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d2:	e8 93 f8 ff ff       	call   c0100e6a <cga_init>
    serial_init();
c01015d7:	e8 74 f9 ff ff       	call   c0100f50 <serial_init>
    kbd_init();
c01015dc:	e8 d2 ff ff ff       	call   c01015b3 <kbd_init>
    if (!serial_exists) {
c01015e1:	a1 88 ae 11 c0       	mov    0xc011ae88,%eax
c01015e6:	85 c0                	test   %eax,%eax
c01015e8:	75 0c                	jne    c01015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015ea:	c7 04 24 89 76 10 c0 	movl   $0xc0107689,(%esp)
c01015f1:	e8 46 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015f6:	c9                   	leave  
c01015f7:	c3                   	ret    

c01015f8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015f8:	55                   	push   %ebp
c01015f9:	89 e5                	mov    %esp,%ebp
c01015fb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015fe:	e8 e2 f7 ff ff       	call   c0100de5 <__intr_save>
c0101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101606:	8b 45 08             	mov    0x8(%ebp),%eax
c0101609:	89 04 24             	mov    %eax,(%esp)
c010160c:	e8 9b fa ff ff       	call   c01010ac <lpt_putc>
        cga_putc(c);
c0101611:	8b 45 08             	mov    0x8(%ebp),%eax
c0101614:	89 04 24             	mov    %eax,(%esp)
c0101617:	e8 cf fa ff ff       	call   c01010eb <cga_putc>
        serial_putc(c);
c010161c:	8b 45 08             	mov    0x8(%ebp),%eax
c010161f:	89 04 24             	mov    %eax,(%esp)
c0101622:	e8 f1 fc ff ff       	call   c0101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101627:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010162a:	89 04 24             	mov    %eax,(%esp)
c010162d:	e8 dd f7 ff ff       	call   c0100e0f <__intr_restore>
}
c0101632:	c9                   	leave  
c0101633:	c3                   	ret    

c0101634 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101634:	55                   	push   %ebp
c0101635:	89 e5                	mov    %esp,%ebp
c0101637:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101641:	e8 9f f7 ff ff       	call   c0100de5 <__intr_save>
c0101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101649:	e8 ab fd ff ff       	call   c01013f9 <serial_intr>
        kbd_intr();
c010164e:	e8 4c ff ff ff       	call   c010159f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101653:	8b 15 a0 b0 11 c0    	mov    0xc011b0a0,%edx
c0101659:	a1 a4 b0 11 c0       	mov    0xc011b0a4,%eax
c010165e:	39 c2                	cmp    %eax,%edx
c0101660:	74 31                	je     c0101693 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101662:	a1 a0 b0 11 c0       	mov    0xc011b0a0,%eax
c0101667:	8d 50 01             	lea    0x1(%eax),%edx
c010166a:	89 15 a0 b0 11 c0    	mov    %edx,0xc011b0a0
c0101670:	0f b6 80 a0 ae 11 c0 	movzbl -0x3fee5160(%eax),%eax
c0101677:	0f b6 c0             	movzbl %al,%eax
c010167a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010167d:	a1 a0 b0 11 c0       	mov    0xc011b0a0,%eax
c0101682:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101687:	75 0a                	jne    c0101693 <cons_getc+0x5f>
                cons.rpos = 0;
c0101689:	c7 05 a0 b0 11 c0 00 	movl   $0x0,0xc011b0a0
c0101690:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101693:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101696:	89 04 24             	mov    %eax,(%esp)
c0101699:	e8 71 f7 ff ff       	call   c0100e0f <__intr_restore>
    return c;
c010169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a1:	c9                   	leave  
c01016a2:	c3                   	ret    

c01016a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016a3:	55                   	push   %ebp
c01016a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016a6:	fb                   	sti    
    sti();
}
c01016a7:	5d                   	pop    %ebp
c01016a8:	c3                   	ret    

c01016a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016a9:	55                   	push   %ebp
c01016aa:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016ac:	fa                   	cli    
    cli();
}
c01016ad:	5d                   	pop    %ebp
c01016ae:	c3                   	ret    

c01016af <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016af:	55                   	push   %ebp
c01016b0:	89 e5                	mov    %esp,%ebp
c01016b2:	83 ec 14             	sub    $0x14,%esp
c01016b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c0:	66 a3 70 a5 11 c0    	mov    %ax,0xc011a570
    if (did_init) {
c01016c6:	a1 ac b0 11 c0       	mov    0xc011b0ac,%eax
c01016cb:	85 c0                	test   %eax,%eax
c01016cd:	74 36                	je     c0101705 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d3:	0f b6 c0             	movzbl %al,%eax
c01016d6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016dc:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016e7:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ec:	66 c1 e8 08          	shr    $0x8,%ax
c01016f0:	0f b6 c0             	movzbl %al,%eax
c01016f3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016f9:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101700:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101704:	ee                   	out    %al,(%dx)
    }
}
c0101705:	c9                   	leave  
c0101706:	c3                   	ret    

c0101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101707:	55                   	push   %ebp
c0101708:	89 e5                	mov    %esp,%ebp
c010170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010170d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101710:	ba 01 00 00 00       	mov    $0x1,%edx
c0101715:	89 c1                	mov    %eax,%ecx
c0101717:	d3 e2                	shl    %cl,%edx
c0101719:	89 d0                	mov    %edx,%eax
c010171b:	f7 d0                	not    %eax
c010171d:	89 c2                	mov    %eax,%edx
c010171f:	0f b7 05 70 a5 11 c0 	movzwl 0xc011a570,%eax
c0101726:	21 d0                	and    %edx,%eax
c0101728:	0f b7 c0             	movzwl %ax,%eax
c010172b:	89 04 24             	mov    %eax,(%esp)
c010172e:	e8 7c ff ff ff       	call   c01016af <pic_setmask>
}
c0101733:	c9                   	leave  
c0101734:	c3                   	ret    

c0101735 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101735:	55                   	push   %ebp
c0101736:	89 e5                	mov    %esp,%ebp
c0101738:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010173b:	c7 05 ac b0 11 c0 01 	movl   $0x1,0xc011b0ac
c0101742:	00 00 00 
c0101745:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010174b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010174f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101753:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101757:	ee                   	out    %al,(%dx)
c0101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010175e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101762:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010176a:	ee                   	out    %al,(%dx)
c010176b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101771:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101775:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101779:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010177d:	ee                   	out    %al,(%dx)
c010177e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101784:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101788:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010178c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101790:	ee                   	out    %al,(%dx)
c0101791:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101797:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010179b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010179f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a3:	ee                   	out    %al,(%dx)
c01017a4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017aa:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017b6:	ee                   	out    %al,(%dx)
c01017b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017bd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017c9:	ee                   	out    %al,(%dx)
c01017ca:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017d4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017d8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017dc:	ee                   	out    %al,(%dx)
c01017dd:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017e7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017eb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017ef:	ee                   	out    %al,(%dx)
c01017f0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017f6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017fe:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101802:	ee                   	out    %al,(%dx)
c0101803:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101809:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010180d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101811:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101815:	ee                   	out    %al,(%dx)
c0101816:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010181c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101820:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101824:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101828:	ee                   	out    %al,(%dx)
c0101829:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010182f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101833:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101837:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010183b:	ee                   	out    %al,(%dx)
c010183c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101842:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101846:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010184a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010184e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010184f:	0f b7 05 70 a5 11 c0 	movzwl 0xc011a570,%eax
c0101856:	66 83 f8 ff          	cmp    $0xffff,%ax
c010185a:	74 12                	je     c010186e <pic_init+0x139>
        pic_setmask(irq_mask);
c010185c:	0f b7 05 70 a5 11 c0 	movzwl 0xc011a570,%eax
c0101863:	0f b7 c0             	movzwl %ax,%eax
c0101866:	89 04 24             	mov    %eax,(%esp)
c0101869:	e8 41 fe ff ff       	call   c01016af <pic_setmask>
    }
}
c010186e:	c9                   	leave  
c010186f:	c3                   	ret    

c0101870 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101870:	55                   	push   %ebp
c0101871:	89 e5                	mov    %esp,%ebp
c0101873:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101876:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010187d:	00 
c010187e:	c7 04 24 c0 76 10 c0 	movl   $0xc01076c0,(%esp)
c0101885:	e8 b2 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010188a:	c9                   	leave  
c010188b:	c3                   	ret    

c010188c <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010188c:	55                   	push   %ebp
c010188d:	89 e5                	mov    %esp,%ebp
c010188f:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101892:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101899:	e9 c3 00 00 00       	jmp    c0101961 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010189e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a1:	8b 04 85 00 a6 11 c0 	mov    -0x3fee5a00(,%eax,4),%eax
c01018a8:	89 c2                	mov    %eax,%edx
c01018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ad:	66 89 14 c5 c0 b0 11 	mov    %dx,-0x3fee4f40(,%eax,8)
c01018b4:	c0 
c01018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b8:	66 c7 04 c5 c2 b0 11 	movw   $0x8,-0x3fee4f3e(,%eax,8)
c01018bf:	c0 08 00 
c01018c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c5:	0f b6 14 c5 c4 b0 11 	movzbl -0x3fee4f3c(,%eax,8),%edx
c01018cc:	c0 
c01018cd:	83 e2 e0             	and    $0xffffffe0,%edx
c01018d0:	88 14 c5 c4 b0 11 c0 	mov    %dl,-0x3fee4f3c(,%eax,8)
c01018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018da:	0f b6 14 c5 c4 b0 11 	movzbl -0x3fee4f3c(,%eax,8),%edx
c01018e1:	c0 
c01018e2:	83 e2 1f             	and    $0x1f,%edx
c01018e5:	88 14 c5 c4 b0 11 c0 	mov    %dl,-0x3fee4f3c(,%eax,8)
c01018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ef:	0f b6 14 c5 c5 b0 11 	movzbl -0x3fee4f3b(,%eax,8),%edx
c01018f6:	c0 
c01018f7:	83 e2 f0             	and    $0xfffffff0,%edx
c01018fa:	83 ca 0e             	or     $0xe,%edx
c01018fd:	88 14 c5 c5 b0 11 c0 	mov    %dl,-0x3fee4f3b(,%eax,8)
c0101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101907:	0f b6 14 c5 c5 b0 11 	movzbl -0x3fee4f3b(,%eax,8),%edx
c010190e:	c0 
c010190f:	83 e2 ef             	and    $0xffffffef,%edx
c0101912:	88 14 c5 c5 b0 11 c0 	mov    %dl,-0x3fee4f3b(,%eax,8)
c0101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191c:	0f b6 14 c5 c5 b0 11 	movzbl -0x3fee4f3b(,%eax,8),%edx
c0101923:	c0 
c0101924:	83 e2 9f             	and    $0xffffff9f,%edx
c0101927:	88 14 c5 c5 b0 11 c0 	mov    %dl,-0x3fee4f3b(,%eax,8)
c010192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101931:	0f b6 14 c5 c5 b0 11 	movzbl -0x3fee4f3b(,%eax,8),%edx
c0101938:	c0 
c0101939:	83 ca 80             	or     $0xffffff80,%edx
c010193c:	88 14 c5 c5 b0 11 c0 	mov    %dl,-0x3fee4f3b(,%eax,8)
c0101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101946:	8b 04 85 00 a6 11 c0 	mov    -0x3fee5a00(,%eax,4),%eax
c010194d:	c1 e8 10             	shr    $0x10,%eax
c0101950:	89 c2                	mov    %eax,%edx
c0101952:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101955:	66 89 14 c5 c6 b0 11 	mov    %dx,-0x3fee4f3a(,%eax,8)
c010195c:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010195d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101961:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101964:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101969:	0f 86 2f ff ff ff    	jbe    c010189e <idt_init+0x12>
c010196f:	c7 45 f8 80 a5 11 c0 	movl   $0xc011a580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101976:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101979:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
c010197c:	c9                   	leave  
c010197d:	c3                   	ret    

c010197e <trapname>:

static const char *
trapname(int trapno) {
c010197e:	55                   	push   %ebp
c010197f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101981:	8b 45 08             	mov    0x8(%ebp),%eax
c0101984:	83 f8 13             	cmp    $0x13,%eax
c0101987:	77 0c                	ja     c0101995 <trapname+0x17>
        return excnames[trapno];
c0101989:	8b 45 08             	mov    0x8(%ebp),%eax
c010198c:	8b 04 85 20 7a 10 c0 	mov    -0x3fef85e0(,%eax,4),%eax
c0101993:	eb 18                	jmp    c01019ad <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101995:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101999:	7e 0d                	jle    c01019a8 <trapname+0x2a>
c010199b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c010199f:	7f 07                	jg     c01019a8 <trapname+0x2a>
        return "Hardware Interrupt";
c01019a1:	b8 ca 76 10 c0       	mov    $0xc01076ca,%eax
c01019a6:	eb 05                	jmp    c01019ad <trapname+0x2f>
    }
    return "(unknown trap)";
c01019a8:	b8 dd 76 10 c0       	mov    $0xc01076dd,%eax
}
c01019ad:	5d                   	pop    %ebp
c01019ae:	c3                   	ret    

c01019af <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019af:	55                   	push   %ebp
c01019b0:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019b9:	66 83 f8 08          	cmp    $0x8,%ax
c01019bd:	0f 94 c0             	sete   %al
c01019c0:	0f b6 c0             	movzbl %al,%eax
}
c01019c3:	5d                   	pop    %ebp
c01019c4:	c3                   	ret    

c01019c5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01019c5:	55                   	push   %ebp
c01019c6:	89 e5                	mov    %esp,%ebp
c01019c8:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01019cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019d2:	c7 04 24 1e 77 10 c0 	movl   $0xc010771e,(%esp)
c01019d9:	e8 5e e9 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c01019de:	8b 45 08             	mov    0x8(%ebp),%eax
c01019e1:	89 04 24             	mov    %eax,(%esp)
c01019e4:	e8 a1 01 00 00       	call   c0101b8a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01019e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ec:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01019f0:	0f b7 c0             	movzwl %ax,%eax
c01019f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019f7:	c7 04 24 2f 77 10 c0 	movl   $0xc010772f,(%esp)
c01019fe:	e8 39 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a06:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a0a:	0f b7 c0             	movzwl %ax,%eax
c0101a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a11:	c7 04 24 42 77 10 c0 	movl   $0xc0107742,(%esp)
c0101a18:	e8 1f e9 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a20:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a24:	0f b7 c0             	movzwl %ax,%eax
c0101a27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a2b:	c7 04 24 55 77 10 c0 	movl   $0xc0107755,(%esp)
c0101a32:	e8 05 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a37:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a3a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a3e:	0f b7 c0             	movzwl %ax,%eax
c0101a41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a45:	c7 04 24 68 77 10 c0 	movl   $0xc0107768,(%esp)
c0101a4c:	e8 eb e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a54:	8b 40 30             	mov    0x30(%eax),%eax
c0101a57:	89 04 24             	mov    %eax,(%esp)
c0101a5a:	e8 1f ff ff ff       	call   c010197e <trapname>
c0101a5f:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a62:	8b 52 30             	mov    0x30(%edx),%edx
c0101a65:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101a69:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a6d:	c7 04 24 7b 77 10 c0 	movl   $0xc010777b,(%esp)
c0101a74:	e8 c3 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101a79:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7c:	8b 40 34             	mov    0x34(%eax),%eax
c0101a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a83:	c7 04 24 8d 77 10 c0 	movl   $0xc010778d,(%esp)
c0101a8a:	e8 ad e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101a8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a92:	8b 40 38             	mov    0x38(%eax),%eax
c0101a95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a99:	c7 04 24 9c 77 10 c0 	movl   $0xc010779c,(%esp)
c0101aa0:	e8 97 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101aac:	0f b7 c0             	movzwl %ax,%eax
c0101aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab3:	c7 04 24 ab 77 10 c0 	movl   $0xc01077ab,(%esp)
c0101aba:	e8 7d e8 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac2:	8b 40 40             	mov    0x40(%eax),%eax
c0101ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac9:	c7 04 24 be 77 10 c0 	movl   $0xc01077be,(%esp)
c0101ad0:	e8 67 e8 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ad5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101adc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101ae3:	eb 3e                	jmp    c0101b23 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae8:	8b 50 40             	mov    0x40(%eax),%edx
c0101aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101aee:	21 d0                	and    %edx,%eax
c0101af0:	85 c0                	test   %eax,%eax
c0101af2:	74 28                	je     c0101b1c <print_trapframe+0x157>
c0101af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101af7:	8b 04 85 a0 a5 11 c0 	mov    -0x3fee5a60(,%eax,4),%eax
c0101afe:	85 c0                	test   %eax,%eax
c0101b00:	74 1a                	je     c0101b1c <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b05:	8b 04 85 a0 a5 11 c0 	mov    -0x3fee5a60(,%eax,4),%eax
c0101b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b10:	c7 04 24 cd 77 10 c0 	movl   $0xc01077cd,(%esp)
c0101b17:	e8 20 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b1c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b20:	d1 65 f0             	shll   -0x10(%ebp)
c0101b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b26:	83 f8 17             	cmp    $0x17,%eax
c0101b29:	76 ba                	jbe    c0101ae5 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2e:	8b 40 40             	mov    0x40(%eax),%eax
c0101b31:	25 00 30 00 00       	and    $0x3000,%eax
c0101b36:	c1 e8 0c             	shr    $0xc,%eax
c0101b39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b3d:	c7 04 24 d1 77 10 c0 	movl   $0xc01077d1,(%esp)
c0101b44:	e8 f3 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4c:	89 04 24             	mov    %eax,(%esp)
c0101b4f:	e8 5b fe ff ff       	call   c01019af <trap_in_kernel>
c0101b54:	85 c0                	test   %eax,%eax
c0101b56:	75 30                	jne    c0101b88 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b58:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5b:	8b 40 44             	mov    0x44(%eax),%eax
c0101b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b62:	c7 04 24 da 77 10 c0 	movl   $0xc01077da,(%esp)
c0101b69:	e8 ce e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b71:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101b75:	0f b7 c0             	movzwl %ax,%eax
c0101b78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b7c:	c7 04 24 e9 77 10 c0 	movl   $0xc01077e9,(%esp)
c0101b83:	e8 b4 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101b88:	c9                   	leave  
c0101b89:	c3                   	ret    

c0101b8a <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101b8a:	55                   	push   %ebp
c0101b8b:	89 e5                	mov    %esp,%ebp
c0101b8d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101b90:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b93:	8b 00                	mov    (%eax),%eax
c0101b95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b99:	c7 04 24 fc 77 10 c0 	movl   $0xc01077fc,(%esp)
c0101ba0:	e8 97 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba8:	8b 40 04             	mov    0x4(%eax),%eax
c0101bab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101baf:	c7 04 24 0b 78 10 c0 	movl   $0xc010780b,(%esp)
c0101bb6:	e8 81 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbe:	8b 40 08             	mov    0x8(%eax),%eax
c0101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc5:	c7 04 24 1a 78 10 c0 	movl   $0xc010781a,(%esp)
c0101bcc:	e8 6b e7 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd4:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdb:	c7 04 24 29 78 10 c0 	movl   $0xc0107829,(%esp)
c0101be2:	e8 55 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101be7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bea:	8b 40 10             	mov    0x10(%eax),%eax
c0101bed:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf1:	c7 04 24 38 78 10 c0 	movl   $0xc0107838,(%esp)
c0101bf8:	e8 3f e7 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c00:	8b 40 14             	mov    0x14(%eax),%eax
c0101c03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c07:	c7 04 24 47 78 10 c0 	movl   $0xc0107847,(%esp)
c0101c0e:	e8 29 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c13:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c16:	8b 40 18             	mov    0x18(%eax),%eax
c0101c19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c1d:	c7 04 24 56 78 10 c0 	movl   $0xc0107856,(%esp)
c0101c24:	e8 13 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2c:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c33:	c7 04 24 65 78 10 c0 	movl   $0xc0107865,(%esp)
c0101c3a:	e8 fd e6 ff ff       	call   c010033c <cprintf>
}
c0101c3f:	c9                   	leave  
c0101c40:	c3                   	ret    

c0101c41 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c41:	55                   	push   %ebp
c0101c42:	89 e5                	mov    %esp,%ebp
c0101c44:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4a:	8b 40 30             	mov    0x30(%eax),%eax
c0101c4d:	83 f8 2f             	cmp    $0x2f,%eax
c0101c50:	77 21                	ja     c0101c73 <trap_dispatch+0x32>
c0101c52:	83 f8 2e             	cmp    $0x2e,%eax
c0101c55:	0f 83 04 01 00 00    	jae    c0101d5f <trap_dispatch+0x11e>
c0101c5b:	83 f8 21             	cmp    $0x21,%eax
c0101c5e:	0f 84 81 00 00 00    	je     c0101ce5 <trap_dispatch+0xa4>
c0101c64:	83 f8 24             	cmp    $0x24,%eax
c0101c67:	74 56                	je     c0101cbf <trap_dispatch+0x7e>
c0101c69:	83 f8 20             	cmp    $0x20,%eax
c0101c6c:	74 16                	je     c0101c84 <trap_dispatch+0x43>
c0101c6e:	e9 b4 00 00 00       	jmp    c0101d27 <trap_dispatch+0xe6>
c0101c73:	83 e8 78             	sub    $0x78,%eax
c0101c76:	83 f8 01             	cmp    $0x1,%eax
c0101c79:	0f 87 a8 00 00 00    	ja     c0101d27 <trap_dispatch+0xe6>
c0101c7f:	e9 87 00 00 00       	jmp    c0101d0b <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101c84:	a1 4c b9 11 c0       	mov    0xc011b94c,%eax
c0101c89:	83 c0 01             	add    $0x1,%eax
c0101c8c:	a3 4c b9 11 c0       	mov    %eax,0xc011b94c
        if (ticks % TICK_NUM == 0) {
c0101c91:	8b 0d 4c b9 11 c0    	mov    0xc011b94c,%ecx
c0101c97:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101c9c:	89 c8                	mov    %ecx,%eax
c0101c9e:	f7 e2                	mul    %edx
c0101ca0:	89 d0                	mov    %edx,%eax
c0101ca2:	c1 e8 05             	shr    $0x5,%eax
c0101ca5:	6b c0 64             	imul   $0x64,%eax,%eax
c0101ca8:	29 c1                	sub    %eax,%ecx
c0101caa:	89 c8                	mov    %ecx,%eax
c0101cac:	85 c0                	test   %eax,%eax
c0101cae:	75 0a                	jne    c0101cba <trap_dispatch+0x79>
            print_ticks();
c0101cb0:	e8 bb fb ff ff       	call   c0101870 <print_ticks>
        }
        break;
c0101cb5:	e9 a6 00 00 00       	jmp    c0101d60 <trap_dispatch+0x11f>
c0101cba:	e9 a1 00 00 00       	jmp    c0101d60 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101cbf:	e8 70 f9 ff ff       	call   c0101634 <cons_getc>
c0101cc4:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101cc7:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101ccb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101ccf:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd7:	c7 04 24 74 78 10 c0 	movl   $0xc0107874,(%esp)
c0101cde:	e8 59 e6 ff ff       	call   c010033c <cprintf>
        break;
c0101ce3:	eb 7b                	jmp    c0101d60 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101ce5:	e8 4a f9 ff ff       	call   c0101634 <cons_getc>
c0101cea:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101ced:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101cf1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101cf5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfd:	c7 04 24 86 78 10 c0 	movl   $0xc0107886,(%esp)
c0101d04:	e8 33 e6 ff ff       	call   c010033c <cprintf>
        break;
c0101d09:	eb 55                	jmp    c0101d60 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d0b:	c7 44 24 08 95 78 10 	movl   $0xc0107895,0x8(%esp)
c0101d12:	c0 
c0101d13:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0101d1a:	00 
c0101d1b:	c7 04 24 a5 78 10 c0 	movl   $0xc01078a5,(%esp)
c0101d22:	e8 9f ef ff ff       	call   c0100cc6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d2a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d2e:	0f b7 c0             	movzwl %ax,%eax
c0101d31:	83 e0 03             	and    $0x3,%eax
c0101d34:	85 c0                	test   %eax,%eax
c0101d36:	75 28                	jne    c0101d60 <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101d38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d3b:	89 04 24             	mov    %eax,(%esp)
c0101d3e:	e8 82 fc ff ff       	call   c01019c5 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101d43:	c7 44 24 08 b6 78 10 	movl   $0xc01078b6,0x8(%esp)
c0101d4a:	c0 
c0101d4b:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0101d52:	00 
c0101d53:	c7 04 24 a5 78 10 c0 	movl   $0xc01078a5,(%esp)
c0101d5a:	e8 67 ef ff ff       	call   c0100cc6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101d5f:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101d60:	c9                   	leave  
c0101d61:	c3                   	ret    

c0101d62 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101d62:	55                   	push   %ebp
c0101d63:	89 e5                	mov    %esp,%ebp
c0101d65:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101d68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d6b:	89 04 24             	mov    %eax,(%esp)
c0101d6e:	e8 ce fe ff ff       	call   c0101c41 <trap_dispatch>
}
c0101d73:	c9                   	leave  
c0101d74:	c3                   	ret    

c0101d75 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101d75:	1e                   	push   %ds
    pushl %es
c0101d76:	06                   	push   %es
    pushl %fs
c0101d77:	0f a0                	push   %fs
    pushl %gs
c0101d79:	0f a8                	push   %gs
    pushal
c0101d7b:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101d7c:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101d81:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101d83:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101d85:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101d86:	e8 d7 ff ff ff       	call   c0101d62 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101d8b:	5c                   	pop    %esp

c0101d8c <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101d8c:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101d8d:	0f a9                	pop    %gs
    popl %fs
c0101d8f:	0f a1                	pop    %fs
    popl %es
c0101d91:	07                   	pop    %es
    popl %ds
c0101d92:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101d93:	83 c4 08             	add    $0x8,%esp
    iret
c0101d96:	cf                   	iret   

c0101d97 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101d97:	6a 00                	push   $0x0
  pushl $0
c0101d99:	6a 00                	push   $0x0
  jmp __alltraps
c0101d9b:	e9 d5 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101da0 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101da0:	6a 00                	push   $0x0
  pushl $1
c0101da2:	6a 01                	push   $0x1
  jmp __alltraps
c0101da4:	e9 cc ff ff ff       	jmp    c0101d75 <__alltraps>

c0101da9 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101da9:	6a 00                	push   $0x0
  pushl $2
c0101dab:	6a 02                	push   $0x2
  jmp __alltraps
c0101dad:	e9 c3 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101db2 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101db2:	6a 00                	push   $0x0
  pushl $3
c0101db4:	6a 03                	push   $0x3
  jmp __alltraps
c0101db6:	e9 ba ff ff ff       	jmp    c0101d75 <__alltraps>

c0101dbb <vector4>:
.globl vector4
vector4:
  pushl $0
c0101dbb:	6a 00                	push   $0x0
  pushl $4
c0101dbd:	6a 04                	push   $0x4
  jmp __alltraps
c0101dbf:	e9 b1 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101dc4 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101dc4:	6a 00                	push   $0x0
  pushl $5
c0101dc6:	6a 05                	push   $0x5
  jmp __alltraps
c0101dc8:	e9 a8 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101dcd <vector6>:
.globl vector6
vector6:
  pushl $0
c0101dcd:	6a 00                	push   $0x0
  pushl $6
c0101dcf:	6a 06                	push   $0x6
  jmp __alltraps
c0101dd1:	e9 9f ff ff ff       	jmp    c0101d75 <__alltraps>

c0101dd6 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101dd6:	6a 00                	push   $0x0
  pushl $7
c0101dd8:	6a 07                	push   $0x7
  jmp __alltraps
c0101dda:	e9 96 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101ddf <vector8>:
.globl vector8
vector8:
  pushl $8
c0101ddf:	6a 08                	push   $0x8
  jmp __alltraps
c0101de1:	e9 8f ff ff ff       	jmp    c0101d75 <__alltraps>

c0101de6 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101de6:	6a 09                	push   $0x9
  jmp __alltraps
c0101de8:	e9 88 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101ded <vector10>:
.globl vector10
vector10:
  pushl $10
c0101ded:	6a 0a                	push   $0xa
  jmp __alltraps
c0101def:	e9 81 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101df4 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101df4:	6a 0b                	push   $0xb
  jmp __alltraps
c0101df6:	e9 7a ff ff ff       	jmp    c0101d75 <__alltraps>

c0101dfb <vector12>:
.globl vector12
vector12:
  pushl $12
c0101dfb:	6a 0c                	push   $0xc
  jmp __alltraps
c0101dfd:	e9 73 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e02 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e02:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e04:	e9 6c ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e09 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e09:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e0b:	e9 65 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e10 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e10:	6a 00                	push   $0x0
  pushl $15
c0101e12:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e14:	e9 5c ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e19 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e19:	6a 00                	push   $0x0
  pushl $16
c0101e1b:	6a 10                	push   $0x10
  jmp __alltraps
c0101e1d:	e9 53 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e22 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e22:	6a 11                	push   $0x11
  jmp __alltraps
c0101e24:	e9 4c ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e29 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e29:	6a 00                	push   $0x0
  pushl $18
c0101e2b:	6a 12                	push   $0x12
  jmp __alltraps
c0101e2d:	e9 43 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e32 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e32:	6a 00                	push   $0x0
  pushl $19
c0101e34:	6a 13                	push   $0x13
  jmp __alltraps
c0101e36:	e9 3a ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e3b <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e3b:	6a 00                	push   $0x0
  pushl $20
c0101e3d:	6a 14                	push   $0x14
  jmp __alltraps
c0101e3f:	e9 31 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e44 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e44:	6a 00                	push   $0x0
  pushl $21
c0101e46:	6a 15                	push   $0x15
  jmp __alltraps
c0101e48:	e9 28 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e4d <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e4d:	6a 00                	push   $0x0
  pushl $22
c0101e4f:	6a 16                	push   $0x16
  jmp __alltraps
c0101e51:	e9 1f ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e56 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e56:	6a 00                	push   $0x0
  pushl $23
c0101e58:	6a 17                	push   $0x17
  jmp __alltraps
c0101e5a:	e9 16 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e5f <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e5f:	6a 00                	push   $0x0
  pushl $24
c0101e61:	6a 18                	push   $0x18
  jmp __alltraps
c0101e63:	e9 0d ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e68 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e68:	6a 00                	push   $0x0
  pushl $25
c0101e6a:	6a 19                	push   $0x19
  jmp __alltraps
c0101e6c:	e9 04 ff ff ff       	jmp    c0101d75 <__alltraps>

c0101e71 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e71:	6a 00                	push   $0x0
  pushl $26
c0101e73:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101e75:	e9 fb fe ff ff       	jmp    c0101d75 <__alltraps>

c0101e7a <vector27>:
.globl vector27
vector27:
  pushl $0
c0101e7a:	6a 00                	push   $0x0
  pushl $27
c0101e7c:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101e7e:	e9 f2 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101e83 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101e83:	6a 00                	push   $0x0
  pushl $28
c0101e85:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101e87:	e9 e9 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101e8c <vector29>:
.globl vector29
vector29:
  pushl $0
c0101e8c:	6a 00                	push   $0x0
  pushl $29
c0101e8e:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101e90:	e9 e0 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101e95 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101e95:	6a 00                	push   $0x0
  pushl $30
c0101e97:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101e99:	e9 d7 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101e9e <vector31>:
.globl vector31
vector31:
  pushl $0
c0101e9e:	6a 00                	push   $0x0
  pushl $31
c0101ea0:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ea2:	e9 ce fe ff ff       	jmp    c0101d75 <__alltraps>

c0101ea7 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ea7:	6a 00                	push   $0x0
  pushl $32
c0101ea9:	6a 20                	push   $0x20
  jmp __alltraps
c0101eab:	e9 c5 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101eb0 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101eb0:	6a 00                	push   $0x0
  pushl $33
c0101eb2:	6a 21                	push   $0x21
  jmp __alltraps
c0101eb4:	e9 bc fe ff ff       	jmp    c0101d75 <__alltraps>

c0101eb9 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101eb9:	6a 00                	push   $0x0
  pushl $34
c0101ebb:	6a 22                	push   $0x22
  jmp __alltraps
c0101ebd:	e9 b3 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101ec2 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101ec2:	6a 00                	push   $0x0
  pushl $35
c0101ec4:	6a 23                	push   $0x23
  jmp __alltraps
c0101ec6:	e9 aa fe ff ff       	jmp    c0101d75 <__alltraps>

c0101ecb <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ecb:	6a 00                	push   $0x0
  pushl $36
c0101ecd:	6a 24                	push   $0x24
  jmp __alltraps
c0101ecf:	e9 a1 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101ed4 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101ed4:	6a 00                	push   $0x0
  pushl $37
c0101ed6:	6a 25                	push   $0x25
  jmp __alltraps
c0101ed8:	e9 98 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101edd <vector38>:
.globl vector38
vector38:
  pushl $0
c0101edd:	6a 00                	push   $0x0
  pushl $38
c0101edf:	6a 26                	push   $0x26
  jmp __alltraps
c0101ee1:	e9 8f fe ff ff       	jmp    c0101d75 <__alltraps>

c0101ee6 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101ee6:	6a 00                	push   $0x0
  pushl $39
c0101ee8:	6a 27                	push   $0x27
  jmp __alltraps
c0101eea:	e9 86 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101eef <vector40>:
.globl vector40
vector40:
  pushl $0
c0101eef:	6a 00                	push   $0x0
  pushl $40
c0101ef1:	6a 28                	push   $0x28
  jmp __alltraps
c0101ef3:	e9 7d fe ff ff       	jmp    c0101d75 <__alltraps>

c0101ef8 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101ef8:	6a 00                	push   $0x0
  pushl $41
c0101efa:	6a 29                	push   $0x29
  jmp __alltraps
c0101efc:	e9 74 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f01 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f01:	6a 00                	push   $0x0
  pushl $42
c0101f03:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f05:	e9 6b fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f0a <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f0a:	6a 00                	push   $0x0
  pushl $43
c0101f0c:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f0e:	e9 62 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f13 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f13:	6a 00                	push   $0x0
  pushl $44
c0101f15:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f17:	e9 59 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f1c <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f1c:	6a 00                	push   $0x0
  pushl $45
c0101f1e:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f20:	e9 50 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f25 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f25:	6a 00                	push   $0x0
  pushl $46
c0101f27:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f29:	e9 47 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f2e <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f2e:	6a 00                	push   $0x0
  pushl $47
c0101f30:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f32:	e9 3e fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f37 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f37:	6a 00                	push   $0x0
  pushl $48
c0101f39:	6a 30                	push   $0x30
  jmp __alltraps
c0101f3b:	e9 35 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f40 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f40:	6a 00                	push   $0x0
  pushl $49
c0101f42:	6a 31                	push   $0x31
  jmp __alltraps
c0101f44:	e9 2c fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f49 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f49:	6a 00                	push   $0x0
  pushl $50
c0101f4b:	6a 32                	push   $0x32
  jmp __alltraps
c0101f4d:	e9 23 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f52 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f52:	6a 00                	push   $0x0
  pushl $51
c0101f54:	6a 33                	push   $0x33
  jmp __alltraps
c0101f56:	e9 1a fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f5b <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f5b:	6a 00                	push   $0x0
  pushl $52
c0101f5d:	6a 34                	push   $0x34
  jmp __alltraps
c0101f5f:	e9 11 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f64 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f64:	6a 00                	push   $0x0
  pushl $53
c0101f66:	6a 35                	push   $0x35
  jmp __alltraps
c0101f68:	e9 08 fe ff ff       	jmp    c0101d75 <__alltraps>

c0101f6d <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f6d:	6a 00                	push   $0x0
  pushl $54
c0101f6f:	6a 36                	push   $0x36
  jmp __alltraps
c0101f71:	e9 ff fd ff ff       	jmp    c0101d75 <__alltraps>

c0101f76 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101f76:	6a 00                	push   $0x0
  pushl $55
c0101f78:	6a 37                	push   $0x37
  jmp __alltraps
c0101f7a:	e9 f6 fd ff ff       	jmp    c0101d75 <__alltraps>

c0101f7f <vector56>:
.globl vector56
vector56:
  pushl $0
c0101f7f:	6a 00                	push   $0x0
  pushl $56
c0101f81:	6a 38                	push   $0x38
  jmp __alltraps
c0101f83:	e9 ed fd ff ff       	jmp    c0101d75 <__alltraps>

c0101f88 <vector57>:
.globl vector57
vector57:
  pushl $0
c0101f88:	6a 00                	push   $0x0
  pushl $57
c0101f8a:	6a 39                	push   $0x39
  jmp __alltraps
c0101f8c:	e9 e4 fd ff ff       	jmp    c0101d75 <__alltraps>

c0101f91 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101f91:	6a 00                	push   $0x0
  pushl $58
c0101f93:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101f95:	e9 db fd ff ff       	jmp    c0101d75 <__alltraps>

c0101f9a <vector59>:
.globl vector59
vector59:
  pushl $0
c0101f9a:	6a 00                	push   $0x0
  pushl $59
c0101f9c:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101f9e:	e9 d2 fd ff ff       	jmp    c0101d75 <__alltraps>

c0101fa3 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fa3:	6a 00                	push   $0x0
  pushl $60
c0101fa5:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fa7:	e9 c9 fd ff ff       	jmp    c0101d75 <__alltraps>

c0101fac <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fac:	6a 00                	push   $0x0
  pushl $61
c0101fae:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fb0:	e9 c0 fd ff ff       	jmp    c0101d75 <__alltraps>

c0101fb5 <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fb5:	6a 00                	push   $0x0
  pushl $62
c0101fb7:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fb9:	e9 b7 fd ff ff       	jmp    c0101d75 <__alltraps>

c0101fbe <vector63>:
.globl vector63
vector63:
  pushl $0
c0101fbe:	6a 00                	push   $0x0
  pushl $63
c0101fc0:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fc2:	e9 ae fd ff ff       	jmp    c0101d75 <__alltraps>

c0101fc7 <vector64>:
.globl vector64
vector64:
  pushl $0
c0101fc7:	6a 00                	push   $0x0
  pushl $64
c0101fc9:	6a 40                	push   $0x40
  jmp __alltraps
c0101fcb:	e9 a5 fd ff ff       	jmp    c0101d75 <__alltraps>

c0101fd0 <vector65>:
.globl vector65
vector65:
  pushl $0
c0101fd0:	6a 00                	push   $0x0
  pushl $65
c0101fd2:	6a 41                	push   $0x41
  jmp __alltraps
c0101fd4:	e9 9c fd ff ff       	jmp    c0101d75 <__alltraps>

c0101fd9 <vector66>:
.globl vector66
vector66:
  pushl $0
c0101fd9:	6a 00                	push   $0x0
  pushl $66
c0101fdb:	6a 42                	push   $0x42
  jmp __alltraps
c0101fdd:	e9 93 fd ff ff       	jmp    c0101d75 <__alltraps>

c0101fe2 <vector67>:
.globl vector67
vector67:
  pushl $0
c0101fe2:	6a 00                	push   $0x0
  pushl $67
c0101fe4:	6a 43                	push   $0x43
  jmp __alltraps
c0101fe6:	e9 8a fd ff ff       	jmp    c0101d75 <__alltraps>

c0101feb <vector68>:
.globl vector68
vector68:
  pushl $0
c0101feb:	6a 00                	push   $0x0
  pushl $68
c0101fed:	6a 44                	push   $0x44
  jmp __alltraps
c0101fef:	e9 81 fd ff ff       	jmp    c0101d75 <__alltraps>

c0101ff4 <vector69>:
.globl vector69
vector69:
  pushl $0
c0101ff4:	6a 00                	push   $0x0
  pushl $69
c0101ff6:	6a 45                	push   $0x45
  jmp __alltraps
c0101ff8:	e9 78 fd ff ff       	jmp    c0101d75 <__alltraps>

c0101ffd <vector70>:
.globl vector70
vector70:
  pushl $0
c0101ffd:	6a 00                	push   $0x0
  pushl $70
c0101fff:	6a 46                	push   $0x46
  jmp __alltraps
c0102001:	e9 6f fd ff ff       	jmp    c0101d75 <__alltraps>

c0102006 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102006:	6a 00                	push   $0x0
  pushl $71
c0102008:	6a 47                	push   $0x47
  jmp __alltraps
c010200a:	e9 66 fd ff ff       	jmp    c0101d75 <__alltraps>

c010200f <vector72>:
.globl vector72
vector72:
  pushl $0
c010200f:	6a 00                	push   $0x0
  pushl $72
c0102011:	6a 48                	push   $0x48
  jmp __alltraps
c0102013:	e9 5d fd ff ff       	jmp    c0101d75 <__alltraps>

c0102018 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102018:	6a 00                	push   $0x0
  pushl $73
c010201a:	6a 49                	push   $0x49
  jmp __alltraps
c010201c:	e9 54 fd ff ff       	jmp    c0101d75 <__alltraps>

c0102021 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102021:	6a 00                	push   $0x0
  pushl $74
c0102023:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102025:	e9 4b fd ff ff       	jmp    c0101d75 <__alltraps>

c010202a <vector75>:
.globl vector75
vector75:
  pushl $0
c010202a:	6a 00                	push   $0x0
  pushl $75
c010202c:	6a 4b                	push   $0x4b
  jmp __alltraps
c010202e:	e9 42 fd ff ff       	jmp    c0101d75 <__alltraps>

c0102033 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102033:	6a 00                	push   $0x0
  pushl $76
c0102035:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102037:	e9 39 fd ff ff       	jmp    c0101d75 <__alltraps>

c010203c <vector77>:
.globl vector77
vector77:
  pushl $0
c010203c:	6a 00                	push   $0x0
  pushl $77
c010203e:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102040:	e9 30 fd ff ff       	jmp    c0101d75 <__alltraps>

c0102045 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102045:	6a 00                	push   $0x0
  pushl $78
c0102047:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102049:	e9 27 fd ff ff       	jmp    c0101d75 <__alltraps>

c010204e <vector79>:
.globl vector79
vector79:
  pushl $0
c010204e:	6a 00                	push   $0x0
  pushl $79
c0102050:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102052:	e9 1e fd ff ff       	jmp    c0101d75 <__alltraps>

c0102057 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102057:	6a 00                	push   $0x0
  pushl $80
c0102059:	6a 50                	push   $0x50
  jmp __alltraps
c010205b:	e9 15 fd ff ff       	jmp    c0101d75 <__alltraps>

c0102060 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102060:	6a 00                	push   $0x0
  pushl $81
c0102062:	6a 51                	push   $0x51
  jmp __alltraps
c0102064:	e9 0c fd ff ff       	jmp    c0101d75 <__alltraps>

c0102069 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102069:	6a 00                	push   $0x0
  pushl $82
c010206b:	6a 52                	push   $0x52
  jmp __alltraps
c010206d:	e9 03 fd ff ff       	jmp    c0101d75 <__alltraps>

c0102072 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102072:	6a 00                	push   $0x0
  pushl $83
c0102074:	6a 53                	push   $0x53
  jmp __alltraps
c0102076:	e9 fa fc ff ff       	jmp    c0101d75 <__alltraps>

c010207b <vector84>:
.globl vector84
vector84:
  pushl $0
c010207b:	6a 00                	push   $0x0
  pushl $84
c010207d:	6a 54                	push   $0x54
  jmp __alltraps
c010207f:	e9 f1 fc ff ff       	jmp    c0101d75 <__alltraps>

c0102084 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102084:	6a 00                	push   $0x0
  pushl $85
c0102086:	6a 55                	push   $0x55
  jmp __alltraps
c0102088:	e9 e8 fc ff ff       	jmp    c0101d75 <__alltraps>

c010208d <vector86>:
.globl vector86
vector86:
  pushl $0
c010208d:	6a 00                	push   $0x0
  pushl $86
c010208f:	6a 56                	push   $0x56
  jmp __alltraps
c0102091:	e9 df fc ff ff       	jmp    c0101d75 <__alltraps>

c0102096 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102096:	6a 00                	push   $0x0
  pushl $87
c0102098:	6a 57                	push   $0x57
  jmp __alltraps
c010209a:	e9 d6 fc ff ff       	jmp    c0101d75 <__alltraps>

c010209f <vector88>:
.globl vector88
vector88:
  pushl $0
c010209f:	6a 00                	push   $0x0
  pushl $88
c01020a1:	6a 58                	push   $0x58
  jmp __alltraps
c01020a3:	e9 cd fc ff ff       	jmp    c0101d75 <__alltraps>

c01020a8 <vector89>:
.globl vector89
vector89:
  pushl $0
c01020a8:	6a 00                	push   $0x0
  pushl $89
c01020aa:	6a 59                	push   $0x59
  jmp __alltraps
c01020ac:	e9 c4 fc ff ff       	jmp    c0101d75 <__alltraps>

c01020b1 <vector90>:
.globl vector90
vector90:
  pushl $0
c01020b1:	6a 00                	push   $0x0
  pushl $90
c01020b3:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020b5:	e9 bb fc ff ff       	jmp    c0101d75 <__alltraps>

c01020ba <vector91>:
.globl vector91
vector91:
  pushl $0
c01020ba:	6a 00                	push   $0x0
  pushl $91
c01020bc:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020be:	e9 b2 fc ff ff       	jmp    c0101d75 <__alltraps>

c01020c3 <vector92>:
.globl vector92
vector92:
  pushl $0
c01020c3:	6a 00                	push   $0x0
  pushl $92
c01020c5:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020c7:	e9 a9 fc ff ff       	jmp    c0101d75 <__alltraps>

c01020cc <vector93>:
.globl vector93
vector93:
  pushl $0
c01020cc:	6a 00                	push   $0x0
  pushl $93
c01020ce:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020d0:	e9 a0 fc ff ff       	jmp    c0101d75 <__alltraps>

c01020d5 <vector94>:
.globl vector94
vector94:
  pushl $0
c01020d5:	6a 00                	push   $0x0
  pushl $94
c01020d7:	6a 5e                	push   $0x5e
  jmp __alltraps
c01020d9:	e9 97 fc ff ff       	jmp    c0101d75 <__alltraps>

c01020de <vector95>:
.globl vector95
vector95:
  pushl $0
c01020de:	6a 00                	push   $0x0
  pushl $95
c01020e0:	6a 5f                	push   $0x5f
  jmp __alltraps
c01020e2:	e9 8e fc ff ff       	jmp    c0101d75 <__alltraps>

c01020e7 <vector96>:
.globl vector96
vector96:
  pushl $0
c01020e7:	6a 00                	push   $0x0
  pushl $96
c01020e9:	6a 60                	push   $0x60
  jmp __alltraps
c01020eb:	e9 85 fc ff ff       	jmp    c0101d75 <__alltraps>

c01020f0 <vector97>:
.globl vector97
vector97:
  pushl $0
c01020f0:	6a 00                	push   $0x0
  pushl $97
c01020f2:	6a 61                	push   $0x61
  jmp __alltraps
c01020f4:	e9 7c fc ff ff       	jmp    c0101d75 <__alltraps>

c01020f9 <vector98>:
.globl vector98
vector98:
  pushl $0
c01020f9:	6a 00                	push   $0x0
  pushl $98
c01020fb:	6a 62                	push   $0x62
  jmp __alltraps
c01020fd:	e9 73 fc ff ff       	jmp    c0101d75 <__alltraps>

c0102102 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102102:	6a 00                	push   $0x0
  pushl $99
c0102104:	6a 63                	push   $0x63
  jmp __alltraps
c0102106:	e9 6a fc ff ff       	jmp    c0101d75 <__alltraps>

c010210b <vector100>:
.globl vector100
vector100:
  pushl $0
c010210b:	6a 00                	push   $0x0
  pushl $100
c010210d:	6a 64                	push   $0x64
  jmp __alltraps
c010210f:	e9 61 fc ff ff       	jmp    c0101d75 <__alltraps>

c0102114 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102114:	6a 00                	push   $0x0
  pushl $101
c0102116:	6a 65                	push   $0x65
  jmp __alltraps
c0102118:	e9 58 fc ff ff       	jmp    c0101d75 <__alltraps>

c010211d <vector102>:
.globl vector102
vector102:
  pushl $0
c010211d:	6a 00                	push   $0x0
  pushl $102
c010211f:	6a 66                	push   $0x66
  jmp __alltraps
c0102121:	e9 4f fc ff ff       	jmp    c0101d75 <__alltraps>

c0102126 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102126:	6a 00                	push   $0x0
  pushl $103
c0102128:	6a 67                	push   $0x67
  jmp __alltraps
c010212a:	e9 46 fc ff ff       	jmp    c0101d75 <__alltraps>

c010212f <vector104>:
.globl vector104
vector104:
  pushl $0
c010212f:	6a 00                	push   $0x0
  pushl $104
c0102131:	6a 68                	push   $0x68
  jmp __alltraps
c0102133:	e9 3d fc ff ff       	jmp    c0101d75 <__alltraps>

c0102138 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102138:	6a 00                	push   $0x0
  pushl $105
c010213a:	6a 69                	push   $0x69
  jmp __alltraps
c010213c:	e9 34 fc ff ff       	jmp    c0101d75 <__alltraps>

c0102141 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102141:	6a 00                	push   $0x0
  pushl $106
c0102143:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102145:	e9 2b fc ff ff       	jmp    c0101d75 <__alltraps>

c010214a <vector107>:
.globl vector107
vector107:
  pushl $0
c010214a:	6a 00                	push   $0x0
  pushl $107
c010214c:	6a 6b                	push   $0x6b
  jmp __alltraps
c010214e:	e9 22 fc ff ff       	jmp    c0101d75 <__alltraps>

c0102153 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102153:	6a 00                	push   $0x0
  pushl $108
c0102155:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102157:	e9 19 fc ff ff       	jmp    c0101d75 <__alltraps>

c010215c <vector109>:
.globl vector109
vector109:
  pushl $0
c010215c:	6a 00                	push   $0x0
  pushl $109
c010215e:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102160:	e9 10 fc ff ff       	jmp    c0101d75 <__alltraps>

c0102165 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102165:	6a 00                	push   $0x0
  pushl $110
c0102167:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102169:	e9 07 fc ff ff       	jmp    c0101d75 <__alltraps>

c010216e <vector111>:
.globl vector111
vector111:
  pushl $0
c010216e:	6a 00                	push   $0x0
  pushl $111
c0102170:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102172:	e9 fe fb ff ff       	jmp    c0101d75 <__alltraps>

c0102177 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102177:	6a 00                	push   $0x0
  pushl $112
c0102179:	6a 70                	push   $0x70
  jmp __alltraps
c010217b:	e9 f5 fb ff ff       	jmp    c0101d75 <__alltraps>

c0102180 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102180:	6a 00                	push   $0x0
  pushl $113
c0102182:	6a 71                	push   $0x71
  jmp __alltraps
c0102184:	e9 ec fb ff ff       	jmp    c0101d75 <__alltraps>

c0102189 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102189:	6a 00                	push   $0x0
  pushl $114
c010218b:	6a 72                	push   $0x72
  jmp __alltraps
c010218d:	e9 e3 fb ff ff       	jmp    c0101d75 <__alltraps>

c0102192 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102192:	6a 00                	push   $0x0
  pushl $115
c0102194:	6a 73                	push   $0x73
  jmp __alltraps
c0102196:	e9 da fb ff ff       	jmp    c0101d75 <__alltraps>

c010219b <vector116>:
.globl vector116
vector116:
  pushl $0
c010219b:	6a 00                	push   $0x0
  pushl $116
c010219d:	6a 74                	push   $0x74
  jmp __alltraps
c010219f:	e9 d1 fb ff ff       	jmp    c0101d75 <__alltraps>

c01021a4 <vector117>:
.globl vector117
vector117:
  pushl $0
c01021a4:	6a 00                	push   $0x0
  pushl $117
c01021a6:	6a 75                	push   $0x75
  jmp __alltraps
c01021a8:	e9 c8 fb ff ff       	jmp    c0101d75 <__alltraps>

c01021ad <vector118>:
.globl vector118
vector118:
  pushl $0
c01021ad:	6a 00                	push   $0x0
  pushl $118
c01021af:	6a 76                	push   $0x76
  jmp __alltraps
c01021b1:	e9 bf fb ff ff       	jmp    c0101d75 <__alltraps>

c01021b6 <vector119>:
.globl vector119
vector119:
  pushl $0
c01021b6:	6a 00                	push   $0x0
  pushl $119
c01021b8:	6a 77                	push   $0x77
  jmp __alltraps
c01021ba:	e9 b6 fb ff ff       	jmp    c0101d75 <__alltraps>

c01021bf <vector120>:
.globl vector120
vector120:
  pushl $0
c01021bf:	6a 00                	push   $0x0
  pushl $120
c01021c1:	6a 78                	push   $0x78
  jmp __alltraps
c01021c3:	e9 ad fb ff ff       	jmp    c0101d75 <__alltraps>

c01021c8 <vector121>:
.globl vector121
vector121:
  pushl $0
c01021c8:	6a 00                	push   $0x0
  pushl $121
c01021ca:	6a 79                	push   $0x79
  jmp __alltraps
c01021cc:	e9 a4 fb ff ff       	jmp    c0101d75 <__alltraps>

c01021d1 <vector122>:
.globl vector122
vector122:
  pushl $0
c01021d1:	6a 00                	push   $0x0
  pushl $122
c01021d3:	6a 7a                	push   $0x7a
  jmp __alltraps
c01021d5:	e9 9b fb ff ff       	jmp    c0101d75 <__alltraps>

c01021da <vector123>:
.globl vector123
vector123:
  pushl $0
c01021da:	6a 00                	push   $0x0
  pushl $123
c01021dc:	6a 7b                	push   $0x7b
  jmp __alltraps
c01021de:	e9 92 fb ff ff       	jmp    c0101d75 <__alltraps>

c01021e3 <vector124>:
.globl vector124
vector124:
  pushl $0
c01021e3:	6a 00                	push   $0x0
  pushl $124
c01021e5:	6a 7c                	push   $0x7c
  jmp __alltraps
c01021e7:	e9 89 fb ff ff       	jmp    c0101d75 <__alltraps>

c01021ec <vector125>:
.globl vector125
vector125:
  pushl $0
c01021ec:	6a 00                	push   $0x0
  pushl $125
c01021ee:	6a 7d                	push   $0x7d
  jmp __alltraps
c01021f0:	e9 80 fb ff ff       	jmp    c0101d75 <__alltraps>

c01021f5 <vector126>:
.globl vector126
vector126:
  pushl $0
c01021f5:	6a 00                	push   $0x0
  pushl $126
c01021f7:	6a 7e                	push   $0x7e
  jmp __alltraps
c01021f9:	e9 77 fb ff ff       	jmp    c0101d75 <__alltraps>

c01021fe <vector127>:
.globl vector127
vector127:
  pushl $0
c01021fe:	6a 00                	push   $0x0
  pushl $127
c0102200:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102202:	e9 6e fb ff ff       	jmp    c0101d75 <__alltraps>

c0102207 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102207:	6a 00                	push   $0x0
  pushl $128
c0102209:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010220e:	e9 62 fb ff ff       	jmp    c0101d75 <__alltraps>

c0102213 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102213:	6a 00                	push   $0x0
  pushl $129
c0102215:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010221a:	e9 56 fb ff ff       	jmp    c0101d75 <__alltraps>

c010221f <vector130>:
.globl vector130
vector130:
  pushl $0
c010221f:	6a 00                	push   $0x0
  pushl $130
c0102221:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102226:	e9 4a fb ff ff       	jmp    c0101d75 <__alltraps>

c010222b <vector131>:
.globl vector131
vector131:
  pushl $0
c010222b:	6a 00                	push   $0x0
  pushl $131
c010222d:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102232:	e9 3e fb ff ff       	jmp    c0101d75 <__alltraps>

c0102237 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102237:	6a 00                	push   $0x0
  pushl $132
c0102239:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010223e:	e9 32 fb ff ff       	jmp    c0101d75 <__alltraps>

c0102243 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102243:	6a 00                	push   $0x0
  pushl $133
c0102245:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010224a:	e9 26 fb ff ff       	jmp    c0101d75 <__alltraps>

c010224f <vector134>:
.globl vector134
vector134:
  pushl $0
c010224f:	6a 00                	push   $0x0
  pushl $134
c0102251:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102256:	e9 1a fb ff ff       	jmp    c0101d75 <__alltraps>

c010225b <vector135>:
.globl vector135
vector135:
  pushl $0
c010225b:	6a 00                	push   $0x0
  pushl $135
c010225d:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102262:	e9 0e fb ff ff       	jmp    c0101d75 <__alltraps>

c0102267 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102267:	6a 00                	push   $0x0
  pushl $136
c0102269:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010226e:	e9 02 fb ff ff       	jmp    c0101d75 <__alltraps>

c0102273 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102273:	6a 00                	push   $0x0
  pushl $137
c0102275:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010227a:	e9 f6 fa ff ff       	jmp    c0101d75 <__alltraps>

c010227f <vector138>:
.globl vector138
vector138:
  pushl $0
c010227f:	6a 00                	push   $0x0
  pushl $138
c0102281:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102286:	e9 ea fa ff ff       	jmp    c0101d75 <__alltraps>

c010228b <vector139>:
.globl vector139
vector139:
  pushl $0
c010228b:	6a 00                	push   $0x0
  pushl $139
c010228d:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102292:	e9 de fa ff ff       	jmp    c0101d75 <__alltraps>

c0102297 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102297:	6a 00                	push   $0x0
  pushl $140
c0102299:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010229e:	e9 d2 fa ff ff       	jmp    c0101d75 <__alltraps>

c01022a3 <vector141>:
.globl vector141
vector141:
  pushl $0
c01022a3:	6a 00                	push   $0x0
  pushl $141
c01022a5:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022aa:	e9 c6 fa ff ff       	jmp    c0101d75 <__alltraps>

c01022af <vector142>:
.globl vector142
vector142:
  pushl $0
c01022af:	6a 00                	push   $0x0
  pushl $142
c01022b1:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022b6:	e9 ba fa ff ff       	jmp    c0101d75 <__alltraps>

c01022bb <vector143>:
.globl vector143
vector143:
  pushl $0
c01022bb:	6a 00                	push   $0x0
  pushl $143
c01022bd:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022c2:	e9 ae fa ff ff       	jmp    c0101d75 <__alltraps>

c01022c7 <vector144>:
.globl vector144
vector144:
  pushl $0
c01022c7:	6a 00                	push   $0x0
  pushl $144
c01022c9:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022ce:	e9 a2 fa ff ff       	jmp    c0101d75 <__alltraps>

c01022d3 <vector145>:
.globl vector145
vector145:
  pushl $0
c01022d3:	6a 00                	push   $0x0
  pushl $145
c01022d5:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01022da:	e9 96 fa ff ff       	jmp    c0101d75 <__alltraps>

c01022df <vector146>:
.globl vector146
vector146:
  pushl $0
c01022df:	6a 00                	push   $0x0
  pushl $146
c01022e1:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01022e6:	e9 8a fa ff ff       	jmp    c0101d75 <__alltraps>

c01022eb <vector147>:
.globl vector147
vector147:
  pushl $0
c01022eb:	6a 00                	push   $0x0
  pushl $147
c01022ed:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01022f2:	e9 7e fa ff ff       	jmp    c0101d75 <__alltraps>

c01022f7 <vector148>:
.globl vector148
vector148:
  pushl $0
c01022f7:	6a 00                	push   $0x0
  pushl $148
c01022f9:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01022fe:	e9 72 fa ff ff       	jmp    c0101d75 <__alltraps>

c0102303 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102303:	6a 00                	push   $0x0
  pushl $149
c0102305:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010230a:	e9 66 fa ff ff       	jmp    c0101d75 <__alltraps>

c010230f <vector150>:
.globl vector150
vector150:
  pushl $0
c010230f:	6a 00                	push   $0x0
  pushl $150
c0102311:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102316:	e9 5a fa ff ff       	jmp    c0101d75 <__alltraps>

c010231b <vector151>:
.globl vector151
vector151:
  pushl $0
c010231b:	6a 00                	push   $0x0
  pushl $151
c010231d:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102322:	e9 4e fa ff ff       	jmp    c0101d75 <__alltraps>

c0102327 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102327:	6a 00                	push   $0x0
  pushl $152
c0102329:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010232e:	e9 42 fa ff ff       	jmp    c0101d75 <__alltraps>

c0102333 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102333:	6a 00                	push   $0x0
  pushl $153
c0102335:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010233a:	e9 36 fa ff ff       	jmp    c0101d75 <__alltraps>

c010233f <vector154>:
.globl vector154
vector154:
  pushl $0
c010233f:	6a 00                	push   $0x0
  pushl $154
c0102341:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102346:	e9 2a fa ff ff       	jmp    c0101d75 <__alltraps>

c010234b <vector155>:
.globl vector155
vector155:
  pushl $0
c010234b:	6a 00                	push   $0x0
  pushl $155
c010234d:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102352:	e9 1e fa ff ff       	jmp    c0101d75 <__alltraps>

c0102357 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102357:	6a 00                	push   $0x0
  pushl $156
c0102359:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010235e:	e9 12 fa ff ff       	jmp    c0101d75 <__alltraps>

c0102363 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102363:	6a 00                	push   $0x0
  pushl $157
c0102365:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010236a:	e9 06 fa ff ff       	jmp    c0101d75 <__alltraps>

c010236f <vector158>:
.globl vector158
vector158:
  pushl $0
c010236f:	6a 00                	push   $0x0
  pushl $158
c0102371:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102376:	e9 fa f9 ff ff       	jmp    c0101d75 <__alltraps>

c010237b <vector159>:
.globl vector159
vector159:
  pushl $0
c010237b:	6a 00                	push   $0x0
  pushl $159
c010237d:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102382:	e9 ee f9 ff ff       	jmp    c0101d75 <__alltraps>

c0102387 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102387:	6a 00                	push   $0x0
  pushl $160
c0102389:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010238e:	e9 e2 f9 ff ff       	jmp    c0101d75 <__alltraps>

c0102393 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102393:	6a 00                	push   $0x0
  pushl $161
c0102395:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010239a:	e9 d6 f9 ff ff       	jmp    c0101d75 <__alltraps>

c010239f <vector162>:
.globl vector162
vector162:
  pushl $0
c010239f:	6a 00                	push   $0x0
  pushl $162
c01023a1:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023a6:	e9 ca f9 ff ff       	jmp    c0101d75 <__alltraps>

c01023ab <vector163>:
.globl vector163
vector163:
  pushl $0
c01023ab:	6a 00                	push   $0x0
  pushl $163
c01023ad:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023b2:	e9 be f9 ff ff       	jmp    c0101d75 <__alltraps>

c01023b7 <vector164>:
.globl vector164
vector164:
  pushl $0
c01023b7:	6a 00                	push   $0x0
  pushl $164
c01023b9:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023be:	e9 b2 f9 ff ff       	jmp    c0101d75 <__alltraps>

c01023c3 <vector165>:
.globl vector165
vector165:
  pushl $0
c01023c3:	6a 00                	push   $0x0
  pushl $165
c01023c5:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023ca:	e9 a6 f9 ff ff       	jmp    c0101d75 <__alltraps>

c01023cf <vector166>:
.globl vector166
vector166:
  pushl $0
c01023cf:	6a 00                	push   $0x0
  pushl $166
c01023d1:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01023d6:	e9 9a f9 ff ff       	jmp    c0101d75 <__alltraps>

c01023db <vector167>:
.globl vector167
vector167:
  pushl $0
c01023db:	6a 00                	push   $0x0
  pushl $167
c01023dd:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01023e2:	e9 8e f9 ff ff       	jmp    c0101d75 <__alltraps>

c01023e7 <vector168>:
.globl vector168
vector168:
  pushl $0
c01023e7:	6a 00                	push   $0x0
  pushl $168
c01023e9:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01023ee:	e9 82 f9 ff ff       	jmp    c0101d75 <__alltraps>

c01023f3 <vector169>:
.globl vector169
vector169:
  pushl $0
c01023f3:	6a 00                	push   $0x0
  pushl $169
c01023f5:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01023fa:	e9 76 f9 ff ff       	jmp    c0101d75 <__alltraps>

c01023ff <vector170>:
.globl vector170
vector170:
  pushl $0
c01023ff:	6a 00                	push   $0x0
  pushl $170
c0102401:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102406:	e9 6a f9 ff ff       	jmp    c0101d75 <__alltraps>

c010240b <vector171>:
.globl vector171
vector171:
  pushl $0
c010240b:	6a 00                	push   $0x0
  pushl $171
c010240d:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102412:	e9 5e f9 ff ff       	jmp    c0101d75 <__alltraps>

c0102417 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102417:	6a 00                	push   $0x0
  pushl $172
c0102419:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010241e:	e9 52 f9 ff ff       	jmp    c0101d75 <__alltraps>

c0102423 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102423:	6a 00                	push   $0x0
  pushl $173
c0102425:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010242a:	e9 46 f9 ff ff       	jmp    c0101d75 <__alltraps>

c010242f <vector174>:
.globl vector174
vector174:
  pushl $0
c010242f:	6a 00                	push   $0x0
  pushl $174
c0102431:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102436:	e9 3a f9 ff ff       	jmp    c0101d75 <__alltraps>

c010243b <vector175>:
.globl vector175
vector175:
  pushl $0
c010243b:	6a 00                	push   $0x0
  pushl $175
c010243d:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102442:	e9 2e f9 ff ff       	jmp    c0101d75 <__alltraps>

c0102447 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102447:	6a 00                	push   $0x0
  pushl $176
c0102449:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010244e:	e9 22 f9 ff ff       	jmp    c0101d75 <__alltraps>

c0102453 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102453:	6a 00                	push   $0x0
  pushl $177
c0102455:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010245a:	e9 16 f9 ff ff       	jmp    c0101d75 <__alltraps>

c010245f <vector178>:
.globl vector178
vector178:
  pushl $0
c010245f:	6a 00                	push   $0x0
  pushl $178
c0102461:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102466:	e9 0a f9 ff ff       	jmp    c0101d75 <__alltraps>

c010246b <vector179>:
.globl vector179
vector179:
  pushl $0
c010246b:	6a 00                	push   $0x0
  pushl $179
c010246d:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102472:	e9 fe f8 ff ff       	jmp    c0101d75 <__alltraps>

c0102477 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102477:	6a 00                	push   $0x0
  pushl $180
c0102479:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010247e:	e9 f2 f8 ff ff       	jmp    c0101d75 <__alltraps>

c0102483 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102483:	6a 00                	push   $0x0
  pushl $181
c0102485:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010248a:	e9 e6 f8 ff ff       	jmp    c0101d75 <__alltraps>

c010248f <vector182>:
.globl vector182
vector182:
  pushl $0
c010248f:	6a 00                	push   $0x0
  pushl $182
c0102491:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102496:	e9 da f8 ff ff       	jmp    c0101d75 <__alltraps>

c010249b <vector183>:
.globl vector183
vector183:
  pushl $0
c010249b:	6a 00                	push   $0x0
  pushl $183
c010249d:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024a2:	e9 ce f8 ff ff       	jmp    c0101d75 <__alltraps>

c01024a7 <vector184>:
.globl vector184
vector184:
  pushl $0
c01024a7:	6a 00                	push   $0x0
  pushl $184
c01024a9:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024ae:	e9 c2 f8 ff ff       	jmp    c0101d75 <__alltraps>

c01024b3 <vector185>:
.globl vector185
vector185:
  pushl $0
c01024b3:	6a 00                	push   $0x0
  pushl $185
c01024b5:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024ba:	e9 b6 f8 ff ff       	jmp    c0101d75 <__alltraps>

c01024bf <vector186>:
.globl vector186
vector186:
  pushl $0
c01024bf:	6a 00                	push   $0x0
  pushl $186
c01024c1:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024c6:	e9 aa f8 ff ff       	jmp    c0101d75 <__alltraps>

c01024cb <vector187>:
.globl vector187
vector187:
  pushl $0
c01024cb:	6a 00                	push   $0x0
  pushl $187
c01024cd:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024d2:	e9 9e f8 ff ff       	jmp    c0101d75 <__alltraps>

c01024d7 <vector188>:
.globl vector188
vector188:
  pushl $0
c01024d7:	6a 00                	push   $0x0
  pushl $188
c01024d9:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01024de:	e9 92 f8 ff ff       	jmp    c0101d75 <__alltraps>

c01024e3 <vector189>:
.globl vector189
vector189:
  pushl $0
c01024e3:	6a 00                	push   $0x0
  pushl $189
c01024e5:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01024ea:	e9 86 f8 ff ff       	jmp    c0101d75 <__alltraps>

c01024ef <vector190>:
.globl vector190
vector190:
  pushl $0
c01024ef:	6a 00                	push   $0x0
  pushl $190
c01024f1:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01024f6:	e9 7a f8 ff ff       	jmp    c0101d75 <__alltraps>

c01024fb <vector191>:
.globl vector191
vector191:
  pushl $0
c01024fb:	6a 00                	push   $0x0
  pushl $191
c01024fd:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102502:	e9 6e f8 ff ff       	jmp    c0101d75 <__alltraps>

c0102507 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102507:	6a 00                	push   $0x0
  pushl $192
c0102509:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010250e:	e9 62 f8 ff ff       	jmp    c0101d75 <__alltraps>

c0102513 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102513:	6a 00                	push   $0x0
  pushl $193
c0102515:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010251a:	e9 56 f8 ff ff       	jmp    c0101d75 <__alltraps>

c010251f <vector194>:
.globl vector194
vector194:
  pushl $0
c010251f:	6a 00                	push   $0x0
  pushl $194
c0102521:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102526:	e9 4a f8 ff ff       	jmp    c0101d75 <__alltraps>

c010252b <vector195>:
.globl vector195
vector195:
  pushl $0
c010252b:	6a 00                	push   $0x0
  pushl $195
c010252d:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102532:	e9 3e f8 ff ff       	jmp    c0101d75 <__alltraps>

c0102537 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102537:	6a 00                	push   $0x0
  pushl $196
c0102539:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010253e:	e9 32 f8 ff ff       	jmp    c0101d75 <__alltraps>

c0102543 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102543:	6a 00                	push   $0x0
  pushl $197
c0102545:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010254a:	e9 26 f8 ff ff       	jmp    c0101d75 <__alltraps>

c010254f <vector198>:
.globl vector198
vector198:
  pushl $0
c010254f:	6a 00                	push   $0x0
  pushl $198
c0102551:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102556:	e9 1a f8 ff ff       	jmp    c0101d75 <__alltraps>

c010255b <vector199>:
.globl vector199
vector199:
  pushl $0
c010255b:	6a 00                	push   $0x0
  pushl $199
c010255d:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102562:	e9 0e f8 ff ff       	jmp    c0101d75 <__alltraps>

c0102567 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102567:	6a 00                	push   $0x0
  pushl $200
c0102569:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010256e:	e9 02 f8 ff ff       	jmp    c0101d75 <__alltraps>

c0102573 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102573:	6a 00                	push   $0x0
  pushl $201
c0102575:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010257a:	e9 f6 f7 ff ff       	jmp    c0101d75 <__alltraps>

c010257f <vector202>:
.globl vector202
vector202:
  pushl $0
c010257f:	6a 00                	push   $0x0
  pushl $202
c0102581:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102586:	e9 ea f7 ff ff       	jmp    c0101d75 <__alltraps>

c010258b <vector203>:
.globl vector203
vector203:
  pushl $0
c010258b:	6a 00                	push   $0x0
  pushl $203
c010258d:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102592:	e9 de f7 ff ff       	jmp    c0101d75 <__alltraps>

c0102597 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102597:	6a 00                	push   $0x0
  pushl $204
c0102599:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010259e:	e9 d2 f7 ff ff       	jmp    c0101d75 <__alltraps>

c01025a3 <vector205>:
.globl vector205
vector205:
  pushl $0
c01025a3:	6a 00                	push   $0x0
  pushl $205
c01025a5:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025aa:	e9 c6 f7 ff ff       	jmp    c0101d75 <__alltraps>

c01025af <vector206>:
.globl vector206
vector206:
  pushl $0
c01025af:	6a 00                	push   $0x0
  pushl $206
c01025b1:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025b6:	e9 ba f7 ff ff       	jmp    c0101d75 <__alltraps>

c01025bb <vector207>:
.globl vector207
vector207:
  pushl $0
c01025bb:	6a 00                	push   $0x0
  pushl $207
c01025bd:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025c2:	e9 ae f7 ff ff       	jmp    c0101d75 <__alltraps>

c01025c7 <vector208>:
.globl vector208
vector208:
  pushl $0
c01025c7:	6a 00                	push   $0x0
  pushl $208
c01025c9:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025ce:	e9 a2 f7 ff ff       	jmp    c0101d75 <__alltraps>

c01025d3 <vector209>:
.globl vector209
vector209:
  pushl $0
c01025d3:	6a 00                	push   $0x0
  pushl $209
c01025d5:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01025da:	e9 96 f7 ff ff       	jmp    c0101d75 <__alltraps>

c01025df <vector210>:
.globl vector210
vector210:
  pushl $0
c01025df:	6a 00                	push   $0x0
  pushl $210
c01025e1:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01025e6:	e9 8a f7 ff ff       	jmp    c0101d75 <__alltraps>

c01025eb <vector211>:
.globl vector211
vector211:
  pushl $0
c01025eb:	6a 00                	push   $0x0
  pushl $211
c01025ed:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01025f2:	e9 7e f7 ff ff       	jmp    c0101d75 <__alltraps>

c01025f7 <vector212>:
.globl vector212
vector212:
  pushl $0
c01025f7:	6a 00                	push   $0x0
  pushl $212
c01025f9:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01025fe:	e9 72 f7 ff ff       	jmp    c0101d75 <__alltraps>

c0102603 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102603:	6a 00                	push   $0x0
  pushl $213
c0102605:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010260a:	e9 66 f7 ff ff       	jmp    c0101d75 <__alltraps>

c010260f <vector214>:
.globl vector214
vector214:
  pushl $0
c010260f:	6a 00                	push   $0x0
  pushl $214
c0102611:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102616:	e9 5a f7 ff ff       	jmp    c0101d75 <__alltraps>

c010261b <vector215>:
.globl vector215
vector215:
  pushl $0
c010261b:	6a 00                	push   $0x0
  pushl $215
c010261d:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102622:	e9 4e f7 ff ff       	jmp    c0101d75 <__alltraps>

c0102627 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102627:	6a 00                	push   $0x0
  pushl $216
c0102629:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010262e:	e9 42 f7 ff ff       	jmp    c0101d75 <__alltraps>

c0102633 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102633:	6a 00                	push   $0x0
  pushl $217
c0102635:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010263a:	e9 36 f7 ff ff       	jmp    c0101d75 <__alltraps>

c010263f <vector218>:
.globl vector218
vector218:
  pushl $0
c010263f:	6a 00                	push   $0x0
  pushl $218
c0102641:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102646:	e9 2a f7 ff ff       	jmp    c0101d75 <__alltraps>

c010264b <vector219>:
.globl vector219
vector219:
  pushl $0
c010264b:	6a 00                	push   $0x0
  pushl $219
c010264d:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102652:	e9 1e f7 ff ff       	jmp    c0101d75 <__alltraps>

c0102657 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102657:	6a 00                	push   $0x0
  pushl $220
c0102659:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010265e:	e9 12 f7 ff ff       	jmp    c0101d75 <__alltraps>

c0102663 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102663:	6a 00                	push   $0x0
  pushl $221
c0102665:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010266a:	e9 06 f7 ff ff       	jmp    c0101d75 <__alltraps>

c010266f <vector222>:
.globl vector222
vector222:
  pushl $0
c010266f:	6a 00                	push   $0x0
  pushl $222
c0102671:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102676:	e9 fa f6 ff ff       	jmp    c0101d75 <__alltraps>

c010267b <vector223>:
.globl vector223
vector223:
  pushl $0
c010267b:	6a 00                	push   $0x0
  pushl $223
c010267d:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102682:	e9 ee f6 ff ff       	jmp    c0101d75 <__alltraps>

c0102687 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102687:	6a 00                	push   $0x0
  pushl $224
c0102689:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010268e:	e9 e2 f6 ff ff       	jmp    c0101d75 <__alltraps>

c0102693 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102693:	6a 00                	push   $0x0
  pushl $225
c0102695:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010269a:	e9 d6 f6 ff ff       	jmp    c0101d75 <__alltraps>

c010269f <vector226>:
.globl vector226
vector226:
  pushl $0
c010269f:	6a 00                	push   $0x0
  pushl $226
c01026a1:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026a6:	e9 ca f6 ff ff       	jmp    c0101d75 <__alltraps>

c01026ab <vector227>:
.globl vector227
vector227:
  pushl $0
c01026ab:	6a 00                	push   $0x0
  pushl $227
c01026ad:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026b2:	e9 be f6 ff ff       	jmp    c0101d75 <__alltraps>

c01026b7 <vector228>:
.globl vector228
vector228:
  pushl $0
c01026b7:	6a 00                	push   $0x0
  pushl $228
c01026b9:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026be:	e9 b2 f6 ff ff       	jmp    c0101d75 <__alltraps>

c01026c3 <vector229>:
.globl vector229
vector229:
  pushl $0
c01026c3:	6a 00                	push   $0x0
  pushl $229
c01026c5:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026ca:	e9 a6 f6 ff ff       	jmp    c0101d75 <__alltraps>

c01026cf <vector230>:
.globl vector230
vector230:
  pushl $0
c01026cf:	6a 00                	push   $0x0
  pushl $230
c01026d1:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01026d6:	e9 9a f6 ff ff       	jmp    c0101d75 <__alltraps>

c01026db <vector231>:
.globl vector231
vector231:
  pushl $0
c01026db:	6a 00                	push   $0x0
  pushl $231
c01026dd:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01026e2:	e9 8e f6 ff ff       	jmp    c0101d75 <__alltraps>

c01026e7 <vector232>:
.globl vector232
vector232:
  pushl $0
c01026e7:	6a 00                	push   $0x0
  pushl $232
c01026e9:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01026ee:	e9 82 f6 ff ff       	jmp    c0101d75 <__alltraps>

c01026f3 <vector233>:
.globl vector233
vector233:
  pushl $0
c01026f3:	6a 00                	push   $0x0
  pushl $233
c01026f5:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01026fa:	e9 76 f6 ff ff       	jmp    c0101d75 <__alltraps>

c01026ff <vector234>:
.globl vector234
vector234:
  pushl $0
c01026ff:	6a 00                	push   $0x0
  pushl $234
c0102701:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102706:	e9 6a f6 ff ff       	jmp    c0101d75 <__alltraps>

c010270b <vector235>:
.globl vector235
vector235:
  pushl $0
c010270b:	6a 00                	push   $0x0
  pushl $235
c010270d:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102712:	e9 5e f6 ff ff       	jmp    c0101d75 <__alltraps>

c0102717 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102717:	6a 00                	push   $0x0
  pushl $236
c0102719:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010271e:	e9 52 f6 ff ff       	jmp    c0101d75 <__alltraps>

c0102723 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102723:	6a 00                	push   $0x0
  pushl $237
c0102725:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010272a:	e9 46 f6 ff ff       	jmp    c0101d75 <__alltraps>

c010272f <vector238>:
.globl vector238
vector238:
  pushl $0
c010272f:	6a 00                	push   $0x0
  pushl $238
c0102731:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102736:	e9 3a f6 ff ff       	jmp    c0101d75 <__alltraps>

c010273b <vector239>:
.globl vector239
vector239:
  pushl $0
c010273b:	6a 00                	push   $0x0
  pushl $239
c010273d:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102742:	e9 2e f6 ff ff       	jmp    c0101d75 <__alltraps>

c0102747 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102747:	6a 00                	push   $0x0
  pushl $240
c0102749:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010274e:	e9 22 f6 ff ff       	jmp    c0101d75 <__alltraps>

c0102753 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102753:	6a 00                	push   $0x0
  pushl $241
c0102755:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010275a:	e9 16 f6 ff ff       	jmp    c0101d75 <__alltraps>

c010275f <vector242>:
.globl vector242
vector242:
  pushl $0
c010275f:	6a 00                	push   $0x0
  pushl $242
c0102761:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102766:	e9 0a f6 ff ff       	jmp    c0101d75 <__alltraps>

c010276b <vector243>:
.globl vector243
vector243:
  pushl $0
c010276b:	6a 00                	push   $0x0
  pushl $243
c010276d:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102772:	e9 fe f5 ff ff       	jmp    c0101d75 <__alltraps>

c0102777 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102777:	6a 00                	push   $0x0
  pushl $244
c0102779:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010277e:	e9 f2 f5 ff ff       	jmp    c0101d75 <__alltraps>

c0102783 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102783:	6a 00                	push   $0x0
  pushl $245
c0102785:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010278a:	e9 e6 f5 ff ff       	jmp    c0101d75 <__alltraps>

c010278f <vector246>:
.globl vector246
vector246:
  pushl $0
c010278f:	6a 00                	push   $0x0
  pushl $246
c0102791:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102796:	e9 da f5 ff ff       	jmp    c0101d75 <__alltraps>

c010279b <vector247>:
.globl vector247
vector247:
  pushl $0
c010279b:	6a 00                	push   $0x0
  pushl $247
c010279d:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027a2:	e9 ce f5 ff ff       	jmp    c0101d75 <__alltraps>

c01027a7 <vector248>:
.globl vector248
vector248:
  pushl $0
c01027a7:	6a 00                	push   $0x0
  pushl $248
c01027a9:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027ae:	e9 c2 f5 ff ff       	jmp    c0101d75 <__alltraps>

c01027b3 <vector249>:
.globl vector249
vector249:
  pushl $0
c01027b3:	6a 00                	push   $0x0
  pushl $249
c01027b5:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027ba:	e9 b6 f5 ff ff       	jmp    c0101d75 <__alltraps>

c01027bf <vector250>:
.globl vector250
vector250:
  pushl $0
c01027bf:	6a 00                	push   $0x0
  pushl $250
c01027c1:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027c6:	e9 aa f5 ff ff       	jmp    c0101d75 <__alltraps>

c01027cb <vector251>:
.globl vector251
vector251:
  pushl $0
c01027cb:	6a 00                	push   $0x0
  pushl $251
c01027cd:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027d2:	e9 9e f5 ff ff       	jmp    c0101d75 <__alltraps>

c01027d7 <vector252>:
.globl vector252
vector252:
  pushl $0
c01027d7:	6a 00                	push   $0x0
  pushl $252
c01027d9:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01027de:	e9 92 f5 ff ff       	jmp    c0101d75 <__alltraps>

c01027e3 <vector253>:
.globl vector253
vector253:
  pushl $0
c01027e3:	6a 00                	push   $0x0
  pushl $253
c01027e5:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01027ea:	e9 86 f5 ff ff       	jmp    c0101d75 <__alltraps>

c01027ef <vector254>:
.globl vector254
vector254:
  pushl $0
c01027ef:	6a 00                	push   $0x0
  pushl $254
c01027f1:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01027f6:	e9 7a f5 ff ff       	jmp    c0101d75 <__alltraps>

c01027fb <vector255>:
.globl vector255
vector255:
  pushl $0
c01027fb:	6a 00                	push   $0x0
  pushl $255
c01027fd:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102802:	e9 6e f5 ff ff       	jmp    c0101d75 <__alltraps>

c0102807 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102807:	55                   	push   %ebp
c0102808:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010280a:	8b 45 08             	mov    0x8(%ebp),%eax
c010280d:	8b 00                	mov    (%eax),%eax
}
c010280f:	5d                   	pop    %ebp
c0102810:	c3                   	ret    

c0102811 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102811:	55                   	push   %ebp
c0102812:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102814:	8b 45 08             	mov    0x8(%ebp),%eax
c0102817:	8b 55 0c             	mov    0xc(%ebp),%edx
c010281a:	89 10                	mov    %edx,(%eax)
}
c010281c:	5d                   	pop    %ebp
c010281d:	c3                   	ret    

c010281e <fixsize>:
#define UINT32_MASK(a)          (UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(UINT32_SHR_OR(a,1),2),4),8),16))    
//大于a的一个最小的2^k
#define UINT32_REMAINDER(a)     ((a)&(UINT32_MASK(a)>>1))
#define UINT32_ROUND_DOWN(a)    (UINT32_REMAINDER(a)?((a)-UINT32_REMAINDER(a)):(a))//小于a的最大的2^k

static unsigned fixsize(unsigned size) {
c010281e:	55                   	push   %ebp
c010281f:	89 e5                	mov    %esp,%ebp
  size |= size >> 1;
c0102821:	8b 45 08             	mov    0x8(%ebp),%eax
c0102824:	d1 e8                	shr    %eax
c0102826:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 2;
c0102829:	8b 45 08             	mov    0x8(%ebp),%eax
c010282c:	c1 e8 02             	shr    $0x2,%eax
c010282f:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 4;
c0102832:	8b 45 08             	mov    0x8(%ebp),%eax
c0102835:	c1 e8 04             	shr    $0x4,%eax
c0102838:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 8;
c010283b:	8b 45 08             	mov    0x8(%ebp),%eax
c010283e:	c1 e8 08             	shr    $0x8,%eax
c0102841:	09 45 08             	or     %eax,0x8(%ebp)
  size |= size >> 16;
c0102844:	8b 45 08             	mov    0x8(%ebp),%eax
c0102847:	c1 e8 10             	shr    $0x10,%eax
c010284a:	09 45 08             	or     %eax,0x8(%ebp)
  return size+1;
c010284d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102850:	83 c0 01             	add    $0x1,%eax
}
c0102853:	5d                   	pop    %ebp
c0102854:	c3                   	ret    

c0102855 <buddy_init>:

struct allocRecord rec[80000];//存放偏移量的数组，？？疑问：什么叫偏移量
int nr_block;//已分配的块数

static void buddy_init()
{
c0102855:	55                   	push   %ebp
c0102856:	89 e5                	mov    %esp,%ebp
c0102858:	83 ec 10             	sub    $0x10,%esp
c010285b:	c7 45 fc 80 7d 1b c0 	movl   $0xc01b7d80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102862:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102865:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102868:	89 50 04             	mov    %edx,0x4(%eax)
c010286b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010286e:	8b 50 04             	mov    0x4(%eax),%edx
c0102871:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102874:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free=0;
c0102876:	c7 05 88 7d 1b c0 00 	movl   $0x0,0xc01b7d88
c010287d:	00 00 00 
}
c0102880:	c9                   	leave  
c0102881:	c3                   	ret    

c0102882 <buddy2_new>:

//初始化二叉树上的节点，size为需要用buddy算法管理的内存
void buddy2_new( int size ) {
c0102882:	55                   	push   %ebp
c0102883:	89 e5                	mov    %esp,%ebp
c0102885:	83 ec 10             	sub    $0x10,%esp
  unsigned node_size;//当前节点所有的内存大小
  int i;
  nr_block=0;
c0102888:	c7 05 60 b9 11 c0 00 	movl   $0x0,0xc011b960
c010288f:	00 00 00 
  if (size < 1 || !IS_POWER_OF_2(size))//判断输入的size合法
c0102892:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102896:	7e 0d                	jle    c01028a5 <buddy2_new+0x23>
c0102898:	8b 45 08             	mov    0x8(%ebp),%eax
c010289b:	83 e8 01             	sub    $0x1,%eax
c010289e:	23 45 08             	and    0x8(%ebp),%eax
c01028a1:	85 c0                	test   %eax,%eax
c01028a3:	74 02                	je     c01028a7 <buddy2_new+0x25>
    return;
c01028a5:	eb 45                	jmp    c01028ec <buddy2_new+0x6a>

  root[0].size = size;//跟节点管理所有内存块
c01028a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01028aa:	a3 80 b9 11 c0       	mov    %eax,0xc011b980
  for (i = 1; i < 2 * size - 1; ++i){
c01028af:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
c01028b6:	eb 26                	jmp    c01028de <buddy2_new+0x5c>
      //初始化所有非根节点
      if (IS_POWER_OF_2(i+1)){
c01028b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01028bb:	83 c0 01             	add    $0x1,%eax
c01028be:	23 45 f8             	and    -0x8(%ebp),%eax
c01028c1:	85 c0                	test   %eax,%eax
c01028c3:	75 08                	jne    c01028cd <buddy2_new+0x4b>
          //如果是这层的第一个节点，做node_size的递减
          node_size /= 2;
c01028c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028c8:	d1 e8                	shr    %eax
c01028ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
      }
      root[i].longest = node_size;//说明这个节点管理的内存大小
c01028cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01028d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01028d3:	89 14 c5 84 b9 11 c0 	mov    %edx,-0x3fee467c(,%eax,8)
  nr_block=0;
  if (size < 1 || !IS_POWER_OF_2(size))//判断输入的size合法
    return;

  root[0].size = size;//跟节点管理所有内存块
  for (i = 1; i < 2 * size - 1; ++i){
c01028da:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c01028de:	8b 45 08             	mov    0x8(%ebp),%eax
c01028e1:	01 c0                	add    %eax,%eax
c01028e3:	83 e8 01             	sub    $0x1,%eax
c01028e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01028e9:	7f cd                	jg     c01028b8 <buddy2_new+0x36>
//   for (i = 0; i < 2 * size - 1; ++i) {
//     if (IS_POWER_OF_2(i+1))
//       node_size /= 2;
//     root[i].longest = node_size;
//   }
  return;
c01028eb:	90                   	nop
}
c01028ec:	c9                   	leave  
c01028ed:	c3                   	ret    

c01028ee <buddy_init_memmap>:

//初始化内存映射关系
static void
buddy_init_memmap(struct Page *base, size_t n)
{
c01028ee:	55                   	push   %ebp
c01028ef:	89 e5                	mov    %esp,%ebp
c01028f1:	56                   	push   %esi
c01028f2:	53                   	push   %ebx
c01028f3:	83 ec 40             	sub    $0x40,%esp
    assert(n>0);
c01028f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01028fa:	75 24                	jne    c0102920 <buddy_init_memmap+0x32>
c01028fc:	c7 44 24 0c 70 7a 10 	movl   $0xc0107a70,0xc(%esp)
c0102903:	c0 
c0102904:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c010290b:	c0 
c010290c:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0102913:	00 
c0102914:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c010291b:	e8 a6 e3 ff ff       	call   c0100cc6 <__panic>
    struct Page* p=base;
c0102920:	8b 45 08             	mov    0x8(%ebp),%eax
c0102923:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(;p!=base + n;p++)
c0102926:	e9 dc 00 00 00       	jmp    c0102a07 <buddy_init_memmap+0x119>
    {
        assert(PageReserved(p));
c010292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010292e:	83 c0 04             	add    $0x4,%eax
c0102931:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102938:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010293b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010293e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102941:	0f a3 10             	bt     %edx,(%eax)
c0102944:	19 c0                	sbb    %eax,%eax
c0102946:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102949:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010294d:	0f 95 c0             	setne  %al
c0102950:	0f b6 c0             	movzbl %al,%eax
c0102953:	85 c0                	test   %eax,%eax
c0102955:	75 24                	jne    c010297b <buddy_init_memmap+0x8d>
c0102957:	c7 44 24 0c 99 7a 10 	movl   $0xc0107a99,0xc(%esp)
c010295e:	c0 
c010295f:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c0102966:	c0 
c0102967:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c010296e:	00 
c010296f:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c0102976:	e8 4b e3 ff ff       	call   c0100cc6 <__panic>
        p->flags = 0;
c010297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010297e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 1;
c0102985:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102988:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
        set_page_ref(p, 0);   
c010298f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102996:	00 
c0102997:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010299a:	89 04 24             	mov    %eax,(%esp)
c010299d:	e8 6f fe ff ff       	call   c0102811 <set_page_ref>
        SetPageProperty(p);
c01029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029a5:	83 c0 04             	add    $0x4,%eax
c01029a8:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01029af:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01029b8:	0f ab 10             	bts    %edx,(%eax)
        list_add_before(&free_list,&(p->page_link));  //??疑问：为什么还要再放到双向链表里面  
c01029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029be:	83 c0 0c             	add    $0xc,%eax
c01029c1:	c7 45 d8 80 7d 1b c0 	movl   $0xc01b7d80,-0x28(%ebp)
c01029c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01029cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01029ce:	8b 00                	mov    (%eax),%eax
c01029d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01029d3:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01029d6:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01029d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01029dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01029e2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01029e5:	89 10                	mov    %edx,(%eax)
c01029e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01029ea:	8b 10                	mov    (%eax),%edx
c01029ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029ef:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01029f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01029f5:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01029f8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01029fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01029fe:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a01:	89 10                	mov    %edx,(%eax)
static void
buddy_init_memmap(struct Page *base, size_t n)
{
    assert(n>0);
    struct Page* p=base;
    for(;p!=base + n;p++)
c0102a03:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a07:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a0a:	89 d0                	mov    %edx,%eax
c0102a0c:	c1 e0 02             	shl    $0x2,%eax
c0102a0f:	01 d0                	add    %edx,%eax
c0102a11:	c1 e0 02             	shl    $0x2,%eax
c0102a14:	89 c2                	mov    %eax,%edx
c0102a16:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a19:	01 d0                	add    %edx,%eax
c0102a1b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a1e:	0f 85 07 ff ff ff    	jne    c010292b <buddy_init_memmap+0x3d>
        p->property = 1;
        set_page_ref(p, 0);   
        SetPageProperty(p);
        list_add_before(&free_list,&(p->page_link));  //??疑问：为什么还要再放到双向链表里面  
    }
    nr_free += n;//共n页空闲页
c0102a24:	8b 15 88 7d 1b c0    	mov    0xc01b7d88,%edx
c0102a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a2d:	01 d0                	add    %edx,%eax
c0102a2f:	a3 88 7d 1b c0       	mov    %eax,0xc01b7d88
    //从这里开始不一样，使用buddy分配算法
    int allocpages=UINT32_ROUND_DOWN(n);//需要管理多少页（只能管理2的整数次幂页）
c0102a34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a37:	d1 e8                	shr    %eax
c0102a39:	0b 45 0c             	or     0xc(%ebp),%eax
c0102a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a3f:	d1 ea                	shr    %edx
c0102a41:	0b 55 0c             	or     0xc(%ebp),%edx
c0102a44:	c1 ea 02             	shr    $0x2,%edx
c0102a47:	09 d0                	or     %edx,%eax
c0102a49:	89 c1                	mov    %eax,%ecx
c0102a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a4e:	d1 e8                	shr    %eax
c0102a50:	0b 45 0c             	or     0xc(%ebp),%eax
c0102a53:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a56:	d1 ea                	shr    %edx
c0102a58:	0b 55 0c             	or     0xc(%ebp),%edx
c0102a5b:	c1 ea 02             	shr    $0x2,%edx
c0102a5e:	09 d0                	or     %edx,%eax
c0102a60:	c1 e8 04             	shr    $0x4,%eax
c0102a63:	09 c1                	or     %eax,%ecx
c0102a65:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a68:	d1 e8                	shr    %eax
c0102a6a:	0b 45 0c             	or     0xc(%ebp),%eax
c0102a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a70:	d1 ea                	shr    %edx
c0102a72:	0b 55 0c             	or     0xc(%ebp),%edx
c0102a75:	c1 ea 02             	shr    $0x2,%edx
c0102a78:	09 d0                	or     %edx,%eax
c0102a7a:	89 c3                	mov    %eax,%ebx
c0102a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a7f:	d1 e8                	shr    %eax
c0102a81:	0b 45 0c             	or     0xc(%ebp),%eax
c0102a84:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a87:	d1 ea                	shr    %edx
c0102a89:	0b 55 0c             	or     0xc(%ebp),%edx
c0102a8c:	c1 ea 02             	shr    $0x2,%edx
c0102a8f:	09 d0                	or     %edx,%eax
c0102a91:	c1 e8 04             	shr    $0x4,%eax
c0102a94:	09 d8                	or     %ebx,%eax
c0102a96:	c1 e8 08             	shr    $0x8,%eax
c0102a99:	09 c1                	or     %eax,%ecx
c0102a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a9e:	d1 e8                	shr    %eax
c0102aa0:	0b 45 0c             	or     0xc(%ebp),%eax
c0102aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102aa6:	d1 ea                	shr    %edx
c0102aa8:	0b 55 0c             	or     0xc(%ebp),%edx
c0102aab:	c1 ea 02             	shr    $0x2,%edx
c0102aae:	09 d0                	or     %edx,%eax
c0102ab0:	89 c3                	mov    %eax,%ebx
c0102ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102ab5:	d1 e8                	shr    %eax
c0102ab7:	0b 45 0c             	or     0xc(%ebp),%eax
c0102aba:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102abd:	d1 ea                	shr    %edx
c0102abf:	0b 55 0c             	or     0xc(%ebp),%edx
c0102ac2:	c1 ea 02             	shr    $0x2,%edx
c0102ac5:	09 d0                	or     %edx,%eax
c0102ac7:	c1 e8 04             	shr    $0x4,%eax
c0102aca:	09 c3                	or     %eax,%ebx
c0102acc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102acf:	d1 e8                	shr    %eax
c0102ad1:	0b 45 0c             	or     0xc(%ebp),%eax
c0102ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ad7:	d1 ea                	shr    %edx
c0102ad9:	0b 55 0c             	or     0xc(%ebp),%edx
c0102adc:	c1 ea 02             	shr    $0x2,%edx
c0102adf:	09 d0                	or     %edx,%eax
c0102ae1:	89 c6                	mov    %eax,%esi
c0102ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102ae6:	d1 e8                	shr    %eax
c0102ae8:	0b 45 0c             	or     0xc(%ebp),%eax
c0102aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102aee:	d1 ea                	shr    %edx
c0102af0:	0b 55 0c             	or     0xc(%ebp),%edx
c0102af3:	c1 ea 02             	shr    $0x2,%edx
c0102af6:	09 d0                	or     %edx,%eax
c0102af8:	c1 e8 04             	shr    $0x4,%eax
c0102afb:	09 f0                	or     %esi,%eax
c0102afd:	c1 e8 08             	shr    $0x8,%eax
c0102b00:	09 d8                	or     %ebx,%eax
c0102b02:	c1 e8 10             	shr    $0x10,%eax
c0102b05:	09 c8                	or     %ecx,%eax
c0102b07:	d1 e8                	shr    %eax
c0102b09:	23 45 0c             	and    0xc(%ebp),%eax
c0102b0c:	85 c0                	test   %eax,%eax
c0102b0e:	0f 84 dc 00 00 00    	je     c0102bf0 <buddy_init_memmap+0x302>
c0102b14:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b17:	d1 e8                	shr    %eax
c0102b19:	0b 45 0c             	or     0xc(%ebp),%eax
c0102b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b1f:	d1 ea                	shr    %edx
c0102b21:	0b 55 0c             	or     0xc(%ebp),%edx
c0102b24:	c1 ea 02             	shr    $0x2,%edx
c0102b27:	09 d0                	or     %edx,%eax
c0102b29:	89 c1                	mov    %eax,%ecx
c0102b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b2e:	d1 e8                	shr    %eax
c0102b30:	0b 45 0c             	or     0xc(%ebp),%eax
c0102b33:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b36:	d1 ea                	shr    %edx
c0102b38:	0b 55 0c             	or     0xc(%ebp),%edx
c0102b3b:	c1 ea 02             	shr    $0x2,%edx
c0102b3e:	09 d0                	or     %edx,%eax
c0102b40:	c1 e8 04             	shr    $0x4,%eax
c0102b43:	09 c1                	or     %eax,%ecx
c0102b45:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b48:	d1 e8                	shr    %eax
c0102b4a:	0b 45 0c             	or     0xc(%ebp),%eax
c0102b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b50:	d1 ea                	shr    %edx
c0102b52:	0b 55 0c             	or     0xc(%ebp),%edx
c0102b55:	c1 ea 02             	shr    $0x2,%edx
c0102b58:	09 d0                	or     %edx,%eax
c0102b5a:	89 c3                	mov    %eax,%ebx
c0102b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b5f:	d1 e8                	shr    %eax
c0102b61:	0b 45 0c             	or     0xc(%ebp),%eax
c0102b64:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b67:	d1 ea                	shr    %edx
c0102b69:	0b 55 0c             	or     0xc(%ebp),%edx
c0102b6c:	c1 ea 02             	shr    $0x2,%edx
c0102b6f:	09 d0                	or     %edx,%eax
c0102b71:	c1 e8 04             	shr    $0x4,%eax
c0102b74:	09 d8                	or     %ebx,%eax
c0102b76:	c1 e8 08             	shr    $0x8,%eax
c0102b79:	09 c1                	or     %eax,%ecx
c0102b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b7e:	d1 e8                	shr    %eax
c0102b80:	0b 45 0c             	or     0xc(%ebp),%eax
c0102b83:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b86:	d1 ea                	shr    %edx
c0102b88:	0b 55 0c             	or     0xc(%ebp),%edx
c0102b8b:	c1 ea 02             	shr    $0x2,%edx
c0102b8e:	09 d0                	or     %edx,%eax
c0102b90:	89 c3                	mov    %eax,%ebx
c0102b92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b95:	d1 e8                	shr    %eax
c0102b97:	0b 45 0c             	or     0xc(%ebp),%eax
c0102b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b9d:	d1 ea                	shr    %edx
c0102b9f:	0b 55 0c             	or     0xc(%ebp),%edx
c0102ba2:	c1 ea 02             	shr    $0x2,%edx
c0102ba5:	09 d0                	or     %edx,%eax
c0102ba7:	c1 e8 04             	shr    $0x4,%eax
c0102baa:	09 c3                	or     %eax,%ebx
c0102bac:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102baf:	d1 e8                	shr    %eax
c0102bb1:	0b 45 0c             	or     0xc(%ebp),%eax
c0102bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102bb7:	d1 ea                	shr    %edx
c0102bb9:	0b 55 0c             	or     0xc(%ebp),%edx
c0102bbc:	c1 ea 02             	shr    $0x2,%edx
c0102bbf:	09 d0                	or     %edx,%eax
c0102bc1:	89 c6                	mov    %eax,%esi
c0102bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102bc6:	d1 e8                	shr    %eax
c0102bc8:	0b 45 0c             	or     0xc(%ebp),%eax
c0102bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102bce:	d1 ea                	shr    %edx
c0102bd0:	0b 55 0c             	or     0xc(%ebp),%edx
c0102bd3:	c1 ea 02             	shr    $0x2,%edx
c0102bd6:	09 d0                	or     %edx,%eax
c0102bd8:	c1 e8 04             	shr    $0x4,%eax
c0102bdb:	09 f0                	or     %esi,%eax
c0102bdd:	c1 e8 08             	shr    $0x8,%eax
c0102be0:	09 d8                	or     %ebx,%eax
c0102be2:	c1 e8 10             	shr    $0x10,%eax
c0102be5:	09 c8                	or     %ecx,%eax
c0102be7:	d1 e8                	shr    %eax
c0102be9:	f7 d0                	not    %eax
c0102beb:	23 45 0c             	and    0xc(%ebp),%eax
c0102bee:	eb 03                	jmp    c0102bf3 <buddy_init_memmap+0x305>
c0102bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    buddy2_new(allocpages);//给这n页建树
c0102bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bf9:	89 04 24             	mov    %eax,(%esp)
c0102bfc:	e8 81 fc ff ff       	call   c0102882 <buddy2_new>
}
c0102c01:	83 c4 40             	add    $0x40,%esp
c0102c04:	5b                   	pop    %ebx
c0102c05:	5e                   	pop    %esi
c0102c06:	5d                   	pop    %ebp
c0102c07:	c3                   	ret    

c0102c08 <buddy2_alloc>:
//内存分配
int buddy2_alloc(struct buddy2* self, int size) {
c0102c08:	55                   	push   %ebp
c0102c09:	89 e5                	mov    %esp,%ebp
c0102c0b:	53                   	push   %ebx
c0102c0c:	83 ec 14             	sub    $0x14,%esp
  unsigned index = 0;//节点的标号
c0102c0f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  unsigned node_size;
  unsigned offset = 0;
c0102c16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  if (self==NULL)//无法分配
c0102c1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102c21:	75 0a                	jne    c0102c2d <buddy2_alloc+0x25>
    return -1;
c0102c23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0102c28:	e9 7a 01 00 00       	jmp    c0102da7 <buddy2_alloc+0x19f>

  if (size <= 0)//分配不合理
c0102c2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c31:	7f 09                	jg     c0102c3c <buddy2_alloc+0x34>
    size = 1;
c0102c33:	c7 45 0c 01 00 00 00 	movl   $0x1,0xc(%ebp)
c0102c3a:	eb 1b                	jmp    c0102c57 <buddy2_alloc+0x4f>
  else if (!IS_POWER_OF_2(size))//不为2的幂时，取比size更大的2的n次幂作为待分配的size
c0102c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c3f:	83 e8 01             	sub    $0x1,%eax
c0102c42:	23 45 0c             	and    0xc(%ebp),%eax
c0102c45:	85 c0                	test   %eax,%eax
c0102c47:	74 0e                	je     c0102c57 <buddy2_alloc+0x4f>
    size = fixsize(size);
c0102c49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c4c:	89 04 24             	mov    %eax,(%esp)
c0102c4f:	e8 ca fb ff ff       	call   c010281e <fixsize>
c0102c54:	89 45 0c             	mov    %eax,0xc(%ebp)

  if (self[index].longest < size)//可分配内存不足（根节点就没有这么多内存页，直接报错返回）
c0102c57:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102c5a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0102c61:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c64:	01 d0                	add    %edx,%eax
c0102c66:	8b 50 04             	mov    0x4(%eax),%edx
c0102c69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c6c:	39 c2                	cmp    %eax,%edx
c0102c6e:	73 0a                	jae    c0102c7a <buddy2_alloc+0x72>
    return -1;
c0102c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0102c75:	e9 2d 01 00 00       	jmp    c0102da7 <buddy2_alloc+0x19f>

  for(node_size = self->size; node_size != size; node_size /= 2 ) {//从根节点开始，逐层找到合适的页
c0102c7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c7d:	8b 00                	mov    (%eax),%eax
c0102c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c82:	e9 91 00 00 00       	jmp    c0102d18 <buddy2_alloc+0x110>
    //找到合适的那层，分配原则：左右都可以，则找longest小的(即这一块已经七零八落的）；只有一个可以，则就是那个；
    //找到要插入的节点的index
    if (self[LEFT_LEAF(index)].longest >= size)
c0102c87:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102c8a:	c1 e0 04             	shl    $0x4,%eax
c0102c8d:	8d 50 08             	lea    0x8(%eax),%edx
c0102c90:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c93:	01 d0                	add    %edx,%eax
c0102c95:	8b 50 04             	mov    0x4(%eax),%edx
c0102c98:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c9b:	39 c2                	cmp    %eax,%edx
c0102c9d:	72 66                	jb     c0102d05 <buddy2_alloc+0xfd>
    {
       if(self[RIGHT_LEAF(index)].longest>=size)
c0102c9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102ca2:	83 c0 01             	add    $0x1,%eax
c0102ca5:	c1 e0 04             	shl    $0x4,%eax
c0102ca8:	89 c2                	mov    %eax,%edx
c0102caa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cad:	01 d0                	add    %edx,%eax
c0102caf:	8b 50 04             	mov    0x4(%eax),%edx
c0102cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102cb5:	39 c2                	cmp    %eax,%edx
c0102cb7:	72 3f                	jb     c0102cf8 <buddy2_alloc+0xf0>
        {
           index=self[LEFT_LEAF(index)].longest <= self[RIGHT_LEAF(index)].longest? LEFT_LEAF(index):RIGHT_LEAF(index);
c0102cb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102cbc:	c1 e0 04             	shl    $0x4,%eax
c0102cbf:	8d 50 08             	lea    0x8(%eax),%edx
c0102cc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cc5:	01 d0                	add    %edx,%eax
c0102cc7:	8b 50 04             	mov    0x4(%eax),%edx
c0102cca:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102ccd:	83 c0 01             	add    $0x1,%eax
c0102cd0:	c1 e0 04             	shl    $0x4,%eax
c0102cd3:	89 c1                	mov    %eax,%ecx
c0102cd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd8:	01 c8                	add    %ecx,%eax
c0102cda:	8b 40 04             	mov    0x4(%eax),%eax
c0102cdd:	39 c2                	cmp    %eax,%edx
c0102cdf:	77 0a                	ja     c0102ceb <buddy2_alloc+0xe3>
c0102ce1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102ce4:	01 c0                	add    %eax,%eax
c0102ce6:	83 c0 01             	add    $0x1,%eax
c0102ce9:	eb 08                	jmp    c0102cf3 <buddy2_alloc+0xeb>
c0102ceb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102cee:	83 c0 01             	add    $0x1,%eax
c0102cf1:	01 c0                	add    %eax,%eax
c0102cf3:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0102cf6:	eb 18                	jmp    c0102d10 <buddy2_alloc+0x108>
         //找到两个相符合的节点中内存较小的结点
        }
       else
       {
         index=LEFT_LEAF(index);
c0102cf8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102cfb:	01 c0                	add    %eax,%eax
c0102cfd:	83 c0 01             	add    $0x1,%eax
c0102d00:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0102d03:	eb 0b                	jmp    c0102d10 <buddy2_alloc+0x108>
       }  
    }
    else
      index = RIGHT_LEAF(index);
c0102d05:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102d08:	83 c0 01             	add    $0x1,%eax
c0102d0b:	01 c0                	add    %eax,%eax
c0102d0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    size = fixsize(size);

  if (self[index].longest < size)//可分配内存不足（根节点就没有这么多内存页，直接报错返回）
    return -1;

  for(node_size = self->size; node_size != size; node_size /= 2 ) {//从根节点开始，逐层找到合适的页
c0102d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d13:	d1 e8                	shr    %eax
c0102d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d18:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d1b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d1e:	0f 85 63 ff ff ff    	jne    c0102c87 <buddy2_alloc+0x7f>
    }
    else
      index = RIGHT_LEAF(index);
  }

  self[index].longest = 0;//标记节点为已使用
c0102d24:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102d27:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0102d2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d31:	01 d0                	add    %edx,%eax
c0102d33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  offset = (index + 1) * node_size - self->size;//计算在buffer的实际起始地址
c0102d3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102d3d:	83 c0 01             	add    $0x1,%eax
c0102d40:	0f af 45 f4          	imul   -0xc(%ebp),%eax
c0102d44:	89 c2                	mov    %eax,%edx
c0102d46:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d49:	8b 00                	mov    (%eax),%eax
c0102d4b:	29 c2                	sub    %eax,%edx
c0102d4d:	89 d0                	mov    %edx,%eax
c0102d4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while (index) {//要对他的父节点页进行修改，直至根节点
c0102d52:	eb 4a                	jmp    c0102d9e <buddy2_alloc+0x196>
    index = PARENT(index);
c0102d54:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102d57:	83 c0 01             	add    $0x1,%eax
c0102d5a:	d1 e8                	shr    %eax
c0102d5c:	83 e8 01             	sub    $0x1,%eax
c0102d5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    self[index].longest = 
c0102d62:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102d65:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0102d6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d6f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
      MAX(self[LEFT_LEAF(index)].longest, self[RIGHT_LEAF(index)].longest);
c0102d72:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102d75:	83 c0 01             	add    $0x1,%eax
c0102d78:	c1 e0 04             	shl    $0x4,%eax
c0102d7b:	89 c2                	mov    %eax,%edx
c0102d7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d80:	01 d0                	add    %edx,%eax
c0102d82:	8b 50 04             	mov    0x4(%eax),%edx
c0102d85:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102d88:	c1 e0 04             	shl    $0x4,%eax
c0102d8b:	8d 58 08             	lea    0x8(%eax),%ebx
c0102d8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d91:	01 d8                	add    %ebx,%eax
c0102d93:	8b 40 04             	mov    0x4(%eax),%eax
c0102d96:	39 c2                	cmp    %eax,%edx
c0102d98:	0f 43 c2             	cmovae %edx,%eax

  self[index].longest = 0;//标记节点为已使用
  offset = (index + 1) * node_size - self->size;//计算在buffer的实际起始地址
  while (index) {//要对他的父节点页进行修改，直至根节点
    index = PARENT(index);
    self[index].longest = 
c0102d9b:	89 41 04             	mov    %eax,0x4(%ecx)
      index = RIGHT_LEAF(index);
  }

  self[index].longest = 0;//标记节点为已使用
  offset = (index + 1) * node_size - self->size;//计算在buffer的实际起始地址
  while (index) {//要对他的父节点页进行修改，直至根节点
c0102d9e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0102da2:	75 b0                	jne    c0102d54 <buddy2_alloc+0x14c>
    self[index].longest = 
      MAX(self[LEFT_LEAF(index)].longest, self[RIGHT_LEAF(index)].longest);
      //父节点longest等于左右的最大的
  }
//向上刷新，修改先祖结点的数值
  return offset;
c0102da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102da7:	83 c4 14             	add    $0x14,%esp
c0102daa:	5b                   	pop    %ebx
c0102dab:	5d                   	pop    %ebp
c0102dac:	c3                   	ret    

c0102dad <buddy_alloc_pages>:

static struct Page*
buddy_alloc_pages(size_t n){//采用buddy算法给出一个新页
c0102dad:	55                   	push   %ebp
c0102dae:	89 e5                	mov    %esp,%ebp
c0102db0:	53                   	push   %ebx
c0102db1:	83 ec 44             	sub    $0x44,%esp
  assert(n>0);
c0102db4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102db8:	75 24                	jne    c0102dde <buddy_alloc_pages+0x31>
c0102dba:	c7 44 24 0c 70 7a 10 	movl   $0xc0107a70,0xc(%esp)
c0102dc1:	c0 
c0102dc2:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c0102dc9:	c0 
c0102dca:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0102dd1:	00 
c0102dd2:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c0102dd9:	e8 e8 de ff ff       	call   c0100cc6 <__panic>
  if(n>nr_free)//判断要分配的页大小n的数值合理
c0102dde:	a1 88 7d 1b c0       	mov    0xc01b7d88,%eax
c0102de3:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102de6:	73 0a                	jae    c0102df2 <buddy_alloc_pages+0x45>
   return NULL;
c0102de8:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ded:	e9 4c 01 00 00       	jmp    c0102f3e <buddy_alloc_pages+0x191>
  struct Page* page=NULL;
c0102df2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  struct Page* p;
  list_entry_t *le=&free_list,*len;
c0102df9:	c7 45 f4 80 7d 1b c0 	movl   $0xc01b7d80,-0xc(%ebp)
  rec[nr_block].offset=buddy2_alloc(root,n);//记录偏移量,所谓偏移，就是这个块被存放在了树的哪个节点
c0102e00:	8b 1d 60 b9 11 c0    	mov    0xc011b960,%ebx
c0102e06:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102e0d:	c7 04 24 80 b9 11 c0 	movl   $0xc011b980,(%esp)
c0102e14:	e8 ef fd ff ff       	call   c0102c08 <buddy2_alloc>
c0102e19:	89 c2                	mov    %eax,%edx
c0102e1b:	89 d8                	mov    %ebx,%eax
c0102e1d:	01 c0                	add    %eax,%eax
c0102e1f:	01 d8                	add    %ebx,%eax
c0102e21:	c1 e0 02             	shl    $0x2,%eax
c0102e24:	05 a0 7d 1b c0       	add    $0xc01b7da0,%eax
c0102e29:	89 50 04             	mov    %edx,0x4(%eax)
  int i;
  for(i=0;i<rec[nr_block].offset+1;i++)//找到这个页
c0102e2c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102e33:	eb 13                	jmp    c0102e48 <buddy_alloc_pages+0x9b>
c0102e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e38:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102e3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102e3e:	8b 40 04             	mov    0x4(%eax),%eax
    le=list_next(le);
c0102e41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct Page* page=NULL;
  struct Page* p;
  list_entry_t *le=&free_list,*len;
  rec[nr_block].offset=buddy2_alloc(root,n);//记录偏移量,所谓偏移，就是这个块被存放在了树的哪个节点
  int i;
  for(i=0;i<rec[nr_block].offset+1;i++)//找到这个页
c0102e44:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0102e48:	8b 15 60 b9 11 c0    	mov    0xc011b960,%edx
c0102e4e:	89 d0                	mov    %edx,%eax
c0102e50:	01 c0                	add    %eax,%eax
c0102e52:	01 d0                	add    %edx,%eax
c0102e54:	c1 e0 02             	shl    $0x2,%eax
c0102e57:	05 a0 7d 1b c0       	add    $0xc01b7da0,%eax
c0102e5c:	8b 40 04             	mov    0x4(%eax),%eax
c0102e5f:	83 c0 01             	add    $0x1,%eax
c0102e62:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102e65:	7f ce                	jg     c0102e35 <buddy_alloc_pages+0x88>
    le=list_next(le);
  page=le2page(le,page_link);//list entry->page
c0102e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e6a:	83 e8 0c             	sub    $0xc,%eax
c0102e6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int allocpages;
  if(!IS_POWER_OF_2(n))
c0102e70:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e73:	83 e8 01             	sub    $0x1,%eax
c0102e76:	23 45 08             	and    0x8(%ebp),%eax
c0102e79:	85 c0                	test   %eax,%eax
c0102e7b:	74 10                	je     c0102e8d <buddy_alloc_pages+0xe0>
   allocpages=fixsize(n);
c0102e7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e80:	89 04 24             	mov    %eax,(%esp)
c0102e83:	e8 96 f9 ff ff       	call   c010281e <fixsize>
c0102e88:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e8b:	eb 06                	jmp    c0102e93 <buddy_alloc_pages+0xe6>
  else
  {
     allocpages=n;
c0102e8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }
  //根据需求n得到块大小
  rec[nr_block].base=page;//记录分配块首页
c0102e93:	8b 15 60 b9 11 c0    	mov    0xc011b960,%edx
c0102e99:	89 d0                	mov    %edx,%eax
c0102e9b:	01 c0                	add    %eax,%eax
c0102e9d:	01 d0                	add    %edx,%eax
c0102e9f:	c1 e0 02             	shl    $0x2,%eax
c0102ea2:	8d 90 a0 7d 1b c0    	lea    -0x3fe48260(%eax),%edx
c0102ea8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102eab:	89 02                	mov    %eax,(%edx)
  rec[nr_block].nr=allocpages;//记录分配的页数
c0102ead:	8b 15 60 b9 11 c0    	mov    0xc011b960,%edx
c0102eb3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0102eb6:	89 d0                	mov    %edx,%eax
c0102eb8:	01 c0                	add    %eax,%eax
c0102eba:	01 d0                	add    %edx,%eax
c0102ebc:	c1 e0 02             	shl    $0x2,%eax
c0102ebf:	05 a0 7d 1b c0       	add    $0xc01b7da0,%eax
c0102ec4:	89 48 08             	mov    %ecx,0x8(%eax)
  nr_block++;//管理的空块数+1
c0102ec7:	a1 60 b9 11 c0       	mov    0xc011b960,%eax
c0102ecc:	83 c0 01             	add    $0x1,%eax
c0102ecf:	a3 60 b9 11 c0       	mov    %eax,0xc011b960
  for(i=0;i<allocpages;i++)
c0102ed4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102edb:	eb 3b                	jmp    c0102f18 <buddy_alloc_pages+0x16b>
c0102edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ee0:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102ee3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102ee6:	8b 40 04             	mov    0x4(%eax),%eax
  {
    //清零被分配页上的property
    len=list_next(le);
c0102ee9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    p=le2page(le,page_link);
c0102eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eef:	83 e8 0c             	sub    $0xc,%eax
c0102ef2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    ClearPageProperty(p);
c0102ef5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ef8:	83 c0 04             	add    $0x4,%eax
c0102efb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102f02:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f05:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f08:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f0b:	0f b3 10             	btr    %edx,(%eax)
    le=len;
c0102f0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  //根据需求n得到块大小
  rec[nr_block].base=page;//记录分配块首页
  rec[nr_block].nr=allocpages;//记录分配的页数
  nr_block++;//管理的空块数+1
  for(i=0;i<allocpages;i++)
c0102f14:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0102f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f1b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102f1e:	7c bd                	jl     c0102edd <buddy_alloc_pages+0x130>
    len=list_next(le);
    p=le2page(le,page_link);
    ClearPageProperty(p);
    le=len;
  }//修改每一页的状态
  nr_free-=allocpages;//减去已被分配的页数
c0102f20:	8b 15 88 7d 1b c0    	mov    0xc01b7d88,%edx
c0102f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f29:	29 c2                	sub    %eax,%edx
c0102f2b:	89 d0                	mov    %edx,%eax
c0102f2d:	a3 88 7d 1b c0       	mov    %eax,0xc01b7d88
  page->property=n;//base页的property = n
c0102f32:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102f35:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f38:	89 50 08             	mov    %edx,0x8(%eax)
  return page;//返回base页
c0102f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
c0102f3e:	83 c4 44             	add    $0x44,%esp
c0102f41:	5b                   	pop    %ebx
c0102f42:	5d                   	pop    %ebp
c0102f43:	c3                   	ret    

c0102f44 <buddy_free_pages>:

void buddy_free_pages(struct Page* base, size_t n) {
c0102f44:	55                   	push   %ebp
c0102f45:	89 e5                	mov    %esp,%ebp
c0102f47:	83 ec 58             	sub    $0x58,%esp
    //利用buddy算法释放页
  unsigned node_size, index = 0;
c0102f4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  unsigned left_longest, right_longest;
  struct buddy2* self=root;
c0102f51:	c7 45 e0 80 b9 11 c0 	movl   $0xc011b980,-0x20(%ebp)
c0102f58:	c7 45 c8 80 7d 1b c0 	movl   $0xc01b7d80,-0x38(%ebp)
c0102f5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f62:	8b 40 04             	mov    0x4(%eax),%eax
  
  list_entry_t *le=list_next(&free_list);
c0102f65:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i=0;
c0102f68:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  for(i=0;i<nr_block;i++)//找到块所对应的base页
c0102f6f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0102f76:	eb 1e                	jmp    c0102f96 <buddy_free_pages+0x52>
  {
    if(rec[i].base==base)
c0102f78:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102f7b:	89 d0                	mov    %edx,%eax
c0102f7d:	01 c0                	add    %eax,%eax
c0102f7f:	01 d0                	add    %edx,%eax
c0102f81:	c1 e0 02             	shl    $0x2,%eax
c0102f84:	05 a0 7d 1b c0       	add    $0xc01b7da0,%eax
c0102f89:	8b 00                	mov    (%eax),%eax
c0102f8b:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102f8e:	75 02                	jne    c0102f92 <buddy_free_pages+0x4e>
     break;
c0102f90:	eb 0e                	jmp    c0102fa0 <buddy_free_pages+0x5c>
  unsigned left_longest, right_longest;
  struct buddy2* self=root;
  
  list_entry_t *le=list_next(&free_list);
  int i=0;
  for(i=0;i<nr_block;i++)//找到块所对应的base页
c0102f92:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0102f96:	a1 60 b9 11 c0       	mov    0xc011b960,%eax
c0102f9b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0102f9e:	7c d8                	jl     c0102f78 <buddy_free_pages+0x34>
  {
    if(rec[i].base==base)
     break;
  }
  int offset=rec[i].offset;
c0102fa0:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102fa3:	89 d0                	mov    %edx,%eax
c0102fa5:	01 c0                	add    %eax,%eax
c0102fa7:	01 d0                	add    %edx,%eax
c0102fa9:	c1 e0 02             	shl    $0x2,%eax
c0102fac:	05 a0 7d 1b c0       	add    $0xc01b7da0,%eax
c0102fb1:	8b 40 04             	mov    0x4(%eax),%eax
c0102fb4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int pos=i;//暂存i
c0102fb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102fba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  i=0;
c0102fbd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  while(i<offset)
c0102fc4:	eb 13                	jmp    c0102fd9 <buddy_free_pages+0x95>
c0102fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fc9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0102fcc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102fcf:	8b 40 04             	mov    0x4(%eax),%eax
  {
    le=list_next(le);//找到起始页
c0102fd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    i++;
c0102fd5:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
     break;
  }
  int offset=rec[i].offset;
  int pos=i;//暂存i
  i=0;
  while(i<offset)
c0102fd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102fdc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102fdf:	7c e5                	jl     c0102fc6 <buddy_free_pages+0x82>
  {
    le=list_next(le);//找到起始页
    i++;
  }
  int freepages;//要释放的页的数量
  if(!IS_POWER_OF_2(n))
c0102fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102fe4:	83 e8 01             	sub    $0x1,%eax
c0102fe7:	23 45 0c             	and    0xc(%ebp),%eax
c0102fea:	85 c0                	test   %eax,%eax
c0102fec:	74 10                	je     c0102ffe <buddy_free_pages+0xba>
   freepages=fixsize(n);
c0102fee:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102ff1:	89 04 24             	mov    %eax,(%esp)
c0102ff4:	e8 25 f8 ff ff       	call   c010281e <fixsize>
c0102ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0102ffc:	eb 06                	jmp    c0103004 <buddy_free_pages+0xc0>
  else
  {
     freepages=n;
c0102ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103001:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  }
  assert(self && offset >= 0 && offset < self->size);//是否合法
c0103004:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103008:	74 12                	je     c010301c <buddy_free_pages+0xd8>
c010300a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010300e:	78 0c                	js     c010301c <buddy_free_pages+0xd8>
c0103010:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103013:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103016:	8b 00                	mov    (%eax),%eax
c0103018:	39 c2                	cmp    %eax,%edx
c010301a:	72 24                	jb     c0103040 <buddy_free_pages+0xfc>
c010301c:	c7 44 24 0c ac 7a 10 	movl   $0xc0107aac,0xc(%esp)
c0103023:	c0 
c0103024:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c010302b:	c0 
c010302c:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103033:	00 
c0103034:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c010303b:	e8 86 dc ff ff       	call   c0100cc6 <__panic>
  node_size = 1;
c0103040:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  //在分配的时候是这样的：
//   self[index].longest = 0;//标记节点为已使用
//   offset = (index + 1) * node_size - self->size;
//改动：不应该省略1
  index = (offset + self->size)/node_size - 1;//与分配时逆向
c0103047:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010304a:	8b 10                	mov    (%eax),%edx
c010304c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010304f:	01 d0                	add    %edx,%eax
c0103051:	ba 00 00 00 00       	mov    $0x0,%edx
c0103056:	f7 75 f4             	divl   -0xc(%ebp)
c0103059:	83 e8 01             	sub    $0x1,%eax
c010305c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  nr_free+=freepages;//更新空闲页的数量
c010305f:	8b 15 88 7d 1b c0    	mov    0xc01b7d88,%edx
c0103065:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103068:	01 d0                	add    %edx,%eax
c010306a:	a3 88 7d 1b c0       	mov    %eax,0xc01b7d88
  struct Page* p;
  self[index].longest = freepages;//当前页的关卡恢复
c010306f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103072:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0103079:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010307c:	01 c2                	add    %eax,%edx
c010307e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103081:	89 42 04             	mov    %eax,0x4(%edx)
  for(i=0;i<freepages;i++)//回收已分配的页，设置property
c0103084:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010308b:	eb 49                	jmp    c01030d6 <buddy_free_pages+0x192>
  {
     p=le2page(le,page_link);
c010308d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103090:	83 e8 0c             	sub    $0xc,%eax
c0103093:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     p->flags=0;
c0103096:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103099:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
     p->property=1;
c01030a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01030a3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
     SetPageProperty(p);
c01030aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01030ad:	83 c0 04             	add    $0x4,%eax
c01030b0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01030b7:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01030ba:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01030bd:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01030c0:	0f ab 10             	bts    %edx,(%eax)
c01030c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030c6:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01030c9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01030cc:	8b 40 04             	mov    0x4(%eax),%eax
     le=list_next(le);
c01030cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
//改动：不应该省略1
  index = (offset + self->size)/node_size - 1;//与分配时逆向
  nr_free+=freepages;//更新空闲页的数量
  struct Page* p;
  self[index].longest = freepages;//当前页的关卡恢复
  for(i=0;i<freepages;i++)//回收已分配的页，设置property
c01030d2:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c01030d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030d9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
c01030dc:	7c af                	jl     c010308d <buddy_free_pages+0x149>
     p->flags=0;
     p->property=1;
     SetPageProperty(p);
     le=list_next(le);
  }
  while (index) {//向上合并，修改先祖节点的记录值
c01030de:	eb 7b                	jmp    c010315b <buddy_free_pages+0x217>
    index = PARENT(index);
c01030e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030e3:	83 c0 01             	add    $0x1,%eax
c01030e6:	d1 e8                	shr    %eax
c01030e8:	83 e8 01             	sub    $0x1,%eax
c01030eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    node_size *= 2;//node_size表示在这一层的节点应该满的数
c01030ee:	d1 65 f4             	shll   -0xc(%ebp)

    left_longest = self[LEFT_LEAF(index)].longest;
c01030f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030f4:	c1 e0 04             	shl    $0x4,%eax
c01030f7:	8d 50 08             	lea    0x8(%eax),%edx
c01030fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030fd:	01 d0                	add    %edx,%eax
c01030ff:	8b 40 04             	mov    0x4(%eax),%eax
c0103102:	89 45 d0             	mov    %eax,-0x30(%ebp)
    right_longest = self[RIGHT_LEAF(index)].longest;
c0103105:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103108:	83 c0 01             	add    $0x1,%eax
c010310b:	c1 e0 04             	shl    $0x4,%eax
c010310e:	89 c2                	mov    %eax,%edx
c0103110:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103113:	01 d0                	add    %edx,%eax
c0103115:	8b 40 04             	mov    0x4(%eax),%eax
c0103118:	89 45 cc             	mov    %eax,-0x34(%ebp)
    
    if (left_longest + right_longest == node_size)//可以合并 
c010311b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010311e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103121:	01 d0                	add    %edx,%eax
c0103123:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103126:	75 17                	jne    c010313f <buddy_free_pages+0x1fb>
      self[index].longest = node_size;
c0103128:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010312b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0103132:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103135:	01 c2                	add    %eax,%edx
c0103137:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010313a:	89 42 04             	mov    %eax,0x4(%edx)
c010313d:	eb 1c                	jmp    c010315b <buddy_free_pages+0x217>
    else
      self[index].longest = MAX(left_longest, right_longest);//不能合并，但也许关卡有更新
c010313f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103142:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0103149:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010314c:	01 c2                	add    %eax,%edx
c010314e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103151:	39 45 cc             	cmp    %eax,-0x34(%ebp)
c0103154:	0f 43 45 cc          	cmovae -0x34(%ebp),%eax
c0103158:	89 42 04             	mov    %eax,0x4(%edx)
     p->flags=0;
     p->property=1;
     SetPageProperty(p);
     le=list_next(le);
  }
  while (index) {//向上合并，修改先祖节点的记录值
c010315b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010315f:	0f 85 7b ff ff ff    	jne    c01030e0 <buddy_free_pages+0x19c>
    if (left_longest + right_longest == node_size)//可以合并 
      self[index].longest = node_size;
    else
      self[index].longest = MAX(left_longest, right_longest);//不能合并，但也许关卡有更新
  }
  for(i=pos;i<nr_block-1;i++)//清除此次的分配记录
c0103165:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103168:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010316b:	eb 3a                	jmp    c01031a7 <buddy_free_pages+0x263>
  {
    rec[i]=rec[i+1];//后面的前移，即数组这个元素的删除
c010316d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103170:	8d 48 01             	lea    0x1(%eax),%ecx
c0103173:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0103176:	89 d0                	mov    %edx,%eax
c0103178:	01 c0                	add    %eax,%eax
c010317a:	01 d0                	add    %edx,%eax
c010317c:	c1 e0 02             	shl    $0x2,%eax
c010317f:	8d 90 a0 7d 1b c0    	lea    -0x3fe48260(%eax),%edx
c0103185:	89 c8                	mov    %ecx,%eax
c0103187:	01 c0                	add    %eax,%eax
c0103189:	01 c8                	add    %ecx,%eax
c010318b:	c1 e0 02             	shl    $0x2,%eax
c010318e:	05 a0 7d 1b c0       	add    $0xc01b7da0,%eax
c0103193:	8b 08                	mov    (%eax),%ecx
c0103195:	89 0a                	mov    %ecx,(%edx)
c0103197:	8b 48 04             	mov    0x4(%eax),%ecx
c010319a:	89 4a 04             	mov    %ecx,0x4(%edx)
c010319d:	8b 40 08             	mov    0x8(%eax),%eax
c01031a0:	89 42 08             	mov    %eax,0x8(%edx)
    if (left_longest + right_longest == node_size)//可以合并 
      self[index].longest = node_size;
    else
      self[index].longest = MAX(left_longest, right_longest);//不能合并，但也许关卡有更新
  }
  for(i=pos;i<nr_block-1;i++)//清除此次的分配记录
c01031a3:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c01031a7:	a1 60 b9 11 c0       	mov    0xc011b960,%eax
c01031ac:	83 e8 01             	sub    $0x1,%eax
c01031af:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c01031b2:	7f b9                	jg     c010316d <buddy_free_pages+0x229>
  {
    rec[i]=rec[i+1];//后面的前移，即数组这个元素的删除
  }
  nr_block--;//更新分配块数的值
c01031b4:	a1 60 b9 11 c0       	mov    0xc011b960,%eax
c01031b9:	83 e8 01             	sub    $0x1,%eax
c01031bc:	a3 60 b9 11 c0       	mov    %eax,0xc011b960
}
c01031c1:	c9                   	leave  
c01031c2:	c3                   	ret    

c01031c3 <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
c01031c3:	55                   	push   %ebp
c01031c4:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01031c6:	a1 88 7d 1b c0       	mov    0xc01b7d88,%eax
}
c01031cb:	5d                   	pop    %ebp
c01031cc:	c3                   	ret    

c01031cd <buddy_check>:

//以下是一个测试函数
static void

buddy_check(void) {
c01031cd:	55                   	push   %ebp
c01031ce:	89 e5                	mov    %esp,%ebp
c01031d0:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *A, *B,*C,*D;
    p0 = A = B = C = D =NULL;
c01031d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01031da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01031ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01031ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    assert((p0 = alloc_page()) != NULL);
c01031f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031f9:	e8 61 1e 00 00       	call   c010505f <alloc_pages>
c01031fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103201:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103205:	75 24                	jne    c010322b <buddy_check+0x5e>
c0103207:	c7 44 24 0c d7 7a 10 	movl   $0xc0107ad7,0xc(%esp)
c010320e:	c0 
c010320f:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c0103216:	c0 
c0103217:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c010321e:	00 
c010321f:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c0103226:	e8 9b da ff ff       	call   c0100cc6 <__panic>
    assert((A = alloc_page()) != NULL);
c010322b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103232:	e8 28 1e 00 00       	call   c010505f <alloc_pages>
c0103237:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010323a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010323e:	75 24                	jne    c0103264 <buddy_check+0x97>
c0103240:	c7 44 24 0c f3 7a 10 	movl   $0xc0107af3,0xc(%esp)
c0103247:	c0 
c0103248:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c010324f:	c0 
c0103250:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0103257:	00 
c0103258:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c010325f:	e8 62 da ff ff       	call   c0100cc6 <__panic>
    assert((B = alloc_page()) != NULL);
c0103264:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010326b:	e8 ef 1d 00 00       	call   c010505f <alloc_pages>
c0103270:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103273:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103277:	75 24                	jne    c010329d <buddy_check+0xd0>
c0103279:	c7 44 24 0c 0e 7b 10 	movl   $0xc0107b0e,0xc(%esp)
c0103280:	c0 
c0103281:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c0103288:	c0 
c0103289:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0103290:	00 
c0103291:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c0103298:	e8 29 da ff ff       	call   c0100cc6 <__panic>

    assert(p0 != A && p0 != B && A != B);
c010329d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032a0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c01032a3:	74 10                	je     c01032b5 <buddy_check+0xe8>
c01032a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01032ab:	74 08                	je     c01032b5 <buddy_check+0xe8>
c01032ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01032b3:	75 24                	jne    c01032d9 <buddy_check+0x10c>
c01032b5:	c7 44 24 0c 29 7b 10 	movl   $0xc0107b29,0xc(%esp)
c01032bc:	c0 
c01032bd:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c01032c4:	c0 
c01032c5:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c01032cc:	00 
c01032cd:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c01032d4:	e8 ed d9 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);
c01032d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032dc:	89 04 24             	mov    %eax,(%esp)
c01032df:	e8 23 f5 ff ff       	call   c0102807 <page_ref>
c01032e4:	85 c0                	test   %eax,%eax
c01032e6:	75 1e                	jne    c0103306 <buddy_check+0x139>
c01032e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032eb:	89 04 24             	mov    %eax,(%esp)
c01032ee:	e8 14 f5 ff ff       	call   c0102807 <page_ref>
c01032f3:	85 c0                	test   %eax,%eax
c01032f5:	75 0f                	jne    c0103306 <buddy_check+0x139>
c01032f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032fa:	89 04 24             	mov    %eax,(%esp)
c01032fd:	e8 05 f5 ff ff       	call   c0102807 <page_ref>
c0103302:	85 c0                	test   %eax,%eax
c0103304:	74 24                	je     c010332a <buddy_check+0x15d>
c0103306:	c7 44 24 0c 48 7b 10 	movl   $0xc0107b48,0xc(%esp)
c010330d:	c0 
c010330e:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c0103315:	c0 
c0103316:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c010331d:	00 
c010331e:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c0103325:	e8 9c d9 ff ff       	call   c0100cc6 <__panic>
    free_page(p0);
c010332a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103331:	00 
c0103332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103335:	89 04 24             	mov    %eax,(%esp)
c0103338:	e8 5a 1d 00 00       	call   c0105097 <free_pages>
    free_page(A);
c010333d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103344:	00 
c0103345:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103348:	89 04 24             	mov    %eax,(%esp)
c010334b:	e8 47 1d 00 00       	call   c0105097 <free_pages>
    free_page(B);
c0103350:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103357:	00 
c0103358:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010335b:	89 04 24             	mov    %eax,(%esp)
c010335e:	e8 34 1d 00 00       	call   c0105097 <free_pages>
    
    A=alloc_pages(500);
c0103363:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
c010336a:	e8 f0 1c 00 00       	call   c010505f <alloc_pages>
c010336f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B=alloc_pages(500);
c0103372:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
c0103379:	e8 e1 1c 00 00       	call   c010505f <alloc_pages>
c010337e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    cprintf("A %p\n",A);
c0103381:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103384:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103388:	c7 04 24 82 7b 10 c0 	movl   $0xc0107b82,(%esp)
c010338f:	e8 a8 cf ff ff       	call   c010033c <cprintf>
    cprintf("B %p\n",B);
c0103394:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103397:	89 44 24 04          	mov    %eax,0x4(%esp)
c010339b:	c7 04 24 88 7b 10 c0 	movl   $0xc0107b88,(%esp)
c01033a2:	e8 95 cf ff ff       	call   c010033c <cprintf>
    free_pages(A,250);
c01033a7:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01033ae:	00 
c01033af:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033b2:	89 04 24             	mov    %eax,(%esp)
c01033b5:	e8 dd 1c 00 00       	call   c0105097 <free_pages>
    free_pages(B,500);
c01033ba:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c01033c1:	00 
c01033c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033c5:	89 04 24             	mov    %eax,(%esp)
c01033c8:	e8 ca 1c 00 00       	call   c0105097 <free_pages>
    free_pages(A+250,250);
c01033cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033d0:	05 88 13 00 00       	add    $0x1388,%eax
c01033d5:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01033dc:	00 
c01033dd:	89 04 24             	mov    %eax,(%esp)
c01033e0:	e8 b2 1c 00 00       	call   c0105097 <free_pages>
    
    p0=alloc_pages(1024);
c01033e5:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
c01033ec:	e8 6e 1c 00 00       	call   c010505f <alloc_pages>
c01033f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("p0 %p\n",p0);
c01033f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01033fb:	c7 04 24 8e 7b 10 c0 	movl   $0xc0107b8e,(%esp)
c0103402:	e8 35 cf ff ff       	call   c010033c <cprintf>
    assert(p0 == A);
c0103407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010340a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010340d:	74 24                	je     c0103433 <buddy_check+0x266>
c010340f:	c7 44 24 0c 95 7b 10 	movl   $0xc0107b95,0xc(%esp)
c0103416:	c0 
c0103417:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c010341e:	c0 
c010341f:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0103426:	00 
c0103427:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c010342e:	e8 93 d8 ff ff       	call   c0100cc6 <__panic>
    //以下是根据链接中的样例测试编写的
    A=alloc_pages(70);  
c0103433:	c7 04 24 46 00 00 00 	movl   $0x46,(%esp)
c010343a:	e8 20 1c 00 00       	call   c010505f <alloc_pages>
c010343f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    B=alloc_pages(35);
c0103442:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
c0103449:	e8 11 1c 00 00       	call   c010505f <alloc_pages>
c010344e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(A+128==B);//检查是否相邻
c0103451:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103454:	05 00 0a 00 00       	add    $0xa00,%eax
c0103459:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010345c:	74 24                	je     c0103482 <buddy_check+0x2b5>
c010345e:	c7 44 24 0c 9d 7b 10 	movl   $0xc0107b9d,0xc(%esp)
c0103465:	c0 
c0103466:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c010346d:	c0 
c010346e:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
c0103475:	00 
c0103476:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c010347d:	e8 44 d8 ff ff       	call   c0100cc6 <__panic>
    cprintf("A %p\n",A);
c0103482:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103485:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103489:	c7 04 24 82 7b 10 c0 	movl   $0xc0107b82,(%esp)
c0103490:	e8 a7 ce ff ff       	call   c010033c <cprintf>
    cprintf("B %p\n",B);
c0103495:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103498:	89 44 24 04          	mov    %eax,0x4(%esp)
c010349c:	c7 04 24 88 7b 10 c0 	movl   $0xc0107b88,(%esp)
c01034a3:	e8 94 ce ff ff       	call   c010033c <cprintf>
    C=alloc_pages(80);
c01034a8:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
c01034af:	e8 ab 1b 00 00       	call   c010505f <alloc_pages>
c01034b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(A+256==C);//检查C有没有和A重叠
c01034b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034ba:	05 00 14 00 00       	add    $0x1400,%eax
c01034bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01034c2:	74 24                	je     c01034e8 <buddy_check+0x31b>
c01034c4:	c7 44 24 0c a6 7b 10 	movl   $0xc0107ba6,0xc(%esp)
c01034cb:	c0 
c01034cc:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c01034d3:	c0 
c01034d4:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c01034db:	00 
c01034dc:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c01034e3:	e8 de d7 ff ff       	call   c0100cc6 <__panic>
    cprintf("C %p\n",C);
c01034e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01034ef:	c7 04 24 af 7b 10 c0 	movl   $0xc0107baf,(%esp)
c01034f6:	e8 41 ce ff ff       	call   c010033c <cprintf>
    free_pages(A,70);//释放A
c01034fb:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103502:	00 
c0103503:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103506:	89 04 24             	mov    %eax,(%esp)
c0103509:	e8 89 1b 00 00       	call   c0105097 <free_pages>
    cprintf("B %p\n",B);
c010350e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103511:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103515:	c7 04 24 88 7b 10 c0 	movl   $0xc0107b88,(%esp)
c010351c:	e8 1b ce ff ff       	call   c010033c <cprintf>
    D=alloc_pages(60);
c0103521:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
c0103528:	e8 32 1b 00 00       	call   c010505f <alloc_pages>
c010352d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("D %p\n",D);
c0103530:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103533:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103537:	c7 04 24 b5 7b 10 c0 	movl   $0xc0107bb5,(%esp)
c010353e:	e8 f9 cd ff ff       	call   c010033c <cprintf>
    assert(B+64==D);//检查B，D是否相邻
c0103543:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103546:	05 00 05 00 00       	add    $0x500,%eax
c010354b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010354e:	74 24                	je     c0103574 <buddy_check+0x3a7>
c0103550:	c7 44 24 0c bb 7b 10 	movl   $0xc0107bbb,0xc(%esp)
c0103557:	c0 
c0103558:	c7 44 24 08 74 7a 10 	movl   $0xc0107a74,0x8(%esp)
c010355f:	c0 
c0103560:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c0103567:	00 
c0103568:	c7 04 24 89 7a 10 c0 	movl   $0xc0107a89,(%esp)
c010356f:	e8 52 d7 ff ff       	call   c0100cc6 <__panic>
    free_pages(B,35);
c0103574:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
c010357b:	00 
c010357c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010357f:	89 04 24             	mov    %eax,(%esp)
c0103582:	e8 10 1b 00 00       	call   c0105097 <free_pages>
    cprintf("D %p\n",D);
c0103587:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010358a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010358e:	c7 04 24 b5 7b 10 c0 	movl   $0xc0107bb5,(%esp)
c0103595:	e8 a2 cd ff ff       	call   c010033c <cprintf>
    free_pages(D,60);
c010359a:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
c01035a1:	00 
c01035a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035a5:	89 04 24             	mov    %eax,(%esp)
c01035a8:	e8 ea 1a 00 00       	call   c0105097 <free_pages>
    cprintf("C %p\n",C);
c01035ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01035b4:	c7 04 24 af 7b 10 c0 	movl   $0xc0107baf,(%esp)
c01035bb:	e8 7c cd ff ff       	call   c010033c <cprintf>
    free_pages(C,80);
c01035c0:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
c01035c7:	00 
c01035c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035cb:	89 04 24             	mov    %eax,(%esp)
c01035ce:	e8 c4 1a 00 00       	call   c0105097 <free_pages>
    free_pages(p0,1000);//全部释放
c01035d3:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
c01035da:	00 
c01035db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035de:	89 04 24             	mov    %eax,(%esp)
c01035e1:	e8 b1 1a 00 00       	call   c0105097 <free_pages>
}
c01035e6:	c9                   	leave  
c01035e7:	c3                   	ret    

c01035e8 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01035e8:	55                   	push   %ebp
c01035e9:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01035eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01035ee:	a1 a8 23 2a c0       	mov    0xc02a23a8,%eax
c01035f3:	29 c2                	sub    %eax,%edx
c01035f5:	89 d0                	mov    %edx,%eax
c01035f7:	c1 f8 02             	sar    $0x2,%eax
c01035fa:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103600:	5d                   	pop    %ebp
c0103601:	c3                   	ret    

c0103602 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103602:	55                   	push   %ebp
c0103603:	89 e5                	mov    %esp,%ebp
c0103605:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103608:	8b 45 08             	mov    0x8(%ebp),%eax
c010360b:	89 04 24             	mov    %eax,(%esp)
c010360e:	e8 d5 ff ff ff       	call   c01035e8 <page2ppn>
c0103613:	c1 e0 0c             	shl    $0xc,%eax
}
c0103616:	c9                   	leave  
c0103617:	c3                   	ret    

c0103618 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103618:	55                   	push   %ebp
c0103619:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010361b:	8b 45 08             	mov    0x8(%ebp),%eax
c010361e:	8b 00                	mov    (%eax),%eax
}
c0103620:	5d                   	pop    %ebp
c0103621:	c3                   	ret    

c0103622 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103622:	55                   	push   %ebp
c0103623:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103625:	8b 45 08             	mov    0x8(%ebp),%eax
c0103628:	8b 55 0c             	mov    0xc(%ebp),%edx
c010362b:	89 10                	mov    %edx,(%eax)
}
c010362d:	5d                   	pop    %ebp
c010362e:	c3                   	ret    

c010362f <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010362f:	55                   	push   %ebp
c0103630:	89 e5                	mov    %esp,%ebp
c0103632:	83 ec 10             	sub    $0x10,%esp
c0103635:	c7 45 fc 80 7d 1b c0 	movl   $0xc01b7d80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010363c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010363f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103642:	89 50 04             	mov    %edx,0x4(%eax)
c0103645:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103648:	8b 50 04             	mov    0x4(%eax),%edx
c010364b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010364e:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103650:	c7 05 88 7d 1b c0 00 	movl   $0x0,0xc01b7d88
c0103657:	00 00 00 
}
c010365a:	c9                   	leave  
c010365b:	c3                   	ret    

c010365c <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010365c:	55                   	push   %ebp
c010365d:	89 e5                	mov    %esp,%ebp
c010365f:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0103662:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103666:	75 24                	jne    c010368c <default_init_memmap+0x30>
c0103668:	c7 44 24 0c f4 7b 10 	movl   $0xc0107bf4,0xc(%esp)
c010366f:	c0 
c0103670:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103677:	c0 
c0103678:	c7 44 24 04 4e 00 00 	movl   $0x4e,0x4(%esp)
c010367f:	00 
c0103680:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103687:	e8 3a d6 ff ff       	call   c0100cc6 <__panic>
    struct Page *p = base;
c010368c:	8b 45 08             	mov    0x8(%ebp),%eax
c010368f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103692:	eb 7d                	jmp    c0103711 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0103694:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103697:	83 c0 04             	add    $0x4,%eax
c010369a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01036a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01036aa:	0f a3 10             	bt     %edx,(%eax)
c01036ad:	19 c0                	sbb    %eax,%eax
c01036af:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01036b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01036b6:	0f 95 c0             	setne  %al
c01036b9:	0f b6 c0             	movzbl %al,%eax
c01036bc:	85 c0                	test   %eax,%eax
c01036be:	75 24                	jne    c01036e4 <default_init_memmap+0x88>
c01036c0:	c7 44 24 0c 25 7c 10 	movl   $0xc0107c25,0xc(%esp)
c01036c7:	c0 
c01036c8:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c01036cf:	c0 
c01036d0:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
c01036d7:	00 
c01036d8:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c01036df:	e8 e2 d5 ff ff       	call   c0100cc6 <__panic>
        p->flags = p->property = 0;
c01036e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01036ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f1:	8b 50 08             	mov    0x8(%eax),%edx
c01036f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f7:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01036fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103701:	00 
c0103702:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103705:	89 04 24             	mov    %eax,(%esp)
c0103708:	e8 15 ff ff ff       	call   c0103622 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c010370d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0103711:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103714:	89 d0                	mov    %edx,%eax
c0103716:	c1 e0 02             	shl    $0x2,%eax
c0103719:	01 d0                	add    %edx,%eax
c010371b:	c1 e0 02             	shl    $0x2,%eax
c010371e:	89 c2                	mov    %eax,%edx
c0103720:	8b 45 08             	mov    0x8(%ebp),%eax
c0103723:	01 d0                	add    %edx,%eax
c0103725:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103728:	0f 85 66 ff ff ff    	jne    c0103694 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c010372e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103731:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103734:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103737:	8b 45 08             	mov    0x8(%ebp),%eax
c010373a:	83 c0 04             	add    $0x4,%eax
c010373d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0103744:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103747:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010374a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010374d:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0103750:	8b 15 88 7d 1b c0    	mov    0xc01b7d88,%edx
c0103756:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103759:	01 d0                	add    %edx,%eax
c010375b:	a3 88 7d 1b c0       	mov    %eax,0xc01b7d88
    list_add(&free_list, &(base->page_link));
c0103760:	8b 45 08             	mov    0x8(%ebp),%eax
c0103763:	83 c0 0c             	add    $0xc,%eax
c0103766:	c7 45 dc 80 7d 1b c0 	movl   $0xc01b7d80,-0x24(%ebp)
c010376d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103770:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103773:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103776:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103779:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010377c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010377f:	8b 40 04             	mov    0x4(%eax),%eax
c0103782:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103785:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103788:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010378b:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010378e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103791:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103794:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103797:	89 10                	mov    %edx,(%eax)
c0103799:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010379c:	8b 10                	mov    (%eax),%edx
c010379e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01037a1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01037a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01037a7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01037aa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01037ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01037b0:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01037b3:	89 10                	mov    %edx,(%eax)
}
c01037b5:	c9                   	leave  
c01037b6:	c3                   	ret    

c01037b7 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01037b7:	55                   	push   %ebp
c01037b8:	89 e5                	mov    %esp,%ebp
c01037ba:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01037bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01037c1:	75 24                	jne    c01037e7 <default_alloc_pages+0x30>
c01037c3:	c7 44 24 0c f4 7b 10 	movl   $0xc0107bf4,0xc(%esp)
c01037ca:	c0 
c01037cb:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c01037d2:	c0 
c01037d3:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c01037da:	00 
c01037db:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c01037e2:	e8 df d4 ff ff       	call   c0100cc6 <__panic>
    if (n > nr_free) {
c01037e7:	a1 88 7d 1b c0       	mov    0xc01b7d88,%eax
c01037ec:	3b 45 08             	cmp    0x8(%ebp),%eax
c01037ef:	73 0a                	jae    c01037fb <default_alloc_pages+0x44>
        return NULL;
c01037f1:	b8 00 00 00 00       	mov    $0x0,%eax
c01037f6:	e9 2a 01 00 00       	jmp    c0103925 <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
c01037fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0103802:	c7 45 f0 80 7d 1b c0 	movl   $0xc01b7d80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103809:	eb 1c                	jmp    c0103827 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c010380b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010380e:	83 e8 0c             	sub    $0xc,%eax
c0103811:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0103814:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103817:	8b 40 08             	mov    0x8(%eax),%eax
c010381a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010381d:	72 08                	jb     c0103827 <default_alloc_pages+0x70>
            page = p;
c010381f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103822:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0103825:	eb 18                	jmp    c010383f <default_alloc_pages+0x88>
c0103827:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010382a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010382d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103830:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103833:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103836:	81 7d f0 80 7d 1b c0 	cmpl   $0xc01b7d80,-0x10(%ebp)
c010383d:	75 cc                	jne    c010380b <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c010383f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103843:	0f 84 d9 00 00 00    	je     c0103922 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
c0103849:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010384c:	83 c0 0c             	add    $0xc,%eax
c010384f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103852:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103855:	8b 40 04             	mov    0x4(%eax),%eax
c0103858:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010385b:	8b 12                	mov    (%edx),%edx
c010385d:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0103860:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103863:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103866:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103869:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010386c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010386f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103872:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c0103874:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103877:	8b 40 08             	mov    0x8(%eax),%eax
c010387a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010387d:	76 7d                	jbe    c01038fc <default_alloc_pages+0x145>
            struct Page *p = page + n;
c010387f:	8b 55 08             	mov    0x8(%ebp),%edx
c0103882:	89 d0                	mov    %edx,%eax
c0103884:	c1 e0 02             	shl    $0x2,%eax
c0103887:	01 d0                	add    %edx,%eax
c0103889:	c1 e0 02             	shl    $0x2,%eax
c010388c:	89 c2                	mov    %eax,%edx
c010388e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103891:	01 d0                	add    %edx,%eax
c0103893:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0103896:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103899:	8b 40 08             	mov    0x8(%eax),%eax
c010389c:	2b 45 08             	sub    0x8(%ebp),%eax
c010389f:	89 c2                	mov    %eax,%edx
c01038a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038a4:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c01038a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038aa:	83 c0 0c             	add    $0xc,%eax
c01038ad:	c7 45 d4 80 7d 1b c0 	movl   $0xc01b7d80,-0x2c(%ebp)
c01038b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01038b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01038ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01038bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01038c0:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01038c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01038c6:	8b 40 04             	mov    0x4(%eax),%eax
c01038c9:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01038cc:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c01038cf:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01038d2:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01038d5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01038d8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01038db:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01038de:	89 10                	mov    %edx,(%eax)
c01038e0:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01038e3:	8b 10                	mov    (%eax),%edx
c01038e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01038e8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01038eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01038ee:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01038f1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01038f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01038f7:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01038fa:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c01038fc:	a1 88 7d 1b c0       	mov    0xc01b7d88,%eax
c0103901:	2b 45 08             	sub    0x8(%ebp),%eax
c0103904:	a3 88 7d 1b c0       	mov    %eax,0xc01b7d88
        ClearPageProperty(page);
c0103909:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010390c:	83 c0 04             	add    $0x4,%eax
c010390f:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0103916:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103919:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010391c:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010391f:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0103922:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103925:	c9                   	leave  
c0103926:	c3                   	ret    

c0103927 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103927:	55                   	push   %ebp
c0103928:	89 e5                	mov    %esp,%ebp
c010392a:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0103930:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103934:	75 24                	jne    c010395a <default_free_pages+0x33>
c0103936:	c7 44 24 0c f4 7b 10 	movl   $0xc0107bf4,0xc(%esp)
c010393d:	c0 
c010393e:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103945:	c0 
c0103946:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c010394d:	00 
c010394e:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103955:	e8 6c d3 ff ff       	call   c0100cc6 <__panic>
    struct Page *p = base;
c010395a:	8b 45 08             	mov    0x8(%ebp),%eax
c010395d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103960:	e9 9d 00 00 00       	jmp    c0103a02 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0103965:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103968:	83 c0 04             	add    $0x4,%eax
c010396b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103972:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103975:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103978:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010397b:	0f a3 10             	bt     %edx,(%eax)
c010397e:	19 c0                	sbb    %eax,%eax
c0103980:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0103983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103987:	0f 95 c0             	setne  %al
c010398a:	0f b6 c0             	movzbl %al,%eax
c010398d:	85 c0                	test   %eax,%eax
c010398f:	75 2c                	jne    c01039bd <default_free_pages+0x96>
c0103991:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103994:	83 c0 04             	add    $0x4,%eax
c0103997:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010399e:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01039a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01039a7:	0f a3 10             	bt     %edx,(%eax)
c01039aa:	19 c0                	sbb    %eax,%eax
c01039ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c01039af:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01039b3:	0f 95 c0             	setne  %al
c01039b6:	0f b6 c0             	movzbl %al,%eax
c01039b9:	85 c0                	test   %eax,%eax
c01039bb:	74 24                	je     c01039e1 <default_free_pages+0xba>
c01039bd:	c7 44 24 0c 38 7c 10 	movl   $0xc0107c38,0xc(%esp)
c01039c4:	c0 
c01039c5:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c01039cc:	c0 
c01039cd:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c01039d4:	00 
c01039d5:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c01039dc:	e8 e5 d2 ff ff       	call   c0100cc6 <__panic>
        p->flags = 0;   //标记为空闲
c01039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0); //清空引用计数
c01039eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01039f2:	00 
c01039f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039f6:	89 04 24             	mov    %eax,(%esp)
c01039f9:	e8 24 fc ff ff       	call   c0103622 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01039fe:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0103a02:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a05:	89 d0                	mov    %edx,%eax
c0103a07:	c1 e0 02             	shl    $0x2,%eax
c0103a0a:	01 d0                	add    %edx,%eax
c0103a0c:	c1 e0 02             	shl    $0x2,%eax
c0103a0f:	89 c2                	mov    %eax,%edx
c0103a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a14:	01 d0                	add    %edx,%eax
c0103a16:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103a19:	0f 85 46 ff ff ff    	jne    c0103965 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;   //标记为空闲
        set_page_ref(p, 0); //清空引用计数
    }
    base->property = n; //设置空闲块大小
c0103a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a22:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a25:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103a28:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a2b:	83 c0 04             	add    $0x4,%eax
c0103a2e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103a35:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103a38:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103a3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103a3e:	0f ab 10             	bts    %edx,(%eax)
c0103a41:	c7 45 cc 80 7d 1b c0 	movl   $0xc01b7d80,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103a48:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103a4b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);   //----------疑惑：这是在找什么
c0103a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {  //遍历存放空闲块的列表--此处merge
c0103a51:	e9 08 01 00 00       	jmp    c0103b5e <default_free_pages+0x237>
        p = le2page(le, page_link);
c0103a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a59:	83 e8 0c             	sub    $0xc,%eax
c0103a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a62:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103a65:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103a68:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0103a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0103a6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a71:	8b 50 08             	mov    0x8(%eax),%edx
c0103a74:	89 d0                	mov    %edx,%eax
c0103a76:	c1 e0 02             	shl    $0x2,%eax
c0103a79:	01 d0                	add    %edx,%eax
c0103a7b:	c1 e0 02             	shl    $0x2,%eax
c0103a7e:	89 c2                	mov    %eax,%edx
c0103a80:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a83:	01 d0                	add    %edx,%eax
c0103a85:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103a88:	75 5a                	jne    c0103ae4 <default_free_pages+0x1bd>
            base->property += p->property;
c0103a8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a8d:	8b 50 08             	mov    0x8(%eax),%edx
c0103a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a93:	8b 40 08             	mov    0x8(%eax),%eax
c0103a96:	01 c2                	add    %eax,%edx
c0103a98:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a9b:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0103a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aa1:	83 c0 04             	add    $0x4,%eax
c0103aa4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0103aab:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103aae:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103ab1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103ab4:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0103ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aba:	83 c0 0c             	add    $0xc,%eax
c0103abd:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103ac0:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103ac3:	8b 40 04             	mov    0x4(%eax),%eax
c0103ac6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103ac9:	8b 12                	mov    (%edx),%edx
c0103acb:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0103ace:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103ad1:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ad4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ad7:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103ada:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103add:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103ae0:	89 10                	mov    %edx,(%eax)
c0103ae2:	eb 7a                	jmp    c0103b5e <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0103ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ae7:	8b 50 08             	mov    0x8(%eax),%edx
c0103aea:	89 d0                	mov    %edx,%eax
c0103aec:	c1 e0 02             	shl    $0x2,%eax
c0103aef:	01 d0                	add    %edx,%eax
c0103af1:	c1 e0 02             	shl    $0x2,%eax
c0103af4:	89 c2                	mov    %eax,%edx
c0103af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103af9:	01 d0                	add    %edx,%eax
c0103afb:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103afe:	75 5e                	jne    c0103b5e <default_free_pages+0x237>
            p->property += base->property;
c0103b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b03:	8b 50 08             	mov    0x8(%eax),%edx
c0103b06:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b09:	8b 40 08             	mov    0x8(%eax),%eax
c0103b0c:	01 c2                	add    %eax,%edx
c0103b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b11:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0103b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b17:	83 c0 04             	add    $0x4,%eax
c0103b1a:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0103b21:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103b24:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103b27:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103b2a:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0103b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b30:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0103b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b36:	83 c0 0c             	add    $0xc,%eax
c0103b39:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103b3c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103b3f:	8b 40 04             	mov    0x4(%eax),%eax
c0103b42:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103b45:	8b 12                	mov    (%edx),%edx
c0103b47:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0103b4a:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103b4d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103b50:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103b53:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103b56:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103b59:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103b5c:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0); //清空引用计数
    }
    base->property = n; //设置空闲块大小
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);   //----------疑惑：这是在找什么
    while (le != &free_list) {  //遍历存放空闲块的列表--此处merge
c0103b5e:	81 7d f0 80 7d 1b c0 	cmpl   $0xc01b7d80,-0x10(%ebp)
c0103b65:	0f 85 eb fe ff ff    	jne    c0103a56 <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0103b6b:	8b 15 88 7d 1b c0    	mov    0xc01b7d88,%edx
c0103b71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b74:	01 d0                	add    %edx,%eax
c0103b76:	a3 88 7d 1b c0       	mov    %eax,0xc01b7d88
    list_add(&free_list, &(base->page_link));
c0103b7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b7e:	83 c0 0c             	add    $0xc,%eax
c0103b81:	c7 45 9c 80 7d 1b c0 	movl   $0xc01b7d80,-0x64(%ebp)
c0103b88:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103b8b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103b8e:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0103b91:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103b94:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0103b97:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103b9a:	8b 40 04             	mov    0x4(%eax),%eax
c0103b9d:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103ba0:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0103ba3:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103ba6:	89 55 88             	mov    %edx,-0x78(%ebp)
c0103ba9:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103bac:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103baf:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103bb2:	89 10                	mov    %edx,(%eax)
c0103bb4:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103bb7:	8b 10                	mov    (%eax),%edx
c0103bb9:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103bbc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103bbf:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103bc2:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103bc5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103bc8:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103bcb:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103bce:	89 10                	mov    %edx,(%eax)
}
c0103bd0:	c9                   	leave  
c0103bd1:	c3                   	ret    

c0103bd2 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103bd2:	55                   	push   %ebp
c0103bd3:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103bd5:	a1 88 7d 1b c0       	mov    0xc01b7d88,%eax
}
c0103bda:	5d                   	pop    %ebp
c0103bdb:	c3                   	ret    

c0103bdc <basic_check>:

static void
basic_check(void) {
c0103bdc:	55                   	push   %ebp
c0103bdd:	89 e5                	mov    %esp,%ebp
c0103bdf:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103be2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103bf5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bfc:	e8 5e 14 00 00       	call   c010505f <alloc_pages>
c0103c01:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103c04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103c08:	75 24                	jne    c0103c2e <basic_check+0x52>
c0103c0a:	c7 44 24 0c 5d 7c 10 	movl   $0xc0107c5d,0xc(%esp)
c0103c11:	c0 
c0103c12:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103c19:	c0 
c0103c1a:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0103c21:	00 
c0103c22:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103c29:	e8 98 d0 ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103c2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c35:	e8 25 14 00 00       	call   c010505f <alloc_pages>
c0103c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c41:	75 24                	jne    c0103c67 <basic_check+0x8b>
c0103c43:	c7 44 24 0c 79 7c 10 	movl   $0xc0107c79,0xc(%esp)
c0103c4a:	c0 
c0103c4b:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103c52:	c0 
c0103c53:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0103c5a:	00 
c0103c5b:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103c62:	e8 5f d0 ff ff       	call   c0100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103c67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c6e:	e8 ec 13 00 00       	call   c010505f <alloc_pages>
c0103c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103c7a:	75 24                	jne    c0103ca0 <basic_check+0xc4>
c0103c7c:	c7 44 24 0c 95 7c 10 	movl   $0xc0107c95,0xc(%esp)
c0103c83:	c0 
c0103c84:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103c8b:	c0 
c0103c8c:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c0103c93:	00 
c0103c94:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103c9b:	e8 26 d0 ff ff       	call   c0100cc6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ca3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103ca6:	74 10                	je     c0103cb8 <basic_check+0xdc>
c0103ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103cae:	74 08                	je     c0103cb8 <basic_check+0xdc>
c0103cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cb3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103cb6:	75 24                	jne    c0103cdc <basic_check+0x100>
c0103cb8:	c7 44 24 0c b4 7c 10 	movl   $0xc0107cb4,0xc(%esp)
c0103cbf:	c0 
c0103cc0:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103cc7:	c0 
c0103cc8:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
c0103ccf:	00 
c0103cd0:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103cd7:	e8 ea cf ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103cdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cdf:	89 04 24             	mov    %eax,(%esp)
c0103ce2:	e8 31 f9 ff ff       	call   c0103618 <page_ref>
c0103ce7:	85 c0                	test   %eax,%eax
c0103ce9:	75 1e                	jne    c0103d09 <basic_check+0x12d>
c0103ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cee:	89 04 24             	mov    %eax,(%esp)
c0103cf1:	e8 22 f9 ff ff       	call   c0103618 <page_ref>
c0103cf6:	85 c0                	test   %eax,%eax
c0103cf8:	75 0f                	jne    c0103d09 <basic_check+0x12d>
c0103cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cfd:	89 04 24             	mov    %eax,(%esp)
c0103d00:	e8 13 f9 ff ff       	call   c0103618 <page_ref>
c0103d05:	85 c0                	test   %eax,%eax
c0103d07:	74 24                	je     c0103d2d <basic_check+0x151>
c0103d09:	c7 44 24 0c d8 7c 10 	movl   $0xc0107cd8,0xc(%esp)
c0103d10:	c0 
c0103d11:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103d18:	c0 
c0103d19:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0103d20:	00 
c0103d21:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103d28:	e8 99 cf ff ff       	call   c0100cc6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103d2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d30:	89 04 24             	mov    %eax,(%esp)
c0103d33:	e8 ca f8 ff ff       	call   c0103602 <page2pa>
c0103d38:	8b 15 c0 b8 11 c0    	mov    0xc011b8c0,%edx
c0103d3e:	c1 e2 0c             	shl    $0xc,%edx
c0103d41:	39 d0                	cmp    %edx,%eax
c0103d43:	72 24                	jb     c0103d69 <basic_check+0x18d>
c0103d45:	c7 44 24 0c 14 7d 10 	movl   $0xc0107d14,0xc(%esp)
c0103d4c:	c0 
c0103d4d:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103d54:	c0 
c0103d55:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c0103d5c:	00 
c0103d5d:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103d64:	e8 5d cf ff ff       	call   c0100cc6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d6c:	89 04 24             	mov    %eax,(%esp)
c0103d6f:	e8 8e f8 ff ff       	call   c0103602 <page2pa>
c0103d74:	8b 15 c0 b8 11 c0    	mov    0xc011b8c0,%edx
c0103d7a:	c1 e2 0c             	shl    $0xc,%edx
c0103d7d:	39 d0                	cmp    %edx,%eax
c0103d7f:	72 24                	jb     c0103da5 <basic_check+0x1c9>
c0103d81:	c7 44 24 0c 31 7d 10 	movl   $0xc0107d31,0xc(%esp)
c0103d88:	c0 
c0103d89:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103d90:	c0 
c0103d91:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0103d98:	00 
c0103d99:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103da0:	e8 21 cf ff ff       	call   c0100cc6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103da8:	89 04 24             	mov    %eax,(%esp)
c0103dab:	e8 52 f8 ff ff       	call   c0103602 <page2pa>
c0103db0:	8b 15 c0 b8 11 c0    	mov    0xc011b8c0,%edx
c0103db6:	c1 e2 0c             	shl    $0xc,%edx
c0103db9:	39 d0                	cmp    %edx,%eax
c0103dbb:	72 24                	jb     c0103de1 <basic_check+0x205>
c0103dbd:	c7 44 24 0c 4e 7d 10 	movl   $0xc0107d4e,0xc(%esp)
c0103dc4:	c0 
c0103dc5:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103dcc:	c0 
c0103dcd:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0103dd4:	00 
c0103dd5:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103ddc:	e8 e5 ce ff ff       	call   c0100cc6 <__panic>

    list_entry_t free_list_store = free_list;
c0103de1:	a1 80 7d 1b c0       	mov    0xc01b7d80,%eax
c0103de6:	8b 15 84 7d 1b c0    	mov    0xc01b7d84,%edx
c0103dec:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103def:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103df2:	c7 45 e0 80 7d 1b c0 	movl   $0xc01b7d80,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103dfc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103dff:	89 50 04             	mov    %edx,0x4(%eax)
c0103e02:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e05:	8b 50 04             	mov    0x4(%eax),%edx
c0103e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e0b:	89 10                	mov    %edx,(%eax)
c0103e0d:	c7 45 dc 80 7d 1b c0 	movl   $0xc01b7d80,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103e14:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e17:	8b 40 04             	mov    0x4(%eax),%eax
c0103e1a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103e1d:	0f 94 c0             	sete   %al
c0103e20:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103e23:	85 c0                	test   %eax,%eax
c0103e25:	75 24                	jne    c0103e4b <basic_check+0x26f>
c0103e27:	c7 44 24 0c 6b 7d 10 	movl   $0xc0107d6b,0xc(%esp)
c0103e2e:	c0 
c0103e2f:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103e36:	c0 
c0103e37:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0103e3e:	00 
c0103e3f:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103e46:	e8 7b ce ff ff       	call   c0100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
c0103e4b:	a1 88 7d 1b c0       	mov    0xc01b7d88,%eax
c0103e50:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103e53:	c7 05 88 7d 1b c0 00 	movl   $0x0,0xc01b7d88
c0103e5a:	00 00 00 

    assert(alloc_page() == NULL);
c0103e5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e64:	e8 f6 11 00 00       	call   c010505f <alloc_pages>
c0103e69:	85 c0                	test   %eax,%eax
c0103e6b:	74 24                	je     c0103e91 <basic_check+0x2b5>
c0103e6d:	c7 44 24 0c 82 7d 10 	movl   $0xc0107d82,0xc(%esp)
c0103e74:	c0 
c0103e75:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103e7c:	c0 
c0103e7d:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103e84:	00 
c0103e85:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103e8c:	e8 35 ce ff ff       	call   c0100cc6 <__panic>

    free_page(p0);
c0103e91:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103e98:	00 
c0103e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e9c:	89 04 24             	mov    %eax,(%esp)
c0103e9f:	e8 f3 11 00 00       	call   c0105097 <free_pages>
    free_page(p1);
c0103ea4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103eab:	00 
c0103eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103eaf:	89 04 24             	mov    %eax,(%esp)
c0103eb2:	e8 e0 11 00 00       	call   c0105097 <free_pages>
    free_page(p2);
c0103eb7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ebe:	00 
c0103ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ec2:	89 04 24             	mov    %eax,(%esp)
c0103ec5:	e8 cd 11 00 00       	call   c0105097 <free_pages>
    assert(nr_free == 3);
c0103eca:	a1 88 7d 1b c0       	mov    0xc01b7d88,%eax
c0103ecf:	83 f8 03             	cmp    $0x3,%eax
c0103ed2:	74 24                	je     c0103ef8 <basic_check+0x31c>
c0103ed4:	c7 44 24 0c 97 7d 10 	movl   $0xc0107d97,0xc(%esp)
c0103edb:	c0 
c0103edc:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103ee3:	c0 
c0103ee4:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0103eeb:	00 
c0103eec:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103ef3:	e8 ce cd ff ff       	call   c0100cc6 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103ef8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103eff:	e8 5b 11 00 00       	call   c010505f <alloc_pages>
c0103f04:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103f07:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103f0b:	75 24                	jne    c0103f31 <basic_check+0x355>
c0103f0d:	c7 44 24 0c 5d 7c 10 	movl   $0xc0107c5d,0xc(%esp)
c0103f14:	c0 
c0103f15:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103f1c:	c0 
c0103f1d:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103f24:	00 
c0103f25:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103f2c:	e8 95 cd ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103f31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f38:	e8 22 11 00 00       	call   c010505f <alloc_pages>
c0103f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103f40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103f44:	75 24                	jne    c0103f6a <basic_check+0x38e>
c0103f46:	c7 44 24 0c 79 7c 10 	movl   $0xc0107c79,0xc(%esp)
c0103f4d:	c0 
c0103f4e:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103f55:	c0 
c0103f56:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0103f5d:	00 
c0103f5e:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103f65:	e8 5c cd ff ff       	call   c0100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103f6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f71:	e8 e9 10 00 00       	call   c010505f <alloc_pages>
c0103f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103f79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103f7d:	75 24                	jne    c0103fa3 <basic_check+0x3c7>
c0103f7f:	c7 44 24 0c 95 7c 10 	movl   $0xc0107c95,0xc(%esp)
c0103f86:	c0 
c0103f87:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103f8e:	c0 
c0103f8f:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103f96:	00 
c0103f97:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103f9e:	e8 23 cd ff ff       	call   c0100cc6 <__panic>

    assert(alloc_page() == NULL);
c0103fa3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103faa:	e8 b0 10 00 00       	call   c010505f <alloc_pages>
c0103faf:	85 c0                	test   %eax,%eax
c0103fb1:	74 24                	je     c0103fd7 <basic_check+0x3fb>
c0103fb3:	c7 44 24 0c 82 7d 10 	movl   $0xc0107d82,0xc(%esp)
c0103fba:	c0 
c0103fbb:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0103fc2:	c0 
c0103fc3:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0103fca:	00 
c0103fcb:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0103fd2:	e8 ef cc ff ff       	call   c0100cc6 <__panic>

    free_page(p0);
c0103fd7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fde:	00 
c0103fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103fe2:	89 04 24             	mov    %eax,(%esp)
c0103fe5:	e8 ad 10 00 00       	call   c0105097 <free_pages>
c0103fea:	c7 45 d8 80 7d 1b c0 	movl   $0xc01b7d80,-0x28(%ebp)
c0103ff1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103ff4:	8b 40 04             	mov    0x4(%eax),%eax
c0103ff7:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103ffa:	0f 94 c0             	sete   %al
c0103ffd:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104000:	85 c0                	test   %eax,%eax
c0104002:	74 24                	je     c0104028 <basic_check+0x44c>
c0104004:	c7 44 24 0c a4 7d 10 	movl   $0xc0107da4,0xc(%esp)
c010400b:	c0 
c010400c:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104013:	c0 
c0104014:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c010401b:	00 
c010401c:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104023:	e8 9e cc ff ff       	call   c0100cc6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104028:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010402f:	e8 2b 10 00 00       	call   c010505f <alloc_pages>
c0104034:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104037:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010403a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010403d:	74 24                	je     c0104063 <basic_check+0x487>
c010403f:	c7 44 24 0c bc 7d 10 	movl   $0xc0107dbc,0xc(%esp)
c0104046:	c0 
c0104047:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c010404e:	c0 
c010404f:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0104056:	00 
c0104057:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c010405e:	e8 63 cc ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c0104063:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010406a:	e8 f0 0f 00 00       	call   c010505f <alloc_pages>
c010406f:	85 c0                	test   %eax,%eax
c0104071:	74 24                	je     c0104097 <basic_check+0x4bb>
c0104073:	c7 44 24 0c 82 7d 10 	movl   $0xc0107d82,0xc(%esp)
c010407a:	c0 
c010407b:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104082:	c0 
c0104083:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c010408a:	00 
c010408b:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104092:	e8 2f cc ff ff       	call   c0100cc6 <__panic>

    assert(nr_free == 0);
c0104097:	a1 88 7d 1b c0       	mov    0xc01b7d88,%eax
c010409c:	85 c0                	test   %eax,%eax
c010409e:	74 24                	je     c01040c4 <basic_check+0x4e8>
c01040a0:	c7 44 24 0c d5 7d 10 	movl   $0xc0107dd5,0xc(%esp)
c01040a7:	c0 
c01040a8:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c01040af:	c0 
c01040b0:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c01040b7:	00 
c01040b8:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c01040bf:	e8 02 cc ff ff       	call   c0100cc6 <__panic>
    free_list = free_list_store;
c01040c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040ca:	a3 80 7d 1b c0       	mov    %eax,0xc01b7d80
c01040cf:	89 15 84 7d 1b c0    	mov    %edx,0xc01b7d84
    nr_free = nr_free_store;
c01040d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01040d8:	a3 88 7d 1b c0       	mov    %eax,0xc01b7d88

    free_page(p);
c01040dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040e4:	00 
c01040e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040e8:	89 04 24             	mov    %eax,(%esp)
c01040eb:	e8 a7 0f 00 00       	call   c0105097 <free_pages>
    free_page(p1);
c01040f0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040f7:	00 
c01040f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040fb:	89 04 24             	mov    %eax,(%esp)
c01040fe:	e8 94 0f 00 00       	call   c0105097 <free_pages>
    free_page(p2);
c0104103:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010410a:	00 
c010410b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010410e:	89 04 24             	mov    %eax,(%esp)
c0104111:	e8 81 0f 00 00       	call   c0105097 <free_pages>
}
c0104116:	c9                   	leave  
c0104117:	c3                   	ret    

c0104118 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104118:	55                   	push   %ebp
c0104119:	89 e5                	mov    %esp,%ebp
c010411b:	53                   	push   %ebx
c010411c:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0104122:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104129:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104130:	c7 45 ec 80 7d 1b c0 	movl   $0xc01b7d80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104137:	eb 6b                	jmp    c01041a4 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0104139:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010413c:	83 e8 0c             	sub    $0xc,%eax
c010413f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0104142:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104145:	83 c0 04             	add    $0x4,%eax
c0104148:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010414f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104152:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104155:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104158:	0f a3 10             	bt     %edx,(%eax)
c010415b:	19 c0                	sbb    %eax,%eax
c010415d:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104160:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104164:	0f 95 c0             	setne  %al
c0104167:	0f b6 c0             	movzbl %al,%eax
c010416a:	85 c0                	test   %eax,%eax
c010416c:	75 24                	jne    c0104192 <default_check+0x7a>
c010416e:	c7 44 24 0c e2 7d 10 	movl   $0xc0107de2,0xc(%esp)
c0104175:	c0 
c0104176:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c010417d:	c0 
c010417e:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0104185:	00 
c0104186:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c010418d:	e8 34 cb ff ff       	call   c0100cc6 <__panic>
        count ++, total += p->property;
c0104192:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104196:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104199:	8b 50 08             	mov    0x8(%eax),%edx
c010419c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010419f:	01 d0                	add    %edx,%eax
c01041a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01041a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01041aa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01041ad:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01041b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01041b3:	81 7d ec 80 7d 1b c0 	cmpl   $0xc01b7d80,-0x14(%ebp)
c01041ba:	0f 85 79 ff ff ff    	jne    c0104139 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01041c0:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01041c3:	e8 01 0f 00 00       	call   c01050c9 <nr_free_pages>
c01041c8:	39 c3                	cmp    %eax,%ebx
c01041ca:	74 24                	je     c01041f0 <default_check+0xd8>
c01041cc:	c7 44 24 0c f2 7d 10 	movl   $0xc0107df2,0xc(%esp)
c01041d3:	c0 
c01041d4:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c01041db:	c0 
c01041dc:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01041e3:	00 
c01041e4:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c01041eb:	e8 d6 ca ff ff       	call   c0100cc6 <__panic>

    basic_check();
c01041f0:	e8 e7 f9 ff ff       	call   c0103bdc <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01041f5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01041fc:	e8 5e 0e 00 00       	call   c010505f <alloc_pages>
c0104201:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0104204:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104208:	75 24                	jne    c010422e <default_check+0x116>
c010420a:	c7 44 24 0c 0b 7e 10 	movl   $0xc0107e0b,0xc(%esp)
c0104211:	c0 
c0104212:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104219:	c0 
c010421a:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0104221:	00 
c0104222:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104229:	e8 98 ca ff ff       	call   c0100cc6 <__panic>
    assert(!PageProperty(p0));
c010422e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104231:	83 c0 04             	add    $0x4,%eax
c0104234:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010423b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010423e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104241:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104244:	0f a3 10             	bt     %edx,(%eax)
c0104247:	19 c0                	sbb    %eax,%eax
c0104249:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010424c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104250:	0f 95 c0             	setne  %al
c0104253:	0f b6 c0             	movzbl %al,%eax
c0104256:	85 c0                	test   %eax,%eax
c0104258:	74 24                	je     c010427e <default_check+0x166>
c010425a:	c7 44 24 0c 16 7e 10 	movl   $0xc0107e16,0xc(%esp)
c0104261:	c0 
c0104262:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104269:	c0 
c010426a:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0104271:	00 
c0104272:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104279:	e8 48 ca ff ff       	call   c0100cc6 <__panic>

    list_entry_t free_list_store = free_list;
c010427e:	a1 80 7d 1b c0       	mov    0xc01b7d80,%eax
c0104283:	8b 15 84 7d 1b c0    	mov    0xc01b7d84,%edx
c0104289:	89 45 80             	mov    %eax,-0x80(%ebp)
c010428c:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010428f:	c7 45 b4 80 7d 1b c0 	movl   $0xc01b7d80,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104296:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104299:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010429c:	89 50 04             	mov    %edx,0x4(%eax)
c010429f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042a2:	8b 50 04             	mov    0x4(%eax),%edx
c01042a5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01042a8:	89 10                	mov    %edx,(%eax)
c01042aa:	c7 45 b0 80 7d 1b c0 	movl   $0xc01b7d80,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01042b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01042b4:	8b 40 04             	mov    0x4(%eax),%eax
c01042b7:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01042ba:	0f 94 c0             	sete   %al
c01042bd:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01042c0:	85 c0                	test   %eax,%eax
c01042c2:	75 24                	jne    c01042e8 <default_check+0x1d0>
c01042c4:	c7 44 24 0c 6b 7d 10 	movl   $0xc0107d6b,0xc(%esp)
c01042cb:	c0 
c01042cc:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c01042d3:	c0 
c01042d4:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01042db:	00 
c01042dc:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c01042e3:	e8 de c9 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c01042e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042ef:	e8 6b 0d 00 00       	call   c010505f <alloc_pages>
c01042f4:	85 c0                	test   %eax,%eax
c01042f6:	74 24                	je     c010431c <default_check+0x204>
c01042f8:	c7 44 24 0c 82 7d 10 	movl   $0xc0107d82,0xc(%esp)
c01042ff:	c0 
c0104300:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104307:	c0 
c0104308:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c010430f:	00 
c0104310:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104317:	e8 aa c9 ff ff       	call   c0100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
c010431c:	a1 88 7d 1b c0       	mov    0xc01b7d88,%eax
c0104321:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0104324:	c7 05 88 7d 1b c0 00 	movl   $0x0,0xc01b7d88
c010432b:	00 00 00 

    free_pages(p0 + 2, 3);
c010432e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104331:	83 c0 28             	add    $0x28,%eax
c0104334:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010433b:	00 
c010433c:	89 04 24             	mov    %eax,(%esp)
c010433f:	e8 53 0d 00 00       	call   c0105097 <free_pages>
    assert(alloc_pages(4) == NULL);
c0104344:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010434b:	e8 0f 0d 00 00       	call   c010505f <alloc_pages>
c0104350:	85 c0                	test   %eax,%eax
c0104352:	74 24                	je     c0104378 <default_check+0x260>
c0104354:	c7 44 24 0c 28 7e 10 	movl   $0xc0107e28,0xc(%esp)
c010435b:	c0 
c010435c:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104363:	c0 
c0104364:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c010436b:	00 
c010436c:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104373:	e8 4e c9 ff ff       	call   c0100cc6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010437b:	83 c0 28             	add    $0x28,%eax
c010437e:	83 c0 04             	add    $0x4,%eax
c0104381:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104388:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010438b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010438e:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104391:	0f a3 10             	bt     %edx,(%eax)
c0104394:	19 c0                	sbb    %eax,%eax
c0104396:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104399:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010439d:	0f 95 c0             	setne  %al
c01043a0:	0f b6 c0             	movzbl %al,%eax
c01043a3:	85 c0                	test   %eax,%eax
c01043a5:	74 0e                	je     c01043b5 <default_check+0x29d>
c01043a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043aa:	83 c0 28             	add    $0x28,%eax
c01043ad:	8b 40 08             	mov    0x8(%eax),%eax
c01043b0:	83 f8 03             	cmp    $0x3,%eax
c01043b3:	74 24                	je     c01043d9 <default_check+0x2c1>
c01043b5:	c7 44 24 0c 40 7e 10 	movl   $0xc0107e40,0xc(%esp)
c01043bc:	c0 
c01043bd:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c01043c4:	c0 
c01043c5:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c01043cc:	00 
c01043cd:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c01043d4:	e8 ed c8 ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01043d9:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01043e0:	e8 7a 0c 00 00       	call   c010505f <alloc_pages>
c01043e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01043e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01043ec:	75 24                	jne    c0104412 <default_check+0x2fa>
c01043ee:	c7 44 24 0c 6c 7e 10 	movl   $0xc0107e6c,0xc(%esp)
c01043f5:	c0 
c01043f6:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c01043fd:	c0 
c01043fe:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0104405:	00 
c0104406:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c010440d:	e8 b4 c8 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c0104412:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104419:	e8 41 0c 00 00       	call   c010505f <alloc_pages>
c010441e:	85 c0                	test   %eax,%eax
c0104420:	74 24                	je     c0104446 <default_check+0x32e>
c0104422:	c7 44 24 0c 82 7d 10 	movl   $0xc0107d82,0xc(%esp)
c0104429:	c0 
c010442a:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104431:	c0 
c0104432:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0104439:	00 
c010443a:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104441:	e8 80 c8 ff ff       	call   c0100cc6 <__panic>
    assert(p0 + 2 == p1);
c0104446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104449:	83 c0 28             	add    $0x28,%eax
c010444c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010444f:	74 24                	je     c0104475 <default_check+0x35d>
c0104451:	c7 44 24 0c 8a 7e 10 	movl   $0xc0107e8a,0xc(%esp)
c0104458:	c0 
c0104459:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104460:	c0 
c0104461:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0104468:	00 
c0104469:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104470:	e8 51 c8 ff ff       	call   c0100cc6 <__panic>

    p2 = p0 + 1;
c0104475:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104478:	83 c0 14             	add    $0x14,%eax
c010447b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010447e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104485:	00 
c0104486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104489:	89 04 24             	mov    %eax,(%esp)
c010448c:	e8 06 0c 00 00       	call   c0105097 <free_pages>
    free_pages(p1, 3);
c0104491:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104498:	00 
c0104499:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010449c:	89 04 24             	mov    %eax,(%esp)
c010449f:	e8 f3 0b 00 00       	call   c0105097 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01044a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044a7:	83 c0 04             	add    $0x4,%eax
c01044aa:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01044b1:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01044b4:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01044b7:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01044ba:	0f a3 10             	bt     %edx,(%eax)
c01044bd:	19 c0                	sbb    %eax,%eax
c01044bf:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01044c2:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01044c6:	0f 95 c0             	setne  %al
c01044c9:	0f b6 c0             	movzbl %al,%eax
c01044cc:	85 c0                	test   %eax,%eax
c01044ce:	74 0b                	je     c01044db <default_check+0x3c3>
c01044d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044d3:	8b 40 08             	mov    0x8(%eax),%eax
c01044d6:	83 f8 01             	cmp    $0x1,%eax
c01044d9:	74 24                	je     c01044ff <default_check+0x3e7>
c01044db:	c7 44 24 0c 98 7e 10 	movl   $0xc0107e98,0xc(%esp)
c01044e2:	c0 
c01044e3:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c01044ea:	c0 
c01044eb:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c01044f2:	00 
c01044f3:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c01044fa:	e8 c7 c7 ff ff       	call   c0100cc6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01044ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104502:	83 c0 04             	add    $0x4,%eax
c0104505:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010450c:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010450f:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104512:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104515:	0f a3 10             	bt     %edx,(%eax)
c0104518:	19 c0                	sbb    %eax,%eax
c010451a:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010451d:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104521:	0f 95 c0             	setne  %al
c0104524:	0f b6 c0             	movzbl %al,%eax
c0104527:	85 c0                	test   %eax,%eax
c0104529:	74 0b                	je     c0104536 <default_check+0x41e>
c010452b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010452e:	8b 40 08             	mov    0x8(%eax),%eax
c0104531:	83 f8 03             	cmp    $0x3,%eax
c0104534:	74 24                	je     c010455a <default_check+0x442>
c0104536:	c7 44 24 0c c0 7e 10 	movl   $0xc0107ec0,0xc(%esp)
c010453d:	c0 
c010453e:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104545:	c0 
c0104546:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c010454d:	00 
c010454e:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104555:	e8 6c c7 ff ff       	call   c0100cc6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010455a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104561:	e8 f9 0a 00 00       	call   c010505f <alloc_pages>
c0104566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104569:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010456c:	83 e8 14             	sub    $0x14,%eax
c010456f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104572:	74 24                	je     c0104598 <default_check+0x480>
c0104574:	c7 44 24 0c e6 7e 10 	movl   $0xc0107ee6,0xc(%esp)
c010457b:	c0 
c010457c:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104583:	c0 
c0104584:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c010458b:	00 
c010458c:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104593:	e8 2e c7 ff ff       	call   c0100cc6 <__panic>
    free_page(p0);
c0104598:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010459f:	00 
c01045a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045a3:	89 04 24             	mov    %eax,(%esp)
c01045a6:	e8 ec 0a 00 00       	call   c0105097 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01045ab:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01045b2:	e8 a8 0a 00 00       	call   c010505f <alloc_pages>
c01045b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01045ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01045bd:	83 c0 14             	add    $0x14,%eax
c01045c0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01045c3:	74 24                	je     c01045e9 <default_check+0x4d1>
c01045c5:	c7 44 24 0c 04 7f 10 	movl   $0xc0107f04,0xc(%esp)
c01045cc:	c0 
c01045cd:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c01045d4:	c0 
c01045d5:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01045dc:	00 
c01045dd:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c01045e4:	e8 dd c6 ff ff       	call   c0100cc6 <__panic>

    free_pages(p0, 2);
c01045e9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01045f0:	00 
c01045f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045f4:	89 04 24             	mov    %eax,(%esp)
c01045f7:	e8 9b 0a 00 00       	call   c0105097 <free_pages>
    free_page(p2);
c01045fc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104603:	00 
c0104604:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104607:	89 04 24             	mov    %eax,(%esp)
c010460a:	e8 88 0a 00 00       	call   c0105097 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010460f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104616:	e8 44 0a 00 00       	call   c010505f <alloc_pages>
c010461b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010461e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104622:	75 24                	jne    c0104648 <default_check+0x530>
c0104624:	c7 44 24 0c 24 7f 10 	movl   $0xc0107f24,0xc(%esp)
c010462b:	c0 
c010462c:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104633:	c0 
c0104634:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c010463b:	00 
c010463c:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104643:	e8 7e c6 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c0104648:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010464f:	e8 0b 0a 00 00       	call   c010505f <alloc_pages>
c0104654:	85 c0                	test   %eax,%eax
c0104656:	74 24                	je     c010467c <default_check+0x564>
c0104658:	c7 44 24 0c 82 7d 10 	movl   $0xc0107d82,0xc(%esp)
c010465f:	c0 
c0104660:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104667:	c0 
c0104668:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c010466f:	00 
c0104670:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104677:	e8 4a c6 ff ff       	call   c0100cc6 <__panic>

    assert(nr_free == 0);
c010467c:	a1 88 7d 1b c0       	mov    0xc01b7d88,%eax
c0104681:	85 c0                	test   %eax,%eax
c0104683:	74 24                	je     c01046a9 <default_check+0x591>
c0104685:	c7 44 24 0c d5 7d 10 	movl   $0xc0107dd5,0xc(%esp)
c010468c:	c0 
c010468d:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104694:	c0 
c0104695:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c010469c:	00 
c010469d:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c01046a4:	e8 1d c6 ff ff       	call   c0100cc6 <__panic>
    nr_free = nr_free_store;
c01046a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046ac:	a3 88 7d 1b c0       	mov    %eax,0xc01b7d88

    free_list = free_list_store;
c01046b1:	8b 45 80             	mov    -0x80(%ebp),%eax
c01046b4:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01046b7:	a3 80 7d 1b c0       	mov    %eax,0xc01b7d80
c01046bc:	89 15 84 7d 1b c0    	mov    %edx,0xc01b7d84
    free_pages(p0, 5);
c01046c2:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01046c9:	00 
c01046ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046cd:	89 04 24             	mov    %eax,(%esp)
c01046d0:	e8 c2 09 00 00       	call   c0105097 <free_pages>

    le = &free_list;
c01046d5:	c7 45 ec 80 7d 1b c0 	movl   $0xc01b7d80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01046dc:	eb 1d                	jmp    c01046fb <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01046de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046e1:	83 e8 0c             	sub    $0xc,%eax
c01046e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01046e7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01046eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01046ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01046f1:	8b 40 08             	mov    0x8(%eax),%eax
c01046f4:	29 c2                	sub    %eax,%edx
c01046f6:	89 d0                	mov    %edx,%eax
c01046f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01046fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046fe:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104701:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104704:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104707:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010470a:	81 7d ec 80 7d 1b c0 	cmpl   $0xc01b7d80,-0x14(%ebp)
c0104711:	75 cb                	jne    c01046de <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104713:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104717:	74 24                	je     c010473d <default_check+0x625>
c0104719:	c7 44 24 0c 42 7f 10 	movl   $0xc0107f42,0xc(%esp)
c0104720:	c0 
c0104721:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104728:	c0 
c0104729:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0104730:	00 
c0104731:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104738:	e8 89 c5 ff ff       	call   c0100cc6 <__panic>
    assert(total == 0);
c010473d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104741:	74 24                	je     c0104767 <default_check+0x64f>
c0104743:	c7 44 24 0c 4d 7f 10 	movl   $0xc0107f4d,0xc(%esp)
c010474a:	c0 
c010474b:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104752:	c0 
c0104753:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010475a:	00 
c010475b:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104762:	e8 5f c5 ff ff       	call   c0100cc6 <__panic>
}
c0104767:	81 c4 94 00 00 00    	add    $0x94,%esp
c010476d:	5b                   	pop    %ebx
c010476e:	5d                   	pop    %ebp
c010476f:	c3                   	ret    

c0104770 <ff_init_memmap>:


static void
ff_init_memmap(struct Page *base, size_t n) {
c0104770:	55                   	push   %ebp
c0104771:	89 e5                	mov    %esp,%ebp
c0104773:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0104776:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010477a:	75 24                	jne    c01047a0 <ff_init_memmap+0x30>
c010477c:	c7 44 24 0c f4 7b 10 	movl   $0xc0107bf4,0xc(%esp)
c0104783:	c0 
c0104784:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c010478b:	c0 
c010478c:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0104793:	00 
c0104794:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c010479b:	e8 26 c5 ff ff       	call   c0100cc6 <__panic>
    struct Page *p = base;
c01047a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01047a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01047a6:	e9 96 00 00 00       	jmp    c0104841 <ff_init_memmap+0xd1>
        assert(PageReserved(p));
c01047ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047ae:	83 c0 04             	add    $0x4,%eax
c01047b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01047b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01047bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047be:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01047c1:	0f a3 10             	bt     %edx,(%eax)
c01047c4:	19 c0                	sbb    %eax,%eax
c01047c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01047c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01047cd:	0f 95 c0             	setne  %al
c01047d0:	0f b6 c0             	movzbl %al,%eax
c01047d3:	85 c0                	test   %eax,%eax
c01047d5:	75 24                	jne    c01047fb <ff_init_memmap+0x8b>
c01047d7:	c7 44 24 0c 25 7c 10 	movl   $0xc0107c25,0xc(%esp)
c01047de:	c0 
c01047df:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c01047e6:	c0 
c01047e7:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01047ee:	00 
c01047ef:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c01047f6:	e8 cb c4 ff ff       	call   c0100cc6 <__panic>
        p->flags = p->property = 0;
c01047fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104805:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104808:	8b 50 08             	mov    0x8(%eax),%edx
c010480b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010480e:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0104811:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104818:	00 
c0104819:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010481c:	89 04 24             	mov    %eax,(%esp)
c010481f:	e8 fe ed ff ff       	call   c0103622 <set_page_ref>
        SetPageProperty(p);
c0104824:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104827:	83 c0 04             	add    $0x4,%eax
c010482a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0104831:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104834:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104837:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010483a:	0f ab 10             	bts    %edx,(%eax)

static void
ff_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c010483d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104841:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104844:	89 d0                	mov    %edx,%eax
c0104846:	c1 e0 02             	shl    $0x2,%eax
c0104849:	01 d0                	add    %edx,%eax
c010484b:	c1 e0 02             	shl    $0x2,%eax
c010484e:	89 c2                	mov    %eax,%edx
c0104850:	8b 45 08             	mov    0x8(%ebp),%eax
c0104853:	01 d0                	add    %edx,%eax
c0104855:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104858:	0f 85 4d ff ff ff    	jne    c01047ab <ff_init_memmap+0x3b>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
        SetPageProperty(p);
    }
    base->property = n;
c010485e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104861:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104864:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104867:	8b 45 08             	mov    0x8(%ebp),%eax
c010486a:	83 c0 04             	add    $0x4,%eax
c010486d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0104874:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104877:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010487a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010487d:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0104880:	8b 15 88 7d 1b c0    	mov    0xc01b7d88,%edx
c0104886:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104889:	01 d0                	add    %edx,%eax
c010488b:	a3 88 7d 1b c0       	mov    %eax,0xc01b7d88
    list_add(&free_list, &(base->page_link));
c0104890:	8b 45 08             	mov    0x8(%ebp),%eax
c0104893:	83 c0 0c             	add    $0xc,%eax
c0104896:	c7 45 d4 80 7d 1b c0 	movl   $0xc01b7d80,-0x2c(%ebp)
c010489d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01048a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01048a3:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01048a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01048a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01048ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01048af:	8b 40 04             	mov    0x4(%eax),%eax
c01048b2:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01048b5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c01048b8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01048bb:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01048be:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01048c1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01048c4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01048c7:	89 10                	mov    %edx,(%eax)
c01048c9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01048cc:	8b 10                	mov    (%eax),%edx
c01048ce:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01048d1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01048d4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01048d7:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01048da:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01048dd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01048e0:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01048e3:	89 10                	mov    %edx,(%eax)
}
c01048e5:	c9                   	leave  
c01048e6:	c3                   	ret    

c01048e7 <ff_alloc_pages>:

static struct Page *
ff_alloc_pages(size_t n) {
c01048e7:	55                   	push   %ebp
c01048e8:	89 e5                	mov    %esp,%ebp
c01048ea:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01048ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01048f1:	75 24                	jne    c0104917 <ff_alloc_pages+0x30>
c01048f3:	c7 44 24 0c f4 7b 10 	movl   $0xc0107bf4,0xc(%esp)
c01048fa:	c0 
c01048fb:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104902:	c0 
c0104903:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c010490a:	00 
c010490b:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104912:	e8 af c3 ff ff       	call   c0100cc6 <__panic>
    if (n > nr_free) {
c0104917:	a1 88 7d 1b c0       	mov    0xc01b7d88,%eax
c010491c:	3b 45 08             	cmp    0x8(%ebp),%eax
c010491f:	73 0a                	jae    c010492b <ff_alloc_pages+0x44>
        return NULL;
c0104921:	b8 00 00 00 00       	mov    $0x0,%eax
c0104926:	e9 52 01 00 00       	jmp    c0104a7d <ff_alloc_pages+0x196>
    }
    struct Page *page = NULL;
c010492b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104932:	c7 45 f0 80 7d 1b c0 	movl   $0xc01b7d80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104939:	eb 1c                	jmp    c0104957 <ff_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c010493b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010493e:	83 e8 0c             	sub    $0xc,%eax
c0104941:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0104944:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104947:	8b 40 08             	mov    0x8(%eax),%eax
c010494a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010494d:	72 08                	jb     c0104957 <ff_alloc_pages+0x70>
            page = p;
c010494f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104952:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0104955:	eb 18                	jmp    c010496f <ff_alloc_pages+0x88>
c0104957:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010495a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010495d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104960:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104963:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104966:	81 7d f0 80 7d 1b c0 	cmpl   $0xc01b7d80,-0x10(%ebp)
c010496d:	75 cc                	jne    c010493b <ff_alloc_pages+0x54>
            page = p;
            break;
        }
    }
    //以下处理目标块
    if (page != NULL) {
c010496f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104973:	0f 84 01 01 00 00    	je     c0104a7a <ff_alloc_pages+0x193>
        /*start add*/
        int i;
        for(i=0;i<n;i++)
c0104979:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104980:	eb 2e                	jmp    c01049b0 <ff_alloc_pages+0xc9>
        {
            ClearPageProperty(page+i);
c0104982:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104985:	89 d0                	mov    %edx,%eax
c0104987:	c1 e0 02             	shl    $0x2,%eax
c010498a:	01 d0                	add    %edx,%eax
c010498c:	c1 e0 02             	shl    $0x2,%eax
c010498f:	89 c2                	mov    %eax,%edx
c0104991:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104994:	01 d0                	add    %edx,%eax
c0104996:	83 c0 04             	add    $0x4,%eax
c0104999:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c01049a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01049a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01049a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049a9:	0f b3 10             	btr    %edx,(%eax)
    }
    //以下处理目标块
    if (page != NULL) {
        /*start add*/
        int i;
        for(i=0;i<n;i++)
c01049ac:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01049b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049b3:	3b 45 08             	cmp    0x8(%ebp),%eax
c01049b6:	72 ca                	jb     c0104982 <ff_alloc_pages+0x9b>
        {
            ClearPageProperty(page+i);
        }//更改分配后的页标记
        /*end add*/
        
        if (page->property > n) {
c01049b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049bb:	8b 40 08             	mov    0x8(%eax),%eax
c01049be:	3b 45 08             	cmp    0x8(%ebp),%eax
c01049c1:	76 7f                	jbe    c0104a42 <ff_alloc_pages+0x15b>
            struct Page *p = page + n;
c01049c3:	8b 55 08             	mov    0x8(%ebp),%edx
c01049c6:	89 d0                	mov    %edx,%eax
c01049c8:	c1 e0 02             	shl    $0x2,%eax
c01049cb:	01 d0                	add    %edx,%eax
c01049cd:	c1 e0 02             	shl    $0x2,%eax
c01049d0:	89 c2                	mov    %eax,%edx
c01049d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d5:	01 d0                	add    %edx,%eax
c01049d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n;
c01049da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049dd:	8b 40 08             	mov    0x8(%eax),%eax
c01049e0:	2b 45 08             	sub    0x8(%ebp),%eax
c01049e3:	89 c2                	mov    %eax,%edx
c01049e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049e8:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(page->page_link), &(p->page_link));  //把原来的指针指向剩下的的空闲块首页--双指针妙啊
c01049eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049ee:	83 c0 0c             	add    $0xc,%eax
c01049f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01049f4:	83 c2 0c             	add    $0xc,%edx
c01049f7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01049fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01049fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104a00:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0104a03:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a06:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104a09:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104a0c:	8b 40 04             	mov    0x4(%eax),%eax
c0104a0f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104a12:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104a15:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104a18:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104a1b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104a1e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104a21:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104a24:	89 10                	mov    %edx,(%eax)
c0104a26:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104a29:	8b 10                	mov    (%eax),%edx
c0104a2b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104a2e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104a31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104a34:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104a37:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104a3a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104a3d:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104a40:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));//把原来的删掉
c0104a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a45:	83 c0 0c             	add    $0xc,%eax
c0104a48:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104a4b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104a4e:	8b 40 04             	mov    0x4(%eax),%eax
c0104a51:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104a54:	8b 12                	mov    (%edx),%edx
c0104a56:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c0104a59:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104a5c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104a5f:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104a62:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104a65:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104a68:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104a6b:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0104a6d:	a1 88 7d 1b c0       	mov    0xc01b7d88,%eax
c0104a72:	2b 45 08             	sub    0x8(%ebp),%eax
c0104a75:	a3 88 7d 1b c0       	mov    %eax,0xc01b7d88
        
    }
    
    return page;
c0104a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  /*或许应该更新链表序列*/

}
c0104a7d:	c9                   	leave  
c0104a7e:	c3                   	ret    

c0104a7f <merge_backward>:

static bool merge_backward(struct Page *base)
{
c0104a7f:	55                   	push   %ebp
c0104a80:	89 e5                	mov    %esp,%ebp
c0104a82:	83 ec 30             	sub    $0x30,%esp
    //bool flag=true;

    list_entry_t *le_nx=list_next(&(base->page_link));
c0104a85:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a88:	83 c0 0c             	add    $0xc,%eax
c0104a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a91:	8b 40 04             	mov    0x4(%eax),%eax
c0104a94:	89 45 fc             	mov    %eax,-0x4(%ebp)

    if(le_nx==&free_list) return 0;
c0104a97:	81 7d fc 80 7d 1b c0 	cmpl   $0xc01b7d80,-0x4(%ebp)
c0104a9e:	75 0a                	jne    c0104aaa <merge_backward+0x2b>
c0104aa0:	b8 00 00 00 00       	mov    $0x0,%eax
c0104aa5:	e9 aa 00 00 00       	jmp    c0104b54 <merge_backward+0xd5>
    struct Page *p = le2page(le_nx,page_link);
c0104aaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104aad:	83 e8 0c             	sub    $0xc,%eax
c0104ab0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if(PageProperty(p)==0) return 0;
c0104ab3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104ab6:	83 c0 04             	add    $0x4,%eax
c0104ab9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0104ac0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ac6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104ac9:	0f a3 10             	bt     %edx,(%eax)
c0104acc:	19 c0                	sbb    %eax,%eax
c0104ace:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0104ad1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104ad5:	0f 95 c0             	setne  %al
c0104ad8:	0f b6 c0             	movzbl %al,%eax
c0104adb:	85 c0                	test   %eax,%eax
c0104add:	75 07                	jne    c0104ae6 <merge_backward+0x67>
c0104adf:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ae4:	eb 6e                	jmp    c0104b54 <merge_backward+0xd5>
    if(base+base->property!=p) return 0;
c0104ae6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ae9:	8b 50 08             	mov    0x8(%eax),%edx
c0104aec:	89 d0                	mov    %edx,%eax
c0104aee:	c1 e0 02             	shl    $0x2,%eax
c0104af1:	01 d0                	add    %edx,%eax
c0104af3:	c1 e0 02             	shl    $0x2,%eax
c0104af6:	89 c2                	mov    %eax,%edx
c0104af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104afb:	01 d0                	add    %edx,%eax
c0104afd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0104b00:	74 07                	je     c0104b09 <merge_backward+0x8a>
c0104b02:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b07:	eb 4b                	jmp    c0104b54 <merge_backward+0xd5>

    base->property=base->property+p->property;//合并，更新base
c0104b09:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b0c:	8b 50 08             	mov    0x8(%eax),%edx
c0104b0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104b12:	8b 40 08             	mov    0x8(%eax),%eax
c0104b15:	01 c2                	add    %eax,%edx
c0104b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b1a:	89 50 08             	mov    %edx,0x8(%eax)
    p->property=0;
c0104b1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104b20:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104b27:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104b2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104b2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b30:	8b 40 04             	mov    0x4(%eax),%eax
c0104b33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104b36:	8b 12                	mov    (%edx),%edx
c0104b38:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0104b3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104b3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104b41:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104b44:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104b47:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104b4d:	89 10                	mov    %edx,(%eax)
    list_del(le_nx);    

    return 1;
c0104b4f:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0104b54:	c9                   	leave  
c0104b55:	c3                   	ret    

c0104b56 <ff_free_pages>:

static void
ff_free_pages(struct Page *base, size_t n) {
c0104b56:	55                   	push   %ebp
c0104b57:	89 e5                	mov    %esp,%ebp
c0104b59:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0104b5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104b60:	75 24                	jne    c0104b86 <ff_free_pages+0x30>
c0104b62:	c7 44 24 0c f4 7b 10 	movl   $0xc0107bf4,0xc(%esp)
c0104b69:	c0 
c0104b6a:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104b71:	c0 
c0104b72:	c7 44 24 04 5c 01 00 	movl   $0x15c,0x4(%esp)
c0104b79:	00 
c0104b7a:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104b81:	e8 40 c1 ff ff       	call   c0100cc6 <__panic>
    struct Page *p = base;
c0104b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104b8c:	e9 b6 00 00 00       	jmp    c0104c47 <ff_free_pages+0xf1>
        assert(!PageReserved(p) && !PageProperty(p));
c0104b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b94:	83 c0 04             	add    $0x4,%eax
c0104b97:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104b9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104ba1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ba4:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104ba7:	0f a3 10             	bt     %edx,(%eax)
c0104baa:	19 c0                	sbb    %eax,%eax
c0104bac:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0104baf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104bb3:	0f 95 c0             	setne  %al
c0104bb6:	0f b6 c0             	movzbl %al,%eax
c0104bb9:	85 c0                	test   %eax,%eax
c0104bbb:	75 2c                	jne    c0104be9 <ff_free_pages+0x93>
c0104bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bc0:	83 c0 04             	add    $0x4,%eax
c0104bc3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0104bca:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104bcd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104bd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104bd3:	0f a3 10             	bt     %edx,(%eax)
c0104bd6:	19 c0                	sbb    %eax,%eax
c0104bd8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c0104bdb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104bdf:	0f 95 c0             	setne  %al
c0104be2:	0f b6 c0             	movzbl %al,%eax
c0104be5:	85 c0                	test   %eax,%eax
c0104be7:	74 24                	je     c0104c0d <ff_free_pages+0xb7>
c0104be9:	c7 44 24 0c 38 7c 10 	movl   $0xc0107c38,0xc(%esp)
c0104bf0:	c0 
c0104bf1:	c7 44 24 08 fa 7b 10 	movl   $0xc0107bfa,0x8(%esp)
c0104bf8:	c0 
c0104bf9:	c7 44 24 04 5f 01 00 	movl   $0x15f,0x4(%esp)
c0104c00:	00 
c0104c01:	c7 04 24 0f 7c 10 c0 	movl   $0xc0107c0f,(%esp)
c0104c08:	e8 b9 c0 ff ff       	call   c0100cc6 <__panic>
        p->flags = 0;   //标记为空闲
c0104c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c0104c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c1a:	83 c0 04             	add    $0x4,%eax
c0104c1d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104c24:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104c27:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104c2a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104c2d:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0); //清空引用计数
c0104c30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104c37:	00 
c0104c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c3b:	89 04 24             	mov    %eax,(%esp)
c0104c3e:	e8 df e9 ff ff       	call   c0103622 <set_page_ref>

static void
ff_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0104c43:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104c47:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104c4a:	89 d0                	mov    %edx,%eax
c0104c4c:	c1 e0 02             	shl    $0x2,%eax
c0104c4f:	01 d0                	add    %edx,%eax
c0104c51:	c1 e0 02             	shl    $0x2,%eax
c0104c54:	89 c2                	mov    %eax,%edx
c0104c56:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c59:	01 d0                	add    %edx,%eax
c0104c5b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104c5e:	0f 85 2d ff ff ff    	jne    c0104b91 <ff_free_pages+0x3b>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;   //标记为空闲
        SetPageProperty(p);
        set_page_ref(p, 0); //清空引用计数
    }
    base->property = n; //设置空闲块大小--- Q
c0104c64:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c67:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104c6a:	89 50 08             	mov    %edx,0x8(%eax)
c0104c6d:	c7 45 c8 80 7d 1b c0 	movl   $0xc01b7d80,-0x38(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104c74:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104c77:	8b 40 04             	mov    0x4(%eax),%eax
    
    list_entry_t *le = list_next(&free_list);   //------疑惑：这是在找什么
c0104c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while ((le != &free_list)&&(le<(&(base->page_link)))) 
c0104c7d:	eb 0f                	jmp    c0104c8e <ff_free_pages+0x138>
c0104c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c82:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104c85:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104c88:	8b 40 04             	mov    0x4(%eax),%eax
    { 
        le = list_next(le);
c0104c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        set_page_ref(p, 0); //清空引用计数
    }
    base->property = n; //设置空闲块大小--- Q
    
    list_entry_t *le = list_next(&free_list);   //------疑惑：这是在找什么
    while ((le != &free_list)&&(le<(&(base->page_link)))) 
c0104c8e:	81 7d f0 80 7d 1b c0 	cmpl   $0xc01b7d80,-0x10(%ebp)
c0104c95:	74 0b                	je     c0104ca2 <ff_free_pages+0x14c>
c0104c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c9a:	83 c0 0c             	add    $0xc,%eax
c0104c9d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104ca0:	77 dd                	ja     c0104c7f <ff_free_pages+0x129>
    { 
        le = list_next(le);
    } //遍历存放空闲块的列表
    list_add_before(le,&(base->page_link));
c0104ca2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ca5:	8d 50 0c             	lea    0xc(%eax),%edx
c0104ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cab:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0104cae:	89 55 bc             	mov    %edx,-0x44(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104cb1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104cb4:	8b 00                	mov    (%eax),%eax
c0104cb6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104cb9:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0104cbc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0104cbf:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104cc2:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104cc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104cc8:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104ccb:	89 10                	mov    %edx,(%eax)
c0104ccd:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104cd0:	8b 10                	mov    (%eax),%edx
c0104cd2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104cd5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104cd8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104cdb:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104cde:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104ce1:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104ce4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104ce7:	89 10                	mov    %edx,(%eax)
    nr_free += n;
c0104ce9:	8b 15 88 7d 1b c0    	mov    0xc01b7d88,%edx
c0104cef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104cf2:	01 d0                	add    %edx,%eax
c0104cf4:	a3 88 7d 1b c0       	mov    %eax,0xc01b7d88
    /*以下开始合并*/
    //backward
    while(merge_backward(base));
c0104cf9:	90                   	nop
c0104cfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cfd:	89 04 24             	mov    %eax,(%esp)
c0104d00:	e8 7a fd ff ff       	call   c0104a7f <merge_backward>
c0104d05:	85 c0                	test   %eax,%eax
c0104d07:	75 f1                	jne    c0104cfa <ff_free_pages+0x1a4>
    //forward
    list_entry_t *i;
    for ( i= list_prev(&(base->page_link)); i!= &free_list; i = list_prev(i))
c0104d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d0c:	83 c0 0c             	add    $0xc,%eax
c0104d0f:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0104d12:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104d15:	8b 00                	mov    (%eax),%eax
c0104d17:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104d1a:	eb 22                	jmp    c0104d3e <ff_free_pages+0x1e8>
    { 
        // 将新插入的空闲块和其物理地址小的一段的所有相邻的物理空闲块进行合并
        if (!merge_backward(le2page(i, page_link))) break;//断一次就结束
c0104d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d1f:	83 e8 0c             	sub    $0xc,%eax
c0104d22:	89 04 24             	mov    %eax,(%esp)
c0104d25:	e8 55 fd ff ff       	call   c0104a7f <merge_backward>
c0104d2a:	85 c0                	test   %eax,%eax
c0104d2c:	75 02                	jne    c0104d30 <ff_free_pages+0x1da>
c0104d2e:	eb 17                	jmp    c0104d47 <ff_free_pages+0x1f1>
c0104d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d33:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104d36:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104d39:	8b 00                	mov    (%eax),%eax
    /*以下开始合并*/
    //backward
    while(merge_backward(base));
    //forward
    list_entry_t *i;
    for ( i= list_prev(&(base->page_link)); i!= &free_list; i = list_prev(i))
c0104d3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104d3e:	81 7d ec 80 7d 1b c0 	cmpl   $0xc01b7d80,-0x14(%ebp)
c0104d45:	75 d5                	jne    c0104d1c <ff_free_pages+0x1c6>
        // 将新插入的空闲块和其物理地址小的一段的所有相邻的物理空闲块进行合并
        if (!merge_backward(le2page(i, page_link))) break;//断一次就结束
    }
    
    
}
c0104d47:	c9                   	leave  
c0104d48:	c3                   	ret    

c0104d49 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104d49:	55                   	push   %ebp
c0104d4a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104d4c:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d4f:	a1 a8 23 2a c0       	mov    0xc02a23a8,%eax
c0104d54:	29 c2                	sub    %eax,%edx
c0104d56:	89 d0                	mov    %edx,%eax
c0104d58:	c1 f8 02             	sar    $0x2,%eax
c0104d5b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104d61:	5d                   	pop    %ebp
c0104d62:	c3                   	ret    

c0104d63 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104d63:	55                   	push   %ebp
c0104d64:	89 e5                	mov    %esp,%ebp
c0104d66:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104d69:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d6c:	89 04 24             	mov    %eax,(%esp)
c0104d6f:	e8 d5 ff ff ff       	call   c0104d49 <page2ppn>
c0104d74:	c1 e0 0c             	shl    $0xc,%eax
}
c0104d77:	c9                   	leave  
c0104d78:	c3                   	ret    

c0104d79 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104d79:	55                   	push   %ebp
c0104d7a:	89 e5                	mov    %esp,%ebp
c0104d7c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104d7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d82:	c1 e8 0c             	shr    $0xc,%eax
c0104d85:	89 c2                	mov    %eax,%edx
c0104d87:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c0104d8c:	39 c2                	cmp    %eax,%edx
c0104d8e:	72 1c                	jb     c0104dac <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104d90:	c7 44 24 08 88 7f 10 	movl   $0xc0107f88,0x8(%esp)
c0104d97:	c0 
c0104d98:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0104d9f:	00 
c0104da0:	c7 04 24 a7 7f 10 c0 	movl   $0xc0107fa7,(%esp)
c0104da7:	e8 1a bf ff ff       	call   c0100cc6 <__panic>
    }
    return &pages[PPN(pa)];
c0104dac:	8b 0d a8 23 2a c0    	mov    0xc02a23a8,%ecx
c0104db2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104db5:	c1 e8 0c             	shr    $0xc,%eax
c0104db8:	89 c2                	mov    %eax,%edx
c0104dba:	89 d0                	mov    %edx,%eax
c0104dbc:	c1 e0 02             	shl    $0x2,%eax
c0104dbf:	01 d0                	add    %edx,%eax
c0104dc1:	c1 e0 02             	shl    $0x2,%eax
c0104dc4:	01 c8                	add    %ecx,%eax
}
c0104dc6:	c9                   	leave  
c0104dc7:	c3                   	ret    

c0104dc8 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104dc8:	55                   	push   %ebp
c0104dc9:	89 e5                	mov    %esp,%ebp
c0104dcb:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104dce:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dd1:	89 04 24             	mov    %eax,(%esp)
c0104dd4:	e8 8a ff ff ff       	call   c0104d63 <page2pa>
c0104dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ddf:	c1 e8 0c             	shr    $0xc,%eax
c0104de2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104de5:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c0104dea:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104ded:	72 23                	jb     c0104e12 <page2kva+0x4a>
c0104def:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104df2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104df6:	c7 44 24 08 b8 7f 10 	movl   $0xc0107fb8,0x8(%esp)
c0104dfd:	c0 
c0104dfe:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0104e05:	00 
c0104e06:	c7 04 24 a7 7f 10 c0 	movl   $0xc0107fa7,(%esp)
c0104e0d:	e8 b4 be ff ff       	call   c0100cc6 <__panic>
c0104e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e15:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104e1a:	c9                   	leave  
c0104e1b:	c3                   	ret    

c0104e1c <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104e1c:	55                   	push   %ebp
c0104e1d:	89 e5                	mov    %esp,%ebp
c0104e1f:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104e22:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e25:	83 e0 01             	and    $0x1,%eax
c0104e28:	85 c0                	test   %eax,%eax
c0104e2a:	75 1c                	jne    c0104e48 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104e2c:	c7 44 24 08 dc 7f 10 	movl   $0xc0107fdc,0x8(%esp)
c0104e33:	c0 
c0104e34:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0104e3b:	00 
c0104e3c:	c7 04 24 a7 7f 10 c0 	movl   $0xc0107fa7,(%esp)
c0104e43:	e8 7e be ff ff       	call   c0100cc6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104e48:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e50:	89 04 24             	mov    %eax,(%esp)
c0104e53:	e8 21 ff ff ff       	call   c0104d79 <pa2page>
}
c0104e58:	c9                   	leave  
c0104e59:	c3                   	ret    

c0104e5a <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104e5a:	55                   	push   %ebp
c0104e5b:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104e5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e60:	8b 00                	mov    (%eax),%eax
}
c0104e62:	5d                   	pop    %ebp
c0104e63:	c3                   	ret    

c0104e64 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104e64:	55                   	push   %ebp
c0104e65:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104e67:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e6d:	89 10                	mov    %edx,(%eax)
}
c0104e6f:	5d                   	pop    %ebp
c0104e70:	c3                   	ret    

c0104e71 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104e71:	55                   	push   %ebp
c0104e72:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104e74:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e77:	8b 00                	mov    (%eax),%eax
c0104e79:	8d 50 01             	lea    0x1(%eax),%edx
c0104e7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e7f:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104e81:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e84:	8b 00                	mov    (%eax),%eax
}
c0104e86:	5d                   	pop    %ebp
c0104e87:	c3                   	ret    

c0104e88 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104e88:	55                   	push   %ebp
c0104e89:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104e8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e8e:	8b 00                	mov    (%eax),%eax
c0104e90:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104e93:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e96:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104e98:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e9b:	8b 00                	mov    (%eax),%eax
}
c0104e9d:	5d                   	pop    %ebp
c0104e9e:	c3                   	ret    

c0104e9f <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104e9f:	55                   	push   %ebp
c0104ea0:	89 e5                	mov    %esp,%ebp
c0104ea2:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104ea5:	9c                   	pushf  
c0104ea6:	58                   	pop    %eax
c0104ea7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104ead:	25 00 02 00 00       	and    $0x200,%eax
c0104eb2:	85 c0                	test   %eax,%eax
c0104eb4:	74 0c                	je     c0104ec2 <__intr_save+0x23>
        intr_disable();
c0104eb6:	e8 ee c7 ff ff       	call   c01016a9 <intr_disable>
        return 1;
c0104ebb:	b8 01 00 00 00       	mov    $0x1,%eax
c0104ec0:	eb 05                	jmp    c0104ec7 <__intr_save+0x28>
    }
    return 0;
c0104ec2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ec7:	c9                   	leave  
c0104ec8:	c3                   	ret    

c0104ec9 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104ec9:	55                   	push   %ebp
c0104eca:	89 e5                	mov    %esp,%ebp
c0104ecc:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104ecf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104ed3:	74 05                	je     c0104eda <__intr_restore+0x11>
        intr_enable();
c0104ed5:	e8 c9 c7 ff ff       	call   c01016a3 <intr_enable>
    }
}
c0104eda:	c9                   	leave  
c0104edb:	c3                   	ret    

c0104edc <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104edc:	55                   	push   %ebp
c0104edd:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104edf:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ee2:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104ee5:	b8 23 00 00 00       	mov    $0x23,%eax
c0104eea:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104eec:	b8 23 00 00 00       	mov    $0x23,%eax
c0104ef1:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104ef3:	b8 10 00 00 00       	mov    $0x10,%eax
c0104ef8:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104efa:	b8 10 00 00 00       	mov    $0x10,%eax
c0104eff:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104f01:	b8 10 00 00 00       	mov    $0x10,%eax
c0104f06:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104f08:	ea 0f 4f 10 c0 08 00 	ljmp   $0x8,$0xc0104f0f
}
c0104f0f:	5d                   	pop    %ebp
c0104f10:	c3                   	ret    

c0104f11 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104f11:	55                   	push   %ebp
c0104f12:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104f14:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f17:	a3 e4 b8 11 c0       	mov    %eax,0xc011b8e4
}
c0104f1c:	5d                   	pop    %ebp
c0104f1d:	c3                   	ret    

c0104f1e <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104f1e:	55                   	push   %ebp
c0104f1f:	89 e5                	mov    %esp,%ebp
c0104f21:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104f24:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0104f29:	89 04 24             	mov    %eax,(%esp)
c0104f2c:	e8 e0 ff ff ff       	call   c0104f11 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104f31:	66 c7 05 e8 b8 11 c0 	movw   $0x10,0xc011b8e8
c0104f38:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104f3a:	66 c7 05 28 aa 11 c0 	movw   $0x68,0xc011aa28
c0104f41:	68 00 
c0104f43:	b8 e0 b8 11 c0       	mov    $0xc011b8e0,%eax
c0104f48:	66 a3 2a aa 11 c0    	mov    %ax,0xc011aa2a
c0104f4e:	b8 e0 b8 11 c0       	mov    $0xc011b8e0,%eax
c0104f53:	c1 e8 10             	shr    $0x10,%eax
c0104f56:	a2 2c aa 11 c0       	mov    %al,0xc011aa2c
c0104f5b:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0104f62:	83 e0 f0             	and    $0xfffffff0,%eax
c0104f65:	83 c8 09             	or     $0x9,%eax
c0104f68:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0104f6d:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0104f74:	83 e0 ef             	and    $0xffffffef,%eax
c0104f77:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0104f7c:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0104f83:	83 e0 9f             	and    $0xffffff9f,%eax
c0104f86:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0104f8b:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0104f92:	83 c8 80             	or     $0xffffff80,%eax
c0104f95:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0104f9a:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0104fa1:	83 e0 f0             	and    $0xfffffff0,%eax
c0104fa4:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0104fa9:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0104fb0:	83 e0 ef             	and    $0xffffffef,%eax
c0104fb3:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0104fb8:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0104fbf:	83 e0 df             	and    $0xffffffdf,%eax
c0104fc2:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0104fc7:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0104fce:	83 c8 40             	or     $0x40,%eax
c0104fd1:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0104fd6:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0104fdd:	83 e0 7f             	and    $0x7f,%eax
c0104fe0:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0104fe5:	b8 e0 b8 11 c0       	mov    $0xc011b8e0,%eax
c0104fea:	c1 e8 18             	shr    $0x18,%eax
c0104fed:	a2 2f aa 11 c0       	mov    %al,0xc011aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104ff2:	c7 04 24 30 aa 11 c0 	movl   $0xc011aa30,(%esp)
c0104ff9:	e8 de fe ff ff       	call   c0104edc <lgdt>
c0104ffe:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0105004:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0105008:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c010500b:	c9                   	leave  
c010500c:	c3                   	ret    

c010500d <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c010500d:	55                   	push   %ebp
c010500e:	89 e5                	mov    %esp,%ebp
c0105010:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &buddy_pmm_manager;
c0105013:	c7 05 a0 23 2a c0 d8 	movl   $0xc0107bd8,0xc02a23a0
c010501a:	7b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c010501d:	a1 a0 23 2a c0       	mov    0xc02a23a0,%eax
c0105022:	8b 00                	mov    (%eax),%eax
c0105024:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105028:	c7 04 24 08 80 10 c0 	movl   $0xc0108008,(%esp)
c010502f:	e8 08 b3 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0105034:	a1 a0 23 2a c0       	mov    0xc02a23a0,%eax
c0105039:	8b 40 04             	mov    0x4(%eax),%eax
c010503c:	ff d0                	call   *%eax
}
c010503e:	c9                   	leave  
c010503f:	c3                   	ret    

c0105040 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0105040:	55                   	push   %ebp
c0105041:	89 e5                	mov    %esp,%ebp
c0105043:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0105046:	a1 a0 23 2a c0       	mov    0xc02a23a0,%eax
c010504b:	8b 40 08             	mov    0x8(%eax),%eax
c010504e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105051:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105055:	8b 55 08             	mov    0x8(%ebp),%edx
c0105058:	89 14 24             	mov    %edx,(%esp)
c010505b:	ff d0                	call   *%eax
}
c010505d:	c9                   	leave  
c010505e:	c3                   	ret    

c010505f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c010505f:	55                   	push   %ebp
c0105060:	89 e5                	mov    %esp,%ebp
c0105062:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0105065:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010506c:	e8 2e fe ff ff       	call   c0104e9f <__intr_save>
c0105071:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0105074:	a1 a0 23 2a c0       	mov    0xc02a23a0,%eax
c0105079:	8b 40 0c             	mov    0xc(%eax),%eax
c010507c:	8b 55 08             	mov    0x8(%ebp),%edx
c010507f:	89 14 24             	mov    %edx,(%esp)
c0105082:	ff d0                	call   *%eax
c0105084:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0105087:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010508a:	89 04 24             	mov    %eax,(%esp)
c010508d:	e8 37 fe ff ff       	call   c0104ec9 <__intr_restore>
    return page;
c0105092:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105095:	c9                   	leave  
c0105096:	c3                   	ret    

c0105097 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0105097:	55                   	push   %ebp
c0105098:	89 e5                	mov    %esp,%ebp
c010509a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010509d:	e8 fd fd ff ff       	call   c0104e9f <__intr_save>
c01050a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01050a5:	a1 a0 23 2a c0       	mov    0xc02a23a0,%eax
c01050aa:	8b 40 10             	mov    0x10(%eax),%eax
c01050ad:	8b 55 0c             	mov    0xc(%ebp),%edx
c01050b0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050b4:	8b 55 08             	mov    0x8(%ebp),%edx
c01050b7:	89 14 24             	mov    %edx,(%esp)
c01050ba:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01050bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050bf:	89 04 24             	mov    %eax,(%esp)
c01050c2:	e8 02 fe ff ff       	call   c0104ec9 <__intr_restore>
}
c01050c7:	c9                   	leave  
c01050c8:	c3                   	ret    

c01050c9 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01050c9:	55                   	push   %ebp
c01050ca:	89 e5                	mov    %esp,%ebp
c01050cc:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01050cf:	e8 cb fd ff ff       	call   c0104e9f <__intr_save>
c01050d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01050d7:	a1 a0 23 2a c0       	mov    0xc02a23a0,%eax
c01050dc:	8b 40 14             	mov    0x14(%eax),%eax
c01050df:	ff d0                	call   *%eax
c01050e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01050e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050e7:	89 04 24             	mov    %eax,(%esp)
c01050ea:	e8 da fd ff ff       	call   c0104ec9 <__intr_restore>
    return ret;
c01050ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01050f2:	c9                   	leave  
c01050f3:	c3                   	ret    

c01050f4 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01050f4:	55                   	push   %ebp
c01050f5:	89 e5                	mov    %esp,%ebp
c01050f7:	57                   	push   %edi
c01050f8:	56                   	push   %esi
c01050f9:	53                   	push   %ebx
c01050fa:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0105100:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0105107:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c010510e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0105115:	c7 04 24 1f 80 10 c0 	movl   $0xc010801f,(%esp)
c010511c:	e8 1b b2 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105121:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105128:	e9 15 01 00 00       	jmp    c0105242 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010512d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105130:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105133:	89 d0                	mov    %edx,%eax
c0105135:	c1 e0 02             	shl    $0x2,%eax
c0105138:	01 d0                	add    %edx,%eax
c010513a:	c1 e0 02             	shl    $0x2,%eax
c010513d:	01 c8                	add    %ecx,%eax
c010513f:	8b 50 08             	mov    0x8(%eax),%edx
c0105142:	8b 40 04             	mov    0x4(%eax),%eax
c0105145:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0105148:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010514b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010514e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105151:	89 d0                	mov    %edx,%eax
c0105153:	c1 e0 02             	shl    $0x2,%eax
c0105156:	01 d0                	add    %edx,%eax
c0105158:	c1 e0 02             	shl    $0x2,%eax
c010515b:	01 c8                	add    %ecx,%eax
c010515d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0105160:	8b 58 10             	mov    0x10(%eax),%ebx
c0105163:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105166:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105169:	01 c8                	add    %ecx,%eax
c010516b:	11 da                	adc    %ebx,%edx
c010516d:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0105170:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0105173:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105176:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105179:	89 d0                	mov    %edx,%eax
c010517b:	c1 e0 02             	shl    $0x2,%eax
c010517e:	01 d0                	add    %edx,%eax
c0105180:	c1 e0 02             	shl    $0x2,%eax
c0105183:	01 c8                	add    %ecx,%eax
c0105185:	83 c0 14             	add    $0x14,%eax
c0105188:	8b 00                	mov    (%eax),%eax
c010518a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0105190:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105193:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105196:	83 c0 ff             	add    $0xffffffff,%eax
c0105199:	83 d2 ff             	adc    $0xffffffff,%edx
c010519c:	89 c6                	mov    %eax,%esi
c010519e:	89 d7                	mov    %edx,%edi
c01051a0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051a6:	89 d0                	mov    %edx,%eax
c01051a8:	c1 e0 02             	shl    $0x2,%eax
c01051ab:	01 d0                	add    %edx,%eax
c01051ad:	c1 e0 02             	shl    $0x2,%eax
c01051b0:	01 c8                	add    %ecx,%eax
c01051b2:	8b 48 0c             	mov    0xc(%eax),%ecx
c01051b5:	8b 58 10             	mov    0x10(%eax),%ebx
c01051b8:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01051be:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01051c2:	89 74 24 14          	mov    %esi,0x14(%esp)
c01051c6:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01051ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01051cd:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01051d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01051d4:	89 54 24 10          	mov    %edx,0x10(%esp)
c01051d8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01051dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01051e0:	c7 04 24 2c 80 10 c0 	movl   $0xc010802c,(%esp)
c01051e7:	e8 50 b1 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01051ec:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051f2:	89 d0                	mov    %edx,%eax
c01051f4:	c1 e0 02             	shl    $0x2,%eax
c01051f7:	01 d0                	add    %edx,%eax
c01051f9:	c1 e0 02             	shl    $0x2,%eax
c01051fc:	01 c8                	add    %ecx,%eax
c01051fe:	83 c0 14             	add    $0x14,%eax
c0105201:	8b 00                	mov    (%eax),%eax
c0105203:	83 f8 01             	cmp    $0x1,%eax
c0105206:	75 36                	jne    c010523e <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0105208:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010520b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010520e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0105211:	77 2b                	ja     c010523e <page_init+0x14a>
c0105213:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0105216:	72 05                	jb     c010521d <page_init+0x129>
c0105218:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c010521b:	73 21                	jae    c010523e <page_init+0x14a>
c010521d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0105221:	77 1b                	ja     c010523e <page_init+0x14a>
c0105223:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0105227:	72 09                	jb     c0105232 <page_init+0x13e>
c0105229:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0105230:	77 0c                	ja     c010523e <page_init+0x14a>
                maxpa = end;
c0105232:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105235:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105238:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010523b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010523e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105242:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105245:	8b 00                	mov    (%eax),%eax
c0105247:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010524a:	0f 8f dd fe ff ff    	jg     c010512d <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0105250:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105254:	72 1d                	jb     c0105273 <page_init+0x17f>
c0105256:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010525a:	77 09                	ja     c0105265 <page_init+0x171>
c010525c:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0105263:	76 0e                	jbe    c0105273 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0105265:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010526c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0105273:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105276:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105279:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010527d:	c1 ea 0c             	shr    $0xc,%edx
c0105280:	a3 c0 b8 11 c0       	mov    %eax,0xc011b8c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0105285:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c010528c:	b8 ac 23 2a c0       	mov    $0xc02a23ac,%eax
c0105291:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105294:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105297:	01 d0                	add    %edx,%eax
c0105299:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010529c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010529f:	ba 00 00 00 00       	mov    $0x0,%edx
c01052a4:	f7 75 ac             	divl   -0x54(%ebp)
c01052a7:	89 d0                	mov    %edx,%eax
c01052a9:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01052ac:	29 c2                	sub    %eax,%edx
c01052ae:	89 d0                	mov    %edx,%eax
c01052b0:	a3 a8 23 2a c0       	mov    %eax,0xc02a23a8

    for (i = 0; i < npage; i ++) {
c01052b5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01052bc:	eb 2f                	jmp    c01052ed <page_init+0x1f9>
        SetPageReserved(pages + i);
c01052be:	8b 0d a8 23 2a c0    	mov    0xc02a23a8,%ecx
c01052c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052c7:	89 d0                	mov    %edx,%eax
c01052c9:	c1 e0 02             	shl    $0x2,%eax
c01052cc:	01 d0                	add    %edx,%eax
c01052ce:	c1 e0 02             	shl    $0x2,%eax
c01052d1:	01 c8                	add    %ecx,%eax
c01052d3:	83 c0 04             	add    $0x4,%eax
c01052d6:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01052dd:	89 45 8c             	mov    %eax,-0x74(%ebp)
c01052e0:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01052e3:	8b 55 90             	mov    -0x70(%ebp),%edx
c01052e6:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01052e9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01052ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052f0:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c01052f5:	39 c2                	cmp    %eax,%edx
c01052f7:	72 c5                	jb     c01052be <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01052f9:	8b 15 c0 b8 11 c0    	mov    0xc011b8c0,%edx
c01052ff:	89 d0                	mov    %edx,%eax
c0105301:	c1 e0 02             	shl    $0x2,%eax
c0105304:	01 d0                	add    %edx,%eax
c0105306:	c1 e0 02             	shl    $0x2,%eax
c0105309:	89 c2                	mov    %eax,%edx
c010530b:	a1 a8 23 2a c0       	mov    0xc02a23a8,%eax
c0105310:	01 d0                	add    %edx,%eax
c0105312:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0105315:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c010531c:	77 23                	ja     c0105341 <page_init+0x24d>
c010531e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105321:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105325:	c7 44 24 08 5c 80 10 	movl   $0xc010805c,0x8(%esp)
c010532c:	c0 
c010532d:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0105334:	00 
c0105335:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c010533c:	e8 85 b9 ff ff       	call   c0100cc6 <__panic>
c0105341:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105344:	05 00 00 00 40       	add    $0x40000000,%eax
c0105349:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010534c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105353:	e9 74 01 00 00       	jmp    c01054cc <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0105358:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010535b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010535e:	89 d0                	mov    %edx,%eax
c0105360:	c1 e0 02             	shl    $0x2,%eax
c0105363:	01 d0                	add    %edx,%eax
c0105365:	c1 e0 02             	shl    $0x2,%eax
c0105368:	01 c8                	add    %ecx,%eax
c010536a:	8b 50 08             	mov    0x8(%eax),%edx
c010536d:	8b 40 04             	mov    0x4(%eax),%eax
c0105370:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105373:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105376:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105379:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010537c:	89 d0                	mov    %edx,%eax
c010537e:	c1 e0 02             	shl    $0x2,%eax
c0105381:	01 d0                	add    %edx,%eax
c0105383:	c1 e0 02             	shl    $0x2,%eax
c0105386:	01 c8                	add    %ecx,%eax
c0105388:	8b 48 0c             	mov    0xc(%eax),%ecx
c010538b:	8b 58 10             	mov    0x10(%eax),%ebx
c010538e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105391:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105394:	01 c8                	add    %ecx,%eax
c0105396:	11 da                	adc    %ebx,%edx
c0105398:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010539b:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010539e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01053a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053a4:	89 d0                	mov    %edx,%eax
c01053a6:	c1 e0 02             	shl    $0x2,%eax
c01053a9:	01 d0                	add    %edx,%eax
c01053ab:	c1 e0 02             	shl    $0x2,%eax
c01053ae:	01 c8                	add    %ecx,%eax
c01053b0:	83 c0 14             	add    $0x14,%eax
c01053b3:	8b 00                	mov    (%eax),%eax
c01053b5:	83 f8 01             	cmp    $0x1,%eax
c01053b8:	0f 85 0a 01 00 00    	jne    c01054c8 <page_init+0x3d4>
            if (begin < freemem) {
c01053be:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01053c1:	ba 00 00 00 00       	mov    $0x0,%edx
c01053c6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01053c9:	72 17                	jb     c01053e2 <page_init+0x2ee>
c01053cb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01053ce:	77 05                	ja     c01053d5 <page_init+0x2e1>
c01053d0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01053d3:	76 0d                	jbe    c01053e2 <page_init+0x2ee>
                begin = freemem;
c01053d5:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01053d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01053db:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01053e2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01053e6:	72 1d                	jb     c0105405 <page_init+0x311>
c01053e8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01053ec:	77 09                	ja     c01053f7 <page_init+0x303>
c01053ee:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01053f5:	76 0e                	jbe    c0105405 <page_init+0x311>
                end = KMEMSIZE;
c01053f7:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01053fe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0105405:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105408:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010540b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010540e:	0f 87 b4 00 00 00    	ja     c01054c8 <page_init+0x3d4>
c0105414:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105417:	72 09                	jb     c0105422 <page_init+0x32e>
c0105419:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010541c:	0f 83 a6 00 00 00    	jae    c01054c8 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0105422:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0105429:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010542c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010542f:	01 d0                	add    %edx,%eax
c0105431:	83 e8 01             	sub    $0x1,%eax
c0105434:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105437:	8b 45 98             	mov    -0x68(%ebp),%eax
c010543a:	ba 00 00 00 00       	mov    $0x0,%edx
c010543f:	f7 75 9c             	divl   -0x64(%ebp)
c0105442:	89 d0                	mov    %edx,%eax
c0105444:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105447:	29 c2                	sub    %eax,%edx
c0105449:	89 d0                	mov    %edx,%eax
c010544b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105450:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105453:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0105456:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105459:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010545c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010545f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105464:	89 c7                	mov    %eax,%edi
c0105466:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010546c:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010546f:	89 d0                	mov    %edx,%eax
c0105471:	83 e0 00             	and    $0x0,%eax
c0105474:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0105477:	8b 45 80             	mov    -0x80(%ebp),%eax
c010547a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010547d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105480:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0105483:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105486:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105489:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010548c:	77 3a                	ja     c01054c8 <page_init+0x3d4>
c010548e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105491:	72 05                	jb     c0105498 <page_init+0x3a4>
c0105493:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105496:	73 30                	jae    c01054c8 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0105498:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010549b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010549e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01054a1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01054a4:	29 c8                	sub    %ecx,%eax
c01054a6:	19 da                	sbb    %ebx,%edx
c01054a8:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01054ac:	c1 ea 0c             	shr    $0xc,%edx
c01054af:	89 c3                	mov    %eax,%ebx
c01054b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054b4:	89 04 24             	mov    %eax,(%esp)
c01054b7:	e8 bd f8 ff ff       	call   c0104d79 <pa2page>
c01054bc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01054c0:	89 04 24             	mov    %eax,(%esp)
c01054c3:	e8 78 fb ff ff       	call   c0105040 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01054c8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01054cc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01054cf:	8b 00                	mov    (%eax),%eax
c01054d1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01054d4:	0f 8f 7e fe ff ff    	jg     c0105358 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01054da:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01054e0:	5b                   	pop    %ebx
c01054e1:	5e                   	pop    %esi
c01054e2:	5f                   	pop    %edi
c01054e3:	5d                   	pop    %ebp
c01054e4:	c3                   	ret    

c01054e5 <enable_paging>:

static void
enable_paging(void) {
c01054e5:	55                   	push   %ebp
c01054e6:	89 e5                	mov    %esp,%ebp
c01054e8:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01054eb:	a1 a4 23 2a c0       	mov    0xc02a23a4,%eax
c01054f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01054f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01054f6:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01054f9:	0f 20 c0             	mov    %cr0,%eax
c01054fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01054ff:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0105502:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0105505:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010550c:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0105510:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105513:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0105516:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105519:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010551c:	c9                   	leave  
c010551d:	c3                   	ret    

c010551e <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010551e:	55                   	push   %ebp
c010551f:	89 e5                	mov    %esp,%ebp
c0105521:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0105524:	8b 45 14             	mov    0x14(%ebp),%eax
c0105527:	8b 55 0c             	mov    0xc(%ebp),%edx
c010552a:	31 d0                	xor    %edx,%eax
c010552c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105531:	85 c0                	test   %eax,%eax
c0105533:	74 24                	je     c0105559 <boot_map_segment+0x3b>
c0105535:	c7 44 24 0c 8e 80 10 	movl   $0xc010808e,0xc(%esp)
c010553c:	c0 
c010553d:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105544:	c0 
c0105545:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c010554c:	00 
c010554d:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105554:	e8 6d b7 ff ff       	call   c0100cc6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0105559:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105563:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105568:	89 c2                	mov    %eax,%edx
c010556a:	8b 45 10             	mov    0x10(%ebp),%eax
c010556d:	01 c2                	add    %eax,%edx
c010556f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105572:	01 d0                	add    %edx,%eax
c0105574:	83 e8 01             	sub    $0x1,%eax
c0105577:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010557a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010557d:	ba 00 00 00 00       	mov    $0x0,%edx
c0105582:	f7 75 f0             	divl   -0x10(%ebp)
c0105585:	89 d0                	mov    %edx,%eax
c0105587:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010558a:	29 c2                	sub    %eax,%edx
c010558c:	89 d0                	mov    %edx,%eax
c010558e:	c1 e8 0c             	shr    $0xc,%eax
c0105591:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0105594:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105597:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010559a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010559d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01055a2:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01055a5:	8b 45 14             	mov    0x14(%ebp),%eax
c01055a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01055b3:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01055b6:	eb 6b                	jmp    c0105623 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01055b8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01055bf:	00 
c01055c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ca:	89 04 24             	mov    %eax,(%esp)
c01055cd:	e8 cc 01 00 00       	call   c010579e <get_pte>
c01055d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01055d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01055d9:	75 24                	jne    c01055ff <boot_map_segment+0xe1>
c01055db:	c7 44 24 0c ba 80 10 	movl   $0xc01080ba,0xc(%esp)
c01055e2:	c0 
c01055e3:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c01055ea:	c0 
c01055eb:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01055f2:	00 
c01055f3:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c01055fa:	e8 c7 b6 ff ff       	call   c0100cc6 <__panic>
        *ptep = pa | PTE_P | perm;
c01055ff:	8b 45 18             	mov    0x18(%ebp),%eax
c0105602:	8b 55 14             	mov    0x14(%ebp),%edx
c0105605:	09 d0                	or     %edx,%eax
c0105607:	83 c8 01             	or     $0x1,%eax
c010560a:	89 c2                	mov    %eax,%edx
c010560c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010560f:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105611:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0105615:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010561c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0105623:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105627:	75 8f                	jne    c01055b8 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0105629:	c9                   	leave  
c010562a:	c3                   	ret    

c010562b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010562b:	55                   	push   %ebp
c010562c:	89 e5                	mov    %esp,%ebp
c010562e:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0105631:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105638:	e8 22 fa ff ff       	call   c010505f <alloc_pages>
c010563d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105640:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105644:	75 1c                	jne    c0105662 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0105646:	c7 44 24 08 c7 80 10 	movl   $0xc01080c7,0x8(%esp)
c010564d:	c0 
c010564e:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0105655:	00 
c0105656:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c010565d:	e8 64 b6 ff ff       	call   c0100cc6 <__panic>
    }
    return page2kva(p);
c0105662:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105665:	89 04 24             	mov    %eax,(%esp)
c0105668:	e8 5b f7 ff ff       	call   c0104dc8 <page2kva>
}
c010566d:	c9                   	leave  
c010566e:	c3                   	ret    

c010566f <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010566f:	55                   	push   %ebp
c0105670:	89 e5                	mov    %esp,%ebp
c0105672:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105675:	e8 93 f9 ff ff       	call   c010500d <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010567a:	e8 75 fa ff ff       	call   c01050f4 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010567f:	e8 dd 04 00 00       	call   c0105b61 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0105684:	e8 a2 ff ff ff       	call   c010562b <boot_alloc_page>
c0105689:	a3 c4 b8 11 c0       	mov    %eax,0xc011b8c4
    memset(boot_pgdir, 0, PGSIZE);
c010568e:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105693:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010569a:	00 
c010569b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01056a2:	00 
c01056a3:	89 04 24             	mov    %eax,(%esp)
c01056a6:	e8 1f 1b 00 00       	call   c01071ca <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01056ab:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01056b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056b3:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01056ba:	77 23                	ja     c01056df <pmm_init+0x70>
c01056bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01056c3:	c7 44 24 08 5c 80 10 	movl   $0xc010805c,0x8(%esp)
c01056ca:	c0 
c01056cb:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c01056d2:	00 
c01056d3:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c01056da:	e8 e7 b5 ff ff       	call   c0100cc6 <__panic>
c01056df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056e2:	05 00 00 00 40       	add    $0x40000000,%eax
c01056e7:	a3 a4 23 2a c0       	mov    %eax,0xc02a23a4

    check_pgdir();
c01056ec:	e8 8e 04 00 00       	call   c0105b7f <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01056f1:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01056f6:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01056fc:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105701:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105704:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010570b:	77 23                	ja     c0105730 <pmm_init+0xc1>
c010570d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105710:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105714:	c7 44 24 08 5c 80 10 	movl   $0xc010805c,0x8(%esp)
c010571b:	c0 
c010571c:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
c0105723:	00 
c0105724:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c010572b:	e8 96 b5 ff ff       	call   c0100cc6 <__panic>
c0105730:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105733:	05 00 00 00 40       	add    $0x40000000,%eax
c0105738:	83 c8 03             	or     $0x3,%eax
c010573b:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010573d:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105742:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0105749:	00 
c010574a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105751:	00 
c0105752:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0105759:	38 
c010575a:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105761:	c0 
c0105762:	89 04 24             	mov    %eax,(%esp)
c0105765:	e8 b4 fd ff ff       	call   c010551e <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010576a:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c010576f:	8b 15 c4 b8 11 c0    	mov    0xc011b8c4,%edx
c0105775:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010577b:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010577d:	e8 63 fd ff ff       	call   c01054e5 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0105782:	e8 97 f7 ff ff       	call   c0104f1e <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0105787:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c010578c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0105792:	e8 83 0a 00 00       	call   c010621a <check_boot_pgdir>

    print_pgdir();
c0105797:	e8 10 0f 00 00       	call   c01066ac <print_pgdir>

}
c010579c:	c9                   	leave  
c010579d:	c3                   	ret    

c010579e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte  -> 返回页表项虚拟地址
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010579e:	55                   	push   %ebp
c010579f:	89 e5                	mov    %esp,%ebp
c01057a1:	83 ec 48             	sub    $0x48,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

    pde_t *pdep = pgdir+PDX(la);  // （1）页目录地址+线性地址（偏移） -> page directory entry
c01057a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a7:	c1 e8 16             	shr    $0x16,%eax
c01057aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01057b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b4:	01 d0                	add    %edx,%eax
c01057b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //cprintf("%08x\n",*pdep & PTE_P);//debug 1

    if(*pdep&PTE_P)// (2) check if the entry is presented
c01057b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057bc:	8b 00                	mov    (%eax),%eax
c01057be:	83 e0 01             	and    $0x1,%eax
c01057c1:	85 c0                	test   %eax,%eax
c01057c3:	74 67                	je     c010582c <get_pte+0x8e>
    {
        pte_t *ptep = ((pte_t *)(KADDR(*pdep & ~0XFFF))+ PTX(la));//页表基址+offset
c01057c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057c8:	8b 00                	mov    (%eax),%eax
c01057ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01057cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057d5:	c1 e8 0c             	shr    $0xc,%eax
c01057d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01057db:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c01057e0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01057e3:	72 23                	jb     c0105808 <get_pte+0x6a>
c01057e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01057ec:	c7 44 24 08 b8 7f 10 	movl   $0xc0107fb8,0x8(%esp)
c01057f3:	c0 
c01057f4:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
c01057fb:	00 
c01057fc:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105803:	e8 be b4 ff ff       	call   c0100cc6 <__panic>
c0105808:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010580b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105810:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105813:	c1 ea 0c             	shr    $0xc,%edx
c0105816:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c010581c:	c1 e2 02             	shl    $0x2,%edx
c010581f:	01 d0                	add    %edx,%eax
c0105821:	89 45 e8             	mov    %eax,-0x18(%ebp)
        //cprintf("%08x\n",*pdep & PTE_P);//debug 2
        return ptep;    
c0105824:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105827:	e9 db 00 00 00       	jmp    c0105907 <get_pte+0x169>
    }
    
    if(!create) return NULL;        // （3）check if create a new page-table 
c010582c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105830:	75 0a                	jne    c010583c <get_pte+0x9e>
c0105832:	b8 00 00 00 00       	mov    $0x0,%eax
c0105837:	e9 cb 00 00 00       	jmp    c0105907 <get_pte+0x169>
    struct Page* pt = alloc_page(); // allocate a page frame for the page-table
c010583c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105843:	e8 17 f8 ff ff       	call   c010505f <alloc_pages>
c0105848:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pt == NULL) return NULL;
c010584b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010584f:	75 0a                	jne    c010585b <get_pte+0xbd>
c0105851:	b8 00 00 00 00       	mov    $0x0,%eax
c0105856:	e9 ac 00 00 00       	jmp    c0105907 <get_pte+0x169>
    set_page_ref(pt,1);             //（4）更新物理页引用计数
c010585b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105862:	00 
c0105863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105866:	89 04 24             	mov    %eax,(%esp)
c0105869:	e8 f6 f5 ff ff       	call   c0104e64 <set_page_ref>
    uintptr_t pa = page2pa(pt);  //得到该页物理地址
c010586e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105871:	89 04 24             	mov    %eax,(%esp)
c0105874:	e8 ea f4 ff ff       	call   c0104d63 <page2pa>
c0105879:	89 45 e0             	mov    %eax,-0x20(%ebp)
    pte_t *ptep = KADDR(pa);      //（5）get the virtual address of page pt
c010587c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010587f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105882:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105885:	c1 e8 0c             	shr    $0xc,%eax
c0105888:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010588b:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c0105890:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0105893:	72 23                	jb     c01058b8 <get_pte+0x11a>
c0105895:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105898:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010589c:	c7 44 24 08 b8 7f 10 	movl   $0xc0107fb8,0x8(%esp)
c01058a3:	c0 
c01058a4:	c7 44 24 04 94 01 00 	movl   $0x194,0x4(%esp)
c01058ab:	00 
c01058ac:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c01058b3:	e8 0e b4 ff ff       	call   c0100cc6 <__panic>
c01058b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058bb:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01058c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    memset(ptep,0,PGSIZE);          // (6)
c01058c3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01058ca:	00 
c01058cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01058d2:	00 
c01058d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01058d6:	89 04 24             	mov    %eax,(%esp)
c01058d9:	e8 ec 18 00 00       	call   c01071ca <memset>
    *pdep = (pa&~0XFFF)|PTE_U|PTE_W|PTE_P; // （7）对原先的目录进行设置，大端存址，把物理地址对应位写进去 
c01058de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01058e6:	83 c8 07             	or     $0x7,%eax
c01058e9:	89 c2                	mov    %eax,%edx
c01058eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058ee:	89 10                	mov    %edx,(%eax)
    return ptep+PTX(la);          //(8)返回虚拟地址的页表索引项
c01058f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f3:	c1 e8 0c             	shr    $0xc,%eax
c01058f6:	25 ff 03 00 00       	and    $0x3ff,%eax
c01058fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105902:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105905:	01 d0                	add    %edx,%eax
}
c0105907:	c9                   	leave  
c0105908:	c3                   	ret    

c0105909 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0105909:	55                   	push   %ebp
c010590a:	89 e5                	mov    %esp,%ebp
c010590c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010590f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105916:	00 
c0105917:	8b 45 0c             	mov    0xc(%ebp),%eax
c010591a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010591e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105921:	89 04 24             	mov    %eax,(%esp)
c0105924:	e8 75 fe ff ff       	call   c010579e <get_pte>
c0105929:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010592c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105930:	74 08                	je     c010593a <get_page+0x31>
        *ptep_store = ptep;
c0105932:	8b 45 10             	mov    0x10(%ebp),%eax
c0105935:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105938:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010593a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010593e:	74 1b                	je     c010595b <get_page+0x52>
c0105940:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105943:	8b 00                	mov    (%eax),%eax
c0105945:	83 e0 01             	and    $0x1,%eax
c0105948:	85 c0                	test   %eax,%eax
c010594a:	74 0f                	je     c010595b <get_page+0x52>
        return pa2page(*ptep);
c010594c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010594f:	8b 00                	mov    (%eax),%eax
c0105951:	89 04 24             	mov    %eax,(%esp)
c0105954:	e8 20 f4 ff ff       	call   c0104d79 <pa2page>
c0105959:	eb 05                	jmp    c0105960 <get_page+0x57>
    }
    return NULL;
c010595b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105960:	c9                   	leave  
c0105961:	c3                   	ret    

c0105962 <page_remove_pte>:
//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void

page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105962:	55                   	push   %ebp
c0105963:	89 e5                	mov    %esp,%ebp
c0105965:	83 ec 28             	sub    $0x28,%esp

    }

#endif
    //如果要更严谨的做法，应该也检查下page directory项是否存在
    assert(*ptep & PTE_P);//ok
c0105968:	8b 45 10             	mov    0x10(%ebp),%eax
c010596b:	8b 00                	mov    (%eax),%eax
c010596d:	83 e0 01             	and    $0x1,%eax
c0105970:	85 c0                	test   %eax,%eax
c0105972:	75 24                	jne    c0105998 <page_remove_pte+0x36>
c0105974:	c7 44 24 0c e0 80 10 	movl   $0xc01080e0,0xc(%esp)
c010597b:	c0 
c010597c:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105983:	c0 
c0105984:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
c010598b:	00 
c010598c:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105993:	e8 2e b3 ff ff       	call   c0100cc6 <__panic>
    if(*ptep){
c0105998:	8b 45 10             	mov    0x10(%ebp),%eax
c010599b:	8b 00                	mov    (%eax),%eax
c010599d:	85 c0                	test   %eax,%eax
c010599f:	74 64                	je     c0105a05 <page_remove_pte+0xa3>
        //check this page table is existed
        if(PTE_P==1){
            
            struct Page* curPage = pte2page(*ptep);
c01059a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01059a4:	8b 00                	mov    (%eax),%eax
c01059a6:	89 04 24             	mov    %eax,(%esp)
c01059a9:	e8 6e f4 ff ff       	call   c0104e1c <pte2page>
c01059ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
            bool shouldBeFree = page_ref_dec(curPage)==0;//whether or not this page should be freed
c01059b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059b4:	89 04 24             	mov    %eax,(%esp)
c01059b7:	e8 cc f4 ff ff       	call   c0104e88 <page_ref_dec>
c01059bc:	85 c0                	test   %eax,%eax
c01059be:	0f 94 c0             	sete   %al
c01059c1:	0f b6 c0             	movzbl %al,%eax
c01059c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
            //if this pte is not used by anyone
            if(shouldBeFree){
c01059c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01059cb:	74 1d                	je     c01059ea <page_remove_pte+0x88>
                free_page(pte2page(*ptep));
c01059cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01059d0:	8b 00                	mov    (%eax),%eax
c01059d2:	89 04 24             	mov    %eax,(%esp)
c01059d5:	e8 42 f4 ff ff       	call   c0104e1c <pte2page>
c01059da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01059e1:	00 
c01059e2:	89 04 24             	mov    %eax,(%esp)
c01059e5:	e8 ad f6 ff ff       	call   c0105097 <free_pages>
            }
            // clear second page table entry (即对应值变为0)
            *ptep = 0;
c01059ea:	8b 45 10             	mov    0x10(%ebp),%eax
c01059ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            //flush tlb
            tlb_invalidate(pgdir,la);
c01059f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01059fd:	89 04 24             	mov    %eax,(%esp)
c0105a00:	e8 ff 00 00 00       	call   c0105b04 <tlb_invalidate>
        }
    }
}
c0105a05:	c9                   	leave  
c0105a06:	c3                   	ret    

c0105a07 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105a07:	55                   	push   %ebp
c0105a08:	89 e5                	mov    %esp,%ebp
c0105a0a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105a0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a14:	00 
c0105a15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a1f:	89 04 24             	mov    %eax,(%esp)
c0105a22:	e8 77 fd ff ff       	call   c010579e <get_pte>
c0105a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105a2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105a2e:	74 19                	je     c0105a49 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a33:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a37:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a41:	89 04 24             	mov    %eax,(%esp)
c0105a44:	e8 19 ff ff ff       	call   c0105962 <page_remove_pte>
    }
}
c0105a49:	c9                   	leave  
c0105a4a:	c3                   	ret    

c0105a4b <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105a4b:	55                   	push   %ebp
c0105a4c:	89 e5                	mov    %esp,%ebp
c0105a4e:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105a51:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105a58:	00 
c0105a59:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a60:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a63:	89 04 24             	mov    %eax,(%esp)
c0105a66:	e8 33 fd ff ff       	call   c010579e <get_pte>
c0105a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105a6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105a72:	75 0a                	jne    c0105a7e <page_insert+0x33>
        return -E_NO_MEM;
c0105a74:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105a79:	e9 84 00 00 00       	jmp    c0105b02 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105a7e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a81:	89 04 24             	mov    %eax,(%esp)
c0105a84:	e8 e8 f3 ff ff       	call   c0104e71 <page_ref_inc>
    if (*ptep & PTE_P) {
c0105a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a8c:	8b 00                	mov    (%eax),%eax
c0105a8e:	83 e0 01             	and    $0x1,%eax
c0105a91:	85 c0                	test   %eax,%eax
c0105a93:	74 3e                	je     c0105ad3 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a98:	8b 00                	mov    (%eax),%eax
c0105a9a:	89 04 24             	mov    %eax,(%esp)
c0105a9d:	e8 7a f3 ff ff       	call   c0104e1c <pte2page>
c0105aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105aa8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105aab:	75 0d                	jne    c0105aba <page_insert+0x6f>
            page_ref_dec(page);
c0105aad:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ab0:	89 04 24             	mov    %eax,(%esp)
c0105ab3:	e8 d0 f3 ff ff       	call   c0104e88 <page_ref_dec>
c0105ab8:	eb 19                	jmp    c0105ad3 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105abd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ac1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ac8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105acb:	89 04 24             	mov    %eax,(%esp)
c0105ace:	e8 8f fe ff ff       	call   c0105962 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ad6:	89 04 24             	mov    %eax,(%esp)
c0105ad9:	e8 85 f2 ff ff       	call   c0104d63 <page2pa>
c0105ade:	0b 45 14             	or     0x14(%ebp),%eax
c0105ae1:	83 c8 01             	or     $0x1,%eax
c0105ae4:	89 c2                	mov    %eax,%edx
c0105ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ae9:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105aeb:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aee:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105af2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af5:	89 04 24             	mov    %eax,(%esp)
c0105af8:	e8 07 00 00 00       	call   c0105b04 <tlb_invalidate>
    return 0;
c0105afd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b02:	c9                   	leave  
c0105b03:	c3                   	ret    

c0105b04 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105b04:	55                   	push   %ebp
c0105b05:	89 e5                	mov    %esp,%ebp
c0105b07:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105b0a:	0f 20 d8             	mov    %cr3,%eax
c0105b0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105b13:	89 c2                	mov    %eax,%edx
c0105b15:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b18:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b1b:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105b22:	77 23                	ja     c0105b47 <tlb_invalidate+0x43>
c0105b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b27:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b2b:	c7 44 24 08 5c 80 10 	movl   $0xc010805c,0x8(%esp)
c0105b32:	c0 
c0105b33:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0105b3a:	00 
c0105b3b:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105b42:	e8 7f b1 ff ff       	call   c0100cc6 <__panic>
c0105b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b4a:	05 00 00 00 40       	add    $0x40000000,%eax
c0105b4f:	39 c2                	cmp    %eax,%edx
c0105b51:	75 0c                	jne    c0105b5f <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105b53:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b56:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b5c:	0f 01 38             	invlpg (%eax)
    }
}
c0105b5f:	c9                   	leave  
c0105b60:	c3                   	ret    

c0105b61 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105b61:	55                   	push   %ebp
c0105b62:	89 e5                	mov    %esp,%ebp
c0105b64:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105b67:	a1 a0 23 2a c0       	mov    0xc02a23a0,%eax
c0105b6c:	8b 40 18             	mov    0x18(%eax),%eax
c0105b6f:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105b71:	c7 04 24 f0 80 10 c0 	movl   $0xc01080f0,(%esp)
c0105b78:	e8 bf a7 ff ff       	call   c010033c <cprintf>
}
c0105b7d:	c9                   	leave  
c0105b7e:	c3                   	ret    

c0105b7f <check_pgdir>:

static void
check_pgdir(void) {
c0105b7f:	55                   	push   %ebp
c0105b80:	89 e5                	mov    %esp,%ebp
c0105b82:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105b85:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c0105b8a:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105b8f:	76 24                	jbe    c0105bb5 <check_pgdir+0x36>
c0105b91:	c7 44 24 0c 0f 81 10 	movl   $0xc010810f,0xc(%esp)
c0105b98:	c0 
c0105b99:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105ba0:	c0 
c0105ba1:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0105ba8:	00 
c0105ba9:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105bb0:	e8 11 b1 ff ff       	call   c0100cc6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105bb5:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105bba:	85 c0                	test   %eax,%eax
c0105bbc:	74 0e                	je     c0105bcc <check_pgdir+0x4d>
c0105bbe:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105bc3:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105bc8:	85 c0                	test   %eax,%eax
c0105bca:	74 24                	je     c0105bf0 <check_pgdir+0x71>
c0105bcc:	c7 44 24 0c 2c 81 10 	movl   $0xc010812c,0xc(%esp)
c0105bd3:	c0 
c0105bd4:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105bdb:	c0 
c0105bdc:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105be3:	00 
c0105be4:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105beb:	e8 d6 b0 ff ff       	call   c0100cc6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105bf0:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105bf5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105bfc:	00 
c0105bfd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105c04:	00 
c0105c05:	89 04 24             	mov    %eax,(%esp)
c0105c08:	e8 fc fc ff ff       	call   c0105909 <get_page>
c0105c0d:	85 c0                	test   %eax,%eax
c0105c0f:	74 24                	je     c0105c35 <check_pgdir+0xb6>
c0105c11:	c7 44 24 0c 64 81 10 	movl   $0xc0108164,0xc(%esp)
c0105c18:	c0 
c0105c19:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105c20:	c0 
c0105c21:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0105c28:	00 
c0105c29:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105c30:	e8 91 b0 ff ff       	call   c0100cc6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105c35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105c3c:	e8 1e f4 ff ff       	call   c010505f <alloc_pages>
c0105c41:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105c44:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105c49:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105c50:	00 
c0105c51:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c58:	00 
c0105c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c5c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c60:	89 04 24             	mov    %eax,(%esp)
c0105c63:	e8 e3 fd ff ff       	call   c0105a4b <page_insert>
c0105c68:	85 c0                	test   %eax,%eax
c0105c6a:	74 24                	je     c0105c90 <check_pgdir+0x111>
c0105c6c:	c7 44 24 0c 8c 81 10 	movl   $0xc010818c,0xc(%esp)
c0105c73:	c0 
c0105c74:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105c7b:	c0 
c0105c7c:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0105c83:	00 
c0105c84:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105c8b:	e8 36 b0 ff ff       	call   c0100cc6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105c90:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105c95:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c9c:	00 
c0105c9d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105ca4:	00 
c0105ca5:	89 04 24             	mov    %eax,(%esp)
c0105ca8:	e8 f1 fa ff ff       	call   c010579e <get_pte>
c0105cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105cb4:	75 24                	jne    c0105cda <check_pgdir+0x15b>
c0105cb6:	c7 44 24 0c b8 81 10 	movl   $0xc01081b8,0xc(%esp)
c0105cbd:	c0 
c0105cbe:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105cc5:	c0 
c0105cc6:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105ccd:	00 
c0105cce:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105cd5:	e8 ec af ff ff       	call   c0100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
c0105cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cdd:	8b 00                	mov    (%eax),%eax
c0105cdf:	89 04 24             	mov    %eax,(%esp)
c0105ce2:	e8 92 f0 ff ff       	call   c0104d79 <pa2page>
c0105ce7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105cea:	74 24                	je     c0105d10 <check_pgdir+0x191>
c0105cec:	c7 44 24 0c e5 81 10 	movl   $0xc01081e5,0xc(%esp)
c0105cf3:	c0 
c0105cf4:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105cfb:	c0 
c0105cfc:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105d03:	00 
c0105d04:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105d0b:	e8 b6 af ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p1) == 1);
c0105d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d13:	89 04 24             	mov    %eax,(%esp)
c0105d16:	e8 3f f1 ff ff       	call   c0104e5a <page_ref>
c0105d1b:	83 f8 01             	cmp    $0x1,%eax
c0105d1e:	74 24                	je     c0105d44 <check_pgdir+0x1c5>
c0105d20:	c7 44 24 0c fa 81 10 	movl   $0xc01081fa,0xc(%esp)
c0105d27:	c0 
c0105d28:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105d2f:	c0 
c0105d30:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105d37:	00 
c0105d38:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105d3f:	e8 82 af ff ff       	call   c0100cc6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105d44:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105d49:	8b 00                	mov    (%eax),%eax
c0105d4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105d50:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d53:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d56:	c1 e8 0c             	shr    $0xc,%eax
c0105d59:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105d5c:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c0105d61:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105d64:	72 23                	jb     c0105d89 <check_pgdir+0x20a>
c0105d66:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d69:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d6d:	c7 44 24 08 b8 7f 10 	movl   $0xc0107fb8,0x8(%esp)
c0105d74:	c0 
c0105d75:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105d7c:	00 
c0105d7d:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105d84:	e8 3d af ff ff       	call   c0100cc6 <__panic>
c0105d89:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d8c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105d91:	83 c0 04             	add    $0x4,%eax
c0105d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105d97:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105d9c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105da3:	00 
c0105da4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105dab:	00 
c0105dac:	89 04 24             	mov    %eax,(%esp)
c0105daf:	e8 ea f9 ff ff       	call   c010579e <get_pte>
c0105db4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105db7:	74 24                	je     c0105ddd <check_pgdir+0x25e>
c0105db9:	c7 44 24 0c 0c 82 10 	movl   $0xc010820c,0xc(%esp)
c0105dc0:	c0 
c0105dc1:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105dc8:	c0 
c0105dc9:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105dd0:	00 
c0105dd1:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105dd8:	e8 e9 ae ff ff       	call   c0100cc6 <__panic>

    p2 = alloc_page();
c0105ddd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105de4:	e8 76 f2 ff ff       	call   c010505f <alloc_pages>
c0105de9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105dec:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105df1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105df8:	00 
c0105df9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105e00:	00 
c0105e01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e04:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e08:	89 04 24             	mov    %eax,(%esp)
c0105e0b:	e8 3b fc ff ff       	call   c0105a4b <page_insert>
c0105e10:	85 c0                	test   %eax,%eax
c0105e12:	74 24                	je     c0105e38 <check_pgdir+0x2b9>
c0105e14:	c7 44 24 0c 34 82 10 	movl   $0xc0108234,0xc(%esp)
c0105e1b:	c0 
c0105e1c:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105e23:	c0 
c0105e24:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105e2b:	00 
c0105e2c:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105e33:	e8 8e ae ff ff       	call   c0100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105e38:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105e3d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105e44:	00 
c0105e45:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105e4c:	00 
c0105e4d:	89 04 24             	mov    %eax,(%esp)
c0105e50:	e8 49 f9 ff ff       	call   c010579e <get_pte>
c0105e55:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105e5c:	75 24                	jne    c0105e82 <check_pgdir+0x303>
c0105e5e:	c7 44 24 0c 6c 82 10 	movl   $0xc010826c,0xc(%esp)
c0105e65:	c0 
c0105e66:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105e6d:	c0 
c0105e6e:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105e75:	00 
c0105e76:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105e7d:	e8 44 ae ff ff       	call   c0100cc6 <__panic>
    assert(*ptep & PTE_U);
c0105e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e85:	8b 00                	mov    (%eax),%eax
c0105e87:	83 e0 04             	and    $0x4,%eax
c0105e8a:	85 c0                	test   %eax,%eax
c0105e8c:	75 24                	jne    c0105eb2 <check_pgdir+0x333>
c0105e8e:	c7 44 24 0c 9c 82 10 	movl   $0xc010829c,0xc(%esp)
c0105e95:	c0 
c0105e96:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105e9d:	c0 
c0105e9e:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105ea5:	00 
c0105ea6:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105ead:	e8 14 ae ff ff       	call   c0100cc6 <__panic>
    assert(*ptep & PTE_W);
c0105eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eb5:	8b 00                	mov    (%eax),%eax
c0105eb7:	83 e0 02             	and    $0x2,%eax
c0105eba:	85 c0                	test   %eax,%eax
c0105ebc:	75 24                	jne    c0105ee2 <check_pgdir+0x363>
c0105ebe:	c7 44 24 0c aa 82 10 	movl   $0xc01082aa,0xc(%esp)
c0105ec5:	c0 
c0105ec6:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105ecd:	c0 
c0105ece:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105ed5:	00 
c0105ed6:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105edd:	e8 e4 ad ff ff       	call   c0100cc6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105ee2:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105ee7:	8b 00                	mov    (%eax),%eax
c0105ee9:	83 e0 04             	and    $0x4,%eax
c0105eec:	85 c0                	test   %eax,%eax
c0105eee:	75 24                	jne    c0105f14 <check_pgdir+0x395>
c0105ef0:	c7 44 24 0c b8 82 10 	movl   $0xc01082b8,0xc(%esp)
c0105ef7:	c0 
c0105ef8:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105eff:	c0 
c0105f00:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105f07:	00 
c0105f08:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105f0f:	e8 b2 ad ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 1);
c0105f14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f17:	89 04 24             	mov    %eax,(%esp)
c0105f1a:	e8 3b ef ff ff       	call   c0104e5a <page_ref>
c0105f1f:	83 f8 01             	cmp    $0x1,%eax
c0105f22:	74 24                	je     c0105f48 <check_pgdir+0x3c9>
c0105f24:	c7 44 24 0c ce 82 10 	movl   $0xc01082ce,0xc(%esp)
c0105f2b:	c0 
c0105f2c:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105f33:	c0 
c0105f34:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0105f3b:	00 
c0105f3c:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105f43:	e8 7e ad ff ff       	call   c0100cc6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105f48:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0105f4d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105f54:	00 
c0105f55:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105f5c:	00 
c0105f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f60:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105f64:	89 04 24             	mov    %eax,(%esp)
c0105f67:	e8 df fa ff ff       	call   c0105a4b <page_insert>
c0105f6c:	85 c0                	test   %eax,%eax
c0105f6e:	74 24                	je     c0105f94 <check_pgdir+0x415>
c0105f70:	c7 44 24 0c e0 82 10 	movl   $0xc01082e0,0xc(%esp)
c0105f77:	c0 
c0105f78:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105f7f:	c0 
c0105f80:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0105f87:	00 
c0105f88:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105f8f:	e8 32 ad ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p1) == 2);
c0105f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f97:	89 04 24             	mov    %eax,(%esp)
c0105f9a:	e8 bb ee ff ff       	call   c0104e5a <page_ref>
c0105f9f:	83 f8 02             	cmp    $0x2,%eax
c0105fa2:	74 24                	je     c0105fc8 <check_pgdir+0x449>
c0105fa4:	c7 44 24 0c 0c 83 10 	movl   $0xc010830c,0xc(%esp)
c0105fab:	c0 
c0105fac:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105fb3:	c0 
c0105fb4:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0105fbb:	00 
c0105fbc:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105fc3:	e8 fe ac ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0105fc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fcb:	89 04 24             	mov    %eax,(%esp)
c0105fce:	e8 87 ee ff ff       	call   c0104e5a <page_ref>
c0105fd3:	85 c0                	test   %eax,%eax
c0105fd5:	74 24                	je     c0105ffb <check_pgdir+0x47c>
c0105fd7:	c7 44 24 0c 1e 83 10 	movl   $0xc010831e,0xc(%esp)
c0105fde:	c0 
c0105fdf:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0105fe6:	c0 
c0105fe7:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c0105fee:	00 
c0105fef:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0105ff6:	e8 cb ac ff ff       	call   c0100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105ffb:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0106000:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106007:	00 
c0106008:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010600f:	00 
c0106010:	89 04 24             	mov    %eax,(%esp)
c0106013:	e8 86 f7 ff ff       	call   c010579e <get_pte>
c0106018:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010601b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010601f:	75 24                	jne    c0106045 <check_pgdir+0x4c6>
c0106021:	c7 44 24 0c 6c 82 10 	movl   $0xc010826c,0xc(%esp)
c0106028:	c0 
c0106029:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0106030:	c0 
c0106031:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c0106038:	00 
c0106039:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0106040:	e8 81 ac ff ff       	call   c0100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
c0106045:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106048:	8b 00                	mov    (%eax),%eax
c010604a:	89 04 24             	mov    %eax,(%esp)
c010604d:	e8 27 ed ff ff       	call   c0104d79 <pa2page>
c0106052:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106055:	74 24                	je     c010607b <check_pgdir+0x4fc>
c0106057:	c7 44 24 0c e5 81 10 	movl   $0xc01081e5,0xc(%esp)
c010605e:	c0 
c010605f:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0106066:	c0 
c0106067:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c010606e:	00 
c010606f:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0106076:	e8 4b ac ff ff       	call   c0100cc6 <__panic>
    assert((*ptep & PTE_U) == 0);
c010607b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010607e:	8b 00                	mov    (%eax),%eax
c0106080:	83 e0 04             	and    $0x4,%eax
c0106083:	85 c0                	test   %eax,%eax
c0106085:	74 24                	je     c01060ab <check_pgdir+0x52c>
c0106087:	c7 44 24 0c 30 83 10 	movl   $0xc0108330,0xc(%esp)
c010608e:	c0 
c010608f:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0106096:	c0 
c0106097:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c010609e:	00 
c010609f:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c01060a6:	e8 1b ac ff ff       	call   c0100cc6 <__panic>

    page_remove(boot_pgdir, 0x0);
c01060ab:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01060b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01060b7:	00 
c01060b8:	89 04 24             	mov    %eax,(%esp)
c01060bb:	e8 47 f9 ff ff       	call   c0105a07 <page_remove>
    assert(page_ref(p1) == 1);
c01060c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060c3:	89 04 24             	mov    %eax,(%esp)
c01060c6:	e8 8f ed ff ff       	call   c0104e5a <page_ref>
c01060cb:	83 f8 01             	cmp    $0x1,%eax
c01060ce:	74 24                	je     c01060f4 <check_pgdir+0x575>
c01060d0:	c7 44 24 0c fa 81 10 	movl   $0xc01081fa,0xc(%esp)
c01060d7:	c0 
c01060d8:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c01060df:	c0 
c01060e0:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c01060e7:	00 
c01060e8:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c01060ef:	e8 d2 ab ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c01060f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060f7:	89 04 24             	mov    %eax,(%esp)
c01060fa:	e8 5b ed ff ff       	call   c0104e5a <page_ref>
c01060ff:	85 c0                	test   %eax,%eax
c0106101:	74 24                	je     c0106127 <check_pgdir+0x5a8>
c0106103:	c7 44 24 0c 1e 83 10 	movl   $0xc010831e,0xc(%esp)
c010610a:	c0 
c010610b:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0106112:	c0 
c0106113:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c010611a:	00 
c010611b:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0106122:	e8 9f ab ff ff       	call   c0100cc6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0106127:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c010612c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106133:	00 
c0106134:	89 04 24             	mov    %eax,(%esp)
c0106137:	e8 cb f8 ff ff       	call   c0105a07 <page_remove>
    assert(page_ref(p1) == 0);
c010613c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010613f:	89 04 24             	mov    %eax,(%esp)
c0106142:	e8 13 ed ff ff       	call   c0104e5a <page_ref>
c0106147:	85 c0                	test   %eax,%eax
c0106149:	74 24                	je     c010616f <check_pgdir+0x5f0>
c010614b:	c7 44 24 0c 45 83 10 	movl   $0xc0108345,0xc(%esp)
c0106152:	c0 
c0106153:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c010615a:	c0 
c010615b:	c7 44 24 04 4e 02 00 	movl   $0x24e,0x4(%esp)
c0106162:	00 
c0106163:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c010616a:	e8 57 ab ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c010616f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106172:	89 04 24             	mov    %eax,(%esp)
c0106175:	e8 e0 ec ff ff       	call   c0104e5a <page_ref>
c010617a:	85 c0                	test   %eax,%eax
c010617c:	74 24                	je     c01061a2 <check_pgdir+0x623>
c010617e:	c7 44 24 0c 1e 83 10 	movl   $0xc010831e,0xc(%esp)
c0106185:	c0 
c0106186:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c010618d:	c0 
c010618e:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
c0106195:	00 
c0106196:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c010619d:	e8 24 ab ff ff       	call   c0100cc6 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c01061a2:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01061a7:	8b 00                	mov    (%eax),%eax
c01061a9:	89 04 24             	mov    %eax,(%esp)
c01061ac:	e8 c8 eb ff ff       	call   c0104d79 <pa2page>
c01061b1:	89 04 24             	mov    %eax,(%esp)
c01061b4:	e8 a1 ec ff ff       	call   c0104e5a <page_ref>
c01061b9:	83 f8 01             	cmp    $0x1,%eax
c01061bc:	74 24                	je     c01061e2 <check_pgdir+0x663>
c01061be:	c7 44 24 0c 58 83 10 	movl   $0xc0108358,0xc(%esp)
c01061c5:	c0 
c01061c6:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c01061cd:	c0 
c01061ce:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
c01061d5:	00 
c01061d6:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c01061dd:	e8 e4 aa ff ff       	call   c0100cc6 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c01061e2:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01061e7:	8b 00                	mov    (%eax),%eax
c01061e9:	89 04 24             	mov    %eax,(%esp)
c01061ec:	e8 88 eb ff ff       	call   c0104d79 <pa2page>
c01061f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01061f8:	00 
c01061f9:	89 04 24             	mov    %eax,(%esp)
c01061fc:	e8 96 ee ff ff       	call   c0105097 <free_pages>
    boot_pgdir[0] = 0;
c0106201:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0106206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c010620c:	c7 04 24 7e 83 10 c0 	movl   $0xc010837e,(%esp)
c0106213:	e8 24 a1 ff ff       	call   c010033c <cprintf>
}
c0106218:	c9                   	leave  
c0106219:	c3                   	ret    

c010621a <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c010621a:	55                   	push   %ebp
c010621b:	89 e5                	mov    %esp,%ebp
c010621d:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106220:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106227:	e9 ca 00 00 00       	jmp    c01062f6 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c010622c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010622f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106232:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106235:	c1 e8 0c             	shr    $0xc,%eax
c0106238:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010623b:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c0106240:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0106243:	72 23                	jb     c0106268 <check_boot_pgdir+0x4e>
c0106245:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106248:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010624c:	c7 44 24 08 b8 7f 10 	movl   $0xc0107fb8,0x8(%esp)
c0106253:	c0 
c0106254:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c010625b:	00 
c010625c:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0106263:	e8 5e aa ff ff       	call   c0100cc6 <__panic>
c0106268:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010626b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0106270:	89 c2                	mov    %eax,%edx
c0106272:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0106277:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010627e:	00 
c010627f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106283:	89 04 24             	mov    %eax,(%esp)
c0106286:	e8 13 f5 ff ff       	call   c010579e <get_pte>
c010628b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010628e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106292:	75 24                	jne    c01062b8 <check_boot_pgdir+0x9e>
c0106294:	c7 44 24 0c 98 83 10 	movl   $0xc0108398,0xc(%esp)
c010629b:	c0 
c010629c:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c01062a3:	c0 
c01062a4:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c01062ab:	00 
c01062ac:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c01062b3:	e8 0e aa ff ff       	call   c0100cc6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01062b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01062bb:	8b 00                	mov    (%eax),%eax
c01062bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01062c2:	89 c2                	mov    %eax,%edx
c01062c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062c7:	39 c2                	cmp    %eax,%edx
c01062c9:	74 24                	je     c01062ef <check_boot_pgdir+0xd5>
c01062cb:	c7 44 24 0c d5 83 10 	movl   $0xc01083d5,0xc(%esp)
c01062d2:	c0 
c01062d3:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c01062da:	c0 
c01062db:	c7 44 24 04 5e 02 00 	movl   $0x25e,0x4(%esp)
c01062e2:	00 
c01062e3:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c01062ea:	e8 d7 a9 ff ff       	call   c0100cc6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01062ef:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01062f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01062f9:	a1 c0 b8 11 c0       	mov    0xc011b8c0,%eax
c01062fe:	39 c2                	cmp    %eax,%edx
c0106300:	0f 82 26 ff ff ff    	jb     c010622c <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0106306:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c010630b:	05 ac 0f 00 00       	add    $0xfac,%eax
c0106310:	8b 00                	mov    (%eax),%eax
c0106312:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106317:	89 c2                	mov    %eax,%edx
c0106319:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c010631e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106321:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0106328:	77 23                	ja     c010634d <check_boot_pgdir+0x133>
c010632a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010632d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106331:	c7 44 24 08 5c 80 10 	movl   $0xc010805c,0x8(%esp)
c0106338:	c0 
c0106339:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c0106340:	00 
c0106341:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0106348:	e8 79 a9 ff ff       	call   c0100cc6 <__panic>
c010634d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106350:	05 00 00 00 40       	add    $0x40000000,%eax
c0106355:	39 c2                	cmp    %eax,%edx
c0106357:	74 24                	je     c010637d <check_boot_pgdir+0x163>
c0106359:	c7 44 24 0c ec 83 10 	movl   $0xc01083ec,0xc(%esp)
c0106360:	c0 
c0106361:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0106368:	c0 
c0106369:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c0106370:	00 
c0106371:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0106378:	e8 49 a9 ff ff       	call   c0100cc6 <__panic>

    assert(boot_pgdir[0] == 0);
c010637d:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0106382:	8b 00                	mov    (%eax),%eax
c0106384:	85 c0                	test   %eax,%eax
c0106386:	74 24                	je     c01063ac <check_boot_pgdir+0x192>
c0106388:	c7 44 24 0c 20 84 10 	movl   $0xc0108420,0xc(%esp)
c010638f:	c0 
c0106390:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0106397:	c0 
c0106398:	c7 44 24 04 63 02 00 	movl   $0x263,0x4(%esp)
c010639f:	00 
c01063a0:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c01063a7:	e8 1a a9 ff ff       	call   c0100cc6 <__panic>

    struct Page *p;
    p = alloc_page();
c01063ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01063b3:	e8 a7 ec ff ff       	call   c010505f <alloc_pages>
c01063b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01063bb:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c01063c0:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01063c7:	00 
c01063c8:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01063cf:	00 
c01063d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01063d3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063d7:	89 04 24             	mov    %eax,(%esp)
c01063da:	e8 6c f6 ff ff       	call   c0105a4b <page_insert>
c01063df:	85 c0                	test   %eax,%eax
c01063e1:	74 24                	je     c0106407 <check_boot_pgdir+0x1ed>
c01063e3:	c7 44 24 0c 34 84 10 	movl   $0xc0108434,0xc(%esp)
c01063ea:	c0 
c01063eb:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c01063f2:	c0 
c01063f3:	c7 44 24 04 67 02 00 	movl   $0x267,0x4(%esp)
c01063fa:	00 
c01063fb:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0106402:	e8 bf a8 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p) == 1);
c0106407:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010640a:	89 04 24             	mov    %eax,(%esp)
c010640d:	e8 48 ea ff ff       	call   c0104e5a <page_ref>
c0106412:	83 f8 01             	cmp    $0x1,%eax
c0106415:	74 24                	je     c010643b <check_boot_pgdir+0x221>
c0106417:	c7 44 24 0c 62 84 10 	movl   $0xc0108462,0xc(%esp)
c010641e:	c0 
c010641f:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0106426:	c0 
c0106427:	c7 44 24 04 68 02 00 	movl   $0x268,0x4(%esp)
c010642e:	00 
c010642f:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0106436:	e8 8b a8 ff ff       	call   c0100cc6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010643b:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0106440:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106447:	00 
c0106448:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010644f:	00 
c0106450:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106453:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106457:	89 04 24             	mov    %eax,(%esp)
c010645a:	e8 ec f5 ff ff       	call   c0105a4b <page_insert>
c010645f:	85 c0                	test   %eax,%eax
c0106461:	74 24                	je     c0106487 <check_boot_pgdir+0x26d>
c0106463:	c7 44 24 0c 74 84 10 	movl   $0xc0108474,0xc(%esp)
c010646a:	c0 
c010646b:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0106472:	c0 
c0106473:	c7 44 24 04 69 02 00 	movl   $0x269,0x4(%esp)
c010647a:	00 
c010647b:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0106482:	e8 3f a8 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p) == 2);
c0106487:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010648a:	89 04 24             	mov    %eax,(%esp)
c010648d:	e8 c8 e9 ff ff       	call   c0104e5a <page_ref>
c0106492:	83 f8 02             	cmp    $0x2,%eax
c0106495:	74 24                	je     c01064bb <check_boot_pgdir+0x2a1>
c0106497:	c7 44 24 0c ab 84 10 	movl   $0xc01084ab,0xc(%esp)
c010649e:	c0 
c010649f:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c01064a6:	c0 
c01064a7:	c7 44 24 04 6a 02 00 	movl   $0x26a,0x4(%esp)
c01064ae:	00 
c01064af:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c01064b6:	e8 0b a8 ff ff       	call   c0100cc6 <__panic>

    const char *str = "ucore: Hello world!!";
c01064bb:	c7 45 dc bc 84 10 c0 	movl   $0xc01084bc,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01064c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01064c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01064c9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01064d0:	e8 1e 0a 00 00       	call   c0106ef3 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01064d5:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01064dc:	00 
c01064dd:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01064e4:	e8 83 0a 00 00       	call   c0106f6c <strcmp>
c01064e9:	85 c0                	test   %eax,%eax
c01064eb:	74 24                	je     c0106511 <check_boot_pgdir+0x2f7>
c01064ed:	c7 44 24 0c d4 84 10 	movl   $0xc01084d4,0xc(%esp)
c01064f4:	c0 
c01064f5:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c01064fc:	c0 
c01064fd:	c7 44 24 04 6e 02 00 	movl   $0x26e,0x4(%esp)
c0106504:	00 
c0106505:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c010650c:	e8 b5 a7 ff ff       	call   c0100cc6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0106511:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106514:	89 04 24             	mov    %eax,(%esp)
c0106517:	e8 ac e8 ff ff       	call   c0104dc8 <page2kva>
c010651c:	05 00 01 00 00       	add    $0x100,%eax
c0106521:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0106524:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010652b:	e8 6b 09 00 00       	call   c0106e9b <strlen>
c0106530:	85 c0                	test   %eax,%eax
c0106532:	74 24                	je     c0106558 <check_boot_pgdir+0x33e>
c0106534:	c7 44 24 0c 0c 85 10 	movl   $0xc010850c,0xc(%esp)
c010653b:	c0 
c010653c:	c7 44 24 08 a5 80 10 	movl   $0xc01080a5,0x8(%esp)
c0106543:	c0 
c0106544:	c7 44 24 04 71 02 00 	movl   $0x271,0x4(%esp)
c010654b:	00 
c010654c:	c7 04 24 80 80 10 c0 	movl   $0xc0108080,(%esp)
c0106553:	e8 6e a7 ff ff       	call   c0100cc6 <__panic>

    free_page(p);
c0106558:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010655f:	00 
c0106560:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106563:	89 04 24             	mov    %eax,(%esp)
c0106566:	e8 2c eb ff ff       	call   c0105097 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c010656b:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0106570:	8b 00                	mov    (%eax),%eax
c0106572:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106577:	89 04 24             	mov    %eax,(%esp)
c010657a:	e8 fa e7 ff ff       	call   c0104d79 <pa2page>
c010657f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106586:	00 
c0106587:	89 04 24             	mov    %eax,(%esp)
c010658a:	e8 08 eb ff ff       	call   c0105097 <free_pages>
    boot_pgdir[0] = 0;
c010658f:	a1 c4 b8 11 c0       	mov    0xc011b8c4,%eax
c0106594:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010659a:	c7 04 24 30 85 10 c0 	movl   $0xc0108530,(%esp)
c01065a1:	e8 96 9d ff ff       	call   c010033c <cprintf>
}
c01065a6:	c9                   	leave  
c01065a7:	c3                   	ret    

c01065a8 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01065a8:	55                   	push   %ebp
c01065a9:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01065ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01065ae:	83 e0 04             	and    $0x4,%eax
c01065b1:	85 c0                	test   %eax,%eax
c01065b3:	74 07                	je     c01065bc <perm2str+0x14>
c01065b5:	b8 75 00 00 00       	mov    $0x75,%eax
c01065ba:	eb 05                	jmp    c01065c1 <perm2str+0x19>
c01065bc:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01065c1:	a2 48 b9 11 c0       	mov    %al,0xc011b948
    str[1] = 'r';
c01065c6:	c6 05 49 b9 11 c0 72 	movb   $0x72,0xc011b949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01065cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01065d0:	83 e0 02             	and    $0x2,%eax
c01065d3:	85 c0                	test   %eax,%eax
c01065d5:	74 07                	je     c01065de <perm2str+0x36>
c01065d7:	b8 77 00 00 00       	mov    $0x77,%eax
c01065dc:	eb 05                	jmp    c01065e3 <perm2str+0x3b>
c01065de:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01065e3:	a2 4a b9 11 c0       	mov    %al,0xc011b94a
    str[3] = '\0';
c01065e8:	c6 05 4b b9 11 c0 00 	movb   $0x0,0xc011b94b
    return str;
c01065ef:	b8 48 b9 11 c0       	mov    $0xc011b948,%eax
}
c01065f4:	5d                   	pop    %ebp
c01065f5:	c3                   	ret    

c01065f6 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01065f6:	55                   	push   %ebp
c01065f7:	89 e5                	mov    %esp,%ebp
c01065f9:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01065fc:	8b 45 10             	mov    0x10(%ebp),%eax
c01065ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106602:	72 0a                	jb     c010660e <get_pgtable_items+0x18>
        return 0;
c0106604:	b8 00 00 00 00       	mov    $0x0,%eax
c0106609:	e9 9c 00 00 00       	jmp    c01066aa <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010660e:	eb 04                	jmp    c0106614 <get_pgtable_items+0x1e>
        start ++;
c0106610:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106614:	8b 45 10             	mov    0x10(%ebp),%eax
c0106617:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010661a:	73 18                	jae    c0106634 <get_pgtable_items+0x3e>
c010661c:	8b 45 10             	mov    0x10(%ebp),%eax
c010661f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106626:	8b 45 14             	mov    0x14(%ebp),%eax
c0106629:	01 d0                	add    %edx,%eax
c010662b:	8b 00                	mov    (%eax),%eax
c010662d:	83 e0 01             	and    $0x1,%eax
c0106630:	85 c0                	test   %eax,%eax
c0106632:	74 dc                	je     c0106610 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0106634:	8b 45 10             	mov    0x10(%ebp),%eax
c0106637:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010663a:	73 69                	jae    c01066a5 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c010663c:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0106640:	74 08                	je     c010664a <get_pgtable_items+0x54>
            *left_store = start;
c0106642:	8b 45 18             	mov    0x18(%ebp),%eax
c0106645:	8b 55 10             	mov    0x10(%ebp),%edx
c0106648:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010664a:	8b 45 10             	mov    0x10(%ebp),%eax
c010664d:	8d 50 01             	lea    0x1(%eax),%edx
c0106650:	89 55 10             	mov    %edx,0x10(%ebp)
c0106653:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010665a:	8b 45 14             	mov    0x14(%ebp),%eax
c010665d:	01 d0                	add    %edx,%eax
c010665f:	8b 00                	mov    (%eax),%eax
c0106661:	83 e0 07             	and    $0x7,%eax
c0106664:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106667:	eb 04                	jmp    c010666d <get_pgtable_items+0x77>
            start ++;
c0106669:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010666d:	8b 45 10             	mov    0x10(%ebp),%eax
c0106670:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106673:	73 1d                	jae    c0106692 <get_pgtable_items+0x9c>
c0106675:	8b 45 10             	mov    0x10(%ebp),%eax
c0106678:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010667f:	8b 45 14             	mov    0x14(%ebp),%eax
c0106682:	01 d0                	add    %edx,%eax
c0106684:	8b 00                	mov    (%eax),%eax
c0106686:	83 e0 07             	and    $0x7,%eax
c0106689:	89 c2                	mov    %eax,%edx
c010668b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010668e:	39 c2                	cmp    %eax,%edx
c0106690:	74 d7                	je     c0106669 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0106692:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106696:	74 08                	je     c01066a0 <get_pgtable_items+0xaa>
            *right_store = start;
c0106698:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010669b:	8b 55 10             	mov    0x10(%ebp),%edx
c010669e:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01066a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01066a3:	eb 05                	jmp    c01066aa <get_pgtable_items+0xb4>
    }
    return 0;
c01066a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01066aa:	c9                   	leave  
c01066ab:	c3                   	ret    

c01066ac <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01066ac:	55                   	push   %ebp
c01066ad:	89 e5                	mov    %esp,%ebp
c01066af:	57                   	push   %edi
c01066b0:	56                   	push   %esi
c01066b1:	53                   	push   %ebx
c01066b2:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01066b5:	c7 04 24 50 85 10 c0 	movl   $0xc0108550,(%esp)
c01066bc:	e8 7b 9c ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c01066c1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01066c8:	e9 fa 00 00 00       	jmp    c01067c7 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01066cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01066d0:	89 04 24             	mov    %eax,(%esp)
c01066d3:	e8 d0 fe ff ff       	call   c01065a8 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01066d8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01066db:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01066de:	29 d1                	sub    %edx,%ecx
c01066e0:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01066e2:	89 d6                	mov    %edx,%esi
c01066e4:	c1 e6 16             	shl    $0x16,%esi
c01066e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01066ea:	89 d3                	mov    %edx,%ebx
c01066ec:	c1 e3 16             	shl    $0x16,%ebx
c01066ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01066f2:	89 d1                	mov    %edx,%ecx
c01066f4:	c1 e1 16             	shl    $0x16,%ecx
c01066f7:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01066fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01066fd:	29 d7                	sub    %edx,%edi
c01066ff:	89 fa                	mov    %edi,%edx
c0106701:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106705:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106709:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010670d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106711:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106715:	c7 04 24 81 85 10 c0 	movl   $0xc0108581,(%esp)
c010671c:	e8 1b 9c ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0106721:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106724:	c1 e0 0a             	shl    $0xa,%eax
c0106727:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010672a:	eb 54                	jmp    c0106780 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010672c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010672f:	89 04 24             	mov    %eax,(%esp)
c0106732:	e8 71 fe ff ff       	call   c01065a8 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106737:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010673a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010673d:	29 d1                	sub    %edx,%ecx
c010673f:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106741:	89 d6                	mov    %edx,%esi
c0106743:	c1 e6 0c             	shl    $0xc,%esi
c0106746:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106749:	89 d3                	mov    %edx,%ebx
c010674b:	c1 e3 0c             	shl    $0xc,%ebx
c010674e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106751:	c1 e2 0c             	shl    $0xc,%edx
c0106754:	89 d1                	mov    %edx,%ecx
c0106756:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0106759:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010675c:	29 d7                	sub    %edx,%edi
c010675e:	89 fa                	mov    %edi,%edx
c0106760:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106764:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106768:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010676c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106770:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106774:	c7 04 24 a0 85 10 c0 	movl   $0xc01085a0,(%esp)
c010677b:	e8 bc 9b ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106780:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0106785:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106788:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010678b:	89 ce                	mov    %ecx,%esi
c010678d:	c1 e6 0a             	shl    $0xa,%esi
c0106790:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106793:	89 cb                	mov    %ecx,%ebx
c0106795:	c1 e3 0a             	shl    $0xa,%ebx
c0106798:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c010679b:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010679f:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01067a2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01067a6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01067aa:	89 44 24 08          	mov    %eax,0x8(%esp)
c01067ae:	89 74 24 04          	mov    %esi,0x4(%esp)
c01067b2:	89 1c 24             	mov    %ebx,(%esp)
c01067b5:	e8 3c fe ff ff       	call   c01065f6 <get_pgtable_items>
c01067ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01067bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01067c1:	0f 85 65 ff ff ff    	jne    c010672c <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01067c7:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01067cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01067cf:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01067d2:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01067d6:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01067d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01067dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01067e1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01067e5:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01067ec:	00 
c01067ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01067f4:	e8 fd fd ff ff       	call   c01065f6 <get_pgtable_items>
c01067f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01067fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106800:	0f 85 c7 fe ff ff    	jne    c01066cd <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106806:	c7 04 24 c4 85 10 c0 	movl   $0xc01085c4,(%esp)
c010680d:	e8 2a 9b ff ff       	call   c010033c <cprintf>
}
c0106812:	83 c4 4c             	add    $0x4c,%esp
c0106815:	5b                   	pop    %ebx
c0106816:	5e                   	pop    %esi
c0106817:	5f                   	pop    %edi
c0106818:	5d                   	pop    %ebp
c0106819:	c3                   	ret    

c010681a <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010681a:	55                   	push   %ebp
c010681b:	89 e5                	mov    %esp,%ebp
c010681d:	83 ec 58             	sub    $0x58,%esp
c0106820:	8b 45 10             	mov    0x10(%ebp),%eax
c0106823:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106826:	8b 45 14             	mov    0x14(%ebp),%eax
c0106829:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010682c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010682f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106832:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106835:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0106838:	8b 45 18             	mov    0x18(%ebp),%eax
c010683b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010683e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106841:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106844:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106847:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010684a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010684d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106850:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106854:	74 1c                	je     c0106872 <printnum+0x58>
c0106856:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106859:	ba 00 00 00 00       	mov    $0x0,%edx
c010685e:	f7 75 e4             	divl   -0x1c(%ebp)
c0106861:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0106864:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106867:	ba 00 00 00 00       	mov    $0x0,%edx
c010686c:	f7 75 e4             	divl   -0x1c(%ebp)
c010686f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106872:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106875:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106878:	f7 75 e4             	divl   -0x1c(%ebp)
c010687b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010687e:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106881:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106884:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106887:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010688a:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010688d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106890:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0106893:	8b 45 18             	mov    0x18(%ebp),%eax
c0106896:	ba 00 00 00 00       	mov    $0x0,%edx
c010689b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010689e:	77 56                	ja     c01068f6 <printnum+0xdc>
c01068a0:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01068a3:	72 05                	jb     c01068aa <printnum+0x90>
c01068a5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01068a8:	77 4c                	ja     c01068f6 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01068aa:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01068ad:	8d 50 ff             	lea    -0x1(%eax),%edx
c01068b0:	8b 45 20             	mov    0x20(%ebp),%eax
c01068b3:	89 44 24 18          	mov    %eax,0x18(%esp)
c01068b7:	89 54 24 14          	mov    %edx,0x14(%esp)
c01068bb:	8b 45 18             	mov    0x18(%ebp),%eax
c01068be:	89 44 24 10          	mov    %eax,0x10(%esp)
c01068c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01068c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01068c8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01068cc:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01068d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01068d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01068d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01068da:	89 04 24             	mov    %eax,(%esp)
c01068dd:	e8 38 ff ff ff       	call   c010681a <printnum>
c01068e2:	eb 1c                	jmp    c0106900 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01068e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01068e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01068eb:	8b 45 20             	mov    0x20(%ebp),%eax
c01068ee:	89 04 24             	mov    %eax,(%esp)
c01068f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01068f4:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01068f6:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01068fa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01068fe:	7f e4                	jg     c01068e4 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0106900:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106903:	05 78 86 10 c0       	add    $0xc0108678,%eax
c0106908:	0f b6 00             	movzbl (%eax),%eax
c010690b:	0f be c0             	movsbl %al,%eax
c010690e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106911:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106915:	89 04 24             	mov    %eax,(%esp)
c0106918:	8b 45 08             	mov    0x8(%ebp),%eax
c010691b:	ff d0                	call   *%eax
}
c010691d:	c9                   	leave  
c010691e:	c3                   	ret    

c010691f <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010691f:	55                   	push   %ebp
c0106920:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0106922:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0106926:	7e 14                	jle    c010693c <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0106928:	8b 45 08             	mov    0x8(%ebp),%eax
c010692b:	8b 00                	mov    (%eax),%eax
c010692d:	8d 48 08             	lea    0x8(%eax),%ecx
c0106930:	8b 55 08             	mov    0x8(%ebp),%edx
c0106933:	89 0a                	mov    %ecx,(%edx)
c0106935:	8b 50 04             	mov    0x4(%eax),%edx
c0106938:	8b 00                	mov    (%eax),%eax
c010693a:	eb 30                	jmp    c010696c <getuint+0x4d>
    }
    else if (lflag) {
c010693c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106940:	74 16                	je     c0106958 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0106942:	8b 45 08             	mov    0x8(%ebp),%eax
c0106945:	8b 00                	mov    (%eax),%eax
c0106947:	8d 48 04             	lea    0x4(%eax),%ecx
c010694a:	8b 55 08             	mov    0x8(%ebp),%edx
c010694d:	89 0a                	mov    %ecx,(%edx)
c010694f:	8b 00                	mov    (%eax),%eax
c0106951:	ba 00 00 00 00       	mov    $0x0,%edx
c0106956:	eb 14                	jmp    c010696c <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0106958:	8b 45 08             	mov    0x8(%ebp),%eax
c010695b:	8b 00                	mov    (%eax),%eax
c010695d:	8d 48 04             	lea    0x4(%eax),%ecx
c0106960:	8b 55 08             	mov    0x8(%ebp),%edx
c0106963:	89 0a                	mov    %ecx,(%edx)
c0106965:	8b 00                	mov    (%eax),%eax
c0106967:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010696c:	5d                   	pop    %ebp
c010696d:	c3                   	ret    

c010696e <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010696e:	55                   	push   %ebp
c010696f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0106971:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0106975:	7e 14                	jle    c010698b <getint+0x1d>
        return va_arg(*ap, long long);
c0106977:	8b 45 08             	mov    0x8(%ebp),%eax
c010697a:	8b 00                	mov    (%eax),%eax
c010697c:	8d 48 08             	lea    0x8(%eax),%ecx
c010697f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106982:	89 0a                	mov    %ecx,(%edx)
c0106984:	8b 50 04             	mov    0x4(%eax),%edx
c0106987:	8b 00                	mov    (%eax),%eax
c0106989:	eb 28                	jmp    c01069b3 <getint+0x45>
    }
    else if (lflag) {
c010698b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010698f:	74 12                	je     c01069a3 <getint+0x35>
        return va_arg(*ap, long);
c0106991:	8b 45 08             	mov    0x8(%ebp),%eax
c0106994:	8b 00                	mov    (%eax),%eax
c0106996:	8d 48 04             	lea    0x4(%eax),%ecx
c0106999:	8b 55 08             	mov    0x8(%ebp),%edx
c010699c:	89 0a                	mov    %ecx,(%edx)
c010699e:	8b 00                	mov    (%eax),%eax
c01069a0:	99                   	cltd   
c01069a1:	eb 10                	jmp    c01069b3 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01069a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01069a6:	8b 00                	mov    (%eax),%eax
c01069a8:	8d 48 04             	lea    0x4(%eax),%ecx
c01069ab:	8b 55 08             	mov    0x8(%ebp),%edx
c01069ae:	89 0a                	mov    %ecx,(%edx)
c01069b0:	8b 00                	mov    (%eax),%eax
c01069b2:	99                   	cltd   
    }
}
c01069b3:	5d                   	pop    %ebp
c01069b4:	c3                   	ret    

c01069b5 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01069b5:	55                   	push   %ebp
c01069b6:	89 e5                	mov    %esp,%ebp
c01069b8:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01069bb:	8d 45 14             	lea    0x14(%ebp),%eax
c01069be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01069c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01069c8:	8b 45 10             	mov    0x10(%ebp),%eax
c01069cb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01069cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01069d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01069d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01069d9:	89 04 24             	mov    %eax,(%esp)
c01069dc:	e8 02 00 00 00       	call   c01069e3 <vprintfmt>
    va_end(ap);
}
c01069e1:	c9                   	leave  
c01069e2:	c3                   	ret    

c01069e3 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01069e3:	55                   	push   %ebp
c01069e4:	89 e5                	mov    %esp,%ebp
c01069e6:	56                   	push   %esi
c01069e7:	53                   	push   %ebx
c01069e8:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01069eb:	eb 18                	jmp    c0106a05 <vprintfmt+0x22>
            if (ch == '\0') {
c01069ed:	85 db                	test   %ebx,%ebx
c01069ef:	75 05                	jne    c01069f6 <vprintfmt+0x13>
                return;
c01069f1:	e9 d1 03 00 00       	jmp    c0106dc7 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01069f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01069f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01069fd:	89 1c 24             	mov    %ebx,(%esp)
c0106a00:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a03:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106a05:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a08:	8d 50 01             	lea    0x1(%eax),%edx
c0106a0b:	89 55 10             	mov    %edx,0x10(%ebp)
c0106a0e:	0f b6 00             	movzbl (%eax),%eax
c0106a11:	0f b6 d8             	movzbl %al,%ebx
c0106a14:	83 fb 25             	cmp    $0x25,%ebx
c0106a17:	75 d4                	jne    c01069ed <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0106a19:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0106a1d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0106a24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106a27:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0106a2a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106a31:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a34:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0106a37:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a3a:	8d 50 01             	lea    0x1(%eax),%edx
c0106a3d:	89 55 10             	mov    %edx,0x10(%ebp)
c0106a40:	0f b6 00             	movzbl (%eax),%eax
c0106a43:	0f b6 d8             	movzbl %al,%ebx
c0106a46:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0106a49:	83 f8 55             	cmp    $0x55,%eax
c0106a4c:	0f 87 44 03 00 00    	ja     c0106d96 <vprintfmt+0x3b3>
c0106a52:	8b 04 85 9c 86 10 c0 	mov    -0x3fef7964(,%eax,4),%eax
c0106a59:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0106a5b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0106a5f:	eb d6                	jmp    c0106a37 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0106a61:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0106a65:	eb d0                	jmp    c0106a37 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0106a67:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0106a6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106a71:	89 d0                	mov    %edx,%eax
c0106a73:	c1 e0 02             	shl    $0x2,%eax
c0106a76:	01 d0                	add    %edx,%eax
c0106a78:	01 c0                	add    %eax,%eax
c0106a7a:	01 d8                	add    %ebx,%eax
c0106a7c:	83 e8 30             	sub    $0x30,%eax
c0106a7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0106a82:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a85:	0f b6 00             	movzbl (%eax),%eax
c0106a88:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0106a8b:	83 fb 2f             	cmp    $0x2f,%ebx
c0106a8e:	7e 0b                	jle    c0106a9b <vprintfmt+0xb8>
c0106a90:	83 fb 39             	cmp    $0x39,%ebx
c0106a93:	7f 06                	jg     c0106a9b <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0106a95:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0106a99:	eb d3                	jmp    c0106a6e <vprintfmt+0x8b>
            goto process_precision;
c0106a9b:	eb 33                	jmp    c0106ad0 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0106a9d:	8b 45 14             	mov    0x14(%ebp),%eax
c0106aa0:	8d 50 04             	lea    0x4(%eax),%edx
c0106aa3:	89 55 14             	mov    %edx,0x14(%ebp)
c0106aa6:	8b 00                	mov    (%eax),%eax
c0106aa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0106aab:	eb 23                	jmp    c0106ad0 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0106aad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106ab1:	79 0c                	jns    c0106abf <vprintfmt+0xdc>
                width = 0;
c0106ab3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0106aba:	e9 78 ff ff ff       	jmp    c0106a37 <vprintfmt+0x54>
c0106abf:	e9 73 ff ff ff       	jmp    c0106a37 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0106ac4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0106acb:	e9 67 ff ff ff       	jmp    c0106a37 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0106ad0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106ad4:	79 12                	jns    c0106ae8 <vprintfmt+0x105>
                width = precision, precision = -1;
c0106ad6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ad9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106adc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0106ae3:	e9 4f ff ff ff       	jmp    c0106a37 <vprintfmt+0x54>
c0106ae8:	e9 4a ff ff ff       	jmp    c0106a37 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0106aed:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0106af1:	e9 41 ff ff ff       	jmp    c0106a37 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0106af6:	8b 45 14             	mov    0x14(%ebp),%eax
c0106af9:	8d 50 04             	lea    0x4(%eax),%edx
c0106afc:	89 55 14             	mov    %edx,0x14(%ebp)
c0106aff:	8b 00                	mov    (%eax),%eax
c0106b01:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106b04:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106b08:	89 04 24             	mov    %eax,(%esp)
c0106b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b0e:	ff d0                	call   *%eax
            break;
c0106b10:	e9 ac 02 00 00       	jmp    c0106dc1 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0106b15:	8b 45 14             	mov    0x14(%ebp),%eax
c0106b18:	8d 50 04             	lea    0x4(%eax),%edx
c0106b1b:	89 55 14             	mov    %edx,0x14(%ebp)
c0106b1e:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0106b20:	85 db                	test   %ebx,%ebx
c0106b22:	79 02                	jns    c0106b26 <vprintfmt+0x143>
                err = -err;
c0106b24:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0106b26:	83 fb 06             	cmp    $0x6,%ebx
c0106b29:	7f 0b                	jg     c0106b36 <vprintfmt+0x153>
c0106b2b:	8b 34 9d 5c 86 10 c0 	mov    -0x3fef79a4(,%ebx,4),%esi
c0106b32:	85 f6                	test   %esi,%esi
c0106b34:	75 23                	jne    c0106b59 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0106b36:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106b3a:	c7 44 24 08 89 86 10 	movl   $0xc0108689,0x8(%esp)
c0106b41:	c0 
c0106b42:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106b45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b4c:	89 04 24             	mov    %eax,(%esp)
c0106b4f:	e8 61 fe ff ff       	call   c01069b5 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0106b54:	e9 68 02 00 00       	jmp    c0106dc1 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0106b59:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0106b5d:	c7 44 24 08 92 86 10 	movl   $0xc0108692,0x8(%esp)
c0106b64:	c0 
c0106b65:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106b68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b6f:	89 04 24             	mov    %eax,(%esp)
c0106b72:	e8 3e fe ff ff       	call   c01069b5 <printfmt>
            }
            break;
c0106b77:	e9 45 02 00 00       	jmp    c0106dc1 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0106b7c:	8b 45 14             	mov    0x14(%ebp),%eax
c0106b7f:	8d 50 04             	lea    0x4(%eax),%edx
c0106b82:	89 55 14             	mov    %edx,0x14(%ebp)
c0106b85:	8b 30                	mov    (%eax),%esi
c0106b87:	85 f6                	test   %esi,%esi
c0106b89:	75 05                	jne    c0106b90 <vprintfmt+0x1ad>
                p = "(null)";
c0106b8b:	be 95 86 10 c0       	mov    $0xc0108695,%esi
            }
            if (width > 0 && padc != '-') {
c0106b90:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106b94:	7e 3e                	jle    c0106bd4 <vprintfmt+0x1f1>
c0106b96:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0106b9a:	74 38                	je     c0106bd4 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106b9c:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0106b9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106ba6:	89 34 24             	mov    %esi,(%esp)
c0106ba9:	e8 15 03 00 00       	call   c0106ec3 <strnlen>
c0106bae:	29 c3                	sub    %eax,%ebx
c0106bb0:	89 d8                	mov    %ebx,%eax
c0106bb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106bb5:	eb 17                	jmp    c0106bce <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0106bb7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0106bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106bbe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106bc2:	89 04 24             	mov    %eax,(%esp)
c0106bc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bc8:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106bca:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0106bce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106bd2:	7f e3                	jg     c0106bb7 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106bd4:	eb 38                	jmp    c0106c0e <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0106bd6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106bda:	74 1f                	je     c0106bfb <vprintfmt+0x218>
c0106bdc:	83 fb 1f             	cmp    $0x1f,%ebx
c0106bdf:	7e 05                	jle    c0106be6 <vprintfmt+0x203>
c0106be1:	83 fb 7e             	cmp    $0x7e,%ebx
c0106be4:	7e 15                	jle    c0106bfb <vprintfmt+0x218>
                    putch('?', putdat);
c0106be6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106be9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bed:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0106bf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bf7:	ff d0                	call   *%eax
c0106bf9:	eb 0f                	jmp    c0106c0a <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0106bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c02:	89 1c 24             	mov    %ebx,(%esp)
c0106c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c08:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106c0a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0106c0e:	89 f0                	mov    %esi,%eax
c0106c10:	8d 70 01             	lea    0x1(%eax),%esi
c0106c13:	0f b6 00             	movzbl (%eax),%eax
c0106c16:	0f be d8             	movsbl %al,%ebx
c0106c19:	85 db                	test   %ebx,%ebx
c0106c1b:	74 10                	je     c0106c2d <vprintfmt+0x24a>
c0106c1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106c21:	78 b3                	js     c0106bd6 <vprintfmt+0x1f3>
c0106c23:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0106c27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106c2b:	79 a9                	jns    c0106bd6 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0106c2d:	eb 17                	jmp    c0106c46 <vprintfmt+0x263>
                putch(' ', putdat);
c0106c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c36:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0106c3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c40:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0106c42:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0106c46:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106c4a:	7f e3                	jg     c0106c2f <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0106c4c:	e9 70 01 00 00       	jmp    c0106dc1 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0106c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c58:	8d 45 14             	lea    0x14(%ebp),%eax
c0106c5b:	89 04 24             	mov    %eax,(%esp)
c0106c5e:	e8 0b fd ff ff       	call   c010696e <getint>
c0106c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c66:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0106c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106c6f:	85 d2                	test   %edx,%edx
c0106c71:	79 26                	jns    c0106c99 <vprintfmt+0x2b6>
                putch('-', putdat);
c0106c73:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c7a:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0106c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c84:	ff d0                	call   *%eax
                num = -(long long)num;
c0106c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106c8c:	f7 d8                	neg    %eax
c0106c8e:	83 d2 00             	adc    $0x0,%edx
c0106c91:	f7 da                	neg    %edx
c0106c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c96:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0106c99:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106ca0:	e9 a8 00 00 00       	jmp    c0106d4d <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0106ca5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cac:	8d 45 14             	lea    0x14(%ebp),%eax
c0106caf:	89 04 24             	mov    %eax,(%esp)
c0106cb2:	e8 68 fc ff ff       	call   c010691f <getuint>
c0106cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106cba:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0106cbd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106cc4:	e9 84 00 00 00       	jmp    c0106d4d <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0106cc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cd0:	8d 45 14             	lea    0x14(%ebp),%eax
c0106cd3:	89 04 24             	mov    %eax,(%esp)
c0106cd6:	e8 44 fc ff ff       	call   c010691f <getuint>
c0106cdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106cde:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0106ce1:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0106ce8:	eb 63                	jmp    c0106d4d <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0106cea:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ced:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cf1:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0106cf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cfb:	ff d0                	call   *%eax
            putch('x', putdat);
c0106cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d04:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0106d0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d0e:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0106d10:	8b 45 14             	mov    0x14(%ebp),%eax
c0106d13:	8d 50 04             	lea    0x4(%eax),%edx
c0106d16:	89 55 14             	mov    %edx,0x14(%ebp)
c0106d19:	8b 00                	mov    (%eax),%eax
c0106d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0106d25:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0106d2c:	eb 1f                	jmp    c0106d4d <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0106d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d35:	8d 45 14             	lea    0x14(%ebp),%eax
c0106d38:	89 04 24             	mov    %eax,(%esp)
c0106d3b:	e8 df fb ff ff       	call   c010691f <getuint>
c0106d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d43:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0106d46:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0106d4d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0106d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d54:	89 54 24 18          	mov    %edx,0x18(%esp)
c0106d58:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106d5b:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106d5f:	89 44 24 10          	mov    %eax,0x10(%esp)
c0106d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d66:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106d69:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106d6d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106d71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d78:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d7b:	89 04 24             	mov    %eax,(%esp)
c0106d7e:	e8 97 fa ff ff       	call   c010681a <printnum>
            break;
c0106d83:	eb 3c                	jmp    c0106dc1 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0106d85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d8c:	89 1c 24             	mov    %ebx,(%esp)
c0106d8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d92:	ff d0                	call   *%eax
            break;
c0106d94:	eb 2b                	jmp    c0106dc1 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106d96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d9d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0106da4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106da7:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0106da9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106dad:	eb 04                	jmp    c0106db3 <vprintfmt+0x3d0>
c0106daf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106db3:	8b 45 10             	mov    0x10(%ebp),%eax
c0106db6:	83 e8 01             	sub    $0x1,%eax
c0106db9:	0f b6 00             	movzbl (%eax),%eax
c0106dbc:	3c 25                	cmp    $0x25,%al
c0106dbe:	75 ef                	jne    c0106daf <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0106dc0:	90                   	nop
        }
    }
c0106dc1:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106dc2:	e9 3e fc ff ff       	jmp    c0106a05 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0106dc7:	83 c4 40             	add    $0x40,%esp
c0106dca:	5b                   	pop    %ebx
c0106dcb:	5e                   	pop    %esi
c0106dcc:	5d                   	pop    %ebp
c0106dcd:	c3                   	ret    

c0106dce <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0106dce:	55                   	push   %ebp
c0106dcf:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0106dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106dd4:	8b 40 08             	mov    0x8(%eax),%eax
c0106dd7:	8d 50 01             	lea    0x1(%eax),%edx
c0106dda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ddd:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0106de0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106de3:	8b 10                	mov    (%eax),%edx
c0106de5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106de8:	8b 40 04             	mov    0x4(%eax),%eax
c0106deb:	39 c2                	cmp    %eax,%edx
c0106ded:	73 12                	jae    c0106e01 <sprintputch+0x33>
        *b->buf ++ = ch;
c0106def:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106df2:	8b 00                	mov    (%eax),%eax
c0106df4:	8d 48 01             	lea    0x1(%eax),%ecx
c0106df7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106dfa:	89 0a                	mov    %ecx,(%edx)
c0106dfc:	8b 55 08             	mov    0x8(%ebp),%edx
c0106dff:	88 10                	mov    %dl,(%eax)
    }
}
c0106e01:	5d                   	pop    %ebp
c0106e02:	c3                   	ret    

c0106e03 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0106e03:	55                   	push   %ebp
c0106e04:	89 e5                	mov    %esp,%ebp
c0106e06:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106e09:	8d 45 14             	lea    0x14(%ebp),%eax
c0106e0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0106e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e12:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106e16:	8b 45 10             	mov    0x10(%ebp),%eax
c0106e19:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e24:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e27:	89 04 24             	mov    %eax,(%esp)
c0106e2a:	e8 08 00 00 00       	call   c0106e37 <vsnprintf>
c0106e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0106e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106e35:	c9                   	leave  
c0106e36:	c3                   	ret    

c0106e37 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0106e37:	55                   	push   %ebp
c0106e38:	89 e5                	mov    %esp,%ebp
c0106e3a:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0106e3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e40:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106e43:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e46:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106e49:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e4c:	01 d0                	add    %edx,%eax
c0106e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106e51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0106e58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106e5c:	74 0a                	je     c0106e68 <vsnprintf+0x31>
c0106e5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e64:	39 c2                	cmp    %eax,%edx
c0106e66:	76 07                	jbe    c0106e6f <vsnprintf+0x38>
        return -E_INVAL;
c0106e68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0106e6d:	eb 2a                	jmp    c0106e99 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0106e6f:	8b 45 14             	mov    0x14(%ebp),%eax
c0106e72:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106e76:	8b 45 10             	mov    0x10(%ebp),%eax
c0106e79:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106e7d:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0106e80:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e84:	c7 04 24 ce 6d 10 c0 	movl   $0xc0106dce,(%esp)
c0106e8b:	e8 53 fb ff ff       	call   c01069e3 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0106e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106e93:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0106e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106e99:	c9                   	leave  
c0106e9a:	c3                   	ret    

c0106e9b <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0106e9b:	55                   	push   %ebp
c0106e9c:	89 e5                	mov    %esp,%ebp
c0106e9e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0106ea1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0106ea8:	eb 04                	jmp    c0106eae <strlen+0x13>
        cnt ++;
c0106eaa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0106eae:	8b 45 08             	mov    0x8(%ebp),%eax
c0106eb1:	8d 50 01             	lea    0x1(%eax),%edx
c0106eb4:	89 55 08             	mov    %edx,0x8(%ebp)
c0106eb7:	0f b6 00             	movzbl (%eax),%eax
c0106eba:	84 c0                	test   %al,%al
c0106ebc:	75 ec                	jne    c0106eaa <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0106ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0106ec1:	c9                   	leave  
c0106ec2:	c3                   	ret    

c0106ec3 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0106ec3:	55                   	push   %ebp
c0106ec4:	89 e5                	mov    %esp,%ebp
c0106ec6:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0106ec9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0106ed0:	eb 04                	jmp    c0106ed6 <strnlen+0x13>
        cnt ++;
c0106ed2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0106ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106ed9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106edc:	73 10                	jae    c0106eee <strnlen+0x2b>
c0106ede:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ee1:	8d 50 01             	lea    0x1(%eax),%edx
c0106ee4:	89 55 08             	mov    %edx,0x8(%ebp)
c0106ee7:	0f b6 00             	movzbl (%eax),%eax
c0106eea:	84 c0                	test   %al,%al
c0106eec:	75 e4                	jne    c0106ed2 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0106eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0106ef1:	c9                   	leave  
c0106ef2:	c3                   	ret    

c0106ef3 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0106ef3:	55                   	push   %ebp
c0106ef4:	89 e5                	mov    %esp,%ebp
c0106ef6:	57                   	push   %edi
c0106ef7:	56                   	push   %esi
c0106ef8:	83 ec 20             	sub    $0x20,%esp
c0106efb:	8b 45 08             	mov    0x8(%ebp),%eax
c0106efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106f01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f04:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0106f07:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f0d:	89 d1                	mov    %edx,%ecx
c0106f0f:	89 c2                	mov    %eax,%edx
c0106f11:	89 ce                	mov    %ecx,%esi
c0106f13:	89 d7                	mov    %edx,%edi
c0106f15:	ac                   	lods   %ds:(%esi),%al
c0106f16:	aa                   	stos   %al,%es:(%edi)
c0106f17:	84 c0                	test   %al,%al
c0106f19:	75 fa                	jne    c0106f15 <strcpy+0x22>
c0106f1b:	89 fa                	mov    %edi,%edx
c0106f1d:	89 f1                	mov    %esi,%ecx
c0106f1f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0106f22:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0106f25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0106f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0106f2b:	83 c4 20             	add    $0x20,%esp
c0106f2e:	5e                   	pop    %esi
c0106f2f:	5f                   	pop    %edi
c0106f30:	5d                   	pop    %ebp
c0106f31:	c3                   	ret    

c0106f32 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0106f32:	55                   	push   %ebp
c0106f33:	89 e5                	mov    %esp,%ebp
c0106f35:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0106f38:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0106f3e:	eb 21                	jmp    c0106f61 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0106f40:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f43:	0f b6 10             	movzbl (%eax),%edx
c0106f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106f49:	88 10                	mov    %dl,(%eax)
c0106f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106f4e:	0f b6 00             	movzbl (%eax),%eax
c0106f51:	84 c0                	test   %al,%al
c0106f53:	74 04                	je     c0106f59 <strncpy+0x27>
            src ++;
c0106f55:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0106f59:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0106f5d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0106f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106f65:	75 d9                	jne    c0106f40 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0106f67:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0106f6a:	c9                   	leave  
c0106f6b:	c3                   	ret    

c0106f6c <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0106f6c:	55                   	push   %ebp
c0106f6d:	89 e5                	mov    %esp,%ebp
c0106f6f:	57                   	push   %edi
c0106f70:	56                   	push   %esi
c0106f71:	83 ec 20             	sub    $0x20,%esp
c0106f74:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f77:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0106f80:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f86:	89 d1                	mov    %edx,%ecx
c0106f88:	89 c2                	mov    %eax,%edx
c0106f8a:	89 ce                	mov    %ecx,%esi
c0106f8c:	89 d7                	mov    %edx,%edi
c0106f8e:	ac                   	lods   %ds:(%esi),%al
c0106f8f:	ae                   	scas   %es:(%edi),%al
c0106f90:	75 08                	jne    c0106f9a <strcmp+0x2e>
c0106f92:	84 c0                	test   %al,%al
c0106f94:	75 f8                	jne    c0106f8e <strcmp+0x22>
c0106f96:	31 c0                	xor    %eax,%eax
c0106f98:	eb 04                	jmp    c0106f9e <strcmp+0x32>
c0106f9a:	19 c0                	sbb    %eax,%eax
c0106f9c:	0c 01                	or     $0x1,%al
c0106f9e:	89 fa                	mov    %edi,%edx
c0106fa0:	89 f1                	mov    %esi,%ecx
c0106fa2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106fa5:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106fa8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0106fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0106fae:	83 c4 20             	add    $0x20,%esp
c0106fb1:	5e                   	pop    %esi
c0106fb2:	5f                   	pop    %edi
c0106fb3:	5d                   	pop    %ebp
c0106fb4:	c3                   	ret    

c0106fb5 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0106fb5:	55                   	push   %ebp
c0106fb6:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0106fb8:	eb 0c                	jmp    c0106fc6 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0106fba:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106fbe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0106fc2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0106fc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106fca:	74 1a                	je     c0106fe6 <strncmp+0x31>
c0106fcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fcf:	0f b6 00             	movzbl (%eax),%eax
c0106fd2:	84 c0                	test   %al,%al
c0106fd4:	74 10                	je     c0106fe6 <strncmp+0x31>
c0106fd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fd9:	0f b6 10             	movzbl (%eax),%edx
c0106fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106fdf:	0f b6 00             	movzbl (%eax),%eax
c0106fe2:	38 c2                	cmp    %al,%dl
c0106fe4:	74 d4                	je     c0106fba <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106fe6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106fea:	74 18                	je     c0107004 <strncmp+0x4f>
c0106fec:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fef:	0f b6 00             	movzbl (%eax),%eax
c0106ff2:	0f b6 d0             	movzbl %al,%edx
c0106ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ff8:	0f b6 00             	movzbl (%eax),%eax
c0106ffb:	0f b6 c0             	movzbl %al,%eax
c0106ffe:	29 c2                	sub    %eax,%edx
c0107000:	89 d0                	mov    %edx,%eax
c0107002:	eb 05                	jmp    c0107009 <strncmp+0x54>
c0107004:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107009:	5d                   	pop    %ebp
c010700a:	c3                   	ret    

c010700b <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010700b:	55                   	push   %ebp
c010700c:	89 e5                	mov    %esp,%ebp
c010700e:	83 ec 04             	sub    $0x4,%esp
c0107011:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107014:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0107017:	eb 14                	jmp    c010702d <strchr+0x22>
        if (*s == c) {
c0107019:	8b 45 08             	mov    0x8(%ebp),%eax
c010701c:	0f b6 00             	movzbl (%eax),%eax
c010701f:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0107022:	75 05                	jne    c0107029 <strchr+0x1e>
            return (char *)s;
c0107024:	8b 45 08             	mov    0x8(%ebp),%eax
c0107027:	eb 13                	jmp    c010703c <strchr+0x31>
        }
        s ++;
c0107029:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010702d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107030:	0f b6 00             	movzbl (%eax),%eax
c0107033:	84 c0                	test   %al,%al
c0107035:	75 e2                	jne    c0107019 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0107037:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010703c:	c9                   	leave  
c010703d:	c3                   	ret    

c010703e <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010703e:	55                   	push   %ebp
c010703f:	89 e5                	mov    %esp,%ebp
c0107041:	83 ec 04             	sub    $0x4,%esp
c0107044:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107047:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010704a:	eb 11                	jmp    c010705d <strfind+0x1f>
        if (*s == c) {
c010704c:	8b 45 08             	mov    0x8(%ebp),%eax
c010704f:	0f b6 00             	movzbl (%eax),%eax
c0107052:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0107055:	75 02                	jne    c0107059 <strfind+0x1b>
            break;
c0107057:	eb 0e                	jmp    c0107067 <strfind+0x29>
        }
        s ++;
c0107059:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010705d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107060:	0f b6 00             	movzbl (%eax),%eax
c0107063:	84 c0                	test   %al,%al
c0107065:	75 e5                	jne    c010704c <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0107067:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010706a:	c9                   	leave  
c010706b:	c3                   	ret    

c010706c <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010706c:	55                   	push   %ebp
c010706d:	89 e5                	mov    %esp,%ebp
c010706f:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0107072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0107079:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0107080:	eb 04                	jmp    c0107086 <strtol+0x1a>
        s ++;
c0107082:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0107086:	8b 45 08             	mov    0x8(%ebp),%eax
c0107089:	0f b6 00             	movzbl (%eax),%eax
c010708c:	3c 20                	cmp    $0x20,%al
c010708e:	74 f2                	je     c0107082 <strtol+0x16>
c0107090:	8b 45 08             	mov    0x8(%ebp),%eax
c0107093:	0f b6 00             	movzbl (%eax),%eax
c0107096:	3c 09                	cmp    $0x9,%al
c0107098:	74 e8                	je     c0107082 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c010709a:	8b 45 08             	mov    0x8(%ebp),%eax
c010709d:	0f b6 00             	movzbl (%eax),%eax
c01070a0:	3c 2b                	cmp    $0x2b,%al
c01070a2:	75 06                	jne    c01070aa <strtol+0x3e>
        s ++;
c01070a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01070a8:	eb 15                	jmp    c01070bf <strtol+0x53>
    }
    else if (*s == '-') {
c01070aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01070ad:	0f b6 00             	movzbl (%eax),%eax
c01070b0:	3c 2d                	cmp    $0x2d,%al
c01070b2:	75 0b                	jne    c01070bf <strtol+0x53>
        s ++, neg = 1;
c01070b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01070b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01070bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01070c3:	74 06                	je     c01070cb <strtol+0x5f>
c01070c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01070c9:	75 24                	jne    c01070ef <strtol+0x83>
c01070cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01070ce:	0f b6 00             	movzbl (%eax),%eax
c01070d1:	3c 30                	cmp    $0x30,%al
c01070d3:	75 1a                	jne    c01070ef <strtol+0x83>
c01070d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01070d8:	83 c0 01             	add    $0x1,%eax
c01070db:	0f b6 00             	movzbl (%eax),%eax
c01070de:	3c 78                	cmp    $0x78,%al
c01070e0:	75 0d                	jne    c01070ef <strtol+0x83>
        s += 2, base = 16;
c01070e2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01070e6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01070ed:	eb 2a                	jmp    c0107119 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01070ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01070f3:	75 17                	jne    c010710c <strtol+0xa0>
c01070f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01070f8:	0f b6 00             	movzbl (%eax),%eax
c01070fb:	3c 30                	cmp    $0x30,%al
c01070fd:	75 0d                	jne    c010710c <strtol+0xa0>
        s ++, base = 8;
c01070ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0107103:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010710a:	eb 0d                	jmp    c0107119 <strtol+0xad>
    }
    else if (base == 0) {
c010710c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107110:	75 07                	jne    c0107119 <strtol+0xad>
        base = 10;
c0107112:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0107119:	8b 45 08             	mov    0x8(%ebp),%eax
c010711c:	0f b6 00             	movzbl (%eax),%eax
c010711f:	3c 2f                	cmp    $0x2f,%al
c0107121:	7e 1b                	jle    c010713e <strtol+0xd2>
c0107123:	8b 45 08             	mov    0x8(%ebp),%eax
c0107126:	0f b6 00             	movzbl (%eax),%eax
c0107129:	3c 39                	cmp    $0x39,%al
c010712b:	7f 11                	jg     c010713e <strtol+0xd2>
            dig = *s - '0';
c010712d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107130:	0f b6 00             	movzbl (%eax),%eax
c0107133:	0f be c0             	movsbl %al,%eax
c0107136:	83 e8 30             	sub    $0x30,%eax
c0107139:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010713c:	eb 48                	jmp    c0107186 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010713e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107141:	0f b6 00             	movzbl (%eax),%eax
c0107144:	3c 60                	cmp    $0x60,%al
c0107146:	7e 1b                	jle    c0107163 <strtol+0xf7>
c0107148:	8b 45 08             	mov    0x8(%ebp),%eax
c010714b:	0f b6 00             	movzbl (%eax),%eax
c010714e:	3c 7a                	cmp    $0x7a,%al
c0107150:	7f 11                	jg     c0107163 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0107152:	8b 45 08             	mov    0x8(%ebp),%eax
c0107155:	0f b6 00             	movzbl (%eax),%eax
c0107158:	0f be c0             	movsbl %al,%eax
c010715b:	83 e8 57             	sub    $0x57,%eax
c010715e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107161:	eb 23                	jmp    c0107186 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0107163:	8b 45 08             	mov    0x8(%ebp),%eax
c0107166:	0f b6 00             	movzbl (%eax),%eax
c0107169:	3c 40                	cmp    $0x40,%al
c010716b:	7e 3d                	jle    c01071aa <strtol+0x13e>
c010716d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107170:	0f b6 00             	movzbl (%eax),%eax
c0107173:	3c 5a                	cmp    $0x5a,%al
c0107175:	7f 33                	jg     c01071aa <strtol+0x13e>
            dig = *s - 'A' + 10;
c0107177:	8b 45 08             	mov    0x8(%ebp),%eax
c010717a:	0f b6 00             	movzbl (%eax),%eax
c010717d:	0f be c0             	movsbl %al,%eax
c0107180:	83 e8 37             	sub    $0x37,%eax
c0107183:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0107186:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107189:	3b 45 10             	cmp    0x10(%ebp),%eax
c010718c:	7c 02                	jl     c0107190 <strtol+0x124>
            break;
c010718e:	eb 1a                	jmp    c01071aa <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0107190:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0107194:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107197:	0f af 45 10          	imul   0x10(%ebp),%eax
c010719b:	89 c2                	mov    %eax,%edx
c010719d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071a0:	01 d0                	add    %edx,%eax
c01071a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01071a5:	e9 6f ff ff ff       	jmp    c0107119 <strtol+0xad>

    if (endptr) {
c01071aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01071ae:	74 08                	je     c01071b8 <strtol+0x14c>
        *endptr = (char *) s;
c01071b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071b3:	8b 55 08             	mov    0x8(%ebp),%edx
c01071b6:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01071b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01071bc:	74 07                	je     c01071c5 <strtol+0x159>
c01071be:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01071c1:	f7 d8                	neg    %eax
c01071c3:	eb 03                	jmp    c01071c8 <strtol+0x15c>
c01071c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01071c8:	c9                   	leave  
c01071c9:	c3                   	ret    

c01071ca <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01071ca:	55                   	push   %ebp
c01071cb:	89 e5                	mov    %esp,%ebp
c01071cd:	57                   	push   %edi
c01071ce:	83 ec 24             	sub    $0x24,%esp
c01071d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071d4:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01071d7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01071db:	8b 55 08             	mov    0x8(%ebp),%edx
c01071de:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01071e1:	88 45 f7             	mov    %al,-0x9(%ebp)
c01071e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01071e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01071ea:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01071ed:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01071f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01071f4:	89 d7                	mov    %edx,%edi
c01071f6:	f3 aa                	rep stos %al,%es:(%edi)
c01071f8:	89 fa                	mov    %edi,%edx
c01071fa:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01071fd:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0107200:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0107203:	83 c4 24             	add    $0x24,%esp
c0107206:	5f                   	pop    %edi
c0107207:	5d                   	pop    %ebp
c0107208:	c3                   	ret    

c0107209 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0107209:	55                   	push   %ebp
c010720a:	89 e5                	mov    %esp,%ebp
c010720c:	57                   	push   %edi
c010720d:	56                   	push   %esi
c010720e:	53                   	push   %ebx
c010720f:	83 ec 30             	sub    $0x30,%esp
c0107212:	8b 45 08             	mov    0x8(%ebp),%eax
c0107215:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107218:	8b 45 0c             	mov    0xc(%ebp),%eax
c010721b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010721e:	8b 45 10             	mov    0x10(%ebp),%eax
c0107221:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0107224:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107227:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010722a:	73 42                	jae    c010726e <memmove+0x65>
c010722c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010722f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107232:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107235:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107238:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010723b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010723e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107241:	c1 e8 02             	shr    $0x2,%eax
c0107244:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0107246:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107249:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010724c:	89 d7                	mov    %edx,%edi
c010724e:	89 c6                	mov    %eax,%esi
c0107250:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0107252:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0107255:	83 e1 03             	and    $0x3,%ecx
c0107258:	74 02                	je     c010725c <memmove+0x53>
c010725a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010725c:	89 f0                	mov    %esi,%eax
c010725e:	89 fa                	mov    %edi,%edx
c0107260:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0107263:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0107266:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0107269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010726c:	eb 36                	jmp    c01072a4 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010726e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107271:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107274:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107277:	01 c2                	add    %eax,%edx
c0107279:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010727c:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010727f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107282:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0107285:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107288:	89 c1                	mov    %eax,%ecx
c010728a:	89 d8                	mov    %ebx,%eax
c010728c:	89 d6                	mov    %edx,%esi
c010728e:	89 c7                	mov    %eax,%edi
c0107290:	fd                   	std    
c0107291:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0107293:	fc                   	cld    
c0107294:	89 f8                	mov    %edi,%eax
c0107296:	89 f2                	mov    %esi,%edx
c0107298:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010729b:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010729e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01072a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01072a4:	83 c4 30             	add    $0x30,%esp
c01072a7:	5b                   	pop    %ebx
c01072a8:	5e                   	pop    %esi
c01072a9:	5f                   	pop    %edi
c01072aa:	5d                   	pop    %ebp
c01072ab:	c3                   	ret    

c01072ac <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01072ac:	55                   	push   %ebp
c01072ad:	89 e5                	mov    %esp,%ebp
c01072af:	57                   	push   %edi
c01072b0:	56                   	push   %esi
c01072b1:	83 ec 20             	sub    $0x20,%esp
c01072b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01072b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01072ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01072c0:	8b 45 10             	mov    0x10(%ebp),%eax
c01072c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01072c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01072c9:	c1 e8 02             	shr    $0x2,%eax
c01072cc:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01072ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01072d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072d4:	89 d7                	mov    %edx,%edi
c01072d6:	89 c6                	mov    %eax,%esi
c01072d8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01072da:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01072dd:	83 e1 03             	and    $0x3,%ecx
c01072e0:	74 02                	je     c01072e4 <memcpy+0x38>
c01072e2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01072e4:	89 f0                	mov    %esi,%eax
c01072e6:	89 fa                	mov    %edi,%edx
c01072e8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01072eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01072ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01072f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01072f4:	83 c4 20             	add    $0x20,%esp
c01072f7:	5e                   	pop    %esi
c01072f8:	5f                   	pop    %edi
c01072f9:	5d                   	pop    %ebp
c01072fa:	c3                   	ret    

c01072fb <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01072fb:	55                   	push   %ebp
c01072fc:	89 e5                	mov    %esp,%ebp
c01072fe:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0107301:	8b 45 08             	mov    0x8(%ebp),%eax
c0107304:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0107307:	8b 45 0c             	mov    0xc(%ebp),%eax
c010730a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010730d:	eb 30                	jmp    c010733f <memcmp+0x44>
        if (*s1 != *s2) {
c010730f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107312:	0f b6 10             	movzbl (%eax),%edx
c0107315:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0107318:	0f b6 00             	movzbl (%eax),%eax
c010731b:	38 c2                	cmp    %al,%dl
c010731d:	74 18                	je     c0107337 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010731f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107322:	0f b6 00             	movzbl (%eax),%eax
c0107325:	0f b6 d0             	movzbl %al,%edx
c0107328:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010732b:	0f b6 00             	movzbl (%eax),%eax
c010732e:	0f b6 c0             	movzbl %al,%eax
c0107331:	29 c2                	sub    %eax,%edx
c0107333:	89 d0                	mov    %edx,%eax
c0107335:	eb 1a                	jmp    c0107351 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0107337:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010733b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010733f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107342:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107345:	89 55 10             	mov    %edx,0x10(%ebp)
c0107348:	85 c0                	test   %eax,%eax
c010734a:	75 c3                	jne    c010730f <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010734c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107351:	c9                   	leave  
c0107352:	c3                   	ret    
