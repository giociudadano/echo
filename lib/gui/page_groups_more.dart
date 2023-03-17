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
  final inputSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                              hintStyle: const TextStyle(
                                  color: Color.fromRGBO(235, 235, 235, 0.8)),
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
            )),
      ],
    );
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
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('Groups/${widget.groupID}/posts');
    DataSnapshot snapshot = await ref.get();
    List postIDs = snapshot.value == null ? [] : (snapshot.value as Map).keys.toList();
    for (var postID in postIDs) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('Posts/$postID');
      DataSnapshot snapshot = await ref.get();
      Map postMetadata = snapshot.value as Map;
      var userID = postMetadata['userID'].toString();
      var username = await getUsername(userID);
      posts.add(Post(
          postID,
          postMetadata['title'].toString(),
          postMetadata['content'].toString(),
          userID,
          username,
          postMetadata['timeStart'].toString(),
          postMetadata['groups'].keys.toList()));
    }
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
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int i) {
                      bool isPrint = true;
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
