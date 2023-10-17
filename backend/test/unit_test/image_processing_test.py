import sys
import os
sys.path.insert(0, os.getcwd())

# Import necessary modules
import cv2
from image_processing.Image import Image
file_path = "test//test_01.jpg"

# Load the image
image = cv2.imread(file_path)
myImage = Image(image)

# Define the first test function for image loading
def test_image():
    assert myImage.getImage().any()

# Define the second test function for segmentation
def test_segmentation_image():
    assert myImage.getSegmentationImage().any()

# Define the third test function for RCNN-based segmentation
def test_segmentation_image_rcnn():
    assert myImage.getSegmentationImageRCNN().any()

if __name__ == "__main__":
    # Display the enhanced image
    cv2.imshow("Enhanced Image", myImage.getEnhancedImage())
    
    # Wait for the user to press a key and then close the window
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    # Display the segmented image
    cv2.imshow("Segmented Image", myImage.getSegmentationImage())
    
    # Wait for the user to press a key and then close the window
    cv2.waitKey(0)
    cv2.destroyAllWindows()
