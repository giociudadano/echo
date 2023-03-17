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
                    const SizedBox(height: 17),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Debug',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 28)),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                        child: ListView(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _logoutUser(context);
                          },
                          child: const Text('Log Out'),
                        ),
                        addPostForm(context),
                        addFormGroup(context),
                      ],
                    )),
                  ],
                ))),
      ),
    );
  }

  addPostForm(BuildContext context) {
    var groupsToPost = [];

    return Form(
      key: _formAddPostKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Text("Add Card"),
          const SizedBox(height: 5),
          TextFormField(
            controller: _inputCardTitle,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
              hintText: 'Enter title',
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
            validator: (String? value) {
              return _verifyCardTitle(value);
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
              labelText: 'Content',
              hintText: 'Enter additional information here.',
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 10),
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
            style: const TextStyle(fontSize: 16),
            validator: (String? value) {
              return _verifyCardDate(value);
            },
          ),
          const SizedBox(height: 30),
          GroupSelector(
            groupsSelected: (newGroups) {
              groupsToPost = newGroups;
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              if (_formAddPostKey.currentState!.validate()) {
                _writePost(
                    context,
                    _inputCardTitle.text,
                    _inputCardContent.text,
                    getUID(),
                    _inputCardTimeStart.text,
                    groupsToPost,
                );
              }
            },
            child: const Text('Write Data'),
          ),
        ],
      ),
    );
  }

  addFormGroup(BuildContext context) {
    return Form(
        key: _formAddGroupKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 40),
          const Text("Add Group"),
          const SizedBox(height: 10),
          TextFormField(
            controller: _inputGroupName,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Group Name',
              hintText: 'Enter group name',
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
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
              hintText: 'Enter group description',
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 10),
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

  void _writePost(BuildContext context, title, content, userID, timeStart, groups) {
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
      for (var group in groups){
        DatabaseReference ref2 = FirebaseDatabase.instance.ref("Groups/$group/posts");
        ref2.update({newPost.key!: true});
      }

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

  void _writeGroup(BuildContext context, String name, String desc, String userID) {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Groups");
      var pushedRef = ref.push();
      var groupID = pushedRef.key;
      pushedRef.update({
        'name' : name,
        'description' : desc,
        'members' : {userID : true},
      });
      DatabaseReference ref2 = FirebaseDatabase.instance.ref("Users/$userID/groups");
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



