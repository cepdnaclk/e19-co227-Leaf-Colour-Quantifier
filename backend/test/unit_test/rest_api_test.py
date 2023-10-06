import sys
import os
sys.path.insert(0, os.getcwd())

# Import the necessary modules
from fastapi.testclient import TestClient
from rest_api import api  # Adjust the import path based on your file structure

# Create a TestClient instance for making HTTP requests to the API
client = TestClient(api.app)

# Define a test function for testing the API endpoint
def test_api():
    # Send a GET request to the "/api_test" endpoint
    response = client.get("/api_test")
    
    # Check if the response status code is 200 (OK)
    assert response.status_code == 200
    
    # Check if the response JSON matches the expected value
    assert response.json() == {"msg": "test"}

if __name__ == "__main__":
    # Run the defined test function
    test_api()
