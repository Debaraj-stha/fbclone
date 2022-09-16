import 'package:flutter/material.dart';
class myStoryCard extends StatefulWidget {
  const myStoryCard({Key? key}) : super(key: key);

  @override
  State<myStoryCard> createState() => _myStoryCardState();
}

class _myStoryCardState extends State<myStoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(spacing: 10, children: [
          Container(
            height: 255,
            width: 150,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Column(children: [
                    Container(
                      height: 170,
                      width: 150,
                      margin: EdgeInsets.only(bottom: 30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        child: Image(
                          image: AssetImage('assets/profile1.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Add Story",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ))
                  ]),
                ),
                Positioned(
                    bottom: 46,
                    left: 50,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_circle_outline_rounded,
                        size: 35,
                        color: Colors.blueAccent,
                      ),
                    ))
              ],
            ),
          ),
        ]
        )
      ),
    );
  }
}