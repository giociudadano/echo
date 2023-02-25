import 'package:flutter/material.dart';

class PostCard extends StatelessWidget{
  String title;
  String content;
  PostCard(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          title: Text(title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24)),
          subtitle: Text(content,
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14)),
        )
    );
  }
}