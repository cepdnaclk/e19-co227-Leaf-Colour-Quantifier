# Leaf Colour Quantifier - Backend

Welcome to the backend repository of the Leaf Colour Quantifier project. This backend serves as the API for the Leaf Colour Quantifier, providing image processing and analysis capabilities.

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

# Testing

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

## Integration Tests

These tests use the FastAPI test client to make HTTP requests to your API endpoints.

### Running Integration Tests

```bash
pytest integration_test.py
```

## Unit Tests

These tests focus on specific units of code, such as image processing and API functionality.

### Running Unit Tests

```bash
pytest image_processing_test.py
pytest rest_api_test.py
```

The `image_processing_test.py` file contains tests for image loading, segmentation, and RCNN-based segmentation.
The `rest_api_test.py` file contains API tests for your FastAPI application.

## Run Test

```bash
cd backend
```

```bash
pytest
```

This command will run all available tests and provide you with test results.
