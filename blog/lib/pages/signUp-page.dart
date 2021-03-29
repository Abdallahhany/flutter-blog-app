import 'dart:convert';

import 'package:blog/Network/Network-handler.dart';
import 'package:blog/pages/signin-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'home-page.dart';



class SignUpPage extends StatefulWidget {
  //static String  id = 'SignUpPage';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool vis = true;
  final _globalKey = GlobalKey<FormState>();
  NetworkHandling networkHandling =NetworkHandling();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  bool validate = false;
  bool circular = false;
  String errorMsg;
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
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
          child: Form(
            key:_globalKey ,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 120.0,horizontal: 15.0),
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sign Up with Email" ,textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2,),),
                SizedBox(height: 20,),
                userNameTextField(),
                emailTextField(),
                passwordTextField(),
                SizedBox(height: 20,),
                InkWell(
                  onTap: ()async{
                    setState(() {
                      circular = true;
                    });
                    await checkUser();
                    if(_globalKey.currentState.validate() && validate){
                      Map <String,String> data ={
                        "username":userNameTextEditingController.text,
                        "email":emailTextEditingController.text,
                        "password":passwordTextEditingController.text,
                      };
                      print (data);
                      //send data to server
                      await networkHandling.post("users/signup", data);
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network Error')));
                        //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Network Error')));
                      }
                      setState(() {
                        circular = false;
                      });
                    }else{
                      setState(() {
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
                    child: Center(child: circular? CircularProgressIndicator() : Text("SignUp",style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,),)),
                  ),
                ),
                SizedBox(height: 12.0,),
                InkWell(
                  onTap:(){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignInPage()));
                  } ,
                  child: Text("Already have an account?",textAlign: TextAlign.right,style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
              ],
            ),
          ),
      )
    );
  }
  checkUser() async{
    if(userNameTextEditingController.text.isEmpty){
      setState(() {
        circular = false;
        validate = false ;
        errorMsg = " username can't be empty ";
      });
    }
    else{
      var response = await networkHandling.get('users/checkusername/${userNameTextEditingController.text}');
      if (response['status']){
        setState(() {
          //circular = false;
          validate = false ;
          errorMsg = " username is already used ";
        });
      }
      else{
        validate = true;
      }
    }
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
  Widget emailTextField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        children: [
          Text("Email"),
          TextFormField(
            controller: emailTextEditingController,
            keyboardType:TextInputType.emailAddress,
            validator: (value){
              if(value.isEmpty)
                return " email can't be empty ";
              if(!value.contains("@"))
                return "email is invalid";
              return null;
              //username unique or not
            },
            decoration: InputDecoration(
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
            validator: (value){
              if(value.isEmpty)
                return " password can't be empty ";
              if(value.length <6)
                return " password length should be more than 6";
              return null;
              //username unique or not
            },
            obscureText: vis,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon:Icon(vis ? Icons.visibility_off: Icons.visibility),
                onPressed: () {
                    setState(() {
                      vis = !vis;
                    });
                 },
              ),
              helperText: "Password should be more than 6 characters",
                helperStyle: TextStyle(
                  fontSize: 14,
                ),
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