# CSS 格式批量修复报告

## 📅 执行时间
2026-04-15 08:49

## 🔍 问题原因
图灵测试页面的 `<style scoped>` CSS 使用了**多行格式化**格式，导致 VitePress v1.6.4 渲染异常。
符号主义页面使用**单行压缩**格式，渲染正常。

## ✅ 修复方案
将所有 Markdown 文件中的多行 CSS 压缩为单行格式，与符号主义保持一致。

## 📊 修复结果

### 修复前 CSS 行数对比
| 文件类型 | CSS 行数 |
|---------|---------|
| symbolism.md (参考标准) | 30 行 |
| 其他 12 个文件 | 160-196 行 |

### 修复后 CSS 行数对比
| 文件 | 修复后行数 | 状态 |
|------|-----------|------|
| turing-test.md | 已修复 | ✅ |
| symbolism.md | 30 行 (保持原样) | ✅ |
| dartmouth-conference.md | 1 行 | ✅ |
| perceptron.md | 1 行 | ✅ |
| connectionism.md | 1 行 | ✅ |
| backpropagation.md | 1 行 | ✅ |
| deep-learning.md | 1 行 | ✅ |
| cnn.md | 1 行 | ✅ |
| rnn-lstm.md | 1 行 | ✅ |
| transformer.md | 1 行 | ✅ |
| attention-mechanism.md | 1 行 | ✅ |
| bert.md | 1 行 | ✅ |
| gpt.md | 1 行 | ✅ |
| llm.md | 1 行 | ✅ |

## 🔧 操作流程

1. **识别问题**: 对比 symbolism.md 和其他文件的 CSS 格式差异
2. **批量修复**: 使用 awk 脚本将 12 个文件的多行 CSS 压缩为单行
3. **重新构建**: `npm run build` (耗时 7.24 秒)
4. **部署上线**: 复制到 `/var/www/ainanfeng-blog/` 并设置权限

## 📁 生成的 HTML 文件

### AI 历史系列 (6 篇)
| 文章 | 文件大小 |
|------|---------|
| 图灵测试 | 22 KB |
| 达特茅斯会议 | 19 KB |
| 感知机 | 20 KB |
| 符号主义 | 44 KB |
| 连接主义 | 23 KB |
| 反向传播算法 | 27 KB |

### 核心技术系列 (8 篇)
| 文章 | 文件大小 |
|------|---------|
| 深度学习 | 21 KB |
| 卷积神经网络 | 23 KB |
| RNN 与 LSTM | 29 KB |
| Transformer 架构 | 22 KB |
| 注意力机制 | 30 KB |
| BERT | 22 KB |
| GPT 系列 | 27 KB |
| 大语言模型 | 29 KB |

## ✅ 验证结果

- ✅ 所有 14 篇 HTML 文件已成功生成
- ✅ 文件大小正常 (19KB - 44KB)
- ✅ 已部署到生产环境 `/var/www/ainanfeng-blog/`
- ✅ 文件权限已设置为 `www-data:www-data`

## 🌐 访问地址

主页：https://ainanfeng.cn/ai-learning-docs

所有文章均可正常访问！

---

**修复完成时间**: 2026-04-15 08:49  
**构建工具**: VitePress v1.6.4  
**构建耗时**: 7.24 秒
