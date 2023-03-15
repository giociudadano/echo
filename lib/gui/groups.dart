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
                            contentPadding: const EdgeInsets.fromLTRB(22, 12, 60, 12),
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
                  child: isDoneBuilding ? WidgetGroupsBuilder(groups, inputSearch) : Center(
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
          onPressed: () {  },
          backgroundColor: Color.fromRGBO(98, 112, 242, 1),
          child: const Icon(Icons.new_label_outlined),
        ),
      ),
    );
  }

  void getGroups() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        "Users/${getUID()}/groups");
    DataSnapshot snapshot = await ref.get();
    List groupIDs = (snapshot.value as Map).keys.toList();
    for(var groupID in groupIDs){
      DatabaseReference ref2 = FirebaseDatabase.instance.ref("Groups/$groupID");
      DataSnapshot snapshot = await ref2.get();
      Map groupMetadata = snapshot.value as Map;
      DatabaseReference ref3 = FirebaseDatabase.instance.ref(
          "Users/${groupMetadata['admin']}/username");
      DataSnapshot snapshot2 = await ref3.get();
      var username = snapshot2.value;
      groups.add(Group("$groupID", "${groupMetadata['name']}",
          "${groupMetadata['description']}", "$username"));
    }
    if(mounted) {
      setState(() {
        isDoneBuilding = true;
      });
    }
  }
}

class WidgetGroupsBuilder extends StatefulWidget{
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
    setState(() {
    });
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
            if (widget.inputSearch.text.isNotEmpty){
              isPrint = group.groupName.toLowerCase().contains(widget.inputSearch.text.toLowerCase());
            }
            if (isPrint) {
              return CardGroup(
                  group.groupName, group.groupDesc, group.adminName
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
    );
  }
}
