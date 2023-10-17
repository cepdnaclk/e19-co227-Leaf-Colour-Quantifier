# Import necessary modules
import sys
import os
sys.path.insert(0, os.getcwd())

from fastapi import FastAPI
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from rest_api.config import ProjectSettings
from rest_api.routes import image
from rest_api.routes import report
from rest_api.routes import analysis

# Create a FastAPI instance with project metadata
app = FastAPI(
    title=ProjectSettings.PROJECT_NAME,
    description=ProjectSettings.PROJECT_DESCRIPTION,
    version="1.0.0",
    openapi_url=f"{ProjectSettings.API_VERSION_PATH}openapi.json",
    docs_url=f"{ProjectSettings.API_VERSION_PATH}docs",
    redoc_url=f"{ProjectSettings.API_VERSION_PATH}redoc"
)

# Middleware Settings - Configure CORS (Cross-Origin Resource Sharing)
app.add_middleware(
    CORSMiddleware,
    allow_origins=ProjectSettings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Adding routes from different modules
app.include_router(image.router, prefix="/image", tags=["image"])
app.include_router(report.router, prefix="/report", tags=["report"])
app.include_router(analysis.router, prefix="/analysis", tags=["analysis"])

# Root API endpoint
@app.get(ProjectSettings.API_VERSION_PATH, tags=["api"])
def root() -> JSONResponse:
    return JSONResponse(status_code=200, content={"message": ProjectSettings.PROJECT_NAME})

# Testing endpoint (include_in_schema=False to exclude from OpenAPI documentation)
@app.get("/api_test", include_in_schema=False, tags=["test"])
async def read_main():
    return {"msg": "test"}

# Main function to run the FastAPI application using uvicorn
def api():
    uvicorn.run("rest_api.api:app", host="0.0.0.0", port=5000, reload=True)

# Check if this script is being run as the main program and start the FastAPI application
if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=5000, reload=True)
