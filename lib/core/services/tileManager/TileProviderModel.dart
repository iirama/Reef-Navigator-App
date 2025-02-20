import 'package:flutter/foundation.dart';

// this class is just a listener that enhances the map to refresh when certain changes happen, it is called in main.dart and in local tile provider.
class TileProviderModel extends ChangeNotifier {
  void notifyMapRefresh() {
    notifyListeners();
  }
}
