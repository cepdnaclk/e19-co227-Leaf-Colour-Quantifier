from fastapi.responses import StreamingResponse
import numpy as np
import cv2
from image_processing.Image import Image
import PyPDF2
from io import BytesIO

def getImageReport(contents):
    nparr = np.fromstring(contents, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    image = Image(img)

    pdf_content = BytesIO()
    
    # Open and read the existing PDF file
    with open('test\\sample.pdf', 'rb') as pdfFileObj:
        # Create a PDF reader object
        pdfReader = PyPDF2.PdfReader(pdfFileObj)
        
        # Create a PDF writer object to write the extracted page
        pdfWriter = PyPDF2.PdfWriter()
        
        # Add the first page to the writer
        pdfWriter.add_page(pdfReader.pages[0])
        
        # Write the modified PDF to the BytesIO object
        pdfWriter.write(pdf_content)
    
    # Set the position of BytesIO object to the beginning
    pdf_content.seek(0)
    
    # Return the PDF as a StreamingResponse
    return StreamingResponse(pdf_content, media_type="application/pdf")



