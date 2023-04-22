import 'package:bullet/main.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CardPost extends StatefulWidget {
  String postID, title, content, userID, username, timeStart, emojiLink;
  List groups;
  Map emojiData;

  CardPost(
      this.postID, this.title, this.content,
      this.userID, this.username, this.timeStart,
      this.groups, this.emojiData, this.emojiLink);

  @override
  State<CardPost> createState() => _CardPostState();
}

class _CardPostState extends State<CardPost> {
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
                  (widget.emojiLink == 'No Emoji Link' || widget.emojiLink == 'Unreferenced Emoji Link') ? SizedBox.shrink() :
                  Positioned(
                    top: 40,
                    right: 0,
                    child: Transform(
                      transform: Matrix4.identity()..rotateZ(15 * 3.1415927 / 180),
                      alignment: FractionalOffset.center,
                      child: Image.network(widget.emojiLink,
                        width: 120,
                        height: 120,
                        opacity: const AlwaysStoppedAnimation(.4),
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          DatabaseReference ref = FirebaseDatabase.instance.ref("Posts/${widget.postID}");
                          ref.update({"emojiLink":"Unreferenced Emoji Link"});
                          return SizedBox.shrink();
                        }
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
                                      const Icon(Icons.calendar_month_outlined,
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
                  isAuthor ? ElevatedButton.icon(
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
                        AlertEditCard(widget.title, widget.content, widget.timeStart, widget.emojiData);
                    },
                    icon: Icon(Icons.edit_note_outlined,
                        color: Colors.white),
                    label: Text("Edit Card", style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
                  ) : SizedBox.shrink(),
                  isAuthor ? SizedBox(height: 20) : SizedBox.shrink(),
                  isAuthor ? ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(238, 94, 94, 1)
                        ),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )
                        ),
                      ),
                      onPressed: () {
                        AlertDeleteCard(widget.postID);
                      },
                      icon: Icon(Icons.delete_sweep_outlined,
                          color: Colors.white),
                      label: Text("Delete Card", style: TextStyle(color: Colors
                          .white)),
                    ) : SizedBox.shrink(),
                  !isAuthor ? ElevatedButton.icon(
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
                  ) : SizedBox.shrink(),
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

  void AlertEditCard(title, content, timeStart, emojiData){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return FormEditPost(title, content, timeStart, emojiData);
      },
    );
  }

  void AlertDeleteCard(String postID) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: Icon(Icons.delete_sweep_outlined, color: Color.fromRGBO(238, 94, 94, 1), size: 32),
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
              scrollable: true,
              icon: Icon(Icons.flag_outlined, color: Color.fromRGBO(238, 94, 94, 1), size: 32),
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

  verifyCardTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }

  verifyCardDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a start date';
    }
    return null;
  }

  String getEmojiLink(Emoji? emoji) {
    if (emoji == null) {
      return 'No Emoji';
    } else {
      if (emoji.hasSkinTone){
        return 'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/'
            '${emoji.name[0].toUpperCase()}${emoji.name.substring(1).toLowerCase().replaceAll(RegExp(' '), '%20').replaceAll(RegExp('[^a-z^A-Z^0-9\^-\^%]+'),'')}/Default/3D/'
            '${emoji.name.toLowerCase().replaceAll(RegExp(' '), '_').replaceAll(RegExp('[^a-z^A-Z^0-9\^-\^_\^%]+'),'')}_3d_default.png';
      } else {
        return 'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/'
            '${emoji.name[0].toUpperCase()}${emoji.name.substring(1).toLowerCase().replaceAll(RegExp(' '), '%20').replaceAll(RegExp('[^a-z^A-Z^0-9\^-\^%]+'),'')}/3D/'
            '${emoji.name.toLowerCase().replaceAll(RegExp(' '), '_').replaceAll(RegExp('[^a-z^A-Z^0-9\^-\^_\^%]+'),'')}_3d.png';
      }
    }
  }
}

class FormEditPost extends StatefulWidget {
  var groupsToPost = [];
  String title;
  String content;
  String timeStart;
  Map emojiData;

  FormEditPost(this.title, this.content, this.timeStart, this.emojiData);

  @override
  State<StatefulWidget> createState() => _FormEditPostState();
}

class _FormEditPostState extends State<FormEditPost> {
  final GlobalKey<FormState> _formEditPostKey = GlobalKey<FormState>();
  final _inputCardTitle = TextEditingController();
  final _inputCardContent = TextEditingController();
  final _inputCardTimeStart = TextEditingController();
  final _emojiController = TextEditingController();
  final _scrollController = ScrollController();

  Emoji? emojiSelected;
  bool emojiShowing = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _inputCardTitle.text = widget.title;
      _inputCardContent.text = widget.content;
      _inputCardTimeStart.text = widget.timeStart;
      emojiSelected = Emoji.fromJson(widget.emojiData as Map<String, dynamic>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Row(children: [
          Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                            child: Container(
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                              child: Card(
                                color: const Color.fromRGBO(32, 35, 43, 1),
                                child: Container(
                                  height: 350,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 20, 30, 20),
                                    child: RawScrollbar(
                                      thumbColor:
                                      Color.fromRGBO(235, 235, 235, 0.1),
                                      thumbVisibility: true,
                                      thickness: 10,
                                      controller: _scrollController,
                                      child: ListView(
                                          controller: _scrollController,
                                          children: [
                                            Form(
                                              key: _formEditPostKey,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Icon(Icons.edit_note_outlined,
                                                      color: Color.fromRGBO(
                                                          98, 112, 242, 1),
                                                      size: 32),
                                                  const SizedBox(height: 10),
                                                  const Text("Edit Card",
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            245, 245, 245, 1),
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 16,
                                                      )),
                                                  const SizedBox(height: 20),
                                                  Text("CARD INFORMATION",
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            245, 245, 245, 0.6),
                                                        fontSize: 11,
                                                        letterSpacing: 2.5,
                                                      )),
                                                  const SizedBox(height: 5),
                                                  TextFormField(
                                                    controller: _inputCardTitle,
                                                    decoration:
                                                    const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Card Title',
                                                      labelStyle: TextStyle(
                                                          color: Color.fromRGBO(
                                                              235, 235, 235, 0.6),
                                                          fontSize: 14),
                                                      hintText: 'Enter card title',
                                                      hintStyle: TextStyle(
                                                          color: Color.fromRGBO(
                                                              235, 235, 235, 0.2),
                                                          fontSize: 14),
                                                      isDense: true,
                                                      filled: true,
                                                      fillColor: Color.fromRGBO(
                                                          22, 23, 27, 1),
                                                    ),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromRGBO(
                                                            235, 235, 235, 0.8)),
                                                    validator: (String? value) {
                                                      return verifyCardTitle(
                                                          value);
                                                    },
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextFormField(
                                                    controller: _inputCardContent,
                                                    keyboardType:
                                                    TextInputType.multiline,
                                                    minLines: 3,
                                                    maxLines: 3,
                                                    decoration:
                                                    const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Card Content',
                                                      labelStyle: TextStyle(
                                                          color: Color.fromRGBO(
                                                              235, 235, 235, 0.6),
                                                          fontSize: 14),
                                                      hintText:
                                                      'Enter additional information here.',
                                                      hintStyle: TextStyle(
                                                          color: Color.fromRGBO(
                                                              235, 235, 235, 0.2),
                                                          fontSize: 14),
                                                      isDense: true,
                                                      filled: true,
                                                      fillColor: Color.fromRGBO(
                                                          22, 23, 27, 1),
                                                    ),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromRGBO(
                                                            235, 235, 235, 0.8)),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextFormField(
                                                    controller: _inputCardTimeStart,
                                                    readOnly: true,
                                                    onTap: () {
                                                      DatePicker.showDateTimePicker(
                                                          context,
                                                          theme:
                                                          const DatePickerTheme(
                                                            cancelStyle: TextStyle(
                                                                color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    167,
                                                                    167,
                                                                    1)),
                                                            itemStyle: TextStyle(
                                                                color:
                                                                Color.fromRGBO(
                                                                    235,
                                                                    235,
                                                                    235,
                                                                    1)),
                                                            doneStyle: TextStyle(
                                                                color:
                                                                Color.fromRGBO(
                                                                    98,
                                                                    112,
                                                                    242,
                                                                    1)),
                                                            backgroundColor:
                                                            Color.fromRGBO(
                                                                32, 35, 43, 1),
                                                          ),
                                                          showTitleActions: true,
                                                          minTime: DateTime.now(),
                                                          onConfirm: (date) {
                                                            String formattedDate =
                                                            DateFormat('EEEE, MMMM d, y HH:mm').format(date);
                                                            _inputCardTimeStart.text = formattedDate;
                                                          }, locale: LocaleType.en);
                                                    },
                                                    decoration:
                                                    const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Start Time',
                                                      labelStyle: TextStyle(
                                                          color: Color.fromRGBO(235, 235, 235, 0.6),
                                                          fontSize: 14),
                                                      isDense: true,
                                                      filled: true,
                                                      fillColor: Color.fromRGBO(22, 23, 27, 1),
                                                    ),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromRGBO(235, 235, 235, 0.8)),
                                                    validator: (String? value) {
                                                      return verifyCardDate(value);
                                                    },
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text("CARD VISIBILITY",
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(245, 245, 245, 0.6),
                                                        fontSize: 11,
                                                        letterSpacing: 2.5,
                                                  )),
                                                  const SizedBox(height: 5),
                                                  Column(children: [
                                                    GroupSelector(
                                                      groupsSelected: (newGroups) {
                                                        widget.groupsToPost = newGroups;
                                                      },
                                                    ),
                                                    TextFormField(
                                                      decoration: InputDecoration(
                                                        isDense: true,
                                                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                        border: InputBorder.none,
                                                      ),
                                                      readOnly: true,
                                                      validator: (value) {
                                                        if (widget.groupsToPost.isEmpty) {
                                                          return 'Please select a group to post';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ]),
                                                  Text(
                                                    "CARD APPEARANCE",
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(245, 245, 245, 0.6),
                                                      fontSize: 11,
                                                      letterSpacing: 2.5,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: ElevatedButton(
                                                            style: ButtonStyle(
                                                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(10, 15, 10, 15)),
                                                              backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(20, 20, 20, 1)),
                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(0),
                                                                  )
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                emojiShowing = !emojiShowing;
                                                              });
                                                            },
                                                            child: Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      'Select an emoji',
                                                                      style: TextStyle(
                                                                          color: Color.fromRGBO(235, 235, 235, 0.8)),
                                                                      textAlign: TextAlign.left,
                                                                    ),
                                                                    Spacer(),
                                                                    emojiSelected == null ? Icon(Icons.mood,
                                                                      color: Color.fromRGBO(235, 235, 235, 0.8),
                                                                      size: 29,
                                                                    ) : Text(emojiSelected!.emoji,
                                                                        style: GoogleFonts.notoColorEmoji(
                                                                            textStyle: const TextStyle(
                                                                              fontSize: 20,
                                                                            )
                                                                        )
                                                                    ),
                                                                  ],
                                                                )),
                                                          )),
                                                    ],
                                                  ),
                                                  Offstage(
                                                    offstage: !emojiShowing,
                                                    child: SizedBox(
                                                        height: 250,
                                                        child: EmojiPicker(
                                                          onEmojiSelected: (Category? category, Emoji emoji) {
                                                            setState(() {
                                                              emojiSelected = emoji;
                                                            });
                                                          },
                                                          onBackspacePressed: () {
                                                            setState(() {
                                                              emojiSelected = null;
                                                            });
                                                          },
                                                          textEditingController:
                                                          _emojiController,
                                                          config: Config(
                                                            columns: 7,
                                                            // Issue: https://github.com/flutter/flutter/issues/28894
                                                            emojiSizeMax: 24,
                                                            verticalSpacing: 0,
                                                            horizontalSpacing: 0,
                                                            gridPadding:
                                                            EdgeInsets.zero,
                                                            initCategory:
                                                            Category.RECENT,
                                                            bgColor: const Color
                                                                .fromRGBO(
                                                                30, 38, 49, 1),
                                                            indicatorColor:
                                                            const Color
                                                                .fromRGBO(
                                                                93,
                                                                111,
                                                                238,
                                                                1),
                                                            iconColor: Colors.grey,
                                                            iconColorSelected:
                                                            const Color
                                                                .fromRGBO(
                                                                93,
                                                                111,
                                                                238,
                                                                1),
                                                            backspaceColor:
                                                            const Color
                                                                .fromRGBO(
                                                                93,
                                                                111,
                                                                238,
                                                                1),
                                                            skinToneDialogBgColor:
                                                            Color.fromRGBO(
                                                                30, 38, 49, 1),
                                                            skinToneIndicatorColor:
                                                            Color.fromRGBO(235,
                                                                235, 235, 0.8),
                                                            enableSkinTones: true,
                                                            showRecentsTab: true,
                                                            recentsLimit: 28,
                                                            replaceEmojiOnLimitExceed:
                                                            true,
                                                            noRecents: const Text(
                                                              'No Recents',
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Color.fromRGBO(235, 235, 235, 0.8)),
                                                              textAlign:
                                                              TextAlign.center,
                                                            ),
                                                            loadingIndicator:
                                                            const SizedBox
                                                                .shrink(),
                                                            tabIndicatorAnimDuration:
                                                            kTabScrollDuration,
                                                            categoryIcons:
                                                            const CategoryIcons(),
                                                            buttonMode:
                                                            ButtonMode.MATERIAL,
                                                            checkPlatformCompatibility:
                                                            false,
                                                            emojiTextStyle:
                                                            GoogleFonts
                                                                .notoColorEmoji(),
                                                          ),
                                                        )),
                                                  ),
                                                  Offstage(
                                                    offstage: emojiSelected == null,
                                                    child: Column(
                                                        children:[
                                                          SizedBox(height: 10),
                                                          Text("Preview Emoji in Card",
                                                            style: TextStyle(
                                                              color: Color.fromRGBO(245, 245, 245, 0.8),
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text("${emojiSelected?.name}", style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.6))),
                                                          Image.network(getEmojiLink(emojiSelected),
                                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                              return Column(
                                                                children: [
                                                                  SizedBox(height: 10),
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                                                    child: Row(
                                                                      children:[
                                                                        Icon(Icons.error, color: Color.fromRGBO(255, 94, 97, 1)),
                                                                        SizedBox(width: 10),
                                                                        Expanded(
                                                                          child: Text("Unfortunately, this emoji cannot be used for this card's appearance.",
                                                                            style: TextStyle(color: Color.fromRGBO(255, 94, 97, 1)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 10),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ]
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children:[
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
                                                      SizedBox(width: 10),
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                          MaterialStatePropertyAll<
                                                              Color>(
                                                              Color.fromRGBO(
                                                                  98, 112, 242, 1)),
                                                          shape: MaterialStateProperty
                                                              .all<RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    8.0),
                                                              )),
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text('Edit Card',
                                                            style: TextStyle(
                                                                color: Colors.white)),
                                                      ),

                                                    ],),
                                                ],
                                              ),
                                            )
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ]),
      )
    ]);
  }

  verifyCardTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }

  verifyCardDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a start date';
    }
    return null;
  }

  void _writePost(
      BuildContext context, String title, String content, String userID, String timeStart, groups, String emoji) {
    try {
      Map groupMap = {};
      groups.forEach((group) => groupMap["$group"] = true);
      DatabaseReference ref = FirebaseDatabase.instance.ref("Posts");
      var newPost = ref.push();
      newPost.update({
        'title': title,
        'content': content,
        'userID': userID,
        'timeStart': timeStart,
        'groups': groupMap,
        'emoji' : emoji,
      });
      for (var group in groups) {
        DatabaseReference ref2 =
        FirebaseDatabase.instance.ref("Groups/$group/posts");
        ref2.update({newPost.key!: true});
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Post has been submitted!"),
      ));
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "There was an error submitting your post. Please try again later."),
      ));
    }
  }

  String getEmojiLink(Emoji? emoji) {
    if (emoji == null) {
      return 'No Emoji';
    } else {
      if (emoji.hasSkinTone){
        return 'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/'
            '${emoji.name[0].toUpperCase()}${emoji.name.substring(1).toLowerCase().replaceAll(RegExp(' '), '%20').replaceAll(RegExp('[^a-z^A-Z^0-9\^-\^%]+'),'')}/Default/3D/'
            '${emoji.name.toLowerCase().replaceAll(RegExp(' '), '_').replaceAll(RegExp('[^a-z^A-Z^0-9\^-\^_\^%]+'),'')}_3d_default.png';
      } else {
        return 'https://raw.githubusercontent.com/microsoft/fluentui-emoji/main/assets/'
            '${emoji.name[0].toUpperCase()}${emoji.name.substring(1).toLowerCase().replaceAll(RegExp(' '), '%20').replaceAll(RegExp('[^a-z^A-Z^0-9\^-\^%]+'),'')}/3D/'
            '${emoji.name.toLowerCase().replaceAll(RegExp(' '), '_').replaceAll(RegExp('[^a-z^A-Z^0-9\^-\^_\^%]+'),'')}_3d.png';
      }
    }
  }
}

