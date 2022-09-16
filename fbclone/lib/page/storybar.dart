import 'dart:convert';

import 'package:fbclone/custom/mystorycard.dart';
import 'package:fbclone/model/storymodel.dart';
import 'package:fbclone/page/singleStory.dart';
import 'package:fbclone/page/story_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
class storybar extends StatefulWidget {
  const storybar({Key? key}) : super(key: key);

  @override
  State<storybar> createState() => _storybarState();
}

class _storybarState extends State<storybar> {

  Future<List<Stories>>  getStories() async{

    final response=await http.get(Uri.parse("http://10.0.2.2:8000/story"));
    if(response.statusCode == 200){
      List story=jsonDecode(response.body);
      List<Stories> storys=[];
      for(var s in story){
        storys.add(Stories.fromJson(s));
      }
      return storys;
    }
    else{
      
      throw  new Exception("server error");
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return  ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 255),
      child: ListView(
      shrinkWrap: true,
      physics:  ScrollPhysics(), 
       scrollDirection: Axis.horizontal,
        children:[
           myStoryCard(),
           FutureBuilder<List<Stories>>(
          future: getStories(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 255),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                   physics:  ScrollPhysics(), 
                   scrollDirection: Axis.horizontal,
                   shrinkWrap: true,
                    itemBuilder: (context,i){
                  return Container(
                    height: 255,
                    width: 150,
                    margin: EdgeInsets.all(10),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>storyPage(snapshot:snapshot.data,story:snapshot.data![i])));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              image: NetworkImage(snapshot.data![i].story[0].story),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(snapshot.data![i].user[0].profile),
                                    fit: BoxFit.fill),
                              ),
                            )),
                        Positioned(
                            bottom: 10,
                            left: 10,
                            child: Text(
                              snapshot.data![i].user[0].name,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  );
                }),
              );
            }
             else{
              return CircularProgressIndicator();
             } 
            }),
         
        ]
      ),
    );
  }
}
