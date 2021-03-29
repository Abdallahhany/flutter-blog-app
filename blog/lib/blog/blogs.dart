import 'package:blog/Model/addBlogModel.dart';
import 'package:blog/Model/superModel.dart';
import 'package:blog/Network/Network-handler.dart';
import 'package:blog/customWidgets/blogCard.dart';
import 'package:flutter/material.dart';

import 'fullBlog.dart';

class Blogs extends StatefulWidget {
  final String url;
  Blogs({this.url});
  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandling networkHandling =NetworkHandling();
  SuperModel superModel = SuperModel();
  List<AddBlogModel> data = [];

  void fetchData()async{
    var response = await networkHandling.get(widget.url);
    superModel = SuperModel.fromJson(response);
    setState(() {
      data =superModel.data;
    });
  }
  @override
  void initState() {
    fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return data.length > 0
        ? Column(
      children: data
          .map((item) => Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullBlog(
                        addBlogModel: item,
                        networkHandling: networkHandling,
                      )));
            },
            child: BlogCard(
              addBlogModel: item,
              networkHandling: networkHandling,
            ),
          ),
          SizedBox(
            height: 0,
          ),
        ],
      ))
          .toList(),
    )
        : Center(
      child: Text("We don't have any Blog Yet"),
    );
  }
}
