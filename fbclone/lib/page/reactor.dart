import 'dart:ui';
import 'package:fbclone/custom/likeUserCard.dart';
import 'package:fbclone/page/like_all_likepage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class reactor extends StatefulWidget {
  const reactor({Key? key, required this.snapshot}) : super(key: key);
  final snapshot;
  @override
  State<reactor> createState() => _reactorState();
}

class _reactorState extends State<reactor> with SingleTickerProviderStateMixin {
  TabController? _controller;

  String totalLikes(num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return "All " + num.toString();
    }
  }

  List reactions = [];
  List<Widget> tabs=[];
  int likes=0;
  int loves=0;
  int wows=0;
  int cares=0;
  int angrys=0;
  int sads=0;
  int hahas=0;

  @override
  void initState()  {
    super.initState();
    checkReaction();
      makeTabbar();
    _controller = TabController(length:reactions.length+1 , vsync: this, initialIndex: 0);
  
  }
void countReactions(){
  for (int i = 0; i < widget.snapshot.likes.length; i++) {
      if(widget.snapshot.likes[i].types=="like"){
        setState(() {
          likes++;
        });
      }
      else if(widget.snapshot.likes[i].types=="love"){
        setState(() {
          loves++;
        });
      }
      else if(widget.snapshot.likes[i].types=="care"){
        setState(() {
          cares++;
        });
      }
      else if(widget.snapshot.likes[i].types=="haha"){
        setState(() {
          hahas++;
        });
      }
      else if(widget.snapshot.likes[i].types=="wow"){
        setState(() {
          wows++;
        });
      }
      else if(widget.snapshot.likes[i].types=="angry"){
        setState(() {
          angrys++;
        });
      }
      else if(widget.snapshot.likes[i].types=="sad"){
        setState(() {
          sads++;
        });
      }
}
print(likes);
}

  void checkReaction() {
    for (int i = 0; i < widget.snapshot.likes.length; i++) {
      if(reactions.contains(widget.snapshot.likes[i].types)){
        
      }
      else{
      
      setState(() {
        reactions.add(widget.snapshot.likes[i].types);
      });
      }
    }
    print(reactions);
  }

  void makeTabbar(){
    for(int i=0;i<reactions.length;i++){
      if(reactions[i]=="like"){
        setState(() {
          tabs.add(Tab(
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
        child:  Image.asset("assets/emoji/like.png",fit: BoxFit.cover,),
      ),
      
       ),);
        });
      }
      else if(reactions[i]=="love"){
        setState(() {
          tabs.add(Tab(
            
                child: Container(
                  height: 30,
                  width: 30,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                  child: Image.asset("assets/emoji/love.png",fit: BoxFit.cover),
                ),
              ),);
        });
      }
       else if(reactions[i]=="care"){
        setState(() {
          tabs.add(Tab(
                child: Container(
                  height: 30,
                  width: 30,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                  child: Image.asset("assets/emoji/care.png",fit: BoxFit.cover),
                ),
              ),);
        });
      }
       else if(reactions[i]=="wow"){
        setState(() {
          tabs.add(Tab(
                child: Container(
                  height: 30,
                  width: 30,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                  child: Image.asset("assets/emoji/wow.png",fit: BoxFit.cover),
                ),
              ),);
        });
      }
       else if(reactions[i]=="haha"){
        setState(() {
          tabs.add(Tab(
                child: Container(
                  height: 30,
                  width: 30,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                  child: Image.asset("assets/emoji/haha.png",fit: BoxFit.cover),
                ),
              ),);
        });
      }
      else if(reactions[i]=="angry"){
        setState(() {
          tabs.add(Tab(
                child: Container(
                  height: 30,
                  width: 30,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                  child: Image.asset("assets/emoji/angry.png",fit: BoxFit.cover),
                ),
              ),);
        });
      }
      else if(reactions[i]=="sad"){
        setState(() {
          tabs.add(Tab(
                child: Container(
                  height: 30,
                  width: 30,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                  child: Image.asset("assets/emoji/sad.png",fit: BoxFit.cover),
                ),
              ),);
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  )),
              Text(
                "People who react",
                style: TextStyle(color: Colors.black),
              )
            ]),
            Divider(
              thickness: 1,
              color: Colors.black,
            )
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300]),
          ),
        ],
        bottom: TabBar(
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal: 20),
            controller: _controller,
            tabs: [
              Tab(
                text: totalLikes(widget.snapshot.likes.length),
              ),
              ...tabs,
            ]),
      ),
      body: TabBarView(controller: _controller, children: [
        // allLikePage(users: widget.snapshot!.likes),
        ListView.builder(itemCount: widget.snapshot.likes.length, itemBuilder: (context,i){
      return likeUserCard(user: widget.snapshot!.likes[i]);
    }),
      for(int i=0;i<reactions.length;i++)...[
        if(reactions[i] =="like")...[
        
         reactionlist(widget.snapshot,"like")
        ]
        else if(reactions[i] =="love")...[
          reactionlist(widget.snapshot,"love")
        ]
        else if(reactions[i] =="care")...[
          reactionlist(widget.snapshot, "care")
        ]
       else if(reactions[i] =="wow")...[
         reactionlist(widget.snapshot,"wow")
        ]
        else if(reactions[i] =="haha")...[
           reactionlist(widget.snapshot,"haha")
        ]
       else if(reactions[i] =="sad")...[
           reactionlist(widget.snapshot,"sad")
        ]
        else if(reactions[i] =="angry")...[
           reactionlist(widget.snapshot,"angry")
        ]
      ]
      ]),
    );
  }
  Widget reactionlist(snapshot,String types){
return  ListView.builder(itemCount: widget.snapshot.likes.length, itemBuilder: (context,i){
          if(widget.snapshot!.likes[i].types==types) {
            return likeUserCard(user: widget.snapshot!.likes[i]);
          }
          return Container();
          });
  }
}
