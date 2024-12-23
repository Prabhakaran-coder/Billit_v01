class Product {
  int? id;
  String itemName;
  int qty;
  int price;

  Product({this.id, required this.itemName, required this.qty,required this.price});

  // Convert a User object to a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'qty': qty,
      'price':price,
    };
  }

  // Convert a Map object to a User object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      itemName: map['itemName'],
      qty: map['qty'],
      price: map['price'],
    );
  }
}