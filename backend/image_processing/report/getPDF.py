import datetime
import os
import pathlib
import shutil
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib import pagesizes
import cv2 as cv
from matplotlib import pyplot as plt
import tempfile as tp
import imutils
import dominant

def getHistogram(img, mask):
    # assert img is not None, "file could not be read, check with os.path.exists()"
    colours = {'r': 'Red', 'b': 'Blue', 'g': 'Green'}
    histrArrays = {}
    i = 0
    # print('inside get histogram')
    for col in colours.keys():
        histrArrays[col] = getHistogramChannelWise(
            img, col, colours, i, mask)
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

def getColorSpreads(img):

    # Assuming you have already obtained the output from the function
    top_colors, color_spreads, color_percentages = dominant.get_dominant_colors(img)

    # Extract color labels for the pie chart
    color_labels = [f"Color {i+1}" for i in range(len(color_percentages))]

    # Create a pie chart
    fig, ax = plt.subplots()
    ax.pie(color_percentages, labels=color_labels, autopct='%1.1f%%', startangle=90, colors=[tuple(color) for color in top_colors])
    ax.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.

    plt.title('Top Color Percentages')
    plt.savefig("dominentColors.jpg",bbox_inches= 'tight')
    plt.close()

def getHistogramChannelWise(img, col, colours, i, mask):
    # print('inside channel wise function')
    histr = cv.calcHist([img], [i], mask, [256], [0, 256])
    plt.figure(figsize=(8, 4))
    plt.plot(histr, color=col)
    plt.title(colours[col], fontname='Times New Roman')
    plt.xlim([0, 256])
    plt.grid()
    plt.savefig("histogram"+col+".jpg", format="jpg", bbox_inches="tight")
    plt.close()
    return histr


def createPDF(img, logo, segmentedImg, remarks):
    cv.imwrite("./segmentedLeaf.jpg", segmentedImg)
    mask = cv.imread("./segmentedLeaf.jpg", cv.IMREAD_GRAYSCALE)

    getHistogram(segmentedImg, mask)

    can = Canvas("Report.pdf", pagesize=pagesizes.A4)
    can.setFont("Times-Bold", 20)

    width, height = pagesizes.A4

    cv.imwrite("./leafimg.jpg", imutils.resize(img, height=200))
    cv.imwrite("./leafimg_mask.jpg", imutils.resize(segmentedImg, height=200))
    cv.imwrite("./blacklogo.jpg", logo)
    timestamp = datetime.datetime.now()

    can.drawCentredString(width/2, height-60, "Leaf Spectrum Report")

    can.setFont("Times-Roman", 14)
    can.drawString(70, height-90, "Date: "+str(timestamp.date()))
    can.drawString(70, height-120, "Time: {:02d}: {:02d}: {:02d}".format(timestamp.hour,
                   timestamp.minute, timestamp.second))

    can.drawInlineImage("./leafimg_mask.jpg", width/2-150, height-350,
                        width=300, preserveAspectRatio=True)

    can.setFont("Times-Bold", 17)
    can.drawCentredString(width/2, height-375, "Histogram")
    # print('middle of functino')
    can.drawInlineImage("histogram.jpg", 40, height-700, width=500,
                        preserveAspectRatio=True)

    can.drawInlineImage("./blacklogo.jpg", width-120, height-890, width=100,
                        preserveAspectRatio=True)
    # print('blacklogo1')

    can.showPage()

    can.setFont("Times-Bold", 17)
    can.drawCentredString(width/2, height-50, "Histogram Channel Wise")
    can.drawInlineImage("histogramb.jpg", 20, height-350,
                        width=280, preserveAspectRatio=True)
    can.drawInlineImage("histogramg.jpg", 300, height-350,
                        width=280, preserveAspectRatio=True)
    can.drawInlineImage("histogramr.jpg", 20, height-520,
                        width=280, preserveAspectRatio=True)

    getColorSpreads(segmentedImg)
    can.drawInlineImage("dominentColors.jpg",height-650, width = 280, preserveAspectRatio=True)
    can.setFont("Times-Roman", 14)
    can.drawString(70, height-650, "Remarks: "+remarks)
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
