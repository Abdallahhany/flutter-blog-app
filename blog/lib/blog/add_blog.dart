import 'dart:convert';

import 'package:blog/Model/addBlogModel.dart';
import 'package:blog/Network/Network-handler.dart';
import 'package:blog/customWidgets/overlay-widget.dart';
import 'package:blog/pages/home-page.dart';
import 'package:blog/profile/main-profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddBlog extends StatefulWidget {
  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  bool circular = false;
  final _globalKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  IconData iconPhoto = Icons.image;
  NetworkHandling networkHandling = NetworkHandling();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        elevation: 0.0,
        leading:IconButton(icon: Icon(Icons.clear),onPressed: (){
          Navigator.pop(context);
        },color: Colors.black,),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if(_imageFile.path != null&& _globalKey.currentState.validate()){
                showModalBottomSheet(context: context,
                    builder: ((builder)=>OverlayWidget(imageFile: _imageFile,title:_title.text ,)));
              }
            },
            child: Text(
              "Preview",
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          )
        ],
      ),
      body: Form(
        key: _globalKey,
        child: ListView(
          children: [
            titleTextField(),
            bodyTextField(),
            SizedBox(
              height: 20,
            ),
            addButton(),
          ],
        ),
      ),
    );
  }
  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextFormField(
        controller: _title,
        validator: (value) {
          if (value.isEmpty) {
            return "Title can't be empty";
          } else if (value.length > 100) {
            return "Title length should be <=100";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          labelText: "Add Image and Title",
          prefixIcon: IconButton(
            icon: Icon(
              iconPhoto,
              color: Colors.teal,
            ),
            onPressed: addCoverPhoto,
          ),
        ),
        maxLength: 100,
        maxLines: null,
      ),
    );
  }
  Widget bodyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        controller: _body,
        validator: (value) {
          if (value.isEmpty) {
            return "Body can't be empty";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          labelText: "Provide Body Your Blog",
        ),
        maxLines: null,
      ),
    );
  }
  Widget addButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        if (_imageFile != null && _globalKey.currentState.validate()) {
          AddBlogModel addBlogModel =
          AddBlogModel(body: _body.text, title: _title.text);
          var response = await networkHandling.postBlog(
              "blogPosts/addPost", addBlogModel.toJson());
          print(response.body);

          if (response.statusCode == 200 || response.statusCode == 201) {
            String id = json.decode(response.body)["data"];
            print(id);
            var imageResponse = await networkHandling.patchImage(
                "blogPosts/add/coverImage/$id", _imageFile.path);
            print(imageResponse.statusCode);
            if (imageResponse.statusCode == 200 ||
                imageResponse.statusCode == 201) {
              setState(() {
                circular = false;
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainProfile()),
                      (route) => false);
            }else{
              setState(() {
                circular = false;
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainProfile()),
                      (route) => false);
            }
          }
        }
      },
      child: Center(
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.teal),
          child: Center(
              child:circular? CircularProgressIndicator(): Text(
                "Add Blog",
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }
  void addCoverPhoto() async {
    final coverPhoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = coverPhoto;
      if(coverPhoto.path != null)
        iconPhoto = Icons.check_box;
    });
  }
}
