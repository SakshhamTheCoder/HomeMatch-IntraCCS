import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_match/provider.dart';
import 'package:home_match/views/listings.dart';
import 'package:provider/provider.dart';

class TagPage extends StatefulWidget {
  const TagPage({super.key});

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  final listings = <ListingModel>[];
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('properties').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        print(data['userId']);
        if (data['userId'].contains(FirebaseAuth.instance.currentUser!.uid)) {
          print("found");
          final listing = ListingModel(
            address: data['address'],
            city: data['city'],
            numBedroom: data['numBedroom'],
            mostRecentPriceAmount: data['mostRecentPriceAmount'],
          );
          setState(() {
            listings.add(listing);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tagged Properties'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: listings.isNotEmpty
                    ? ListView(
                        children: listings.map((listing) {
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                                "https://aliferous.ca/wp-content/uploads/2022/02/rental-listing-optimization-tips.jpg"),
                            title: Text(listing.address ?? 'N/A'),
                            subtitle: Text('${listing.numBedroom ?? 'N/A'} BHK, ${listing.city ?? 'N/A'}'),
                            trailing: Text('₹ ${listing.mostRecentPriceAmount ?? 'N/A'}'),
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
