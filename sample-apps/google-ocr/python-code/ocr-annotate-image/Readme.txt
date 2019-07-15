# https://cloud.google.com/vision/docs/fulltext-annotations

# If needed. In main machine we are using anaconda python
# source ../../../venv/bin/activate

# Export the api-key as mentioned in ../../Readme.txt

# The following command will open a window containing annotated PNG file containing boxes
python doctext.py ../../../data-Images/example_03.png

python doctext.py -out_file a1.png ../../../data-Receipts/Debit_Card_Receipt.jpg
