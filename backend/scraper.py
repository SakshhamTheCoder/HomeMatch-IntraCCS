import time
from selenium import webdriver
from selenium.webdriver.common.by import By

# Initialize Chrome driver
driver = webdriver.Chrome()

url = f"https://www.magicbricks.com/property-for-sale/residential-real-estate?proptype=Multistorey-Apartment,Builder-Floor-Apartment,Penthouse,Studio-Apartment,Residential-House,Villa&page=1&cityName={'Jammu'}"
driver.get(url)

# Give the page time to load
time.sleep(5)

# Define the data extraction logic
properties = []
property_elements = driver.find_elements(By.CSS_SELECTOR, ".mb-srp__card")

for element in property_elements:
    title = element.find_element(By.CSS_SELECTOR, ".mb-srp__card--title").text
    price = element.find_element(
        By.CSS_SELECTOR, ".mb-srp__card__price--amount"
    ).text.replace("\n", "")

    details_elements = element.find_element(
        By.CSS_SELECTOR, ".mb-srp__card__summary__list"
    )
    all_items = details_elements.find_elements(
        By.CSS_SELECTOR, ".mb-srp__card__summary__list--item"
    )
    desc = element.find_element(By.CSS_SELECTOR, ".mb-srp__card--desc--text").text
    try:
        new_text = element.find_element(
            By.CSS_SELECTOR, ".mb-srp__card__usp--item"
        ).text.lower()
    except:
        new_text = ""
    is_new = "newly" in new_text

    details = {
        "is_new": is_new,
    }
    for item in all_items:
        key = item.find_element(By.CSS_SELECTOR, ".mb-srp__card__summary--label").text
        value = item.find_element(By.CSS_SELECTOR, ".mb-srp__card__summary--value").text
        details[key] = value

    properties.append(
        {"title": title, "description": desc, "price": price, "details": details}
    )

# Print the extracted data
for property in properties:
    print(property)

# Close the driver
driver.quit()
