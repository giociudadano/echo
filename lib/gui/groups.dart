part of main;

class GroupsPage extends StatefulWidget {
  GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final inputSearch = TextEditingController();

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
                WidgetGroupsBuilder(),
              ],
            ),
          ),
        ),
    );
  }
}

class WidgetGroupsBuilder extends StatefulWidget{
  @override
  State<WidgetGroupsBuilder> createState() => _WidgetGroupsBuilderState();
}

class _WidgetGroupsBuilderState extends State<WidgetGroupsBuilder> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, int i) {
                return CardGroup();
              },
            ),
        )
    );
  }
}
