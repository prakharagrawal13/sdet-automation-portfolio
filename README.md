# SDET Automation Portfolio 🚀

A comprehensive test automation portfolio showcasing **Selenium**, **Playwright**, **API Testing**, and **CI/CD** with **GitHub Actions**.

## 📚 Tech Stack

- **Selenium + Pytest** - UI automation (Python)
- **Playwright** - Cross-browser automation (TypeScript)
- **Requests** - API testing (Python)
- **k6** - Performance testing
- **GitHub Actions** - CI/CD pipeline
- **Allure Reports** - Test reporting

## 📂 Project Structure

```
sdet-automation-portfolio/
├── framework/
│   ├── selenium_pytest/
│   │   ├── pages/              # Page Object Model
│   │   ├── tests/              # Test cases
│   │   ├── utils/              # Helper utilities
│   │   └── conftest.py         # Pytest fixtures
│   └── playwright/
│       ├── tests/              # Playwright tests
│       ├── playwright.config.ts
│       └── package.json
├── api_tests/                  # REST API tests
├── performance/                # k6 performance tests
├── .github/workflows/          # CI/CD pipelines
├── reports/                    # Test reports
├── requirements.txt            # Python dependencies
└── README.md                   # Documentation
```

## 🚀 Quick Start

### Prerequisites
- Python 3.10+
- Node.js 18+
- Git

### Setup (Selenium)

```bash
# Clone the repository
git clone https://github.com/prakharagrawal13/sdet-automation-portfolio.git
cd sdet-automation-portfolio

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run Selenium tests
cd framework/selenium_pytest
pytest tests/ -v
```

### Setup (Playwright)

```bash
cd framework/playwright
npm install
npx playwright install
npx playwright test
```

### Setup (API Tests)

```bash
pytest api_tests/ -v
```

### Setup (Performance Testing)

```bash
# Install k6: https://k6.io/docs/getting-started/installation/
k6 run performance/load_test.js
```

## 📊 Test Coverage

### Selenium Tests
- ✅ User login (success, invalid, locked user)
- ✅ Inventory page interactions
- ✅ Add to cart functionality

### Playwright Tests
- ✅ Cross-browser login tests
- ✅ Inventory management
- ✅ Multi-item cart operations

### API Tests
- ✅ GET all products
- ✅ GET product by ID
- ✅ GET categories
- ✅ POST new product
- ✅ Error handling

## 🔄 CI/CD Pipeline

GitHub Actions automatically runs all tests on:
- Push to `main` or `develop` branch
- Pull requests
- Daily schedule (2 AM UTC)

### Workflow: `.github/workflows/test.yml`
- Selenium tests (Python)
- Playwright tests (Node.js)
- API tests
- Artifact uploads

## 📈 Test Reports

### Generate Allure Reports

```bash
cd framework/selenium_pytest
pytest tests/ --alluredir=../../reports
allure serve ../../reports
```

### Playwright HTML Report

```bash
cd framework/playwright
npx playwright show-report
```

## 🏆 Best Practices Implemented

✅ **Page Object Model** - Maintainable and scalable test structure  
✅ **Fixture-based setup** - Reusable test fixtures  
✅ **Explicit waits** - Reliable element interactions  
✅ **Parallel execution** - Faster test runs  
✅ **CI/CD integration** - Automated test execution  
✅ **Error handling** - Comprehensive assertions  
✅ **Cross-browser testing** - Multiple browser support  

## 📝 Example Test Cases

### Selenium Example

```python
def test_successful_login(driver):
    driver.get("https://www.saucedemo.com")
    login_page = LoginPage(driver)
    login_page.login("standard_user", "secret_sauce")
    assert "inventory" in driver.current_url
```

### Playwright Example

```typescript
test('successful login', async ({ page }) => {
  await page.fill('#user-name', 'standard_user');
  await page.fill('#password', 'secret_sauce');
  await page.click('#login-button');
  await expect(page).toHaveURL(/inventory/);
});
```

### API Example

```python
def test_get_all_products():
    response = requests.get("https://fakestoreapi.com/products")
    assert response.status_code == 200
    assert isinstance(response.json(), list)
```

## 🔧 Troubleshooting

### WebDriver not found
**Solution:** Ensure ChromeDriver is in PATH (automatically handled by webdriver-manager)

### Playwright browsers not installed
**Solution:** Run playwright install
```bash
npx playwright install
```

### Tests timing out
**Solution:** Increase wait times in fixtures or check network connectivity

## 📚 Resources

- [Selenium Documentation](https://www.selenium.dev/documentation/)
- [Playwright Documentation](https://playwright.dev/)
- [Pytest Documentation](https://docs.pytest.org/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 👤 Author

**Prakhar Agrawal**  
[GitHub Profile](https://github.com/prakharagrawal13)

## 📄 License

MIT License - feel free to use this for your portfolio!

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

**Last Updated:** 2026-05-31  
**Status:** Active Development ✅
