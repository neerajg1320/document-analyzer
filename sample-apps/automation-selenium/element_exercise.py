# Ref: https://www.udemy.com/course/elegant-browser-automation-with-python-and-selenium/learn/lecture/8755016#overview

from selenium import webdriver

browser = webdriver.Chrome()
browser.get('https://techstepacademy.com/training-ground')


input2_css_selector = "input[id='ipt2']"
button4_xpath_locator = "//button[@id='b4']"

# Assign elements
input1_elem = browser.find_element_by_css_selector(input2_css_selector)
button4_elem = browser.find_element_by_xpath(button4_xpath_locator)

# Manipulate elements
input1_elem.send_keys("Test text")
button4_elem.click()