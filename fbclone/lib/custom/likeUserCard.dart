import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class likeUserCard extends StatefulWidget {
  const likeUserCard({Key? key,required this.user}) : super(key: key);
final user;
  @override
  State<likeUserCard> createState() => _likeUserCardState();
}

String myImages(String types){
  if(types=="love"){
    return "assets/emoji/love.png";
  }
  else if(types=="sad"){
    return "assets/emoji/sad.png";
  }
  else if(types=="wow"){
    return "assets/emoji/wow.png";
  }
   else if(types=="haha"){
    return "assets/emoji/haha.png";
  }
  else if(types=="angry"){
    return "assets/emoji/angry.png";
  }
  else if(types=="care"){
    return "assets/emoji/care.png";
  }
  else{
    return "assets/emoji/like.png";
  }
}

class _likeUserCardState extends State<likeUserCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Row(
            children: [
                Stack(
                  children:[
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.user.user!.profile),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 2,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue
                        ),
                        child: Image.asset(myImages(widget.user.types),fit: BoxFit.cover,),),
                      ),
                    
                  ]
                ),
                SizedBox(width: 6,),
                Text(widget.user.user!.name,style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),),
            ],
          ),
        ),
      ),
      onTap: (){

      },
    );
  }
}