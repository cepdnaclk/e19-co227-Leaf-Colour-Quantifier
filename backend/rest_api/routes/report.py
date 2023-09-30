from fastapi import APIRouter, File, UploadFile,  Depends
from fastapi.responses import StreamingResponse
from rest_api.controllers import reportController
from pydantic import BaseModel

router = APIRouter()

class ReportRequest(BaseModel):
    remaks : str

@router.post("/image", response_class=StreamingResponse)
async def getReport(reportRequest: ReportRequest = Depends(), originalImage: UploadFile = File(...), segmentationImage: UploadFile = File(...)):
    contentsOriginal = await originalImage.read()
    contentsSegmentation = await segmentationImage.read()

    # Return the streaming response.
    return reportController.getImageReport(contentsOriginal, contentsSegmentation, reportRequest.remaks)


# class ReportRequest(BaseModel):
#     originalImage: UploadFile = File(...)
#     segmentationImage: UploadFile = File(...)
#     remaks : str

# @router.post("/image", response_class=StreamingResponse)
# async def getReport(reportRequest: ReportRequest):
#     contentsOriginal = await reportRequest.originalImage.read()
#     contentsSegmentation = await reportRequest.segmentationImage.read()
    
#     # Return the streaming response.
#     return reportController.getImageReport(contentsOriginal, contentsSegmentation, reportRequest.remaks)