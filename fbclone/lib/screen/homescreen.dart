import 'dart:convert';

import 'package:fbclone/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  late Future<List<Posts>> futurepost;
  Future<List<Posts>> fetchPost() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8000/posts"));
    if (response.statusCode == 200) {
      List datas = jsonDecode(response.body);
      List<Posts> posts = [];
      for (var themeMap in datas) {
        posts.add(Posts.fromJson(themeMap));
      }
      return posts;
    } else {
      print("error!");
      throw new Exception("error!");
    }
  }

  @override
  void initState() {
    super.initState();
    futurepost:
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
    
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List<Posts>>(
          future: fetchPost(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage("https://www.theskinnybeep.com/wp-content/uploads/2019/01/Versace-Man-2019.jpg"),
                                  ),
                                   Padding(
                                     padding: const EdgeInsets.only(left: 7),
                                     child: Text("Radhika Mandhana",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
                                   ),
                                ],
                              ),
                              InkWell(
                                child: Icon(Icons.more_vert),
                                onTap: (){
                  
                                },
                              )
                            ],
                          ),
                          Divider(thickness: 1,color: Colors.grey,),
                          snapshot.data![index].status != null
                              ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(snapshot.data![index].status,style: TextStyle(fontSize: 18,),),
                              )
                              : Container(),
                          ListView.builder(
                              itemCount: snapshot.data![index].posts.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, postPosition) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 400,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.network(snapshot
                                          .data![index].posts[postPosition].post),
                                    ),
                                    Image.network("https://www.theskinnybeep.com/wp-content/uploads/2019/01/Versace-Man-2019.jpg"),
                                  ],
                                );
                              }),
                          Divider(thickness: 2),
                        ],
                      );
                    }),
              );
            } else
              return CircularProgressIndicator();
          }),
        ),
         
      ),
    );
  }
}
