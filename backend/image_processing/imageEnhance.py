import numpy as np
import cv2

def getImage(img):
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

    return grad

