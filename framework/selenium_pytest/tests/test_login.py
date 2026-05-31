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
