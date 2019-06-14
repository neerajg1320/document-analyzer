from PyPDF2 import PdfFileReader, PdfFileWriter
import pdftotext

def is_encrypted_pdf(file_path):
    pdf_file = open(file_path, 'rb')

    pdf_reader = PdfFileReader(pdf_file)
    encrypted_flag =  pdf_reader.isEncrypted
    pdf_file.close()

    return encrypted_flag


def decrypt_pdf(input_path, output_path, password):
    with open(input_path, 'rb') as input_file, \
            open(output_path, 'wb') as output_file:
        reader = PdfFileReader(input_file)
        reader.decrypt(password)

        writer = PdfFileWriter()

        for i in range(reader.getNumPages()):
            writer.addPage(reader.getPage(i))

        writer.write(output_file)


def read_pdf(file_name, password="password", flag_replace_newline=False):
    # creating a pdf file object
    print("PDF: %s" % file_name)
    pdf_file = open(file_name, 'rb')

    # creating a pdf reader object
    pdf_reader = PdfFileReader(pdf_file)

    if pdf_reader.isEncrypted:
        print("Password: %s" % password)
        pdf_reader.decrypt(password)

    num_pages = pdf_reader.numPages
    # printing number of pages in pdf file
    print("Num Pages: %s" % num_pages)

    # return "Processing"

    all_page_text = ""
    page_num = 0
    while page_num < num_pages - 1:
        page = pdf_reader.getPage(page_num)

        # extracting text from page
        extracted_text = page.extractText()

        if flag_replace_newline:
            extracted_text = extracted_text.replace('\n', ' ')

        all_page_text += extracted_text

        page_num += 1

    # closing the pdf file object
    pdf_file.close()

    return all_page_text


# NG: 2019-06-14 5:41pm
# Need linux package poppler-utils to work
# Tested the working of the same
# Kept for possible future reference and inclusion.
#
#
# import subprocess
# PDF_COMMAND = '/usr/bin/pdftotext'
# def pdftotext_read_pdf_using_subprocess(file_path, password=None, flag_replace_newline=False):
#     print("PDF: " + file_path)
#
#     if password is not None:
#         command = [PDF_COMMAND, '-raw', file_path, '-upw', password, '-']
#     else:
#         command = [PDF_COMMAND, '-raw', file_path, '-']
#
#     ret_val = None
#     try:
#         ret_val = subprocess.check_output(command).decode('utf-8')
#     except subprocess.CalledProcessError:
#         print("Subprocess failed for command: %s" % command)
#
#     return ret_val


def pdftotext_read_pdf(file_path, password=None, flag_replace_newline=False):
    all_text = ""
    with open(file_path, "rb") as f:
        pdf = pdftotext.PDF(f)

        for page in pdf:
            all_text += page

    return all_text
