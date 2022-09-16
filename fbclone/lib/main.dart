import 'package:fbclone/page/myDrawer.dart';
import 'package:fbclone/screen/home.dart';
import 'package:fbclone/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "facebook clone",
      home: homePage(),
      theme: ThemeData(primaryColor: Colors.white),
      debugShowCheckedModeBanner: false,
    );
  }
}

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  static const List<Widget> _tabs = [
    Tab(
      icon: Icon(Icons.home),
    ),
    Tab(
      icon: Icon(Icons.tv),
    ),
    Tab(
      icon: Icon(Icons.person_rounded),
    ),
    Tab(
      icon: Icon(Icons.feed),
    ),
    Tab(
      icon: Icon(Icons.notifications),
    ),
    Tab(
      icon: Icon(Icons.list),
    )
  ];
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 6, vsync: this, initialIndex: 0);
  }
Future<bool> _onWillPop()async{
  if(_controller.index == 0){
    await SystemNavigator.pop();
  }
  Future.delayed(Duration(microseconds: 200),(){
_controller.index=0;
  });
  return _controller.index==0;
}
Future<String> getSession()async{
  final email=await SessionManager().get("user");
  return email;
}
final _scaffoldKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Facebook",
              style: TextStyle(color: Colors.blue[700]),
            ),
            actions: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child:IconButton(
                  onPressed: (){
    
                  },
                  icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              ),
              decoration: BoxDecoration(
                shape:BoxShape.circle ,
                color: Colors.grey[300]),
              ),
               Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child:IconButton(
                  onPressed: (){
                      _scaffoldKey.currentState!.openEndDrawer();
                  },
                  icon: Icon(
                Icons.messenger,
                color: Colors.black,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              ),
              decoration: BoxDecoration(
                shape:BoxShape.circle ,
                color: Colors.grey[300]),
              ),
            ],
            bottom: TabBar(
                controller: _controller,
                indicatorColor: Colors.blue[500],
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey[700],
                tabs: _tabs),
          ),
          endDrawer: Container(
              child: myDrawer(),
          ),
          body: TabBarView(
            controller: _controller,
            children: [
              home(),
              Text("video"),
              Text("user"),
              Text("feeds"),
              Text("notifications"),
              Text("list")
            ],
          )),
    );
  }
}
