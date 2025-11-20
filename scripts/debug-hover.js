const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto('http://localhost:3000');

  const profileButton = await page.$('#profileButton');
  if (!profileButton) {
    console.error('profileButton not found');
    await browser.close();
    process.exit(2);
  }
  const beforeBg = await page.evaluate((el) => getComputedStyle(el).backgroundImage, profileButton);
  const box = await profileButton.boundingBox();
  console.log('box', box);
  console.log('beforeBg:', beforeBg);

  await profileButton.hover();
  await page.waitForTimeout(200);
  const afterBg = await page.evaluate((el) => getComputedStyle(el).backgroundImage, profileButton);
  console.log('afterBg:', afterBg);

  await browser.close();
})();
