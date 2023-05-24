part of main;

class Group {
  String groupID, groupName, groupDesc, adminID;

  Group(this.groupID, this.groupName, this.groupDesc, this.adminID);
}

class GroupsPage extends StatefulWidget {
  GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final inputSearch = TextEditingController();
  var groups = [];
  bool isDoneBuilding = false;

  @override
  void initState() {
    super.initState();
    getGroups();
    DatabaseReference ref = FirebaseDatabase.instance.ref('Groups');
    ref.onChildChanged.listen((event) async {
      setState(() {
        for (var group in groups) {
          if (group.groupID == event.snapshot.key) {
            setState(() {
              group.groupName = event.snapshot.child('name').value.toString();
              group.groupDesc =
                  event.snapshot.child('description').value.toString();
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.black, // Navigation bar
            statusBarColor: Colors.black,
          )),
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
                          hintText: '🔍  Search classes',
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
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Expanded(
                child: groups.length == 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 60),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Stack(
                                  alignment: const Alignment(0, 1),
                                  children: <Widget>[
                                    Image.asset(
                                      "lib/assets/images/onboarding/emptygroup.png",
                                      height: 300,
                                    ),
                                    const Text(
                                      "It feels lonely in here...",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Spotnik',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 28,
                                          color: Color(0xFFFFFFFF)),
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
                                "create a new group using the form button",
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
                                "join a group by scanning a valid QR code",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0x5EFFFFFF),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStatePropertyAll<
                                    Color>(
                                    Colors.black),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius
                                          .circular(8.0),
                                    )),
                              ),
                              onPressed: () async {
                                AlertJoinGroup(context);
                              },
                              child: Row(children: [
                                Icon(Icons.qr_code_scanner,
                                    size: 15,
                                    color: Color.fromRGBO(235, 235, 235, 0.6)),
                                SizedBox(width: 5),
                                Text(
                                  'SCAN QR CODE',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(245, 245, 245, 0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ]),
                            ),
                              ],
                            )
                            ],
                        ))
                    : isDoneBuilding
                        ? WidgetGroupsBuilder(groups, inputSearch)
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
              ),
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
                  return FormAddGroup();
                });
          },
          backgroundColor: const Color.fromRGBO(98, 112, 242, 1),
          child: const Icon(Icons.group_add_outlined),
        ),
      ),
    );
  }

  void getGroups() async {
    (FirebaseDatabase.instance.ref("Users/${getUID()}/groups"))
        .onChildAdded
        .listen((event) async {
      var groupID = event.snapshot.key;
      DatabaseReference ref2 = FirebaseDatabase.instance.ref("Groups/$groupID");
      DataSnapshot snapshot = await ref2.get();
      Map groupMetadata = snapshot.value as Map;
      groups.add(Group("$groupID", "${groupMetadata['name']}",
          "${groupMetadata['description']}", "${groupMetadata['admin']}"));
      if (mounted) {
        setState(() {
          isDoneBuilding = true;
        });
      }
    });

    (FirebaseDatabase.instance.ref("Users/${getUID()}/groups"))
        .onChildRemoved
        .listen((event) async {
      var groupID = event.snapshot.key;
      groups.removeWhere((group) => group.groupID == groupID);
      setState(() {});
    });
  }
}

class FormAddGroup extends StatefulWidget {
  const FormAddGroup({super.key});

  @override
  State<StatefulWidget> createState() => _FormAddGroupState();
}

class _FormAddGroupState extends State<FormAddGroup> {
  final GlobalKey<FormState> _formAddGroupKey = GlobalKey<FormState>();
  final inputGroupName = TextEditingController();
  final inputGroupDesc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Row(children: [
          Expanded(
            child: Center(
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
                          color: const Color.fromRGBO(30, 30, 32, 1),
                          child: Container(
                            height: 350,
                            child: Stack(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 20, 30, 20),
                                  child: ListView(children: [
                                    Form(
                                        key: _formAddGroupKey,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 20),
                                              const Center(
                                                child:
                                                    Text("Create a New Class",
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              245, 245, 245, 1),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 20,
                                                        )),
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                "NAME",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      245, 245, 245, 0.8),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              TextFormField(
                                                controller: inputGroupName,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Enter class name',
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
                                                  return verifyGroupName(value);
                                                },
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "DESCRIPTION",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      245, 245, 245, 0.8),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              TextFormField(
                                                controller: inputGroupDesc,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                minLines: 2,
                                                maxLines: 2,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'Enter class description',
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
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll<
                                                                  Color>(
                                                              Colors
                                                                  .transparent),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        side: BorderSide(
                                                            color:
                                                                Color.fromRGBO(
                                                                    245,
                                                                    245,
                                                                    245,
                                                                    0.8),
                                                            width: 1.5),
                                                      )),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Cancel",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    245,
                                                                    245,
                                                                    245,
                                                                    0.8))),
                                                  ),
                                                  SizedBox(width: 10),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll<
                                                                  Color>(
                                                              Color.fromRGBO(98,
                                                                  112, 242, 1)),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      )),
                                                    ),
                                                    onPressed: () async {
                                                      if (_formAddGroupKey
                                                          .currentState!
                                                          .validate()) {
                                                        addGroup(
                                                          context,
                                                          inputGroupName.text,
                                                          inputGroupDesc.text,
                                                          getUID(),
                                                        );
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Create',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ]))
                                  ]),
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
          ),
        ]),
      )
    ]);
  }

  verifyGroupName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a class name';
    }
    return null;
  }

  void addGroup(BuildContext context, String name, String desc, String userID) {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Groups");
      var pushedRef = ref.push();
      var groupID = pushedRef.key;
      pushedRef.update({
        'name': name,
        'description': desc,
        'members': {userID: true},
        'admin': userID,
      });
      DatabaseReference ref2 =
          FirebaseDatabase.instance.ref("Users/$userID/groups");
      ref2.update({
        "$groupID": true,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Class has been added!"),
      ));
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "There was an error adding your class. Please try again later."),
      ));
    }
  }
}

class WidgetGroupsBuilder extends StatefulWidget {
  List groups = [];
  TextEditingController inputSearch;

  WidgetGroupsBuilder(this.groups, this.inputSearch, {super.key});

  @override
  State<WidgetGroupsBuilder> createState() => WidgetGroupsBuilderState();
}

class WidgetGroupsBuilderState extends State<WidgetGroupsBuilder> {
  @override
  void initState() {
    super.initState();
    widget.inputSearch.addListener(refresh);
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.groups.length + 2,
        itemBuilder: (BuildContext context, int i) {
          if (i == 0) {
            return Padding(
                padding: EdgeInsets.fromLTRB(5, 7, 0, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MY CLASSES',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(245, 245, 245, 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 35,
                        child: TextButton(
                          onPressed: () async {
                            AlertJoinGroup(context);
                          },
                          child: Row(children: [
                            Icon(Icons.qr_code_scanner,
                                size: 15,
                                color: Color.fromRGBO(235, 235, 235, 0.6)),
                            SizedBox(width: 5),
                            Text(
                              'SCAN QR CODE',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(245, 245, 245, 0.8),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ]),
                        ),
                      )
                    ]));
          }
          if (i == widget.groups.length + 1) {
            return SizedBox(height: 75);
          }
          var group = widget.groups[i - 1];
          bool isPrint = true;
          if (widget.inputSearch.text.isNotEmpty) {
            isPrint = group.groupName
                .toLowerCase()
                .contains(widget.inputSearch.text.toLowerCase());
          }
          if (isPrint) {
            return CardGroup(
                group.groupID, group.groupName, group.groupDesc, group.adminID);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

void AlertJoinGroup(BuildContext context) {
  MobileScannerController cameraController = MobileScannerController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          title: const Text(
            'Scan QR Code',
            style: TextStyle(
              fontFamily: 'SF-Pro',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              color: Colors.black,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state as TorchState) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.black,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state as CameraFacing) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: MobileScanner(
          // fit: BoxFit.contain,
          controller: cameraController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              JoinGroup('${barcode.rawValue}', context);
              Navigator.pop(context);
            }
          },
        ),
      );
    },
  );
}

void JoinGroup(String groupID, BuildContext context) async {
  DataSnapshot snapshot =
  await (FirebaseDatabase.instance.ref("Groups")).get();
  if (snapshot.hasChild(groupID)) {
    String userID = "${getUID()}";
    DatabaseReference ref =
    FirebaseDatabase.instance.ref("Groups/${groupID}/members");
    ref.update({
      userID: true,
    });
    DatabaseReference ref2 =
    FirebaseDatabase.instance.ref("Users/${userID}/groups");
    ref2.update({
      groupID: true,
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Successfully added to group!"),
    ));
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Color.fromRGBO(30, 30, 32, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Center(
                child: Column(children: [
                  Image.asset(
                    "lib/assets/images/onboarding/emptypost.png",
                    height: 300,
                  ),
                  Text("Invalid Class Invite",
                      style: TextStyle(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      )),
                ]),
              ),
              content: Text(
                  "We could not find a class with that ID. Please try again with a valid QR code.",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.8),
                    fontSize: 14,
                  )),
              actions: [
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromRGBO(98, 112, 242, 1)),
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Confirm",
                        style: TextStyle(
                          color: Color.fromRGBO(245, 245, 245, 0.8),
                        )),
                  ),
                ),
              ]);
        });
  }
}