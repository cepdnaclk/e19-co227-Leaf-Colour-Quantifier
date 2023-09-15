from fastapi.responses import StreamingResponse
import numpy as np
import os
import pathlib
import shutil
import cv2
from image_processing.Image import Image
from image_processing.report import getPDF
import PyPDF2
from io import BytesIO
import tempfile as tp
from fastapi.responses import JSONResponse

def getImageReport(contentsOriginal, contentsSegmentation, remarks):
      try:
        nparrOriginal = np.fromstring(contentsOriginal, np.uint8)
        imgOriginal = cv2.imdecode(nparrOriginal, cv2.IMREAD_COLOR)

        nparrSegmentation = np.fromstring(contentsSegmentation, np.uint8)
        imgSegmentation = cv2.imdecode(nparrSegmentation, cv2.IMREAD_COLOR)

        imageOriginal = Image(imgOriginal)
        imageSegmentation = Image(imgSegmentation)
        # image = Image(img)

        # make the temp directory and use tha as root
        temp_dir = tp.TemporaryDirectory(prefix="pre_", suffix="_suf", dir="./")
        os.chdir(pathlib.Path(temp_dir.name))

        getPDF.createPDF(img)

        pdf_content = BytesIO()
        
        # Open and read the existing PDF file
        with open('Report.pdf', 'rb') as pdfFileObj:
            # Create a PDF reader object
            pdfReader = PyPDF2.PdfReader(pdfFileObj)

            # Create a PDF writer object to write the extracted page
            pdfWriter = PyPDF2.PdfWriter()

            for i in pdfReader.pages:
                pdfWriter.add_page(i)
            
            # Write the modified PDF to the BytesIO object
            pdfWriter.write(pdf_content)

        # go back to previous dir
        os.chdir("../")

        # delete temp dir
        shutil.rmtree(pathlib.Path(temp_dir.name))
        
        # Set the position of BytesIO object to the beginning
        pdf_content.seek(0)
        # Return the PDF as a StreamingResponse
        return StreamingResponse(pdf_content, media_type="application/pdf", headers={"Content-Disposition": "attachment; filename=report.pdf"})
    
    except:
        # go back to previous dir
        os.chdir("../")

        # delete temp dir
        shutil.rmtree(pathlib.Path(temp_dir.name))

        return JSONResponse(status_code=404, content={"message": "Item not found"})
    