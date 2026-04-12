# 分享预览图片 - 南风博客

## 📐 规格要求

### Open Graph 图片（Facebook, LinkedIn, 微信等）
- **尺寸:** 1200 x 630 px
- **格式:** PNG 或 JPG
- **大小:** < 5MB
- **比例:** 1.91:1

### Twitter Card 图片
- **尺寸:** 1200 x 675 px（Twitter Summary Large Image）
- **格式:** PNG 或 JPG
- **大小:** < 5MB
- **比例:** 16:9

---

## 🎨 设计建议

### 方案 A: 简洁文字版
```
背景：渐变蓝紫色 (#667eea → #764ba2)
主标题：南风的博客（白色，粗体）
副标题：记录生活与技术（白色，半透明）
左下角：个人 Logo 或 GitHub ID
```

### 方案 B: 技术风格
```
背景：深色代码编辑器风格
元素：装饰性代码片段、终端窗口
文字：亮色高对比度
```

### 方案 C: 个人品牌
```
背景：你的工作环境或书桌照片（虚化）
文字：叠加在半透明色块上
风格：温暖、亲切
```

---

## 🛠️ 快速生成工具

### 方式 1: 使用 Canva（推荐）
1. 访问 https://www.canva.com/
2. 搜索 "Facebook Post" 模板（1200x630）
3. 自定义文字和颜色
4. 下载为 PNG

### 方式 2: 使用 Figma
1. 访问 https://figma.com/
2. 创建 1200x630 Frame
3. 设计后导出

### 方式 3: 在线生成器
- 🔗 https://og-image.vercel.app/ （程序员风格）
- 🔗 https://www.opengraph.xyz/ （预览测试）

### 方式 4: 用代码生成（Node.js + Canvas）
```javascript
const { createCanvas } = require('canvas');

const canvas = createCanvas(1200, 630);
const ctx = canvas.getContext('2d');

// 渐变背景
const gradient = ctx.createLinearGradient(0, 0, 1200, 630);
gradient.addColorStop(0, '#667eea');
gradient.addColorStop(1, '#764ba2');
ctx.fillStyle = gradient;
ctx.fillRect(0, 0, 1200, 630);

// 文字
ctx.fillStyle = 'white';
ctx.font = 'bold 72px sans-serif';
ctx.fillText('南风的博客', 60, 300);

ctx.font = '48px sans-serif';
ctx.globalAlpha = 0.9;
ctx.fillText('记录生活与技术', 60, 380);

// 保存
const fs = require('fs');
const buffer = canvas.toBuffer('image/png');
fs.writeFileSync('./og-image.png', buffer);
```

---

## 📤 上传到服务器

设计完成后，将图片放到博客的 public 目录：

```bash
# 假设你生成了 og-image.png
cp og-image.png /root/.openclaw/workspace/blog/docs/public/

# 或者通过 SCP 从本地上传
scp og-image.png root@your-server:/root/.openclaw/workspace/blog/docs/public/
```

然后重新构建博客：

```bash
cd /root/.openclaw/workspace/blog
npm run build
```

---

## ✅ 验证

### 测试 Open Graph 预览
- 🔗 Facebook Sharing Debugger: https://developers.facebook.com/tools/debug/
- 🔗 LinkedIn Post Inspector: https://www.linkedin.com/post-inspector/
- 🔗 Twitter Card Validator: https://cards-dev.twitter.com/validator

### 在聊天软件中测试
将链接 `https://ainanfeng.cn` 发送到：
- 微信
- QQ
- Telegram
- Discord

应该能看到自定义的预览图片和描述。

---

## 🎯 示例参考

### 优秀案例
- **VitePress:** 简洁品牌色 + Logo
- **Vue.js:** 绿色主题 + 清晰文字
- **个人博主:** 通常使用个人照片 + 文字叠加

### 避免的错误
- ❌ 文字太小（手机上看不清）
- ❌ 对比度不足
- ❌ 图片过大（加载慢）
- ❌ 使用过时的信息

---

**提示:** 如果暂时没时间设计，可以先用一个简单的渐变色背景 + 文字，后续再优化！
