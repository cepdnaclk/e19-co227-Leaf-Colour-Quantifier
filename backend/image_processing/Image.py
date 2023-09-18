import numpy as np
import cv2
from image_processing.leafSegmentation.segment import segment_leaf
from image_processing.mask_r_cnn.leaf_colour_segmentation import getRCNNSegmentation

class Image:

    def __init__(self, image):
        self.image = image

    def getImage(self):
        return self.image
    
    def getEnhancedImage(self):
        img = self.getNoiceReducedImage(self.image)
    
        return self.getSharpImage(img)
    
    def getSegmentationImage(self):
        return segment_leaf(self.getEnhancedImage(), 1, True, 0)
    
    def getSegmentationImageRCNN(self):
        return getRCNNSegmentation(self.getEnhancedImage())
    
    def getSharpImage(self, img):
        # Create the sharpening kernel
        kernel = np.array([[0, -1, 0], [-1, 5, -1], [0, -1, 0]])
  
        # Sharpen the image
        return cv2.filter2D(img, -1, kernel)
    
    def getNoiceReducedImage(self, img):
        
        return cv2.GaussianBlur(img, (7, 7), 0)

