 
 
 import 'package:flutter/material.dart';

void _showCustomDialog(BuildContext context) {
    Dialog(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      insetAnimationDuration: Duration(seconds: 10),
      shape: RoundedRectangleBorder(),
      child: Row(
        children: [
         Container( decoration: BoxDecoration(color: Colors.green.shade400), width: 10.0,
         child:  Icon(Icons.remove_red_eye_outlined,color: Colors.white,),),
         Container( decoration: BoxDecoration(color: Colors.green.shade400),color: Colors.white,child:  Icon(Icons.edit),),
         Container( decoration: BoxDecoration(color: Colors.green.shade400),color: Colors.white,child: Icon(Icons.delete),),
          
        ],
      ),
    );

  }