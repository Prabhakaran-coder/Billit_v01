import 'package:billit/models/menuheader.dart';
import 'package:billit/models/providercurrentindex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
   final _formKey = GlobalKey<FormState>();

   final TextEditingController _customerNameController = TextEditingController();
final TextEditingController _customerAddressController = TextEditingController();
final TextEditingController _customerContactController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void showcustomerDialog() {
      customerDialog(context); // Call the dialog here
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
             
            ],
          )),
    ));
  }

  void customerDialog(BuildContext context, 
  // Function addProduct
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
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
                          const Text('Products',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                          Divider(),
                          const SizedBox(height: 20),
                          // Row for horizontal input fields
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // First input field with label

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
                                        //errorText: validateitemname? 'Itemname cant be empty': null,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Customer name can\'t be empty';
                                        }
                                        return null; // Return null if validation passes
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                  width: 20), // Space between the two fields

                              // Second input field with label
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
                                        // errorText:
                                        //     validateqty ? 'Quantity cant be empty' : null,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Customer Address can\'t be empty';
                                        }                                        
                                        return null; // Return null if validation passes
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
                                        // errorText:
                                        //     validateprice ? 'Price cant be empty' : null,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Contact can\'t be empty';
                                        }
                                        if (int.tryParse(value) == null) {
                                          return 'Enter a valid number for Contact';
                                        }
                                        return null; // Return null if validation passes
                                      },
                                    ),
                                  ],
                                ),
                              ),
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
                                      // addProduct();

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
                      )),
                ],
                /////
              ),
            ),
          ),
        );
      },
    );
  }
}

