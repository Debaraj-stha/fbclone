import 'dart:convert';

import 'package:fbclone/model/post_model.dart';
import 'package:fbclone/page/comments.dart';
import 'package:fbclone/page/reactor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class post extends StatefulWidget {
  const post({Key? key}) : super(key: key);

  @override
  State<post> createState() => _postState();
}

TextStyle myStyle = TextStyle(fontSize: 16, color: Colors.grey[700]);

class _postState extends State<post> {
  Future<List<Posts>> fetchPost() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8000/posts"));
    if (response.statusCode == 200) {
      List datas = jsonDecode(response.body);
      List<Posts> posts = [];
      for (var themeMap in datas) {
        posts.add(Posts.fromJson(themeMap));
      }
      print(posts);
      
      return posts;
    } else {
      print("error!");
      throw new Exception("error!");
    }
  }
bool isShown = false;
dynamic user;
  @override
  void initState() {
    super.initState();
    user=getSession();
    
  }
  getSession()async{
  dynamic a=await SessionManager().get("user");
  return a;
 }
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

  List<bool>shown=[];
  List<String> reactions=[];
  List likesCount=[];
  String totalLikes(int num){
    if(num>999 && num<99999){
      return "${(num/1000).toStringAsFixed(1)} K";
    }
   else if(num >99999 && num<999999){
        return "${(num/1000).toStringAsFixed(0)} K";
    }
    else if(num>9999999 && num<999999999){
      return "${(num / 1000000).toStringAsFixed(1)} M";
    }
    else if(num>999999999){
    return "${(num / 1000000000).toStringAsFixed(1)} B";
    }
    else{
      return num.toString();
    }
  }
  bool isLiked(snapshot){
    bool like=false;
    for(var k=0;k<snapshot.likes!.length;k++){
    if(snapshot.likes![k].user.email.contains("nabaraj@gmail.com")){
      
        like=true;
    
    }
    else {
  
      like=false;
  
    }
  }
return like;
  }                                                        
  void like(String postId, int num,int index) async{
    print(postId);
    final response=await http.post(Uri.parse("http://10.0.2.2:8000/like"),body:{
           "postId":postId,
          "userId":"63145395e1c2acf0be28ce51",
          "email":await SessionManager().get("user"),
          "types":"love"
      
    });
    if(response.statusCode==200){
      if(response.body=="like"){
        print("like");
        for(var i=0;i<likesCount.length;i++){
          if(postId==likesCount[i]["id"]){
          setState(() {
            likesCount[i]["like"]++;
          });
        }
      }
      print(likesCount);
      }
      else{
        print("unlike");
         for(var i=0;i<likesCount.length;i++){
          if(postId==likesCount[i]["id"]){
          setState(() {
            likesCount[i]["like"]--;
          });
        }
      }
      print(likesCount);
      }
      print(response.body);
    }
    else{
      print("error");
    }
  }
  
  
  @override

  Widget build(BuildContext context) {
    return FutureBuilder<List<Posts>>(
        future: fetchPost(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(itemCount: snapshot.data!.length, shrinkWrap: true, physics: NeverScrollableScrollPhysics(), itemBuilder: (context,i){
              bool a=true;
            
                  likesCount.add({"like":snapshot.data![i].likes!.length,"id":snapshot.data![i].postId,"index":i});
              return Container(
                  child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          iconSize: 50,
                          onPressed: () {},
                          icon: CircleAvatar(
                            radius: 80,
                            backgroundImage:
                                NetworkImage(snapshot.data![i].user[0].profile),
                          )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data![i].user[0].name,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              spacing: 10,
                              children: [
                                Text(convertToAgo(snapshot.data![i].postAt),
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black)),
                                Icon(Icons.public)
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_horiz_outlined,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.close,
                            size: 30,
                          ))
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data![i].status,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                          Image(
                            image:
                                NetworkImage(snapshot.data![i].posts[0].post),
                          )
                        ]),
                  ),
                 Padding(
                   padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                       InkWell(
                         child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                            for(int k=0;k<snapshot.data![i].reaction.length;k++)...[
                              if(snapshot.data![i].reaction[k]=="like")...[
                                Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle
                                ),
                                child:Image.asset("assets/emoji/like.png",fit: BoxFit.cover,)
                                ),
                              ],
                               if(snapshot.data![i].reaction[k]=="love")...[
                                Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle
                                ),
                                child:Image.asset("assets/emoji/love.png",fit: BoxFit.cover,)
                                ),
                              ],
                             if(snapshot.data![i].reaction[k]=="wow")...[
                                Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle
                                ),
                                child:Image.asset("assets/emoji/wow.png",fit: BoxFit.cover,)
                                ),
                              ],
                              if(snapshot.data![i].reaction[k]=="care")...[
                                Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle
                                ),
                                child:Image.asset("assets/emoji/care.png",fit: BoxFit.cover,)
                                ),
                              ]
                              else if(snapshot.data![i].reaction[k]=="haha")...[
                                Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle
                                ),
                                child:Image.asset("assets/emoji/haha.png",fit: BoxFit.cover,)
                                ),
                              ]
                              else ...[
                                Container()
                              ]
                            ],
                                SizedBox(width: 5,),
                              
                                  if(likesCount.isNotEmpty)...[
                                    if(snapshot.data![i].likes!.length!=0)...[
                                    if(snapshot.data![i].likes!.length==1)...[
                                    Text("you"),
                                    ]
                                    else...[
                                    for(var k=0;k<snapshot.data![i].likes!.length;k++)
                                    if(snapshot.data![i].likes![k].user.email.contains("nabaraj@gmail.com"))...[
                                      Text("you ,")
                                    ],
                                Text(snapshot.data![i].likes![0].user.name),
                               likesCount[i]["like"]==1?Container():
                                Text("and "),
                                likesCount[i]["like"]==1?Container():
                                 Text(totalLikes(likesCount[i]["like"]-1) +" others"),
                                  ]
                                  ]
                                  ]
                           ],
                         ),
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>reactor(snapshot: snapshot.data![i]))
                              );
                            },
                       ),
                    Text(snapshot.data![i].comments!.length.toString()+" comments",style: TextStyle(fontSize: 13,color: Colors.grey[600],)),
                    ]
                   ),
                 ),
                 
                    
                 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(children: [
                        IconButton(
                            onPressed: () {
                              like(snapshot.data![i].postId,snapshot.data![i].likes!.length,i);
                            },
                            icon: Icon(Icons.thumb_up_alt_outlined,color:isLiked(snapshot.data![i])?Colors.blue:Colors.grey[800])),
                        Text("Like", style: TextStyle(fontSize: 16))
                      ]),
                      Row(children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>comments(snapshot:snapshot.data![i],postId:snapshot.data![i].postId)));
                          },
                          icon: Icon(Icons.message_outlined),
                        ),
                        Text("Comment", style: TextStyle(fontSize: 16))
                      ]),
                      Row(children: [
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.share_outlined)),
                        Text("Share", style: TextStyle(fontSize: 16)),
                      ]),
                
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                ],
              ));
            });
            
          }

          return Center(
            child: Text("Loading..."),
          );
          
        }));
        
  }
 
  
}
