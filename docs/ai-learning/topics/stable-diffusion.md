---
layout: page
title: Stable Diffusion
description: 开源文生图扩散模型详解与应用
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · AIGC</span>
    <h1>🎨 Stable Diffusion</h1>
    <p class="description">Stability AI 开源的潜在扩散模型，实现了高质量、高效率的文生图生成</p>
  </div>

  <div class="content-body">

## 概述

**Stable Diffusion** 是由 Stability AI 开发的开源潜在扩散模型（Latent Diffusion Model），能够根据文本描述生成高质量图像。

## 核心原理

### 扩散过程

```python
# 前向扩散：逐步添加噪声
def forward_diffusion(x_0, t, T):
    alpha_bar = compute_alpha_bar(t, T)
    noise = torch.randn_like(x_0)
    x_t = sqrt(alpha_bar[t]) * x_0 + sqrt(1 - alpha_bar[t]) * noise
    return x_t, noise

# 反向去噪：学习去除噪声
def reverse_diffusion(x_t, t, model):
    noise_pred = model(x_t, t)
    x_{t-1} = (x_t - beta_t * noise_pred) / sqrt(alpha_t)
    return x_{t-1}
```

### 潜在空间

```python
from diffusers import AutoencoderKL

# VAE 编码器
vae = AutoencoderKL.from_pretrained("stabilityai/stable-diffusion-2")
latent = vae.encode(image).latent_dist.sample()  # 512x512 → 64x64

# VAE 解码器
image_recon = vae.decode(latent).sample
```

## 快速开始

```python
from diffusers import StableDiffusionPipeline
import torch

# 加载模型
pipe = StableDiffusionPipeline.from_pretrained(
    "runwayml/stable-diffusion-v1-5",
    torch_dtype=torch.float16
).to("cuda")

# 文生图
prompt = "a photo of an astronaut riding a horse on mars"
image = pipe(prompt).images[0]
image.save("astronaut.png")

# 负向提示词
negative_prompt = "ugly, blurry, low quality"
image = pipe(prompt, negative_prompt=negative_prompt).images[0]
```

## 进阶应用

### 1. 图像修复 (Inpainting)

```python
from diffusers import StableDiffusionInpaintPipeline

pipe = StableDiffusionInpaintPipeline.from_pretrained(
    "runwayml/stable-diffusion-inpainting"
).to("cuda")

image = Image.open("original.png")
mask = Image.open("mask.png")

prompt = "a cute cat sitting here"
result = pipe(prompt=prompt, image=image, mask_image=mask).images[0]
```

### 2. 图像到图像 (Img2Img)

```python
from diffusers import StableDiffusionImg2ImgPipeline

pipe = StableDiffusionImg2ImgPipeline.from_pretrained(
    "runwayml/stable-diffusion-v1-5"
).to("cuda")

init_image = Image.open("sketch.png")
prompt = "a detailed landscape painting"

result = pipe(prompt=prompt, image=init_image, strength=0.75).images[0]
```

### 3. ControlNet 精确控制

```python
from diffusers import ControlNetModel, StableDiffusionControlNetPipeline
import cv2

# 加载 ControlNet
controlnet = ControlNetModel.from_pretrained(
    "lllyasviel/control_v11p_sd15_canny"
).to("cuda")

pipe = StableDiffusionControlNetPipeline.from_pretrained(
    "runwayml/stable-diffusion-v1-5",
    controlnet=controlnet
).to("cuda")

# 边缘检测
image = np.array(Image.open("input.png"))
edges = cv2.Canny(image, 100, 200)
control_image = Image.fromarray(edges)

prompt = "a beautiful castle"
result = pipe(prompt=prompt, image=control_image).images[0]
```

## 优化技巧

### 采样器选择

```python
from diffusers import DPMSolverMultistepScheduler

pipe.scheduler = DPMSolverMultistepScheduler.from_config(pipe.scheduler.config)

# 更快收敛（20 步 vs 50 步）
image = pipe(prompt, num_inference_steps=20).images[0]
```

### 显存优化

```python
# 启用注意力切片
pipe.enable_attention_slicing()

# 启用模型卸载
pipe.enable_model_cpu_offload()

# 使用 xformers 加速
pipe.enable_xformers_memory_efficient_attention()
```

## 版本对比

| 版本 | 分辨率 | 步数 | 特点 |
|------|--------|------|------|
| SD 1.5 | 512×512 | 50 | 基础版本 |
| SD 2.0 | 768×768 | 50 | 更高画质 |
| SDXL | 1024×1024 | 30 | 最新最强 |
| SDXL Turbo | 512×512 | 1-4 | 实时生成 |

## 学习资源

- [Stability AI 官网](https://stability.ai/)
- [Hugging Face Diffusers](https://huggingface.co/docs/diffusers)
- [CivitAI 模型分享](https://civitai.com/)

## 相关概念

- [[多模态]](/ai-learning/topics/multimodal) - 跨模态理解
- [[AIGC]](/ai-learning/topics/aigc) - 生成式 AI
- [[Sora]](/ai-learning/topics/sora) - 视频生成

## 下一步学习

1. **[多模态融合](/ai-learning/topics/multimodal-fusion)** - 图文统一
2. **[Sora](/ai-learning/topics/sora)** - 视频生成
3. **[ControlNet 实战](/ai-learning/resources/controlnet-guide)** - 精确控制

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/aigc" class="nav-link">← AIGC</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/sora" class="nav-link">Sora →</a>
    </div>
  </div>
</div>

<style scoped>
.learning-content { max-width: 900px; margin: 0 auto; padding: 2rem; }
.content-header { margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 2px solid #e5e7eb; }
.category-badge { display: inline-block; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.85rem; margin-bottom: 1rem; text-transform: uppercase; }
.content-header h1 { font-size: 2.5rem; margin-bottom: 0.75rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
.description { font-size: 1.1rem; color: #666; line-height: 1.6; }
.content-body { line-height: 1.8; color: #374151; }
.content-body h2 { color: #667eea; margin-top: 2rem; margin-bottom: 1rem; font-size: 1.5rem; }
.content-body h3 { color: #764ba2; margin-top: 1.5rem; margin-bottom: 0.75rem; font-size: 1.2rem; }
.content-body ul, .content-body ol { margin: 1rem 0; padding-left: 1.5rem; }
.content-body li { margin: 0.5rem 0; line-height: 1.6; }
.content-body a { color: #667eea; text-decoration: none; transition: color 0.2s; font-weight: 500; }
.content-body a:hover { color: #764ba2; text-decoration: underline; }
.content-body strong { color: #1f2937; font-weight: 600; }
.content-body pre { background: #1f2937; color: #f3f4f6; padding: 1.5rem; border-radius: 8px; overflow-x: auto; margin: 1.5rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.9em; line-height: 1.6; }
.content-body code { font-family: 'JetBrains Mono', monospace; }
.content-body blockquote { border-left: 4px solid #f093fb; padding-left: 1rem; margin: 1.5rem 0; color: #4b5563; font-style: italic; background: #f9fafb; padding: 1rem; border-radius: 0 8px 8px 0; }
.content-navigation { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 3rem; padding-top: 2rem; border-top: 2px solid #e5e7eb; }
.nav-card { background: white; border: 2px solid #e5e7eb; border-radius: 12px; padding: 1.5rem; transition: all 0.3s ease; }
.nav-card:hover { border-color: #f093fb; box-shadow: 0 4px 12px rgba(240, 147, 251, 0.2); transform: translateY(-2px); }
.nav-label { display: block; font-size: 0.85rem; color: #6b7280; margin-bottom: 0.5rem; }
.nav-link { display: block; font-size: 1.1rem; font-weight: 600; color: #667eea; text-decoration: none; transition: color 0.2s; }
.nav-link:hover { color: #764ba2; }
@media (max-width: 768px) { .learning-content { padding: 1rem; } .content-header h1 { font-size: 1.8rem; } .content-navigation { grid-template-columns: 1fr; } }
</style>
