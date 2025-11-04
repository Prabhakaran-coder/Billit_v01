// import 'package:billit/main.dart';
import 'package:billit/models/menu_details.dart';
import 'package:billit/models/providercurrentindex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';



final popmenus = menuDetails();
 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  
  //String? _label;
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body:Column(
        children: [          
          Padding(
            padding: const EdgeInsets.only(left: 20,top: 15),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Image.asset("assets/Icons/logo.png",height: 30,width: 30),
                Text("Billit",                    
                style: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,fontSize: 30,color: Colors.white,),
                ),
              ],
            ),
          ),
          Divider(thickness: 0.5,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: Container(
              child: MenuBuilder(),
            ),
          ),
        ],
            ),
      );
  }

//--------Menus----------------///

  ListView MenuBuilder() {
    return ListView.builder(
      
        shrinkWrap: true,
        itemCount: popmenus.menu.length,
        itemBuilder: (context, index) {
          int currentIndex = Provider.of<MyState>(context).value;
          bool selectedItem = false;
          selectedItem = currentIndex == index;
          //_label = menu[currentIndex];
          return Container(
            margin: EdgeInsets.only(left:3,top: 20,bottom: 20),
            decoration: BoxDecoration(              
                color: selectedItem ? Color.fromARGB(28, 244, 244, 244) : Colors.transparent,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(10))),
            child: ListTile(
              splashColor: Colors.transparent,
              leading: SizedBox(
                width: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(selectedItem)
                    Container(
                      width: 3,
                      height: 20,
                      //color: Color.fromARGB(255, 89, 234, 91),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 89, 234, 91),
                        borderRadius: BorderRadius.circular(3)),
                    ),
                    
                  SvgPicture.asset(
                  popmenus.icons[index],
                  color: selectedItem ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 219, 218, 218),
                ),
                  ],
                ),
              ),
              title: Text(
                popmenus.menu[index],
                style: TextStyle(
                  color: selectedItem ? Color(0xFFFFFFFF) : Color.fromARGB(255, 219, 218, 218),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                  letterSpacing: 0.5,
                ),
              ),
              // minVerticalPadding: 20.0
            contentPadding: EdgeInsets.only(left: 0),
              minTileHeight: 20.0,
              onTap: () {
                
                 Provider.of<MyState>(context, listen: false).updateValue(index, popmenus.menu[index]);
              },
            
              //hoverColor: Colors.red,
            ),
          );
        });
  }
}
