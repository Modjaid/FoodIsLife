import 'package:foodislife/Model/productData.dart';

class BacketData {
  final Map<String, BacketStuff> _products = Map<String, BacketStuff>();

  List<ProductData> get products {
    List<ProductData> products = [];
    _products.forEach((key, value) {
      products.add(value.product);
    });

    return products;
  }

  int getProductCount(ProductData product) {
    return (_products.containsKey(product.id))
        ? _products[product.id].count
        : 0;
  }

  int getProductCash(ProductData product) {
    int productCost = (_products.containsKey(product.id))
        ? _products[product.id].product.cost
        : 0;

    return productCost * _products[product.id].count;
  }

  int get commonProductCount {
    int count = 0;
    _products.forEach((key, value) => count += value.count);
    return count;
  }

  int get commonCash {
    int count = 0;
    _products.forEach((key, value) {
      int cash = value.product.cost * value.count;
      count += cash;
    });

    return count;
  }

  void updBacket(ProductData product, int count) {
    // _products.putIfAbsent(product, () => 1);
    _products[product.id] = BacketStuff(product, count);
    if (_products[product.id].count <= 0) _products.remove(product.id);
  }
}

class BacketStuff {
  ProductData product;
  int count;
  BacketStuff(this.product, this.count);
}
