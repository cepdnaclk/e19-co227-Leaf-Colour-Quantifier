import cv2
import numpy as np
  
# Let's load a simple image with 3 black squares
image = cv2.imread("test\\a4.jpg")
image = cv2.resize(image, (400, 400))
print(image)
  
# Grayscale
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
blurred = cv2.GaussianBlur(src=gray, ksize=(3, 5), sigmaX=0.8)
  
# Find Canny edges
edged = cv2.Canny(blurred, 30, 200)
  
# Finding Contours
# Use a copy of the image e.g. edged.copy()
# since findContours alters the image
contours, hierarchy = cv2.findContours(edged, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
  
# cv2.imshow('Canny Edges After Contouring', edged)
# cv2.waitKey(0)
# print("Number of Contours found = " + str(len(contours)))
  

sorted_contours=sorted(contours, key=cv2.contourArea, reverse= True) 

cv2.drawContours(image, sorted_contours[0], -1, (0, 255, 0), 3)
  
cv2.imshow('Contours', image)
cv2.waitKey(0)
cv2.destroyAllWindows()



def crop_image(image_file):

    img=cv2.imread(image_file)
    img=cv2.cvtColor(img, cv2.COLOR_BGR2RGB) 

    img_copy=img.copy()

    lower=np.array([10,10,10])
    higher=np.array([250,250,250])
    mask=cv2.inRange(img, lower, higher)

    contours, hierarchy = cv2.findContours(image= mask,
                                           mode=cv2.RETR_EXTERNAL,
                                           method=cv2.CHAIN_APPROX_NONE)
    
    sorted_contours=sorted(contours, key=cv2.contourArea, reverse= True) 

    cont_img=cv2.drawContours(image=img, contours=sorted_contours, contourIdx=0, 
                              color=(0,255,0),thickness=3)
    
    c=sorted_contours[0]

    x,y,w,h = cv2.boundingRect(c) 

    cv2.rectangle(img=img, pt1=(x,y), pt2=(x+w,y+h), color=(0,255,0), thickness=3)

    cropped_image=img_copy[y:y+h+1, x:x+w+1]

    return cropped_image