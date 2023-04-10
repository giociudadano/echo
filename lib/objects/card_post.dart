import 'package:firebase_auth/firebase_auth.dart';
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
  bool isVisible = true;
  bool isCardFront = true;
  bool isAuthor = false;

  @override
  void initState(){
    getPostDoneState(widget.userID, widget.postID);
    isCardAuthor(widget.postID);
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
    return !isVisible ? SizedBox.shrink() : GestureDetector(
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
            )
            :
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isAuthor ?
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(238, 94, 94, 1)
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )
                        ),
                      ),
                      onPressed: (){
                        AlertDeleteCard(widget.postID);
                      },
                      icon: Icon(Icons.cancel_presentation_outlined, color: Colors.white),
                      label: Text("Delete Card", style: TextStyle(color: Colors.white)),
                    )
                  :
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromRGBO(238, 94, 94, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )
                      ),
                    ),
                    onPressed: (){
                      AlertReportAuthor(widget.postID, widget.userID, widget.username);
                    },
                    icon: Icon(Icons.flag, color: Colors.white),
                    label: Text("Report Author", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updatePostDoneState(String userID, String postID, bool value) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$userID/postsDone");
    DatabaseReference ref2 = FirebaseDatabase.instance.ref("Posts/$postID/usersDone");
    if (value == true){
      ref.update({postID:true});
      ref2.update({userID:true});
    } else {
      ref.child(postID).remove();
      ref2.child(userID).remove();
    }
  }

  void AlertDeleteCard(String postID) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: Icon(Icons.cancel_presentation_outlined, color: Color.fromRGBO(238, 94, 94, 1), size: 32),
            backgroundColor: Color.fromRGBO(32, 35, 43, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text("Confirm Delete Card",
                style: TextStyle(
                  color: Color.fromRGBO(245, 245, 245, 1),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                )
            ),
            content: Text("This action will permanently delete your card. Are you sure you want to continue?",
                style: TextStyle(
                  color: Color.fromRGBO(245, 245, 245, 0.8),
                  fontSize: 14,
                )
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color.fromRGBO(245, 245, 245, 0.8), width: 1.5),
                      )
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("Cancel", style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromRGBO(238, 94, 94, 1)
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                  DeleteCard(postID);
                },
                child: Text("Delete", style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
              ),
            ]
          );
        }
    );
  }

  void DeleteCard(String postID) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Posts/$postID/groups");
    DataSnapshot snapshot = await ref.get();
    List groups = [];
    (snapshot.value as Map).forEach((a, b) => groups.add(a));
    for (var group in groups){
      (FirebaseDatabase.instance.ref("Groups/$group/posts/$postID")).remove();
    }

    ref = FirebaseDatabase.instance.ref("Posts/$postID/usersDone");
    snapshot = await ref.get();
    List users = [];
    if (snapshot.value != null) {
      (snapshot.value as Map).forEach((a, b) => users.add(a));
      for (var user in users) {
        (FirebaseDatabase.instance.ref("Users/$user/postsDone/$postID"))
            .remove();
      }
    }
    (FirebaseDatabase.instance.ref("Posts/$postID")).remove();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Post has been deleted!"),
    ));
    setState(() {
      isVisible = false;
    });
  }

  void isCardAuthor(String postID) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Posts/$postID/userID");
    DataSnapshot snapshot = await ref.get();
    setState(() {
      isAuthor = (FirebaseAuth.instance.currentUser?.uid.toString() == snapshot.value.toString());
    });
  }

  void AlertReportAuthor(String postID, String userID, String username) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              icon: Icon(Icons.flag, color: Color.fromRGBO(238, 94, 94, 1), size: 32),
              backgroundColor: Color.fromRGBO(32, 35, 43, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text("Report $username?",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  )
              ),
              content: Text("We value your safe space and take reports seriously. If we find this account to be malicious, we will either remove this card or suspend the account. Are you sure you want to continue?",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.8),
                    fontSize: 14,
                  )
              ),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Color.fromRGBO(245, 245, 245, 0.8), width: 1.5),
                        )
                    ),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel", style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromRGBO(238, 94, 94, 1)
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )
                    ),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                    ReportAuthor(postID, userID);
                  },
                  child: Text("Report", style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
                ),
              ]
          );
        }
    );
  }

  void ReportAuthor(String postID, String userID) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Reports/$postID");
    ref.update({userID:true});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("User has been reported!"),
    ));
  }
}


