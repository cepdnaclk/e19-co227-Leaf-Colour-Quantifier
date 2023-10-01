import cv2 as cv
import numpy as np


def resize(image, p=0.3):
    w = int(image.shape[1] * p)
    h = int(image.shape[0] * p)
    return cv.resize(image, (w, h))


image = cv.imread('test\\a1.jpg')
cv.GaussianBlur(image, (3, 3), 0)
gray = cv.cvtColor(image, cv.COLOR_BGR2GRAY)

# apply sobel method to the grayscale image
grad_x = cv.Sobel(gray, cv.CV_64F, 1, 0, ksize=3, scale=1,
                  delta=0, borderType=cv.BORDER_DEFAULT)

grad_y = cv.Sobel(gray, cv.CV_64F, 0, 1, ksize=3, scale=1,
                  delta=0, borderType=cv.BORDER_DEFAULT)

abs_grad_x = cv.convertScaleAbs(grad_x)
abs_grad_y = cv.convertScaleAbs(grad_y)

grad = cv.addWeighted(abs_grad_x, 0.5, abs_grad_y, 0.5, 0)

cv.imshow('sobel', resize(grad))
cv.waitKey(0)

# # Apply thresholding to create a binary mask
# _, threshold = cv.threshold(
#     grad, 0, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)


# # Find contours in the thresholded image
# contours, _ = cv.findContours(
#     threshold, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)


# # Find the contour with the maximum area, which corresponds to the leaf
# leaf_contour = max(contours, key=cv.contourArea)


# # Create a mask of the same size as the grayscale image
# mask = np.zeros_like(grad)

# # Draw the leaf contour on the mask
# cv.drawContours(mask, [leaf_contour], 0, 255, -1)

# cv.imshow('contunors', resize(mask))
# cv.waitKey(0)
# cv.imshow('leaf_contunor', resize(leaf_contour))

# leaf = cv.bitwise_and(image, image, mask=mask)

# cv.imshow("grad", resize(leaf))
# cv.waitKey(0)
