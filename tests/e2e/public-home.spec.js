const { test, expect } = require('@playwright/test');

test.describe('Public website smoke', () => {
  test('renders the landing page and opens the mobile menu', async ({ page }) => {
    await page.setViewportSize({ width: 390, height: 844 });
    await page.goto('/');

    await expect(page.locator('nav')).toBeVisible();
    await expect(page.locator('#home h1')).toContainText(/.+/);
    await expect(page.locator('#mobile-menu-btn')).toBeVisible();

    await page.locator('#mobile-menu-btn').click();
    await expect(page.locator('#mobile-menu')).toBeVisible();
    await expect(page.locator('#mobile-menu a[href="#about"]')).toBeVisible();

    await page.locator('#mobile-menu a[href="#about"]').click();
    await expect(page.locator('#about')).toBeInViewport();
    await expect(page.locator('#about h2')).toContainText(/About/i);
  });
});
