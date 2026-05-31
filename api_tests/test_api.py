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
