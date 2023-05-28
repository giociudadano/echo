part of main;

class GroupMember {
  String UID, username, displayName, status;
  var profilePictureURL;
  bool isAdmin;

  GroupMember(this.UID, this.username, this.displayName, this.profilePictureURL, this.status, this.isAdmin);
}

class GroupsMoreMembersPage extends StatefulWidget {
  String groupID, displayName = '', username = '', adminID;
  bool isSelectable;
  GroupsMoreMembersPage(this.groupID, this.isSelectable, this.adminID);

  @override
  State<GroupsMoreMembersPage> createState() => GroupsMoreMembersPageState();
}

class GroupsMoreMembersPageState extends State<GroupsMoreMembersPage> {
  var members = [];
  bool isDoneBuilding = false;

  @override
  void initState() {
    super.initState();
    getMembers();
  }

  getProfilePicture(Map userMetadata) {
    if (userMetadata['profilePicture'] == null){
      return null;
    } else {
      return userMetadata['profilePicture']['url'];
    }
  }

  void getMembers() async {
    List users = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref('Groups/${widget.groupID}/members');
    DataSnapshot snapshot = await ref.get();
    (snapshot.value as Map).forEach((a, b) => users.add(a));
    for (var userID in users){
      DatabaseReference ref2 = FirebaseDatabase.instance.ref('Users/$userID');
      snapshot = await ref2.get();
      var userMetadata = snapshot.value as Map;
      members.add(
          GroupMember(
              userID, userMetadata['username'], userMetadata['displayName'],
              getProfilePicture(userMetadata), userMetadata['status'], userID == widget.adminID
          )
      );
    }
    setState((){
      isDoneBuilding = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Color.fromRGBO(32, 35, 43, 1),
          // Navigation bar
          statusBarColor: Colors.black,
        ),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(235, 235, 235, 1), //change your color here
        ),
        title: Text("View Members",
          style: TextStyle(
            color: Color.fromRGBO(235, 235, 235, 1),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromRGBO(32, 35, 43, 1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: isDoneBuilding ? ListView.builder(
              itemCount: members.length,
              itemBuilder: (BuildContext context, int i) {
                return CardGroupMember(widget.groupID, members[i].UID, members[i].username,
                    members[i].displayName, members[i].profilePictureURL, members[i].status, widget.isSelectable, members[i].isAdmin);
              },
            ) : CircularProgressIndicator()
          ),
        ),
      ),
    );
  }
}