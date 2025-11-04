import 'package:billit/database/product_database_helper.dart';
import 'package:billit/models/product_db_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentProvider extends ChangeNotifier {
  List<PaymentDetail> paymentsData = [];
  List<InvoiceHeader> invoiceData=[];
  final List<Map<String, dynamic>> _payments = []; 
  late ProductDatabaseHelper _databaseHelper;// Store payments
  final double _pendingAmount = 0.0; 
  
  double totalbill=0.0;
  double amountpaid=0;
  List<InvoiceHeader> invoiceHeader = [];
   List<InvoiceDetail> invoiceDetails = [];
   List<Customers> particularCustomerDetails = [];
   int index=0;
   String formattedDate="";
   double cumulativepayedAmount=0.0;
   bool paymentBtn=false;
   
   double pendingamount=0.0;// Track pending amount

double? pendingPayment;
String status="";
 List<PaymentDetail> _paymentsData = [];
  List<Map<String, dynamic>> get payments => _payments;
  double get pendingAmount => _pendingAmount;
  
 PaymentProvider() {
    _databaseHelper = ProductDatabaseHelper.instance; 
  }
   
  // Function to fetch payments from DB
  Future<void> fetchPayments(String? invoiceId) async {
    
     try {
      final fetchedPayments = await _databaseHelper.getPaymentData(invoiceId!);
      //final data = await _databaseHelper.getPaidPaymentData();
        paymentsData = fetchedPayments;
        
        
         formattedDate= paymentsData.isNotEmpty
    ? DateFormat('yyyy-MM-dd').format(DateTime.parse(paymentsData[0].dateofpayment))
    : "";
     
    } catch (e) {
      print('Error fetching products: $e');
    }

    notifyListeners(); 
  }

  Future<void> fetchpaidPayments() async {
    final data = await _databaseHelper.getPaidPaymentData();
        //paymentsData = fetchedPayments;
        for(int i=0;i<data.length;i++){
      amountpaid +=data[i].amountpaid!;
      
      }
   }   
   Future<void> loadInvoicess({String? invoiceId,String? customerName}) async {
    
    final header = await _databaseHelper.getSpecificInvoiceHeader(invoiceId!);
    final details = await _databaseHelper.getInvoiceDetails(invoiceId);
    final customerdetails=  await _databaseHelper.getParticularCustomer(customerName!);
     invoiceHeader = header;
     invoiceDetails = details; 
     particularCustomerDetails=customerdetails;
     cumulativepayedAmount = 0;
     
      for(int i=0;i<paymentsData.length;i++){
      cumulativepayedAmount +=paymentsData[i].amountpaid??0.0;
      
      }
        totalbill=invoiceHeader[0].totalAmount;
        if(cumulativepayedAmount!=totalbill){
        paymentBtn=false;
      }
      else{
        paymentBtn=true;
      }
        pendingamount=totalbill-cumulativepayedAmount;
         
       formattedDate= invoiceHeader.isNotEmpty
     
    ? DateFormat('yyyy-MM-dd').format(DateTime.parse(invoiceHeader[0].date))
    : "";
  
      notifyListeners(); 
  }
  
 Future <void> addPayments( {String? invoiceId,
  String? paymentMode,String? pendingAmount,String? cash}) async {
    final String paymentController = cash!;

    if (paymentController.isNotEmpty && paymentMode!.isNotEmpty) {
      final getPayment=await _databaseHelper.getPaymentData(invoiceId!);
      pendingPayment = (double.tryParse(paymentController) ?? 0) - (double.tryParse(pendingAmount!) ?? 0);
       if(pendingPayment==0.0){
        status="Paid";         
         }else{         
            status="Pending";         
         }
      final newPayment = PaymentDetail(invoiceId:invoiceId,dateofpayment:DateTime.now().toString(),amountpaid: double.tryParse(paymentController), paymentstatus: paymentMode,pendingamount:pendingPayment.toString(),status: status);
      var result = await _databaseHelper.insertPaymentData(newPayment);
      // _products=<product>[];
     
        _paymentsData = getPayment;
       //validatependingpayment=double.parse(widget.pendingamount);    
       
      notifyListeners();   
      
    }
  }

  Future<int?> fetchFullRecord() async {
    double? invoices;
    int? fetchFullRecordLength;
     try {
      final fetchedPayments = await _databaseHelper.getAllPaymentData();
      
        invoiceData = fetchedPayments;
        fetchFullRecordLength=invoiceData.length;
        for(int i=0;i<invoiceData.length;i++){
      invoices = invoices!+invoiceData[i].totalAmount;
      
      }
       
    } catch (e) {
      print('Error fetching products: $e');
    }
    return fetchFullRecordLength;
    //notifyListeners(); 
  }
  Future<int> fetchPayedInvoices() async {
  try {
    final fetchedPayments = await _databaseHelper.getPaidPaymentData();
    return fetchedPayments.length;
  } catch (e) {
    print('Error fetching products: $e');
    return 0;
  }
}
Future<int> fetchPendingInvoices() async {
  try {
    final fetchedPayments = await _databaseHelper.getPendingPaymentData();
    return fetchedPayments.length;
  } catch (e) {
    print('Error fetching products: $e');
    return 0;
  }
}
Future<int> getCustomerNames() async {
  try {
    final fetchedPayments = await _databaseHelper.getCustomers();
    return fetchedPayments.length;
  } catch (e) {
    print('Error fetching products: $e');
    return 0;
  }
}
Future<List<InvoiceSummary>> fetchInvoiceSummary() async {
  final data = await _databaseHelper.getInvoiceTotalsByMonth();
  return data.map((row) {
    return InvoiceSummary(
      month: row['month'],
      total: (row['total'] as num).toDouble(),
    );
  }).toList();
}

}
