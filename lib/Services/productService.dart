import 'package:foodislife/Model/productData.dart';

class ProductService {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Products');
  final CollectionReference _sections =
      FirebaseFirestore.instance.collection('Types');

  Future<List<dynamic>> sections() async {
    List<dynamic> sections = <dynamic>[];

    var query = await _sections.get();

    for (int i = 0; i < query.docs.length; i++) {
      sections.add({
        'id': query.docs[i].id.toString(),
        'name': query.docs[i]['name'].toString(),
        'image': query.docs[i]['image'].toString()
      });
    }

    return sections;
  }

  Future<List<ProductData>> products(String sectionKey) async {
    List<ProductData> products = <ProductData>[];

    DocumentSnapshot productSnapshot =
        await _sections.doc(sectionKey).get().then((doc) => doc);

    final Map<String, dynamic> productMap = productSnapshot.data()['products'];
    var keyList = productMap.keys.toList();

    var productsQuery =
        await _products.where(FieldPath.documentId, whereIn: keyList).get();

    for (int i = 0; i < productsQuery.docs.length; i++) {
      products.add(ProductData(
        id: productsQuery.docs[i].id,
        name: productsQuery.docs[i]['name'],
        cost: productsQuery.docs[i]['cost'],
        image: productsQuery.docs[i]['image'],
      ));
    }
    return products;
  }
}
