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
