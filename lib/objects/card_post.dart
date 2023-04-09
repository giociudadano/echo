import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CardPost extends StatefulWidget {
  String postID;
  String title;
  String content;
  String userID;
  String username;
  String timeStart;

  CardPost(this.postID, this.title, this.content, this.userID, this.username, this.timeStart);

  @override
  State<CardPost> createState() => _CardPostState();
}

class _CardPostState extends State<CardPost> {

  //TODO PLACEHOLDER VARIABLES
  final _random2 = Random().nextInt(6);
  var emojis = [
    "cry.png", "cry-laugh.png", "dove.png", "face-with-peeking-eye.png", "fish.png", "shark.png"
  ];

  bool isDone = false;
  bool isCardFront = true;

  @override
  void initState(){
    getPostDoneState(widget.userID, widget.postID);
  }

  void getPostDoneState(String userID, String postID) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        "Users/$userID/postsDone");
    DataSnapshot snapshot = await ref.get();
    if (snapshot.value != null) {
      Map postsDoneMap = snapshot.value as Map;
      var postsDoneList = postsDoneMap.keys.toList();
      if (mounted) {
        setState(() {
          isDone = postsDoneList.contains(postID);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState((){
          isCardFront = !isCardFront;
        }
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromRGBO(21, 23, 28, 0)),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              color: const Color.fromRGBO(21, 23, 28, 1),
            ),
            child: isCardFront ? Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
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
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 40),
                                    child: Text(
                                      widget.content,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        color: Colors.white,
                                        height: 1.15,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_month,
                                          color: Color.fromRGBO(245, 245, 245, 0.8)),
                                      const SizedBox(width: 5),
                                      Text(
                                        widget.timeStart,
                                        style: const TextStyle(
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
                              top: 98,
                              child: Text(
                                "by ${widget.username}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: Color.fromRGBO(245, 245, 245, 0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                activeColor: const Color.fromRGBO(98, 112, 242, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                side: MaterialStateBorderSide.resolveWith(
                                      (states) => const BorderSide(width: 1.0, color: Color.fromRGBO(98, 112, 242, 1)),
                                ),
                                value: isDone,
                                onChanged: (bool? value) {
                                  updatePostDoneState(widget.userID, widget.postID, value!);
                                  setState(() {
                                    isDone = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ) : SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  void updatePostDoneState(String userID, String postID, bool value) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$userID/postsDone");
    if (value == true){
      ref.update({postID:true});
    } else {
      ref.child(postID).remove();
    }
  }
}
