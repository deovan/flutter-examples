class ItemSize {
  String name;
  num price;
  int stock;

  bool get hasStock => stock > 0;

  ItemSize({this.name, this.price, this.stock});

  @override
  String toString() {
    return 'ItemSize{name: $name, price: $price, stock: $stock}';
  }

  ItemSize.fromMap(Map<String, dynamic> map) {
    name = map['name'] as String;
    price = map['price'] as num;
    stock = map['stock'] as int;
  }

  ItemSize clone() => ItemSize(
        stock: stock,
        name: name,
        price: price,
      );

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "stock": stock,
    };
  }
}
