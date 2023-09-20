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
 
app = FastAPI(title=ProjectSettings.PROJECT_NAME,
              description=ProjectSettings.PROJECT_DESCRIPTION,
              version="1.0.0",
              openapi_url=f"{ProjectSettings.API_VERSION_PATH}openapi.json",
              docs_url=f"{ProjectSettings.API_VERSION_PATH}docs",
              redoc_url=f"{ProjectSettings.API_VERSION_PATH}redoc")

# Middleware Settings
app.add_middleware(
    CORSMiddleware,
    allow_origins=ProjectSettings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# adding routes
app.include_router(image.router, prefix="/image", tags=["image"])
# app.include_router(report.router, prefix="/report", tags=["report"])

# Root API
@app.get(ProjectSettings.API_VERSION_PATH, tags=["api"])
def root() -> JSONResponse:
    return JSONResponse(status_code=200,
                        content={
                            "message": ProjectSettings.PROJECT_NAME})

# testing
@app.get("/api_test", include_in_schema=False, tags=["test"])
async def read_main():
    return {"msg": "test"}

# main function
def api():
    uvicorn.run("rest_api.api:app", host="0.0.0.0", port=5000, reload=True)

if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=5000, reload=True)
