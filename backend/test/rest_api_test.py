import sys
import os
sys.path.insert(0, os.getcwd())

from fastapi.testclient import TestClient
from rest_api import api  # Adjust the import path based on your file structure

client = TestClient(api.app)

def test_api():
    response = client.get("/api_test")
    assert response.status_code == 200
    assert response.json() == {"msg": "test"}
