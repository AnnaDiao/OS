```
PROJ	:= challenge
EMPTY	:=
SPACE	:= $(EMPTY) $(EMPTY)
SLASH	:= /

V       := @
#@的作用是不输出后面的命令，只输出结果
#初始化，:=  表示在定义时扩展
```

####（fi 未解决）
```
ifndef GCCPREFIX	#如果没有定义环境变量GCCPREFIX,执行下面的指令
GCCPREFIX := $(shell if i386-elf-objdump -i 2>&1 | grep '^elf32-i386$$' >/dev/null 2>&1; \
	# shell 是一个makefile函数，$(shell ...)表示把shell 后面指令输出的正确结果赋值给变量
	#正确结果 即 1 代表的输出
	#grep--文本搜索工具， 这里 把前一条命令的标准输出发送给grep作为输入看能不能匹配上
	then echo 'i386-elf-'; \
	elif objdump -i 2>&1 | grep 'elf32-i386' >/dev/null 2>&1; \
	then echo ''; \
	#如果不存在，则看 objdump 命令是否存在，存在则GCCPREFIX为空串，否则之间报错，要求显示地提供gcc的前缀作为GCCPREFIX变量的数值（可以在环境变量中指定）
	else echo "***" 1>&2; \
	echo "*** Error: Couldn't find an i386-elf version of GCC/binutils." 1>&2; \
	echo "*** Is the directory with i386-elf-gcc in your PATH?" 1>&2; \
	echo "*** If your i386-elf toolchain is installed with a command" 1>&2; \
	echo "*** prefix other than 'i386-elf-', set your GCCPREFIX" 1>&2; \
	echo "*** environment variable to that prefix and run 'make' again." 1>&2; \
	echo "*** To turn off this error, run 'gmake GCCPREFIX= ...'." 1>&2; \
	echo "***" 1>&2; exit 1; fi)
	#利用 echo 增加调试信息  2>&1 即把shell的 标准错误输出 重定向到 标准输出
	#下面的 1>&2 则是把 标准输出 重定向到错误输出 （都会显示在屏幕上） 
	# elif 语句中 >/dev/null 的意思是把那条的输出结果传到 /dev/null 这个文件里，但这个文件的作用是，所有传到里面的数据都会被丢弃
	#如果报错，返回 1 退出 
endif
```


```
# try to infer the correct QEMU
ifndef QEMU	
#原理相同， 上半部分代码是在能找到qemu的情况下，在最后一步之前，顺序输入命令，然后丢掉中间输出结果，把最后一条的输出赋值给 QEMU
QEMU := $(shell if which qemu-system-i386 > /dev/null; \
	then echo 'qemu-system-i386'; exit; \
	elif which i386-elf-qemu > /dev/null; \
	then echo 'i386-elf-qemu'; exit; \
	elif which qemu > /dev/null; \
	then echo 'qemu'; exit; \
	else \
	#否则 把shell返回的输出重定向到标准错误输出，显示在屏幕上，退出
	echo "***" 1>&2; \
	echo "*** Error: Couldn't find a working QEMU executable." 1>&2; \
	echo "*** Is the directory containing the qemu binary in your PATH" 1>&2; \
	echo "***" 1>&2; exit 1; fi)
endif
```
```
\# eliminate default suffix rules

.SUFFIXES: .c .S .h
\#重定义当前makefile内支持文件后缀的类型列表

\# delete target files if there is an error (or make is interrupted)
.DELETE_ON_ERROR:
#遇到报错则删除所有文件

# define compiler and flags 配参数

ifndef  USELLVM			
HOSTCC		:= gcc	
#hostcc是给主机用的编译器，按照主机格式。cc是i386,elf32格式的编译器		
HOSTCFLAGS	:= -g -Wall -O2
# -g 是为了gdb能够对程序进行调试
# -Wall 生成警告信息
# -O2 优化处理（0,1,2,3表示不同的优化程度，0为不优化）

CC		:= $(GCCPREFIX)gcc
CFLAGS	:= -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc $(DEFS)
CFLAGS	+= $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
# -fno-builtin 不接受非“__”开头的内建函数
# -ggdb让gcc 为gdb生成比较丰富的调试信息
# -m32 编译32位程序
# -gstabs 此选项以stabs格式声称调试信息,但是不包括gdb调试信息
# -nostdinc 不在标准系统目录中搜索头文件,只在-I指定的目录中搜索
#DEFS是未定义量。可用来对CFLAGS进行扩展

else
HOSTCC		:= clang
HOSTCFLAGS	:= -g -Wall -O2
CC		:= $(GCCPREFIX)clang
CFLAGS	:= -fno-builtin -Wall -g -m32 -mno-sse -nostdinc $(DEFS)
CFLAGS	+= $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
endif

CTYPE	:= c S

LD      := $(GCCPREFIX)ld
LDFLAGS	:= -m $(shell $(LD) -V | grep elf_i386 2>/dev/null)
LDFLAGS	+= -nostdlib

OBJCOPY := $(GCCPREFIX)objcopy
OBJDUMP := $(GCCPREFIX)objdump

COPY	:= cp
MKDIR   := mkdir -p
MV		:= mv
RM		:= rm -f
AWK		:= awk
SED		:= sed
SH		:= sh
TR		:= tr
TOUCH	:= touch -c

#mkdir -p: 允许创建嵌套子目录；
#touch -c: 不创建已经存在的文件；
#rm -f: 无视任何确认提示；

OBJDIR	:= obj
BINDIR	:= bin

ALLOBJS	:=
ALLDEPS	:=
TARGETS	:=
```
```
include tools/function.mk

listf_cc = $(call listf,$(1),$(CTYPE))

#call函数：call func,变量1，变量2,...
#listf函数在function.mk中定义，列出某地址（变量1）下某些类型（变量2）文件
#listf_cc: 列出某地址（变量1）下.c与.S文件

# for cc
# add files to packet
add_files_cc = $(call add_files,$(1),$(CC),$(CFLAGS) $(3),$(2),$(4))
# add packets and objs to target 
create_target_cc = $(call create_target,$(1),$(2),$(3),$(CC),$(CFLAGS))

# for hostcc
add_files_host = $(call add_files,$(1),$(HOSTCC),$(HOSTCFLAGS),$(2),$(3))
create_target_host = $(call create_target,$(1),$(2),$(3),$(HOSTCC),$(HOSTCFLAGS))

#patsubst替换通配符
#cgtype（filenames,type1，type2）
#把文件名中后缀是type1的改为type2，如*.c改为*.o
cgtype = $(patsubst %.$(2),%.$(3),$(1))
#列出所有.o文件 -- toobj : get .o obj files: (#files[, packet])
objfile = $(call toobj,$(1))
#.o改为.asm
asmfile = $(call cgtype,$(call toobj,$(1)),o,asm)
#.o改为.out
outfile = $(call cgtype,$(call toobj,$(1)),o,out)
#.o改为.sy
symfile = $(call cgtype,$(call toobj,$(1)),o,sym)

# for match pattern
match = $(shell echo $(2) | $(AWK) '{for(i=1;i<=NF;i++){if(match("$(1)","^"$$(i)"$$")){exit 1;}}}'; echo $$?)
```
```
\# include kernel/user
#下面在写路径
INCLUDE	+= libs/

CFLAGS	+= $(addprefix -I,$(INCLUDE))

LIBDIR	+= libs
#寻找libs目录下的所有具有.c, .s后缀的文件，并生成相应的.o文件，放置在obj/libs/文件夹下
$(call add_files_cc,$(call listf_cc,$(LIBDIR)),libs,)

# -------------------------------------------------------------------
# kernel

KINCLUDE	+= kern/debug/ \
			   kern/driver/ \
			   kern/trap/ \
			   kern/mm/

KSRCDIR		+= kern/init \
			   kern/libs \
			   kern/debug \
			   kern/driver \
			   kern/trap \
			   kern/mm

KCFLAGS		+= $(addprefix -I,$(KINCLUDE))

#生成kernel的所有子目录下包含的 .s, .c（CTYPE）文件所对应的.o文件以及.d文件
#KCFLAGS新指定了若干gcc编译选项，具体为制定了若干存放在KINCLUDE变量下的头文件
$(call add_files_cc,$(call listf_cc,$(KSRCDIR)),kernel,$(KCFLAGS))

KOBJS	= $(call read_packet,kernel libs)

# create kernel target
kernel = $(call totarget,kernel)

#表示/bin/kernel文件依赖于tools/kernel.ld文件
$(kernel): tools/kernel.ld

#表示/bin/kernel文件依赖于 obj/libs 里的.o 文件
$(kernel): $(KOBJS)
	#这句没看懂，$@ 指代kernel （？？？突然存疑）
	@echo + ld $@
	#使用ld链接器将这些.o文件连接成kernel文件，其中ld的-T表示指定使用kernel.ld来替代默认的链接器脚本
	#$(V) == @ 不显示结果
	#实际代码：ld -m elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel [接下面路径 都在KOBJS里]
	#obj/kern/init/init.o obj/kern/libs/readline.o obj/kern/libs/stdio.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/debug/panic.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/intr.o obj/kern/driver/picirq.o obj/kern/trap/trap.o obj/kern/trap/trapentry.o obj/kern/trap/vectors.o obj/kern/mm/pmm.o  obj/libs/printfmt.o obj/libs/string.o
	$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
	#使用objdump反汇编出kernel的汇编代码，-S表示将源代码与汇编代码混合展示出来，最终保存在kernel.asm文件中
	@$(OBJDUMP) -S $@ > $(call asmfile,kernel)
	#-t表示打印出文件的符号表表项，然后通过管道将带有符号表的反汇编结果作为sed命令的标准输入进行处理，最终将符号表信息保存到kernel.sym文件中
	#命令（待确认）： 从第一行到含/SYMBOL TABLE/的所有行都删除；所有.*（后缀）都替换成空；删掉空行
	@$(OBJDUMP) -t $@ | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)

#执行
$(call create_target,kernel)
```
# -------------------------------------------------------------------
```
#create bootblock
#获取boot目录下的源文件（.c .S），bootfiles=boot/*.c boot/*.S
bootfiles = $(call listf_cc,boot)
#将boot/*.c boot/*.S编译成obj/boot/*.o
$(foreach f,$(bootfiles),$(call cc_compile,$(f),$(CC),$(CFLAGS) -Os -nostdinc))

#指定bootblock的目标路径，bootblock=bin/bootblock
bootblock = $(call totarget,bootblock)

#表示bin/bootblock文件依赖于 obj/boot/*.o bin/sign
$(bootblock): $(call toobj,$(bootfiles)) | $(call totarget,sign)
	@echo + ld $@
	#连接所有obj/boot/*.o生成obj/bootblock.o
	$(V)$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 $^ -o $(call toobj,bootblock)
	#obj/bootblock.o反汇编为obj/bootblock.asm
	@$(OBJDUMP) -S $(call objfile,bootblock) > $(call asmfile,bootblock)
	#obj/bootblock.o转换为obj/bootblock.out并去掉重定位和符号信息
	@$(OBJCOPY) -S -O binary $(call objfile,bootblock) $(call outfile,bootblock)
	#使用bin/sign工具将obj/bootblock.out转换为obj/bootblock 使得最终的文件大小为512字节，并且以0x55AA结尾，即ELF格式
	@$(call totarget,sign) $(call outfile,bootblock) $(bootblock)

$(call create_target,bootblock)
```
# -------------------------------------------------------------------
```
#create 'sign' tools
#设置__objs_sign=obj/sign/tools/sign.o
$(call add_files_host,tools/sign.c,sign,sign)

#生成bin/sign
$(call create_target_host,sign,sign)
```
# -------------------------------------------------------------------
```
# create ucore.img
# 为ucore.img添加目标路径 => bin/ucore.img
UCOREIMG	:= $(call totarget,ucore.img)
# dd: 转换、复制文件  if: 输入文件 of: 输出文件
# count: 要复制的块数。（默认每个块为512字节）
# seek: 输出到目标文件时需要跳过的块数，即从第seek块之后开始写入
# conv=notrunc: 不截断输出文件


$(UCOREIMG): $(kernel) $(bootblock)
	#为ucore.img分配10000*512块的空间，全部置0
	$(V)dd if=/dev/zero of=$@ count=10000
	# 将bootblock复制到ucore.img的开头处
	$(V)dd if=$(bootblock) of=$@ conv=notrunc
	# 将kernel复制到ucore.img的第二块开始处
	$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc

$(call create_target,ucore.img)
```
```

$(call finish_all)

IGNORE_ALLDEPS	= clean \
				  dist-clean \
				  grade \
				  touch \
				  print-.+ \
				  handin

ifeq ($(call match,$(MAKECMDGOALS),$(IGNORE_ALLDEPS)),0)
-include $(ALLDEPS)
endif

# files for grade script

TARGETS: $(TARGETS)

.DEFAULT_GOAL := TARGETS

.PHONY: qemu qemu-nox debug debug-nox
qemu-mon: $(UCOREIMG)
	$(V)$(QEMU) -monitor stdio -hda $< -serial null
qemu: $(UCOREIMG)
	$(V)$(QEMU) -parallel stdio -hda $< -serial null

qemu-nox: $(UCOREIMG)
	$(V)$(QEMU) -serial mon:stdio -hda $< -nographic
TERMINAL        :=gnome-terminal
debug: $(UCOREIMG)
	$(V)$(QEMU) -S -s -parallel stdio -hda $< -serial null &
	$(V)sleep 2
	$(V)$(TERMINAL) -e "gdb -q -tui -x tools/gdbinit"
	
debug-nox: $(UCOREIMG)
	$(V)$(QEMU) -S -s -serial mon:stdio -hda $< -nographic &
	$(V)sleep 2
	$(V)$(TERMINAL) -e "gdb -q -x tools/gdbinit"

.PHONY: grade touch

GRADE_GDB_IN	:= .gdb.in
GRADE_QEMU_OUT	:= .qemu.out
HANDIN			:= proj$(PROJ)-handin.tar.gz

TOUCH_FILES		:= kern/trap/trap.c

MAKEOPTS		:= --quiet --no-print-directory

grade:
	$(V)$(MAKE) $(MAKEOPTS) clean
	$(V)$(SH) tools/grade.sh

touch:
	$(V)$(foreach f,$(TOUCH_FILES),$(TOUCH) $(f))

print-%:
	@echo $($(shell echo $(patsubst print-%,%,$@) | $(TR) [a-z] [A-Z]))

.PHONY: clean dist-clean handin packall tags
clean:
	$(V)$(RM) $(GRADE_GDB_IN) $(GRADE_QEMU_OUT) cscope* tags
	-$(RM) -r $(OBJDIR) $(BINDIR)

dist-clean: clean
	-$(RM) $(HANDIN)

handin: packall
	@echo Please visit http://learn.tsinghua.edu.cn and upload $(HANDIN). Thanks!

packall: clean
	@$(RM) -f $(HANDIN)
	@tar -czf $(HANDIN) `find . -type f -o -type d | grep -v '^\.*$$' | grep -vF '$(HANDIN)'`

tags:
	@echo TAGS ALL
	$(V)rm -f cscope.files cscope.in.out cscope.out cscope.po.out tags
	$(V)find . -type f -name "*.[chS]" >cscope.files
	$(V)cscope -bq 
	$(V)ctags -L cscope.files
```