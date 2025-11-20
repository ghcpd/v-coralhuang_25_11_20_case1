const { test, expect } = require('@playwright/test');

const getComputedData = (locator, propertyKeys) =>
  locator.evaluate((node, keys) => {
    const computed = window.getComputedStyle(node);
    return keys.reduce((acc, key) => {
      acc[key] = computed[key];
      return acc;
    }, {});
  }, propertyKeys);

test.describe('UI interaction fixes', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('full pill hover is interactive across the entire profile chip', async ({ page }) => {
    const navButton = page.locator('.nav-button');
    await expect(navButton).toBeVisible();
    const box = await navButton.boundingBox();
    expect(box).not.toBeNull();
    if (box) {
      await page.mouse.move(box.x + box.width - 5, box.y + box.height / 2);
    }
    await page.waitForTimeout(100);
    const styles = await getComputedData(navButton, ['backgroundImage']);
    expect(styles.backgroundImage).toContain('gradient');
  });

  test('disabled primary action is clearly disabled and inert', async ({ page }) => {
    const primaryButton = page.locator('#primaryAction');
    await expect(primaryButton).toBeDisabled();
    const beforeHover = await getComputedData(primaryButton, ['cursor', 'boxShadow', 'pointerEvents', 'transform', 'opacity']);
    expect(beforeHover.cursor).toBe('not-allowed');
    expect(beforeHover.boxShadow).toBe('none');
    expect(beforeHover.pointerEvents).toBe('none');
    expect(beforeHover.transform).toBe('none');
    expect(parseFloat(beforeHover.opacity)).toBeLessThan(0.8);

    const box = await primaryButton.boundingBox();
    expect(box).not.toBeNull();
    if (box) {
      await page.mouse.move(box.x + box.width / 2, box.y + box.height / 2);
    }
    await page.waitForTimeout(100);
    const afterHover = await getComputedData(primaryButton, ['transform']);
    expect(afterHover.transform).toBe('none');
  });

  test('backdrop click closes modal and restores scroll', async ({ page }) => {
    await page.locator('#openModalBtn').click();
    const modal = page.locator('#settingsModal');
    await expect(modal).toBeVisible();
    await expect.poll(async () => {
      return page.evaluate(() => getComputedStyle(document.body).overflow);
    }).toBe('hidden');

    const backdrop = page.locator('#modalBackdrop');
    await backdrop.click({ position: { x: 10, y: 10 } });

    await expect(modal).toBeHidden();
    await expect.poll(async () => {
      return page.evaluate(() => getComputedStyle(document.body).overflow);
    }).toBe('visible');
  });
});
