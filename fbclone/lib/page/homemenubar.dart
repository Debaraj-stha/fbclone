import 'package:flutter/material.dart';

class homemenubar extends StatefulWidget {
  const homemenubar({Key? key}) : super(key: key);

  @override
  State<homemenubar> createState() => _homemenubarState();
}

class _homemenubarState extends State<homemenubar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () {},
            child: Row(
              children: [
                Icon(Icons.post_add_outlined),
                Text("Text",style: TextStyle(fontSize: 18,color: Colors.grey[600]),)
              ],
            ))
      ],
    );
  }
}
