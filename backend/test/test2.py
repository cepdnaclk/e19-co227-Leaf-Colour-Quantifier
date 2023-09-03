import cv2
import numpy as np
  
# Let's load a simple image with 3 black squares
image = cv2.imread("test\\a4.jpg")

def crop_image(img):
    
    img=cv2.cvtColor(img, cv2.COLOR_BGR2RGB) 

    img_copy=img.copy()

    lower=np.array([10,10,10])
    higher=np.array([250,250,250])

    mask=cv2.inRange(img, lower, higher)

    contours, hierarchy = cv2.findContours(image= mask,
                                           mode=cv2.RETR_EXTERNAL,
                                           method=cv2.CHAIN_APPROX_NONE)
    
    sorted_contours=sorted(contours, key=cv2.contourArea, reverse= True) 
    print(len(sorted_contours))

    cont_img = cv2.drawContours(image=img, contours=sorted_contours, contourIdx=0, 
                              color=(0,255,0),thickness=3)
    
    c = sorted_contours[0]

    return cont_img


# cv2.imshow('Contours', crop_image(image))
# cv2.waitKey(0)
# cv2.destroyAllWindows()

gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# threshold input image using otsu thresholding as mask and refine with morphology
ret, mask = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY+cv2.THRESH_OTSU) 
kernel = np.ones((9,9), np.uint8)
mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, kernel)
mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)

# put mask into alpha channel of result
result = image.copy()
result = cv2.cvtColor(result, cv2.COLOR_BGR2BGRA)

# masked = cv2.bitwise_and(result, mask)
masked = cv2.bitwise_or(result, result, mask=mask)

print(result.shape)
print(mask.shape)
print(result)

# # save resulting masked image
# cv2.imshow('Contours', masked)
# cv2.waitKey(0)
# cv2.destroyAllWindows()