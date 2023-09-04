import numpy as np

# error message when image is not colored while it should be
NOT_COLOR_IMAGE = 'NOT_COLOR_IMAGE'

def ensure_color(image):
    """
    Ensure that an image is colored
    Args:
        image: image to be checked for

    Returns:
        nothing

    Raises:
        ValueError with message code if image is not colored
    """
    if len(image.shape) < 3:
        raise ValueError(NOT_COLOR_IMAGE)


def div0(a, b):
    """ ignore / 0, div0( [-1, 0, 1], 0 ) -> [0, 0, 0] """
    with np.errstate(divide='ignore', invalid='ignore'):
        q = np.true_divide(a, b)
        q[~ np.isfinite(q)] = 0  # -inf inf NaN

    return q


def index_diff(image, green_scale=2.0, red_scale=1.4):

    ensure_color(image)

    bgr_sum = np.sum(image, axis=2)

    blues = div0(image[:, :, 0], bgr_sum)
    greens = div0(image[:, :, 1], bgr_sum)
    reds = div0(image[:, :, 2], bgr_sum)

    green_index = green_scale * greens - (reds + blues)
    red_index = red_scale * reds - (greens)

    return green_index - red_index
