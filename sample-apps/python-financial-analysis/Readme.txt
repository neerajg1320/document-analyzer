# https://financialzipline.wordpress.com/2016/08/20/installing-zipline/

virtualenv venv
source venv/bin/activate

pip install cython
pip freeze
pip install numpy
pip install zipline


# Problem with python3
# zipline looks for Collecting pandas<=0.22,>=0.18.1 
# this causes a problem as pandas<=0.22 looks for numpy==1.9.3 which is not satisfied by python3
# We will resolve this in case we need python3

# https://pythonprogramming.net/zipline-local-install-python-programming-for-finance/
# The above link talks about this issue
