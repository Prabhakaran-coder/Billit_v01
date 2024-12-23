import 'package:billit/pages/home_page.dart';
import 'package:billit/models/providercurrentindex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Pages(){
  
 
  return PageView.builder(itemCount: popmenus.pages.length, physics: NeverScrollableScrollPhysics(),itemBuilder: (context,index){
    
    int current = Provider.of<MyState>(context).value;
    if (current >= 0 && current < popmenus.pages.length) {
                  return popmenus.pages[current];
                } else {                 
                  return Center(child: Text("Page not found"));
                }  
  });
}


