import 'package:blog/pages/home-page.dart';
import 'package:blog/pages/welcome-page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = WelcomePage();
  final storage = new FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    checkLogin();
  }
  void checkLogin()async{
    String token = await storage.read(key: "token");
    if (token != null ){
      setState(() {
        page = HomePage();
      });
    }else{
      setState(() {
        page = WelcomePage();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Blog App',
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: page,
    );
  }
}
