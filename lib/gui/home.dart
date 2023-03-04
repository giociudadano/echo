part of main;

class Post {
  String title = "";
  String content = "";
  String userID = "";
  String timeStart = "";

  Post(this.title, this.content, this.userID, this.timeStart);
}

class HomePage extends StatelessWidget {
  var filters = [];
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(28, 5, 28, 10),
                  child: Text('For You',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(22, 15, 60, 15),
                    hintText: 'Search cards',
                    filled: true,
                    fillColor: const Color.fromRGBO(233, 235, 247, 1),
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
             const SizedBox(height: 15),
             WidgetGroupsFilter(
               groupsFiltered: (newGroups){
                 filters = newGroups;
               }
             ),
             const SizedBox(height: 5),
             WidgetPostsBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetGroupsFilter extends StatefulWidget {
  final ValueChanged<List> groupsFiltered;
  const WidgetGroupsFilter({super.key, required this.groupsFiltered});
  @override
  State createState() => WidgetGroupsFilterState();
}

class WidgetGroupsFilterState extends State<WidgetGroupsFilter> {
  bool isDoneBuilding = false;
  var groupIDs = [];
  var groupNames = [];
  var filters = [];

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  @override
  Widget build (BuildContext context) {
    return SizedBox(
      height: 30,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(Icons.filter_alt_sharp, color: Color.fromRGBO(120, 120, 120, 1), size: 14),
              SizedBox(width: 5),
              Text("Filter Class",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color.fromRGBO(120, 120, 120, 1),
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: isDoneBuilding ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: groupIDs.length,
                  itemBuilder: (BuildContext context, int i) {
                    return
                        Row(
                          children: [
                            NotificationListener<RemoveGroup>(
                              onNotification: (n) {
                                setState(() {
                                  filters.remove(groupIDs[i]);
                                  widget.groupsFiltered(filters);
                                });
                                return true;
                              },
                              child: NotificationListener<AddGroup>(
                                child: GroupFilter(groupIDs[i], groupNames[i], filters),
                                  onNotification: (n) {
                                    setState(() {
                                      filters.add(groupIDs[i]);
                                      widget.groupsFiltered(filters);
                                    });
                                    return true;
                                  }
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        );
                  },
                ) : Text("Loading your groups..."),
              ),
            ],
          )
      ),
    );
  }

  void getGroups() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        "Users/${getUID()}/groups");
    DataSnapshot snapshot = await ref.get();
    Map value = snapshot.value as Map;
    value.forEach((a, b) => groupIDs.add(a));
    for(var groupID in groupIDs){
      DatabaseReference ref2 = FirebaseDatabase.instance.ref("Groups/$groupID/name");
      DataSnapshot snapshot = await ref2.get();
      groupNames.add("${snapshot.value}");
    }
    setState(() {
      isDoneBuilding = true;
    });
  }
}


class WidgetPostsBuilder extends StatefulWidget {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Posts');

  WidgetPostsBuilder({super.key});

  @override
  State createState() => WidgetPostsBuilderState();
}

class WidgetPostsBuilderState extends State<WidgetPostsBuilder> {
  List <Post> posts = [];

  @override
  void initState() {
    super.initState();

    widget.ref.onChildAdded.listen((event) {
      posts.add(
          Post(
              event.snapshot.child('title').value.toString(),
              event.snapshot.child('content').value.toString(),
              event.snapshot.child('userID').value.toString(),
              event.snapshot.child('timeStart').value.toString(),
          )
      );
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build (BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int i) {
              return CardPost(posts[i].title, posts[i].content, posts[i].userID, posts[i].timeStart);
            },
          )
        )
    );
  }
}

