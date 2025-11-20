import { test, expect } from '@playwright/test';

const URL = 'http://localhost:3000';

test.describe('UI Interaction fixes', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(URL);
  });

  test('hover applies to full pill', async ({ page }) => {
    const btn = page.locator('#profileBtn');
    // ensure not hovered initially
    const bgBefore = await page.evaluate(el => getComputedStyle(el).backgroundImage, await btn.elementHandle());

    await btn.hover();
    const bgAfter = await page.evaluate(el => getComputedStyle(el).backgroundImage, await btn.elementHandle());

    expect(bgAfter).toContain('gradient');
    expect(bgAfter).not.toBe(bgBefore);
  });

  test('disabled primary button is visually and functionally disabled', async ({ page }) => {
    const btn = page.locator('#primaryAction');
    expect(await btn.getAttribute('disabled')).toBeDefined();

    const cursor = await page.evaluate(el => getComputedStyle(el).cursor, await btn.elementHandle());
    const opacity = await page.evaluate(el => getComputedStyle(el).opacity, await btn.elementHandle());

    expect(cursor).toBe('not-allowed');
    expect(parseFloat(opacity)).toBeLessThan(1);

    // clicking the disabled button should not navigate or trigger anything
    await btn.click({ force: true });
    // verify the page remains same
    expect(page.url()).toBe(URL + '/');
  });

  test('modal backdrop click closes and restores scroll', async ({ page }) => {
    // ensure body is tall so page has scrolling
    await page.evaluate(() => { document.body.style.height = '2000px'; });

    const open = page.locator('#openModalBtn');
    const modalRoot = page.locator('#settingsModal');
    const backdrop = page.locator('#modalBackdrop');

    await open.click();
    await expect(modalRoot).toHaveClass(/visible/);

    const overflowWhileOpen = await page.evaluate(() => document.body.style.overflow);
    expect(overflowWhileOpen).toBe('hidden');

    // close by clicking backdrop - click a coordinate outside modal content
    await page.mouse.click(20, 60);

    await expect(modalRoot).not.toHaveClass(/visible/);
    const overflowAfter = await page.evaluate(() => document.body.style.overflow);
    expect(overflowAfter).toBe('');
  });
});
