const { test, expect } = require('@playwright/test');

const BASE = 'http://localhost:3000';

test.describe('UI interaction fixes', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(BASE);
    await page.waitForLoadState('networkidle');
  });

  test('full-pill hover highlights the entire profile pill', async ({ page }) => {
    // ensure initial state has no background image on label
    const beforeBg = await page.$eval('.nav-label', el => getComputedStyle(el).backgroundImage);
    expect(beforeBg === 'none' || beforeBg === 'initial' ).toBeTruthy();

    // hover the pill (center) and verify the nav-label receives the hover styling
    await page.hover('#profilePill');
    const afterBg = await page.$eval('.nav-label', el => getComputedStyle(el).backgroundImage);
    expect(afterBg).not.toBe('none');
  });

  test('disabled primary button is visually distinct and not clickable', async ({ page }) => {
    const isDisabled = await page.$eval('#primaryAction', el => el.disabled === true);
    expect(isDisabled).toBeTruthy();

    // visual checks: opacity and cursor show not-allowed
    const style = await page.$eval('#primaryAction', el => getComputedStyle(el));
    // assert opacity is lower than 0.8 and cursor contains not-allowed
    expect(parseFloat(style.opacity)).toBeLessThanOrEqual(0.6);
    expect(style.cursor).toContain('not-allowed');

    // behavioral check: clicking should not trigger click handlers for disabled button
    const clickedValue = await page.$eval('#primaryAction', el => { el.click(); return el.getAttribute('data-clicked'); });
    expect(clickedValue).toBeNull();
  });

  test('modal backdrop click closes modal and restores page scroll', async ({ page }) => {
    // The page contains a tall spacer so scroll exists
    const canScroll = await page.evaluate(() => document.body.scrollHeight > window.innerHeight);
    expect(canScroll).toBeTruthy();

    // open modal
    await page.click('#openModalBtn');
    await expect(page.locator('#settingsModal')).toHaveClass(/visible/);
    // body scrolling should be locked
    let overflow = await page.evaluate(() => document.body.style.overflow);
    expect(overflow).toBe('hidden');

    // clicking backdrop (outside modal-content) should close the modal and restore scroll
    // click near top-left corner of the backdrop to avoid the centered modal-content
    await page.click('#modalBackdrop', { position: { x: 10, y: 10 } });
    await expect(page.locator('#settingsModal')).not.toHaveClass(/visible/);
    overflow = await page.evaluate(() => document.body.style.overflow);
    expect(overflow === '' || overflow === undefined).toBeTruthy();

    // open again and close via Close button
    await page.click('#openModalBtn');
    await expect(page.locator('#settingsModal')).toHaveClass(/visible/);
    await page.click('#closeModalBtn');
    await expect(page.locator('#settingsModal')).not.toHaveClass(/visible/);
    overflow = await page.evaluate(() => document.body.style.overflow);
    expect(overflow === '' || overflow === undefined).toBeTruthy();
  });
});
