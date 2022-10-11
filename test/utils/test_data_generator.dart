import 'package:flutter_bloc_demo/landing/models/landing_item.dart';

class TestDataGenerator {
  static List<LandingItem> get mockedItems => [
        LandingItem(title: "Health"),
        LandingItem(title: "Insure"),
        LandingItem(title: "Vitality")
      ];
}
