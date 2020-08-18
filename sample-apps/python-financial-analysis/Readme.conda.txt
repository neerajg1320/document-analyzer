# https://blog.quantinsti.com/python-trading/

conda create -n conda_venv python=3
source activate conda_venv
pip install yfinance

# Import yfinance
import yfinance as yf

# Get the data for stock Facebook from 2017-04-01 to 2019-04-30
data = yf.download('AAPL', start="2017-04-01", end="2019-04-30")

# Print the first five rows of the data
data.head()


condata deactivate
