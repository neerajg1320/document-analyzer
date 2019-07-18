from extractor.gcv_doctext import render_doc_text


def is_file_extn_image(file_extn):
    return file_extn == ".jpg" or file_extn == ".png"


def image_to_text(file_path):
    return render_doc_text(file_path, None)
