import sys
import os
sys.path.insert(0, os.getcwd())

# Import the necessary modules
from fastapi.testclient import TestClient
from rest_api import api  # Adjust the import path based on your file structure
from rest_api.config import ProjectSettings

# Create a TestClient instance for making HTTP requests to the API
client = TestClient(api.app)
file_path = "test//test_01.jpg"

# Define a test function for testing the API endpoint
def test_backend():
    # Send a GET request to the "/api_test" endpoint
    response = client.get("/")
    
    # Check if the response status code is 200 (OK)
    assert response.status_code == 200
    
    # Check if the response JSON matches the expected value
    assert response.json() == {"message": ProjectSettings.PROJECT_NAME}

def test_image_segmentation():
    response = client.post("/image/segmentaion", files={"file": ("filename", open(file_path, "rb"), "image/jpeg")})

    # Check if the response status code is 200 (OK)
    assert response.status_code == 200

def test_image_segmentation_mask_rcnn():
    response = client.post("/image/segmentaion/mask-rcnn", files={"file": ("filename", open(file_path, "rb"), "image/jpeg")})

    # Check if the response status code is 200 (OK)
    assert response.status_code == 200

def test_image_dominat_colours():
    response = client.post("/analysis/dominant", files={"file": ("filename", open(file_path, "rb"), "image/jpeg")})

    # Check if the response status code is 200 (OK)
    assert response.status_code == 200


if __name__ == "__main__":
    test_backend()
