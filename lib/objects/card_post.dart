import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CardPost extends StatefulWidget {
  String title;
  String content;
  String userID;
  String timeStart;

  CardPost(this.title, this.content, this.userID, this.timeStart);

  @override
  State<CardPost> createState() => _CardPostState();
}

class _CardPostState extends State<CardPost> {
  final _random = Random().nextInt(3);

  List<List<Color>> colors = [
    [Color.fromRGBO(84, 104, 251, 1), Color.fromRGBO(110, 143, 255, 1)],
    [Color.fromRGBO(255, 67, 111, 1), Color.fromRGBO(255, 122, 125, 1)],
    [Color.fromRGBO(58, 190, 117, 1), Color.fromRGBO(129, 182, 132, 1)]
  ];

  final _random2 = Random().nextInt(6),

  emojis = [
    "cry.png", "cry-laugh.png", "dove.png", "face-with-peeking-eye.png", "fish.png", "shark.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(255, 255, 255, 0)),
            borderRadius: BorderRadius.all(Radius.circular(13)),
            gradient: LinearGradient(
              colors: colors[_random],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: Stack(
              children: [
                Positioned(
                  top: 40,
                  right: 0,
                  child: Transform(
                    transform: Matrix4.identity()..rotateZ(15 * 3.1415927 / 180),
                    alignment: FractionalOffset.center,
                    child: Image.asset(
                      'lib/assets/images/emoji/${emojis[_random2]}',
                      width: 120,
                      height: 120,
                      opacity: const AlwaysStoppedAnimation(.4),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                    Text(
                                      widget.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 28,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 40),
                                  child: Text(
                                    widget.content,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                      color: Colors.white,
                                      height: 1.15,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month,
                                        color: Color.fromRGBO(245, 245, 245, 0.8)),
                                    SizedBox(width: 5),
                                    Text(
                                      widget.timeStart,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color.fromRGBO(245, 245, 245, 0.8),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 108,
                            child: FutureBuilder(
                              future: _getUsername(),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> text) {
                                return Text(
                                  "by ${text.data ?? 'Unknown User'}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: Color.fromRGBO(245, 245, 245, 0.8),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: IconButton(
                              color: Colors.white,
                              onPressed: (){},
                              iconSize: 20,
                              icon: Icon(Icons.more_horiz)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getUsername() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/${widget.userID}/username");
    DataSnapshot snapshot = await ref.get();
    return snapshot.value.toString();
  }
}
