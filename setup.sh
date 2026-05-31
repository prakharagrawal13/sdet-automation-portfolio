#!/bin/bash

# SDET Automation Portfolio - Complete Setup Script
# This script creates the entire project structure and all files

echo "🚀 Starting SDET Automation Portfolio Setup..."

# Create directory structure
echo "📁 Creating directory structure..."

mkdir -p framework/selenium_pytest/{tests,pages,utils}
mkdir -p framework/playwright/{tests,configs}
mkdir -p api_tests
mkdir -p performance
mkdir -p .github/workflows
mkdir -p reports
mkdir -p docs

echo "✅ Directories created"

# ============================================
# SELENIUM FRAMEWORK - PYTHON FILES
# ============================================

echo "📝 Creating Selenium framework files..."

# Driver Factory
cat > framework/selenium_pytest/utils/driver_factory.py << 'EOF'
from selenium import webdriver
from selenium.webdriver.chrome.service import Service

def get_driver():
    """Initialize and return Chrome WebDriver with optimized options."""
    options = webdriver.ChromeOptions()
    options.add_argument("--start-maximized")
    options.add_argument("--disable-blink-features=AutomationControlled")
    options.add_experimental_option("excludeSwitches", ["enable-automation"])
    options.add_experimental_option('useAutomationExtension', False)
    
    driver = webdriver.Chrome(options=options)
    return driver
EOF

# Conftest
cat > framework/selenium_pytest/conftest.py << 'EOF'
import pytest
import sys
import os
sys.path.insert(0, os.path.abspath('.'))

from utils.driver_factory import get_driver

@pytest.fixture
def driver():
    """Fixture to provide WebDriver instance for tests."""
    driver = get_driver()
    yield driver
    driver.quit()
EOF

# Login Page Object
cat > framework/selenium_pytest/pages/login_page.py << 'EOF'
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class LoginPage:
    """Page Object for SauceDemo Login Page."""
    
    # Locators
    USERNAME_INPUT = (By.ID, "user-name")
    PASSWORD_INPUT = (By.ID, "password")
    LOGIN_BUTTON = (By.ID, "login-button")
    ERROR_MESSAGE = (By.CLASS_NAME, "error-message-container")
    
    def __init__(self, driver):
        self.driver = driver
        self.wait = WebDriverWait(driver, 10)
    
    def enter_username(self, username):
        """Enter username in the username field."""
        self.driver.find_element(*self.USERNAME_INPUT).send_keys(username)
    
    def enter_password(self, password):
        """Enter password in the password field."""
        self.driver.find_element(*self.PASSWORD_INPUT).send_keys(password)
    
    def click_login(self):
        """Click the login button."""
        self.driver.find_element(*self.LOGIN_BUTTON).click()
    
    def login(self, username, password):
        """Perform complete login action."""
        self.enter_username(username)
        self.enter_password(password)
        self.click_login()
    
    def get_error_message(self):
        """Retrieve error message if login fails."""
        try:
            return self.driver.find_element(*self.ERROR_MESSAGE).text
        except:
            return None
EOF

# Inventory Page Object
cat > framework/selenium_pytest/pages/inventory_page.py << 'EOF'
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class InventoryPage:
    """Page Object for SauceDemo Inventory Page."""
    
    # Locators
    PRODUCT_TITLE = (By.CLASS_NAME, "title")
    ADD_TO_CART_BUTTON = (By.CLASS_NAME, "btn_primary")
    CART_BADGE = (By.CLASS_NAME, "shopping_cart_badge")
    CART_LINK = (By.CLASS_NAME, "shopping_cart_link")
    
    def __init__(self, driver):
        self.driver = driver
        self.wait = WebDriverWait(driver, 10)
    
    def is_page_loaded(self):
        """Check if inventory page is loaded."""
        try:
            self.wait.until(EC.presence_of_element_located(self.PRODUCT_TITLE))
            return True
        except:
            return False
    
    def add_item_to_cart(self, item_index=0):
        """Add item to cart by index."""
        buttons = self.driver.find_elements(*self.ADD_TO_CART_BUTTON)
        if item_index < len(buttons):
            buttons[item_index].click()
    
    def get_cart_count(self):
        """Get number of items in cart."""
        try:
            return int(self.driver.find_element(*self.CART_BADGE).text)
        except:
            return 0
    
    def click_cart(self):
        """Click on shopping cart."""
        self.driver.find_element(*self.CART_LINK).click()
EOF

# Login Tests
cat > framework/selenium_pytest/tests/test_login.py << 'EOF'
import pytest
import sys
import os
sys.path.insert(0, os.path.abspath('..'))

from pages.login_page import LoginPage

class TestLogin:
    """Test cases for SauceDemo login functionality."""
    
    BASE_URL = "https://www.saucedemo.com"
    
    def test_successful_login(self, driver):
        """Test successful login with valid credentials."""
        driver.get(self.BASE_URL)
        
        login_page = LoginPage(driver)
        login_page.login("standard_user", "secret_sauce")
        
        assert "inventory" in driver.current_url
        assert "Swag Labs" in driver.title
    
    def test_login_with_locked_user(self, driver):
        """Test login with locked user account."""
        driver.get(self.BASE_URL)
        
        login_page = LoginPage(driver)
        login_page.login("locked_out_user", "secret_sauce")
        
        error_msg = login_page.get_error_message()
        assert error_msg is not None
        assert "locked out" in error_msg.lower()
    
    def test_login_with_invalid_credentials(self, driver):
        """Test login with invalid credentials."""
        driver.get(self.BASE_URL)
        
        login_page = LoginPage(driver)
        login_page.login("invalid_user", "wrong_password")
        
        error_msg = login_page.get_error_message()
        assert error_msg is not None
    
    def test_empty_username(self, driver):
        """Test login with empty username."""
        driver.get(self.BASE_URL)
        
        login_page = LoginPage(driver)
        login_page.enter_password("secret_sauce")
        login_page.click_login()
        
        error_msg = login_page.get_error_message()
        assert error_msg is not None
EOF

# Inventory Tests
cat > framework/selenium_pytest/tests/test_inventory.py << 'EOF'
import pytest
import sys
import os
sys.path.insert(0, os.path.abspath('..'))

from pages.login_page import LoginPage
from pages.inventory_page import InventoryPage

class TestInventory:
    """Test cases for SauceDemo inventory functionality."""
    
    BASE_URL = "https://www.saucedemo.com"
    
    @pytest.fixture(autouse=True)
    def login_user(self, driver):
        """Login before each test."""
        driver.get(self.BASE_URL)
        login_page = LoginPage(driver)
        login_page.login("standard_user", "secret_sauce")
    
    def test_inventory_page_loaded(self, driver):
        """Test that inventory page loads successfully."""
        inventory_page = InventoryPage(driver)
        assert inventory_page.is_page_loaded()
    
    def test_add_item_to_cart(self, driver):
        """Test adding item to cart."""
        inventory_page = InventoryPage(driver)
        inventory_page.add_item_to_cart(0)
        
        assert inventory_page.get_cart_count() == 1
    
    def test_add_multiple_items_to_cart(self, driver):
        """Test adding multiple items to cart."""
        inventory_page = InventoryPage(driver)
        inventory_page.add_item_to_cart(0)
        inventory_page.add_item_to_cart(1)
        inventory_page.add_item_to_cart(2)
        
        assert inventory_page.get_cart_count() == 3
EOF

echo "✅ Selenium framework files created"

# ============================================
# PLAYWRIGHT FRAMEWORK - TYPESCRIPT FILES
# ============================================

echo "📝 Creating Playwright framework files..."

# Playwright Tests
cat > framework/playwright/tests/test_login.spec.ts << 'EOF'
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
EOF

# Playwright Config
cat > framework/playwright/playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'https://www.saucedemo.com',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
});
EOF

# Package.json
cat > framework/playwright/package.json << 'EOF'
{
  "name": "playwright-automation",
  "version": "1.0.0",
  "description": "Playwright automation tests for SDET portfolio",
  "scripts": {
    "test": "playwright test",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug",
    "test:report": "playwright show-report"
  },
  "devDependencies": {
    "@playwright/test": "^1.40.0"
  }
}
EOF

echo "✅ Playwright framework files created"

# ============================================
# API TESTS
# ============================================

echo "📝 Creating API tests..."

cat > api_tests/test_api.py << 'EOF'
import requests
import pytest

class TestAPI:
    """Test cases for REST API testing."""
    
    BASE_URL = "https://fakestoreapi.com"
    
    def test_get_all_products(self):
        """Test retrieving all products."""
        response = requests.get(f"{self.BASE_URL}/products")
        
        assert response.status_code == 200
        assert isinstance(response.json(), list)
        assert len(response.json()) > 0
    
    def test_get_product_by_id(self):
        """Test retrieving a specific product by ID."""
        response = requests.get(f"{self.BASE_URL}/products/1")
        
        assert response.status_code == 200
        assert response.json()["id"] == 1
        assert "title" in response.json()
        assert "price" in response.json()
    
    def test_get_all_categories(self):
        """Test retrieving all product categories."""
        response = requests.get(f"{self.BASE_URL}/products/categories")
        
        assert response.status_code == 200
        assert isinstance(response.json(), list)
    
    def test_get_users(self):
        """Test retrieving all users."""
        response = requests.get(f"{self.BASE_URL}/users")
        
        assert response.status_code == 200
        assert isinstance(response.json(), list)
    
    def test_create_product(self):
        """Test creating a new product via POST."""
        payload = {
            "title": "Test Product",
            "price": 99.99,
            "description": "Test Description",
            "image": "https://example.com/image.jpg",
            "category": "electronics"
        }
        
        response = requests.post(f"{self.BASE_URL}/products", json=payload)
        
        assert response.status_code == 200
        assert response.json()["title"] == "Test Product"
    
    def test_invalid_endpoint(self):
        """Test handling of invalid endpoint."""
        response = requests.get(f"{self.BASE_URL}/invalid")
        
        assert response.status_code == 404
EOF

echo "✅ API tests created"

# ============================================
# PERFORMANCE TESTS
# ============================================

echo "📝 Creating performance tests..."

cat > performance/load_test.js << 'EOF'
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 10,
  duration: '30s',
  thresholds: {
    http_req_duration: ['p(95)<500', 'p(99)<1000'],
    http_req_failed: ['rate<0.1'],
  },
};

export default function () {
  // Test fake store API
  const res = http.get('https://fakestoreapi.com/products');
  
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
  
  sleep(1);
}
EOF

echo "✅ Performance tests created"

# ============================================
# CI/CD WORKFLOW
# ============================================

echo "📝 Creating CI/CD workflow..."

cat > .github/workflows/test.yml << 'EOF'
name: Automation Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  schedule:
    - cron: '0 2 * * *'

jobs:
  selenium-tests:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        python-version: ['3.10']
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    
    - name: Run Selenium tests
      run: |
        cd framework/selenium_pytest
        pytest tests/ -v --tb=short --html=report.html --self-contained-html
    
    - name: Upload Selenium Report
      if: always()
      uses: actions/upload-artifact@v3
      with:
        name: selenium-report
        path: framework/selenium_pytest/report.html

  playwright-tests:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    
    - name: Install dependencies
      run: |
        cd framework/playwright
        npm install
        npx playwright install
    
    - name: Run Playwright tests
      run: |
        cd framework/playwright
        npx playwright test
    
    - name: Upload Playwright Report
      if: always()
      uses: actions/upload-artifact@v3
      with:
        name: playwright-report
        path: framework/playwright/playwright-report/

  api-tests:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.10'
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    
    - name: Run API tests
      run: |
        pytest api_tests/ -v --tb=short
EOF

echo "✅ CI/CD workflow created"

# ============================================
# CONFIGURATION FILES
# ============================================

echo "📝 Creating configuration files..."

cat > requirements.txt << 'EOF'
pytest==7.4.3
selenium==4.14.0
requests==2.31.0
allure-pytest==2.13.2
pytest-xdist==3.5.0
pytest-rerunfailures==12.0
pytest-html==4.1.1
python-dotenv==1.0.0
webdriver-manager==4.0.1
EOF

cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
venv/
ENV/
env/
.venv

# Node
node_modules/
npm-debug.log
yarn-error.log
.npm
.eslintcache

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Test & Reports
.pytest_cache/
.coverage
htmlcov/
reports/
*.html
playwright-report/
test-results/

# Environment
.env
.env.local
.env.*.local

# K6
test-output.txt
EOF

echo "✅ Configuration files created"

# ============================================
# DOCUMENTATION
# ============================================

echo "📝 Creating documentation..."

cat > docs/SETUP.md << 'EOF'
# SDET Portfolio Setup Guide

## Step 1: Clone Repository

```bash
git clone https://github.com/prakharagrawal13/sdet-automation-portfolio.git
cd sdet-automation-portfolio
```

## Step 2: Python Environment Setup (Selenium)

### Create Virtual Environment

```bash
python -m venv venv
```

### Activate Virtual Environment

**Windows:**
```bash
venv\Scripts\activate
```

**Mac/Linux:**
```bash
source venv/bin/activate
```

### Install Dependencies

```bash
pip install -r requirements.txt
```

## Step 3: Run Selenium Tests

```bash
cd framework/selenium_pytest
pytest tests/ -v
```

### Run Specific Test

```bash
pytest tests/test_login.py::TestLogin::test_successful_login -v
```

### Run with HTML Report

```bash
pytest tests/ -v --html=report.html --self-contained-html
```

## Step 4: Node.js Environment Setup (Playwright)

### Install Node Dependencies

```bash
cd framework/playwright
npm install
```

### Install Playwright Browsers

```bash
npx playwright install
```

## Step 5: Run Playwright Tests

```bash
npx playwright test
```

### Run in Headed Mode (see browser)

```bash
npm run test:headed
```

### Debug Mode

```bash
npm run test:debug
```

### View Report

```bash
npm run test:report
```

## Step 6: Run API Tests

```bash
pytest api_tests/ -v
```

## Step 7: Performance Testing (k6)

### Install k6

**Windows (using Chocolatey):**
```bash
choco install k6
```

**Mac (using Homebrew):**
```bash
brew install k6
```

**Linux:**
```bash
sudo apt-get install k6
```

### Run Performance Tests

```bash
k6 run performance/load_test.js
```

## Troubleshooting

### ChromeDriver Issues

If you encounter ChromeDriver errors, the setup uses webdriver-manager automatically.

### Playwright Browser Installation

If browsers fail to install:

```bash
npx playwright install --with-deps
```

### Port Already in Use

If Allure server fails to start:

```bash
allure serve reports/ --port 8080
```

## Next Steps

1. Explore test files in `framework/selenium_pytest/tests/`
2. Review Page Objects in `framework/selenium_pytest/pages/`
3. Check CI/CD workflow in `.github/workflows/test.yml`
4. Add your own test cases
5. Push to GitHub and watch CI/CD in action!

---

For more details, see [README.md](../README.md)
EOF

cat > README.md << 'EOF'
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
EOF

echo "✅ Documentation created"

# ============================================
# FINAL STEPS
# ============================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ SDET AUTOMATION PORTFOLIO SETUP COMPLETE! 🎉"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📂 Directory structure:"
find . -type d -not -path '*/\.*' | head -20
echo ""
echo "📄 Key files created:"
echo "  ✅ framework/selenium_pytest/pages/login_page.py"
echo "  ✅ framework/selenium_pytest/pages/inventory_page.py"
echo "  ✅ framework/selenium_pytest/tests/test_login.py"
echo "  ✅ framework/selenium_pytest/tests/test_inventory.py"
echo "  ✅ framework/playwright/tests/test_login.spec.ts"
echo "  ✅ api_tests/test_api.py"
echo "  ✅ performance/load_test.js"
echo "  ✅ .github/workflows/test.yml"
echo "  ✅ requirements.txt"
echo "  ✅ README.md"
echo ""
echo "🚀 NEXT STEPS:"
echo ""
echo "1️⃣  Create Python Virtual Environment:"
echo "   python -m venv venv"
echo ""
echo "2️⃣  Activate Virtual Environment:"
echo "   source venv/bin/activate  (Mac/Linux)"
echo "   venv\\Scripts\\activate     (Windows)"
echo ""
echo "3️⃣  Install Python Dependencies:"
echo "   pip install -r requirements.txt"
echo ""
echo "4️⃣  Run Selenium Tests:"
echo "   cd framework/selenium_pytest"
echo "   pytest tests/ -v"
echo ""
echo "5️⃣  Setup Playwright:"
echo "   cd ../playwright"
echo "   npm install"
echo "   npx playwright install"
echo "   npx playwright test"
echo ""
echo "6️⃣  Push to GitHub:"
echo "   git add ."
echo "   git commit -m 'Initial SDET framework setup'"
echo "   git push -u origin main"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📚 For detailed setup instructions, see: docs/SETUP.md"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
EOF

chmod +x setup.sh

echo "✅ Setup script created successfully!"
echo ""
echo "🎯 Now run this command:"
echo ""
echo "   bash setup.sh"
echo ""
echo "This will create all files and directories instantly! 🚀"
