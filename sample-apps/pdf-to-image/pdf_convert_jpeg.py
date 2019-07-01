import os
import tempfile
from pdf2image import convert_from_path

filename = 'ETRADE Brokerage Trade Confirmation - XXXX7417 - 20180621_9.pdf'

with tempfile.TemporaryDirectory() as path:
    images_from_path = convert_from_path(filename, output_folder=path, last_page=1, first_page=0)

base_filename = os.path.splitext(os.path.basename(filename))[0] + '.jpg'
save_dir = 'images'
file_path = os.path.join(save_dir, base_filename)

for page in images_from_path:
    page.save(file_path, 'JPEG')



from PIL import Image
import pytesseract

base_textfile = os.path.splitext(os.path.basename(filename))[0] + '.txt'

text = pytesseract.image_to_string(Image.open(file_path))

with open(base_textfile, "w") as text_file:
    text_file.write(text)

print(text)