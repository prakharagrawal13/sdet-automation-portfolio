import { test, expect } from '@playwright/test';

test.describe('SauceDemo Login Tests', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('https://www.saucedemo.com');
  });

  test('successful login', async ({ page }) => {
    await page.fill('#user-name', 'standard_user');
    await page.fill('#password', 'secret_sauce');
    await page.click('#login-button');

    await expect(page).toHaveURL(/inventory/);
  });

  test('login with invalid credentials', async ({ page }) => {
    await page.fill('#user-name', 'invalid_user');
    await page.fill('#password', 'wrong_password');
    await page.click('#login-button');

    const errorMessage = page.locator('.error-message-container');
    await expect(errorMessage).toBeVisible();
  });

  test('locked out user', async ({ page }) => {
    await page.fill('#user-name', 'locked_out_user');
    await page.fill('#password', 'secret_sauce');
    await page.click('#login-button');

    const errorMessage = page.locator('.error-message-container');
    const text = await errorMessage.textContent();
    expect(text).toContain('locked out');
  });
});

test.describe('Inventory Tests', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('https://www.saucedemo.com');
    await page.fill('#user-name', 'standard_user');
    await page.fill('#password', 'secret_sauce');
    await page.click('#login-button');
    await page.waitForURL(/inventory/);
  });

  test('add item to cart', async ({ page }) => {
    const addButton = page.locator('button.btn_primary').first();
    await addButton.click();

    const cartBadge = page.locator('.shopping_cart_badge');
    await expect(cartBadge).toContainText('1');
  });

  test('add multiple items', async ({ page }) => {
    const buttons = page.locator('button.btn_primary');
    await buttons.nth(0).click();
    await buttons.nth(1).click();
    await buttons.nth(2).click();

    const cartBadge = page.locator('.shopping_cart_badge');
    await expect(cartBadge).toContainText('3');
  });
});
