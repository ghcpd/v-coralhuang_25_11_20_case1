const { test, expect } = require('@playwright/test');
const http = require('http');

test.describe('UI Interaction Bug Fixes', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:3000');
  });

  test('Full-pill hover state applies to entire pill', async ({ page }) => {
    const profileButton = page.locator('#profileButton');

    // Ensure initial background-image for the whole pill
    const beforeBg = await page.evaluate((el) => getComputedStyle(el).backgroundImage, await profileButton.elementHandle());
    const beforeColor = await page.evaluate((el) => getComputedStyle(el).color, await profileButton.elementHandle());

    // Also capture bounding box for debug assertions
    const box = await profileButton.boundingBox();
    console.log('profileButton box:', box);
    expect(box).not.toBeNull();
    expect(box.width).toBeGreaterThan(6);
    expect(box.height).toBeGreaterThan(6);

    // Hover the button using playwright API — more reliable than mouse move
    await profileButton.hover();

    // Give the animation/transition a moment
    await page.waitForTimeout(120);

    const afterBg = await page.evaluate((el) => getComputedStyle(el).backgroundImage, await profileButton.elementHandle());
    const afterColor = await page.evaluate((el) => getComputedStyle(el).color, await profileButton.elementHandle());

    // Debug: print values
    console.log('beforeBg:', beforeBg);
    console.log('afterBg:', afterBg);

    // The background image should change when hovering — ensure it's now not equal to before and includes 'gradient'
    expect(afterBg).not.toBe(beforeBg);
    expect(afterBg.toLowerCase()).toContain('gradient');

    // Text color should change to dark color on hover (ensuring entire pill hovered)
    expect(beforeColor).not.toBe(afterColor);
    // rgb(11, 17, 32) is #0b1120 dark
    await expect(profileButton).toHaveCSS('color', 'rgb(11, 17, 32)');

    // Also ensure that the profile button is still interactive and focusable
    await profileButton.focus();
    expect(await profileButton.evaluate((el) => el === document.activeElement)).toBe(true);
  });

  test('Disabled button state is clearly not clickable', async ({ page }) => {
    const primaryBtn = page.locator('#primaryAction');

    // Ensure disabled attribute is present
    expect(await primaryBtn.getAttribute('disabled')).not.toBe(null);

    // Expect the button to be disabled per Playwright's convenience method
    expect(await primaryBtn.isEnabled()).toBe(false);

    // Computed cursor should be not-allowed
    const cursor = await page.evaluate((el) => getComputedStyle(el).cursor, await primaryBtn.elementHandle());
    expect(cursor).toBe('not-allowed');

    // Click should be a no-op — since it's disabled, playright's click will throw — but we assert no change to attr
    // Ensure visually it's dimmed (opacity less than 1)
    const opacity = await page.evaluate((el) => parseFloat(getComputedStyle(el).opacity), await primaryBtn.elementHandle());
    expect(opacity).toBeLessThan(1);
  });

  test('Modal backdrop click closes modal and scroll is restored', async ({ page }) => {
    // Long page created for scroll testing
    await page.evaluate(() => { window.scrollTo(0, 400); });
    // ensure scrolled
    const initialScroll = await page.evaluate(() => window.scrollY);
    expect(initialScroll).toBeGreaterThan(0);

    const openModalBtn = page.locator('#openModalBtn');
    await openModalBtn.click();

    const modalRoot = page.locator('#settingsModal');
    const modalBackdrop = page.locator('#modalBackdrop');

    // Modal should show and lock scroll
    await expect(modalRoot).toHaveClass(/visible/);
    const bodyOverflow = await page.evaluate(() => document.body.style.overflow);
    expect(bodyOverflow).toBe('hidden');

    // Click the backdrop and wait for visibility to be removed
    await modalBackdrop.click();
    await page.waitForTimeout(100);

    await expect(modalRoot).not.toHaveClass(/visible/);

    // Scroll should be restored and be at the same position
    const afterScroll = await page.evaluate(() => window.scrollY);
    expect(afterScroll).toBe(initialScroll);
    const restoredOverflow = await page.evaluate(() => document.body.style.overflow);
    expect(restoredOverflow).toBe('');
  });
});
