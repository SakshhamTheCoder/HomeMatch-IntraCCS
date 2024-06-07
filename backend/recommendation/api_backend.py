from fastapi import FastAPI
from pydantic import BaseModel
import os
import requests
import pandas as pd
from surprise import Dataset, Reader, SVD
from typing import List
from firebase_admin import credentials, firestore, initialize_app
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

# Initialize Firebase Admin SDK
cred = credentials.Certificate("my-ccs-firebase-adminsdk-m88uu-159e3d5c8b.json")
initialize_app(cred)
db = firestore.client()


class UserPreferences(BaseModel):
    min_budget: float
    max_budget: float
    min_bedrooms: int
    min_bathrooms: int
    city: str
    province: str
    property_type: str


class UploadPropertiesRequest(BaseModel):
    records: List[dict]
    user_id: str


class PreprocessDataRequest(BaseModel):
    properties: list
    user_id: str


class GetSimilarPropertiesRequest(BaseModel):
    user_id: str
    tagged_properties: list
    user_preferences: dict


@app.post("/get_user_input")
async def get_user_input(user_preferences: UserPreferences):
    # Retrieve user preferences with default values
    min_budget = user_preferences.min_budget
    max_budget = user_preferences.max_budget
    min_bedrooms = user_preferences.min_bedrooms
    min_bathrooms = user_preferences.min_bathrooms
    city = user_preferences.city
    province = user_preferences.province
    property_type = user_preferences.property_type

    query = (
        'country:"US" AND latitude:* AND longitude:* AND postalCode:* AND address:*'
        "AND floorSizeValue:* AND lotSizeValue:* AND mostRecentPriceAmount:*"
        "AND numBathroom:* AND numBedroom:* AND numFloor:* AND numRoom:*"
        "AND numUnit:* AND numParkingSpaces:* AND parkingTypes:*"
        'AND mostRecentStatus:("For Sale" OR "Rental")'
    )

    # Format the user preferences into the query
    query += f" AND mostRecentPriceAmount:[{min_budget} TO {max_budget}]"
    query += f" AND numBedroom:[{min_bedrooms} TO *]"
    query += f" AND numBathroom:[{min_bathrooms} TO *]"
    query += f' AND (province:"{province}")'
    query += f' AND (city:"{city}")'

    # Add user-preferred property types to the query
    if property_type:
        # property_type_query = " OR ".join([f'"{prop}"' for prop in property_type])
        query += f" AND propertyType:({property_type})"

    num_records = 5
    print(
        min_budget,
        max_budget,
        min_bedrooms,
        min_bathrooms,
        city,
        province,
        property_type,
    )

    return {"query": query, "num_records": num_records}


@app.post("/fetch_properties_from_api")
async def fetch_properties_from_api(query: str, num_records: int):
    api_url = "https://api.datafiniti.co/v4/properties/search"
    api_token = os.getenv("API_KEY")
    headers = {
        "Authorization": f"Bearer {api_token}",
        "content-type": "application/json",
    }

    payload = {
        "query": query,
        "num_records": num_records,
        "format": "JSON",
    }

    response = requests.post(api_url, json=payload, headers=headers)

    if response.status_code == 200:
        print(response.content)
        data = response.json()
        return data.get("records", [])
    else:
        print(f"Failed to fetch properties: {response.status_code}")
        return []


@app.post("/upload_properties_to_firestore")
async def upload_properties_to_firestore(request: UploadPropertiesRequest):
    records = request.records
    user_id = request.user_id

    for property in records:
        property_id = property["id"]
        property_ref = db.collection("properties").document(property_id)
        property_doc = property_ref.get()

        if property_doc.exists:
            existing_data = property_doc.to_dict()
            existing_user_ids = existing_data.get("user_ids", [])

            if user_id not in existing_user_ids:
                existing_user_ids.append(user_id)
                property_ref.update({"user_ids": existing_user_ids})
        else:
            property_data = {
                "id": property["id"],
                "address": property["address"],
                "propertyType": property["propertyType"],
                "numBedroom": property["numBedroom"],
                "numBathroom": property["numBathroom"],
                "floorSizeValue": property["floorSizeValue"],
                "mostRecentPriceAmount": property["mostRecentPriceAmount"],
                "latitude": property["latitude"],
                "longitude": property["longitude"],
                "city": property["city"],
                "province": property["province"],
                "postalCode": property["postalCode"],
                "user_ids": [user_id],
            }
            property_ref.set(property_data)


@app.post("/fetch_user_tagged_properties")
async def fetch_user_tagged_properties(user_id: str):
    properties_ref = db.collection("properties")
    query = properties_ref.where(
        field_path="user_ids", op_string="array_contains", value=user_id
    )
    docs = query.stream()
    user_properties = []
    for doc in docs:
        property_data = doc.to_dict()
        user_properties.append(property_data)
    return user_properties


@app.post("/preprocess_data")
async def preprocess_data_endpoint(request: PreprocessDataRequest):
    properties = request.properties
    user_id = request.user_id
    df = pd.DataFrame(properties)
    df["user_id"] = user_id
    df["combined_features"] = df.apply(
        lambda row: " ".join(
            [
                str(row["city"]),
                str(row["propertyType"]),
                str(row["numBedroom"]),
                str(row["numBathroom"]),
                str(row["floorSizeValue"]),
                str(row["mostRecentPriceAmount"]),
            ]
        ),
        axis=1,
    )
    return df.to_dict(orient="records")


@app.post("/train_svd_model")
async def train_svd_model_endpoint(user_properties: list, user_id: str):
    df = pd.DataFrame(user_properties)
    df["user_id"] = user_id
    df["rating"] = 1

    reader = Reader(rating_scale=(1, 1))
    data = Dataset.load_from_df(df[["user_id", "id", "rating"]], reader)
    trainset = data.build_full_trainset()

    algo = SVD()
    algo.fit(trainset)

    return {"message": "SVD model trained successfully"}


@app.post("/get_similar_properties")
async def get_similar_properties_endpoint(request: GetSimilarPropertiesRequest):
    user_id = request.user_id
    tagged_properties = request.tagged_properties
    user_preferences = request.user_preferences

    # Extract relevant information from tagged properties
    tagged_cities = set(property["city"] for property in tagged_properties)
    tagged_property_type = set(
        property["propertyType"] for property in tagged_properties
    )

    # Construct a new query based on tagged properties and user preferences
    new_query = (
        'country:"US" AND latitude:* AND longitude:* AND postalCode:* '
        "AND propertyType:("
        + " OR ".join([f'"{prop}"' for prop in tagged_property_type])
        + ") "
        "AND city:(" + " OR ".join([f'"{city}"' for city in tagged_cities]) + ")"
    )

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
