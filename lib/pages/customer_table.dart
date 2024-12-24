import 'package:billit/database/product_database_helper.dart';
import 'package:billit/models/product_db_data.dart';
import 'package:billit/models/textOverFlow.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomerTable extends StatefulWidget {
  const CustomerTable({super.key});

  @override
  State<CustomerTable> createState() => _CustomerTableState();
}

class _CustomerTableState extends State<CustomerTable> {
  bool gst = false;
  late ProductDatabaseHelper _databaseHelper;
  final TextEditingController _customerNameController = TextEditingController();
    final TextEditingController _customerAddressController = TextEditingController();
    final TextEditingController _customerContactController = TextEditingController();
    final TextEditingController _gstController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Future<List<Customers>> _Customers;
  List<Customers> Customer = <Customers>[];

  // Pagination variables
  int _currentPage = 0;
  final int _itemsPerPage = 8;
  void _updateCustomer(int id) async {
      final String customerNameController = _customerNameController.text;
      final String customerAddressController = _customerAddressController.text;
      final int customerContactController = int.tryParse(_customerContactController.text)??0;
      final String gstNumber = gst ? _gstController.text.trim() : "";

      
      if (customerNameController.isNotEmpty && customerAddressController.isNotEmpty&& customerContactController>0) {
         final newCustomer = Customers(id: id,customerName: customerNameController, customerAddress: customerAddressController, customerContact: customerContactController,gst:gstNumber);
        await _databaseHelper.updateCustomers(newCustomer);
        setState(() {
          _Customers = _databaseHelper.getCustomers();
        });

      _customerNameController.clear();
      _customerAddressController.clear();
      _customerContactController.clear();
      _gstController.clear();
        // widget.onUpdate();
      }
    }
  @override
  void initState() {
    super.initState();
    _databaseHelper = ProductDatabaseHelper.instance;
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _Customers = _databaseHelper.getCustomers();
    });
  }

  void _refreshProductList() {
    _loadProducts(); // Refresh the product list
  }

  void _deleteCustomers(int id) async {
    await _databaseHelper.deleteCustomers(id);
    setState(() {
      _Customers = _databaseHelper.getCustomers();
    });
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
      child: FutureBuilder<List<Customers>>(
        future: _databaseHelper.getCustomers(),
        builder: (BuildContext context, AsyncSnapshot<List<Customers>> snapshot) {
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
          Customer = snapshot.data!;

          // Calculate the items for the current page
          int startIndex = _currentPage * _itemsPerPage;
          int endIndex = (_currentPage + 1) * _itemsPerPage;
          endIndex = endIndex > Customer.length ? Customer.length : endIndex;
          List<Customers> currentCustomer = Customer.sublist(startIndex, endIndex);

          return Column(
            children: [
              DataTable(
                columnSpacing: 138.0,
                headingTextStyle: TextStyle(color: Color(0xFF667085)),
                dataTextStyle:
                    TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                dividerThickness: 0.4,
                headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    return Color(0xFFF0F1F3);
                  },
                ),
                columns: [
                  DataColumn(label: Text("No")),
                  DataColumn(label: Text("Customer Name")),
                  DataColumn(label: Text("Address")),
                  DataColumn(label: Text("Contact")),
                  DataColumn(label: Text("Gst")),
                  DataColumn(label: Text("Action")),
                ],
                rows: List.generate(
                  currentCustomer.length,
                  (index) => _buildDataRow(
                    context,
                    startIndex + index,
                    currentCustomer[index].customerName,
                    currentCustomer[index].customerAddress,
                    currentCustomer[index].customerContact.toString(),
                    currentCustomer[index].gst,
                    
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
                      return Color(0xFFFFFFFF); // Hover color
                    }
                    return Color(0xFFFFFFFF); // Default color (no hover)
                  },
                ),
                overlayColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                     return Color.fromARGB(255, 215, 132, 59); // Hover color
                    }
                    return Color.fromARGB(255, 255, 254, 254); // Default color (no hover)
                  },
                ),
                backgroundColor: WidgetStateProperty.all(Colors.black),
              ),
                    child: Text("Previous"),
                  ),
                  Text("Page ${_currentPage + 1} of ${((Customer.length - 1) / _itemsPerPage).ceil() + 1}",style: TextStyle(fontWeight: FontWeight.w600),),
                  ElevatedButton(
                    onPressed: (_currentPage + 1) * _itemsPerPage < Customer.length
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
                      return Color(0xFFFFFFFF); // Hover color
                    }
                    return Color(0xFFFFFFFF); // Default color (no hover)
                  },
                ),
                overlayColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Color.fromARGB(255, 215, 132, 59); // Hover color
                    }
                    return Color.fromARGB(255, 255, 255, 255); // Default color (no hover)
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
    String customerName,
    String customerAddress,
    String customerContact,
    String gst,
  ) {
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Tooltip(message: customerName,child: TextOverflowByChars(
        text:customerName,
        maxCharacters: 6,
      ))),
        DataCell(Tooltip(message: customerAddress,child: TextOverflowByChars(
        text:customerAddress,
        maxCharacters: 6,
      ))),
        DataCell(Tooltip(message: customerContact,child: TextOverflowByChars(
        text:customerContact,
        maxCharacters: 6,
      ))),
        DataCell(Tooltip(message: gst,child: TextOverflowByChars(
        text:gst,
        maxCharacters: 6,
      ))),
        DataCell(_buildRowWithHover(context, index)),
      ],
    );
  }

  Widget _buildRowWithHover(BuildContext context, int CustomerId) {
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
            // Handle "View" action
          },
        ),
        PopupMenuItem(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFBE5C),
              borderRadius: BorderRadius.circular(3),
            ),
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/editicon.png",
                  color: Color(0xFFBD5C0A),
                ),
              ],
            ),
          ),
          onTap: () {
            // Handle "Edit" action
            print(CustomerId);
            CustomsDialogBox(
                Customer: Customer[CustomerId], onUpdate: _refreshProductList);
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
            Customers Customerss = Customer[CustomerId];
            // Handle "Delete" action
         _showDeleteDialog(Customers: Customerss);
          },
        ),
      ],
    );
  }

  CustomsDialogBox(
          {required Customers Customer, required void Function() onUpdate}) {
        _customerNameController.text = Customer.customerName;
        _customerAddressController.text = Customer.customerAddress;
        _customerContactController.text = Customer.customerContact.toString();
        _gstController.text = Customer.gst;
        if(Customer.gst.length>0){
setState(() {
            gst=true;
            });        
            }else{
setState(() {
            gst=false;
});
        }
        showDialog(
          barrierDismissible: false,
        context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context,StateSetter setState){
            return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10), // Optional: adds rounded corners
            ),
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(seconds: 50),
              child: Container(
                width: double.infinity, // Set custom width
                height: 350, // Set custom height
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text('Customer',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                            Divider(),
                            const SizedBox(height: 20), 
                            Row(
                              children: [
                                Text("GST",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0)),
                                Switch(
                                  value: gst,
                                  activeColor: Colors.green.shade400,
                                  dragStartBehavior: DragStartBehavior.start,
                                  onChanged: (bool value) {
                                    setState(() {
                                      gst = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),                        
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Customer Name',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 5),
                                      TextFormField(
                                        controller: _customerNameController,
                                        decoration: InputDecoration(
                                          focusColor: Colors.green.shade600,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                            width: 2.0,
                                            style: BorderStyle.solid,
                                            color: Color(0xFF5B89FF),
                                          )),
                                          border: OutlineInputBorder(),
                                          labelText: 'Enter Customer Name',                                        
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Customer name can\'t be empty';
                                          }
                                          return null;})])),
                                const SizedBox(
                                    width: 20),                       
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Customer Address',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 5),
                                      TextFormField(
                                        controller: _customerAddressController,
                                        decoration: InputDecoration(
                                          focusColor: Colors.green.shade600,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                            width: 2.0,
                                            style: BorderStyle.solid,
                                            color: Color(0xFF5B89FF),
                                          )),
                                          border: OutlineInputBorder(),
                                          labelText: 'Enter Address',
                                         
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Address can\'t be empty';
                                          }                                        
                                          return null; // Return null if validation passes
                                        })
                                        
                                        ])),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Customer Contact',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 5),
                                      TextFormField(
                                        controller: _customerContactController,
                                        decoration: InputDecoration(
                                          focusColor: Color(0xFF1EB386),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                            width: 2.0,
                                            style: BorderStyle.solid,
                                            color: Color(0xFF5B89FF),
                                          )),
                                          border: OutlineInputBorder(),
                                          labelText: 'Enter Contact',
                                          // errorText:
                                          //     validateprice ? 'Price cant be empty' : null,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Contact can\'t be empty';
                                          }                                          
                                          return null; // Return null if validation passes
                                        })])),
                                        SizedBox(width: 20),
                                        Gst(gst, _gstController),                                      
                                        ]),
                            const SizedBox(height: 40),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                            print(gst);
                                        _updateCustomer(Customer.id!);
                                        Navigator.of(context).pop();
                                      } else {
                                        print("Validation failed");
                                      }},
                                    style: ButtonStyle(
                                      foregroundColor:
                                          WidgetStateProperty.resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.hovered)) {
                                            return Color(
                                                0xFFFFFFFF); // Hover color
                                          }
                                          return Color(
                                              0xFFFFFFFF); // Default color (no hover)
                                        }),
                                      overlayColor:
                                          WidgetStateProperty.resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.hovered)) {
                                            return Color(
                                                0xFF1EB386); // Hover color
                                          }
                                          return Color(
                                              0xFF1EB386); // Default color (no hover)
                                        }),
                                      backgroundColor: WidgetStateProperty.all(
                                          Color(0xFF1EB386)),
                                    ),
                                    child: Text("Save")),
                                SizedBox(width: 15.0),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(context);
                                    },
                                    style: ButtonStyle(
                                      foregroundColor:
                                          WidgetStateProperty.resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.hovered)) {
                                            return Color(
                                                0xFFFFFFFF); // Hover color
                                          }
                                          return Color(
                                              0xFFFFFFFF); // Default color (no hover)
                                        }),
                                      overlayColor:
                                          WidgetStateProperty.resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.hovered)) {
                                            return Color(
                                                0xFF5B89FF); // Hover color
                                          }
                                          return Color(
                                              0xFF5B89FF); // Default color (no hover)
                                        }),
                                      backgroundColor: WidgetStateProperty.all(
                                          Color(0xFF5B89FF)),
                                    ),
                                    child: Text("Close")),
                              ])]))],
                ))
                )
                );
          }
        );
        }
        );
        }
void _showDeleteDialog({required Customers Customers}) {
  showDialog(
    context: context,
    barrierDismissible: true, // Allows the user to dismiss the dialog by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Icon(Icons.delete,color: Colors.red),
        content: Text("Do you wish to delete this record?",style: TextStyle(fontWeight: FontWeight.w500),),
        actions: [
          TextButton(
            onPressed: () {
              // Perform the delete action
              _deleteCustomers(Customers.id!);
              Navigator.of(context).pop(); // Close the dialog after deletion
            },
            style: TextButton.styleFrom(
            foregroundColor: Colors.white, // Text color
            backgroundColor: Colors.green.shade500, // Background color
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
    ),
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.hovered)) {
        return Colors.white.withOpacity(0.2); // Hover color with slight transparency
      }
      return null; // Default state
    }),),
            child: Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              // Close the dialog without deleting
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
            foregroundColor: Colors.white, // Text color
            backgroundColor: Colors.blue, // Background color
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0), // Optional: Rounded corners
    ),
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.hovered)) {
        return Colors.white.withOpacity(0.2); // Hover color with slight transparency
      }
      return null; // Default state
    }),),
            child: Text("No"),
          )]);});
}

Widget Gst(bool gst, TextEditingController _gstController) {
  if (gst == true) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gst Number',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _gstController,
            decoration: InputDecoration(
              focusColor: Color(0xFF1EB386),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  style: BorderStyle.solid,
                  color: Color(0xFF5B89FF),
                ),
              ),
              border: OutlineInputBorder(),
              labelText: 'Enter Gst',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Gst can\'t be empty';
              }
              return null;
            },
          ),
        ],
      ),
    );
  } else {
    null;   
    return SizedBox.shrink();
  }
}
}
