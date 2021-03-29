import 'package:blog/Model/addBlogModel.dart';
import 'package:blog/Network/Network-handler.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  BlogCard({this.addBlogModel, this.networkHandling});

  final AddBlogModel addBlogModel;
  final NetworkHandling networkHandling;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/image.jpg'),
                    //networkHandling.getImage(addBlogModel.id),
                    fit: BoxFit.fill),
              ),
            ),
            Positioned(
              bottom: 2,
              child: Container(
                padding: EdgeInsets.all(7),
                height: 60,
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  addBlogModel.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

