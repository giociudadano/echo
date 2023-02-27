import 'package:flutter/material.dart';
import 'dart:math';

class PostCard extends StatelessWidget{
  String title;
  String content;
  final _random = Random().nextInt(3);

  List<List<Color>> colors = [
    [Color.fromRGBO(84, 104, 251, 1),Color.fromRGBO(110, 143, 255, 1)],
    [Color.fromRGBO(255, 67, 111, 1),Color.fromRGBO(255, 122, 125, 1)],
    [Color.fromRGBO(58, 190, 117, 1),Color.fromRGBO(129, 182, 132, 1)]
  ];

  PostCard(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(child: Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(255,255, 255, 0)),
            borderRadius: BorderRadius.all(Radius.circular(13)),
            gradient: LinearGradient(
              colors: colors[_random],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                          color: Colors.white,
                      )
                    ),
                    Positioned(
                      top: 35,
                      child: Text(
                        content,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white,
                        ),
                      ),
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
}