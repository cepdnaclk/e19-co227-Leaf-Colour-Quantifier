import sys
import os
sys.path.insert(0, os.getcwd())

import cv2
from image_processing.Image import Image
import numpy as np
 
# Load the image
image = cv2.imread("test\\a4.jpg")
myImage = Image(image)

def test_image():
    if type(image == myImage.getImage()) == np.ndarray:
        assert (image == myImage.getImage()).all()
    else:
        assert image == myImage.getImage()

if __name__ == "__main__":

    cv2.imshow("Image", myImage.getGradImage())
    # Wait for the user to press a key
    cv2.waitKey(0)

    cv2.imshow("Image", myImage.getSegmentationImage())
    # Wait for the user to press a key
    cv2.waitKey(0)
    
    # Close all windows
    cv2.destroyAllWindows()