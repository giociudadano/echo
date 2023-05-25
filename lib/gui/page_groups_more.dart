part of main;

class GroupsMorePage extends StatefulWidget {
  String groupID, groupName, groupDesc;
  GroupsMorePage(this.groupID, this.groupName, this.groupDesc);

  @override
  State<GroupsMorePage> createState() => _GroupsMorePageState();
}

class _GroupsMorePageState extends State<GroupsMorePage> {
  bool isFormVisible = false;
  bool isAdmin = false;

  final inputSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    initAdminPerms(widget.groupID);
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('Groups/${widget.groupID}');
    ref.onValue.listen((event) async {
      setState(() {
        widget.groupName = event.snapshot.child('name').value.toString();
        widget.groupDesc = event.snapshot.child('description').value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor:
                Color.fromRGBO(32, 35, 43, 1), // Navigation bar
            statusBarColor: Colors.black,
          )),
      backgroundColor: const Color.fromRGBO(32, 35, 43, 1),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          color: Color.fromRGBO(98, 112, 242, 1),
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            height: 60,
                            child: Stack(
                              children: [
                                Text(
                                  "${widget.groupName}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                Positioned(
                                  top: 24,
                                  child: Text(
                                    "${widget.groupDesc}",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(235, 235, 235, 0.8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          icon: Icon(Icons.more_vert, color: Colors.white),
                          color: Color.fromRGBO(30, 30, 32, 1),
                          itemBuilder: (BuildContext context) {
                            return isAdmin
                                ? [
                                    PopupMenuItem(
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(seconds: 0),
                                            () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          GroupsMoreMembersPage(
                                                              widget.groupID)),
                                                ));
                                      },
                                      child: Text(
                                        "View Members",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(235, 235, 235, 1),
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(seconds: 0),
                                            () => AlertInviteMembers(
                                                widget.groupID));
                                      },
                                      child: Text(
                                        "Invite Members",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(235, 235, 235, 1),
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(seconds: 0),
                                            () => AlertEditGroup(
                                                widget.groupID,
                                                widget.groupName,
                                                widget.groupDesc));
                                      },
                                      child: Text(
                                        "Edit Class",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(235, 235, 235, 1),
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(seconds: 0),
                                            () => AlertDeleteGroup(
                                                widget.groupID));
                                      },
                                      child: Text(
                                        "Delete Class",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 167, 167, 1),
                                        ),
                                      ),
                                    ),
                                  ]
                                : [
                                    PopupMenuItem(
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(seconds: 0),
                                            () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          GroupsMoreMembersPage(
                                                              widget.groupID)),
                                                ));
                                      },
                                      child: Text(
                                        "View Members",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(235, 235, 235, 1),
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        Future.delayed(
                                            const Duration(seconds: 0),
                                            () => AlertLeaveGroup(
                                                widget.groupID));
                                      },
                                      child: Text(
                                        "Leave Class",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 167, 167, 1),
                                        ),
                                      ),
                                    ),
                                  ];
                          },
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: inputSearch,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(22, 12, 60, 12),
                        hintText: '🔍  Search cards',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(235, 235, 235, 0.8),
                            fontSize: 14),
                        filled: true,
                        fillColor: const Color.fromRGBO(22, 23, 27, 1),
                        isDense: true,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(235, 235, 235, 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            WidgetGroupsMorePostsBuilder(widget.groupID, inputSearch),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return FormAddPost(widget.groupID);
              });
        },
        backgroundColor: const Color.fromRGBO(98, 112, 242, 1),
        child: const Icon(Icons.note_add_outlined),
      ),
    );
  }

  void AlertInviteMembers(String groupID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: Color.fromRGBO(30, 30, 32, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Center(
            child: Text("Invite Members",
                style: TextStyle(
                  color: Color.fromRGBO(245, 245, 245, 1),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                )),
          ),
          content: Column(
            children: [
              Container(
                width: 250.0,
                height: 250.0,
                child: QrImage(
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  backgroundColor: Colors.white,
                  data: "${groupID}",
                  version: QrVersions.auto,
                  size: 250.0,
                ),
              ),
              SizedBox(height: 20),
              Text(
                  "To add this class, please use the 'Scan QR Code' function found in the 'Classes' section. Please do not share this QR Code with unauthorized users.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color.fromRGBO(245, 245, 245, 0.6),
                    fontSize: 12,
                    height: 0.95,
                  )),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromRGBO(98, 112, 242, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Done',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void AlertEditGroup(String groupID, String groupName, String groupDesc) {
    final inputGroupName = TextEditingController(text: groupName);
    final inputGroupDesc = TextEditingController(text: groupDesc);

    verifyGroupName(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a class name';
      }
      return null;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: Color.fromRGBO(30, 30, 32, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Center(
            child: Text("Edit Class",
                style: TextStyle(
                  color: Color.fromRGBO(245, 245, 245, 1),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                )),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NAME",
                style: TextStyle(
                  color: Color.fromRGBO(245, 245, 245, 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: inputGroupName,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  filled: true,
                  fillColor: Color.fromRGBO(22, 23, 27, 1),
                ),
                style: const TextStyle(
                    fontSize: 14, color: Color.fromRGBO(235, 235, 235, 0.8)),
                validator: (String? value) {
                  return verifyGroupName(value);
                },
              ),
              const SizedBox(height: 10),
              Text(
                "DESCRIPTION",
                style: TextStyle(
                  color: Color.fromRGBO(245, 245, 245, 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: inputGroupDesc,
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter class description',
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(235, 235, 235, 0.2), fontSize: 14),
                  isDense: true,
                  filled: true,
                  fillColor: Color.fromRGBO(22, 23, 27, 1),
                ),
                style: const TextStyle(
                    fontSize: 14, color: Color.fromRGBO(235, 235, 235, 0.8)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.transparent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                            color: Color.fromRGBO(245, 245, 245, 0.8),
                            width: 1.5),
                      )),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel",
                        style: TextStyle(
                            color: Color.fromRGBO(245, 245, 245, 0.8))),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromRGBO(98, 112, 242, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      EditGroup(
                          groupID, inputGroupName.text, inputGroupDesc.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void EditGroup(String groupID, String groupName, String groupDesc) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Groups/$groupID");
    ref.update({'name': groupName, 'description': groupDesc});
  }

  void initAdminPerms(String groupID) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Groups/$groupID/admin");
    DataSnapshot snapshot = await ref.get();
    setState(() {
      isAdmin = (FirebaseAuth.instance.currentUser?.uid.toString() ==
          snapshot.value.toString());
    });
  }

  void AlertDeleteGroup(String groupID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(30, 30, 32, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Center(
              child: Text("Confirm Delete Class",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ))),
          content: Text(
              "This action will permanently delete your class. Are you sure you want to continue?",
              style: TextStyle(
                color: Color.fromRGBO(245, 245, 245, 0.8),
                fontSize: 14,
              )),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                        color: Color.fromRGBO(245, 245, 245, 0.8), width: 1.5),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel",
                  style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromRGBO(238, 94, 94, 1)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                DeleteGroup(groupID);
              },
              child: Text("Delete Class",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.8),
                  )),
            ),
          ],
        );
      },
    );
  }

  void DeleteGroup(String groupID) async {
    DataSnapshot snapshot =
        await (FirebaseDatabase.instance.ref("Groups/$groupID/posts")).get();
    List posts = [];

    if (snapshot.value != null) {
      (snapshot.value as Map).forEach((a, b) => posts.add(a));
      for (var post in posts) {
        snapshot =
            await (FirebaseDatabase.instance.ref("Posts/$post/groups")).get();
        List groups = [];
        (snapshot.value as Map).forEach((a, b) => groups.add(a));

        // 1. Remove posts whose groups are only this group
        // 2. Remove membership to this group if post has more than one group
        if (groups.length == 1) {
          DeleteCard(post);
        } else {
          (FirebaseDatabase.instance.ref("Posts/$post/groups/$groupID"))
              .remove();
        }
      }
    }

    // 3. Remove membership to this group
    snapshot =
        await (FirebaseDatabase.instance.ref("Groups/$groupID/members")).get();
    List members = [];
    (snapshot.value as Map).forEach((a, b) => members.add(a));
    for (var member in members) {
      (FirebaseDatabase.instance.ref("Users/$member/groups/$groupID")).remove();
    }

    // 4. Remove this group
    (FirebaseDatabase.instance.ref("Groups/$groupID")).remove();
    Navigator.pop(context);
  }

  void DeleteCard(String postID) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Posts/$postID/groups");
    DataSnapshot snapshot = await ref.get();
    List groups = [];
    (snapshot.value as Map).forEach((a, b) => groups.add(a));
    for (var group in groups) {
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
  }

  void AlertLeaveGroup(String groupID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(30, 30, 32, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Center(
              child: Text("Confirm Leave Class",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ))),
          content: Text(
              "This action will permanently remove you from the class. Are you sure you want to continue?",
              style: TextStyle(
                color: Color.fromRGBO(245, 245, 245, 0.8),
                fontSize: 14,
              )),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                        color: Color.fromRGBO(245, 245, 245, 0.8), width: 1.5),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel",
                  style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromRGBO(238, 94, 94, 1)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                LeaveGroup(widget.groupID);
              },
              child: Text("Leave Class",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.8),
                  )),
            ),
          ],
        );
      },
    );
  }

  void LeaveGroup(String groupID) async {
    String userID = getUID();
    DataSnapshot snapshot =
        await (FirebaseDatabase.instance.ref("Groups/$groupID/posts")).get();
    List posts = [];
    if (snapshot.value != null) {
      (snapshot.value as Map).forEach((a, b) => posts.add(a));
      for (var post in posts) {
        snapshot =
            await (FirebaseDatabase.instance.ref("Posts/$post/userID")).get();
        if (snapshot.value == userID) {
          snapshot =
              await (FirebaseDatabase.instance.ref("Posts/$post/groups")).get();
          List groups = [];
          (snapshot.value as Map).forEach((a, b) => groups.add(a));
          if (groups.length == 1) {
            DeleteCard(post);
          } else {
            (FirebaseDatabase.instance.ref("Posts/$post/groups/$groupID"))
                .remove();
          }
        }
      }
    }
    (FirebaseDatabase.instance.ref("Groups/$groupID/members/$userID")).remove();
    (FirebaseDatabase.instance.ref("Users/$userID/groups/$groupID")).remove();
    Navigator.pop(context);
  }
}

class WidgetGroupsMorePostsBuilder extends StatefulWidget {
  TextEditingController inputSearch;
  var groupID;

  WidgetGroupsMorePostsBuilder(this.groupID, this.inputSearch, {super.key});

  @override
  State createState() => WidgetGroupsMorePostsBuilderState();
}

class WidgetGroupsMorePostsBuilderState
    extends State<WidgetGroupsMorePostsBuilder> {
  List<Post> posts = [];
  bool isDoneBuilding = false;

  @override
  void initState() {
    super.initState();
    widget.inputSearch.addListener(refresh);
    getPosts(widget.groupID);
    DatabaseReference ref = FirebaseDatabase.instance.ref('Posts');
    ref.onChildChanged.listen((event) async {
      for (var post in posts) {
        if (post.postID == event.snapshot.key) {
          post.title = event.snapshot.child('title').value.toString();
          post.content = event.snapshot.child('content').value.toString();
          post.username = await getUsername(
              event.snapshot.child('userID').value.toString());
          post.timeStart = event.snapshot.child('timeStart').value.toString();
          post.groups =
              (event.snapshot.child('groups').value as Map).keys.toList();
          post.emojiData = event.snapshot.child('emojiData').value;
          post.emojiLink = event.snapshot.child('emojiLink').value.toString();
          if (mounted) {
            setState(() {});
          }
        }
      }
    });
    ref.onChildRemoved.listen((event) async {
      for (var post in posts) {
        if (post.postID == event.snapshot.key) {
          posts.removeWhere((post) => post.postID == event.snapshot.key);
          if (mounted) {
            setState(() {});
          }
        }
      }
    });
  }

  getPosts(groupID) async {
    (FirebaseDatabase.instance.ref('Groups/$groupID/posts'))
        .onChildAdded
        .listen((event) async {
      var postID = event.snapshot.key;
      DatabaseReference ref = FirebaseDatabase.instance.ref('Posts/$postID');
      DataSnapshot snapshot = await ref.get();
      if (snapshot.value != null) {
        Map postMetadata = snapshot.value as Map;
        var userID = postMetadata['userID'].toString();
        var username = await getUsername(userID);
        posts.add(Post(
          postID!,
          postMetadata['title'].toString(),
          postMetadata['content'].toString(),
          userID,
          username,
          postMetadata['timeStart'].toString(),
          postMetadata['groups'].keys.toList(),
          postMetadata['emojiData'],
          postMetadata['emojiLink'].toString(),
        ));
      }
      if (mounted) {
        setState(() {
          isDoneBuilding = true;
        });
      }
    });
    if (mounted) {
      setState(() {
        isDoneBuilding = true;
      });
    }
  }

  getUsername(userID) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Users/$userID/username");
    DataSnapshot snapshot = await ref.get();
    return snapshot.value.toString();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: posts.length == 0
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Stack(
                              alignment: const Alignment(0, 1),
                              children: <Widget>[
                                Image.asset(
                                  "lib/assets/images/onboarding/emptypost.png",
                                  height: 300,
                                ),
                                const Text(
                                  "This group has\nno posts yet",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Spotnik',
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 24,
                                      color: Color(0xFF9F9F9F)),
                                ),
                              ]),
                        ),
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 5),
                          leading: Image.asset(
                            "lib/assets/images/onboarding/verifiedoff.png",
                            height: 25,
                          ),
                          title: const Text(
                            "post announcements using the forms button",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0x5EFFFFFF),
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 5),
                          leading: Image.asset(
                            "lib/assets/images/onboarding/verifiedoff.png",
                            height: 25,
                          ),
                          title: const Text(
                            "invite new members by sharing the group\'s QR code",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0x5EFFFFFF),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ))
                : isDoneBuilding
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: posts.length + 1,
                        itemBuilder: (BuildContext context, int i) {
                          bool isPrint = true;
                          if (i == posts.length) {
                            return SizedBox(height: 75);
                          }
                          if (widget.inputSearch.text.isNotEmpty) {
                            isPrint = posts[i].title.toLowerCase().contains(
                                widget.inputSearch.text.toLowerCase());
                          }
                          if (isPrint) {
                            return CardPost(
                              posts[i].postID,
                              posts[i].title,
                              posts[i].content,
                              posts[i].userID,
                              posts[i].timeStart,
                              posts[i].groups,
                              posts[i].emojiData,
                              posts[i].emojiLink,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )));
  }
}
