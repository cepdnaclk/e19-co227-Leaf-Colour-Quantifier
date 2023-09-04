import numpy as np
import cv2
from image_processing.leafSegmentation.segment import segment_leaf

class Image:

    def __init__(self, image):
        self.image = image

    def getImage(self):
        return self.image
    
    def getGradImage(self):
        newImage = self.image.copy()
        cv2.GaussianBlur(newImage, (3, 3), 0)
        
        #Convert image to grayscale
        gray = cv2.cvtColor(newImage, cv2.COLOR_BGR2GRAY)
        #Apply Sobel method to the grayscale image
        grad_x = cv2.Sobel(gray, cv2.CV_16S, 1, 0, ksize=3, scale=1, 
        delta=0, borderType=cv2.BORDER_DEFAULT) #Horizontal Sobel 

        grad_y = cv2.Sobel(gray, cv2.CV_16S, 0, 1, ksize=3, scale=1, 
        delta=0, borderType=cv2.BORDER_DEFAULT) #Vertical Sobel 

        abs_grad_x = cv2.convertScaleAbs(grad_x)
        abs_grad_y = cv2.convertScaleAbs(grad_y)
        grad = cv2.addWeighted(abs_grad_x, 0.5, abs_grad_y, 0.5, 0)

        return grad
    
    def getSegmentationImage(self):
        return segment_leaf(self.image, 1, True, 0)