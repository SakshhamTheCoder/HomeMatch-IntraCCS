import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_match/provider.dart';
import 'package:home_match/views/listings.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouriteProvider>(context);
    List<ListingModel> _foundUsers = provider.favourites
        .map((id) => ListingModel.getListings()
            .firstWhere((element) => element.id == int.parse(id)))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Listings'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
