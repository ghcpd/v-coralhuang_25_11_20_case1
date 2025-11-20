import { test, expect } from '@playwright/test';

test.describe('UI Interaction Bug Fixes', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('Hover region applies to entire profile pill', async ({ page }) => {
    const navButton = page.locator('header .nav-button');
    await expect(navButton).toBeVisible();

    const initialBgImage = await navButton.evaluate((el) => getComputedStyle(el).backgroundImage);

    // Hover specifically over the label portion to ensure full-pill hover works
    const label = navButton.locator('.nav-label');
    const box = await label.boundingBox();
    if (!box) throw new Error('Label bounding box not found');
    await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2);

    const hoverBgImage = await navButton.evaluate((el) => getComputedStyle(el).backgroundImage);

    expect(initialBgImage).toBe('none');
    expect(hoverBgImage).toContain('gradient');
  });

  test('Disabled primary button is clearly disabled and non-interactive', async ({ page }) => {
    const primary = page.locator('#primaryAction');
    await expect(primary).toBeVisible();
    await expect(primary).toBeDisabled();

    const cursor = await primary.evaluate((el) => getComputedStyle(el).cursor);
    expect(cursor).toBe('not-allowed');

    const boxShadowBefore = await primary.evaluate((el) => getComputedStyle(el).boxShadow);
    const transformBefore = await primary.evaluate((el) => getComputedStyle(el).transform);

    // Hover should not change visual state when disabled
    await primary.hover({ force: true });

    const boxShadowAfter = await primary.evaluate((el) => getComputedStyle(el).boxShadow);
    const transformAfter = await primary.evaluate((el) => getComputedStyle(el).transform);

    expect(boxShadowAfter).toBe(boxShadowBefore);
    expect(transformAfter).toBe(transformBefore);
  });

  test('Modal backdrop click closes modal and restores scroll', async ({ page }) => {
    const openModalBtn = page.locator('#openModalBtn');
    const modalRoot = page.locator('#settingsModal');
    const backdrop = page.locator('#modalBackdrop');

    // Ensure page can scroll
    const preScroll = await page.evaluate(() => {
      window.scrollTo(0, 500);
      return window.scrollY;
    });
    expect(preScroll).toBeGreaterThan(0);

    await openModalBtn.click();
    await expect(modalRoot).toBeVisible();

    const overflowWhenOpen = await page.evaluate(() => document.body.classList.contains('modal-open'));
    expect(overflowWhenOpen).toBeTruthy();

    // Scroll should be locked for user interactions
    const scrollBeforeWheel = await page.evaluate(() => window.scrollY);
    await page.mouse.wheel(0, 500);
    const scrollAfterWheel = await page.evaluate(() => window.scrollY);
    expect(scrollAfterWheel).toBe(scrollBeforeWheel);

    // Click backdrop (outside modal content) to close
    await backdrop.click({ position: { x: 5, y: 5 } });
    await expect(modalRoot).toBeHidden();

    const overflowAfter = await page.evaluate(() => document.body.classList.contains('modal-open'));
    expect(overflowAfter).toBeFalsy();

    const scrollAfterModal = await page.evaluate(() => {
      window.scrollTo(0, 0);
      const start = window.scrollY;
      window.scrollTo(0, 500);
      return { start, after: window.scrollY };
    });
    // After closing, scrolling should work again
    expect(scrollAfterModal.after).toBeGreaterThan(scrollAfterModal.start);
  });
});
