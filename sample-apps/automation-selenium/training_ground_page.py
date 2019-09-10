from selenium import webdriver

class TrainingGroundPage:
    def __init__(self, driver):
        self.driver = driver
        self.url = 'https://techstepacademy.com/training-ground/'

    def go(self):
        self.driver.get(self.url)
        
    def type_into_input_field(self, text):
        input1 = self.driver.find_element_by_id('ipt1')
        input1.clear()
        input1.send_keys(text)

    def get_input_text(self):
        input1 = self.driver.find_element_by_id('ipt1')
        elem_text = input1.get_attribute('value')
        return elem_text

    def click_button_1(self):
        button1 = self.driver.find_element_by_id('b1')
        button1.click()


# Test code
browser = webdriver.Chrome()
training_page = TrainingGroundPage(browser)
training_page.go()
training_page.type_into_input_field("It worked")
