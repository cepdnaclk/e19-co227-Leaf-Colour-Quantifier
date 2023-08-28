from typing import Union
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import StreamingResponse
import uvicorn
import numpy as np
import cv2
 
app = FastAPI()

@app.post("/")
async def predict_api(file: UploadFile = File(...)):
    contents = await file.read()

    nparr = np.fromstring(contents, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    cv2.GaussianBlur(img, (3, 3), 0)
    #Convert image to grayscale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    #Apply Sobel method to the grayscale image
    grad_x = cv2.Sobel(gray, cv2.CV_16S, 1, 0, ksize=3, scale=1, 
    delta=0, borderType=cv2.BORDER_DEFAULT) #Horizontal Sobel 

    grad_y = cv2.Sobel(gray, cv2.CV_16S, 0, 1, ksize=3, scale=1, 
    delta=0, borderType=cv2.BORDER_DEFAULT) #Vertical Sobel 

    abs_grad_x = cv2.convertScaleAbs(grad_x)
    abs_grad_y = cv2.convertScaleAbs(grad_y)
    grad = cv2.addWeighted(abs_grad_x, 0.5, abs_grad_y, 0.5, 0)

    # line that fixed it
    _, encoded_img = cv2.imencode('.PNG', grad)

    # Create a streaming response.
    def image_generator():
        yield encoded_img.tobytes()

    # Create a StreamingResponse with the generator function and appropriate media type
    # return StreamingResponse(image_generator(), media_type="image/jpeg")
    response = StreamingResponse(image_generator(), media_type="image/png")

    # Return the streaming response.
    return response


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=5000)