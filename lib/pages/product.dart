import 'package:billit/pages/product_table.dart';
import 'package:billit/database/product_database_helper.dart';
import 'package:billit/models/menuheader.dart';
import 'package:billit/models/product_db_data.dart';
import 'package:billit/models/providercurrentindex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class product extends StatefulWidget {
  const product({super.key});

  @override
  State<product> createState() => _productState();
}

late Future<List<Product>> _products;

final TextEditingController _itemnameController = TextEditingController();
final TextEditingController _qtyController = TextEditingController();
final TextEditingController _priceController = TextEditingController();
final TextEditingController _cgstController = TextEditingController();
final TextEditingController _sgstController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _productState extends State<product> {
  late ProductDatabaseHelper _databaseHelper;
  @override
  void initState() {
    super.initState();
    _databaseHelper = ProductDatabaseHelper.instance;
  }

  void _addProduct() async {
    final String itemName = _itemnameController.text;
    final int qty = int.tryParse(_qtyController.text) ?? 0;
    final double price = double.tryParse(_priceController.text) ?? 0.0;
    final int cgst = int.tryParse(_cgstController.text) ?? 0;
    final int sgst = int.tryParse(_sgstController.text) ?? 0;

    if (itemName.isNotEmpty && qty > 0 && price > 0 && cgst > 0 && sgst > 0) {
      final newProduct = Product(itemName: itemName, qty: qty, price: price, cgst: cgst, sgst: sgst);
      var result = await _databaseHelper.insertProduct(newProduct);
      // _products=<product>[];
      setState(() {
        _products = _databaseHelper.getProduct();
      });
      print(result);
      _cgstController.clear();
      _sgstController.clear();
      _itemnameController.clear();
      _qtyController.clear();
      _priceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    void showProductDialog() {
      showCustomDialog(context, _addProduct);
    }

    final menuHeader = Provider.of<MyState>(context).menuHeaderValue;
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Color.fromARGB(255, 241, 242, 245)),
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              menuHeaders(menuHeader, showProductDialog),
              SizedBox(
                height: 20.0,
              ),
              ProductTable(),
            ],
          )),
    ));
  }

  void showCustomDialog(BuildContext context, Function addProduct) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10), 
          ),
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(seconds: 50),
            child: Container(
              width: double.infinity, 
              height: 350, 
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
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Item Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      controller: _itemnameController,
                                      decoration: InputDecoration(
                                        focusColor: Colors.green.shade600,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 2.0,
                                          style: BorderStyle.solid,
                                          color: Color(0xFF5B89FF),
                                        )),
                                        border: OutlineInputBorder(),
                                        labelText: 'Enter Item Name',
                                        //errorText: validateitemname? 'Itemname cant be empty': null,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Item name can\'t be empty';
                                        }
                                        return null; 
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                  width: 20), 

                              
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Quantity',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      controller: _qtyController,
                                      decoration: InputDecoration(
                                        focusColor: Colors.green.shade600,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 2.0,
                                          style: BorderStyle.solid,
                                          color: Color(0xFF5B89FF),
                                        )),
                                        border: OutlineInputBorder(),
                                        labelText: 'Enter Qty',
                                        // errorText:
                                        //     validateqty ? 'Quantity cant be empty' : null,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Quantity can\'t be empty';
                                        }
                                        if (int.tryParse(value) == null) {
                                          return 'Enter a valid number for quantity';
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
                                    const Text('Price',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      controller: _priceController,
                                      decoration: InputDecoration(
                                        focusColor: Color(0xFF1EB386),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 2.0,
                                          style: BorderStyle.solid,
                                          color: Color(0xFF5B89FF),
                                        )),
                                        border: OutlineInputBorder(),
                                        labelText: 'Enter Price',
                                        // errorText:
                                        //     validateprice ? 'Price cant be empty' : null,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Price can\'t be empty';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Enter a valid number for price';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('CGST',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      controller: _cgstController,
                                      decoration: InputDecoration(
                                        focusColor: Colors.green.shade600,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 2.0,
                                          style: BorderStyle.solid,
                                          color: Color(0xFF5B89FF),
                                        )),
                                        border: OutlineInputBorder(),
                                        labelText: 'Enter CGST',
                                        //errorText: validateitemname? 'Itemname cant be empty': null,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'CGST can\'t be empty';
                                        }if (int.tryParse(value) == null) {
                                          return 'Enter a valid value for CGST';
                                        }
                                        return null; 
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('SGST',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 5),
                                    TextFormField(
                                      controller: _sgstController,
                                      decoration: InputDecoration(
                                        focusColor: Colors.green.shade600,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                          width: 2.0,
                                          style: BorderStyle.solid,
                                          color: Color(0xFF5B89FF),
                                        )),
                                        border: OutlineInputBorder(),
                                        labelText: 'Enter SGST',
                                        //errorText: validateitemname? 'Itemname cant be empty': null,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'SGST can\'t be empty';
                                        }if (int.tryParse(value) == null) {
                                          return 'Enter a valid value for SGST';
                                        }
                                        return null;
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
                                      addProduct();

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
