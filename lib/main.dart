import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:billit/database/Firestore/profilesync.dart';
import 'package:billit/database/product_database_helper.dart';
import 'package:billit/pages/home_page.dart';
import 'package:billit/models/pageroute.dart';
import 'package:billit/pages/login.dart';
import 'package:billit/pages/profile.dart';
import 'package:billit/providers/paymentprovider.dart';
// import 'package:billit/models/pageroute.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billit/models/providercurrentindex.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'firebase_options.dart';
import 'dart:async';
// import 'package:flutter_svg/svg.dart';

// final pages=Pageroute();
void main() async{
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  await ProductDatabaseHelper.database;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(    
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final _syncService = ProfileSyncService();
  

  // Run immediate sync once when app starts
  // await _syncService.syncFromFirestore();

  // Set periodic sync every 10 minutes
  Timer.periodic(const Duration(minutes: 3), (timer) async {
  print("Running scheduled sync...");

  try {
    print("syncToFirestore started...");
    await _syncService.syncProfilesToFirestore();
    print("syncToFirestore completed.");
  } catch (e, st) {
    print("Error in syncToFirestore: $e");
    print(st);
  }

try {
    print("syncToFirestore started...");
    await _syncService.syncCustomersToFirestore();
    print("syncToFirestore completed.");
  } catch (e, st) {
    print("Error in syncToFirestore: $e");
    print(st);
  }
  // try {
  //   print("syncFromFirestore started...");
  //   await _syncService.syncFromFirestore();
  //   print("syncFromFirestore completed.");
  // } catch (e, st) {
  //   print("Error in syncFromFirestore: $e");
  //   print(st);
  // }

  try {
    print("syncToinvoiceHeartoFirestore started...");
    await _syncService.syncProductsToFirestore();
    print("syncToinvoiceHeartoFirestore completed.");
  } catch (e, st) {
    print("Error in syncToinvoiceHeartoFirestore: $e");
    print(st);
  }

  try {
    print("syncInvoicesDetailToFirestore started...");
    await _syncService.syncInvoicesToFirestore();
    print("syncInvoicesDetailToFirestore completed.");
  } catch (e, st) {
    print("Error in syncInvoicesDetailToFirestore: $e");
    print(st);
  }

  print(" Sync completed at ${DateTime.now()}");
   try {
    print("syncInvoicesDetailToFirestore started...");
    await _syncService.syncPaymentsToFirestore();
    print("syncInvoicesDetailToFirestore completed.");
  } catch (e, st) {
    print("Error in syncInvoicesDetailToFirestore: $e");
    print(st);
  }
});

  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
       ChangeNotifierProvider(
      create: (context) => MyState())
      ],
   child: MyApp(),
    ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BillitAuthPage(),     
      theme: ThemeData(fontFamily: 'Inter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
 
  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }
 
  void _openDropdown() {
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }
 
  void _closeDropdown() {
    _overlayEntry?.remove();
    setState(() {
      _isDropdownOpen = false;
    });
  }
  OverlayEntry _createOverlayEntry() {
    
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
 
    return 
    
    OverlayEntry(
      builder: (context) => Positioned(
        width: 150,
        top: offset.dy + 50,
        left: offset.dx + size.width - 180,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, 50),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dropdownItem(context,"Profile", Icons.person,() {
                    
                   profileDialog(context);
                    _closeDropdown();
                  }),
                  _dropdownItem(context,"Settings", Icons.settings, () {
                    print("Settings clicked");
                    _closeDropdown();
                  }),
                  _dropdownItem(context,"Logout", Icons.logout, () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BillitAuthPage()),
                  );
                    _closeDropdown();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
 
  Widget _dropdownItem(BuildContext context, String text, IconData icon, VoidCallback onTap, ) {
       bool isHovering = false; 
     
    return StatefulBuilder(
      builder: (context,setState){      
        return InkWell(
        onTap: onTap,
        onHover: (hovering) {
            setState(() => isHovering = hovering);
          },
        child: Container(
          decoration: BoxDecoration(
            color: isHovering?const Color.fromARGB(102, 219, 219, 219) : Colors.transparent,

            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isHovering?Colors.blue : Colors.black,),
              SizedBox(width: 10),
              Text(text, style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600, color: isHovering?Colors.blue : Colors.black,)),
            ],
          ),
        ),
      ); 
      },
      
    );
  }
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,      
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: const Color.fromARGB(255, 33, 51, 243),
               
                child: Column(
                  children: [
                    Expanded(
                      child: HomePage(),
                    )
                  ],
                ),
              )),
      
          //----------center content------//
          Expanded(
            flex: 6,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.zero),
                    border: Border(left: BorderSide.none),
                      color: const Color.fromARGB(255, 33, 51, 243),
                    boxShadow: [
                                       BoxShadow(
                                            color: Colors.blue.withOpacity(0.1),                                                                                  
                                            blurRadius: 50,
                                            spreadRadius: 10,
                                          ),
                                    ],
                  ),
                  //color: const Color.fromARGB(255, 5, 3, 144),
                
                  child: Stack(
                    children: [                   
                      Container(
                         decoration: BoxDecoration(color: const Color.fromARGB(255, 243, 243, 243),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                          
                            ),                      
                               width: double.infinity,
                              height: 60.0,                                  
                         child: Container(
                            decoration: BoxDecoration(color: const Color.fromARGB(255, 253, 253, 253),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),     
                                                     
                           child: Padding(
                              padding: const EdgeInsets.only(left: 34.0, right: 20.0),
                               child: Row(
                                children: [
                            Text("Billit Application V0.1",style: TextStyle(fontSize: 14),),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: CompositedTransformTarget(
                                link: _layerLink,
                                child: GestureDetector(
                                  onTap: _toggleDropdown,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                       child: 
                                            Image.asset("assets/Images/profile.png",height: 100,width: 100,)                                          
                                      ),
                                      Text("Prabhakaran"),
                                       Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                ),
                              ),  
                            ) ],
                            ),
                          ),
                         ),
                        ),
                    ],
                     
                  ),
                ),
                Expanded(
                    child: Container(   
                      color: Color.fromRGBO(255, 255, 255, 1),                     
                  child: Pages(),
                ))
              ],
            )),
        ],
      ),
    );
  }
}
