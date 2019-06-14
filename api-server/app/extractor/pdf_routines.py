import subprocess


def pdftotext_read_pdf(file_path, password=None, flag_replace_newline=False):
    if password is not None:
        command = ['pdftotext', '-raw', file_path, '-upw', password, '-']
    else:
        command = ['pdftotext', '-raw', file_path, '-']

    ret_val = None
    try:
        ret_val = subprocess.check_output(command).decode('utf-8')
    except subprocess.CalledProcessError:
        print("Subprocess failed for command: %s" % command)

    return ret_val
