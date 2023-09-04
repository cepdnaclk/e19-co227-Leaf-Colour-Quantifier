import cv2
import numpy as np

from image_processing.leafSegmentation.utils import *

# constants for filling holes mode
FILL = {
    'NO': 0,
    'FLOOD': 1,
    'THRESHOLD': 2,
    'MORPH': 3,
}


def color_index_marker(color_index_diff, marker):
    """
    Differentiate marker based on the difference of the color indexes
    Threshold below some number(found empirically based on testing on 5 photos,bad)
    If threshold number is getting less, more non-green image
     will be included and vice versa
    Args:
        color_index_diff: color index difference based on green index minus red index
        marker: marker to be updated

    Returns:
        nothing
    """
    marker[color_index_diff <= -0.05] = False


def generate_floodfill_mask(bin_image):
    """
    Generate a mask to remove backgrounds adjacent to image edge

    Args:
        bin_image (ndarray of grayscale image): image to remove backgrounds from

    Returns:
        a mask to backgrounds adjacent to image edge
    """
    y_mask = np.full(
        (bin_image.shape[0], bin_image.shape[1]), fill_value=255, dtype=np.uint8
    )
    x_mask = np.full(
        (bin_image.shape[0], bin_image.shape[1]), fill_value=255, dtype=np.uint8
    )

    xs, ys = bin_image.shape[0], bin_image.shape[1]

    for x in range(0, xs):
        item_indexes = np.where(bin_image[x, :] != 0)[0]
        # min_start_edge = ys
        # max_final_edge = 0
        if len(item_indexes):
            start_edge, final_edge = item_indexes[0], item_indexes[-1]
            x_mask[x, start_edge:final_edge] = 0
            # if start_edge < min_start_edge:
            #     min_start_edge = start_edge
            # if final_edge > max_final_edge:
            #     max_final_edge = final_edge

    for y in range(0, ys):
        item_indexes = np.where(bin_image[:, y] != 0)[0]
        if len(item_indexes):
            start_edge, final_edge = item_indexes[0], item_indexes[-1]

            y_mask[start_edge:final_edge, y] = 0
            # mask[:start_edge, y] = 255
            # mask[final_edge:, y] = 255

    return np.logical_or(x_mask, y_mask)


def select_largest_obj(img_bin, lab_val=255, fill_mode=FILL['FLOOD'],
                       smooth_boundary=False, kernel_size=15):
    """
    Select the largest object from a binary image and optionally
    fill holes inside it and smooth its boundary.
    Args:
        img_bin (2D array): 2D numpy array of binary image.
        lab_val ([int]): integer value used for the label of the largest
                object. Default is 255.
        fill_mode (string {no,flood,threshold,morph}): hole filling techniques which are
            - no: no filling of holes
            - flood: floodfilling technique without removing image edge sharing holes
            - threshold: removing holes based on minimum size of hole to be removed
            - morph: closing morphological operation with some kernel size to remove holes
        smooth_boundary ([boolean]): whether smooth the boundary of the
                largest object using morphological opening or not. Default
                is false.
        kernel_size ([int]): the size of the kernel used for morphological
                operation. Default is 15.
    Returns:
        a binary image as a mask for the largest object.
    """

    # set up components
    n_labels, img_labeled, lab_stats, _ = \
        cv2.connectedComponentsWithStats(
            img_bin, connectivity=8, ltype=cv2.CV_32S)

    # find largest component label(label number works with labeled image because of +1)
    largest_obj_lab = np.argmax(lab_stats[1:, 4]) + 1

    # create a mask that will only cover the largest component
    largest_mask = np.zeros(img_bin.shape, dtype=np.uint8)
    largest_mask[img_labeled == largest_obj_lab] = lab_val

    if fill_mode == FILL['FLOOD']:
        # fill holes using opencv floodfill function

        # set up seedpoint(starting point) for floodfill
        bkg_locs = np.where(img_labeled == 0)
        bkg_seed = (bkg_locs[0][0], bkg_locs[1][0])

        # copied image to be floodfill
        img_floodfill = largest_mask.copy()

        # create a mask to ignore what shouldn't be filled(I think no effect)
        h_, w_ = largest_mask.shape
        mask_ = np.zeros((h_ + 2, w_ + 2), dtype=np.uint8)

        cv2.floodFill(img_floodfill, mask_, seedPoint=bkg_seed,
                      newVal=lab_val)
        holes_mask = cv2.bitwise_not(img_floodfill)  # mask of the holes.

        # get a mask to avoid filling non-holes that are adjacent to image edge
        non_holes_mask = generate_floodfill_mask(largest_mask)
        holes_mask = np.bitwise_and(holes_mask, np.bitwise_not(non_holes_mask))

        largest_mask = largest_mask + holes_mask

    elif fill_mode == FILL['MORPH']:
        # fill holes using closing morphology operation
        kernel_ = np.ones((50, 50), dtype=np.uint8)
        largest_mask = cv2.morphologyEx(largest_mask, cv2.MORPH_CLOSE,
                                        kernel_)
        
    elif fill_mode == FILL['THRESHOLD']:
        # fill background-holes based on hole size threshold
        # default hole size threshold is some percentage
        #   of size of the largest component(i.e leaf component)

        # invert to setup holes of background, sorry for the incovenience
        inv_img_bin = np.bitwise_not(largest_mask)

        # set up components
        inv_n_labels, inv_img_labeled, inv_lab_stats, _ = \
            cv2.connectedComponentsWithStats(
                inv_img_bin, connectivity=8, ltype=cv2.CV_32S)

        # find largest component label(label number works with labeled image because of +1)
        inv_largest_obj_lab = np.argmax(inv_lab_stats[1:, 4]) + 1

        # setup sizes and number of components
        inv_sizes = inv_lab_stats[1:, -1]
        sizes = lab_stats[1:, -1]
        inv_nb_components = inv_n_labels - 1

        # find the greater side of the image
        inv_max_side = np.amax(inv_img_labeled.shape)

        # set the minimum size of hole that is allowed to stay
        # todo: specify good min size
        inv_min_size = int(0.3 * sizes[largest_obj_lab - 1])

        # generate the mask that allows holes greater than minimum size(weird)
        inv_mask = np.zeros((inv_img_labeled.shape), dtype=np.uint8)
        for inv_i in range(0, inv_nb_components):
            if inv_sizes[inv_i] >= inv_min_size:
                inv_mask[inv_img_labeled == inv_i + 1] = 255

        largest_mask = largest_mask + np.bitwise_not(inv_mask)

    if smooth_boundary:
        # smooth edge boundary
        kernel_ = np.ones((kernel_size, kernel_size), dtype=np.uint8)
        largest_mask = cv2.morphologyEx(largest_mask, cv2.MORPH_OPEN,
                                        kernel_)

    return largest_mask
