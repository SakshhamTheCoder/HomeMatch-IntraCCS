from firebase_admin import firestore, initialize_app
from firebase_admin import credentials
from functions import (
    get_user_input, fetch_properties_from_api, save_properties_to_csv, upload_properties_to_firestore,
    fetch_user_tagged_properties, fetch_all_properties, train_svd_model, get_similar_properties
)

# Initialize Firebase Admin SDK
cred = credentials.Certificate(r"C:\Users\aksha\code\CCSHACK\my-ccs-firebase-adminsdk-m88uu-c340c8b065.json")
initialize_app(cred)
db = firestore.client()


def main():
    user_id = "user1"  # Example user ID
    user_preferences = {
        "city": "San Francisco",
        "province": "CA",
        "min_budget": 12345,  # Optional
        "max_budget": 1234567,  # Optional
        "min_bedrooms": 3,  # Optional
        "min_bathrooms": 1,  # Optional
        "propertyType": ["Single Family", "Apartment"]  # Optional, e.g., "Single Family", "Condo", "Townhouse
    }
    
    query, num_records = get_user_input(user_preferences)
    
    # Fetch properties from the API
    fetched_properties = fetch_properties_from_api(query, num_records)
    
    # To Be Removed
    if fetched_properties:
        # Save fetched properties to CSV
        save_properties_to_csv(fetched_properties, 'fetched_properties.csv')
        # Upload fetched properties to Firestore
        upload_properties_to_firestore(fetched_properties, user_id)
    
    # Add function to deal with tagging of properties
    
    # Fetch tagged properties for the user from Firestore
    user_properties = fetch_user_tagged_properties(user_id)
    
    if not user_properties:
        print(f"No tagged properties found for user {user_id}")
        return
    
    # have to change this function(instead of stroing all data on db, we store temporarly and then delete it after use)
    # Fetch all properties from Firestore(by all, we mean the properties from inital response and tagged properties)
    all_properties = fetch_all_properties()
    
    # Train SVD model using tagged properties
    svd_model = train_svd_model(user_properties, user_id)
    
    # Get similar properties based on the trained model
    similar_properties = get_similar_properties(user_id, all_properties, user_preferences, svd_model)
    
    # Save similar properties to CSV
    save_properties_to_csv(similar_properties, 'similar_properties.csv')
    
    print("Recommended properties:")
    for property in similar_properties:
        print(property['address'], property['city'], property['propertyType'], property['numBedroom'], 
            property['numBathroom'], property['floorSizeValue'], property['mostRecentPriceAmount'], 
            property['predicted_rating'])

if __name__ == "__main__":
    main()
