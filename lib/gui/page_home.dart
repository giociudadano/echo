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
    return Scaffold(
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
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FormAddPost('All');
                  });
            },
            backgroundColor: const Color.fromRGBO(98, 112, 242, 1),
            child: const Icon(Icons.note_add_outlined),
          ),
        ));
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
              const Icon(Icons.filter_alt_outlined,
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
                child: groupIDs.length == 0
                    ? SizedBox.shrink()
                    : isDoneBuilding
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
                                        child: GroupFilter(groupIDs[i],
                                            groupNames[i], filters),
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
    if (snapshot.value == null) {
      setState(() {
        isDoneBuilding = true;
      });
      return;
    }
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

  var filters = [];
  TextEditingController inputSearch;
  WidgetDashboardPostsBuilder(this.filters, this.inputSearch, {super.key});

  @override
  State createState() => WidgetDashboardPostsBuilderState();
}

class WidgetDashboardPostsBuilderState extends State<WidgetDashboardPostsBuilder> {
  List<Post> posts = [];
  bool isDoneBuilding = false;

  @override
  void initState() {
    super.initState();
    DatabaseReference ref = FirebaseDatabase.instance.ref('Posts');
    widget.inputSearch.addListener(refresh);
    ref.onChildAdded.listen((event) async {
      List groups = (event.snapshot.child('groups').value as Map).keys.toList();
      var userID = event.snapshot.child('userID').value.toString();
      var username = await getUsername(userID);
      DatabaseReference ref2 = FirebaseDatabase.instance.ref("Users/${getUID()}/groups");
      DataSnapshot snapshot = await ref2.get();
      if (snapshot.value != null) {
        for (var group in (snapshot.value as Map).keys.toList()) {
          if (groups.contains(group)) {
            posts.add(
              Post(
                event.snapshot.key.toString(),
                event.snapshot.child('title').value.toString(),
                event.snapshot.child('content').value.toString(),
                userID,
                username,
                event.snapshot.child('timeStart').value.toString(),
                groups,
                event.snapshot.child('emojiData').value,
                event.snapshot.child('emojiLink').value.toString(),
              )
            );
            break;
          }
        }
      }
      if (mounted) {
        setState(() {
          isDoneBuilding = true;
        });
      }
    });
    ref.onChildChanged.listen((event) async {
      for (var post in posts){
        if (post.postID == event.snapshot.key){
          post.title = event.snapshot.child('title').value.toString();
          post.content = event.snapshot.child('content').value.toString();
          post.username = await getUsername(event.snapshot.child('userID').value.toString());
          post.timeStart = event.snapshot.child('timeStart').value.toString();
          post.groups = (event.snapshot.child('groups').value as Map).keys.toList();
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
            child: posts.length == 0 ? SizedBox.shrink()
                : isDoneBuilding ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: posts.length + 1,
                        itemBuilder: (BuildContext context, int i) {
                          bool isPrint = true;
                          if (i == posts.length) {
                            return SizedBox(height: 75);
                          }
                          if (widget.filters.isNotEmpty) {
                            for (var filter in widget.filters) {
                              isPrint = posts[i].groups.contains(filter);
                              if (posts[i].groups.contains(filter)) {
                                if (widget.inputSearch.text.isNotEmpty) {
                                  isPrint = posts[i]
                                      .title
                                      .toLowerCase()
                                      .contains(widget.inputSearch.text
                                          .toLowerCase());
                                } else {
                                  isPrint = true;
                                  break;
                                }
                              } else {
                                isPrint = false;
                              }
                            }
                          } else {
                            if (widget.inputSearch.text.isNotEmpty) {
                              isPrint = posts[i].title.toLowerCase().contains(
                                  widget.inputSearch.text.toLowerCase());
                            }
                          }
                          if (isPrint) {
                            return CardPost(
                                posts[i].postID,
                                posts[i].title,
                                posts[i].content,
                                posts[i].userID,
                                posts[i].username,
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

class Post {
  String postID, title, content, username, userID, timeStart, emojiLink;
  var emojiData;
  List groups = [];

  Post(this.postID, this.title, this.content, this.userID, this.username,
      this.timeStart, this.groups, this.emojiData, this.emojiLink);
}

class FormAddPost extends StatefulWidget {
  var groupID;
  var groupsToPost = [];

  FormAddPost(this.groupID);

  @override
  State<StatefulWidget> createState() => _FormAddPostState();
}

class _FormAddPostState extends State<FormAddPost> {
  final GlobalKey<FormState> _formAddPostKey = GlobalKey<FormState>();
  final _inputCardTitle = TextEditingController();
  final _inputCardContent = TextEditingController();
  final _inputCardTimeStart = TextEditingController();
  final _emojiController = TextEditingController();
  final _scrollController = ScrollController();

  Emoji? emojiSelected = null;
  bool emojiShowing = false;

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
                                padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                                child: RawScrollbar(
                                  thumbColor: Color.fromRGBO(235, 235, 235, 0.1),
                                  thumbVisibility: true,
                                  thickness: 10,
                                  controller: _scrollController,
                                  child: ListView(
                                      controller: _scrollController,
                                      children: [
                                        Form(
                                          key: _formAddPostKey,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 10),
                                              Icon(Icons.note_add_outlined,
                                                  color: Color.fromRGBO(98, 112, 242, 1),
                                                  size: 32
                                              ),
                                              const SizedBox(height: 10),
                                              const Text("Create a New Card",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(245, 245, 245, 1),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                              ),
                                              const SizedBox(height: 20),
                                              Text("CARD INFORMATION",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        245, 245, 245, 0.6),
                                                    fontSize: 11,
                                                    letterSpacing: 2.5,
                                                  ),
                                              ),
                                              const SizedBox(height: 5),
                                              TextFormField(
                                                controller: _inputCardTitle,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Card Title',
                                                  labelStyle: TextStyle(
                                                      color: Color.fromRGBO(235, 235, 235, 0.6),
                                                      fontSize: 14
                                                  ),
                                                  hintText: 'Enter card title',
                                                  hintStyle: TextStyle(
                                                      color: Color.fromRGBO(235, 235, 235, 0.2),
                                                      fontSize: 14
                                                  ),
                                                  isDense: true,
                                                  filled: true,
                                                  fillColor: Color.fromRGBO(22, 23, 27, 1),
                                                ),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(235, 235, 235, 0.8)),
                                                validator: (String? value) {
                                                  return verifyCardTitle(value);
                                                },
                                              ),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                controller: _inputCardContent,
                                                keyboardType: TextInputType.multiline,
                                                minLines: 3,
                                                maxLines: 3,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Card Content',
                                                  labelStyle: TextStyle(
                                                      color: Color.fromRGBO(235, 235, 235, 0.6),
                                                      fontSize: 14),
                                                  hintText: 'Enter additional information here.',
                                                  hintStyle: TextStyle(
                                                      color: Color.fromRGBO(235, 235, 235, 0.2),
                                                      fontSize: 14),
                                                  isDense: true,
                                                  filled: true,
                                                  fillColor: Color.fromRGBO(22, 23, 27, 1),
                                                ),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(235, 235, 235, 0.8)),
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
                                                            color: Color.fromRGBO(255, 167, 167, 1)
                                                        ),
                                                        itemStyle: TextStyle(
                                                            color: Color.fromRGBO(235,235,235,1)
                                                        ),
                                                        doneStyle: TextStyle(
                                                            color: Color.fromRGBO(98, 112, 242, 1)
                                                        ),
                                                        backgroundColor: Color.fromRGBO(32, 35, 43, 1),
                                                      ),
                                                      showTitleActions: true,
                                                      minTime: DateTime.now(),
                                                      onConfirm: (date) {
                                                    String formattedDate = DateFormat('EEEE, MMMM d, y HH:mm').format(date);
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
                                              widget.groupID == 'All'
                                                  ? Text("CARD VISIBILITY",
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(245, 245, 245, 0.6),
                                                        fontSize: 11,
                                                        letterSpacing: 2.5,
                                                      ))
                                                  : SizedBox.shrink(),
                                              const SizedBox(height: 5),
                                              widget.groupID == 'All'
                                                  ? Column(children: [
                                                      GroupSelector(
                                                        groupsSelected: (newGroups) {
                                                          widget.groupsToPost = newGroups;
                                                        },
                                                      ),
                                                      const SizedBox(height: 20),
                                                    ])
                                                  : SizedBox.shrink(),
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
                                                  if (_formAddPostKey
                                                      .currentState!
                                                      .validate()) {
                                                    Navigator.of(context).pop();
                                                    _writePost(
                                                      context,
                                                      _inputCardTitle.text,
                                                      _inputCardContent.text,
                                                      getUID(),
                                                      _inputCardTimeStart.text,
                                                      widget.groupID == 'All' ? widget.groupsToPost : ["${widget.groupID}"],
                                                      emojiSelected!.toJson(),
                                                      getEmojiLink(emojiSelected),
                                                    );
                                                  }
                                                },
                                                child: const Text('Create Card',
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
      BuildContext context, String title, String content, String userID, String timeStart, groups, Map emojiData, String emojiLink) {
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
        'emojiData' : emojiData,
        'emojiLink' : emojiLink,
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

class GroupSelector extends StatefulWidget {
  final ValueChanged<List> groupsSelected;
  List initGroups = [];

  GroupSelector({super.key, required this.groupsSelected, this.initGroups = const []});

  @override
  State<GroupSelector> createState() => _GroupSelectorState();
}

class _GroupSelectorState extends State<GroupSelector> {
  bool isDoneBuilding = false;
  var groups = [];
  var items;
  List selectedGroups = [];

  @override
  void initState() {
    super.initState();
    getGroups();
    selectedGroups = widget.initGroups;
  }

  @override
  Widget build(BuildContext context) {
    return groups.length == 0
        ? Column(children: [
            SizedBox(height: 12),
            Text("Join a class to submit a card!",
                style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
            SizedBox(height: 12),
          ])
        : isDoneBuilding
            ? Column(
                children: <Widget>[
                  MultiSelectBottomSheetField(
                    validator: (value) {
                      if (selectedGroups.isEmpty) {
                        return 'Please select a group to post';
                      }
                      return null;
                    },
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color.fromRGBO(22, 23, 27, 1),
                    ),
                    searchTextStyle:
                        TextStyle(color: Color.fromRGBO(235, 235, 235, 0.6)),
                    backgroundColor: Color.fromRGBO(41, 44, 50, 1),
                    buttonIcon: const Icon(Icons.group_add_outlined,
                        color: Color.fromRGBO(235, 235, 235, 0.6)),
                    initialChildSize: 0.37,
                    itemsTextStyle:
                        TextStyle(color: Color.fromRGBO(235, 235, 235, 0.8)),
                    selectedItemsTextStyle: TextStyle(color: Colors.black),
                    checkColor: Color.fromRGBO(235, 235, 235, 0.8),
                    selectedColor: Color.fromRGBO(210, 210, 210, 1),
                    unselectedColor: Color.fromRGBO(63, 69, 84, 1),
                    listType: MultiSelectListType.CHIP,
                    searchable: true,
                    searchHintStyle:
                        TextStyle(color: Color.fromRGBO(235, 235, 235, 0.6)),
                    searchIcon: Icon(Icons.search,
                        color: Color.fromRGBO(235, 235, 235, 0.6)),
                    closeSearchIcon: Icon(Icons.close,
                        color: Color.fromRGBO(235, 235, 235, 0.6)),
                    buttonText: const Text("Select a class to post",
                        style: TextStyle(
                            color: Color.fromRGBO(235, 235, 235, 0.8))),
                    items: items,
                    title: Text("Search a class",
                        style:
                            TextStyle(color: Color.fromRGBO(225, 225, 225, 1))),
                    onConfirm: (values) {
                      selectedGroups = values;
                    },
                    onSelectionChanged: (values) {
                      widget.groupsSelected(values);
                    },
                    initialValue: selectedGroups,
                    chipDisplay: MultiSelectChipDisplay(
                      chipColor: Color.fromRGBO(210, 210, 210, 1),
                      textStyle: TextStyle(color: Colors.black, fontSize: 12),
                      onTap: (value) {
                        setState(() {
                          selectedGroups.remove(value);
                        });
                      },
                    ),
                  ),
                ],
              )
            : const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Loading Classes...",
                  style: TextStyle(color: Color.fromRGBO(235, 235, 235, 0.6)),
                ));
  }

  void getGroups() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/${getUID()}/groups");
    DataSnapshot snapshot = await ref.get();
    if (snapshot.value == null) {
      setState(() {
        isDoneBuilding = true;
      });
      return;
    }
    Map value = snapshot.value as Map;
    value.forEach((a, b) => groups.add(a));
    var groupNames = [];
    for (var group in groups) {
      DatabaseReference ref2 =
          FirebaseDatabase.instance.ref("Groups/$group/name");
      DataSnapshot snapshot = await ref2.get();
      groupNames.add(snapshot.value);
    }
    items = groups.map((group) => MultiSelectItem(group, groupNames[groups.indexOf(group)])).toList();
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
