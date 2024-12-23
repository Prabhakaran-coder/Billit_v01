import 'package:flutter/material.dart';


  Container menuHeaders(String menuHeader,Function dialogmethod) {
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
               dialogmethod();
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
  );
 }
 

 