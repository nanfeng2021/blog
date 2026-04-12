const { createCanvas } = require('canvas');
const fs = require('fs');
const path = require('path');

// 创建画布
const canvas = createCanvas(1200, 630);
const ctx = canvas.getContext('2d');

// 创建渐变背景（蓝紫色）
const gradient = ctx.createLinearGradient(0, 0, 1200, 630);
gradient.addColorStop(0, '#667eea');
gradient.addColorStop(0.5, '#764ba2');
gradient.addColorStop(1, '#f093fb');
ctx.fillStyle = gradient;
ctx.fillRect(0, 0, 1200, 630);

// 添加装饰性圆形
ctx.globalAlpha = 0.08;
for (let i = 0; i < 30; i++) {
    const x = Math.random() * 1200;
    const y = Math.random() * 630;
    const r = Math.random() * 120 + 40;
    ctx.beginPath();
    ctx.arc(x, y, r, 0, Math.PI * 2);
    ctx.fillStyle = 'white';
    ctx.fill();
}
ctx.globalAlpha = 1;

// 主标题 - 南风的博客
ctx.fillStyle = 'white';
ctx.font = 'bold 80px "PingFang SC", "Microsoft YaHei", "SimHei", sans-serif';
ctx.textAlign = 'center';
ctx.fillText('南风的博客', 600, 280);

// 副标题 - 记录生活与技术
ctx.font = '48px "PingFang SC", "Microsoft YaHei", "SimHei", sans-serif';
ctx.globalAlpha = 0.95;
ctx.fillText('记录生活与技术', 600, 360);

// 底部描述
ctx.font = '32px "PingFang SC", "Microsoft YaHei", "SimHei", sans-serif';
ctx.globalAlpha = 0.85;
ctx.fillText('AI 技术 · 编程实践 · 生活感悟', 600, 440);

// 添加底线装饰
ctx.globalAlpha = 1;
ctx.strokeStyle = 'rgba(255,255,255,0.6)';
ctx.lineWidth = 4;
ctx.beginPath();
ctx.moveTo(400, 480);
ctx.lineTo(800, 480);
ctx.stroke();

// GitHub ID
ctx.font = '24px monospace';
ctx.globalAlpha = 0.7;
ctx.textAlign = 'right';
ctx.fillText('@nanfeng2021', 1140, 580);

// 右下角小图标（代码符号）
ctx.font = 'bold 28px monospace';
ctx.fillStyle = 'white';
ctx.globalAlpha = 0.8;
ctx.fillText('</>', 1140, 540);

// 保存为 PNG
const outputPath = path.join(__dirname, 'docs/public/og-image.png');
const buffer = canvas.toBuffer('image/png');
fs.writeFileSync(outputPath, buffer);

console.log('✅ OG 图片生成成功！');
console.log(`📁 保存位置：${outputPath}`);
console.log(`📐 尺寸：1200 x 630 px`);
console.log(`💾 文件大小：${(buffer.length / 1024).toFixed(2)} KB`);
