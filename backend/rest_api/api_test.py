from fastapi.testclient import TestClient
from api import app

client = TestClient(app)

def test_api():
    response = client.get("/api_test")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}