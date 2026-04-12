/**
 * Playwright 测试配置
 */

import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  // 测试文件位置
  testDir: './tests/e2e',
  
  // 超时设置
  timeout: 30 * 1000,
  expect: {
    timeout: 5000
  },
  
  // 失败重试次数
  retries: process.env.CI ? 2 : 0,
  
  // 并行 worker 数量
  workers: process.env.CI ? 1 : undefined,
  
  // 报告器
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['list'],
    ['json', { outputFile: 'test-results.json' }]
  ],
  
  // 共享配置
  use: {
    // 基础 URL（在 CI 中会被覆盖）
    baseURL: 'http://localhost:4173',
    
    // 浏览器上下文
    browserName: 'chromium',
    headless: true,
    
    // 截图和录像
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'retain-on-failure',
    
    // 其他选项
    viewport: { width: 1280, height: 720 },
    actionTimeout: 10 * 1000,
  },
  
  // 多浏览器配置
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    // 以下浏览器在 CI 中可选启用
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
  
  // Web 服务器配置（用于本地测试）
  webServer: {
    command: 'npm run build && npm run preview',
    url: 'http://localhost:4173',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000,
  },
});
