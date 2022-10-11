import 'package:flutter_bloc_demo/landing/models/landing_item.dart';

class LandingNetworking {
  Future<List<LandingItem>> fetchItems() {
    return Future.delayed(
      const Duration(seconds: 2),
      () => [
        LandingItem(title: "Health"),
        LandingItem(title: "Insure"),
        LandingItem(title: "Vitality")
      ],
    );
  }
}
