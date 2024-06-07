class ListingModel {
  var address;
  var city;
  var province;
  var lat;
  var lng;
  var numBedroom;
  var numBathroom;
  var floorSizeValue;
  var mostRecentPriceAmount;
  var postalCode;
  var propertyType;

  ListingModel({
    this.address,
    this.city,
    this.province,
    this.lat,
    this.lng,
    this.numBedroom,
    this.numBathroom,
    this.floorSizeValue,
    this.mostRecentPriceAmount,
    this.postalCode,
    this.propertyType,
  });

  // static List<ListingModel> getListings() {
  //   List<ListingModel> listings = [];

  //   listings.add(
  //     ListingModel(
  //       id: 1,
  //       name: '2 BHK Apartment',
  //       image: './photos/house.jpg',
  //       bhk: 2,
  //       area: 1200,
  //       price: 20000000,
  //       location: 'Koramangala',
  //     ),
  //   );
  //   listings.add(ListingModel(
  //     id: 2,
  //     name: '3 BHK Apartment',
  //     image: './photos/house.jpg',
  //     bhk: 3,
  //     area: 1500,
  //     price: 25000000,
  //     location: 'Indiranagar',
  //   ));
  //   listings.add(ListingModel(
  //     id: 3,
  //     name: '1 BHK Apartment',
  //     image: './photos/house.jpg',
  //     bhk: 1,
  //     area: 800,
  //     price: 15000000,
  //     location: 'HSR Layout',
  //   ));
  //   listings.add(ListingModel(
  //     id: 4,
  //     name: '4 BHK Apartment',
  //     image: './photos/house.jpg',
  //     bhk: 4,
  //     area: 2000,
  //     price: 30000000,
  //     location: 'Whitefield',
  //   ));
  //   listings.add(ListingModel(
  //     id: 5,
  //     name: '2 BHK Apartment',
  //     image: './photos/house.jpg',
  //     bhk: 2,
  //     area: 1200,
  //     price: 20000000,
  //     location: 'Koramangala',
  //   ));
  //   listings.add(ListingModel(
  //     id: 6,
  //     name: '3 BHK Apartment',
  //     image: './photos/house.jpg',
  //     bhk: 3,
  //     area: 1500,
  //     price: 25000000,
  //     location: 'Indiranagar',
  //   ));
  //   listings.add(ListingModel(
  //     id: 7,
  //     name: '1 BHK Apartment',
  //     image: './photos/house.jpg',
  //     bhk: 1,
  //     area: 800,
  //     price: 15000000,
  //     location: 'HSR Layout',
  //   ));
  //   listings.add(ListingModel(
  //     id: 8,
  //     name: '4 BHK Apartment',
  //     image: './photos/house.jpg',
  //     bhk: 4,
  //     area: 2000,
  //     price: 30000000,
  //     location: 'Whitefield',
  //   ));
  //   return listings;
  // }
  static toMap(ListingModel listing) {
    return {
      'address': listing.address,
      'city': listing.city,
      'province': listing.province,
      'latitude': listing.lat,
      'longitude': listing.lng,
      'numBedroom': listing.numBedroom,
      'numBathroom': listing.numBathroom,
      'floorSizeValue': listing.floorSizeValue,
      'mostRecentPriceAmount': listing.mostRecentPriceAmount,
      'postalCode': listing.postalCode,
    };
  }
}
