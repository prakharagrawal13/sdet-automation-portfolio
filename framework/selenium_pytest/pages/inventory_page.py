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
