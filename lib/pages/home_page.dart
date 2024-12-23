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
    return Column(
      children: [
        SvgPicture.asset("assets/icons/Logo.svg", width: 200.0, height: 100.0),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          child: Container(
            child: MenuBuilder(),
          ),
        ),
      ],
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
            margin: EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(
                color: selectedItem ? Color(0xFF1EB386) : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(3.0))),
            child: ListTile(
              leading: SvgPicture.asset(
                popmenus.icons[index],
                color: selectedItem ? Color(0xFFFFFFFF) : Color(0xFF667085),
              ),
              title: Text(
                popmenus.menu[index],
                style: TextStyle(
                  color: selectedItem ? Color(0xFFFFFFFF) : Color(0xFF667085),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                  letterSpacing: 0.5,
                ),
              ),
              // minVerticalPadding: 20.0,

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
