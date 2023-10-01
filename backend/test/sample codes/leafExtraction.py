import cv2
import numpy as np
import matplotlib.pyplot as plt

from sklearn.cluster import KMeans


def get_dominant_colors(image, num_colors=3):

    # Convert the image to RGB color space
    image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    
    # Flatten the image into a 2D array of pixels
    pixels = image_rgb.reshape(-1, 3)


    # Perform K-means clustering
    kmeans = KMeans(n_clusters=num_colors)
    kmeans.fit(pixels)

    # Get the labels and counts for each cluster
    labels, counts = np.unique(kmeans.labels_, return_counts=True)
    # print(labels, counts)

    # Sort the clusters based on count in descending order
    sorted_clusters = np.argsort(counts)[::-1]
    # print(sorted_clusters)

    # Get the top three dominant colors
    top_clusters = sorted_clusters[:num_colors]
    # print(top_clusters)

    # Get the RGB values of the top three clusters
    top_colors = kmeans.cluster_centers_[top_clusters].astype(int)
    # print(top_colors)

    # Calculate the percentage of each color
    total_pixels = pixels.shape[0]
    color_percentages = counts[top_clusters] / total_pixels * 100

    # Calculate the spread of each color
    color_spreads = np.sqrt(
        np.mean(np.square(pixels - kmeans.cluster_centers_[kmeans.labels_]), axis=0))
    
    temp_pixel = pixels[np.random.choice(pixels.shape[0], 1000, replace=False)]

    # ax = plt.axes(projection='3d')
    # xdata = temp_pixel[:,0]
    # ydata = temp_pixel[:,1]
    # zdata = temp_pixel[:,2]
    # ax.scatter3D(xdata, ydata, zdata, c=zdata, cmap='Greens')
    # print(top_colors)
    # xdata = top_colors[:,0]
    # ydata = top_colors[:,1]
    # zdata = top_colors[:,2]
    # ax.scatter3D(xdata, ydata, zdata, c=zdata, cmap='Dark2_r')
    # plt.show()

    return top_colors, color_spreads, color_percentages


def createCompositeMask(photo, paint):
    # Convert the paint image to grayscale
    paint_gray = cv2.cvtColor(paint, cv2.COLOR_BGR2GRAY)

    # Apply a threshold to create a binary paint mask
    _, paint_mask = cv2.threshold(paint_gray, 127, 255, cv2.THRESH_BINARY)

    # Obtain the leaf mask from the photo image
    leaf_mask = extractLeafMask(photo)

    # Create a composite mask by performing bitwise AND operation between the paint mask and leaf mask
    composite_mask = cv2.bitwise_and(paint_mask, leaf_mask)

    return composite_mask


def extractLeafMask(image):
    # Convert the image to grayscale
    cv2.GaussianBlur(image, (3, 3), 0)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Apply thresholding to create a binary mask
    _, threshold = cv2.threshold(
        gray, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)

    # Find contours in the thresholded image
    contours, _ = cv2.findContours(
        threshold, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Find the contour with the maximum area, which corresponds to the leaf
    leaf_contour = max(contours, key=cv2.contourArea)

    # Create a mask of the same size as the grayscale image
    mask = np.zeros_like(gray)

    # Draw the leaf contour on the mask
    cv2.drawContours(mask, [leaf_contour], 0, 255, -1)

    return mask

# define a function to compute and plot histogram


def plot_histogram(img, title, mask=None):
    # split the image into blue, green and red channels
    channels = cv2.split(img)
    colors = ("b", "g", "r")
    plt.title(title)
    plt.xlabel("Bins")
    plt.ylabel("# of Pixels")
    # loop over the image channels
    for (channel, color) in zip(channels, colors):
        # compute the histogram for the current channel and plot it
        hist = cv2.calcHist([channel], [0], mask, [256], [0, 256])
        plt.plot(hist, color=color)
        plt.xlim([0, 256])


def resize(image, p=0.3):
    w = int(image.shape[1] * p)
    h = int(image.shape[0] * p)
    return cv2.resize(image, (w, h))


photo = cv2.imread('test\\test_01.jpg')
# paint = cv2.imread('paint.jpg')

# composite_mask = createCompositeMask(photo, paint)

# leaf = cv2.bitwise_and(photo, photo, mask=composite_mask)


# # Resizing Image
# p = 0.3
# w = int(leaf.shape[1] * p)
# h = int(leaf. shape[0] * p)
# resized = cv2.resize(leaf, (w, h))
# cv2.imshow(' resized_leaf', resized)
# cv2 .waitKey(0)

# # compute a histogram for masked image
# plot_histogram(leaf, "Histogram for Masked Image", mask=composite_mask)

# # show the plots
# plt.show()


dominant_colors, color_spreads, color_percentages = get_dominant_colors(
    photo)

print(dominant_colors, color_spreads, color_percentages)

for color, spread, percentage in zip(dominant_colors, color_spreads, color_percentages):
    print(f"Dominant color: {color}, Spread: {spread}, Percentage: {percentage}%")
