import 'package:billit/database/product_database_helper.dart';
import 'package:billit/models/product_db_data.dart';
import 'package:flutter/material.dart';

class CustomDialogBox extends StatefulWidget {
   final Product product;
   final Function onUpdate;
  const CustomDialogBox({required this.product, required this.onUpdate,super.key});

  @override
  State<CustomDialogBox> createState() => _CustomDialogBoxState();
}
late Future<List<Product>> _products;

final TextEditingController _itemnameController = TextEditingController();
final TextEditingController _qtyController = TextEditingController();
final TextEditingController _priceController = TextEditingController();
final _formKey = GlobalKey<FormState>();


class _CustomDialogBoxState extends State<CustomDialogBox> {
  late ProductDatabaseHelper _databaseHelper;
  

  @override
  void initState() {
    super.initState();
    _databaseHelper = ProductDatabaseHelper.instance;
    _itemnameController.text=widget.product.itemName;
    _qtyController.text=widget.product.qty.toString() ;
    _priceController.text=widget.product.price.toString();
    
  }

  void _updateProduct(int id) async {
    final String itemName = _itemnameController.text;
    final int qty = int.tryParse(_qtyController.text) ?? 0;
    final int price = int.tryParse(_priceController.text) ?? 0;

    if (itemName.isNotEmpty && qty > 0 && price > 0) {
      final updatedProduct =
          Product(id: id, itemName: itemName, qty: qty, price: price);
      await _databaseHelper.updateProduct(updatedProduct);
      setState(() {
        _products = _databaseHelper.getProduct();
      });
     
      _itemnameController.clear();
      _qtyController.clear();
      _priceController.clear();
       widget.onUpdate();
    }
  }
  @override
  Widget build(BuildContext context) {
    
     return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Optional: adds rounded corners
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // First input field with label
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
                        const SizedBox(width: 20), // Space between the two fields

                        // Second input field with label
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
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Price can\'t be empty';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Enter a valid number for price';
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
                            if (_formKey.currentState?.validate() ?? false) {
                              print(widget.product.id);
                              _updateProduct(widget.product.id ?? 0);
                              Navigator.of(context).pop(context);
                            } else {
                              print("Validation failed");
                            }
                          },
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Color(0xFFFFFFFF); // Hover color
                                }
                                return Color(0xFFFFFFFF); // Default color (no hover)
                              },
                            ),
                            backgroundColor: WidgetStateProperty.all(Color(0xFF1EB386)),
                          ),
                          child: Text("Update"),
                        ),
                        SizedBox(width: 15.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(context);
                          },
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Color(0xFFFFFFFF); // Hover color
                                }
                                return Color(0xFFFFFFFF); // Default color (no hover)
                              },
                            ),
                            backgroundColor: WidgetStateProperty.all(Color(0xFF5B89FF)),
                          ),
                          child: Text("Close"),
                        ),
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

  }
}