from fastapi import APIRouter, File, UploadFile
from fastapi.responses import StreamingResponse
from rest_api.controllers import reportController

router = APIRouter()

@router.post("/image", response_class=StreamingResponse)
async def getReport(file: UploadFile = File(...)):
    contents = await file.read()
    
    # Return the streaming response.
    return reportController.getImageReport(contents)
