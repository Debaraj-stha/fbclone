import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';
class comments extends StatefulWidget {
  const comments({Key? key, required this.snapshot,required this.postId}) : super(key: key);
  final snapshot;
  final postId;
  @override
  State<comments> createState() => _commentsState();
}

TextStyle myStyle = TextStyle(fontSize: 16, color: Colors.grey[700]);
class _commentsState extends State<comments> {

  void initState(){
    super.initState();
    
  }
 

  @override
 
  TextEditingController _textEditingController=TextEditingController();
  bool isHaveValue=false;
  List submittedComment=[];
  List commentLike=[];
  List submittedReply=[];
  List snapchatReply=[];
  late final focusNode = FocusNode();
  bool isReply=false;
  String commentId="";
  String userName="";
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
String totalLikes(num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K  Likes";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K Likes";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M Likes";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B Likes";
    } else {
      return  "${num.toString()} Likes";
    }
  }
 
void submitComment(String postId) async{
var response=await http.post(Uri.parse("http://10.0.2.2:8000/comment"),body:{
"commentText":_textEditingController.text,
"email":await SessionManager().get('email'),
"postId":postId,
});
// var decodedData=json.decode(response.body);

if(response.statusCode == 200) {
  print(response.body);
  submittedComment.add({
    "commentText":_textEditingController.text,
    "profile":await SessionManager().get('profile'),
    "name":await SessionManager().get('name'),
    "email":await SessionManager().get('email'),
    "commentAt":DateTime.now(),
    "isImage":false
    });
    
}
else{
  print("api error");
}
_textEditingController.clear();
}

void likeComment(String commentId,String postId ) async{
  final response=await http.post(Uri.parse("http://10.0.2.2:8000/commentlike"),body:{
    "email":await SessionManager().get('email'),
    "postId":postId,
    "commentId":commentId
  });
  print(response.body);
  if(response.statusCode == 200){
    print(response.body);
    if(response.body=="like"){
      for(var i=0;i<commentLike.length;i++){
          if(commentId==commentLike[i]["commentId"]){
              setState(() {
                commentLike[i]["like"]++;
              });
          }
      }
    }
    else{
      for(var i=0;i<commentLike.length;i++){
          if(commentId==commentLike[i]["commentId"]){
          setState(() {
            commentLike[i]["like"]--;
          });
    }
  }
  }
  }
  else{
    print("server error");
  }
}
 
 void replyComment(String postId) async{
 
  final response=await http.post(Uri.parse("http://10.0.2.2:8000/commentReply"),body:{
    "email":await SessionManager().get("email"),
    "replyText":_textEditingController.text,
    "commentId":commentId,
    "postId":postId,
  });
  if(response.statusCode==200){
    print(response.body);
    submittedReply.add({
    "profile":await SessionManager().get('profile'),
    "name":await SessionManager().get('name'),
    "email":await SessionManager().get('email'),
    "replyAt":DateTime.now(),
    "replyText":_textEditingController.text,
    "commentId":commentId
    });
  
  }
  else{
    print("server error");
  }
  
  print(submittedReply);
 }
 void toggleReply(String commentId) {
    for (int a = 0; a < snapchatReply.length; a++) {
      if (commentId == snapchatReply[a]['commentId']) {
        if (snapchatReply[a]['isShown'] == false) {
          setState(() {
            snapchatReply[a] = {
              'commentId': "9999",
              'isShown': true
            };
          });
        } else {
          print("else");
          setState(() {
            snapchatReply[a] = {
              'commentId':"88888",
              'isShown': false
            };
          });
        }
         print(snapchatReply[a]["isShown"]==true);
      }
    
    }
    print(snapchatReply);
  }

  @override
  Widget build(BuildContext context) {
    snapchatReply=[];
    return Scaffold(
      body: Stack(
        children:[
           SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              if(submittedComment.isNotEmpty)...[
                ListView.builder(
                  itemCount: submittedComment.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                   scrollDirection: Axis.vertical,
                    itemBuilder: (context,index){
               return SingleChildScrollView(
                 child: Container(
                      width: MediaQuery.of(context).size.width-150,
                      child: Card(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                  iconSize: 50,
                                  onPressed: () {},
                                  icon: CircleAvatar(
                                    radius: 80,
                                    backgroundImage: NetworkImage(
                                        submittedComment[index]['profile']),
                                  )),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width - 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.grey[300]),
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                             submittedComment[index]['name'],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(submittedComment[index]['commentText'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700])),
                                          ])),
                                    Row(
                                      children: [
                                        Text(convertToAgo(
                                           submittedComment[index]['commentAt'])),
                                        
                                        TextButton(
                                            onPressed: () {},
                                            child: Text("Like", style: myStyle)),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text("Reply", style: myStyle),
                                        ),
                                        
                                      ],
                                    ),
                                ],
                              ),
                            ]),
                      ),
                    ),
               );
                })
              ],
              
              ListView.builder(
                itemCount: widget.snapshot.comments.length,
                padding: EdgeInsets.only(bottom: 20),
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, j) {
                
                  // commentLike.add({"index":j,
                  // "like":widget.snapshot.comments[j].commentlikes.length,
                  // "commentId":widget.snapshot.comments[j].id});
                  
                  snapchatReply.add({
                    "commentId":widget.snapshot.comments[j].id,
                    "isShown":false
                    });
                
                  return SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width-150,
                      child: Card(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                  iconSize: 50,
                                  onPressed: () {},
                                  icon: CircleAvatar(
                                    radius: 80,
                                    backgroundImage: NetworkImage(
                                        widget.snapshot.comments![j].user.profile),
                                  )),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width - 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.grey[300]),
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.snapshot.comments![j].user.name,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(widget.snapshot.comments![j].commentText),
                                            
                                            // Text(widget.snapshot.comments![j].commentText,
                                            //     style: TextStyle(
                                            //         fontSize: 16,
                                            //         color: Colors.grey[700])),
                                          ])),
                                    Row(
                                      children: [
                                        Text(convertToAgo(
                                            widget.snapshot.comments![j].commentAt)),
                              
                                        TextButton(
                                            onPressed: () {
                                              likeComment(
                                                widget.snapshot.comments![j].id,
                                                widget.postId,
                                                );
                                            },
                                            child: Text("Like", style: myStyle)),
                                        TextButton(
                                          onPressed: () {
                                              print("isReply");
                                            setState(() {
                                              isReply=true;
                                              commentId=widget.snapshot.comments![j].id;
                                              userName=widget.snapshot.comments![j].user.name;
                                            });
                                           
                                          },
                                          child: Text("Reply", style: myStyle),
                                        ),
                                        TextButton(onPressed: (){
                                            toggleReply(widget.snapshot.comments![j].id);
                                        
                                        },
                                        child: Text("view reply"),
                                        ),
                                        if(widget.snapshot.comments![j].commentlikes!.length!=0)...[
                                          if(commentLike[j]['like']!=0)...[
                                          Text(totalLikes(commentLike[j]['like']))
                                          ]
                                        ],
                                        //  Text(totalLikes(widget.snapshot.comments![j].commentlikes!.length),
                                        //         style: myStyle),
                                      ],
                                    ),
                                    if(submittedReply.isNotEmpty)...[
                                      for(var k=0;k<submittedReply.length;k++)...[
                                        if(submittedReply[k]['commentId']==widget.snapshot.comments![j].id)...[
                                          Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          IconButton(
                                              iconSize: 50,
                                              onPressed: () {},
                                              icon: CircleAvatar(
                                                radius: 80,
                                                backgroundImage: NetworkImage(submittedReply[k]['profile']),
                                              )),
                                          Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    width: MediaQuery.of(context).size.width -200,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(10),
                                                        color: Colors.grey[300]),
                                                    padding: EdgeInsets.all(8),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            submittedReply[k]['name'],
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors.black,
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                          ),
                                                          Text(submittedReply[k]['replyText'],
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                      Colors.grey[700])),
                                                        ])),
                                                         Row(
                                                            children: [
                                                              Text(convertToAgo(submittedReply[k]['replyAt'])),
                                                                  TextButton(onPressed: () {}, child: Text("Like", style: myStyle)),
                                                                  TextButton( onPressed: () {},child: Text("Reply", style: myStyle),),         
                                                       ],
                                          )])
                                                  ]) 
                                        ]
                                      ]
                                    ],
                                    
                                     for (int k = 0;k < widget.snapshot.comments![j].reply!.length;k++) ...[
                                      for(int l=0;l<snapchatReply.length;l++) ...[
                                         if(snapchatReply[l]["commentId"]==widget.snapshot.comments![j].id) ...[
                                    if(snapchatReply[l]["isShown"])...[
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          IconButton(
                                              iconSize: 50,
                                              onPressed: () {},
                                              icon: CircleAvatar(
                                                radius: 80,
                                                backgroundImage: NetworkImage(widget.snapshot.comments![j].reply![k].user.profile),
                                              )),
                                          Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    width: MediaQuery.of(context).size.width -200,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(10),
                                                        color: Colors.grey[300]),
                                                    padding: EdgeInsets.all(8),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            widget.snapshot.comments![j]
                                                                .reply![k].user.name,
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors.black,
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                          ),
                                                           RichText(
                                                                  text: TextSpan(
                                                                      style: TextStyle( fontSize:18,color:Colors.grey[700],fontWeight: FontWeight.bold),
                                                                      children: <TextSpan>[
                                                                        TextSpan(text:widget.snapshot.comments![j].user.name + " ", style: TextStyle(color: Colors.black)),
                                                                        
                                                                        TextSpan(text:widget.snapshot.comments![j].reply[k].replyText,style: TextStyle(fontWeight: FontWeight.normal) ),
                                                                      ],
                                                                  ),
                                                                ),
                                                        ])),
                                                         Row(
                                                         children: [
                                                                  Text(convertToAgo( widget.snapshot.comments![j].commentAt)),
                                                                    TextButton(onPressed: () {},child: Text("Like", style: myStyle)),
                                                                    TextButton(onPressed: () {},child: Text("Reply", style: myStyle),),
                                                                    ],
                                                              ),
                                                               ])
                                                  ])
                                    ]
                                      
                                      ]
                                      
                                      
                                      ]
                                    ],
                                ],
                              ),
                            ]),
                      ),
                    ),
                  );
                
                }),            
            ]
          ),
        ),
        
          
                Container(
                  padding: EdgeInsets.only(top: 30),
                  margin: EdgeInsets.only(top:30),
                
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    elevation: 1,
                    color: Colors.grey[300],
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: TextFormField(
                      controller: _textEditingController,
                      focusNode: focusNode,
                      onChanged: (value){
                        if(value.length>0){
                          setState(() {
                            isHaveValue=true;
                          });
                        }
                        else{
                         setState(() {
                            isHaveValue=false;
                          }); 
                        }
                      },               
                      decoration: InputDecoration(
                        filled: true,
                         border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 6,right: 5),
                        hintText: "Write a comment...",
                        hintStyle:TextStyle(color:Colors.grey[500]),
                       
                        suffix: IconButton(onPressed: (){
                          if(isReply){
                            if(_textEditingController.text.length>0){
                              replyComment(widget.postId);
                            }
                            else{
                              print("disable");
                            }
                          }
                          else{
                            if(_textEditingController.text.length>0){
                              submitComment(widget.postId);
                            }
                            else{
                               print("disable");

                            }
                          }
                        },icon:Icon( Icons.send,color:isHaveValue?Colors.blue:Colors.grey))
                      ),
                      style: TextStyle(fontSize:18),
                    ),
                  ),
                ),
                ),
        ]
      ),
    );
  }
}
