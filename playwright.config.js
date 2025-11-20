// Playwright config for headless tests against local server
const { devices } = require('@playwright/test');

module.exports = {
  timeout: 30 * 1000,
  use: {
    headless: true,
    viewport: { width: 1280, height: 800 },
    actionTimeout: 5 * 1000
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } }
  ],
  testDir: 'tests'
};
