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
