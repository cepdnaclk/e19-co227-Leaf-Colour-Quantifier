import numpy as np
import cv2
from fastapi.responses import StreamingResponse
from image_processing import imageEnhance

def getImageToEnhance(contents):
    
    nparr = np.fromstring(contents, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    enhancedImg = imageEnhance.getImage(img)

    # line that fixed it
    _, encoded_img = cv2.imencode('.PNG', enhancedImg)

    # Create a streaming response.
    def image_generator():
        yield encoded_img.tobytes()

    # Create a StreamingResponse with the generator function and appropriate media type
    # return StreamingResponse(image_generator(), media_type="image/jpeg")
    response = StreamingResponse(image_generator(), media_type="image/png")

    # Return the streaming response.
    return response