import 'dart:convert';

import 'package:blog/Network/Network-handler.dart';
import 'package:blog/pages/signUp-page.dart';
import 'package:blog/pages/signin-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'home-page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin{
  AnimationController _controller1;
  Animation<Offset> animation1;
  AnimationController _controller2;
  Animation<Offset> animation2;
  bool _isLoggedIn = false;
  Map oData;
  final facebookLogin = FacebookLogin();
  final storage = new FlutterSecureStorage();
  NetworkHandling networkHandling =NetworkHandling();
  @override
  void initState() {
    _controller1 = AnimationController(duration:Duration(milliseconds: 1000) ,vsync: this);
    animation1 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeOut),
    );
    _controller2 = AnimationController(duration:Duration(milliseconds: 2500) ,vsync: this);
    animation2 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.elasticInOut),
    );
    _controller1.forward();
    _controller2.forward();

    super.initState();
  }
  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.green
            ],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0,1.0],
            tileMode: TileMode.repeated
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0,horizontal: 40.0),
          child: Column(
            children: [
              SlideTransition(
                position: animation1,
                child: Text(
                  "My Blog App",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/6,),
              SlideTransition(
                position: animation1,
                child: Text(
                  "Great stories for great people",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 38,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              boxContainer("assets/google.png", "Sign up with Google",onEmailClick),
              SizedBox(
                height: 20,
              ),
              boxContainer(
                  "assets/facebook1.png", "Sign up with Facebook",onFBLogin),
              SizedBox(
                height: 20,
              ),
              boxContainer(
                "assets/email2.png",
                "Sign up with Email",
                onEmailClick
              ),
              SlideTransition(
                position: animation2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignInPage()));
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  onFBLogin() async{
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        var url = Uri.parse('https://graph.facebook.com/v2.9/me?fields=name,picture,email&access_token=$token');
        final response = await http.get(url);
        final data = jsonDecode(response.body);

        print(data["name"]);
        print(data["email"]);
        print(data["id"]);
        Map<String ,String> FaceBookData = {
          "username":data["name"],
          "email":data["email"],
          "password":data["id"]
        };
        networkHandling.post("users/signup", FaceBookData);

        setState(() {
          _isLoggedIn = true;
          oData = data;
        });
        await storage.write(key: "token", value: token);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomePage()),(route)=>false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        setState(() {
          _isLoggedIn = false;
        });
        break;
      case FacebookLoginStatus.error:
        setState(() {
          _isLoggedIn = false;
        });
        break;
    }
  }
  onEmailClick() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpPage()));
  }
  Widget boxContainer(String path, String text, onClick ){
    return SlideTransition(
      position: animation2,
      child: InkWell(
        onTap: onClick ,
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width - 140,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Image.asset(path,height: 25,width: 25,),
                  SizedBox(width: 20),
                  Text(
                    text,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
