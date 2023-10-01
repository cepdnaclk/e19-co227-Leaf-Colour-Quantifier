import cv2
import numpy as np
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
    
    return top_colors, color_spreads, color_percentages