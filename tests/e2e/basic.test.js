/**
 * 南风博客 - E2E 测试基础用例
 * 使用 Playwright 进行端到端测试
 */

const { test, expect } = require('@playwright/test');

// ============================================
// 首页测试
// ============================================
test.describe('首页', () => {
  test('应该成功加载首页', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveTitle(/南风的博客/);
  });

  test('应该显示导航栏', async ({ page }) => {
    await page.goto('/');
    const nav = page.locator('nav');
    await expect(nav).toBeVisible();
  });

  test('应该包含所有导航链接', async ({ page }) => {
    await page.goto('/');
    
    const links = [
      { text: '首页', href: '/' },
      { text: '文章', href: '/posts/' },
      { text: '关于', href: '/about' }
    ];
    
    for (const link of links) {
      const element = page.getByText(link.text);
      await expect(element).toBeVisible();
    }
  });

  test('SEO meta 标签应该存在', async ({ page }) => {
    await page.goto('/');
    
    // 检查 description
    const description = await page.locator('meta[name="description"]').getAttribute('content');
    expect(description).toContain('南风的博客');
    
    // 检查 keywords
    const keywords = await page.locator('meta[name="keywords"]').getAttribute('content');
    expect(keywords).toContain('AI 技术');
  });
});

// ============================================
// 文章页面测试
// ============================================
test.describe('文章页面', () => {
  test('文章列表页应该可访问', async ({ page }) => {
    await page.goto('/posts/');
    await expect(page).toHaveURL(/\/posts\//);
  });

  test('文章详情页应该可访问', async ({ page }) => {
    await page.goto('/posts/blog-transformation');
    await expect(page.locator('article')).toBeVisible();
  });

  test('文章应该有目录（TOC）', async ({ page }) => {
    await page.goto('/posts/blog-transformation');
    const toc = page.locator('.VPDocOutline');
    await expect(toc).toBeVisible();
  });
});

// ============================================
// 功能页面测试
// ============================================
test.describe('功能页面', () => {
  test('RAG 知识库页面应该可访问', async ({ page }) => {
    await page.goto('/rag');
    await expect(page).toHaveURL(/\/rag/);
  });

  test('情感分析页面应该可访问', async ({ page }) => {
    await page.goto('/emotion');
    await expect(page).toHaveURL(/\/emotion/);
  });

  test('AI 方块页面应该可访问', async ({ page }) => {
    await page.goto('/tetris');
    await expect(page).toHaveURL(/\/tetris/);
  });
});

// ============================================
// 响应式测试
// ============================================
test.describe('响应式设计', () => {
  test('应该在移动端正常显示', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/');
    
    const nav = page.locator('nav');
    await expect(nav).toBeVisible();
  });

  test('应该在桌面端正常显示', async ({ page }) => {
    await page.setViewportSize({ width: 1920, height: 1080 });
    await page.goto('/');
    
    const content = page.locator('.VPContent');
    await expect(content).toBeVisible();
  });
});

// ============================================
// 性能测试
// ============================================
test.describe('性能', () => {
  test('首页加载时间应该小于 3 秒', async ({ page }) => {
    const startTime = Date.now();
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    const loadTime = Date.now() - startTime;
    
    console.log(`首页加载时间：${loadTime}ms`);
    expect(loadTime).toBeLessThan(3000);
  });

  test('页面应该有合理的 LCP', async ({ page }) => {
    await page.goto('/');
    
    // 获取 LCP 指标
    const lcp = await page.evaluate(() => {
      return new Promise((resolve) => {
        new PerformanceObserver((list) => {
          const entries = list.getEntries();
          const lastEntry = entries[entries.length - 1];
          resolve(lastEntry.startTime);
        }).observe({ entryTypes: ['largest-contentful-paint'] });
        
        setTimeout(resolve, 5000);
      });
    });
    
    console.log(`LCP: ${lcp}ms`);
    expect(lcp).toBeLessThan(2500);
  });
});

// ============================================
// 无障碍测试
// ============================================
test.describe('无障碍性', () => {
  test('所有图片应该有 alt 文本', async ({ page }) => {
    await page.goto('/');
    
    const images = page.locator('img');
    const count = await images.count();
    
    for (let i = 0; i < count; i++) {
      const img = images.nth(i);
      const alt = await img.getAttribute('alt');
      
      // 装饰性图片可以有空 alt，但必须有 alt 属性
      expect(img).toHaveAttribute('alt');
    }
  });

  test('页面应该有正确的语言设置', async ({ page }) => {
    await page.goto('/');
    const html = page.locator('html');
    await expect(html).toHaveAttribute('lang', 'zh-CN');
  });
});
