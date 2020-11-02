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

         

         

         

         

         