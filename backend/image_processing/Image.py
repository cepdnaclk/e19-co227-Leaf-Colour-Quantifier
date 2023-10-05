import numpy as np
import cv2
from image_processing.leafSegmentation.segment import segment_leaf
from image_processing.mask_r_cnn.leaf_colour_segmentation import getRCNNSegmentation
from image_processing.dominantColours.dominant import get_dominant_colors
from image_processing.leafSegmentationMask.segmentationMask import getLeafUsingMark
from image_processing.define import *

class Image:
    """
    Image class for handling image processing operations.

    Args:
        image: Input image to be processed.

    Methods:
        getImage(): Get the original input image.
        getEnhancedImage(): Enhance the input image by reducing noise and improving sharpness.
        getSegmentationImage(): Get a segmented image of the leaf using a custom segmentation technique.
        getSegmentationImageRCNN(): Get a segmented image of the leaf using Mask R-CNN.
        getSharpImage(img): Apply a sharpening filter to the input image.
        getNoiceReducedImage(img): Apply Gaussian blur to reduce noise in the input image.
        resizeImage(image): Resize the input image to a predefined size.
        getDominantColours(): Get the dominant colors in the input image.
        getSegmentationImageUsingMark(mask): Get a segmented image using a provided mask.

    """

    def __init__(self, image):
        (h, w) = image.shape[:2]
        aspect_ratio = h * 1.0 / w
        self.image = cv2.resize(image, (int(DIM_HEIGHT / aspect_ratio), DIM_HEIGHT), interpolation=cv2.INTER_AREA)

    def getImage(self):
        """Get the original input image."""
        return self.image

    def getEnhancedImage(self):
        """Enhance the input image by reducing noise and improving sharpness."""
        img = self.getNoiceReducedImage(self.image)
        return self.resizeImage(self.getSharpImage(img))

    def getSegmentationImage(self):
        """Get a segmented image of the leaf using a custom segmentation technique."""
        return self.resizeImage(segment_leaf(self.getEnhancedImage(), 1, True, 0))

    def getSegmentationImageRCNN(self):
        """Get a segmented image of the leaf using Mask R-CNN."""
        return self.resizeImage(getRCNNSegmentation(self.getEnhancedImage()))

    def getSharpImage(self, img):
        """Apply a sharpening filter to the input image."""
        kernel = np.array([[0, -1, 0], [-1, 5, -1], [0, -1, 0]])
        return cv2.filter2D(img, -1, kernel)

    def getNoiceReducedImage(self, img):
        """Apply Gaussian blur to reduce noise in the input image."""
        return cv2.GaussianBlur(img, (7, 7), 0)

    def resizeImage(self, image):
        """
        Resize the input image to a predefined size.

        Args:
            image: Input image to be resized.

        Returns:
            Resized image.
        """
        (h, w) = image.shape[:2]
        aspect_ratio = h * 1.0 / w
        return cv2.resize(image, (int(SEND_DIM_HEIGHT / aspect_ratio), SEND_DIM_HEIGHT), interpolation=cv2.INTER_AREA)

    def getDominantColours(self):
        """Get the dominant colors in the input image."""
        return get_dominant_colors(self.resizeImage(self.image))

    def getSegmentationImageUsingMark(self, mask):
        """
        Get a segmented image using a provided mask.

        Args:
            mask: Binary mask used for segmentation.

        Returns:
            Segmented image.
        """
        return self.resizeImage(getLeafUsingMark(self.image, mask))
