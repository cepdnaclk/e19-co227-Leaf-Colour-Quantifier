
def imageToRGB(img):
    img = img.reshape(-1, 3)
    return [img[:,0].tolist(), img[:,1].tolist(), img[:,2].tolist()]