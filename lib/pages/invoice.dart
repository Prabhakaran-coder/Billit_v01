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
  final bool _shouldRebuild = false;
   void _navigateToAddInvoicePage() async {
    // Navigate to the second page and wait for the result
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DynamicTable()),
    );

    // Once you return from the second page, you can update the state based on the result
    setState(() {
     homeinvoicetable();  // Use the returned result to update state
    });
    }

  @override
  Widget build(BuildContext context) {
    // void showinvoiceDialog() {
    //   invoiceDialog(context); // Call the dialog here
    // }
     final menuHeader = Provider.of<MyState>(context).menuHeaderValue;
    return Scaffold(
      body:Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 241, 242, 245)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              
              Container(
    color: Color(0xFFFFFFFF),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(menuHeader,style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
          ElevatedButton(
              onPressed: _navigateToAddInvoicePage,
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
                      return Color(0xFF5B89FF); // Hover color
                    }
                    return Color(0xFF000000); // Default color (no hover)
                  },
                ),
                backgroundColor: WidgetStateProperty.all(Colors.black),
              ),
              child: Text("+Add")),
        ],
      ),
    ),
  ),
  
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




