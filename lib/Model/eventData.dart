import 'package:flutter/material.dart';
import 'package:foodislife/Model/backetData.dart';
import 'package:foodislife/Model/productData.dart';

class EventData with ChangeNotifier {
  final BacketData _backet = BacketData();

  BacketData get backet => _backet;

  void changeBacketCount(
      {@required ProductData product, @required bool isAdd}) {
    int count = backet.getProductCount(product);
    count = (isAdd) ? ++count : --count;
    backet.updBacket(product, count);

    notifyListeners();
  }
}
