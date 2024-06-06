import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_match/views/listings.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _isRecommended = true;
  final List<ListingModel> listings = [];

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
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
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
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
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
                                    hintText: 'Ex: 4',
                                  ),
                                ),
                                TextField(
                                  controller: _minPriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Min Price',
                                    hintText: 'Ex: 1000',
                                  ),
                                ),
                                TextField(
                                  controller: _maxPriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Max Price',
                                    hintText: 'Ex: 1000',
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

                                    http.post(Uri.parse("http://127.0.0.1:8000/get_user_properties"), body: {
                                      'city': city,
                                      'province': province,
                                      'min_bedrooms': minBedrooms,
                                      'min_bathrooms': minBathrooms,
                                      'min_budget': minPrice,
                                      'max_budget': maxPrice,
                                      'property_type': propertyType,
                                    }).then((response) {
                                      if (response.statusCode == 200) {
                                        var queryStr = jsonDecode(response.body)['query'];
                                        http
                                            .post(Uri.parse(
                                                "http://127.0.0.1:8000/fetch_properties_from_api?query=$queryStr?num_records=5"))
                                            .then((response) {
                                          if (response.statusCode == 200) {
                                            var properties = jsonDecode(response.body)['records'];
                                            print(properties);
                                            properties.forEach((property) {
                                              setState(() {
                                                listings.add(ListingModel(
                                                    city: property['city'],
                                                    province: property['province'],
                                                    lat: property['latitute'],
                                                    lng: property['longitude'],
                                                    numBedroom: property['numBedroom'],
                                                    numBathroom: property['numBathroom'],
                                                    floorSizeValue: property['floorSizeValue'],
                                                    propertyType: property['property_type'],
                                                    mostRecentPriceAmount: property['prices']['amountMax']));
                                              });
                                            });
                                          } else {
                                            print(response.body);
                                            print('Failed to fetch propertie2s');
                                          }
                                        });
                                      } else {
                                        print(response.body);
                                        print('Failed to fetch properties');
                                      }
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: const Text('Search')),
                            ],
                          );
                        });
                  },
                  child: Text('Search Listings')),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: listings.isNotEmpty
                    ? ListView(
                        children: listings.map((listing) {
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                                "https://aliferous.ca/wp-content/uploads/2022/02/rental-listing-optimization-tips.jpg"),
                            title: Text(listing.address!),
                            subtitle: Text('${listing.numBedroom} BHK, sqft, ${listing.city}'),
                            trailing: Text('₹ ${listing.mostRecentPriceAmount}'),
                            onTap: () async {
                              // if property is already present in one of the document in properties collecction then update the userid in that
                              // document else add a new document in properties collection
                              if (await FirebaseFirestore.instance
                                  .collection('properties')
                                  .where('address', isEqualTo: listing.address)
                                  .get()
                                  .then((value) => value.docs.isNotEmpty)) {
                                await FirebaseFirestore.instance
                                    .collection('properties')
                                    .where('address', isEqualTo: listing.address)
                                    .get()
                                    .then((value) async {
                                  var docId = value.docs[0].id;
                                  var userIds = value.docs[0].data()['userId'];
                                  userIds.add(widget.user!.uid);
                                  await FirebaseFirestore.instance.collection('properties').doc(docId).update({
                                    'userId': userIds,
                                  });
                                });
                              }
                              await FirebaseFirestore.instance.collection('properties').add({
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
                                'userId': [
                                  widget.user!.uid,
                                ]
                              });
                            },
                          ),
                        );
                      }).toList())
                    : const Center(
                        child: Text(
                        'No listing found. Start searching and tagging!',
                        textAlign: TextAlign.center,
                      )))
          ])),
    );
  }
}
