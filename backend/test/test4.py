import sys
import os
sys.path.insert(0, os.getcwd())

from image_processing.leafSegmentation.segment import segment_leaf
import cv2
import numpy as np

image = cv2.imread("test\\a4.jpg")

image = segment_leaf(image, 1, True, 0)

cv2.imshow("image", image)
cv2.waitKey(0)
cv2.imwrite("test.jpg", image)