# 🚨 摔倒检测系统访问说明

## ⚠️ 重要提示

由于 Streamlit 框架的技术限制（使用相对路径加载资源），摔倒检测系统**无法**通过 `https://ainanfeng.cn/fall-detection/` 路径访问。

## ✅ 正确的访问方式

### 方式 1：通过 IP 和端口（推荐）
```
http://43.134.43.119:8501/
```

### 方式 2：通过域名和端口
```
http://ainanfeng.cn:8501/
```

## 🔒 为什么不能通过 HTTPS 路径访问？

Streamlit 是一个完整的 Web 应用框架，它：
1. 使用**相对路径**加载 JavaScript 和 CSS 资源（如 `./static/js/...`）
2. 当通过 `https://ainanfeng.cn/fall-detection/` 访问时
3. 浏览器会尝试从 `https://ainanfeng.cn/fall-detection/static/js/...` 加载资源
4. 但这些资源实际由 Streamlit 服务器内部管理，不在 Nginx 的静态文件目录中
5. 导致 404 错误，页面无法正常显示

## 💡 其他应用的访问方式

以下应用**可以**通过 HTTPS 路径访问（因为它们支持子路径部署）：

| 应用 | HTTPS 访问地址 |
|------|--------------|
| RAG 知识库 | https://ainanfeng.cn/rag/ |
| 情感分析 | https://ainanfeng.cn/emotion/ |
| AI 俄罗斯方块 | https://ainanfeng.cn/tetris/ |

## 🔧 技术细节

**支持子路径的应用**：
- 使用绝对路径或可配置的基础路径
- 静态资源可以通过 Nginx 反向代理

**不支持子路径的应用**：
- Streamlit（摔倒检测系统）
- 某些单页应用（SPA）
- 需要使用独立端口或通过根路径访问

## 📞 如有问题

如果无法访问 http://43.134.43.119:8501/，请检查：
1. 防火墙是否开放了 8501 端口
2. Streamlit 服务是否在运行
3. 联系管理员重启服务

---

*最后更新：2026-04-12*
