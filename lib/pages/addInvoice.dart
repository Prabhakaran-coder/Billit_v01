import 'package:billit/models/product_db_data.dart';
import 'package:billit/models/textOverFlow.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:billit/database/product_database_helper.dart';

class DynamicTable extends StatefulWidget {
  const DynamicTable({super.key});

  @override
  State<DynamicTable> createState() => _DynamicTableState();
}

class _DynamicTableState extends State<DynamicTable> {
  late ProductDatabaseHelper _databaseHelper;
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedName;
  String? _printName="";
  String? _selectedProduct;
  String? _selectedCustomerState;
  List<String> _customerNames = [];
  List<Product> _products = [];
  List<Customers> _customerTable=[];
  final List<Map<String, dynamic>> _tableData = [];
  bool gst = false;
  bool isDropdownEnabled = true;
  bool productSelected=false;
  int No=0;
  double subtotal=0;
  int cgst=0;
  int sgst=0;
  double? cgstPerProduct;
  double? sgstPerProduct;
  double? cgstamount;
  double? sgstamount;
  double? igstamount;
  double? totalAmount;
  double? totalAmountIgst;
  @override
  void initState() {
    super.initState();
    _databaseHelper = ProductDatabaseHelper.instance;
    _fetchCustomerNames();
    _fetchProducts();
    _fetchCustomers();
  }

  Future<void> _fetchCustomerNames() async {
     final List<String> fetchedCustomerNames;
    try {
      if(gst==true){
          fetchedCustomerNames = await _databaseHelper.getGstCustomerNames();
      }
      else{
           fetchedCustomerNames = await _databaseHelper.getCustomerNames();
      }
      setState(() {
        _customerNames = fetchedCustomerNames;
      });
    } catch (e) {
      print('Error fetching customer names: $e');
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final fetchedProducts = await _databaseHelper.getProduct();
      setState(() {
        _products = fetchedProducts;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }
  Future<void> _fetchCustomers() async {
    try {
      final fetchedCustomers = await _databaseHelper.getCustomers();
      setState(() {
        _customerTable = fetchedCustomers;
      });
    } catch (e) {
      print('Error fetching customerTable: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: SingleChildScrollView(
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
            height: MediaQuery.of(context).size.width * 0.05,
            color: Colors.blue, 
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                 IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                  Navigator.pop(context, true); 
                },
            ),
                Text("Invoice", style: TextStyle(color: Colors.white, fontSize: 20.0),),
              ],
            ),
          ), 
            Column(
              children: [
                  Padding(padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
              children: [
                const Text(
                  "GST",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
                ),
                Switch(
                  value: gst,
                  activeColor: Colors.green.shade400,
                  dragStartBehavior: DragStartBehavior.start,
                  onChanged: isDropdownEnabled? (bool value) {
                    print("dropdown $isDropdownEnabled");
                    setState(() {
                      gst = value;
                      _fetchCustomerNames();
                    });
                    print("Gst $gst");
                  }
                  :null,
                 
                ),
                 
              ],
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors.white, 
                              shadowColor: Colors.white, 
                              // Removes shadow
                            ),
                          child: DropdownButtonFormField(
                             isExpanded: true,
                            focusColor: Colors.white,
                            decoration: const InputDecoration(
                              labelText: "Select Customer",
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                             dropdownColor: Colors.white, 
                            value: _selectedName,
                            hint: const Text('Select Name'),
                            items: _customerNames.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                           
                            onChanged: isDropdownEnabled ? (newValue) {
                              setState(() {
                                _selectedName = newValue as String?;
                                 try {
                                final selectedCustomer = _customerTable.firstWhere(
                                  (customer) => customer.customerName == newValue,
                                );
                                _selectedCustomerState = selectedCustomer.state;
                                   print("Selected Customer State: ${_selectedCustomerState!}");
                              } catch (e) {
                                print("Customer not found: $e");
                              }
                                print("Selected value: $newValue");
                                print("Customer table: ${_customerTable.map((e) => e.customerName).toList()}");
                    
                              });
                    
                            }
                            :null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                           isExpanded: true,
                          focusColor: Colors.white,
                          decoration: const InputDecoration(
                            labelText: "Select Product",
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          value: _selectedProduct,
                          hint: const Text('Select Product'),
                          items: _products.map((Product product) {
                            return DropdownMenuItem<String>(
                              value: product.itemName,
                              child: Text(product.itemName),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedProduct = newValue;
                              final selectedProduct = _products.firstWhere(
                                (product) => product.itemName == newValue,
                              );
                             
                              _priceController.text =
                              selectedProduct.price.toString();
                              cgst=selectedProduct.cgst;
                              sgst=selectedProduct.sgst;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Product can\'t be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _qtyController,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Qty can\'t be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Price name can\'t be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                       style: TextButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0), 
                          ),
                          padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0), 
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                          
                            print("Validation Succuessful");
                          } else {
                            print("Validation failed");
                          }
                          if (_selectedName != null &&
                              _selectedProduct != null &&
                              _qtyController.text.isNotEmpty &&
                              _priceController.text.isNotEmpty) {
                            setState(() {
                            
                              totalAmount=0;
                              No=No+1;
                              subtotal=subtotal+(double.tryParse(_qtyController.text)! * double.tryParse(_priceController.text)!);
                              if(_selectedCustomerState =="Tamilnadu" && gst==true){
                              cgstPerProduct=((cgst/100)*(double.tryParse(_qtyController.text)! * double.tryParse(_priceController.text)!));
                              sgstPerProduct=((sgst/100)*(double.tryParse(_qtyController.text)! * double.tryParse(_priceController.text)!));
                              cgstamount = (cgstamount ?? 0) + (cgst / 100) * (double.tryParse(_qtyController.text)! * double.tryParse(_priceController.text)!);
                              sgstamount = (sgstamount ?? 0) + (sgst / 100) * (double.tryParse(_qtyController.text)! * double.tryParse(_priceController.text)!);
                              totalAmount=(subtotal + cgstamount! + sgstamount!);
                              
                              }
                             else if(_selectedCustomerState !="Tamilnadu"&& gst==true){
                             cgstamount = (cgstamount ?? 0) + (cgst / 100) * (double.tryParse(_qtyController.text)! * double.tryParse(_priceController.text)!);
                             sgstamount = (sgstamount ?? 0) + (sgst / 100) * (double.tryParse(_qtyController.text)! * double.tryParse(_priceController.text)!);
                             igstamount=(cgstamount!+sgstamount!).toDouble();
                             totalAmount=subtotal+igstamount!;
                             }
                             else{                              
                              totalAmount=subtotal;
                             }
                              _tableData.add({
                                'No': No,
                                'Product': _selectedProduct!,
                                'Qty': _qtyController.text,
                                'Price': _priceController.text,
                                'Amount': (double.tryParse(_qtyController.text)! * double.tryParse(_priceController.text)!).toString(),
                                'cgst':cgstPerProduct.toString(),
                                'sgst':sgstPerProduct.toString(),
                              });
                               productSelected=true;
                               isDropdownEnabled=false;
                               _printName=_selectedName;
                              _selectedProduct = null;
                              _qtyController.clear();
                              _priceController.clear();
                            });
                          }
                          
                        },
                        
                        child: const Text('Add to Table'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
             const SizedBox(height: 10),
            
            Text("Customer : ${_printName!}",style: TextStyle(fontSize:15.0,fontWeight: FontWeight.w500),),
            const SizedBox(height: 16),
            Container(
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView(
                  children: [
                    DataTable(
                       headingTextStyle: TextStyle(color: Color(0xFF667085)),
                  dataTextStyle:
                      TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                  dividerThickness: 0.4,
                  headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      return Color(0xFFF0F1F3);
                    },
                  ),
                      columns: const [
                        DataColumn(label: Text('No')),
                        DataColumn(label: Text('Product')),
                        DataColumn(label: Text('Qty')),
                        DataColumn(label: Text('Price')),
                         DataColumn(label: Text('cgst')),
                         DataColumn(label: Text('sgst')),
                         DataColumn(label: Text('Amount')),
                      ],
                      rows: _tableData
                          .map(
                            (data) => DataRow(
                              cells: [
                                 DataCell(Tooltip(message: data['No'].toString(),child: TextOverflowByChars(
                                  fontSize: 14,
                                      text:data['No'].toString(),
                                      maxCharacters: 6,
                                    ))),
                                DataCell(Tooltip(message: data['Product'],child: TextOverflowByChars(
                                      text:data['Product'],
                                      maxCharacters: 6,
                                      fontSize: 14,
                                    ))),
                                DataCell(Tooltip(message: data['Qty'],child: TextOverflowByChars(
                                      text:data['Qty'],
                                      maxCharacters: 6,
                                      fontSize: 14,
                                    ))),
                                DataCell(Tooltip(message: data['Price'],child: TextOverflowByChars(
                                      text:data['Price'],
                                      maxCharacters: 6,
                                      fontSize: 14,
                                    ))), 
                                     DataCell(Tooltip(message: data['cgst'],child: TextOverflowByChars(
                                      text:data['cgst'],
                                      maxCharacters: 6,
                                      fontSize: 14,
                                    ))), 
                                     DataCell(Tooltip(message: data['sgst'],child: TextOverflowByChars(
                                      text:data['sgst'],
                                      maxCharacters: 6,
                                      fontSize: 14,
                                    ))), 
                                 DataCell(Tooltip(message: data['Amount'],child: TextOverflowByChars(
                                      text:data['Amount'],
                                      maxCharacters: 6,
                                      fontSize: 14,
                                    ))),    
                                
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Container(
                width: 200,
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("SUBTOTAL",style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF667085)),),
                        Text(subtotal.toString(),style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF333843)),),
                      ],
                    ),
                    SizedBox(height: 3.0,),
                   if(gst&&productSelected&&_selectedCustomerState=="Tamilnadu")...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("CGST",style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF667085))),
                        Text((cgstamount!).toString(),style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF333843))),
                      ],
                    ),
                    SizedBox(height: 3.0,),
                    Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("SGST",style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF667085))),
                        Text((sgstamount!).toString(),style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF333843))),
                      ],
                    ),
                     Divider(height: 5.0,),
                   Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount",style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(totalAmount.toString(),style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                   ]
                   else if(gst&&productSelected&&_selectedCustomerState !="Tamilnadu")...[
                     Divider(height: 3.0,),
                   Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("IGST",style: TextStyle(fontWeight: FontWeight.w600)),
                        Text((igstamount).toString(),style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Divider(height: 5.0,),
                   Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount",style: TextStyle(fontWeight: FontWeight.w600)),
                        Text((totalAmount).toString(),style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                   ]
                   else...[
                     Divider(height: 5.0,),
                   Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount",style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(subtotal.toString(),style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                   ]
                  
                  ],
                ),
              )
            ],),
            SizedBox(height: 20.0),
             Row(
              mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 TextButton(
                           style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF1EB386),
                            foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0), 
                              ),
                              padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0),
                            ),
                            onPressed: () {
                             saveInvoice(gst);
                             setState(() {
                                isDropdownEnabled=true;
                                gst=false;                                
                                Navigator.pop(context,true);
                             });
                            },
                            child: const Text('Save'),
                          ),
               ],
             ),
                    ],
                  ),
                  )
              ],
            ),
                    
          ],
        ),
      ),
    );
  }

  void saveInvoice(bool isGstApplicable) async {
  // : Generate the Invoice ID
  String invoiceId = await generateInvoiceId(isGstApplicable);

  //Save Invoice Header
  InvoiceHeader header = InvoiceHeader(
    invoiceId: invoiceId, 
    customerName: _printName!,
    subtotal: subtotal,
    cgst: isGstApplicable ? cgstamount! : 0,
    sgst: isGstApplicable ? sgstamount! : 0,
    igst:(igstamount != null && igstamount! > 0) ? igstamount! : 0,
    totalAmount: totalAmount!,
    date: DateTime.now().toIso8601String(),
    isGstApplicable: isGstApplicable ? 'true':'false',
  );
  await _databaseHelper.insertInvoiceHeader(header);

  // Step 3: Save Invoice Details
  for (var row in _tableData) {
    InvoiceDetail detail = InvoiceDetail(
      // Assuming `detailId` is auto-incremented
      invoiceId: invoiceId, // Use the same invoice ID
      productName: row['Product'],
      quantity: int.parse(row['Qty']),
      price: double.parse(row['Price']),
      amount: double.parse(row['Amount']),
      cgstPerProduct:isGstApplicable ?double.parse(row['cgst']):0,
      sgstPerProduct: isGstApplicable ?double.parse(row['sgst']):0,
    );
    await _databaseHelper.insertInvoiceDetail(detail);
  }

  print('Invoice saved successfully!');
}


Future<String> generateInvoiceId(bool isGstApplicable) async {
  final now = DateTime.now();

  // Get current year and month
  String year = now.year.toString();
  String month = now.month.toString().padLeft(2, '0');

  // Query the latest invoice ID from the database
  String? latestInvoiceId =
      await _databaseHelper.getLatestInvoiceIdForMonth(year, month,isGstApplicable);

  // Calculate the next sequence number
  int nextNumber;
  if (latestInvoiceId != null) {
    // Extract the last 4 digits (sequence number)
    String lastSequence = latestInvoiceId.split('-').last;
    nextNumber = int.parse(lastSequence) + 1; 
  } else {
    // Start from 1 if no existing invoices
    nextNumber = 1;
  }

  // Format the next number to 4 digits
  String sequenceNumber = nextNumber.toString().padLeft(4, '0');
   String prefix = isGstApplicable ? "Y" : "N";
  // Generate the full invoice ID
  return "$prefix-$year-$month-$sequenceNumber";
}

}
