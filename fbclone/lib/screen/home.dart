
import 'dart:convert';

import 'package:fbclone/custom/mystorycard.dart';
import 'package:fbclone/model/userModel.dart';
import 'package:fbclone/page/post.dart';
import 'package:fbclone/page/postbar.dart';
import 'package:fbclone/page/storybar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
class home extends StatefulWidget {
  const home({Key? key,}) : super(key: key);
  
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  void initState(){
    super.initState();
  getSessions();
  }
  // Future login()async{
  //   final response=await http.post(Uri.parse("http://10.0.2.2:8000/login"),body:{
  //       "email":"anish12@gmail.com",
  //       "name":"Nabaraj Shrestha",
  //       "profile":"https://i3.wp.com/donghuaguoman.com/wp-content/uploads/2022/07/Black-Gate-Hei-Men.png",
  //       "dob":"2001-02-09",
  //       "password":"Rajan"
  //   });
   
  //   if(response.statusCode==200){
  //      var decodedJson = json.decode(response.body);
  //     if(response.body.isNotEmpty){
  //       if(decodedJson['message']=="error"){
  //       print(decodedJson);
        
  //       }
  //       else if(decodedJson['message']=="exits"){
  //         print("account already exits");
  //       }
  //       else{
  //         print(decodedJson['email']);
  //         setSession(decodedJson['email'],decodedJson['name'],decodedJson['profile'],decodedJson['_id']);
  //       }
  //     }
      
    //   final parsed = json.decode(response.body).cast<String,dynamic>();
    //  return parsed.map((json) => User.fromJson(json)).toList();
  //   }
  //   else{
  //     throw Exception("error");
  //   }
  // }
  
   setSession(email,name,profile,userId)async{
    //  await SessionManager().set("user", user);
     await SessionManager().set("email",email);
     await SessionManager().set("name",name);
    await SessionManager().set("profile",profile);
  

  }
 void getSessions()async{
  final name=await SessionManager().get("name");
  print(name);
 }
  Future<String> getSession()async{
  final email=await SessionManager().get("user");
  return email;
}
  
  
  @override
  
  Widget build(BuildContext context) {
    return ListView(
      children: [
        postbar(),
        Divider(thickness: 2,),
          
        storybar(),
       Divider(thickness: 2,),
      post(),
      ],
    );
  }
}