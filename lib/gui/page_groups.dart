part of main;

class Group {
  String groupID, groupName, groupDesc, adminName;

  Group(this.groupID, this.groupName, this.groupDesc, this.adminName);
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
      setState((){
        for (var group in groups){
          if (group.groupID == event.snapshot.key){
            setState((){
              group.groupName = event.snapshot.child('name').value.toString();
              group.groupDesc = event.snapshot.child('description').value.toString();
            });
          }
        }
      });
    });
  }

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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () async {
                              AlertJoinGroup();
                            },
                            child: const Text('Scan QR Code',
                                style: TextStyle(
                                  color: Color.fromRGBO(235, 235, 235, 0.6),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color.fromRGBO(235, 235, 235, 0.6),
                                )),
                          ),
                      ]
                    )
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: groups.length == 0 ? SizedBox.shrink() : isDoneBuilding
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
    (FirebaseDatabase.instance.ref("Users/${getUID()}/groups")).onChildAdded.listen((event) async {
      var groupID = event.snapshot.key;
      DatabaseReference ref2 = FirebaseDatabase.instance.ref("Groups/$groupID");
      DataSnapshot snapshot = await ref2.get();
      Map groupMetadata = snapshot.value as Map;
      DatabaseReference ref3 = FirebaseDatabase.instance
        .ref("Users/${groupMetadata['admin']}/username");
      DataSnapshot snapshot2 = await ref3.get();
      var username = snapshot2.value;
      groups.add(Group("$groupID", "${groupMetadata['name']}",
        "${groupMetadata['description']}", "$username"));
      if (mounted) {
        setState(() {
          isDoneBuilding = true;
        });
      }
    });

    (FirebaseDatabase.instance.ref("Users/${getUID()}/groups")).onChildRemoved.listen((event) async {
      var groupID = event.snapshot.key;
      groups.removeWhere((group) => group.groupID == groupID);
      setState(() {
      });
    });
  }

  void AlertJoinGroup() {
    MobileScannerController cameraController = MobileScannerController();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              leading: const BackButton(
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
              title: const Text('Scan QR Code',
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
                  JoinGroup('${barcode.rawValue}');
                  Navigator.pop(context);
                }
              },
            ),
          );
        },
    );
  }

  void JoinGroup(String groupID) async {
    DataSnapshot snapshot = await (FirebaseDatabase.instance.ref("Groups"))
        .get();
    if (snapshot.hasChild(groupID)) {
      String userID = "${getUID()}";
      DatabaseReference ref = FirebaseDatabase.instance.ref("Groups/${groupID}/members");
      ref.update({
        userID: true,
      });
      DatabaseReference ref2 = FirebaseDatabase.instance.ref("Users/${userID}/groups");
      ref2.update({
        groupID: true,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Successfully added to group!"),
      ));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color.fromRGBO(32, 35, 43, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text("Invalid Class Invite",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  )),
              content: Text(
                  "We could not find a class with that ID. Please try again with a valid QR code.",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.8),
                    fontSize: 14,
                  )
              ),
              actions: [
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Confirm",
                      style: TextStyle(
                        color: Color.fromRGBO(245, 245, 245, 0.8),
                      )
                  ),
                ),
              ]
            );
          }
      );
    }
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
                            color: const Color.fromRGBO(32, 35, 43, 1),
                            child: Container(
                              height: 330,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 20, 30, 20),
                                    child: ListView(children: [Form(
                                        key: _formAddGroupKey,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10),
                                              Icon(Icons.group_add_outlined, color: Color.fromRGBO(98, 112, 242, 1), size: 32),
                                              const SizedBox(height: 10),
                                              const Text("Create a New Class",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(245, 245, 245, 1),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  )
                                              ),
                                              const SizedBox(height: 20),
                                              Text("CLASS INFORMATION",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        245, 245, 245, 0.6),
                                                    fontSize: 11,
                                                    letterSpacing: 2.5,
                                                  )),
                                              const SizedBox(height: 5),
                                              TextFormField(
                                                controller: inputGroupName,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Class Name',
                                                  labelStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          235, 235, 235, 0.6),
                                                      fontSize: 14),
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
                                                  return verifyGroupName(
                                                      value);
                                                },
                                              ),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                controller: inputGroupDesc,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                minLines: 2,
                                                maxLines: 2,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      'Class Description',
                                                  labelStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          235, 235, 235, 0.6),
                                                      fontSize: 14),
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
                                              const SizedBox(height: 10),
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
                                                  if (_formAddGroupKey
                                                      .currentState!
                                                      .validate()) {
                                                    addGroup(
                                                      context,
                                                      inputGroupName.text,
                                                      inputGroupDesc.text,
                                                      getUID(),
                                                    );
                                                  }
                                                },
                                                child: const Text(
                                                  'Create Class',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ])
                                    )]),
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
        itemCount: widget.groups.length+1,
        itemBuilder: (BuildContext context, int i) {
          if (i == widget.groups.length){
            return SizedBox(height: 75);
          }
          var group = widget.groups[i];
          bool isPrint = true;
          if (widget.inputSearch.text.isNotEmpty) {
            isPrint = group.groupName
                .toLowerCase()
                .contains(widget.inputSearch.text.toLowerCase());
          }
          if (isPrint) {
            return CardGroup(group.groupID, group.groupName, group.groupDesc,
                group.adminName);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
