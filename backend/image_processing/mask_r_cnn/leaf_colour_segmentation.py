import torch
from torchvision import transforms as T
import cv2
import os
import gdown

URL = 'https://drive.google.com/file/d/1T-CTsVM4R-TGmyF0sOGzu8Ar3sgMbY4D/view?usp=drive_link'
MODEL = "model_01.pth"

MODEL_PATH = "image_processing\\mask_r_cnn\\models\\" + MODEL 

def downloadModel(file_url, output):
    gdown.download(url=file_url, output=output, quiet=False, fuzzy=True)

if not os.path.exists(MODEL_PATH):
    downloadModel(URL, MODEL_PATH)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = torch.load(MODEL_PATH, map_location=device)
model.eval()
transform = T.ToTensor()

def getRCNNSegmentation(image):
    ig = transform(image)

    with torch.no_grad():
        pred = model([ig.to(device)])

    masks = pred[0]["masks"]
    mask = masks[0 , 0] > 0.5
    maskImage = mask.cpu().detach().numpy().astype("uint8") * 255

    fin_img = cv2.bitwise_and(image , image , mask = maskImage)
    return fin_img

if __name__ == "__main__":
    image = cv2.imread("image_processing\\mask_r_cnn\\test\\0.jpg")
    segmentationImage = getRCNNSegmentation(image)

    cv2.imshow("image_mask",segmentationImage)
    cv2 .waitKey(0)
