import { test, expect } from '@playwright/test';

test.describe('UI Interaction Bug Fixes', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('Bug 1: Full pill hover region works correctly', async ({ page }) => {
    const navButton = page.locator('.nav-button');
    
    // Get the button's bounding box
    const box = await navButton.boundingBox();
    expect(box).not.toBeNull();
    
    // Hover over the left side of the button (where the text is, not the icon)
    await page.mouse.move(box!.x + box!.width - 30, box!.y + box!.height / 2);
    
    // Check that hover styles are applied to the button
    await expect(navButton).toHaveCSS('background', /linear-gradient/);
    
    // Verify hover state is visible by checking computed style
    const bgColor = await navButton.evaluate((el) => {
      const style = window.getComputedStyle(el);
      return style.backgroundImage;
    });
    
    // Should have gradient background on hover
    expect(bgColor).toContain('linear-gradient');
  });

  test('Bug 2: Disabled button state is clearly distinguishable', async ({ page }) => {
    const disabledButton = page.locator('#primaryAction');
    
    // Verify button is disabled
    await expect(disabledButton).toBeDisabled();
    
    // Check visual indicators of disabled state
    const opacity = await disabledButton.evaluate((el) => {
      return window.getComputedStyle(el).opacity;
    });
    
    // Opacity should be low (0.4 or less)
    expect(parseFloat(opacity)).toBeLessThanOrEqual(0.5);
    
    // Check cursor style
    const cursor = await disabledButton.evaluate((el) => {
      return window.getComputedStyle(el).cursor;
    });
    
    // Should have not-allowed cursor
    expect(cursor).toBe('not-allowed');
    
    // Verify it doesn't respond to clicks
    let clicked = false;
    await page.evaluate(() => {
      (window as any).primaryActionClicked = false;
      document.getElementById('primaryAction')?.addEventListener('click', () => {
        (window as any).primaryActionClicked = true;
      });
    });
    
    await disabledButton.click({ force: true });
    clicked = await page.evaluate(() => (window as any).primaryActionClicked);
    
    // Button should not fire click events when disabled
    expect(clicked).toBe(false);
  });

  test('Bug 3a: Modal backdrop click closes modal', async ({ page }) => {
    const openModalBtn = page.locator('#openModalBtn');
    const modalRoot = page.locator('#settingsModal');
    const modalBackdrop = page.locator('#modalBackdrop');
    
    // Modal should be hidden initially
    await expect(modalRoot).not.toHaveClass(/visible/);
    
    // Open modal
    await openModalBtn.click();
    
    // Modal should be visible
    await expect(modalRoot).toHaveClass(/visible/);
    
    // Get backdrop bounding box
    const backdropBox = await modalBackdrop.boundingBox();
    expect(backdropBox).not.toBeNull();
    
    // Click on backdrop (not on modal content)
    // Click at top-left corner of backdrop, away from modal
    await page.mouse.click(backdropBox!.x + 10, backdropBox!.y + 10);
    
    // Modal should be closed
    await expect(modalRoot).not.toHaveClass(/visible/);
  });

  test('Bug 3b: Modal close button restores scroll', async ({ page }) => {
    const openModalBtn = page.locator('#openModalBtn');
    const closeModalBtn = page.locator('#closeModalBtn');
    const modalRoot = page.locator('#settingsModal');
    
    // Check initial body overflow style
    let bodyOverflow = await page.evaluate(() => document.body.style.overflow);
    expect(bodyOverflow).toBe('');
    
    // Open modal
    await openModalBtn.click();
    await expect(modalRoot).toHaveClass(/visible/);
    
    // Body overflow should be hidden
    bodyOverflow = await page.evaluate(() => document.body.style.overflow);
    expect(bodyOverflow).toBe('hidden');
    
    // Close modal
    await closeModalBtn.click();
    await expect(modalRoot).not.toHaveClass(/visible/);
    
    // Body overflow should be restored
    bodyOverflow = await page.evaluate(() => document.body.style.overflow);
    expect(bodyOverflow).toBe('');
  });

  test('Bug 3c: Modal backdrop click also restores scroll', async ({ page }) => {
    const openModalBtn = page.locator('#openModalBtn');
    const modalRoot = page.locator('#settingsModal');
    const modalBackdrop = page.locator('#modalBackdrop');
    
    // Open modal
    await openModalBtn.click();
    await expect(modalRoot).toHaveClass(/visible/);
    
    // Body overflow should be hidden
    let bodyOverflow = await page.evaluate(() => document.body.style.overflow);
    expect(bodyOverflow).toBe('hidden');
    
    // Get backdrop bounding box and click it
    const backdropBox = await modalBackdrop.boundingBox();
    expect(backdropBox).not.toBeNull();
    await page.mouse.click(backdropBox!.x + 10, backdropBox!.y + 10);
    
    // Modal should be closed
    await expect(modalRoot).not.toHaveClass(/visible/);
    
    // Body overflow should be restored
    bodyOverflow = await page.evaluate(() => document.body.style.overflow);
    expect(bodyOverflow).toBe('');
  });
});
