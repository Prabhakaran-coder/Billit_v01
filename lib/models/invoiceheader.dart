import 'package:flutter/material.dart';


Container InvoicemenuHeaders(String menuHeader,BuildContext context) {
    return Container(
    color: Color(0xFFFFFFFF),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(menuHeader,style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
          ElevatedButton(
              onPressed: () {
                
              
              },
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
                      return Color(0xFF5B89FF); 
                    }
                    return Color(0xFF000000); 
                  },
                ),
                backgroundColor: WidgetStateProperty.all(Colors.black),
              ),
              child: Text("+Add")),
        ],
      ),
    ),
  );
 }
 