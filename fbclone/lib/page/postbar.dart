
import 'dart:io';
 import 'package:path/path.dart';
  import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class postbar extends StatefulWidget {
  const postbar({Key? key}) : super(key: key);

  @override
  State<postbar> createState() => _postbarState();
}

class _postbarState extends State<postbar> {
  File ?file;
  Future<void> pickImage()async{
    try{
    final file=await ImagePicker().pickImage(source:ImageSource.camera);
    if(file==null){
      print("no image selected");
    }
    else{
      final tempPath=File(file.path);
      setState(() {
        this.file=tempPath;
      }); 
      print(file.path);
    }
    }
    on PlatformException catch(e){
      throw("failed to pick image $e");
    }
  }
 
   void uploader(File imageFile) async {    
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri = Uri.parse("http://10.0.2.2:8000/uploader");

     var request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile('file', stream, length,
          filename:basename(imageFile.path));
            request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: IconButton(
              onPressed: () {},
              icon: CircleAvatar(
                radius: 80,
                backgroundImage:  AssetImage('assets/profile1.jpg'),
              )),
        ),
        TextButton(
          onPressed: () {},
          child: Text("What's on your mind? Name",style: TextStyle(color: Colors.grey[700],fontSize: 17),),
        ),
        Expanded(
          child: TextButton(onPressed: (){
            uploader(file!);
          },child: Text("upload"),),
        ),
        Expanded(
       child: Container(
          child: VerticalDivider(color: Colors.black12,thickness: 2,),
        ),
        ),
        
        Expanded(
          child: Column(
            children: [
              IconButton(onPressed: (){
                pickImage();
              },icon: Icon(Icons.photo_album_outlined),),
              Text(("Photo"))
            ],
          ),
        )
      ],
    );
  }
}
