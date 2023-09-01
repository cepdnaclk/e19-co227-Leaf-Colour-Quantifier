from Image import Image

import cv2
 
# Load the image
image = cv2.imread("image_processing\photo1.jpg")

myImage = Image(image)

cv2.imshow("Image", myImage.getGradImage())
# cv2.imshow("Image", myImage.image)

# Wait for the user to press a key
cv2.waitKey(0)
 
# Close all windows
cv2.destroyAllWindows()