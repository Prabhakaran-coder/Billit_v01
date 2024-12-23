import 'package:billit/models/menuheader.dart';
import 'package:billit/models/providercurrentindex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  @override
  Widget build(BuildContext context) {
    void showinvoiceDialog() {
      invoiceDialog(context); // Call the dialog here
    }
     final menuHeader = Provider.of<MyState>(context).menuHeaderValue;
    return Scaffold(
      body:menuHeaders(menuHeader,showinvoiceDialog)
    );
  }
}

Future<void> invoiceDialog(BuildContext context) async {
    return showDialog(
      context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Add Invoice", style: TextStyle(color: Colors.black)),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("Invoice"),
                  TextField(),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text("Save")),
            ],
          );
        });
  }
