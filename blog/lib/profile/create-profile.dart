import 'dart:io';

import 'package:blog/Network/Network-handler.dart';
import 'package:blog/pages/home-page.dart';
import 'package:blog/profile/main-profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateProfile extends StatefulWidget {
  final bool edit;
  CreateProfile({this.edit});
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  TextEditingController _name = TextEditingController();
  TextEditingController _profession = TextEditingController();
  TextEditingController _dob = TextEditingController();
  //TextEditingController _title = TextEditingController();
  TextEditingController _about = TextEditingController();
  PickedFile _imageFile;
  final ImagePicker _picker =ImagePicker();
  final _globalKey = GlobalKey<FormState>();
  bool circular = false;
  final networkHandling = NetworkHandling();

  bool get isEditing => widget.edit != false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _globalKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ListView(
              children: [
                imageProfile(),
                SizedBox(height: 20,),
                nameTextField(),
                SizedBox(height: 20,),
                professionTextField(),
                SizedBox(height: 20,),
                dobField(),
                // SizedBox(height: 20,),
                // titleTextField(),
                SizedBox(height: 20,),
                aboutTextField(),
                SizedBox(height: 20,),
                InkWell(
                  onTap: () async{
                    setState(() {
                      circular =true;
                    });

                    if(_globalKey.currentState.validate()){
                      Map<String, String> data = {
                        "name": _name.text,
                        "profession": _profession.text,
                        "DOB": _dob.text,
                        //"titleline": _title.text,
                        "about": _about.text,
                      };
                      if(!isEditing){
                        var response = await networkHandling.post('profile/add', data);
                        if(response.statusCode == 200 || response.statusCode == 201){
                          if(_imageFile != null){
                            var imageResponse = await networkHandling.patchImage("profile/add/image", _imageFile.path);
                            if(imageResponse.statusCode ==200){
                              setState(() {
                                circular = false;
                              });
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MainProfile()), (route) => false);
                            }
                          }else{
                            setState(() {
                              circular = false;
                            });
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MainProfile()), (route) => false);
                          }
                        }
                      }
                      else if(isEditing){
                        Map<String, String> data = {
                          "name": _name.text,
                          "profession": _profession.text,
                          "DOB": _dob.text,
                          //"titleline": _title.text,
                          "about": _about.text,
                        };
                        var response = await networkHandling.patch('profile/updateProfileData', data);
                        if(response.statusCode == 200 || response.statusCode == 201){
                          if(_imageFile != null){
                            var imageResponse = await networkHandling.patchImage("profile/add/image", _imageFile.path);
                            if(imageResponse.statusCode ==200){
                              setState(() {
                                circular = false;
                              });
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MainProfile()), (route) => false);
                            }
                          }else{
                            setState(() {
                              circular = false;
                            });
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MainProfile()), (route) => false);
                          }
                        }
                      }

                    }
                  },
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: circular
                            ? CircularProgressIndicator()
                            : Text(isEditing?
                            "update":"Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void takePhoto(ImageSource source)async{
    final pickedImage = await _picker.getImage(
        source: source
    );
    setState(() {
      _imageFile = pickedImage;
    });
  }
  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage:
          _imageFile == null
              ? AssetImage("assets/profile.jpg")
              : FileImage(File(_imageFile.path)),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }
  Widget nameTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value.isEmpty) return "Name can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            )
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Name",
        helperText: "Name can't be empty",
        hintText: "Rashed",
      ),
    );
  }
  Widget professionTextField() {
    return TextFormField(
      controller: _profession,
      validator: (value) {
        if (value.isEmpty) return "Profession can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Profession",
        helperText: "Profession can't be empty",
        hintText: "Flutter Developer",
      ),
    );
  }
  Widget dobField() {
    return TextFormField(
      controller: _dob,
      validator: (value) {
        if (value.isEmpty) return "DOB can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Date Of Birth",
        helperText: "Provide DOB on dd/mm/yyyy",
        hintText: "17/08/2001",
      ),
    );
  }
  // Widget titleTextField() {
  //   return TextFormField(
  //     controller: _title,
  //     validator: (value) {
  //       if (value.isEmpty) return "Title can't be empty";
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: Colors.teal,
  //           )),
  //       focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: Colors.orange,
  //             width: 2,
  //           )),
  //       prefixIcon: Icon(
  //         Icons.person,
  //         color: Colors.green,
  //       ),
  //       labelText: "Title",
  //       helperText: "It can't be empty",
  //       hintText: "Flutter Developer",
  //     ),
  //   );
  // }
  Widget aboutTextField() {
    return TextFormField(
      controller: _about,
      validator: (value) {
        if (value.isEmpty) return "About can't be empty";
        return null;
      },
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            )),
        labelText: "About",
        helperText: "Write about yourself",
        hintText: "I am Abdallah Rashed",
      ),
    );
  }
}
