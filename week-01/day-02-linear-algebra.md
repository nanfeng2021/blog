# Day 2: 线性代数核心 - 矩阵运算、特征值、SVD

**日期**: 2026-03-24  
**学习时长**: 2.5 小时  
**完成状态**: ✅

---

## 🎯 今日学习目标

1. 理解矩阵的几何意义
2. 掌握特征值和特征向量的概念
3. 了解 SVD 分解及其应用
4. 用 NumPy 实现 PCA 降维

---

## 📚 学习内容

### 1. 矩阵的本质 - 线性变换

**直观理解**:
> 矩阵不是数字的表格，而是**空间变换的描述**。

**二维空间的例子**:
```
原始点：(x, y)
矩阵 A = [[a, b],
          [c, d]]

变换后：A × (x, y) = (ax+by, cx+dy)
```

**常见变换**:
- **旋转**: 绕原点旋转一定角度
- **缩放**: 沿坐标轴拉伸或压缩
- **剪切**: 平行四边形变形
- **投影**: 降到低维空间

### 2. 特征值与特征向量

**定义**:
对于方阵 A，如果存在非零向量 v 和标量 λ，使得:
```
A × v = λ × v
```
则称:
- **v** 是 A 的特征向量 (eigenvector)
- **λ** 是对应的特征值 (eigenvalue)

**几何意义**:
> 特征向量是在变换中**方向不变**的向量，特征值是伸缩的比例。

**示例**:
```
假设有一个拉伸变换:
A = [[2, 0],
     [0, 1]]

特征向量 1: [1, 0] → 特征值: 2 (x 轴方向拉伸 2 倍)
特征向量 2: [0, 1] → 特征值: 1 (y 轴方向不变)
```

**应用场景**:
- **主成分分析 **(PCA): 找到数据变化最大的方向
- **Google PageRank**: 网页重要性排序
- **振动分析**: 桥梁、建筑的固有频率
- **量子力学**: 能量本征态

### 3. 奇异值分解 (SVD)

**定义**:
任何 m×n 的矩阵 A 都可以分解为:
```
A = U × Σ × V^T
```

其中:
- **U**: m×m 正交矩阵（左奇异向量）
- **Σ**: m×n 对角矩阵（奇异值，从大到小排列）
- **V^T**: n×n 正交矩阵的转置（右奇异向量）

**直观理解**:
> 任何复杂的变换都可以分解为三个简单步骤:
> 1. 旋转 (V^T)
> 2. 沿坐标轴缩放 (Σ)
> 3. 再旋转 (U)

**应用**:
- **数据压缩**: 保留前 k 个大的奇异值
- **推荐系统**: 矩阵填充和预测
- **图像去噪**: 去除小的奇异值
- **自然语言处理**: LSA 潜在语义分析

---

## 🔧 代码实践 - 用 NumPy 实现 PCA

### 步骤 1: 导入库并生成数据

```python
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA

# 设置随机种子
np.random.seed(42)

# 生成二维数据（呈椭圆形分布）
mean = [0, 0]
cov = [[3, 1], [1, 1]]  # 协方差矩阵
data = np.random.multivariate_normal(mean, cov, 1000)

print(f"数据形状：{data.shape}")
print(f"数据均值：{data.mean(axis=0)}")
```

### 步骤 2: 可视化原始数据

```python
plt.figure(figsize=(8, 6))
plt.scatter(data[:, 0], data[:, 1], alpha=0.5)
plt.xlabel('特征 1')
plt.ylabel('特征 2')
plt.title('原始数据分布')
plt.axis('equal')
plt.grid(True, alpha=0.3)
plt.show()
```

### 步骤 3: 计算协方差矩阵的特征值和特征向量

```python
# 中心化数据（减去均值）
data_centered = data - data.mean(axis=0)

# 计算协方差矩阵
cov_matrix = np.cov(data_centered.T)
print("协方差矩阵:")
print(cov_matrix)

# 计算特征值和特征向量
eigenvalues, eigenvectors = np.linalg.eig(cov_matrix)

print("\n特征值:", eigenvalues)
print("\n特征向量:")
print(eigenvectors)
```

### 步骤 4: 可视化主成分方向

```python
# 绘制原始数据
plt.figure(figsize=(8, 6))
plt.scatter(data[:, 0], data[:, 1], alpha=0.5)

# 绘制特征向量（主成分方向）
for i in range(len(eigenvalues)):
    # 从数据中心画箭头
    arrow_props = dict(arrowstyle='->', linewidth=2, color='red')
    plt.arrow(
        data.mean(axis=0)[0], 
        data.mean(axis=0)[1],
        eigenvectors[0, i] * np.sqrt(eigenvalues[i]) * 2,
        eigenvectors[1, i] * np.sqrt(eigenvalues[i]) * 2,
        color='red',
        width=0.05
    )

plt.xlabel('特征 1')
plt.ylabel('特征 2')
plt.title('主成分方向（特征向量）')
plt.axis('equal')
plt.grid(True, alpha=0.3)
plt.show()
```

### 步骤 5: 降维到一维

```python
# 选择最大的特征值对应的特征向量
principal_component = eigenvectors[:, np.argmax(eigenvalues)]
print("主成分方向:", principal_component)

# 投影到主成分上
data_1d = np.dot(data_centered, principal_component)
print(f"降维后数据形状：{data_1d.shape}")

# 可视化降维结果
plt.figure(figsize=(10, 4))

# 子图 1: 原始二维数据
plt.subplot(1, 2, 1)
plt.scatter(data[:, 0], data[:, 1], alpha=0.5)
plt.xlabel('特征 1')
plt.ylabel('特征 2')
plt.title('原始数据 (2D)')
plt.axis('equal')
plt.grid(True, alpha=0.3)

# 子图 2: 降维后的一维数据
plt.subplot(1, 2, 2)
plt.hist(data_1d, bins=30, alpha=0.7, edgecolor='black')
plt.xlabel('主成分得分')
plt.ylabel '频数')
plt.title('降维后数据 (1D)')
plt.grid(True, alpha=0.3)

plt.tight_layout()
plt.show()
```

### 步骤 6: 使用 sklearn 验证

```python
# 使用 sklearn 的 PCA
pca = PCA(n_components=1)
data_sklearn = pca.fit_transform(data)

print("sklearn 解释的方差比例:", pca.explained_variance_ratio_)
print("手动计算的特征值比例:", eigenvalues / eigenvalues.sum())

# 对比结果
print("\n前 5 个样本对比:")
print("手动计算:", data_1d[:5])
print("sklearn:", data_sklearn.flatten()[:5])
```

---

## 💡 关键知识点总结

### 矩阵的核心概念
| 概念 | 几何意义 | 应用 |
|------|----------|------|
| 矩阵乘法 | 空间变换 | 神经网络前向传播 |
| 行列式 | 变换后的面积/体积缩放比例 | 判断矩阵是否可逆 |
| 逆矩阵 | 变换的逆变换 | 解线性方程组 |
| 秩 | 变换后空间的维度 | 判断信息是否冗余 |

### 特征值与特征向量
- **物理意义**: 系统的"固有模式"
- **计算方法**: 解特征方程 det(A - λI) = 0
- **重要性质**: 
  - 对称矩阵的特征向量正交
  - 特征值之和 = 矩阵的迹
  - 特征值之积 = 矩阵的行列式

### SVD 分解
- **通用性**: 适用于任何矩阵（不限于方阵）
- **数值稳定性**: 比特征值分解更稳定
- **降维原理**: 保留前 k 个大的奇异值

---

## 📝 学习笔记

### 今日收获
1. 理解了矩阵是空间变换的描述
2. 掌握了特征值和特征向量的几何意义
3. 学会了用 NumPy 实现 PCA 降维

### 遇到的困难
1. SVD 的数学推导比较复杂
2. 特征向量的方向有时不好理解

### 解决方案
1. 多看可视化的例子
2. 用代码验证理论

### 明日计划
- [ ] 复习今日内容
- [ ] 预习概率统计基础
- [ ] 完成贝叶斯分类器代码

---

## 🔗 参考资料

### 视频教程
- [3Blue1Brown 线性代数本质](https://www.bilibili.com/video/BV1ys411472E)（强烈推荐！）
- [MIT 线性代数公开课](https://www.bilibili.com/video/BV1iQ4y1V7CZ)

### 文章
- [特征值和特征向量的直观理解](https://www.zhihu.com/question/...)
- [SVD 分解详解](https://www.cnblogs.com/pinard/p/...)

### 代码资源
- [NumPy 官方文档 - 线性代数](https://numpy.org/doc/stable/reference/routines.linalg.html)
- [sklearn PCA 文档](https://scikit-learn.org/stable/modules/generated/sklearn.decomposition.PCA.html)

---

**完成时间**: 2026-03-24  
**下次更新**: 2026-03-25 (Day 3)
