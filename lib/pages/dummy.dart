// import 'package:billit/database/product_database_helper.dart';
// import 'package:billit/models/product_db_data.dart';
// import 'package:flutter/material.dart';

// class CustomDialogBox extends StatefulWidget {
//    final Product product;
//    final Function onUpdate;
//   const CustomDialogBox({required this.product, required this.onUpdate,super.key});

//   @override
//   State<CustomDialogBox> createState() => _CustomDialogBoxState();
// }
// late Future<List<Product>> _products;

// final TextEditingController _itemnameController = TextEditingController();
// final TextEditingController _qtyController = TextEditingController();
// final TextEditingController _priceController = TextEditingController();
// final _formKey = GlobalKey<FormState>();


// class _CustomDialogBoxState extends State<CustomDialogBox> {
//   late ProductDatabaseHelper _databaseHelper;
  

//   @override
//   void initState() {
//     super.initState();
//     _databaseHelper = ProductDatabaseHelper.instance;
//     _itemnameController.text=widget.product.itemName;
//     _qtyController.text=widget.product.qty.toString() ;
//     _priceController.text=widget.product.price.toString();
    
//   }

//   void _updateProduct(int id) async {
//     final String itemName = _itemnameController.text;
//     final int qty = int.tryParse(_qtyController.text) ?? 0;
//     final int price = int.tryParse(_priceController.text) ?? 0;

//     if (itemName.isNotEmpty && qty > 0 && price > 0) {
//       final updatedProduct =
//           Product(id: id, itemName: itemName, qty: qty, price: price);
//       await _databaseHelper.updateProduct(updatedProduct);
//       setState(() {
//         _products = _databaseHelper.getProduct();
//       });
     
//       _itemnameController.clear();
//       _qtyController.clear();
//       _priceController.clear();
//        widget.onUpdate();
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
    
//      return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10), // Optional: adds rounded corners
//       ),
//       child: AnimatedOpacity(
//         opacity: 1.0,
//         duration: Duration(seconds: 50),
//         child: Container(
//           width: double.infinity, // Set custom width
//           height: 350, // Set custom height
//           padding: const EdgeInsets.all(40),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     const Text('Products',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.w500)),
//                     Divider(),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // First input field with label
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text('Item Name',
//                                   style: TextStyle(
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.w500)),
//                               const SizedBox(height: 5),
//                               TextFormField(
//                                 controller: _itemnameController,
//                                 decoration: InputDecoration(
//                                   focusColor: Colors.green.shade600,
//                                   focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                     width: 2.0,
//                                     style: BorderStyle.solid,
//                                     color: Color(0xFF5B89FF),
//                                   )),
//                                   border: OutlineInputBorder(),
//                                   labelText: 'Enter Item Name',
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Item name can\'t be empty';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 20), // Space between the two fields

//                         // Second input field with label
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text('Quantity',
//                                   style: TextStyle(
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.w500)),
//                               const SizedBox(height: 5),
//                               TextFormField(
//                                 controller: _qtyController,
//                                 decoration: InputDecoration(
//                                   focusColor: Colors.green.shade600,
//                                   focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                     width: 2.0,
//                                     style: BorderStyle.solid,
//                                     color: Color(0xFF5B89FF),
//                                   )),
//                                   border: OutlineInputBorder(),
//                                   labelText: 'Enter Qty',
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Quantity can\'t be empty';
//                                   }
//                                   if (int.tryParse(value) == null) {
//                                     return 'Enter a valid number for quantity';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text('Price',
//                                   style: TextStyle(
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.w500)),
//                               const SizedBox(height: 5),
//                               TextFormField(
//                                 controller: _priceController,
//                                 decoration: InputDecoration(
//                                   focusColor: Color(0xFF1EB386),
//                                   focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                     width: 2.0,
//                                     style: BorderStyle.solid,
//                                     color: Color(0xFF5B89FF),
//                                   )),
//                                   border: OutlineInputBorder(),
//                                   labelText: 'Enter Price',
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Price can\'t be empty';
//                                   }
//                                   if (int.tryParse(value) == null) {
//                                     return 'Enter a valid number for price';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 40),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             if (_formKey.currentState?.validate() ?? false) {
//                               print(widget.product.id);
//                               _updateProduct(widget.product.id ?? 0);
//                               Navigator.of(context).pop(context);
//                             } else {
//                               print("Validation failed");
//                             }
//                           },
//                           style: ButtonStyle(
//                             foregroundColor: WidgetStateProperty.resolveWith<Color>(
//                               (Set<WidgetState> states) {
//                                 if (states.contains(WidgetState.hovered)) {
//                                   return Color(0xFFFFFFFF); // Hover color
//                                 }
//                                 return Color(0xFFFFFFFF); // Default color (no hover)
//                               },
//                             ),
//                             backgroundColor: WidgetStateProperty.all(Color(0xFF1EB386)),
//                           ),
//                           child: Text("Update"),
//                         ),
//                         SizedBox(width: 15.0),
//                         ElevatedButton(
//                           onPressed: () {
//                             Navigator.of(context).pop(context);
//                           },
//                           style: ButtonStyle(
//                             foregroundColor: WidgetStateProperty.resolveWith<Color>(
//                               (Set<WidgetState> states) {
//                                 if (states.contains(WidgetState.hovered)) {
//                                   return Color(0xFFFFFFFF); // Hover color
//                                 }
//                                 return Color(0xFFFFFFFF); // Default color (no hover)
//                               },
//                             ),
//                             backgroundColor: WidgetStateProperty.all(Color(0xFF5B89FF)),
//                           ),
//                           child: Text("Close"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );

//   }
// }

// //---------------------------

// class ProductTable extends StatefulWidget {
//   const ProductTable({super.key});

//   @override
//   State<ProductTable> createState() => _ProductTableState();
// }

// class _ProductTableState extends State<ProductTable> {
//   late ProductDatabaseHelper _databaseHelper;
//   final TextEditingController _itemnameController = TextEditingController();
//   final TextEditingController _qtyController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   late Future<List<Product>> _products;
//   List<Product> products = <Product>[];

//   // Pagination variables
//   int _currentPage = 0;
//   final int _itemsPerPage = 8;
//   void _updateProduct(int id) async {
//       final String itemName = _itemnameController.text;
//       final int qty = int.tryParse(_qtyController.text) ?? 0;
//       final int price = int.tryParse(_priceController.text) ?? 0;

//       if (itemName.isNotEmpty && qty > 0 && price > 0) {
//         final updatedProduct =
//             Product(id: id, itemName: itemName, qty: qty, price: price);
//         await _databaseHelper.updateProduct(updatedProduct);
//         setState(() {
//           _products = _databaseHelper.getProduct();
//         });

//         _itemnameController.clear();
//         _qtyController.clear();
//         _priceController.clear();
//         // widget.onUpdate();
//       }
//     }
//   @override
//   void initState() {
//     super.initState();
//     _databaseHelper = ProductDatabaseHelper.instance;
//     _loadProducts();
//   }

//   void _loadProducts() {
//     setState(() {
//       _products = _databaseHelper.getProduct();
//     });
//   }

//   void _refreshProductList() {
//     _loadProducts(); // Refresh the product list
//   }

//   void _deleteProduct(int id) async {
//     await _databaseHelper.deleteProduct(id);
//     setState(() {
//       _products = _databaseHelper.getProduct();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(5.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             offset: Offset(5, 5),
//             blurRadius: 10,
//             spreadRadius: 3,
//           ),
//         ],
//       ),
//       child: FutureBuilder<List<Product>>(
//         future: _databaseHelper.getProduct(),
//         builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No products found.'));
//           }

//           // Get the product list from snapshot data
//           products = snapshot.data!;

//           // Calculate the items for the current page
//           int startIndex = _currentPage * _itemsPerPage;
//           int endIndex = (_currentPage + 1) * _itemsPerPage;
//           endIndex = endIndex > products.length ? products.length : endIndex;
//           List<Product> currentProducts = products.sublist(startIndex, endIndex);

//           return Column(
//             children: [
//              Table(
//             defaultVerticalAlignment: TableCellVerticalAlignment.middle,
           
//             border: TableBorder.symmetric(
//               inside: BorderSide.none,
              
//             ),
//             columnWidths: {
//               0: FlexColumnWidth(1.0), // For 'No' column
//               1: FlexColumnWidth(1.0), // For 'Product Name' column
//               2: FlexColumnWidth(1.0), // For 'Quantity' column
//               3: FlexColumnWidth(1.0), // For 'Price' column
//               4: FlexColumnWidth(1.0), // For 'Action' column
//             },
//             children: [
//               // Table Header Row
//               TableRow(
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 231, 233, 237),                  
//                 ),
//                 children: [
//                   Expanded(child: Text(
//                       "No",
//                       style: TextStyle(color: Color(0xFF667085),fontSize: 14.0, fontWeight: FontWeight.w500,height: 4.0,),
//                       textAlign: TextAlign.center,
//                     )),
//                     Expanded(child: Text(
//                       "Product Name",
//                       style: TextStyle(color: Color(0xFF667085),fontSize: 14.0, fontWeight: FontWeight.w500),
//                        textAlign: TextAlign.center,
//                     ),),
                  
//                   Expanded(child: Text(
//                       "Quantity",
//                       style: TextStyle(color: Color(0xFF667085),fontSize: 14.0, fontWeight: FontWeight.w500),
//                        textAlign: TextAlign.center,
//                     ),),
//                   Expanded(child: Text(
//                       "Price",
//                       style: TextStyle(color: Color(0xFF667085),fontSize: 14.0, fontWeight: FontWeight.w500),
//                        textAlign: TextAlign.center,
//                     ),),
//                   Expanded(child: Text(
//                       "Action",
//                       style: TextStyle(color: Color(0xFF667085),fontSize: 14.0, fontWeight: FontWeight.w500),
//                        textAlign: TextAlign.center,
//                     ),),
                  
//                 ],
//               ),
//               // Table Data Rows
//               for (int index = 0; index < currentProducts.length; index++)
//                 TableRow(
//                   decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.4,color: Color.fromARGB(255, 205, 206, 209)))),
//                   children: [
//                     Expanded(child: 
//                     // Text((startIndex + index + 1).toString(),textAlign: TextAlign.center,
//                     // style: TextStyle(height: 3.0,fontSize: 14.0, fontWeight: FontWeight.w500),
//                     Tooltip(message: (startIndex + index + 1).toString(), child: TextOverflowByChars(text: (startIndex + index + 1).toString(),maxCharacters: 10,))),
//                     Tooltip(message: currentProducts[index].itemName,child: Expanded(child: TextOverflowByChars(text: currentProducts[index].itemName,maxCharacters: 10,))),
//                     Tooltip(message: currentProducts[index].qty.toString(),child: Expanded(child: TextOverflowByChars(text: currentProducts[index].qty.toString(),maxCharacters: 10,))),
//                     Tooltip(message: currentProducts[index].price.toString(),child: Expanded(child: TextOverflowByChars(text: currentProducts[index].price.toString(),maxCharacters: 10,))),
//                     Expanded(child: _buildRowWithHover(context, index))
                    
//                   ],
//                 ),
//             ],
//           ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: _currentPage > 0
//                         ? () {
//                             setState(() {
//                               _currentPage--;
//                             });
//                           }
//                         : null,
//                         style: ButtonStyle(
//                 foregroundColor: WidgetStateProperty.resolveWith<Color>(
//                   (Set<WidgetState> states) {
//                     if (states.contains(WidgetState.hovered)) {
//                       return Color(0xFFFFFFFF); // Hover color
//                     }
//                     return Color(0xFFFFFFFF); // Default color (no hover)
//                   },
//                 ),
//                 overlayColor: WidgetStateProperty.resolveWith<Color>(
//                   (Set<WidgetState> states) {
//                     if (states.contains(WidgetState.hovered)) {
//                      return Color.fromARGB(255, 215, 132, 59); // Hover color
//                     }
//                     return Color.fromARGB(255, 255, 254, 254); // Default color (no hover)
//                   },
//                 ),
//                 backgroundColor: WidgetStateProperty.all(Colors.black),
//               ),
//                     child: Text("Previous"),
//                   ),
//                   Text("Page ${_currentPage + 1} of ${((products.length - 1) / _itemsPerPage).ceil() + 1}",style: TextStyle(fontWeight: FontWeight.w600),),
//                   ElevatedButton(
//                     onPressed: (_currentPage + 1) * _itemsPerPage < products.length
//                         ? () {
//                             setState(() {
//                               _currentPage++;
//                             });
//                           }
//                         : null,
//                         style: ButtonStyle(
//                 foregroundColor: WidgetStateProperty.resolveWith<Color>(
//                   (Set<WidgetState> states) {
//                     if (states.contains(WidgetState.hovered)) {
//                       return Color(0xFFFFFFFF); // Hover color
//                     }
//                     return Color(0xFFFFFFFF); // Default color (no hover)
//                   },
//                 ),
//                 overlayColor: WidgetStateProperty.resolveWith<Color>(
//                   (Set<WidgetState> states) {
//                     if (states.contains(WidgetState.hovered)) {
//                       return Color.fromARGB(255, 215, 132, 59); // Hover color
//                     }
//                     return Color.fromARGB(255, 255, 255, 255); // Default color (no hover)
//                   },
//                 ),
//                 backgroundColor: WidgetStateProperty.all(Colors.black),
//               ),
//                     child: Text("Next"),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // DataRow _buildDataRow(
//   //   BuildContext context,
//   //   int index,
//   //   String productName,
//   //   String qty,
//   //   String price,
//   // ) {
//   //   return DataRow(
//   //     cells: [
//   //       DataCell(Text((index + 1).toString())),
//   //       DataCell(Tooltip(message: productName,child: TextOverflowByChars(
//   //       text:productName,
//   //       maxCharacters: 10,
//   //     ))),
//   //       DataCell(Tooltip(message: qty,child: TextOverflowByChars(
//   //       text:qty,
//   //       maxCharacters: 10,
//   //     ))),
//   //       DataCell(Tooltip(message: price,child: TextOverflowByChars(
//   //       text:price,
//   //       maxCharacters: 10,
//   //     ))),
//   //       DataCell(_buildRowWithHover(context, index)),
//   //     ],
//   //   );
//   // }

//   Widget _buildRowWithHover(BuildContext context, int productId) {
//     return PopupMenuButton(
//       padding: EdgeInsets.all(0),
//       menuPadding: EdgeInsets.all(0),
//       constraints: BoxConstraints(maxHeight: 150.0, maxWidth: 60.0),
//       color: Colors.white,
//       itemBuilder: (context) => [
//         PopupMenuItem(
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(3),
//               color: const Color.fromARGB(255, 145, 249, 149),
//             ),
//             padding: EdgeInsets.all(10.0),
//             child: Row(
//               children: [
//                 Image.asset(
//                   "assets/icons/viewicon.png",
//                   color: Colors.green,
//                   width: 16,
//                   height: 16,
//                 ),
//               ],
//             ),
//           ),
//           onTap: () {
//             // Handle "View" action
//           },
//         ),
//         PopupMenuItem(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Color(0xFFFFBE5C),
//               borderRadius: BorderRadius.circular(3),
//             ),
//             padding: EdgeInsets.all(10.0),
//             child: Row(
//               children: [
//                 Image.asset(
//                   "assets/icons/editicon.png",
//                   color: Color(0xFFBD5C0A),
//                 ),
//               ],
//             ),
//           ),
//           onTap: () {
//             // Handle "Edit" action
//             print(productId);
//             CustomsDialogBox(
//                 product: products[productId], onUpdate: _refreshProductList);
//           },
//         ),
//         PopupMenuItem(
//           child: Container(
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 240, 157, 157),
//               borderRadius: BorderRadius.circular(3),
//             ),
//             padding: EdgeInsets.all(10.0),
//             child: Row(
//               children: [
//                 Image.asset(
//                   "assets/icons/deleteicon.png",
//                   color: const Color.fromARGB(255, 235, 98, 79),
//                 ),
//               ],
//             ),
//           ),
//           onTap: () {
//             Product product = products[productId];
//             // Handle "Delete" action
//          _showDeleteDialog(product: product);
//           },
//         ),
//       ],
//     );
//   }

//   CustomsDialogBox(
//           {required Product product, required void Function() onUpdate}) {
//         _itemnameController.text = product.itemName;
//         _qtyController.text = product.qty.toString();
//         _priceController.text = product.price.toString();
//         showDialog(
//           barrierDismissible: false,
//         context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius:
//                 BorderRadius.circular(10), // Optional: adds rounded corners
//           ),
//           child: AnimatedOpacity(
//             opacity: 1.0,
//             duration: Duration(seconds: 50),
//             child: Container(
//               width: double.infinity, // Set custom width
//               height: 350, // Set custom height
//               padding: const EdgeInsets.all(40),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           const Text('Products',
//                               style: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.w500)),
//                           Divider(),
//                           const SizedBox(height: 20),                         
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text('Item Name',
//                                         style: TextStyle(
//                                             fontSize: 16.0,
//                                             fontWeight: FontWeight.w500)),
//                                     const SizedBox(height: 5),
//                                     TextFormField(
//                                       controller: _itemnameController,
//                                       decoration: InputDecoration(
//                                         focusColor: Colors.green.shade600,
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                           width: 2.0,
//                                           style: BorderStyle.solid,
//                                           color: Color(0xFF5B89FF),
//                                         )),
//                                         border: OutlineInputBorder(),
//                                         labelText: 'Enter Item Name',                                        
//                                       ),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Item name can\'t be empty';
//                                         }
//                                         return null;})])),
//                               const SizedBox(
//                                   width: 20),                       
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text('Quantity',
//                                         style: TextStyle(
//                                             fontSize: 16.0,
//                                             fontWeight: FontWeight.w500)),
//                                     const SizedBox(height: 5),
//                                     TextFormField(
//                                       controller: _qtyController,
//                                       decoration: InputDecoration(
//                                         focusColor: Colors.green.shade600,
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                           width: 2.0,
//                                           style: BorderStyle.solid,
//                                           color: Color(0xFF5B89FF),
//                                         )),
//                                         border: OutlineInputBorder(),
//                                         labelText: 'Enter Qty',
                                       
//                                       ),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Quantity can\'t be empty';
//                                         }
//                                         if (int.tryParse(value) == null) {
//                                           return 'Enter a valid number for quantity';
//                                         }
//                                         return null; // Return null if validation passes
//                                       })])),
//                               const SizedBox(width: 20),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text('Price',
//                                         style: TextStyle(
//                                             fontSize: 16.0,
//                                             fontWeight: FontWeight.w500)),
//                                     const SizedBox(height: 5),
//                                     TextFormField(
//                                       controller: _priceController,
//                                       decoration: InputDecoration(
//                                         focusColor: Color(0xFF1EB386),
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                           width: 2.0,
//                                           style: BorderStyle.solid,
//                                           color: Color(0xFF5B89FF),
//                                         )),
//                                         border: OutlineInputBorder(),
//                                         labelText: 'Enter Price',
//                                         // errorText:
//                                         //     validateprice ? 'Price cant be empty' : null,
//                                       ),
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Price can\'t be empty';
//                                         }
//                                         if (int.tryParse(value) == null) {
//                                           return 'Enter a valid number for price';
//                                         }
//                                         return null; // Return null if validation passes
//                                       })]))]),
//                           const SizedBox(height: 40),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               ElevatedButton(
//                                   onPressed: () {
//                                     if (_formKey.currentState?.validate() ??
//                                         false) {
//                                       _updateProduct(product.id!);
//                                       Navigator.of(context).pop();
//                                     } else {
//                                       print("Validation failed");
//                                     }},
//                                   style: ButtonStyle(
//                                     foregroundColor:
//                                         WidgetStateProperty.resolveWith<Color>(
//                                       (Set<WidgetState> states) {
//                                         if (states
//                                             .contains(WidgetState.hovered)) {
//                                           return Color(
//                                               0xFFFFFFFF); // Hover color
//                                         }
//                                         return Color(
//                                             0xFFFFFFFF); // Default color (no hover)
//                                       }),
//                                     overlayColor:
//                                         WidgetStateProperty.resolveWith<Color>(
//                                       (Set<WidgetState> states) {
//                                         if (states
//                                             .contains(WidgetState.hovered)) {
//                                           return Color(
//                                               0xFF1EB386); // Hover color
//                                         }
//                                         return Color(
//                                             0xFF1EB386); // Default color (no hover)
//                                       }),
//                                     backgroundColor: WidgetStateProperty.all(
//                                         Color(0xFF1EB386)),
//                                   ),
//                                   child: Text("Save")),
//                               SizedBox(width: 15.0),
//                               ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop(context);
//                                   },
//                                   style: ButtonStyle(
//                                     foregroundColor:
//                                         WidgetStateProperty.resolveWith<Color>(
//                                       (Set<WidgetState> states) {
//                                         if (states
//                                             .contains(WidgetState.hovered)) {
//                                           return Color(
//                                               0xFFFFFFFF); // Hover color
//                                         }
//                                         return Color(
//                                             0xFFFFFFFF); // Default color (no hover)
//                                       }),
//                                     overlayColor:
//                                         WidgetStateProperty.resolveWith<Color>(
//                                       (Set<WidgetState> states) {
//                                         if (states
//                                             .contains(WidgetState.hovered)) {
//                                           return Color(
//                                               0xFF5B89FF); // Hover color
//                                         }
//                                         return Color(
//                                             0xFF5B89FF); // Default color (no hover)
//                                       }),
//                                     backgroundColor: WidgetStateProperty.all(
//                                         Color(0xFF5B89FF)),
//                                   ),
//                                   child: Text("Close")),
//                             ])]))],
//               ))));});}
// void _showDeleteDialog({required Product product}) {
//   showDialog(
//     context: context,
//     barrierDismissible: true, // Allows the user to dismiss the dialog by tapping outside
//     builder: (BuildContext context) {
//       return AlertDialog(
//         icon: Icon(Icons.delete,color: Colors.red),
//         content: Text("Do you wish to delete this record?",style: TextStyle(fontWeight: FontWeight.w500),),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Perform the delete action
//               _deleteProduct(product.id!);
//               Navigator.of(context).pop(); // Close the dialog after deletion
//             },
//             style: TextButton.styleFrom(
//             foregroundColor: Colors.white, // Text color
//             backgroundColor: Colors.green.shade500, // Background color
//             shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
//     ),
//   ).copyWith(
//     overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
//       if (states.contains(WidgetState.hovered)) {
//         return Colors.white.withOpacity(0.2); // Hover color with slight transparency
//       }
//       return null; // Default state
//     }),),
//             child: Text("Yes"),
//           ),
//           TextButton(
//             onPressed: () {
//               // Close the dialog without deleting
//               Navigator.of(context).pop();
//             },
//             style: TextButton.styleFrom(
//             foregroundColor: Colors.white, // Text color
//             backgroundColor: Colors.blue, // Background color
//             shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(6.0), // Optional: Rounded corners
//     ),
//   ).copyWith(
//     overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
//       if (states.contains(WidgetState.hovered)) {
//         return Colors.white.withOpacity(0.2); // Hover color with slight transparency
//       }
//       return null; // Default state
//     }),),
//             child: Text("No"),
//           )]);});
// }

// }




