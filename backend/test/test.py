import cv2
import numpy as np
from matplotlib import pyplot as plt
  
# Let's load a simple image with 3 black squares
img= cv2.imread("test\\a5.jpg")


# Create a black mask with the same size as the image
mask = np.zeros_like(img)

# Define the center and radius of the circle
height, width = img.shape[:2]
center = (width // 2, height // 2)
radius = min(center[0], center[1])

# Draw a white circle in the mask
cv2.circle(mask, center, radius, (255, 255, 255), -1)

# Apply the mask to the image
masked_image = cv2.bitwise_and(img, mask)

# Display the original image with the circular mask
fig, ax = plt.subplots(1, 2, figsize=(10, 5))
ax[0].imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
ax[0].set_title('Original Image')
ax[1].imshow(cv2.cvtColor(masked_image, cv2.COLOR_BGR2RGB))
ax[1].set_title('Masked Image')
ax[0].axis('off')
ax[1].axis('off')
plt.show()