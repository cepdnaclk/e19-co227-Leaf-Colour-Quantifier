import datetime
import os
import pathlib
import shutil
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib import pagesizes
import cv2 as cv
from matplotlib import pyplot as plt
import tempfile as tp


def getHistogram(img):
    # assert img is not None, "file could not be read, check with os.path.exists()"
    colours = {'r': 'Red', 'b': 'Blue', 'g': 'Green'}
    histrArrays = {}
    i = 0
    for col in colours.keys():
        histrArrays[col] = getHistogramChannelWise(
            img, col, colours, i)
        i += 1
        # plt.show()

    plt.figure(figsize=(8, 4))
    for col in histrArrays.keys():
        plt.plot(histrArrays[col], color=col, label=colours.get(col))

    plt.title("")
    plt.xlabel("Pixel Value", fontname='Times New Roman')
    plt.ylabel("Frequency", fontname='Times New Roman')
    plt.legend()
    plt.grid()
    plt.savefig("histogram.jpg", format="jpg", bbox_inches="tight")

    # plt.show()


def getHistogramChannelWise(img, col, colours, i):

    histr = cv.calcHist([img], [i], None, [256], [0, 256])
    plt.figure(figsize=(8, 4))
    plt.plot(histr, color=col)
    plt.title(colours[col], fontname='Times New Roman')
    plt.xlim([0, 256])
    plt.grid()
    plt.savefig("histogram"+col+".jpg", format="jpg", bbox_inches="tight")
    plt.close()
    return histr


def createPDF(img):
    getHistogram(img)

    can = Canvas("ReportNew.pdf", pagesize=pagesizes.A4)
    can.setFont("Times-Bold", 20)

    width, height = pagesizes.A4

    cv.imwrite("./leafimg.jpg", img)
    timestamp = datetime.datetime.now()

    can.drawCentredString(width/2, height-60, "Leaf Spectrum Report")

    can.setFont("Times-Roman", 14)
    can.drawString(70, height-90, "Date: "+str(timestamp.date()))
    can.drawString(70, height-120, "Time: {:02d}: {:02d}: {:02d}".format(timestamp.hour,
                   timestamp.minute, timestamp.second))

    can.drawInlineImage("./leafimg.jpg", width/2-150, height-550,
                        width=300, preserveAspectRatio=True)

    can.setFont("Times-Bold", 17)
    can.drawCentredString(width/2, height-350, "Histogram")

    can.drawInlineImage("histogram.jpg", 40, height-700, width=500,
                        preserveAspectRatio=True)

    can.drawInlineImage("./blacklogo.jpg", width-120, height-890, width=100,
                        preserveAspectRatio=True)

    can.showPage()

    can.setFont("Times-Bold", 17)
    can.drawCentredString(width/2, height-50, "Histogram Channel Wise")
    can.drawInlineImage("histogramb.jpg", 20, height-350,
                        width=280, preserveAspectRatio=True)
    can.drawInlineImage("histogramg.jpg", 300, height-350,
                        width=280, preserveAspectRatio=True)
    can.drawInlineImage("histogramr.jpg", 20, height-520,
                        width=280, preserveAspectRatio=True)

    can.drawInlineImage("./blacklogo.jpg", width-120, height-890, width=100,
                        preserveAspectRatio=True)
    can.showPage()
    can.save()


if __name__ == "__main__":
    # create temporary directory
    temp_dir = tp.TemporaryDirectory(
        prefix="leafseg_", suffix="_tmp", dir="./")

    # print(temp_dir)

    # get image - not required if  already done
    img = cv.imread("test\\a1.jpg")

    # change the current directory to temporary dir
    os.chdir(pathlib.Path(temp_dir.name))

    createPDF(img)

    # go back to previous dir
    os.chdir("../")

    # delete temp dir
    shutil.rmtree(pathlib.Path(temp_dir.name))
