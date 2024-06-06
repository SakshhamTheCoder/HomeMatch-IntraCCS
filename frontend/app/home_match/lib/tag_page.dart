import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_match/provider.dart';
import 'package:home_match/views/listings.dart';
import 'package:provider/provider.dart';

class TagPage extends StatelessWidget {
  const TagPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _isRecommended = true;
    final listings = <ListingModel>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Listings'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: _isRecommended
                    ? ListView(
                        children: listings.map((listing) {
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                                "https://aliferous.ca/wp-content/uploads/2022/02/rental-listing-optimization-tips.jpg"),
                            title: Text(listing.address!),
                            subtitle: Text('${listing.numBedroom} BHK, sqft, ${listing.city}'),
                            trailing: Text('₹ ${listing.price}'),
                          ),
                        );
                      }).toList())
                    : const Center(
                        child: Text(
                        'No recommendations found. Start searching and tagging!',
                        textAlign: TextAlign.center,
                      )))
          ],
        ),
      ),
    );
  }
}
