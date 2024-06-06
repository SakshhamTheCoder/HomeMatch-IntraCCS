import 'package:flutter/foundation.dart';

class FavouriteProvider extends ChangeNotifier {
  final List<String> _favourites = [];

  List<String> get favourites => _favourites;

  void toggleFavourite(String id) {
    if (_favourites.contains(id)) {
      _favourites.remove(id);
    } else {
      _favourites.add(id);
    }
    notifyListeners();
  }

  bool isFavourite(String id) {
    return _favourites.contains(id);
  }

  void resetFavourites() {
    _favourites.clear();
    notifyListeners();
  }
}
