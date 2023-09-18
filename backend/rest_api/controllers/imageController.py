import numpy as np
import cv2
from fastapi.responses import StreamingResponse
from image_processing.Image import Image
from rest_api.util.utils import *
from fastapi.responses import JSONResponse

def getImageToEnhance(contents):
    
    try:
        nparr = np.fromstring(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        image = Image(img)
        enhancedImg = image.getEnhancedImage()

        _, encoded_img = cv2.imencode('.PNG', enhancedImg)

        # Create a streaming response.
        def image_generator():
            yield encoded_img.tobytes()

        # Create a StreamingResponse with the generator function and appropriate media type
        return StreamingResponse(image_generator(), media_type="image/jpeg")
    
    except Exception as e:
        print(e)
        return JSONResponse(status_code=404, content={"message": "Item not found"})
    

def getImageToSegementation(contents):
    
    try:
        nparr = np.fromstring(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        image = Image(img)
        enhancedImg = image.getSegmentationImage()

        _, encoded_img = cv2.imencode('.PNG', enhancedImg)

        # Create a streaming response.
        def image_generator():
            yield encoded_img.tobytes()

        # Create a StreamingResponse with the generator function and appropriate media type
        return StreamingResponse(image_generator(), media_type="image/jpeg")
    
    except Exception as e:
        print(e)
        return JSONResponse(status_code=404, content={"message": "Item not found"})
    
def getImageToSegementationWithMask(image, mask):
    
    try:
        nparr = np.fromstring(image, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        nparr = np.fromstring(mask, np.uint8)
        mask = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        image = Image(img)
        enhancedImg = image.getSegmentationImage()

        _, encoded_img = cv2.imencode('.PNG', enhancedImg)

        # Create a streaming response.
        def image_generator():
            yield encoded_img.tobytes()

        # Create a StreamingResponse with the generator function and appropriate media type
        return StreamingResponse(image_generator(), media_type="image/jpeg")
    
    except Exception as e:
        print(e)
        return JSONResponse(status_code=404, content={"message": "Item not found"})
    

def getImageToNpArray(contents):
    
    try:
        nparr = np.fromstring(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        image = Image(img)
        enhancedImg = image.getSegmentationImage()

        # Create a StreamingResponse with the generator function and appropriate media type
        return {"img":enhancedImg.tolist()}
    
    except Exception as e:
        print(e)
        return JSONResponse(status_code=404, content={"message": "Item not found"})
    

def getImageToRGB(contents):
    
    try:
        nparr = np.fromstring(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        image = Image(img)
        enhancedImg = image.getSegmentationImage()

        rgbData = imageToRGB(enhancedImg)

        # Create a StreamingResponse with the generator function and appropriate media type
        return {"r":rgbData[0], "g":rgbData[1], "b":rgbData[2]}
    
    except Exception as e:
        print(e)
        return JSONResponse(status_code=404, content={"message": "Item not found"})