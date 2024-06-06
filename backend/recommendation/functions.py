from firebase_admin import firestore, initialize_app
from firebase_admin import credentials
import pandas as pd
from surprise import Dataset, Reader, SVD
import csv
import os
import requests
from dotenv import load_dotenv
load_dotenv()

# Initialize Firebase Admin SDK
cred = credentials.Certificate(r"C:\Users\aksha\code\CCSHACK\my-ccs-firebase-adminsdk-m88uu-c340c8b065.json")
initialize_app(cred)
db = firestore.client()

def get_user_input(user_preferences):
    
    # make changes to work with user input from frontend
    # Retrieve user preferences with default values
    min_budget = user_preferences.get("min_budget", 0)
    max_budget = user_preferences.get("max_budget", 10000000)
    min_bedrooms = user_preferences.get("min_bedrooms", 0)
    min_bathrooms = user_preferences.get("min_bathrooms", 0)
    city = user_preferences["city"]
    province = user_preferences["province"]
    property_types = user_preferences.get("propertyType", [])
    
    query = (
        "country:\"US\" AND latitude:* AND longitude:* AND postalCode:* AND address:*"
        "AND floorSizeValue:* AND lotSizeValue:* AND mostRecentPriceAmount:*"
        "AND numBathroom:* AND numBedroom:* AND numFloor:* AND numRoom:*"
        "AND numUnit:* AND numParkingSpaces:* AND parkingTypes:*"
        "AND mostRecentStatus:(\"For Sale\" OR \"Rental\")"
    )
    
    # Format the user preferences into the query
    query += f" AND mostRecentPriceAmount:[{min_budget} TO {max_budget}]"
    query += f" AND numBedroom:[{min_bedrooms} TO *]"
    query += f" AND numBathroom:[{min_bathrooms} TO *]"
    query += f' AND (province:"{province}")'
    query += f' AND (city:"{city}")'
    
    # Add user-preferred property types to the query
    if property_types:
        property_type_query = " OR ".join([f'\"{prop}\"' for prop in property_types])
        query += f' AND propertyType:({property_type_query})'
    
    num_records = 5
    
    return query, num_records


def fetch_properties_from_api(query, num_records):
    api_url = "https://api.datafiniti.co/v4/properties/search"
    api_token = os.getenv("API_KEY")
    headers = {
        "accept": "application/json",
        "Authorization": f"Bearer {api_token}",
        "content-type": "application/json"
    }
    
    payload = {
        "query": query,
        "num_records": num_records
    }
    
    response = requests.post(api_url, json=payload, headers=headers)
    
    if response.status_code == 200:
        data = response.json()
        return data.get('records', [])
    else:
        print(f"Failed to fetch properties: {response.status_code}")
        return []


# To be Removed
def save_properties_to_csv(records, filename):
    important_columns = [
        'id', 'address', 'propertyType', 'numBedroom', 'numBathroom', 'numRoom', 'numFloor', 'numUnit', 'numParkingSpaces',
        'parkingTypes', 'floorSizeValue', 'lotSizeValue', 'yearBuilt', 'mostRecentPriceAmount', 'latitude', 'longitude',
        'city', 'province', 'postalCode'
    ]
    
    with open(filename, 'w', newline='') as file:
        dict_writer = csv.DictWriter(file, fieldnames=important_columns)
        dict_writer.writeheader()
        
        for record in records:
            filtered_record = {key: record.get(key, '') for key in important_columns}
            dict_writer.writerow(filtered_record)


def upload_properties_to_firestore(properties, user_id):
    for property in properties:
        property_id = property['id']
        property_ref = db.collection('properties').document(property_id)
        property_doc = property_ref.get()
        
        if property_doc.exists:
            existing_data = property_doc.to_dict()
            existing_user_ids = existing_data.get('user_ids', [])
            
            if user_id not in existing_user_ids:
                existing_user_ids.append(user_id)
                property_ref.update({'user_ids': existing_user_ids})
        else:
            property_data = {
                'id': property['id'],
                'address': property['address'],
                'propertyType': property['propertyType'],
                'numBedroom': property['numBedroom'],
                'numBathroom': property['numBathroom'],
                'floorSizeValue': property['floorSizeValue'],
                'mostRecentPriceAmount': property['mostRecentPriceAmount'],
                'latitude': property['latitude'],
                'longitude': property['longitude'],
                'city': property['city'],
                'province': property['province'],
                'postalCode': property['postalCode'],
                'user_ids': [user_id]
            }
            property_ref.set(property_data)


# Edit this to work with frontend
def fetch_user_tagged_properties(user_id):
    properties_ref = db.collection("properties")
    query = properties_ref.where(field_path="user_ids", op_string="array_contains", value=user_id)
    docs = query.stream()
    user_properties = []
    for doc in docs:
        property_data = doc.to_dict()
        user_properties.append(property_data)
    return user_properties


# have to change this function(instead of stroing all data on db, we store temporarly and then delete it after use)
# Fetch all properties from Firestore(by all, we mean the properties from inital response and tagged properties)
def fetch_all_properties():
    properties_ref = db.collection("properties")
    docs = properties_ref.stream()
    all_properties = []
    for doc in docs:
        property_data = doc.to_dict()
        all_properties.append(property_data)
    return all_properties


def preprocess_data(properties, user_id):
    df = pd.DataFrame(properties)
    df['user_id'] = user_id 
    df['combined_features'] = df.apply(lambda row: ' '.join([str(row['city']),str(row['propertyType']),str(row['numBedroom']),str(row['numBathroom']),
                                                             str(row['floorSizeValue']),str(row['mostRecentPriceAmount'])]), axis=1)
    return df


def train_svd_model(user_properties, user_id):
    df = preprocess_data(user_properties, user_id)
    df['rating'] = 1  # Use a constant rating since users have tagged these properties
    
    reader = Reader(rating_scale=(1, 1))
    data = Dataset.load_from_df(df[['user_id', 'id', 'rating']], reader)
    trainset = data.build_full_trainset()
    
    algo = SVD()
    algo.fit(trainset)
    
    return algo


def get_similar_properties(user_id, tagged_properties, user_preferences, top_n=4):
    
    # Extract relevant information from tagged properties
    # ask if city is a good feature to use as it is being assigned initially by user
    tagged_cities = set(property['city'] for property in tagged_properties)
    tagged_property_types = set(property['propertyType'] for property in tagged_properties)
    
    # Construct a new query based on tagged properties and user preferences
    new_query = (
        "country:\"US\" AND latitude:* AND longitude:* AND postalCode:* "
        "AND propertyType:(" + ' OR '.join([f'\"{prop}\"' for prop in tagged_property_types]) + ") "
        "AND city:(" + ' OR '.join([f'\"{city}\"' for city in tagged_cities]) + ")"
    )

    # change this to take the inital preferences
    # Add user preferences to the query
    min_budget = user_preferences.get("min_budget", 0)
    max_budget = user_preferences.get("max_budget", 10000000)
    min_bedrooms = user_preferences.get("min_bedrooms", 0)
    min_bathrooms = user_preferences.get("min_bathrooms", 0)
    city = user_preferences["city"]
    province = user_preferences["province"]
    
    new_query += f" AND mostRecentPriceAmount:[{min_budget} TO {max_budget}]"
    new_query += f" AND numBedroom:[{min_bedrooms} TO *]"
    new_query += f" AND numBathroom:[{min_bathrooms} TO *]"
    new_query += f' AND (province:"{province}")'
    new_query += f' AND (city:"{city}")'
    
    num_records = 5
    
    # Make a new API call to fetch properties based on the updated query
    fetched_properties = fetch_properties_from_api(new_query, num_records)
    
    return fetched_properties
