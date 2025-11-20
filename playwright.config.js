const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests',
  fullyParallel: true,
  use: {
    baseURL: 'http://localhost:3000',
    headless: true,
    trace: 'on-first-retry',
  },
  expect: {
    timeout: 5000,
  },
  reporter: [['list']],
  retries: process.env.CI ? 2 : 0,
  timeout: 30000,
});
