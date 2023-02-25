import 'package:flutter/material.dart';
import 'dart:math';

class PostCard extends StatelessWidget{
  String title;
  String content;
  final _random = new Random();

  int next(int min, int max) => min + _random.nextInt(max - min);
  List<List<Color>> colors = [
    [Color.fromRGBO(84, 104, 251, 1),Color.fromRGBO(100, 130, 255, 1)],
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
              colors: colors[next(0, 3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                      color: Colors.white,
                  )
                ),
                Text(
                  content,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.white,
                      height: 0.4,
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}