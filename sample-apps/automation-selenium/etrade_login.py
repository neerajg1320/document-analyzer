from selenium import webdriver

browser = webdriver.Chrome()
browser.get('https://us.etrade.com/e/t/user/login')

input_user_css_sel = "input[id='user_orig']"
input_user_elem = browser.find_element_by_css_selector(input_user_css_sel)

input_password_css_sel = "input[name='PASSWORD']"
input_password_elem = browser.find_element_by_css_selector(input_password_css_sel)

input_user_elem.send_keys("NEERGUPT")
input_password_elem.send_keys("zeni1176")

