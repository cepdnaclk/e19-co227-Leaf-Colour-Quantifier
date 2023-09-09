from fastapi import APIRouter
from fastapi import File, UploadFile
from fastapi.responses import StreamingResponse
from rest_api.controllers import imageController

router = APIRouter()

@router.post("/grad", response_class=StreamingResponse)
async def getEnhacedImage(file: UploadFile = File(...)):
    contents = await file.read()

    # Return the streaming response.
    return imageController.getImageToEnhance(contents)

@router.post("/segmentaion", response_class=StreamingResponse)
async def getSegmentationImage(file: UploadFile = File(...)):
    contents = await file.read()

    # Return the streaming response.
    return imageController.getImageToSegementation(contents)

# @router.post("/segmentaion/nparray")
# async def getSegmentationImage(file: UploadFile = File(...)):
#     contents = await file.read()

#     # Return the streaming response.
#     return imageController.getImageToNpArray(contents)

# @router.post("/segmentaion/rgb")
# async def getSegmentationImage(file: UploadFile = File(...)):
#     contents = await file.read()

#     # Return the streaming response.
#     return imageController.getImageToRGB(contents)