import 'package:flutter/material.dart';
import 'package:home_match/views/listings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              barHintText: 'Search for properties',
              onSubmitted: (query) {
                print('Searching for $query');
              },
            ),
            const SizedBox(height: 20),
            Expanded(
                child: ListView(
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
            }).toList()))
          ])),
    );
  }
}
