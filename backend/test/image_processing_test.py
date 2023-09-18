import sys
import os
sys.path.insert(0, os.getcwd())

import cv2
from image_processing.Image import Image
 
# Load the image
image = cv2.imread("test//a4.jpg")
myImage = Image(image)

def test_image():
    print(image)
    assert myImage.getImage().any()

if __name__ == "__main__":

    cv2.imshow("Image", myImage.getEnhancedImage())
    # Wait for the user to press a key
    cv2.waitKey(0)

    cv2.imshow("Image", myImage.getSegmentationImage())
    # Wait for the user to press a key
    cv2.waitKey(0)
    
    # Close all windows
    cv2.destroyAllWindows()