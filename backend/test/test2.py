import cv2
import numpy as np
  
# Let's load a simple image with 3 black squares
image = cv2.imread("test\\a1.jpg")

gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# threshold input image using otsu thresholding as mask and refine with morphology
ret, mask = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY+cv2.THRESH_OTSU) 
kernel = np.ones((9,9), np.uint8)
mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, kernel)
mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)

# put mask into alpha channel of result
result = image.copy()
result = cv2.cvtColor(result, cv2.COLOR_BGR2BGRA)


print(gray.shape)
print(mask.shape)

# # save resulting masked image
cv2.imshow('Contours', mask)
cv2.waitKey(0)
cv2.destroyAllWindows()