import 'package:billit/database/product_database_helper.dart';
import 'package:billit/models/product_db_data.dart';
import 'package:billit/models/textOverFlow.dart';
import 'package:flutter/material.dart';

class ProductTable extends StatefulWidget {
  const ProductTable({super.key});

  @override
  State<ProductTable> createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  late ProductDatabaseHelper _databaseHelper;
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _cgstController = TextEditingController();
final TextEditingController _sgstController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Future<List<Product>> _products;
  List<Product> products = <Product>[];

  // Pagination variables
  int _currentPage = 0;
  final int _itemsPerPage = 8;
  void _updateProduct(int id) async {
      final String itemName = _itemnameController.text;
      final int qty = int.tryParse(_qtyController.text) ?? 0;
      final double price = double.tryParse(_priceController.text) ?? 0.0;
      final int cgst = int.tryParse(_cgstController.text) ?? 0;
      final int sgst = int.tryParse(_sgstController.text) ?? 0;

       if (itemName.isNotEmpty && qty > 0 && price > 0 && cgst > 0 && sgst > 0) {
      final updatedProduct = Product(itemName: itemName, qty: qty, price: price, cgst: cgst, sgst: sgst);
        await _databaseHelper.updateProduct(updatedProduct);
        setState(() {
          _products = _databaseHelper.getProduct();
        });
        _cgstController.clear();
        _sgstController.clear();
        _itemnameController.clear();
        _qtyController.clear();
        _priceController.clear();
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
      _products = _databaseHelper.getProduct();
    });
  }

  void _refreshProductList() {
    _loadProducts(); // Refresh the product list
  }

  void _deleteProduct(int id) async {
    await _databaseHelper.deleteProduct(id);
    setState(() {
      _products = _databaseHelper.getProduct();
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
      child: FutureBuilder<List<Product>>(
        future: _databaseHelper.getProduct(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
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
          products = snapshot.data!;

          // Calculate the items for the current page
          int startIndex = _currentPage * _itemsPerPage;
          int endIndex = (_currentPage + 1) * _itemsPerPage;
          endIndex = endIndex > products.length ? products.length : endIndex;
          List<Product> currentProducts = products.sublist(startIndex, endIndex);

          return Column(
            children: [
              DataTable(
                columnSpacing: 110.0,
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
                  DataColumn(label: Text("Product Name")),
                  DataColumn(label: Text("Quantity")),
                  DataColumn(label: Text("Price")),
                  DataColumn(label: Text("CGST")),
                  DataColumn(label: Text("SGST")),
                  DataColumn(label: Text("Action")),
                ],
                rows: List.generate(
                  currentProducts.length,
                  (index) => _buildDataRow(
                    context,
                    startIndex + index,
                    currentProducts[index].itemName,
                    currentProducts[index].qty.toString(),
                    currentProducts[index].price.toString(),
                    currentProducts[index].cgst.toString(),
                    currentProducts[index].sgst.toString(),
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
                  Text("Page ${_currentPage + 1} of ${((products.length - 1) / _itemsPerPage).ceil() + 1}",style: TextStyle(fontWeight: FontWeight.w600),),
                  ElevatedButton(
                    onPressed: (_currentPage + 1) * _itemsPerPage < products.length
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
    String productName,
    String qty,
    String price,
    String cgst,
    String sgst,
  ) {
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Tooltip(message: productName,child: TextOverflowByChars(
            text:productName,
            fontSize: 14,
            //maxCharactersPerLine: 10,
            maxCharacters: 5,
                  )),
          ],
        )),
         DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            
             Tooltip(message: qty,child: TextOverflowByChars(
                     text:qty,
                     fontSize: 14,
                     //maxCharactersPerLine: 10,
                     maxCharacters: 5,
                   )),
           ],
         )),
         DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Tooltip(message: price,child: TextOverflowByChars(
                     text:price,
                     fontSize: 14,
                     //maxCharactersPerLine: 10,
                     maxCharacters: 5,
                   )),
           ],
         )),
       DataCell(Column(
        mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Tooltip(message: cgst,child: TextOverflowByChars(
            text:cgst,
            fontSize: 14,
            //maxCharactersPerLine: 10,
            maxCharacters: 5,
                 )),
         ],
       )),
       DataCell(Column(
        mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Tooltip(message: sgst,child: TextOverflowByChars(
            text:sgst,
            fontSize: 14,
            //maxCharactersPerLine: 10,
            maxCharacters: 5,
                 )),
         ],
       )),
        DataCell(_buildRowWithHover(context, index)),
      ],
    );
  }

  Widget _buildRowWithHover(BuildContext context, int productId) {
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
              color: const Color.fromARGB(255, 193, 247, 195),
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
            print(productId);
            CustomsDialogBox(
                product: products[productId], onUpdate: _refreshProductList);
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
            Product product = products[productId];
            // Handle "Delete" action
         _showDeleteDialog(product: product);
          },
        ),
      ],
    );
  }

  CustomsDialogBox(
          {required Product product, required void Function() onUpdate}) {
        _itemnameController.text = product.itemName;
        _qtyController.text = product.qty.toString();
        _priceController.text = product.price.toString();
        _cgstController.text=product.cgst.toString();
        _sgstController.text=product.sgst.toString();
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
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Item name can\'t be empty';
                                        }
                                        return null;})])),
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
                                       
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Quantity can\'t be empty';
                                        }
                                        if (int.tryParse(value) == null) {
                                          return 'Enter a valid number for quantity';
                                        }
                                        return null; 
                                      })])),
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
                                      })])
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
                                      ]
                                      ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      _updateProduct(product.id!);
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
                                              0xFFFFFFFF); 
                                        }
                                        return Color(
                                            0xFFFFFFFF); 
                                      }),
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
                                              0xFFFFFFFF); 
                                        }
                                        return Color(
                                            0xFFFFFFFF); 
                                      }),
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
                                      }),
                                    backgroundColor: WidgetStateProperty.all(
                                        Color(0xFF5B89FF)),
                                  ),
                                  child: Text("Close")),
                            ])]))],
              ))));});}
void _showDeleteDialog({required Product product}) {
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
              _deleteProduct(product.id!);
              Navigator.of(context).pop(); 
            },
            style: TextButton.styleFrom(
            foregroundColor: Colors.white, 
            backgroundColor: Colors.green.shade500, 
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), 
    ),
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.hovered)) {
        return Colors.white.withOpacity(0.2); 
      }
      return null; // Default state
    }),),
            child: Text("Yes"),
          ),
          TextButton(
            onPressed: () {
             
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
            foregroundColor: Colors.white, 
            backgroundColor: Colors.blue, 
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
    ),
  ).copyWith(
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.hovered)) {
        return Colors.white.withOpacity(0.2); 
      }
      return null; // Default state
    }),),
            child: Text("No"),
          )]);});
}

}

class TextOverflowByWords extends StatelessWidget {
  final String text;
  final int maxWords;

  const TextOverflowByWords({super.key, required this.text, required this.maxWords});

  String _truncateText() {
    List<String> words = text.split(' ');
    if (words.length > maxWords) {
      return '${words.sublist(0, maxWords).join(' ')}...';
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _truncateText(),
      overflow: TextOverflow.ellipsis, 
      style: TextStyle(fontSize: 16),
    );
  }
}
