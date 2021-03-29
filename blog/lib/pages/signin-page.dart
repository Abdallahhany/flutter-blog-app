import 'dart:convert';
import 'package:blog/Network/Network-handler.dart';
import 'package:blog/pages/forget-password.dart';
import 'package:blog/pages/home-page.dart';
import 'package:blog/pages/signUp-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool vis = true;
  final _globalKey = GlobalKey<FormState>();
  NetworkHandling networkHandling = NetworkHandling();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  bool validate = false;
  bool circular = false;
  String errorMsg;
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child:Form(
          key:_globalKey ,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 120.0,horizontal: 15.0),
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sign In" ,textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2,),),
              SizedBox(height: 20,),
              userNameTextField(),
              passwordTextField(),
              SizedBox(height: 20,),
              InkWell(
                onTap: () async{
                  setState(() {
                    circular = true;
                  });
                  Map <String,String> data ={
                    "username":userNameTextEditingController.text,
                    "password":passwordTextEditingController.text,
                  };
                  var response = await networkHandling.post('users/login', data);
                  if(response.statusCode ==200 || response.statusCode == 201){
                    Map<String,dynamic> output = await jsonDecode(response.body);
                    print(output['token']);
                    await storage.write(key: "token", value: output['token']);
                    setState(() {
                      validate = true;
                      circular = false;
                    });
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomePage()),(route)=>false);
                  }
                  else{
                    String output = await jsonDecode(response.body);
                    setState(() {
                      validate = false;
                      errorMsg = output;
                      circular = false;
                    });
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff00A868)
                  ),
                  child: Center(child:circular? CircularProgressIndicator() : Text("SignIn",style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,),)),
                ),
              ),
              SizedBox(height: 14.0,),
//              Divider(height: 30,thickness: 0.8,color: Colors.black,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap:(){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignUpPage()));
                    } ,
                    child: Text("New User?",style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                  InkWell(
                    onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgetPassword()));
                    } ,
                    child: Text("Forget password?",style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget userNameTextField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        children: [
          Text("User Name"),
          TextFormField(
            controller: userNameTextEditingController,
            decoration: InputDecoration(
                errorText: validate ? null : errorMsg,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                    )
                )
            ),
          )
        ],
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        children: [
          Text("Password"),
          TextFormField(
            controller: passwordTextEditingController,
            obscureText: vis,
            decoration: InputDecoration(
                errorText: validate ? null : errorMsg,
                suffixIcon: IconButton(
                  icon:Icon(vis ? Icons.visibility_off: Icons.visibility),
                  onPressed: () {
                    setState(() {
                      vis = !vis;
                    });
                  },
                ),
                // helperText: "Password should be more than 6 characters",
                // helperStyle: TextStyle(
                //   fontSize: 14,
                // ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                    )
                )
            ),
          )
        ],
      ),
    );
  }
}
