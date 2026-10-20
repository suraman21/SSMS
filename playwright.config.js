const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests/e2e',
  fullyParallel: false,
  reporter: 'list',
  timeout: 30000,
  use: {
    baseURL: 'http://127.0.0.1:8123',
    headless: true,
    channel: 'chrome',
    trace: 'on-first-retry',
  },
  webServer: {
    command: 'php -S 127.0.0.1:8123 -t .',
    url: 'http://127.0.0.1:8123',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },
});
