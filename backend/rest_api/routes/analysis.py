from fastapi import APIRouter
from fastapi import File, UploadFile
from rest_api.controllers import imageController
from rest_api.models.dominantResponse import DominantResponse, Colour
from fastapi.responses import JSONResponse

router = APIRouter()

@router.post("/dominant", response_model=DominantResponse)
async def getSegmentationImage(file: UploadFile = File(...)):
    contents = await file.read()

    try:
        top_colors, color_spreads, color_percentages = imageController.getImageDominantColours(contents)
        
        dominant = DominantResponse()
        for _ in range(3):
            dominant.dominant.append(Colour())

        for i in range(3):
            dominant.dominant[i].colour = [int(x) for x in top_colors[i]]
            dominant.dominant[i].spread = float(color_spreads[i])
            dominant.dominant[i].precentage = float(color_percentages[i])

        # Return the streaming response.
        return dominant
    
    except Exception as e:
        print(e)
        return JSONResponse(status_code=404, content={"message": "Item not found"})