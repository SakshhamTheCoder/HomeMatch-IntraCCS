
class ListingModel {
  String name;
  String image;
  int bhk;
  int area;
  double price;
  String location;
  ListingModel({
    required this.name,
    required this.image,
    required this.bhk,
    required this.area,
    required this.price,
    required this.location,
  });

  static List<ListingModel> getListings() {
    List<ListingModel> listings = [];

    listings.add(
      ListingModel(
        name: '2 BHK Apartment',
        image: './photos/house.jpg',
        bhk: 2,
        area: 1200,
        price: 20000000,
        location: 'Koramangala',
      ),
    );
    listings.add(ListingModel(
      name: '3 BHK Apartment',
      image: './photos/house.jpg',
      bhk: 3,
      area: 1500,
      price: 25000000,
      location: 'Indiranagar',
    ));
    listings.add(ListingModel(
      name: '1 BHK Apartment',
      image: './photos/house.jpg',
      bhk: 1,
      area: 800,
      price: 15000000,
      location: 'HSR Layout',
    ));
    listings.add(ListingModel(
      name: '4 BHK Apartment',
      image: './photos/house.jpg',
      bhk: 4,
      area: 2000,
      price: 30000000,
      location: 'Whitefield',
    ));
    listings.add(ListingModel(
      name: '2 BHK Apartment',
      image: './photos/house.jpg',
      bhk: 2,
      area: 1200,
      price: 20000000,
      location: 'Koramangala',
    ));
    listings.add(ListingModel(
      name: '3 BHK Apartment',
      image: './photos/house.jpg',
      bhk: 3,
      area: 1500,
      price: 25000000,
      location: 'Indiranagar',
    ));
    listings.add(ListingModel(
      name: '1 BHK Apartment',
      image: './photos/house.jpg',
      bhk: 1,
      area: 800,
      price: 15000000,
      location: 'HSR Layout',
    ));
    listings.add(ListingModel(
      name: '4 BHK Apartment',
      image: './photos/house.jpg',
      bhk: 4,
      area: 2000,
      price: 30000000,
      location: 'Whitefield',
    ));
    return listings;
  }
}
