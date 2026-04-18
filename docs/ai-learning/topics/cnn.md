---
layout: page
title: 卷积神经网络
description: 计算机视觉的核心技术，受生物视觉皮层启发
sidebar: true
page: true
---


<div class="learning-content">
    <div class="content-header">
    <span class="category-badge">核心技术</span>
    <h1> 卷积神经网络</h1>
    <p class="description">计算机视觉的核心技术，受生物视觉皮层启发</p>
  </div>

  <div class="content-body">


## 概述

**卷积神经网络**（Convolutional Neural Network, CNN）是一种专门用于处理具有网格结构数据（如图像）的深度学习模型。它在图像分类、目标检测、语义分割等计算机视觉任务中取得了巨大成功。

## 核心思想

### 局部连接

与传统全连接网络不同，CNN 的神经元只连接到输入数据的局部区域：

```
传统 FCN: 每个神经元连接所有输入 (784 个参数 for 28x28 图像)
CNN: 每个神经元只连接局部区域 (如 3x3=9 个参数)
```

**优势**：
- ✅ 参数数量大幅减少
- ✅ 保留空间结构信息
- ✅ 提取局部特征

### 权值共享

同一个卷积核在整张图像上滑动，使用相同的权重：

```python
# 卷积操作示例
output[i, j] = sum(kernel * input[i:i+3, j:j+3])
```

**好处**：
- ✅ 平移不变性
- ✅ 进一步减少参数
- ✅ 检测任意位置的特征

### 层次化特征

```
输入 → 边缘/角点 → 纹理 → 部件 → 物体 → 场景
      (浅层)        (中层)     (深层)
```

## 关键组件

### 1. 卷积层（Convolutional Layer）

#### 2D 卷积
```python
import torch.nn as nn

conv_layer = nn.Conv2d(
    in_channels=3,      # 输入通道数 (RGB)
    out_channels=64,    # 输出通道数 (滤波器数量)
    kernel_size=3,      # 卷积核大小
    stride=1,           # 步长
    padding=1,          # 填充
    bias=True           # 偏置
)
```

#### 常见卷积类型
- **标准卷积**：常规的空间卷积
- **1x1 卷积**：通道混合，降维/升维
- **深度可分离卷积**：MobileNet 使用，高效
- **空洞卷积**：扩大感受野，无需增加参数

### 2. 池化层（Pooling Layer）

#### 最大池化
```python
maxpool = nn.MaxPool2d(kernel_size=2, stride=2)
# 取 2x2 区域的最大值，尺寸减半
```

#### 平均池化
```python
avgpool = nn.AvgPool2d(kernel_size=2, stride=2)
# 取 2x2 区域的平均值
```

**作用**：
- 降采样，减少计算量
- 增大感受野
- 一定的平移不变性

### 3. 激活函数

#### ReLU
```python
relu = nn.ReLU()
# f(x) = max(0, x)
```

#### Leaky ReLU
```python
leaky_relu = nn.LeakyReLU(negative_slope=0.01)
# 允许小的负梯度
```

### 4. 批归一化（BatchNorm）

```python
bn = nn.BatchNorm2d(num_features=64)
# 标准化激活值，加速训练
```

## 经典架构

### LeNet-5 (1998)

第一个成功的 CNN 应用（手写数字识别）：

```
Input(32x32) → Conv → Pool → Conv → Pool → FC → Output
```

### AlexNet (2012)

ImageNet 竞赛突破性胜利：

```python
architecture = [
    Conv(11x11, 96, stride=4) → ReLU → MaxPool,
    Conv(5x5, 256) → ReLU → MaxPool,
    Conv(3x3, 384) → ReLU,
    Conv(3x3, 384) → ReLU,
    Conv(3x3, 256) → ReLU → MaxPool,
    FC(4096) → ReLU → Dropout,
    FC(4096) → ReLU → Dropout,
    FC(1000) → Softmax
]
```

**创新**：
- ReLU 激活函数
- Dropout 正则化
- GPU 加速训练

### VGG (2014)

探索网络深度的影响：

```
特点：
- 全部使用 3x3 小卷积核
- 非常深的网络（16-19 层）
- 规则的网络结构
```

### ResNet (2015)

引入残差连接，解决退化问题：

```python
class ResidualBlock(nn.Module):
    def forward(self, x):
        residual = x
        out = self.conv1(x)
        out = self.bn1(out)
        out = self.relu(out)
        out = self.conv2(out)
        out = self.bn2(out)
        out += residual  # 残差连接
        out = self.relu(out)
        return out
```

**关键创新**：
- 恒等映射（Identity Mapping）
- 可以训练上百层的网络
- ResNet-152 甚至 ResNet-1000

## 代码实战

### 实现简单 CNN

```python
import torch
import torch.nn as nn

class SimpleCNN(nn.Module):
    def __init__(self, num_classes=10):
        super().__init__()
        
        self.features = nn.Sequential(
            # Block 1
            nn.Conv2d(3, 64, kernel_size=3, padding=1),
            nn.BatchNorm2d(64),
            nn.ReLU(inplace=True),
            nn.Conv2d(64, 64, kernel_size=3, padding=1),
            nn.BatchNorm2d(64),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(2, 2),
            
            # Block 2
            nn.Conv2d(64, 128, kernel_size=3, padding=1),
            nn.BatchNorm2d(128),
            nn.ReLU(inplace=True),
            nn.Conv2d(128, 128, kernel_size=3, padding=1),
            nn.BatchNorm2d(128),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(2, 2),
            
            # Block 3
            nn.Conv2d(128, 256, kernel_size=3, padding=1),
            nn.BatchNorm2d(256),
            nn.ReLU(inplace=True),
            nn.AdaptiveAvgPool2d((1, 1))
        )
        
        self.classifier = nn.Linear(256, num_classes)
    
    def forward(self, x):
        x = self.features(x)
        x = x.view(x.size(0), -1)
        x = self.classifier(x)
        return x

# 创建模型
model = SimpleCNN(num_classes=10)
print(f"模型参数量：{sum(p.numel() for p in model.parameters()):,}")
```

### 迁移学习

```python
from torchvision import models

# 加载预训练的 ResNet
resnet = models.resnet50(pretrained=True)

# 冻结骨干网络
for param in resnet.parameters():
    param.requires_grad = False

# 替换最后的全连接层
num_features = resnet.fc.in_features
resnet.fc = nn.Linear(num_features, num_classes)

# 只训练新的分类层
optimizer = torch.optim.Adam(filter(lambda p: p.requires_grad, 
                                     resnet.parameters()), 
                            lr=0.001)
```

## 应用领域

### 图像分类
- ImageNet 挑战赛
- 细粒度分类
- 医学图像分析

### 目标检测
- R-CNN 系列
- YOLO 系列
- SSD

### 语义分割
- FCN（全卷积网络）
- U-Net（医学图像）
- DeepLab 系列

### 实例分割
- Mask R-CNN
- SOLO

### 其他应用
- 🎨 风格迁移
- 🔍 图像检索
- 📸 超分辨率
- 🎭 人脸生成

## 学习资源

### 📺 视频教程
- **[CS231n - Stanford](http://cs231n.stanford.edu/)** - CNN 与视觉识别经典课程
- **[李飞飞 CS231n 中文字幕](https://www.bilibili.com/video/BV1iJ411E7xW)** - B 站可看
- **[Fast.ai 计算机视觉](https://course.fast.ai/)** - 实战导向

### 📚 书籍推荐
- **《深度学习》第 9 章** - Ian Goodfellow（理论基础）
- **《Computer Vision: Algorithms and Applications》** - Richard Szeliski
- **《Deep Learning for Computer Vision》** - Rajalingappaa Shanmugamani

### 📄 经典论文
- [LeCun et al. (1998) - Gradient-based learning applied to document recognition](http://yann.lecun.com/exdb/publis/pdf/lecun-98.pdf)
- [Krizhevsky et al. (2012) - ImageNet Classification with Deep Convolutional Neural Networks](https://papers.nips.cc/paper/2012/hash/c399862d3b9d6b76c8436e924a68c45b-Abstract.html)
- [He et al. (2015) - Deep Residual Learning for Image Recognition](https://arxiv.org/abs/1512.03385)

### 💻 实践工具
- **[PyTorch](https://pytorch.org/)** - 研究首选
- **[TensorFlow](https://www.tensorflow.org/)** - 工业部署
- **[Detectron2](https://github.com/facebookresearch/detectron2)** - FAIR 的目标检测库
- **[MMDetection](https://github.com/open-mmlab/mmdetection)** - 商汤的检测工具箱

## 相关概念

- [[深度学习]](/ai-learning/topics/deep-learning) - 基础理论
- [[Transformer]](/ai-learning/topics/transformer) - 新的视觉架构 ViT
- [[目标检测]](/ai-learning/tasks/object-detection) - 主要应用方向
- [[图像分割]](/ai-learning/tasks/image-segmentation) - 像素级理解

## 下一步学习

完成这个概念后，建议继续学习：

1. **[目标检测](/ai-learning/tasks/object-detection)** - CNN 的重要应用
2. **[图像分割](/ai-learning/tasks/image-segmentation)** - 像素级理解
3. **[Transformer](/ai-learning/topics/transformer)** - 了解 ViT 等新架构


  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/deep-learning" class="nav-link">← 深度学习</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/rnn-lstm" class="nav-link">RNN 与 LSTM →</a>
    </div>
  </div>
</div>

<style scoped> .learning-content { max-width: 900px; margin: 0 auto; padding: 2rem; } .content-header { margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 2px solid #e5e7eb; } .category-badge { display: inline-block; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.85rem; margin-bottom: 1rem; text-transform: uppercase; } .content-header h1 { font-size: 2.5rem; margin-bottom: 0.75rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; } .description { font-size: 1.1rem; color: #666; line-height: 1.6; } .content-body { line-height: 1.8; color: #374151; } .content-body h2 { color: #667eea; margin-top: 2rem; margin-bottom: 1rem; font-size: 1.5rem; } .content-body h3 { color: #764ba2; margin-top: 1.5rem; margin-bottom: 0.75rem; font-size: 1.2rem; } .content-body ul { margin: 1rem 0; padding-left: 1.5rem; } .content-body li { margin: 0.5rem 0; line-height: 1.6; } .content-body a { color: #667eea; text-decoration: none; transition: color 0.2s; font-weight: 500; } .content-body a:hover { color: #764ba2; text-decoration: underline; } .content-body strong { color: #1f2937; font-weight: 600; } .content-body pre { background: #1f2937; color: #f3f4f6; padding: 1.5rem; border-radius: 8px; overflow-x: auto; margin: 1.5rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.9em; line-height: 1.6; } .content-body code { font-family: 'JetBrains Mono', monospace; } .content-body blockquote { border-left: 4px solid #f093fb; padding-left: 1rem; margin: 1.5rem 0; color: #4b5563; font-style: italic; background: #f9fafb; padding: 1rem; border-radius: 0 8px 8px 0; } .content-navigation { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 3rem; padding-top: 2rem; border-top: 2px solid #e5e7eb; } .nav-card { background: white; border: 2px solid #e5e7eb; border-radius: 12px; padding: 1.5rem; transition: all 0.3s ease; } .nav-card:hover { border-color: #f093fb; box-shadow: 0 4px 12px rgba(240, 147, 251, 0.2); transform: translateY(-2px); } .nav-label { display: block; font-size: 0.85rem; color: #6b7280; margin-bottom: 0.5rem; } .nav-link { display: block; font-size: 1.1rem; font-weight: 600; color: #667eea; text-decoration: none; transition: color 0.2s; } .nav-link:hover { color: #764ba2; } @media (max-width: 768px) { .learning-content { padding: 1rem; } .content-header h1 { font-size: 1.8rem; } .content-navigation { grid-template-columns: 1fr; } } </style>
