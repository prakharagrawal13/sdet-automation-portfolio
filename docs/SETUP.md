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
