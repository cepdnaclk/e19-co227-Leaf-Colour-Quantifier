# A Field-Based Approach for Quantifying Plant Leaf Color

---

<!--
This is a sample image, to show how to add images to your page. To learn more options, please refer [this](https://projects.ce.pdn.ac.lk/docs/faq/how-to-add-an-image/)

![Sample Image](./images/sample.png)
 -->

## Team

- E/19/094-Eashwara M.
- E/19/129-Gunawardana K.H.
- E/19/372-Silva A.K.M.
- E/19/408-Ubayasiri S.J.

## Table of Contents

1. [Introduction](#introduction)
2. [Backend](#Backend)
3. [Links](#links)

---

## Introduction

Welcome to our GitHub repository for a project on developing a simple field technique to detect and quantify the color of plant leaves. Our goal is to provide a practical solution for researchers, botanists, and enthusiasts who need a quick and accurate method to assess leaf color in various environments.
Traditionally, leaf color assessment has been subjective and time-consuming. To overcome these limitations, we are developing a field technique that leverages image processing. By capturing leaf images and analyzing the RGB values or other color models, we can quantify the color characteristics of the leaves, such as hue, saturation, and brightness.
Our approach is simple, affordable, and accessible, using commonly available equipment and open-source software libraries. The use of digital imaging ensures consistent and repeatable measurements, reducing human bias.

---

# Backend

## Setup

Follow these steps to set up the backend environment:

1. Clone the Repository:

   ```bash
   cd backend
   ```

2. Create a Virtual Environment (Optional but Recommended):

   ```bash
   python -m venv env
   ```

3. Activate the Virtual Environment:

   - On Windows:

     ```bash
     .\env\Scripts\activate
     ```

   - On macOS and Linux:

     ```bash
     source env/bin/activate
     ```

4. Install Required Dependencies:

   ```bash
   pip install -r requirements.txt
   ```

## Run the Backend

To run the backend server, use the following commands:

1. Change to the `backend` directory if you're not already there:

   ```bash
   cd backend
   ```

2. Activate the Virtual Environment (if not already activated):

   - On Windows:

     ```bash
     .\env\Scripts\activate
     ```

   - On macOS and Linux:

     ```bash
     source env/bin/activate
     ```

3. Start the FastAPI Application:

   ```bash
   python main.py
   ```

The backend server will start, and you will see output indicating the server is running. By default, the server will be accessible at `http://localhost:5000`.

## API Documentation

- http://localhost:5000/docs

  - Access the interactive Swagger documentation for the API.

- http://localhost:5000/openapi.json

  - Download the OpenAPI JSON file to use with your API client.

- http://localhost:5000/redoc

  - View API documentation in a user-friendly ReDoc interface.

## API Endpoints

### 1. Get Segmentation Image

- **URL**: `/image/segmentation`
- **Description**: Get a segmentation image of a plant leaf.
- **Method**: POST
- **Request Body**: Accepts a multipart/form-data request containing the leaf image.
- **Response**: Returns a successful response or validation error.

### 2. Get Segmentation Image using Mask R-CNN

- **URL**: `/image/segmentation/mask-rcnn`
- **Description**: Get a segmentation image of a plant leaf using Mask R-CNN.
- **Method**: POST
- **Request Body**: Accepts a multipart/form-data request containing the leaf image.
- **Response**: Returns a successful response or validation error.

### 3. Get Segmentation Image Mask

- **URL**: `/image/segmentation/mask`
- **Description**: Get a mask for the segmented plant leaf.
- **Method**: POST
- **Request Body**: Accepts a multipart/form-data request containing the leaf image and the segmentation mask.
- **Response**: Returns a successful response or validation error.

### 4. Generate a Report

- **URL**: `/report/image`
- **Description**: Generate a report for a segmented plant leaf image.
- **Method**: POST
- **Request Parameters**: `remarks` (string, required) - Remarks about the image.
- **Request Body**: Accepts a multipart/form-data request containing the original image and segmentation image.
- **Response**: Returns a successful response or validation error.

### 5. Analyze Dominant Colors

- **URL**: `/analysis/dominant`
- **Description**: Analyze dominant colors in an image.
- **Method**: POST
- **Request Body**: Accepts a multipart/form-data request containing the image.
- **Response**: Returns a JSON response with information about dominant colors.

## Directory Structure

Here is the directory structure of the backend:

```
├── assets
│
├── image_processing
│   ├── dominantColours
│   ├── leafSegmentation
│   ├── leafSegmentationMask
│   ├── mask_r_cnn
│   ├── report
│   ├── __init__.py
│   ├── define.py
│   └── Image.py
│
├── rest_api
│   ├── config
│   ├── controllers
│   ├── models
│   ├── routes
│   ├── util
│   ├── __init__.py
│   └── api.py
│
├── test
│
├── __init__.py
├── .gitignore
├── Dockerfile
├── main.py
├── README.md
└── requirements.txt
```

This structure outlines the main components of the backend, including image processing modules, REST API components, and tests.

## Leaf Segmentation Techniques

In the Leaf Colour Quantifier project, we employ three different leaf segmentation techniques to accurately isolate plant leaves from images.

### 1. OpenCV Algorithm

The OpenCV-based leaf segmentation algorithm utilizes various image processing methods to generate a marker for identifying the leaf region within an image.

- **Generate Background Marker**: A background marker is created to distinguish the leaf from the background. This marker is updated using techniques such as color index markers and removing blues. The details of the background marker generation process include:

  - **Color Index Marker**: The marker is differentiated based on the difference of color indexes, specifically the green index minus the red index.
  - **Thresholding**: A threshold is applied to the color index difference to separate the leaf from the background. The threshold value is chosen empirically based on testing.
  - **Hole Filling**: Holes in the marker, which may appear due to thresholding, can be filled using various techniques:
    - **Floodfill**: Floodfilling is used to fill holes, and a mask is created to avoid filling non-hole regions adjacent to the image edge.
    - **Threshold-Based**: Holes are filled based on a minimum hole size threshold, often relative to the size of the largest leaf component.

- **Segment Leaf**: The leaf is segmented from the original image using the generated background marker. The segmentation includes options for filling holes, smoothing boundaries, and specifying marker intensity.

This technique is implemented in Python and provides an efficient way to segment leaves from images.

### 2. Mask R-CNN Model

The Mask R-CNN model is a deep learning-based technique used for leaf segmentation. It leverages pre-trained models and fine-tunes them for the task of identifying leaves in images.

**Note: Initially, this model works specifically for the "Dieffenbachia Amoena" species. However, we plan to extend its functionality to other plant species as well.**

- **Data Augmentation**: The code applies various data augmentation techniques to enhance the diversity of the training dataset. These techniques include rotations, resizing, blurring, sharpening, and more. Data augmentation helps the model generalize better to different leaf images.

- **Dataset Preparation**: The code loads leaf images and corresponding masks, where each pixel in the mask corresponds to a specific object (in this case, different parts of the plant leaf). It prepares the data by resizing and applying data augmentation.

- **Model Architecture**: It uses the Mask R-CNN architecture based on ResNet-50 as the backbone. The model is customized for binary leaf segmentation (foreground and background). Fast R-CNN and Mask R-CNN predictors are modified accordingly.

- **Training Loop**: The code includes a training loop that iterates over the dataset. It uses stochastic gradient descent (SGD) as the optimizer and calculates the loss for each batch. The loss is backpropagated to update the model's weights.

- **Validation**: After each epoch of training, the code evaluates the model on a validation dataset to monitor its performance.

- **Model Saving**: The trained model is saved to a file for later use in the Leaf Colour Quantifier project.

The trained Mask R-CNN model provides accurate leaf segmentation results and is a powerful tool for this task.

### 3. Mask-Based Segmentation

This technique combines mask-based segmentation with color filtering to isolate leaves in images. Here's how it works:

- **Create Composite Mask**: A composite mask is created by performing bitwise AND operations between a binary paint mask and a leaf mask obtained from the photo image.

- **Extract Leaf Mask**: The leaf mask is extracted by converting the image to grayscale, applying thresholding, and finding the contour with the maximum area.

- **Filter Color**: Color filtering is applied to the mask to remove non-leaf regions, leaving only the segmented leaf.

This technique effectively combines mask-based and color-based segmentation to accurately identify plant leaves.

## Dominant Color Extraction

The dominant color extraction process involves identifying the main colors in an image. It's particularly useful for analyzing the predominant color characteristics of plant leaves or other plant parts.

1. **Convert to RGB**: The input image is first converted from the BGR color space to the more commonly used RGB color space. This step ensures that the image is in the right color format for further processing.

2. **Flatten Image**: The image is then flattened into a 2D array of pixels. Each pixel is represented by its RGB values.

3. **K-Means Clustering**: K-means clustering is applied to the flattened pixel data. The algorithm groups similar colors together into clusters, with each cluster representing a dominant color. The number of clusters (colors) to extract can be specified as a parameter (default is 3).

4. **Cluster Analysis**: After clustering, we obtain the labels and counts for each cluster. The clusters are sorted based on the count of pixels they contain in descending order, revealing the most dominant colors.

5. **Top Dominant Colors**: The top 3 clusters (where 3 is the specified number of dominant colors) are selected based on their pixel count. These clusters represent the dominant colors in the image.

6. **Color Percentage**: We calculate the percentage of each dominant color in the image by dividing the count of pixels in each cluster by the total number of pixels in the image.

7. **Color Spread**: The color spread is calculated to determine how spread out the colors are within each cluster. It provides insights into the variability of each dominant color.

### Output

The output of this process includes:

- The RGB values of the dominant colors.
- The percentage of each dominant color in the image.
- The color spread (variability) of each dominant color.

## Report Generation

The report generation process aims to provide a detailed summary of the image analysis, making it easier for users to understand the results and observations. The report is created in PDF format and contains various sections with visual representations of the analysis.

1. **Histogram Generation**: Histograms of color channels (Red, Green, Blue) are generated from the segmented leaf image. These histograms provide insights into the distribution of pixel intensities for each color channel.

2. **PDF Creation**: The ReportLab library is used to create a PDF document. We set up the document's layout, fonts, and styles for consistent formatting.

3. **Header Information**: The report begins with a title, "Leaf Spectrum Report," followed by the date and time of the analysis. The current date and time are automatically generated using the `datetime` module.

4. **Image and Logo**: The original plant image is resized and included in the report to provide visual context. Additionally, a logo image is added for branding purposes.

5. **Histogram Section**: The histograms of color channels (Red, Green, Blue) are added to the report, providing a visual representation of color distribution within the segmented leaf.

6. **Remarks**: Users have the option to add remarks or comments to the report. These remarks are included in the report for additional information.

---

## Testing Backend

Implemeted using pytest

```

test/
│
├── integration_test/
│ ├── integration_test.py
│
├── unit_test/
│ ├── image_processing_test.py
│ └── rest_api_test.py
│
├── test_01.jpg
├── test_02.jpg
├── test_03.jpg
├── test_04.jpg
└── test_05.jpg

```

### Integration Tests

These tests use the FastAPI test client to make HTTP requests to your API endpoints.

#### Running Integration Tests

```bash
pytest integration_test.py
```

### Unit Tests

These tests focus on specific units of code, such as image processing and API functionality.

#### Running Unit Tests

```bash
pytest image_processing_test.py
pytest rest_api_test.py
```

The `image_processing_test.py` file contains tests for image loading, segmentation, and RCNN-based segmentation.
The `rest_api_test.py` file contains API tests for your FastAPI application.

### Run Test

```bash
cd backend
```

```bash
pytest
```

This command will run all available tests and provide you with test results.

---

## Links

- [Department of Computer Engineering](http://www.ce.pdn.ac.lk/)
- [University of Peradeniya](https://eng.pdn.ac.lk/)

[//]: # "Please refer this to learn more about Markdown syntax"
[//]: # "https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet"
