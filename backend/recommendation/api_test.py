import requests

# Base URL of your FastAPI application
base_url = "http://127.0.0.1:8000"

# Test /get_user_input endpoint
def test_get_user_input():
    url = f"{base_url}/get_user_input"
    user_preferences = {
        "min_budget": 12345.0,
        "max_budget": 1234567.0,
        "min_bedrooms": 3,
        "min_bathrooms": 1,
        "city": "New York",
        "province": "NY",
        "property_type": "Apartment"
    }
    response = requests.post(url, json=user_preferences)
    print("Response from /get_user_input:", response.json())
    return response.json()

# Test /fetch_properties_from_api endpoint
def test_fetch_properties_from_api(query, num_records):
    url = f"{base_url}/fetch_properties_from_api"
    payload = {"query": query, "num_records": num_records}
    response = requests.post(url, json=payload)
    print("Response from /fetch_properties_from_api:", response.json())

# Test /get_user_recommendations endpoint
def test_get_user_recommendations():
    url = f"{base_url}/get_user_recommendations"
    user_id = "user1"
    user_preferences = {
        "min_budget": 12345.0,
        "max_budget": 1234567.0,
        "min_bedrooms": 3,
        "min_bathrooms": 1,
        "city": "New York",
        "province": "NY",
        "property_type": "Apartment"
    }
    payload = {"user_id": user_id, "user_preferences": user_preferences}
    response = requests.post(url, json=payload)
    print("Response from /get_user_recommendations:", response.json())

# Run tests
if __name__ == "__main__":
    user_input_response = test_get_user_input()
    query = user_input_response["query"]
    num_records = user_input_response["num_records"]
    test_fetch_properties_from_api(query, num_records)
    test_get_user_recommendations()
