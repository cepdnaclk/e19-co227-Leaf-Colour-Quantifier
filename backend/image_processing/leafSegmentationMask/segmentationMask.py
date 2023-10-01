import numpy as np
import cv2

def createCompositeMask(photo, paint):
    # Convert the paint image to grayscale
    paint_gray = cv2.cvtColor(paint, cv2.COLOR_BGR2GRAY)

    # Apply a threshold to create a binary paint mask
    _, paint_mask = cv2.threshold(paint_gray, 127, 255, cv2.THRESH_BINARY)

    # Obtain the leaf mask from the photo image
    leaf_mask = extractLeafMask(photo)

    # Create a composite mask by performing bitwise AND operation between the paint mask and leaf mask
    composite_mask = cv2.bitwise_and(paint_mask, leaf_mask)

    return composite_mask


def extractLeafMask(image):
    # Convert the image to grayscale
    cv2.GaussianBlur(image, (3, 3), 0)

    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Apply thresholding to create a binary mask
    _, threshold = cv2.threshold(
        gray, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)

    # Find contours in the thresholded image
    contours, _ = cv2.findContours(
        threshold, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Find the contour with the maximum area, which corresponds to the leaf
    leaf_contour = max(contours, key=cv2.contourArea)

    # Create a mask of the same size as the grayscale image
    mask = np.zeros_like(gray)

    # Draw the leaf contour on the mask
    cv2.drawContours(mask, [leaf_contour], 0, 255, -1)

    return mask

def filterColour(img, mask):

    # It converts the BGR color space of image to HSV color space
    hsv = cv2.cvtColor(mask, cv2.COLOR_BGR2HSV)
      
    # Threshold of blue in HSV space
    lower_blue = np.array([0, 0, 0])
    upper_blue = np.array([66, 164, 245])
    # lower_blue = np.array([66, 164, 245])
    # upper_blue = np.array([255, 255, 255])
  
    # preparing the mask to overlay
    mask = cv2.inRange(mask, lower_blue, upper_blue)
      
    # The black region in the mask has the value of 0,
    # so when multiplied with original image removes all non-blue regions
    result = cv2.bitwise_and(img, img, mask = mask)

    return result

def getLeafUsingMark(img, mask):
    mask = cv2.resize(mask, (img.shape[1], img.shape[0]), interpolation=cv2.INTER_AREA)

    m = mask - img
    
    composite_mask = createCompositeMask(img, mask)
    leaf = cv2.bitwise_and(img, img, mask=composite_mask)

    return leaf