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
  bool isFormVisible = false;

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
                              hintText: '🔍  Search classes',
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: isDoneBuilding
                        ? WidgetGroupsBuilder(groups, inputSearch)
                        : Center(
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
              shape: CircleBorder(),
              onPressed: () {
                setState(() {
                  isFormVisible = true;
                });
              },
              backgroundColor: Color.fromRGBO(98, 112, 242, 1),
              child: const Icon(Icons.new_label_outlined),
            ),
          ),
        ),
        Visibility(
          visible: isFormVisible,
          child: FormAddGroup(
            isVisible: (value) {
              isFormVisible = value;
              setState(() {
              });
            }
          ),
        ),
      ],
    );
  }

  void getGroups() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Users/${getUID()}/groups");
    DataSnapshot snapshot = await ref.get();
    List groupIDs = (snapshot.value as Map).keys.toList();
    for (var groupID in groupIDs) {
      DatabaseReference ref2 = FirebaseDatabase.instance.ref("Groups/$groupID");
      DataSnapshot snapshot = await ref2.get();
      Map groupMetadata = snapshot.value as Map;
      DatabaseReference ref3 = FirebaseDatabase.instance
          .ref("Users/${groupMetadata['admin']}/username");
      DataSnapshot snapshot2 = await ref3.get();
      var username = snapshot2.value;
      groups.add(Group("$groupID", "${groupMetadata['name']}",
          "${groupMetadata['description']}", "$username"));
    }
    if (mounted) {
      setState(() {
        isDoneBuilding = true;
      });
    }
  }
}

class FormAddGroup extends StatefulWidget {
  final ValueChanged<bool> isVisible;
  const FormAddGroup({super.key, required this.isVisible});

  @override
  State<StatefulWidget> createState() => _FormAddGroupState();
}

class _FormAddGroupState extends State<FormAddGroup> {
  final GlobalKey<FormState> _formAddGroupKey = GlobalKey<FormState>();
  final _inputGroupName = TextEditingController();
  final _inputGroupDesc = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Center(
          child: Row(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Card(
                  color: Color.fromRGBO(32, 35, 43, 1),
                  child: Container(
                    height: 300,
                    child: Stack(
                      children: [
                        Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: Form(
                        key: _formAddGroupKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              const Text("Add Class",
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _inputGroupName,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Group Name',
                                  labelStyle: TextStyle(color: Color.fromRGBO(235, 235, 235, 0.6), fontSize: 14),
                                  hintText: 'Enter group name',
                                  hintStyle: TextStyle(color: Color.fromRGBO(235, 235, 235, 0.2), fontSize: 14),
                                  isDense: true,
                                  filled: true,
                                  fillColor: Color.fromRGBO(22, 23, 27, 1),
                                ),
                                style: const TextStyle(fontSize: 14, color: Color.fromRGBO(235, 235, 235, 0.8)),
                                validator: (String? value) {
                                  return _verifyGroupName(value);
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _inputGroupDesc,
                                keyboardType: TextInputType.multiline,
                                minLines: 2,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Group Description',
                                  labelStyle: TextStyle(color: Color.fromRGBO(235, 235, 235, 0.6), fontSize: 14),
                                  hintText: 'Enter group description',
                                  hintStyle: TextStyle(color: Color.fromRGBO(235, 235, 235, 0.2), fontSize: 14),
                                  isDense: true,
                                  filled: true,
                                  fillColor: Color.fromRGBO(22, 23, 27, 1),
                                ),
                                style: const TextStyle(fontSize: 14, color: Color.fromRGBO(235, 235, 235, 0.8)),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(98, 112, 242, 1)),
                                ),
                                onPressed: () async {
                                  if (_formAddGroupKey.currentState!
                                      .validate()) {
                                    _writeGroup(
                                      context,
                                      _inputGroupName.text,
                                      _inputGroupDesc.text,
                                      getUID(),
                                    );
                                  }
                                },
                                child: const Text('Add Group',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ]
                        )
                      ),
                    ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(onPressed: () {
                            setState(() {
                              widget.isVisible(false);
                            });
                          }, icon: Icon(Icons.close_rounded, color: Color.fromRGBO(98, 112, 242, 1))),
                        ),
                ],
                    ),
                  )
              ),
            ),
          ),
        )
      ]
          )
      ),
    );
  }

  _verifyGroupName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a group name';
    }
    return null;
  }

  void _writeGroup(
      BuildContext context, String name, String desc, String userID) {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Groups");
      var pushedRef = ref.push();
      var groupID = pushedRef.key;
      pushedRef.update({
        'name': name,
        'description': desc,
        'members': {userID: true},
      });
      DatabaseReference ref2 =
          FirebaseDatabase.instance.ref("Users/$userID/groups");
      ref2.update({
        "$groupID": true,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Group has been added!"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "There was an error adding your group. Please try again later."),
      ));
    }
  }
}

class WidgetGroupsBuilder extends StatefulWidget {
  List groups = [];
  TextEditingController inputSearch;

  WidgetGroupsBuilder(this.groups, this.inputSearch, {super.key});

  @override
  State<WidgetGroupsBuilder> createState() => _WidgetGroupsBuilderState();
}

class _WidgetGroupsBuilderState extends State<WidgetGroupsBuilder> {
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
        itemCount: widget.groups.length,
        itemBuilder: (BuildContext context, int i) {
          var group = widget.groups[i];
          bool isPrint = true;
          if (widget.inputSearch.text.isNotEmpty) {
            isPrint = group.groupName
                .toLowerCase()
                .contains(widget.inputSearch.text.toLowerCase());
          }
          if (isPrint) {
            return CardGroup(group.groupName, group.groupDesc, group.adminName);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
