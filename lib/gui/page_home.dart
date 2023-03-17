part of main;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final inputSearch = TextEditingController();
  var filters = [];
  bool isFormVisible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          backgroundColor: const Color.fromRGBO(32, 35, 43, 1),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.black,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: TextFormField(
                            controller: inputSearch,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(22, 12, 60, 12),
                              hintText: '🔍  Search card',
                              hintStyle: TextStyle(
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
                        ),
                        const SizedBox(height: 15),
                        WidgetGroupsFilter(groupsFiltered: (newGroups) {
                          filters = newGroups;
                          setState(() {});
                        }),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  WidgetDashboardPostsBuilder(filters, inputSearch),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                setState(() {
                  isFormVisible = true;
                });
              },
              backgroundColor: const Color.fromRGBO(98, 112, 242, 1),
              child: const Icon(Icons.add_card),
            ),
          )),
      Visibility(
        visible: isFormVisible,
        child: FormAddPost('All', isVisible: (value) {
          isFormVisible = value;
          setState(() {});
        }),
      ),
    ]);
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Icon(Icons.filter_alt_sharp,
                  color: Color.fromRGBO(230, 230, 230, 1), size: 14),
              const SizedBox(width: 5),
              const Text(
                "Filter Class",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color.fromRGBO(230, 230, 230, 1),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: isDoneBuilding
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: groupIDs.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Row(
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
                                    child: GroupFilter(
                                        groupIDs[i], groupNames[i], filters),
                                    onNotification: (n) {
                                      setState(() {
                                        filters.add(groupIDs[i]);
                                        widget.groupsFiltered(filters);
                                      });
                                      return true;
                                    }),
                              ),
                              const SizedBox(width: 10),
                            ],
                          );
                        },
                      )
                    : const Text("Loading your cards...",
                        style: TextStyle(
                            color: Color.fromRGBO(235, 235, 235, 0.8))),
              ),
            ],
          )),
    );
  }

  void getGroups() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Users/${getUID()}/groups");
    DataSnapshot snapshot = await ref.get();
    groupIDs = (snapshot.value as Map).keys.toList();
    for (var groupID in groupIDs) {
      DatabaseReference ref2 =
          FirebaseDatabase.instance.ref("Groups/$groupID/name");
      DataSnapshot snapshot = await ref2.get();
      groupNames.add("${snapshot.value}");
    }
    if (mounted) {
      setState(() {
        isDoneBuilding = true;
      });
    }
  }
}

class WidgetDashboardPostsBuilder extends StatefulWidget {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Posts');
  var filters = [];
  TextEditingController inputSearch;

  WidgetDashboardPostsBuilder(this.filters, this.inputSearch, {super.key});

  @override
  State createState() => WidgetDashboardPostsBuilderState();
}

class WidgetDashboardPostsBuilderState
    extends State<WidgetDashboardPostsBuilder> {
  List<Post> posts = [];
  List<Post> postsFiltered = [];
  bool isDoneBuilding = false;

  @override
  void initState() {
    super.initState();
    widget.inputSearch.addListener(refresh);
    widget.ref.onChildAdded.listen((event) async {
      Map groups = event.snapshot.child('groups').value as Map;
      var userID = event.snapshot.child('userID').value.toString();
      var username = await getUsername(userID);
      posts.add(Post(
          event.snapshot.key.toString(),
          event.snapshot.child('title').value.toString(),
          event.snapshot.child('content').value.toString(),
          userID,
          username,
          event.snapshot.child('timeStart').value.toString(),
          groups.keys.toList()));
      if (mounted) {
        setState(() {
          isDoneBuilding = true;
        });
      }
    });
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
                      if (widget.filters.isNotEmpty) {
                        for (var filter in widget.filters) {
                          isPrint = posts[i].groups.contains(filter);
                          if (posts[i].groups.contains(filter)) {
                            if (widget.inputSearch.text.isNotEmpty) {
                              isPrint = posts[i].title.toLowerCase().contains(
                                  widget.inputSearch.text.toLowerCase());
                            } else {
                              isPrint = true;
                            }
                          } else {
                            isPrint = false;
                          }
                        }
                      } else {
                        if (widget.inputSearch.text.isNotEmpty) {
                          isPrint = posts[i]
                              .title
                              .toLowerCase()
                              .contains(widget.inputSearch.text.toLowerCase());
                        }
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

class Post {
  String postID, title, content, username, userID, timeStart;
  List groups = [];

  Post(this.postID, this.title, this.content, this.userID, this.username,
      this.timeStart, this.groups);
}


class FormAddPost extends StatefulWidget {
  final ValueChanged<bool> isVisible;
  var groupID;
  var groupsToPost = [];

  FormAddPost(this.groupID, {super.key, required this.isVisible});

  @override
  State<StatefulWidget> createState() => _FormAddPostState();
}

class _FormAddPostState extends State<FormAddPost> {
  final GlobalKey<FormState> _formAddPostKey = GlobalKey<FormState>();
  final _inputCardTitle = TextEditingController();
  final _inputCardContent = TextEditingController();
  final _inputCardTimeStart = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Row(children: [
          Expanded(
              child: Stack(
                children: [
                  Container(
                    color: Colors.black54,
                  ),
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
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 10, 30, 10),
                                        child: ListView(children:[Form(
                                          key: _formAddPostKey,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 20),
                                              const Text("Add Card",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.w700)),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                controller: _inputCardTitle,
                                                decoration: const InputDecoration(
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
                                                  fillColor:
                                                  Color.fromRGBO(22, 23, 27, 1),
                                                ),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        235, 235, 235, 0.8)),
                                                validator: (String? value) {
                                                  return _verifyCardTitle(value);
                                                },
                                              ),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                controller: _inputCardContent,
                                                keyboardType:
                                                TextInputType.multiline,
                                                minLines: 3,
                                                maxLines: 3,
                                                decoration: const InputDecoration(
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
                                                  fillColor:
                                                  Color.fromRGBO(22, 23, 27, 1),
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
                                                      theme: const DatePickerTheme(
                                                        cancelStyle: TextStyle(
                                                            color: Color.fromRGBO(
                                                                255, 167, 167, 1)),
                                                        itemStyle: TextStyle(
                                                            color: Color.fromRGBO(
                                                                235, 235, 235, 1)),
                                                        doneStyle: TextStyle(
                                                            color: Color.fromRGBO(
                                                                98, 112, 242, 1)),
                                                        backgroundColor:
                                                        Color.fromRGBO(
                                                            32, 35, 43, 1),
                                                      ),
                                                      showTitleActions: true,
                                                      minTime: DateTime.now(),
                                                      onConfirm: (date) {
                                                        String formattedDate = DateFormat(
                                                            'EEEE, MMMM d, y HH:mm')
                                                            .format(date);
                                                        _inputCardTimeStart.text =
                                                            formattedDate;
                                                      }, locale: LocaleType.en);
                                                },
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Start Time',
                                                  labelStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          235, 235, 235, 0.6),
                                                      fontSize: 14),
                                                  isDense: true,
                                                  filled: true,
                                                  fillColor:
                                                  Color.fromRGBO(22, 23, 27, 1),
                                                ),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        235, 235, 235, 0.8)),
                                                validator: (String? value) {
                                                  return _verifyCardDate(value);
                                                },
                                              ),
                                              const SizedBox(height: 15),
                                              widget.groupID == 'All' ? GroupSelector(
                                                groupsSelected: (newGroups) {
                                                  widget.groupsToPost = newGroups;
                                                },
                                              ) : SizedBox.shrink(),
                                              const SizedBox(height: 15),
                                              ElevatedButton(
                                                style: const ButtonStyle(
                                                  backgroundColor:
                                                  MaterialStatePropertyAll<
                                                      Color>(
                                                      Color.fromRGBO(
                                                          98, 112, 242, 1)),
                                                ),
                                                onPressed: () async {
                                                  if (_formAddPostKey.currentState!
                                                      .validate()) {
                                                    _writePost(
                                                      context,
                                                      _inputCardTitle.text,
                                                      _inputCardContent.text,
                                                      getUID(),
                                                      _inputCardTimeStart.text,
                                                      widget.groupID == 'All' ? widget.groupsToPost : ["${widget.groupID}"],
                                                    );
                                                  }
                                                },
                                                child: const Text('Add Group',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        )]),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                widget.isVisible(false);
                                              });
                                            },
                                            icon: const Icon(Icons.close_rounded,
                                                color: Color.fromRGBO(
                                                    98, 112, 242, 1))),
                                      ),
                                    ],
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

  _verifyCardTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }

  _verifyCardDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a start date';
    }
    return null;
  }

  void _writePost(
      BuildContext context, title, content, userID, timeStart, groups) {
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
      });
      for (var group in groups) {
        DatabaseReference ref2 =
        FirebaseDatabase.instance.ref("Groups/$group/posts");
        ref2.update({newPost.key!: true});
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Post has been submitted!"),
      ));
      setState(() {

      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "There was an error submitting your post. Please try again later."),
      ));
    }
  }
}

class GroupSelector extends StatefulWidget{
  final ValueChanged<List> groupsSelected;
  const GroupSelector({super.key, required this.groupsSelected});
  @override
  State<GroupSelector> createState() => _GroupSelectorState();
}

class _GroupSelectorState extends State<GroupSelector>{
  bool isDoneBuilding = false;
  var groups = [];
  var items;
  List selectedGroups = [];

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return isDoneBuilding ? Column(
      children: <Widget>[
        MultiSelectBottomSheetField(
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color.fromRGBO(235, 235, 235, 1),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          backgroundColor: Colors.white,
          buttonIcon: const Icon(Icons.group),
          initialChildSize: 0.37,
          listType: MultiSelectListType.CHIP,
          searchable: true,
          buttonText: const Text("Select a group to post"),
          items: items,
          onConfirm: (values) {
            selectedGroups = values;
          },
          onSelectionChanged: (values) {
            widget.groupsSelected(values);
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (value) {
              setState(() {
                selectedGroups.remove(value);
              });
            },
          ),
        ),
        selectedGroups.isEmpty
            ? Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: const Text(
              "None selected",
              style: TextStyle(color: Colors.black54),
            ))
            : Container(),
      ],
    ) : const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text("Loading Classes...", style: TextStyle(color: Color.fromRGBO(235, 235, 235, 0.6)),
    ));
  }

  void getGroups() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        "Users/${getUID()}/groups");
    DataSnapshot snapshot = await ref.get();
    Map value = snapshot.value as Map;
    value.forEach((a, b) => groups.add(a));
    var groupNames = [];
    for(var group in groups){
      DatabaseReference ref2 = FirebaseDatabase.instance.ref(
          "Groups/$group/name");
      DataSnapshot snapshot = await ref2.get();
      groupNames.add(snapshot.value);
    }
    items = groups.map((group) => MultiSelectItem(group, groupNames[groups.indexOf(group)])).toList();
    selectedGroups = groups;
    if (mounted) {
      setState(() {
        isDoneBuilding = true;
      });
    }
  }
}

getUID() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  }
}

