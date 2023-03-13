part of main;

class GroupsPage extends StatefulWidget {

  GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 35, 43, 1),
      body: SizedBox(height:20)
    );
  }
}
