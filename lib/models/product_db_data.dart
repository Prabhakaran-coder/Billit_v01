class Product {
  int? id;
  String itemName;
  int qty;
  double price;
  int cgst;
  int sgst;
  Product({this.id, required this.itemName, required this.qty,required this.price,required this.cgst,required this.sgst});

  // Convert a User object to a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'qty': qty,
      'price':price,
      'cgst':cgst,
      'sgst':sgst
    };
  }

  // Convert a Map object to a User object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      itemName: map['itemName'],
      qty: map['qty'],
      price: map['price'],
      cgst: map['cgst'],
      sgst: map['sgst']
    );
  }
}

class Customers{
  int? id;
  String customerName;
  String customerAddress;
  String state;
  int customerContact;
  String gst;

  Customers({this.id, required this.customerName, required this.customerAddress,required this.customerContact,required this.state,required this.gst});

  // Convert a User object to a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerContact':customerContact,
      'state':state,
      'gst':gst,
    };
  }

  // Convert a Map object to a User object
  factory Customers.fromMap(Map<String, dynamic> map) {
    return Customers(
      id: map['id'],
      customerName: map['customerName'],
      customerAddress: map['customerAddress'],
      customerContact: map['customerContact'],
      state: map['state'],
      gst:map['gst'],
    );
  }
}
class InvoiceHeader {
 
  final String invoiceId;
  String customerName;
  double subtotal;
  double cgst;
  double sgst;
  double igst;
  double totalAmount;
  String date;
  String isGstApplicable;
  InvoiceHeader({
    required this.invoiceId,
    required this.customerName,
    required this.subtotal,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.totalAmount,
    required this.date,
    required this.isGstApplicable,
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceId':invoiceId,
      'customerName': customerName,
      'subtotal': subtotal,
      'cgst': cgst,
      'sgst': sgst,
      'igst':igst,
      'totalAmount': totalAmount,
      'date': date,
      'isGstApplicable': isGstApplicable,
    };
  }
   factory InvoiceHeader.fromMap(Map<String, dynamic> map) {
    return InvoiceHeader(
      invoiceId: map['invoiceId'],
      customerName: map['customerName'],
      subtotal: map['subtotal'],
      cgst: map['cgst'],
      sgst: map['sgst'],
      igst:map['igst'],
      totalAmount:map['totalAmount'],
      date:map['date'],
      isGstApplicable: map['isGstApplicable'],
    );
  }
}

class InvoiceDetail {

  final String invoiceId;
  final String productName;
  final int quantity;
  final double price;
  final double amount;

  InvoiceDetail({
   
    required this.invoiceId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'amount': amount,
    };
  }
   factory InvoiceDetail.fromMap(Map<String, dynamic> map) {
    return InvoiceDetail(
    
      invoiceId: map['invoiceId'],
      productName: map['productName'],
      quantity: map['quantity'],
      price: map['price'],
      amount:map['amount'],
      
    );
  }
}
