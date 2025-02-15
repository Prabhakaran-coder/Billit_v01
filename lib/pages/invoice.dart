import 'package:billit/models/invoiceheader.dart';
import 'package:billit/models/menuheader.dart';
import 'package:billit/models/providercurrentindex.dart';
import 'package:billit/pages/addInvoice.dart';
import 'package:billit/pages/homeinvoicetable.dart';
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
    // void showinvoiceDialog() {
    //   invoiceDialog(context); // Call the dialog here
    // }
     final menuHeader = Provider.of<MyState>(context).menuHeaderValue;
    return Scaffold(
      body:Container(
        decoration: BoxDecoration(color: Color(0xFFFAFAFA)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              InvoicemenuHeaders(menuHeader,context),
               SizedBox(
                height: 20.0,
              ),
              homeinvoicetable(),
            ],
          ),
        ),
      )
    );
  }
}




