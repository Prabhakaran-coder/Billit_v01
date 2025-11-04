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
class Profile{
  int? id;
  String profileName;
  String profileAddress;
  String state;
  String district;
  int profileContact;
  String emailAddress;
  int pincode;
  String gst;

  Profile({
    this.id, 
    required this.profileName, 
    required this.profileAddress,
    required this.profileContact,
    required this.emailAddress,
    required this.district,
    required this.state,
    required this.pincode,
    required this.gst});

  // Convert a User object to a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileName': profileName,
      'profileAddress': profileAddress,
      'profileContact':profileContact,
      'emailAddress':emailAddress,
      'district':district,
      'state':state,
      'pincode':pincode,
      'gst':gst,
    };
  }

  // Convert a Map object to a User object
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      profileName: map['profileName'],
      profileAddress: map['profileAddress'],
      profileContact: map['profileContact'],
      emailAddress:map['emailAddress'],
      district: map['district'],
      state: map['state'],
      pincode:map['pincode'],
      gst: map['gst'],
    );
  }
}

class Customers{
  int? id;
  String customerName;
  String customerAddress;
  String state;
  String district;
  int customerContact;
  String customeremailContact;
  int customerPincode;
  String gst;

  Customers({
    this.id, required this.customerName, 
    required this.customerAddress,
    required this.customerContact,
    required this.customeremailContact,
    required this.state,
    required this.district,
    required this.gst,
    required this.customerPincode});

  // Convert a User object to a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerContact':customerContact,
      'customeremailContact':customeremailContact,
      'state':state,
      'district':district,
      'customerPincode':customerPincode,
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
      customeremailContact: map['customeremailContact'],
      district: map['district'],
      state: map['state'],
      customerPincode:map['customerPincode'],
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
  final cgstPerProduct;
  final sgstPerProduct;

  InvoiceDetail({
   
    required this.invoiceId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.amount,
     required this.cgstPerProduct,
      required this.sgstPerProduct,
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'amount': amount,
      'cgstPerProduct':cgstPerProduct,
      'sgstPerProduct':sgstPerProduct
    };
  }
   factory InvoiceDetail.fromMap(Map<String, dynamic> map) {
    return InvoiceDetail(
    
      invoiceId: map['invoiceId'],
      productName: map['productName'],
      quantity: map['quantity'],
      price: map['price'],
      amount:map['amount'],
      cgstPerProduct:map['cgstPerProduct'],
      sgstPerProduct:map['sgstPerProduct']      
    );
  }
}

class PaymentDetail {

  final String invoiceId;
  final String dateofpayment;
  final double? amountpaid;
  final String pendingamount;
  final String paymentstatus;
  final String status;
  final String? upiRefId; 

  PaymentDetail({
   
    required this.invoiceId,
    required this.dateofpayment,
    required this.amountpaid,
    required this.pendingamount,
    required this.paymentstatus,
    required this.status,
    this.upiRefId,
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'dateofpayment': dateofpayment,
      'amountpaid': amountpaid,
      'pendingamount': pendingamount,
      'paymentstatus': paymentstatus,
      'status':status,
      'upiRefId': upiRefId,
    };
  }
   factory PaymentDetail.fromMap(Map<String, dynamic> map) {
    return PaymentDetail(
    
      invoiceId: map['invoiceId'],
      dateofpayment: map['dateofpayment'],
      amountpaid: map['amountpaid'],
      pendingamount: map['pendingamount'],
      paymentstatus:map['paymentstatus'],
      status: map['status'],
      upiRefId: map['upiRefId'],
    );
  }
}

class AdminSignUp{

  final String username;
  final String emailid;
  final String password;
  
  AdminSignUp({   
    required this.username,
    required this.emailid,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'emailid': emailid,
      'password': password,
    };
  }
   factory AdminSignUp.fromMap(Map<String, dynamic> map) {
    return AdminSignUp(    
      username: map['username'],
      emailid: map['emailid'],
      password: map['password'],
      );
  }
}

class InvoiceSummary {
  final String month;
  final double total;

  InvoiceSummary({required this.month, required this.total});
}
class ProductSales {
  final String name;
  final int count;

  ProductSales({required this.name, required this.count});
}
