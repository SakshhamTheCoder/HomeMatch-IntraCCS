import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_match/views/listings.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _isRecommended = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeMatch'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            SearchAnchor.bar(
              suggestionsBuilder: (context, controller) {
                return ListingModel.getListings().map((listing) {
                  return ListTile(
                    title: Text(listing.name),
                    onTap: () {
                      controller.text = listing.name;
                    },
                  );
                }).toList();
              },
              barHintText: 'Search for areas, localities, etc.',
              onSubmitted: (query) {
                print('Searching for $query');
              },
            ),
            const SizedBox(height: 20),
            Expanded(
                child: _isRecommended
                    ? ListView(
                        children: ListingModel.getListings().map((listing) {
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                                "https://aliferous.ca/wp-content/uploads/2022/02/rental-listing-optimization-tips.jpg"),
                            title: Text(listing.name),
                            subtitle: Text('${listing.bhk} BHK, ${listing.area} sqft, ${listing.location}'),
                            trailing: Text('₹ ${listing.price}'),
                          ),
                        );
                      }).toList())
                    : const Center(
                        child: Text(
                        'No recommendations found. Start searching and tagging!',
                        textAlign: TextAlign.center,
                      )))
          ])),
    );
  }
}
