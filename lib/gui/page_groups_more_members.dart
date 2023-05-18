part of main;

class GroupsMoreMembersPage extends StatefulWidget {
  String displayName = '', username = '';
  GroupsMoreMembersPage();

  @override
  State<GroupsMoreMembersPage> createState() => GroupsMoreMembersPageState();
}

class GroupsMoreMembersPageState extends State<GroupsMoreMembersPage> {

  @override
  void initState() {
    super.initState();
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
            child: SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}