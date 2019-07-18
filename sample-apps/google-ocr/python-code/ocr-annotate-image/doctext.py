# https://cloud.google.com/vision/docs/fulltext-annotations
#

import argparse
from enum import Enum
import io

from google.cloud import vision
from google.cloud.vision import types
from PIL import Image, ImageDraw

import json

class FeatureType(Enum):
    PAGE = 1
    BLOCK = 2
    PARA = 3
    WORD = 4
    SYMBOL = 5


def draw_boxes(image, bounds, color, line_thickness=5):
    """Draw a border around the image using the hints in the vector list."""
    draw = ImageDraw.Draw(image)

    box_index = 0
    for bound in bounds:
        # print("box[{}]".format(box_index))
        box_index += 1
        points = [
            bound.vertices[0].x, bound.vertices[0].y,
            bound.vertices[1].x, bound.vertices[1].y,
            bound.vertices[2].x, bound.vertices[2].y,
            bound.vertices[3].x, bound.vertices[3].y,
            # Fifth: Only when using lines. We are using lines to control thickness.
            bound.vertices[0].x, bound.vertices[0].y,
        ]
        # draw.polygon(points, None, color)
        draw.line(points, fill=color, width=line_thickness)
    return image


def get_document_and_bounds(image_file, feature):
    """Returns document bounds given an image."""
    client = vision.ImageAnnotatorClient()

    bounds = []

    with io.open(image_file, 'rb') as image_file:
        content = image_file.read()

    image = types.Image(content=content)

    response = client.document_text_detection(image=image)
    annotation = response.full_text_annotation

    # Collect specified feature bounds by enumerating all document features
    for page in annotation.pages:
        for block in page.blocks:
            for paragraph in block.paragraphs:
                para_text_buf = ""
                for word in paragraph.words:
                    for symbol in word.symbols:
                        para_text_buf += symbol.text
                        if (feature == FeatureType.SYMBOL):
                            bounds.append(symbol.bounding_box)

                    if (feature == FeatureType.WORD):
                        bounds.append(word.bounding_box)
                    para_text_buf += " "

                if (feature == FeatureType.PARA):
                    # print(para_text_buf)
                    bounds.append(paragraph.bounding_box)

            if (feature == FeatureType.BLOCK):
                bounds.append(block.bounding_box)

        if (feature == FeatureType.PAGE):
            bounds.append(block.bounding_box)

    # The list `bounds` contains the coordinates of the bounding boxes.
    return annotation, bounds


# https://stackoverflow.com/questions/51972479/get-lines-and-paragraphs-not-symbols-from-google-vision-api-ocr-on-pdf/52086299
#
def get_para_and_lines(annotation):
    breaks = vision.enums.TextAnnotation.DetectedBreak.BreakType
    paragraphs = []
    lines = []

    for page in annotation.pages:
        for block in page.blocks:
            for paragraph in block.paragraphs:
                para = ""
                line = ""
                for word in paragraph.words:
                    for symbol in word.symbols:
                        line += symbol.text
                        if symbol.property.detected_break.type == breaks.SPACE:
                            line += ' '
                        if symbol.property.detected_break.type == breaks.EOL_SURE_SPACE:
                            line += ' '
                            lines.append(line)
                            para += line
                            line = ''
                        if symbol.property.detected_break.type == breaks.LINE_BREAK:
                            lines.append(line)
                            para += line
                            line = ''
                paragraphs.append(para)

    return paragraphs, lines


def render_doc_text(filein, fileout):
    image = Image.open(filein)

    # document, bounds = get_document_and_bounds(filein, FeatureType.PAGE)
    # draw_boxes(image, bounds, 'blue')

    document, bounds = get_document_and_bounds(filein, FeatureType.PARA)
    draw_boxes(image, bounds, 'red')

    print("DOCUMENT:\n", document.text)

    paragraphs, lines = get_para_and_lines(document)
    index=0
    for para in paragraphs:
        print("PARA[{}]:".format(index), para)
        # print(para)
        index += 1

    index = 0
    for line in lines:
        print("LINE[{}]:".format(index), line)
        index += 1

    # document, bounds = get_document_and_bounds(filein, FeatureType.WORD)
    # draw_boxes(image, bounds, 'yellow')

    if fileout is not 0:
        image.save(fileout)
    else:
        image.show()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('detect_file', help='The image for text detection.')
    parser.add_argument('-out_file', help='Optional output file', default=0)
    args = parser.parse_args()

    render_doc_text(args.detect_file, args.out_file)
