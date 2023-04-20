part of main;

class GroupsMorePage extends StatefulWidget {
  String groupID;
  String groupName;
  String groupDesc;

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
    isGroupAdmin(widget.groupID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Positioned(
                                      top: 28,
                                      child: Text(
                                        "${widget.groupDesc}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuButton(
                              icon: Icon(Icons.more_vert, color: Colors.white),
                              color: Colors.black,
                              itemBuilder: (BuildContext context) {
                                return isAdmin
                                    ? [
                                        PopupMenuItem(
                                          onTap: () {
                                            Future.delayed(
                                                const Duration(seconds: 0),
                                            () => AlertDeleteGroup(widget.groupID));
                                          },
                                          child: Text(
                                            "Delete Class",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 167, 167, 1)),
                                          ),
                                        ),
                                      ]
                                    : [
                                        PopupMenuItem(
                                          child: Text(
                                            "Leave Class",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 167, 167, 1)),
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
            child: const Icon(Icons.add_card),
          ),
        );
  }

  void isGroupAdmin(String groupID) async {
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
          icon: Icon(Icons.label_off,
              color: Color.fromRGBO(238, 94, 94, 1), size: 32),
          backgroundColor: Color.fromRGBO(32, 35, 43, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Confirm Delete Class",
              style: TextStyle(
                color: Color.fromRGBO(245, 245, 245, 1),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              )),
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
                )),
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
                )),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                DeleteGroup(groupID);
              },
              child: Text("Delete",
                  style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
            ),
          ],
        );
      },
    );
  }

  void DeleteGroup(String groupID) async {
    DataSnapshot snapshot = await (FirebaseDatabase.instance.ref("Groups/$groupID/posts")).get();
    List posts = [];

    if (snapshot.value != null) {
      (snapshot.value as Map).forEach((a, b) => posts.add(a));
      for (var post in posts){
        snapshot = await (FirebaseDatabase.instance.ref("Posts/$post/groups")).get();
        List groups = [];
        (snapshot.value as Map).forEach((a, b) => groups.add(a));

        // 1. Remove posts whose groups are only this group
        if (groups.length == 1){
          DeleteCard(post);
        } else {
          (FirebaseDatabase.instance.ref("Posts/$post/groups/$groupID")).remove();
        }
      }
    }

    // 3. Remove membership to this group
    snapshot = await (FirebaseDatabase.instance.ref("Groups/$groupID/members")).get();
    List members = [];
    (snapshot.value as Map).forEach((a, b) => members.add(a));
    for (var member in members){
      (FirebaseDatabase.instance.ref("Users/$member/groups/$groupID")).remove();
    }

    // 4. Remove this group
    (FirebaseDatabase.instance.ref("Groups/$groupID")).remove();
    Navigator.pop(context);
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
  }

  getPosts(groupID) async {
    (FirebaseDatabase.instance.ref('Groups/$groupID/posts')).onChildAdded.listen((event) async {
      var postID = event.snapshot.key;
      DatabaseReference ref = FirebaseDatabase.instance.ref('Posts/$postID');
      DataSnapshot snapshot = await ref.get();
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
          postMetadata['groups'].keys.toList()
      ));
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
            child: isDoneBuilding
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: posts.length + 1,
                    itemBuilder: (BuildContext context, int i) {
                      bool isPrint = true;
                      if (i == posts.length) {
                        return SizedBox(height: 75);
                      }
                      if (widget.inputSearch.text.isNotEmpty) {
                        isPrint = posts[i]
                            .title
                            .toLowerCase()
                            .contains(widget.inputSearch.text.toLowerCase());
                      }
                      if (isPrint) {
                        return CardPost(
                            posts[i].postID,
                            posts[i].title,
                            posts[i].content,
                            posts[i].userID,
                            posts[i].username,
                            posts[i].timeStart);
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
