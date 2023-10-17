from fastapi import APIRouter, File, UploadFile,  Depends
from fastapi.responses import StreamingResponse
from rest_api.controllers import reportController
from rest_api.models.reportRequest import ReportRequest

router = APIRouter()

@router.post("/image", response_class=StreamingResponse)
async def getReport(reportRequest: ReportRequest = Depends(), originalImage: UploadFile = File(...), segmentationImage: UploadFile = File(...)):
    contentsOriginal = await originalImage.read()
    contentsSegmentation = await segmentationImage.read()

    # Return the streaming response.
    return reportController.getImageReport(contentsOriginal, contentsSegmentation, reportRequest.remaks)
