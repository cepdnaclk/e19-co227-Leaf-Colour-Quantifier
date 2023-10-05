import torch
from torchvision import transforms as T
import cv2
import os
import gdown

# URL = 'https://drive.google.com/file/d/1T-CTsVM4R-TGmyF0sOGzu8Ar3sgMbY4D/view?usp=drive_link' # model_04

# URL = 'https://drive.google.com/file/d/1-Tqx0VvC117hVDYBcHU2uD4Ryg68VtpX/view?usp=drive_link'  # model_11.3
# URL = 'https://drive.google.com/file/d/100rQP-_0nQFWwudp3qjxcRDMgbFnnNwR/view?usp=drive_link'  # model_11.5

# URL = 'https://drive.google.com/file/d/1gDk4Rw1TOwXL3h2lTByp7I8Wpn4ILF3K/view?usp=drive_link'  # model_12.0
URL = 'https://drive.google.com/file/d/1-9jD-F6NLZC5iZTI8hkTwGpOB3-1zWGD/view?usp=drive_link'  # model_12.1

MODEL = "model_05.pth"

# Path to store the downloaded model file
MODEL_PATH = "image_processing\\mask_r_cnn\\models\\" + MODEL

# Function to download the model file if it doesn't exist
def downloadModel(file_url, output):
    gdown.download(url=file_url, output=output, quiet=False, fuzzy=True)

# Check if the model file exists, if not, download it
if not os.path.exists(MODEL_PATH):
    downloadModel(URL, MODEL_PATH)

# Determine the device (GPU or CPU) for running the model
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Load the pre-trained Mask R-CNN model
model = torch.load(MODEL_PATH, map_location=device)
model.eval()

# Define a transformation to convert input images to tensors
transform = T.ToTensor()

# Function to perform Mask R-CNN segmentation on an input image
def getRCNNSegmentation(image):
    try:
        # Transform the input image to a tensor
        img = transform(image)

        with torch.no_grad():
            # Make predictions using the Mask R-CNN model
            pred = model([img.to(device)])

        # Get the mask for the detected object
        masks = pred[0]["masks"]
        mask = masks[0, 0] > 0.4
        maskImage = mask.cpu().detach().numpy().astype("uint8") * 255

        # Apply the mask to the original image
        fin_img = cv2.bitwise_and(image, image, mask=maskImage)

        return fin_img

    except:
        # Return the original image in case of an error
        return image

if __name__ == "__main__":
    # Example usage: Load an image and perform Mask R-CNN segmentation
    image = cv2.imread("image_processing\\mask_r_cnn\\test\\0.jpg")
    segmentationImage = getRCNNSegmentation(image)

    # Display the segmented image
    cv2.imshow("image_mask", segmentationImage)
    cv2.waitKey(0)