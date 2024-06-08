from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os
import requests
import pandas as pd
from surprise import Dataset, Reader, SVD
from typing import List, Dict, Any
from firebase_admin import credentials, firestore, initialize_app
from dotenv import load_dotenv
import logging
import json

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
    records: List[Dict[str, Any]]
    user_id: str


class GetUserRecommendationsRequest(BaseModel):
    user_id: str
    user_preferences: UserPreferences


class FetchPropertiesRequest(BaseModel):
    query: str
    num_records: int


@app.post("/get_user_input")
async def get_user_input(user_preferences: UserPreferences):
    min_budget = user_preferences.min_budget
    max_budget = user_preferences.max_budget
    min_bedrooms = user_preferences.min_bedrooms
    min_bathrooms = user_preferences.min_bathrooms
    city = user_preferences.city
    province = user_preferences.province
    property_type = user_preferences.property_type

    query = (
        "floorSizeValue:[1 TO *] AND mostRecentPriceAmount:[1 TO *]"
        ' AND mostRecentStatus:("For Sale" OR "Rental")'
    )

    query += f" AND {{prices.amountMin:[{min_budget} TO {max_budget}] AND prices.currency:USD}}"
    query += f" AND numBedroom:[{min_bedrooms} TO *]"
    query += f" AND numBathroom:[{min_bathrooms} TO *]"
    query += f' AND province:("{province}")'
    query += f' AND city:("{city}")'

    if property_type:
        query += f' AND propertyType:"{property_type}"'

    num_records = 10
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
    logging.info(f"API response status: {response.status_code}")
    logging.info(f"API response content: {response.content}")

    if response.status_code == 200:
        data = response.json()
        return data.get("records", [])
    else:
        logging.error(f"Failed to fetch properties: {response.content}")
        raise HTTPException(
            status_code=response.status_code, detail="Failed to fetch properties"
        )


@app.post("/get_user_recommendations")
async def get_user_recommendations_endpoint(user_id: str, user_preferences):

    user_preferences = json.loads(user_preferences)

    properties_ref = db.collection("properties")
    query = properties_ref.where("userId", "array_contains", user_id)
    docs = query.stream()
    tagged_properties = [doc.to_dict() for doc in docs]

    if not tagged_properties:
        raise HTTPException(
            status_code=404, detail="No tagged properties found for the user"
        )

    if not all("id" in prop for prop in tagged_properties):
        raise HTTPException(status_code=500, detail="Missing 'id' in some properties")

    df = pd.DataFrame(tagged_properties)
    df["user_id"] = user_id
    df["combined_features"] = df.apply(
        lambda row: " ".join(
            [
                str(row.get("city", "")),
                str(row.get("propertyType", "")),
                str(row.get("numBedroom", "")),
                str(row.get("numBathroom", "")),
                str(row.get("floorSizeValue", "")),
                str(row.get("mostRecentPriceAmount", "")),
            ]
        ),
        axis=1,
    )
    df["rating"] = 1

    reader = Reader(rating_scale=(1, 1))
    data = Dataset.load_from_df(df[["user_id", "id", "rating"]], reader)
    trainset = data.build_full_trainset()

    algo = SVD()
    algo.fit(trainset)

    tagged_cities = set(property["city"] for property in tagged_properties)
    tagged_property_type = set(
        property["propertyType"] for property in tagged_properties
    )

    new_query = (
        'country:"US" AND latitude:* AND longitude:* AND postalCode:* '
        "AND propertyType:("
        + " OR ".join([f'"{prop}"' for prop in tagged_property_type])
        + ") "
        "AND city:(" + " OR ".join([f'"{city}"' for city in tagged_cities]) + ")"
    )

    min_budget = user_preferences.get("min_budget", 0)
    max_budget = user_preferences.get("max_budget", 10000000)
    min_bedrooms = user_preferences.get("min_bedrooms", 1)
    min_bathrooms = user_preferences.get("min_bathrooms", 1)
    city = user_preferences.get("city", "")
    province = user_preferences.get("province", "")

    new_query += f" AND numBedroom:[{min_bedrooms} TO *]"
    new_query += f" AND numBathroom:[{min_bathrooms} TO *]"
    new_query += f' AND (province:"{province}")'
    new_query += f' AND (city:"{city}")'
    new_query += f" AND {{prices.amountMin:[{min_budget} TO {max_budget}] AND prices.currency:USD}}"

    num_records = 5

    fetched_properties = await fetch_properties_from_api(
        query=new_query, num_records=num_records
    )

    return fetched_properties
