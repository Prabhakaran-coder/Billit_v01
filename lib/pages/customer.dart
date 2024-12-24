import 'package:billit/database/product_database_helper.dart';
import 'package:billit/models/menuheader.dart';
import 'package:billit/models/product_db_data.dart';
import 'package:billit/models/providercurrentindex.dart';
import 'package:billit/pages/customer_table.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
   final _formKey = GlobalKey<FormState>();
   late Future<List<Customers>> _Customers;
   late ProductDatabaseHelper _databaseHelper;
    bool gst = false;
     
  @override
  void initState() {
    super.initState();
    _databaseHelper = ProductDatabaseHelper.instance;
  }
   void _addCustomers() async {
    final String customerNameController = _customerNameController.text;
    final String customerAddressController = _customerAddressController.text ;
    final String customerContactController = _customerContactController.text;
    final String gstNumber = gst ? _gstController.text.trim() : "";

    if (customerNameController.isNotEmpty && customerAddressController.isNotEmpty&& customerContactController.isNotEmpty) {
      final newCustomer = Customers(customerName: customerNameController, customerAddress: customerAddressController, customerContact: customerContactController,gst:gstNumber);
      var result = await _databaseHelper.insertCustomers(newCustomer);
      // _products=<product>[];
      setState(() {
        _Customers = _databaseHelper.getCustomers();
      });
      print(result);
      _customerNameController.clear();
      _customerAddressController.clear();
      _customerContactController.clear();
      _gstController.clear();
    }
  }
   
   final TextEditingController _customerNameController = TextEditingController();
   final TextEditingController _customerAddressController = TextEditingController();
   final TextEditingController _customerContactController = TextEditingController();
   final TextEditingController _gstController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    void showcustomerDialog() {
      customerDialog(context,_addCustomers); // Call the dialog here
    }
    final menuHeader = Provider.of<MyState>(context).menuHeaderValue;
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Color(0xFFFAFAFA)),
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              menuHeaders(menuHeader, showcustomerDialog),
              SizedBox(
                height: 20.0,
              ),
             CustomerTable(),
            ],
          )),
    ));
  }
void customerDialog(BuildContext context,Function addCustomer) {
  // Declare GST state here
  
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder( // Use StatefulBuilder to manage state inside the dialog
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Optional: adds rounded corners
            ),
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(seconds: 50),
              child: Container(
                width: double.infinity, // Set custom width
                height: 400, // Set custom height
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text('Customers',
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
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
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
                                        labelText: 'Enter Customer Address',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Customer Address can\'t be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Contact Number',
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
                                        labelText: 'Enter Customer Contact',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Contact can\'t be empty';
                                        }
                                        if (int.tryParse(value) == null) {
                                          return 'Enter a valid number for Contact';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              Gst(gst, _gstController),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                          addCustomer();
                                           print("Validation Succuessful");
                                      Navigator.of(context).pop();
                                    } else {
                                      print("Validation failed");
                                    }
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
                                      },
                                    ),
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
                                      },
                                    ),
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
                                      },
                                    ),
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
                                      },
                                    ),
                                    backgroundColor: WidgetStateProperty.all(
                                        Color(0xFF5B89FF)),
                                  ),
                                  child: Text("Close")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
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
        
       

