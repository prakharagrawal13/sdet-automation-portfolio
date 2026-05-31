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
