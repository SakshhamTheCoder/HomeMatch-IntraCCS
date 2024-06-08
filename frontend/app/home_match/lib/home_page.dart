import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:home_match/views/listings.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _isRecommended = true;
  final List<ListingModel> listings = [];
  Map<String, dynamic>? preferences;
  bool _isLoading = false;

  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _minBedroomsController = TextEditingController();
  final _minBathroomsController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _propertyTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Tags',
            ),
          ],
          onTap: (index) {
            if (index == 1) {
              Navigator.pushNamed(context, '/tags/');
            }
          }),
      appBar: AppBar(
        title: const Text('HomeMatch'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            scrollable: true,
                            title: const Text('Search Listings'),
                            content: Column(
                              children: [
                                TextField(
                                  controller: _cityController,
                                  decoration: const InputDecoration(
                                    labelText: 'City',
                                    hintText: 'Ex: New York',
                                  ),
                                ),
                                TextField(
                                  controller: _provinceController,
                                  decoration: const InputDecoration(
                                    labelText: 'Province',
                                    hintText: 'Ex: CA',
                                  ),
                                ),
                                TextField(
                                  controller: _minBedroomsController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Min Bedrooms',
                                    hintText: 'Ex: 2',
                                  ),
                                ),
                                TextField(
                                  controller: _minBathroomsController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Min Bathrooms',
                                    hintText: 'Ex: 2',
                                  ),
                                ),
                                TextField(
                                  controller: _minPriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Min Price',
                                    hintText: 'Ex: 10000',
                                  ),
                                ),
                                TextField(
                                  controller: _maxPriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Max Price',
                                    hintText: 'Ex: 50000',
                                  ),
                                ),
                                DropdownButtonFormField(
                                  items: ['Apartment', 'Single Family Dwelling'].map((type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    _propertyTypeController.text = value.toString();
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Property Type',
                                    hintText: 'Ex: Apartment',
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                              TextButton(
                                onPressed: () {
                                  final city = _cityController.text;
                                  final province = _provinceController.text;
                                  final minBedrooms = _minBedroomsController.text;
                                  final minBathrooms = _minBathroomsController.text;
                                  final minPrice = _minPriceController.text;
                                  final maxPrice = _maxPriceController.text;
                                  final propertyType = _propertyTypeController.text;

                                  var body = {
                                    'city': city,
                                    'province': province,
                                    'min_bedrooms': int.parse(minBedrooms),
                                    'min_bathrooms': int.parse(minBathrooms),
                                    'min_budget': int.parse(minPrice),
                                    'max_budget': int.parse(maxPrice),
                                    'property_type': propertyType,
                                  };
                                  setState(() {
                                    preferences = body;
                                    _isLoading = true;
                                  });

                                  http
                                      .post(
                                    Uri.parse("http://127.0.0.1:8000/get_user_input"),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: json.encode(body),
                                  )
                                      .then((response) {
                                    if (response.statusCode == 200) {
                                      var queryStr = jsonDecode(response.body)['query'];
                                      print(queryStr);
                                      var numRecords = (jsonDecode(response.body)['num_records']);
                                      http.post(
                                          Uri.parse(
                                              "http://127.0.0.1:8000/fetch_properties_from_api?query=$queryStr&num_records=$numRecords"),
                                          headers: <String, String>{
                                            'Content-Type': 'application/json; charset=UTF-8',
                                          }).then((response) {
                                        if (response.statusCode == 200) {
                                          var properties = jsonDecode(response.body);
                                          setState(() {
                                            listings.clear();
                                          });
                                          print(properties.length);
                                          for (var property in properties) {
                                            print(
                                                'city: ${property['city']}, province: ${property['province']}, lat: ${property['latitute']}, lng: ${property['longitude']}, numBedroom: ${property['numBedroom']}, numBathroom: ${property['numBathroom']}, floorSizeValue: ${property['floorSizeValue']}, propertyType: ${property['propertyType']}, mostRecentPriceAmount: ${property['mostRecentPriceAmount']}, address: ${property['address']}');

                                            setState(() {
                                              listings.add(ListingModel(
                                                city: property['city'],
                                                province: property['province'],
                                                lat: property['latitute'],
                                                lng: property['longitude'],
                                                numBedroom: property['numBedroom'],
                                                numBathroom: property['numBathroom'],
                                                floorSizeValue: property['floorSizeValue'],
                                                propertyType: property['propertyType'],
                                                mostRecentPriceAmount: property['mostRecentPriceAmount'],
                                                address: property['address'],
                                              ));
                                            });
                                          }
                                        } else {
                                          print('Failed to fetch properties');
                                        }
                                      });
                                    } else {
                                      print('Failed to fetch properties');
                                    }
                                  }).whenComplete(() => setState(() {
                                            _isLoading = false;
                                          }));
                                  Navigator.pop(context);
                                },
                                child: const Text('Search'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Search Listings'),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: listings.isNotEmpty
                      ? ListView(
                          children: listings.map((listing) {
                          var city = listing.city ?? 'N/A';
                          var province = listing.province ?? 'N/A';
                          var address = listing.address ?? 'N/A';
                          var numBedroom = listing.numBedroom ?? 'N/A';
                          var numBathroom = listing.numBathroom ?? 'N/A';
                          var floorSizeValue = listing.floorSizeValue ?? 'N/A';
                          var propertyType = listing.propertyType ?? 'N/A';
                          var mostRecentPriceAmount = listing.mostRecentPriceAmount ?? 'N/A';

                          return Card(
                            child: ListTile(
                              leading: Image.network(
                                  "https://aliferous.ca/wp-content/uploads/2022/02/rental-listing-optimization-tips.jpg"),
                              title: Text(address),
                              subtitle: Text('${numBedroom} BHK, ${city} ${province}'),
                              trailing: Text('\$ ${mostRecentPriceAmount}'),
                              onTap: () async {
                                // if property is already present in one of the document in properties collection then update the userId in that
                                // document else add a new document in properties collection
                                if (await FirebaseFirestore.instance
                                    .collection('properties')
                                    .where('address', isEqualTo: listing.address)
                                    .where('price', isEqualTo: listing.mostRecentPriceAmount)
                                    .get()
                                    .then((value) => value.docs.isNotEmpty)) {
                                  if (await FirebaseFirestore.instance
                                      .collection('properties')
                                      .where('address', isEqualTo: listing.address)
                                      .where('price', isEqualTo: listing.mostRecentPriceAmount)
                                      .where('userId', arrayContains: widget.user!.uid)
                                      .get()
                                      .then((value) => value.docs.isNotEmpty)) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('You have already tagged this property!'),
                                    ));
                                    return;
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection('properties')
                                        .where('address', isEqualTo: listing.address)
                                        .where('price', isEqualTo: listing.mostRecentPriceAmount)
                                        .get()
                                        .then((value) {
                                      for (var element in value.docs) {
                                        element.reference.update({
                                          'userId': FieldValue.arrayUnion([widget.user!.uid])
                                        });
                                      }
                                    }).then((value) {
                                      http
                                          .post(Uri.parse(
                                              "http://127.0.0.1:8000/get_user_recommendations?user_id=${widget.user!.uid}&user_preferences=${jsonEncode(preferences)}"))
                                          .then((response) {
                                        if (response.statusCode == 200) {
                                          var properties = jsonDecode(response.body);
                                          print(properties.length);
                                          for (var property in properties) {
                                            print(
                                                'city: ${property['city']}, province: ${property['province']}, lat: ${property['latitute']}, lng: ${property['longitude']}, numBedroom: ${property['numBedroom']}, numBathroom: ${property['numBathroom']}, floorSizeValue: ${property['floorSizeValue']}, propertyType: ${property['propertyType']}, mostRecentPriceAmount: ${property['mostRecentPriceAmount']}, address: ${property['address']}');

                                            setState(() {
                                              listings.add(ListingModel(
                                                city: property['city'],
                                                province: property['province'],
                                                lat: property['latitute'],
                                                lng: property['longitude'],
                                                numBedroom: property['numBedroom'],
                                                numBathroom: property['numBathroom'],
                                                floorSizeValue: property['floorSizeValue'],
                                                propertyType: property['propertyType'],
                                                mostRecentPriceAmount: property['mostRecentPriceAmount'],
                                                address: property['address'],
                                              ));
                                            });
                                          }
                                        } else {
                                          print(response.body);
                                          print('Failed to fetch properties');
                                        }
                                      });
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Property tagged successfully!'),
                                    ));
                                    return;
                                  }
                                }
                                var doc1 = FirebaseFirestore.instance.collection('properties');
                                await doc1.add({
                                  'id': doc1.doc().id,
                                  'address': listing.address,
                                  'city': listing.city,
                                  'province': listing.province,
                                  'latitude': listing.lat,
                                  'longitude': listing.lng,
                                  'numBedroom': listing.numBedroom,
                                  'numBathroom': listing.numBathroom,
                                  'mostRecentPriceAmount': listing.mostRecentPriceAmount,
                                  'floorSizeValue': listing.floorSizeValue,
                                  'propertyType': listing.propertyType,
                                  'userId': [widget.user!.uid]
                                }).then((value) {
                                  http
                                      .post(Uri.parse(
                                          "http://127.0.0.1:8000/get_user_recommendations?user_id=${widget.user!.uid}&user_preferences=${jsonEncode(preferences)}"))
                                      .then((response) {
                                    if (response.statusCode == 200) {
                                      var properties = jsonDecode(response.body);
                                      print(properties.length);
                                      for (var property in properties) {
                                        print(
                                            'city: ${property['city']}, province: ${property['province']}, lat: ${property['latitute']}, lng: ${property['longitude']}, numBedroom: ${property['numBedroom']}, numBathroom: ${property['numBathroom']}, floorSizeValue: ${property['floorSizeValue']}, propertyType: ${property['propertyType']}, mostRecentPriceAmount: ${property['mostRecentPriceAmount']}, address: ${property['address']}');

                                        setState(() {
                                          listings.add(ListingModel(
                                            city: property['city'],
                                            province: property['province'],
                                            lat: property['latitute'],
                                            lng: property['longitude'],
                                            numBedroom: property['numBedroom'],
                                            numBathroom: property['numBathroom'],
                                            floorSizeValue: property['floorSizeValue'],
                                            propertyType: property['propertyType'],
                                            mostRecentPriceAmount: property['mostRecentPriceAmount'],
                                            address: property['address'],
                                          ));
                                        });
                                      }
                                    } else {
                                      print(response.body);
                                      print('Failed to fetch properties');
                                    }
                                  });
                                });
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Property tagged successfully!'),
                                ));
                              },
                            ),
                          );
                        }).toList())
                      : const Center(
                          child: Text(
                            'No listing found. Start searching and tagging!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
