import 'package:flutter_bloc_demo/landing/models/landing_item.dart';
import 'package:flutter_bloc_demo/landing/networking/landing_networking.dart';

class LandingRepository {
  late LandingNetworking _networking;
  int _count = 0;

  LandingRepository({LandingNetworking? networking}) {
    _networking = networking ?? LandingNetworking();
  }

  Future<List<LandingItem>> loadItems() {
    if (_count == 0) {
      _count++;
      throw Exception("Something went wrong fetching data");
    }
    return _networking.fetchItems();
  }
}
