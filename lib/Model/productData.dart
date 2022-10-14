class ProductData {
  String id;
  String article;
  String name;
  int cost;
  int oldCost;
  String description;
  int rest;
  List<String> images;
  ProductData(
      {this.id,
      this.name = "testName",
      this.cost,
      this.oldCost,
      this.article,
      this.images,
      this.description,
      this.rest}) {
    if (images == null) images = [];
    if (cost == null) cost = 0;
    if (oldCost == null) oldCost = 0;
    if (rest == null) rest = 0;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['article'] = article;
    map['name'] = name;
    map['cost'] = cost;
    map['oldCost'] = oldCost;
    map['description'] = description;
    map['images'] = images.toList();
    map['rest'] = rest;
    return map;
  }
}
