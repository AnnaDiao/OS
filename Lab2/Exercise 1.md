### Exercise 1

1. 先阅读：struct list in list.h. 

   1. know the func of:  list_init, list_add(list_add_after), list_add_before, list_del, list_next, list_prev
   2. list-> special struct 用le2page函数

2. default_init : 默认ok 初始化链表

3. default_init_memap:  初始化块

   1.  p->flag 置0

   2. 块的非首页 p->property 置 0

   3. 首页置 本块的空闲页总数 n

   4. p->ref 置 0

   5. 用 p->page_link 把单页link到 free_list 上

      ex:  (such as: list_add_before(&free_list, &(p->page_link)); 

                6. 更新 -- sum the number of free mem block: nr_free+=n 
       
                   【Qs】
       
                   ​	(1) SetPageProperty 在干嘛-- 在设置空闲标记
       
                   ​	(2) 这系列的页分配算法有锁吗？如果有，在哪啊
       
                   ​	(3) list_next(&free_list) 功能是什么
       
                   ​	(4) 为什么采用地址递增而不是大端往下走？

4. ff_free_pages: 核心--合并

   1. 构造向后合并，找到插入点后先向后合并
   2. 再向前，一个节点一个节点的查看能否merge，注意是 引用

5. 改进空间：

   1. 一堆小块怎么合并，能不能同时处理多个请求，组合后实现内存最优分配？--又扯到了并行与同步问题，多个又是几个呢？

   2. 查询时间-> 构造二叉树怎么样？

      - 按照中序遍历得到的空闲块序列的物理地址恰好按照从小到大排序；

      - 每个二叉树节点上维护该节点为根的子树上的最大的空闲块的大小；

      - 在每次进行查询的时候，不妨从根节点开始，查询左子树的最大空闲块是否符合要求，如果是的话进入左子树进行进一步查询，否则进入右子树；（二分查找）

      - 树的维护和后续操作

        按照上述方法的话，每次查询符合条件的第一块物理空闲块的时间复杂度为O(log N)，对比原先的O（N）有了较大的改进；

         

### Exercise 2

![](D:\ThirdYear\OS\Lab2\pdt.png)

 ![](D:\ThirdYear\OS\Lab2\pet.png)

 由于页表或者页的物理地址都是4KB对齐的（低12位全是零），所以上图中只保留了物理基地址的高20位（bit[31:12]）。低12位可以安排其他用途。

【P】：存在位。为1表示页表或者页位于内存中。否则，表示不在内存中，必须先予以创建或者从磁盘调入内存后方可使用。
【R/W】：读写标志。为1表示页面可以被读写，为0表示只读。当处理器运行在0、1、2特权级时，此位不起作用。页目录中的这个位对其所映射的所有页面起作用。
【U/S】：用户/超级用户标志。为1时，允许所有特权级别的程序访问；为0时，仅允许特权级为0、1、2的程序访问。页目录中的这个位对其所映射的所有页面起作用。
【PWT】：Page级的Write-Through标志位。为1时使用Write-Through的Cache类型；为0时使用Write-Back的Cache类型。当CR0.CD=1时（Cache被Disable掉），此标志被忽略。对于我们的实验，此位清零。
【PCD】：Page级的Cache Disable标志位。为1时，物理页面是不能被Cache的；为0时允许Cache。当CR0.CD=1时，此标志被忽略。对于我们的实验，此位清零。
【A】：访问位。该位由处理器固件设置，用来指示此表项所指向的页是否已被访问（读或写），一旦置位，处理器从不清这个标志位。这个位可以被操作系统用来监视页的使用频率。
【D】：脏位。该位由处理器固件设置，用来指示此表项所指向的页是否写过数据。
【PS】：Page Size位。为0时，页的大小是4KB；为1时，页的大小是4MB（for normal 32-bit addressing ）或者2MB（if extended physical addressing is enabled).
【G】：全局位。如果页是全局的，那么它将在高速缓存中一直保存。当CR4.PGE=1时，可以设置此位为1，指示Page是全局Page，在CR3被更新时，TLB内的全局Page不会被刷新。
【AVL】：被处理器忽略，软件可以使用。

![](D:\ThirdYear\OS\Lab2\struct.png)



 