# net_zone
 对管网进行分区

## 引言
在对sustainability-650195论文审阅时，一个外审专家提出，应该考虑阀门位置的影响。而不是仅仅
假设每个管道两端都有一个阀门。因此，进行这方面的研究。
## 方法与材料
SANTONASTASO et al. [1]的理论对我有很大的启发，采用双矩阵来描述管网及阀门位置。另外，本文的案例被采用作为本文的研究案例，进行方法验证。

DEUERLEIN et al.[2]论文中也考虑了阀门位置的影响，并根据阀门位置对管网进行分区。因此，也有一定的参考价值。

## 步骤
### 建立验证案例
采用SANTONASTASO et al. [1]中10节点管网作为验证案例。
所需文件包括：
1. 源点描述文件。source.csv
2. 普通节点描述文件。node.csv
3. 管线节点关系描述文件。pipe.csv
4. 阀门位置描述文件。valve.csv
### 检查输入文件
1. 检查pipe.csv文件中节点与source.csv，node.csv中的节点部分是否一致。
2. 检查pipe.csv文件中管线与valve.csv中管线部分是否一致。
### 建立无向图
根据管线节点关系描述文件，建立无向图。
利用Matlab graph 类。
管线节点关系描述文件内容如下所示，三列数分别表示：管道号，起点号，以及终点号
===
管道; 起点;终点
1;3;5
===
### 生成邻接矩阵与关联矩阵
根据pipe.csv生成邻接矩阵与关联矩阵。
### 建立阀门位置判断矩阵，
阀门位置描述文件应如下所示：其中起点和终点列的1，表示靠近起点一端有阀门，0表示靠近终点的一端没有阀门。

===
管道; 起点;终点
1;1;0
===

因此，每个管道有四个状态：无阀门，靠近起点有阀门，靠近终点有阀门，以及两端均有阀门。
状态代码分别为：0，1，2，3
## 参考文献
[1] SANTONASTASO G F, NARDO A D, CREACO E. Dual topology for partitioning of water distribution networks considering actual valve locations[J]. Urban Water Journal, 2019, 16(7): 469–479.
[2] DEUERLEIN J, GILBERT D, ABRAHAM E et al. A greedy scheduling of post-disaster response and restoration using pressure-driven models and graph segment analysis[C]//1st International Water Distribution System Analysis / Computing and Control in the Water Industry Joint Conference. Kingston, Canada: 2018.
