<h2 align = "center">关于本 DIP_MATLAB 仓库</h2>

<p align="center">
    <img src="https://img.shields.io/badge/DIP__MATLAB-by%20chubbylhao-brightgreen" />
    <img src="https://img.shields.io/badge/license-MIT-brightgreen" />
    <img src="https://img.shields.io/badge/purpose-study%20and%20backup-red" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/language-MATLAB-blue" />
    <img src="https://img.shields.io/badge/institution-HIT--ISE-blue" />
</p>

> 此仓库的所有内容（代码）均由本人在学习经典数字图像处理算法的过程中所积攒
>
> 除备份外，本仓库还旨在记录本人的点滴学习过程，希望能以此来督促本人不断成长与进步
>
> —— `by chubbylhao`

------

### 仓库内容

- **图像融合：** 基本方法（平均灰度法、最大灰度法、最小灰度法、最大最小平均灰度法、简单邻域平均灰度法、加权平均灰度法）、  `PCA` 主成分分析、 `IHS` 和 `Brovey` 、 `pyramid` 图像金字塔、 `dct` 离散余弦变换、 `dwt` 小波变换、 `metrics` 融合评价指标、（导向滤波、（非下采样）轮廓波变换、（非下采样）剪切波变换、 `PCNN` 脉冲耦合神经网络、其它各种小波变体）

—— 后一个括号中的内容本仓库未手动实现（方法较新）

> 若是有深厚的数学功底该有多好，学起这些必然游刃有余

![](https://raw.githubusercontent.com/chubbylhao/myPics/012bd7561d95012f645ed4cfe8fcd1777c53554e/imageFusion/%E5%9B%BE%E5%83%8F%E8%9E%8D%E5%90%88.svg)

<h5 align = "center"> （ 图像融合方法综述 ） </h5>

![](https://raw.githubusercontent.com/chubbylhao/myPics/637393017ed3295900ab1af356d2ae44c9658a59/imageFusion/Metrics.svg)

<h5 align = "center"> （ 图像融合质量评价方法综述 ） </h5>

------

- **图像分割：** `simple-threshold` 简单迭代全局阈值、  `otsu` 最大类间方差全局阈值、 `variable-threshold` 可变阈值、 `flood-fill` 漫水填充、 `region-grow` 区域生长、 `split-merge` 区域的分离与聚合、 `k-means` 聚类、 `fuzzy-c-means` 聚类、 `SLIC` 超像素分割、（ `watershed` 形态学分水岭、 `graph-cut` 图割、 `grab-cut` 图割、  `snake` 主动轮廓区域增长）

—— 括号中的内容本仓库未手动实现，但在 `MATLAB` 的 `DIP` 工具箱中有对应的函数

> 涉及特定数学理论的方法，在不着急用时，应先理解其基本思想，而不是花大量时间精力去从头实现
>
> 立足经典，有求再学，为时不晚（体会经典方法的思路、学习经典方法的编程实现技巧）

![](https://raw.githubusercontent.com/chubbylhao/myPics/7488a2120ecfb3226e29633f09e8275e006a0e9d/imageSegmentation/imageSegmentation.svg)

<h5 align = "center"> （ 图像分割方法综述 ） </h5>

- ------

- **图像特征：** `Harris` 角点检测、 `DoH` 斑点检测、 `LoG` 斑点检测、 `DoG` 斑点检测、 `HOG` 特征、 `LBP` 特征（原始的 `LBP` 、圆形的 `LBP` 、旋转不变的 `LBP` 、等价模式的 `LBP` 以及多尺度分块 `LBP` ）、 `Haar` 特征（积分图像）、 `Moravec` 角点检测、 `ShiTomasi` 角点检测、 `Susan` 角点检测、 `Fast` 角点检测、 `Brief` 描述子、 `Hough` 线变换、 `Hough` 圆变换、 `Ransac` 随机采样一致性、 `Hu` 不变矩、 `gray-matrix` 灰度共生矩阵（还有许多，如 `SIFT` 特征、 `SURF` 特征、 `ORB` 特征（ `Fast` + `Brief` ）、 `MSER` 稳定极值区域、 `Brisk` 、 `Kaze` 、 `Freak` 等等）（另外，像 `canny` 边缘检测算子这种已经见过千百次的算子，只能说相当熟悉，需要的时候直接调包就好）

—— 后两个括号中的内容本仓库未手动实现（ `Fast` + `Brief` ）除外

> `SIFT` 、 `SURF` 和 `ORB` 是未来要编写的三种”复杂、经典“的特征（尽量实现）
>
> 附注：（完成情况： `SIFT` 已完成、 `SURF` 和 `ORB` 的代码已上传，但本人还**尚未学习**）
>
> 多了解了解人工设计的特征是为了更好地理解图像，而不要直接上手深度学习的黑匣子（多没意思）

<div align=center><img src="https://raw.githubusercontent.com/chubbylhao/myPics/05bd31e6d72a7ada8dc1748a5b08400ed1e8b74a/featureDetection/%E5%9B%BE%E5%83%8F%E7%89%B9%E5%BE%81.svg"></div>

<h5 align = "center"> （ 图像特征检测方法综述 ） </h5>

------

- **图像变换：** 二维 `DFT` 变换、二维 `DHT` 变换、二维 `DCT` 变换、二维 `DST` 变换、二维 `WHT` 变换，其中 `DHT` `DCT` `DST` 三者是 `DFT` 的衍生变换，都属于正弦变换，而 `WHT` 属于非正弦变换，其基函数类似于方波（小波变换将后续更新~~）

——从矩阵的线性变换观点去看待离散变换，或许就能豁然开朗

> 这些变换十分重要，多花点时间去理解它们是很有益处的

<div align=center><img src="https://raw.githubusercontent.com/chubbylhao/DIP_MATLAB/0540f060ac7ba73e1881d81eec3f59d0e921876c/image%20transformation/image%20transformation.svg"></div>

<h5 align = "center"> （ 常见图像变换方法一览 ） </h5>

------

  **内容未完，后续将持续更新~~**

> —— `2022.09.12` （内容以后续为主）

------

- **补充材料：** 这是我对传统图像处理算法的一点补充，如维纳滤波、 `Radon` 变换、 `SVD` 奇异值分解等

——从目前（ `2022.09.23` ）来说，我的学习重心将开始向机器学习与深度学习偏移，传统算法暂告一段落

——但我觉得，偶尔回头穿插学习一点儿传统算法，是有必要的并且是快乐的

> —— `2022.09.23` 

------

### 主要参考资料

> 《数字图像处理》，第 4 版，冈萨雷斯 —— 永远的经典！
>
> DIP 小方向的综述论文 —— 加强知识的整体把握程度！
>
> 网络上优秀的技术日志与技术博客！