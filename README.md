# net_zone
 对管网进行分区

## 引言
在对sustainability-650195论文审阅时，一个外审专家提出，应该考虑阀门位置的影响。而不是仅仅
假设每个管道两端都有一个阀门。因此，进行这方面的研究。
## 方法与材料
SANTONASTASO et al. [1]的理论对我有很大的启发，采用双矩阵来描述管网及阀门位置。另外，本文的案例被采用作为本文的研究案例，进行方法验证。

DEUERLEIN et al.[2]论文中也考虑了阀门位置的影响，并根据阀门位置对管网进行分区。因此，也有一定的参考价值。在本文中，分解网络的工作是参考了DEUERLEIN et al.[3]。采用了SIR 3S 软件(www.3sconsult.de)。但是该软件学习成本太高，时间太长，不予采用。

## 步骤
功能已经实现，详细见pipe_segment.m
该函数需要输入，link,valve数据。
输出每个管道所属的segment flag，以及segment包含的管道ID。
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

```
管道; 起点;终点
1;3;5
```
### 生成邻接矩阵与关联矩阵

根据pipe.csv生成邻接矩阵与关联矩阵。
### 建立阀门位置判断矩阵

阀门位置描述文件应如下所示：其中起点和终点列的1，表示靠近起点一端有阀门，0表示靠近终点的一端没有阀门。

```
管道; 起点;终点
1;1;0
```

因此，每个管道有四个状态：无阀门，靠近起点有阀门，靠近终点有阀门，以及两端均有阀门。
状态代码分别为：0，1，2，3

### 删除包含阀门的边（灵光一闪）

在图中，删除包含阀门的边，则剩下的原件自动组成不同的segment，进一步考虑，可以将含有阀门的的一端断开，这样也可以生成不同网络图。

## 其他准备工作
### 阀门的比例
1. 找到BBM-EPS.inp文件。
2. 仅保留[PIPE]部分数据，将其余数据删除，另存为BBM-EPA-valve.txt文件。
3. Matlab readcell 读入BBM-EPS-valve.txt文件，将分号前的数据删除。
4. 将分号后的数据另存到文本文件data2.txt。
5. Matlab readmatrix 从data2.txt读入数据，用矩阵形式保存。
```Matlab
data = readcell('BBM-EPS-valve.txt','Delimiter',';')
data2 = data(:,2);
writecell(data2,'data2.txt');
data3 = readmatrix('data2.txt','Delimiter','-')；
iflag1 = sum(data3,2) %
numel(iflag1)%管道个数
sum(iflag1 == 2) % 两端阀门的管道个数
sum(l3)-sum(iflag1 == 2) % 单侧阀门管道个数
```

### 统计结果
在BPDRR文件中，阀门比例数据统计：

管道数| 左侧阀门管道数 | 右侧阀门管道数 | 双侧阀门管道数 |阀门总数 |有阀门总管道数
:-: | :-: | :-: | :-: | :-: |:-:
6064|2384 | 795| 1392 | 5963|4571
1   |0.3931|0.1311|0.2296|0.9833|0.7538

### 生成阀门与管道的关系描述文件
2020/01/03
论文宿舍他inabilit-650165修改稿返回。整理近期的文件。
1. 根据BBM-EPA-valve.txt的文件，生成link.csv以及valve.csv。
2. 详细过程可见forBcity.m

## MOD管网应用
1. 对MOD管网生成对应格式的link.csv,以及valve.csv中管线部分是否一致
其中valve.csv为随机生成。并将其变量存为MAT文件。方便以后调用。
2. 在模拟过程中需要识别管道所属segment,以及关闭所属segment的所有管道。
3. 进行模拟，统计数据。
在模拟前修改EPS_net_EPANETx64PDD.m
### 出现问题
1. 隔离时间不对，当前隔离时间为固定的0.5小时；应当根据需要隔离的管道数确定。（解决）
2. 回复没有达到1，猜测可能是是因为某些管道没有重新打开。（解决）
3. 单侧阀门的隔离管道，应当既属于一个分区，又属于另一个分区，即两个分区都需要隔离该管道。
同样双侧阀门的管道应当属于三个分区。（解决）

## 问题查证 20200101 10:47
果然出错了，在pipe_segment.m中，将管道分区的函数不对。管道编号与节点对没有对应上。（解决）幸好计算结果有明显的错误，否则我会遗漏掉这些错误。
## 参考文献
1. SANTONASTASO G F, NARDO A D, CREACO E. Dual topology for partitioning of water distribution networks considering actual valve locations[J]. Urban Water Journal, 2019, 16(7): 469–479.
2.  DEUERLEIN J, GILBERT D, ABRAHAM E et al. A greedy scheduling of post-disaster response and restoration using pressure-driven models and graph segment analysis[C]//1st International Water Distribution System Analysis / Computing and Control in the Water Industry Joint Conference. Kingston, Canada: 2018.
3. DEUERLEIN JOCHEN W. Decomposition Model of a General Water Supply Network Graph[J]. Journal of Hydraulic Engineering, 2008, 134(6): 822–832.
