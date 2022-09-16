import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class singleStory extends StatefulWidget {
  const singleStory({Key? key, required this.snapshot}) : super(key: key);
  final snapshot;
  @override
  State<singleStory> createState() => _singleStoryState();
}

class _singleStoryState extends State<singleStory> with SingleTickerProviderStateMixin{
    final controller = StoryController();
  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays}d';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} h';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} m';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second';
    } else {
      return 'just now';
    }
  }
   double value=0;
   List<StoryItem> storyItems=[];
  @override
  void initState(){
    super.initState();
    downloadData();
    setStory();
  }
  void setStory(){
for(var a=0;a<widget.snapshot.story.length;a++){
  if(widget.snapshot.story[a].type =="photo"){
  storyItems.add(StoryItem.pageImage(
    url: widget.snapshot.story[a].story,
    controller: controller,
    caption:"manual caption",
    imageFit:BoxFit.contain
      ));     
   }
   else if(widget.snapshot.story[a].type == "video"){
    storyItems.add(StoryItem.pageVideo(widget.snapshot.story[a].story, controller: controller));
   }
   else{
    storyItems.add(StoryItem.text(title: widget.snapshot.story[a].story, backgroundColor: Colors.indigo));
   }
}
  }
  downloadData(){
    new Timer.periodic(
        Duration(seconds: 1),
            (Timer timer){
          setState(() {
            if(value == 1) {
              timer.cancel();
            }
            else {
              value = value + .1;
            }
          });
        }
    );
 }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        
                  children: [
                      StoryView(
                      storyItems: storyItems,
                       controller: controller,
                       repeat: true,
                       inline: false,
                       onComplete: (){

                       },
                       ),
                    Positioned(
                      bottom: 0,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: CircleAvatar(
                                radius: 80,
                                backgroundImage:
                                    AssetImage("assets/emoji/love.png"),
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: CircleAvatar(
                                radius: 80,
                                backgroundImage:
                                    AssetImage("assets/emoji/like.png"),
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: CircleAvatar(
                                radius: 80,
                                backgroundImage: AssetImage("assets/emoji/wow.png"),
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: CircleAvatar(
                                radius: 80,
                                backgroundImage:
                                    AssetImage("assets/emoji/care.png"),
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: CircleAvatar(
                                radius: 80,
                                backgroundImage:
                                    AssetImage("assets/emoji/haha.png"),
                              ))
                        ],
                      ),
                    ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 80),
                        color: Colors.transparent,
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                      iconSize: 50,
                                      onPressed: () {
                                        print("a");
                                      },
                                      icon: CircleAvatar(
                                        radius: 80,
                                        backgroundImage: NetworkImage(
                                            widget.snapshot.user[0].profile),
                                      )),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.snapshot.user[0].name,style: TextStyle(color:Colors.white,fontSize:18,fontWeight: FontWeight.bold),),
                                  Text(
                                      convertToAgo(widget.snapshot.addedAt),style:TextStyle(color:Colors.white,fontSize:18),)
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.more_horiz,color:Colors.white)),
                              IconButton(onPressed: () {
                                Navigator.of(context).pop();
                              }, icon: Icon(Icons.close,color:Colors.white,size:30))
                            ],
                          )
                        ],
                                          ),
                      )
                  ],
                ),
    );
  }
}
