// import 'dart:ffi';
// import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_match/favouriteListing.dart';
import 'package:home_match/provider.dart';
import 'package:home_match/views/listings.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ListingModel> _foundUsers = ListingModel.getListings();
  double _minArea = 100;
  double _maxArea = 10000;
  double _minPrice = 1000000;
  double _maxPrice = 100000000;
  late RangeValues _areaValues;
  late RangeValues _priceValues;

  void _getInitialInfo() {
    _foundUsers = ListingModel.getListings();
    _minArea = _foundUsers
        .map((user) => user.area)
        .reduce((min, area) => min < area ? min : area) as double;
    _maxArea = _foundUsers
        .map((user) => user.area)
        .reduce((max, area) => max > area ? max : area) as double;

    _priceValues = RangeValues(
      _foundUsers
          .map((user) => user.price)
          .reduce((min, price) => min < price ? min : price),
      _foundUsers
          .map((user) => user.price)
          .reduce((max, price) => max > price ? max : price),
    );
    _areaValues = RangeValues(
      _foundUsers
          .map((user) => user.area)
          .reduce((min, area) => min < area ? min : area) as double,
      _foundUsers
          .map((user) => user.area)
          .reduce((max, area) => max > area ? max : area) as double,
    );
    // _setRangeArea();
    // _setRangePrice();
  }

  void _runFilter2() {
    List<ListingModel> results = [];
    results = ListingModel.getListings()
        .where((user) =>
            user.area >= _areaValues.start &&
            user.area <= _areaValues.end &&
            user.price >= _priceValues.start &&
            user.price <= _priceValues.end)
        .toList();
    setState(() {
      _foundUsers = results;
    });
  }

  void _runFilter1(String enteredKeyword) {
    List<ListingModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = ListingModel.getListings();
    } else {
      results = ListingModel.getListings()
              .where((user) => user.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList() +
          ListingModel.getListings()
              .where((user) => user.location
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList() +
          ListingModel.getListings()
              .where((user) =>
                  user.area.toString().contains(enteredKeyword.toLowerCase()))
              .toList() +
          ListingModel.getListings()
              .where((user) =>
                  user.bhk.toString().contains(enteredKeyword.toLowerCase()))
              .toList() +
          ListingModel.getListings()
              .where((user) =>
                  user.price.toString().contains(enteredKeyword.toLowerCase()))
              .toList();
    }

    setState(() {
      _foundUsers = results;
    });
  }

  void _setRangeArea() {
    _maxArea = _foundUsers[0].area as double;
    _minArea = _foundUsers[0].area as double;
    for (int i = 0; i < _foundUsers.length; i++) {
      if (_foundUsers[i].area < _minArea) {
        _minArea = _foundUsers[i].area as double;
      }
      if (_foundUsers[i].area > _maxArea) {
        _maxArea = _foundUsers[i].area as double;
      }
    }
    _areaValues = RangeValues(_minArea, _maxArea);
  }

  void _setRangePrice() {
    _maxPrice = _foundUsers[0].price;
    _minPrice = _foundUsers[0].price;
    for (int i = 0; i < _foundUsers.length; i++) {
      if (_foundUsers[i].price < _minPrice) {
        _minPrice = _foundUsers[i].price;
      }
      if (_foundUsers[i].price > _maxPrice) {
        _maxPrice = _foundUsers[i].price;
      }
    }
    _priceValues = RangeValues(_minPrice, _maxPrice);
  }

  // final _isRecommended = true;
  bool settingVariable = true;
  @override
  Widget build(BuildContext context) {
    _getInitialInfo();
    final provider = Provider.of<FavouriteProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeMatch'),
          centerTitle: true,
        ),
        //
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                  onChanged: (value) => _runFilter1(value),
                  decoration: InputDecoration(
                    labelText: 'Search',
                    // suffixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        settingVariable = !settingVariable;
                        setState(() {});
                      },
                    ),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            settingVariable
                ? Expanded(
                    child: _foundUsers.length == 0
                        ? const Center(
                            child: Text(
                            'No recommendations found. Start searching and tagging!',
                            textAlign: TextAlign.center,
                          ))
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.builder(
                              itemCount: _foundUsers.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  key: ValueKey(_foundUsers[index].id),
                                  elevation: 4,
                                  margin: const EdgeInsets.all(8),
                                  child: ListTile(
                                    leading: Image.network(
                                        "https://aliferous.ca/wp-content/uploads/2022/02/rental-listing-optimization-tips.jpg"),
                                    title: Text(_foundUsers[index].name),
                                    subtitle: Text(
                                        '${_foundUsers[index].bhk} BHK, ${_foundUsers[index].area} sqft, ${_foundUsers[index].location}'),
                                    // trailing:
                                    //     Text('₹ ${_foundUsers[index].price}'),
                                    trailing: IconButton(
                                      icon: Icon(provider.isFavourite(
                                              _foundUsers[index].id.toString())
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                      onPressed: () {
                                        provider.toggleFavourite(
                                            _foundUsers[index].id.toString());
                                        // _foundUsers.removeAt(index);
                                        // setState(() {});
                                      },
                                    ),
                                    //                     ),
                                  ),
                                );
                              },
                            ),
                          ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Area'),
                      Center(
                          child: RangeSlider(
                        values: _areaValues,
                        min: _minArea,
                        max: _maxArea,
                        onChanged: (newValues) {
                          if (kDebugMode) {
                            print(
                                "${_areaValues.start.round()} ${_areaValues.end.round()}");
                          }
                          setState(() {
                            _areaValues = newValues;
                          });
                        },
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Price'),
                      Center(
                        child: RangeSlider(
                          values: _priceValues,
                          min: _minPrice,
                          max: _maxPrice,
                          onChanged: (newValues) {
                            if (kDebugMode) {
                              print(
                                  "${_priceValues.start.round()} ${_priceValues.end.round()}");
                            }
                            setState(() {
                              _priceValues = newValues;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final route = MaterialPageRoute(
              builder: (context) => FavouritePage(),
            );
            Navigator.push(context, route);
          },
          child: const Icon(Icons.favorite),
        ));
  }
}




// Sakshham's Code for reference
//  body: Padding(
      //     padding: const EdgeInsets.all(20),
      //     child: Column(children: [
      //       SearchAnchor.bar(
      //         suggestionsBuilder: (context, controller) {
      //           return ListingModel.getListings().map((listing) {
      //             return ListTile(
      //               title: Text(listing.name),
      //               onTap: () {
      //                 controller.text = listing.name;
      //               },
      //             );
      //           }).toList();
      //         },
      //         barHintText: 'Search for areas, localities, etc.',
      //         onSubmitted: (query) {
      //           print('Searching for $query');
      //         },
      //       ),
      //       const SizedBox(height: 20),
      //       Expanded(
      //           child: _isRecommended
      //               ? ListView(
      //                   children: ListingModel.getListings().map((listing) {
      //                   return Card(
      //                     child: ListTile(
      //                       leading: Image.network(
      //                           "https://aliferous.ca/wp-content/uploads/2022/02/rental-listing-optimization-tips.jpg"),
      //                       title: Text(listing.name),
      //                       subtitle: Text(
      //                           '${listing.bhk} BHK, ${listing.area} sqft, ${listing.location}'),
      //                       trailing: Text('₹ ${listing.price}'),
      //                     ),
      //                   );
      //                 }).toList())
      //               : const Center(
      //                   child: Text(
      //                   'No recommendations found. Start searching and tagging!',
      //                   textAlign: TextAlign.center,
      //                 )))
      //     ])),