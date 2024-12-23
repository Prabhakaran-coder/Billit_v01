import 'package:billit/pages/home_page.dart';
import 'package:billit/models/pageroute.dart';
// import 'package:billit/models/pageroute.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:billit/models/providercurrentindex.dart';
// import 'package:flutter_svg/svg.dart';

// final pages=Pageroute();
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyState(),
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
      home: MyHomePage(),
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
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
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
                children: [
                  Container(
                    width: double.infinity,
                    height: 60.0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        children: [
                          Text("Billit Application V0.1"),
                          Spacer(),
                          CircleAvatar(
                            foregroundImage:
                                AssetImage("assets/images/profile.png"),
                          ),
                          Text("Prabha")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        
                    child: Pages(),
                  ))
                ],
              )),
        ],
      ),
    );
  }
}
