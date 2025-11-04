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
  final nameExp = RegExp(r'^[a-zA-Z ]+$');
      final stateExp = RegExp(r'^[a-zA-Z]+$');
      final alphanumericNoSpace = RegExp(r'^[a-zA-Z0-9]+$');
   final _formKey = GlobalKey<FormState>();
   late Future<List<Customers>> _Customers;
   late ProductDatabaseHelper _databaseHelper;
    bool gst = false;
    final List<String> _customerState =['AndraPradesh','Kerala','Karnataka','Tamilnadu'];  
  @override
  void initState() {
    super.initState();
    _databaseHelper = ProductDatabaseHelper.instance;
  }
   void _addCustomers() async {
    final String customerNameController = _customerNameController.text;
    final String customerAddressController = _customerAddressController.text ;
     final String DistrictController = _districtController.text ;
    final int customerContactController = int.tryParse(_customerContactController.text)??0;
    final String emailController = _emailContactController.text ;
    final String state = _selectedName!;
    final int pincode=int.tryParse(_customerpincodeController.text)??0;
    final String gstNumber = gst ? _gstController.text.trim().toUpperCase() : "No";

    if (customerNameController.isNotEmpty && customerAddressController.isNotEmpty&& customerContactController>0) {
      final newCustomer = Customers(customerName: customerNameController, customerAddress: customerAddressController,
      state: state, district: DistrictController,customerContact: customerContactController,customeremailContact: emailController,gst:gstNumber,customerPincode: pincode);
      var result = await _databaseHelper.insertCustomers(newCustomer);
      // _products=<product>[];
      setState(() {
        _Customers = _databaseHelper.getCustomers();
      });
      print(result);
      _customerNameController.clear();
      _customerAddressController.clear();
      _customerContactController.clear();
      _customerpincodeController.clear();
      _gstController.clear();
    }
  }
   
   final TextEditingController _customerNameController = TextEditingController();
   final TextEditingController _customerAddressController = TextEditingController();
     final TextEditingController _districtController = TextEditingController();
   final TextEditingController _customerContactController = TextEditingController();
    final TextEditingController _emailContactController = TextEditingController();
   final TextEditingController _customerpincodeController = TextEditingController();
   final TextEditingController _gstController = TextEditingController();
   
     String? _selectedName; 

  @override
  Widget build(BuildContext context) {
    void showcustomerDialog() {
      customerDialog(context,_addCustomers); // Call the dialog here
    }
    final menuHeader = Provider.of<MyState>(context).menuHeaderValue;
    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 177, 177, 177),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                      menuHeaders(menuHeader, showcustomerDialog),
                      SizedBox(
                        height: 20.0,
                      ),
                      
                Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(color: Color.fromARGB(255, 241, 242, 245)),
                  child: CustomerTable()),
              ],
            ),
          ),
        ));
  }
void customerDialog(BuildContext context,Function addCustomer) {
  // Declare GST state here
  
  showDialog(
    barrierDismissible: true,
    context: context,
    
    builder: (BuildContext context) {
      return StatefulBuilder( // Use StatefulBuilder to manage state inside the dialog
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            shadowColor: const Color.fromARGB(255, 244, 153, 96),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), 
            ),
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(seconds: 50),
              child: Container(
                
                width: double.infinity,
                height: 450, 
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
                                        if (!nameExp.hasMatch(value)) {
                                          return 'Please enter only letters for the name';
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
                                    const Text('District',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      controller: _districtController,
                                      decoration: InputDecoration(
                                        focusColor: Colors.green.shade600,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 2.0,
                                          style: BorderStyle.solid,
                                          color: Color(0xFF5B89FF),
                                        )),
                                        border: OutlineInputBorder(),
                                        labelText: 'Enter Your District',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'District can\'t be empty';
                                        }
                                        if (!stateExp.hasMatch(value)) {
                                          return 'Please enter only letters for the name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),

                              Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             
                              const Text('State',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 5),
                              Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Colors.white, // Background color of dropdown menu
                                    shadowColor: Colors.white, 
                                    // Removes shadow
                                  ),
                                child: DropdownButtonFormField(
                                  //controller:_stateController,
                                  focusColor: Colors.white,
                                  decoration: const InputDecoration(
                                    labelText: "Select State",
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                   dropdownColor: Colors.white, 
                                  value: _selectedName,
                                  hint: const Text('Select State'),
                                  items: _customerState.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                 
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedName = newValue;
                                    });
                              
                                  },
                                 
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'States can\'t be empty';
                                    }
                                    return null;
                                  },
                                ),
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
                                        if (int.tryParse(value) == null|| value.length>10) {
                                          return 'Enter a valid number for Contact';
                                        }  
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [                              
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Pincode',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      controller: _customerpincodeController,
                                      decoration: InputDecoration(
                                        focusColor: Color(0xFF1EB386),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 2.0,
                                          style: BorderStyle.solid,
                                          color: Color(0xFF5B89FF),
                                        )),
                                        border: OutlineInputBorder(),
                                        labelText: 'Enter pincode',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Pincode can\'t be empty';
                                        }
                                        if (int.tryParse(value) == null|| value.length>6) {
                                          return 'Enter a valid Pincode';
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
                                    const Text('Email contact',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      controller: _emailContactController,
                                      decoration: InputDecoration(
                                        focusColor: Color(0xFF1EB386),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 2.0,
                                          style: BorderStyle.solid,
                                          color: Color(0xFF5B89FF),
                                        )),
                                        border: OutlineInputBorder(),
                                        labelText: 'Enter email Contact',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'email can\'t be empty';
                                        }
                                        if ((value) == null) {
                                          return 'Enter a valid email for Contact';
                                        }  
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20,),                              
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
                                              0xFFFFFFFF); 
                                        }
                                        return Color(
                                            0xFFFFFFFF); 
                                      },
                                    ),
                                    overlayColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.hovered)) {
                                          return Color(
                                              0xFF1EB386); 
                                        }
                                        return Color(
                                            0xFF1EB386); 
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
                                              0xFFFFFFFF); 
                                        }
                                        return Color(
                                            0xFFFFFFFF);
                                           },
                                    ),
                                    overlayColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.hovered)) {
                                          return Color(
                                              0xFF5B89FF); 
                                        }
                                        return Color(
                                            0xFF5B89FF); 
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

Widget Gst(bool gst, TextEditingController gstController) {
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
            controller: gstController,
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
        
       

