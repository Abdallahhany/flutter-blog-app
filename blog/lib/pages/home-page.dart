import 'package:blog/Model/ProfileModel.dart';
import 'package:blog/blog/add_blog.dart';
import 'package:blog/pages/welcome-page.dart';
import 'package:blog/screens/homeScreen.dart';
import 'file:///F:/Blog/flutter/blog/lib/profile/profile-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blog/Network/Network-handler.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool circular = false;
  final networkHandling = NetworkHandling();
  String username = "";
  Widget profilePhoto = CircleAvatar(
      radius: 50.0,
      backgroundImage:
      AssetImage("assets/profile.jpg")
  );
  ProfileModel profileModel = ProfileModel();
  void checkProfile() async {
    var response = await networkHandling.get("profile/checkProfile");
    setState(() {
      username = response["username"];
    });
    if (response["status"] == true) {
      setState(() {
         profilePhoto = CircleAvatar(
             radius: 50,
             backgroundImage: AssetImage("assets/profile.jpg")
           //networkHandling.getImage(profileModel.username),
         );
      });
    }
    setState(() {
      circular = false;
    });
  }
  int currentState = 0;
  final storage = new FlutterSecureStorage();
  List<Widget> screens =[
    HomeScreen(),
    ProfileScreen(),
  ];
  List<String> titleString = ["Home Page", "Profile Page"];
  @override
  void initState() {
    setState(() {
      circular = true;
    });
    checkProfile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  profilePhoto,
                  SizedBox(
                    height: 10,
                  ),
                  Text("@$username"),
                ],
              ),
            ),
            ListTile(
              title: Text("All Post"),
              trailing: Icon(Icons.launch),
              onTap: () {},
            ),
            ListTile(
              title: Text("New Story"),
              trailing: Icon(Icons.add),
              onTap: () {},
            ),
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings),
              onTap: () {},
            ),
            ListTile(
              title: Text("Feedback"),
              trailing: Icon(Icons.feedback),
              onTap: () {},
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
              onTap: logOut,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(titleString[currentState]),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.notifications),onPressed: (){},)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddBlog()));
        },
        child: Icon(Icons.add,size: 32.0,),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 60,
          color: Colors.teal ,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: (){
                    setState(() {
                      currentState = 0;
                    });
                  },
                  iconSize: 35.0,
                  color: currentState == 0 ? Colors.white : Colors.white54,
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: (){
                    setState(() {
                      currentState = 1;
                    });
                  },
                  iconSize: 35.0,
                  color: currentState == 1 ? Colors.white : Colors.white54,
                ),
              ],
            ),
          ),
        ),
      ),
      body:circular ? Center(child: CircularProgressIndicator()) : screens[currentState],
    );
  }
  void logOut ()async{
    await storage.delete(key: 'token');
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>WelcomePage()), (route) => false);
  }
}
