part of main;

class DebugPage extends StatelessWidget {
  final GlobalKey<FormState> _formAddPostKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formAddGroupKey = GlobalKey<FormState>();
  final _inputCardTitle = TextEditingController();
  final _inputCardContent = TextEditingController();
  final _inputCardTimeStart = TextEditingController();

  final _inputGroupName = TextEditingController();
  final _inputGroupDesc = TextEditingController();

  DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    SizedBox(height: 17),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Debug',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 28)),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                        child: ListView(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _logoutUser(context);
                          },
                          child: const Text('Log Out'),
                        ),
                        FormAddPost(context),
                        FormAddGroup(context),
                      ],
                    )),
                  ],
                ))),
      ),
    );
  }

  FormAddPost(BuildContext context) {
    return Form(
      key: _formAddPostKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Text("Add Card"),
          SizedBox(height: 5),
          TextFormField(
            controller: _inputCardTitle,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
              hintText: 'Enter title',
              isDense: true,
            ),
            style: TextStyle(fontSize: 14),
            validator: (String? value) {
              return _verifyCardTitle(value);
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _inputCardContent,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Content',
              hintText: 'Enter additional information here.',
              isDense: true,
            ),
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _inputCardTimeStart,
            readOnly: true,
            onTap: () {
              DatePicker.showDateTimePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(), onConfirm: (date) {
                String formattedDate =
                    DateFormat('EEEE, MMMM d, y HH:mm').format(date);
                _inputCardTimeStart.text = formattedDate;
              }, locale: LocaleType.en);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Start Time',
              isDense: true,
            ),
            style: TextStyle(fontSize: 14),
            validator: (String? value) {
              return _verifyCardDate(value);
            },
          ),
          SizedBox(height: 30),
          GroupSelector(),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              if (_formAddPostKey.currentState!.validate()) {
                _writePost(
                    context,
                    _inputCardTitle.text,
                    _inputCardContent.text,
                    getUID(),
                    _inputCardTimeStart.text);
              }
            },
            child: const Text('Write Data'),
          ),
        ],
      ),
    );
  }

  FormAddGroup(BuildContext context) {
    return Form(
        key: _formAddGroupKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: 40),
          Text("Add Group"),
          SizedBox(height: 10),
          TextFormField(
            controller: _inputGroupName,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Group Name',
              hintText: 'Enter group name',
              isDense: true,
            ),
            style: TextStyle(fontSize: 14),
            validator: (String? value) {
              return _verifyGroupName(value);
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _inputGroupDesc,
            keyboardType: TextInputType.multiline,
            minLines: 2,
            maxLines: 2,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Group Description',
              hintText: 'Enter group description',
              isDense: true,
            ),
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              if (_formAddGroupKey.currentState!.validate()) {
                _writeGroup(
                    context,
                    _inputGroupName.text,
                    _inputGroupDesc.text,
                    getUID(),
                );
              }
            },
            child: const Text('Add Group'),
          ),
        ]));
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

  _verifyGroupName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a group name';
    }
    return null;
  }

  void _logoutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "There was an error logging out your account. Please try again later."),
      ));
      return;
    }
  }

  void _writePost(BuildContext context, title, content, userID, timeStart) {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Posts");
      ref.push().update({
        'title': title,
        'content': content,
        'userID': userID,
        'timeStart': timeStart,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Post has been submitted!"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "There was an error submitting your post. Please try again later."),
      ));
    }
  }

  void _writeGroup(BuildContext context, String name, String desc, String UID) {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Groups");
      var pushedRef = ref.push();
      var groupID = pushedRef.key;
      pushedRef.update({
        'name' : name,
        'description' : desc,
        'members' : {UID : true},
      });
      DatabaseReference ref2 = FirebaseDatabase.instance.ref("Users/$UID/groups");
      ref2.update({
        "$groupID" : true,
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

class GroupSelector extends StatefulWidget{
  const GroupSelector({super.key});
  @override
  State<GroupSelector> createState() => _GroupSelectorState();
}

class _GroupSelectorState extends State<GroupSelector>{
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
    return groups.length != 0 ? Column(
      children: <Widget>[
        Container(
          child: MultiSelectBottomSheetField(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(235, 235, 235, 1),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            backgroundColor: Colors.white,
            buttonIcon: Icon(Icons.group),
            initialChildSize: 0.37,
            listType: MultiSelectListType.CHIP,
            searchable: true,
            buttonText: Text("Select a group to post"),
            items: items,
            onConfirm: (values) {
              selectedGroups = values;
            },
            chipDisplay: MultiSelectChipDisplay(
              onTap: (value) {
                setState(() {
                  selectedGroups.remove(value);
                });
              },
            ),
          ),
        ),
        selectedGroups == null || selectedGroups.isEmpty
            ? Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(
              "None selected",
              style: TextStyle(color: Colors.black54),
            ))
            : Container(),
      ],
    ) : Text("Join a group to post something!");
  }

  void getGroups() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        "Users/${getUID()}/groups");
    DataSnapshot snapshot = await ref.get();
    Map value = snapshot.value as Map;
    if (value != null){
      value.forEach((a, b) => groups.add(a));
    }

    var groupNames = [];
    for(var group in groups){
      DatabaseReference ref2 = FirebaseDatabase.instance.ref(
          "Groups/${group}/name");
      DataSnapshot snapshot = await ref2.get();
      groupNames.add(snapshot.value);
    }
    items = groups.map((group) => MultiSelectItem(group, groupNames[groups.indexOf(group)])).toList();
    selectedGroups = groups;
    setState(() {});
  }
}

getUID() {
  String userID = '';
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  }
}


