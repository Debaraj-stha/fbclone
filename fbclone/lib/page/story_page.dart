import 'package:fbclone/page/storyWidget.dart';
import 'package:flutter/material.dart';
class storyPage extends StatefulWidget {
  const storyPage({Key? key,required this.snapshot,required this.story}) : super(key: key);
final snapshot;
final story;
  @override
  State<storyPage> createState() => _storyPageState();
}

class _storyPageState extends State<storyPage> {
  PageController?controller;
  final int initialPage=0;
  @override
  void initState(){
    super.initState();
     final initialPage=a();
    controller=PageController(initialPage: initialPage);
  }
  void dispose(){
    controller?.dispose();
    super.dispose();
  }
   a(){
    final initialPage=widget.snapshot.indexOf(widget.story);
    return initialPage;
  }
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      children:[
        for(var a=initialPage;a<widget.snapshot.length;a++)...[
        storyWidget(story: widget.snapshot[a], controller: controller,snapshot: widget.snapshot,),
        ]
      ],
    );
  }
}