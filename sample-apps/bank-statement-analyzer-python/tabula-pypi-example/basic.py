import tabula

FILE_PATH = "../data-statements/HDFC.pdf"

# Read pdf into DataFrame
df = tabula.read_pdf(FILE_PATH, pages='all')
print(type(df), df)

# Read remote pdf into DataFrame
# df2 = tabula.read_pdf("https://github.com/tabulapdf/tabula-java/raw/master/src/test/resources/technology/tabula/arabic.pdf")
# print(type(df2), df2)

# convert PDF into CSV
tabula.convert_into(FILE_PATH, "output.csv", output_format="csv", pages='all')

# convert all PDFs in a directory
# tabula.convert_into_by_batch("input_directory", output_format='csv', pages='all')
