import 'package:billit/database/product_database_helper.dart';
import 'package:billit/models/product_db_data.dart';
import 'package:billit/models/textOverFlow.dart';
import 'package:billit/pages/invoicepdfview.dart';
import 'package:flutter/material.dart';

class homeinvoicetable extends StatefulWidget {
  const homeinvoicetable({super.key});

  @override
  State<homeinvoicetable> createState() => _homeinvoicetableState();
}

class _homeinvoicetableState extends State<homeinvoicetable> {
  final bool _shouldRebuild = false;
  late ProductDatabaseHelper _databaseHelper;
  int _currentPage = 0;
  //String status="Pending";
  List<String> invoiceStatuses = []; 
  final int _itemsPerPage = 8;
   late Future<List<PaymentDetail>> _paymentsData;
   List<InvoiceHeader> currentInvoice=[];
 
  String extractedInvoice="";
  late Future<List<InvoiceHeader>> _invoices;
  List<InvoiceHeader> invoices = <InvoiceHeader>[];

    @override
  void initState() {
    super.initState();
    _databaseHelper = ProductDatabaseHelper.instance;
    _loadInvoicess();
    _fetchPaymentDataForInvoices();
   
    //print("currentInvoice : ${currentInvoice[0].invoiceId}");
  }
  void _loadInvoicess() {
    setState(() {
      _invoices = _databaseHelper.getAllInvoiceHeader();      
    });
  }
 // List to hold the status for each invoice

Future<void> _fetchPaymentDataForInvoices() async {
  try {
    // Ensure invoices are loaded first
    final invoiceList = await _invoices;

    for (var invoice in invoiceList) {
      extractedInvoice = invoice.invoiceId; // Extract invoiceId
      final fetchedPayments = await _databaseHelper.getPaymentData(extractedInvoice);
    if(fetchedPayments.isEmpty) {
        setState(() {
         
          invoiceStatuses.add("Pending");
          // print("No payment record found for invoice ${extractedInvoice}, using default status.");
        });
      }
      else{
        setState(() {
          
          invoiceStatuses.add(fetchedPayments[fetchedPayments.length - 1].status);
          //print("Status of invoice ${extractedInvoice}: ${fetchedPayments[fetchedPayments.length - 1].status}");
        });
      } 
    }
  } catch (e) {
    print('Error fetching payment data: $e');
  }
}
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: FutureBuilder<List<InvoiceHeader>>(
        future: _databaseHelper.getAllInvoiceHeader(),
        builder: (BuildContext context, AsyncSnapshot<List<InvoiceHeader>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found.'));
          }

          // Get the product list from snapshot data
          invoices = snapshot.data!;

           
          // Calculate the items for the current page
          int startIndex = _currentPage * _itemsPerPage;
          int endIndex = (_currentPage + 1) * _itemsPerPage;
          endIndex = endIndex > invoices.length ? invoices.length : endIndex;
          currentInvoice = invoices.sublist(startIndex, endIndex);

          if (invoiceStatuses.length < invoices.length) {
            invoiceStatuses.add("Pending"); 
          }
          
          return Column(
            children: [
              DataTable(
                columnSpacing: 109.0,
                //decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(20))),
                headingTextStyle: TextStyle(color: Color.fromARGB(255, 86, 85, 85)),
                headingRowHeight: 40,
                dataTextStyle:
                    TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                dividerThickness: 0.4,
                headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    return Color.fromARGB(54, 126, 161, 250);
                  },
                ),
              
                columns: [
                   DataColumn(label: Text("No")),
                  DataColumn(label: Text("Invoice")),
                  DataColumn(label: Text("Customer Name")),
                  DataColumn(label: Text("Total Amount")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Action")),                    
                ],
                
                rows: List.generate(
                  currentInvoice.length,
                  
                  (index) => _buildDataRow(
                    context,
                    startIndex + index,
                    currentInvoice[index].invoiceId,
                    currentInvoice[index].customerName,
                    currentInvoice[index].totalAmount.toString(),
                     invoiceStatuses.length >= (startIndex + index) 
        ? invoiceStatuses[startIndex + index] 
        : "Pending",
                  ),
                ),
              ),
             
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _currentPage > 0
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                          }
                        : null,
                        style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Color(0xFFFFFFFF); 
                    }
                    return Color(0xFFFFFFFF); 
                  },
                ),
                overlayColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                     return Color.fromARGB(255, 215, 132, 59); 
                    }
                    return Color.fromARGB(255, 255, 254, 254); 
                  },
                ),
                backgroundColor: WidgetStateProperty.all(Colors.black),
              ),
                    child: Text("Previous"),
                  ),
                  Text("Page ${_currentPage + 1} of ${((invoices.length - 1) / _itemsPerPage).ceil()}",style: TextStyle(fontWeight: FontWeight.w600),),
                  ElevatedButton(
                    onPressed: (_currentPage + 1) * _itemsPerPage < invoices.length
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                          }
                        : null,
                        style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Color(0xFFFFFFFF);}
                    return Color(0xFFFFFFFF); },
                ),
                overlayColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Color.fromARGB(255, 215, 132, 59); 
                    }
                    return Color.fromARGB(255, 255, 255, 255); 
                  },
                ),
                backgroundColor: WidgetStateProperty.all(Colors.black),
              ),
                    child: Text("Next"),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  DataRow _buildDataRow(
    BuildContext context,
    int index,
    String invoiceId,
    String customerName,
    String totalAmount,
    String status,
   
  ) {
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Tooltip(message: invoiceId,child: TextOverflowByChars(
        text:invoiceId,
        fontSize: 14,
        //maxCharactersPerLine: 15,
        maxCharacters: 15,
              ))),
         DataCell(Tooltip(message: customerName,child: TextOverflowByChars(
                 text:customerName,
                 fontSize: 14,
                 //maxCharactersPerLine: 30,
                 maxCharacters: 30,
               ))),
         DataCell(Tooltip(message: totalAmount,child: TextOverflowByChars(
                 text:totalAmount,
                 fontSize: 14,
                 //maxCharactersPerLine: 10,
                 maxCharacters: 15,
               ))),
               if(status=="Pending")...{
                DataCell(Tooltip(message: status,child: 
                
               Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(color: const Color.fromARGB(255, 254, 211, 215),borderRadius: BorderRadius.all(Radius.circular(3))),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                    Icon(Icons.refresh_rounded,size: 14,),
                      SizedBox(width: 5,),
                     TextOverflowByChars(
                     
                       text:status,
                       fontSize: 14,
                       //maxCharactersPerLine: 10,
                       maxCharacters: 15,
                     ),
                   ],
                 ),
               ))),
               }else...{
                DataCell(Tooltip(message: status,child: 
                
               Container(
                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                decoration: BoxDecoration(color: const Color.fromARGB(255, 208, 246, 209),borderRadius: BorderRadius.all(Radius.circular(3))),
                 child: Row(
                   children: [
                    Icon(Icons.done,size: 14,),
                    SizedBox(width: 5,),
                     TextOverflowByChars(
                     
                       text:status,
                       fontSize: 14,
                       //maxCharactersPerLine: 10,
                       maxCharacters: 15,
                     ),
                   ],
                 ),
               ))),
               },
               
       DataCell(_buildRowWithHover(context,invoiceId,customerName)),
      ],
    );
  }

   Widget _buildRowWithHover(BuildContext context,String invoiceId,String customerName) {
    return PopupMenuButton(
      padding: EdgeInsets.all(0),
      menuPadding: EdgeInsets.all(0),
      constraints: BoxConstraints(maxHeight: 150.0, maxWidth: 60.0),
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: const Color.fromARGB(255, 145, 249, 149),
            ),
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/viewicon.png",
                  color: Colors.green,
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
          onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => invoicepdfview(invoiceId: invoiceId,customerName: customerName,)),
              );
          },
        ),
        
        PopupMenuItem(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 240, 157, 157),
              borderRadius: BorderRadius.circular(3),
            ),
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/deleteicon.png",
                  color: const Color.fromARGB(255, 235, 98, 79),
                ),
              ],
            ),
          ),
          onTap: () {
        //     Customers Customerss = invoice[invoiceId];
        //     // Handle "Delete" action
        //  _showDeleteDialog(Customers: Customerss);
          },
        ),
      ],
    );
  }
}

