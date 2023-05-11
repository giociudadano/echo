part of main;

class CardGroup extends StatefulWidget {
  var groupID, name, desc, adminID, adminUsername = '', adminProfilePicture;
  bool isDoneBuilding = false;
  CardGroup(this.groupID, this.name, this.desc, this.adminID) {
  }

  @override
  State<CardGroup> createState() => _CardGroupState();
}

class _CardGroupState extends State<CardGroup> {

  @override
  void initState() {
    super.initState();
    getUsername();
    getProfilePicture();
  }

  void getUsername() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/${widget.adminID}/username");
    DataSnapshot snapshot = await ref.get();
    if (mounted){
      setState(() {
        widget.adminUsername = snapshot.value.toString();
      });
    }
  }

  void getProfilePicture() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/${widget.adminID}/profilePicture/url");
    DataSnapshot snapshot = await ref.get();
    if (mounted){
      setState(() {
        widget.adminProfilePicture = snapshot.value.toString();
        widget.isDoneBuilding = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(21, 23, 28, 0)),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Color.fromRGBO(21, 23, 28, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.name}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${widget.desc}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: Colors.white,
                                    height: 0.85,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 58,
                            child: widget.isDoneBuilding ? Row(
                              children: [
                                Text("by",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: Color.fromRGBO(235, 235, 235, 0.6),
                                  )
                                ),
                                SizedBox(width: 5),
                                ProfilePicture(
                                  name: widget.adminUsername,
                                  radius: 10,
                                  fontsize: 6,
                                  img: widget.adminProfilePicture,
                                ),
                                SizedBox(width: 5),
                                Text("${widget.adminUsername}",
                                  style: const TextStyle(
                                     fontWeight: FontWeight.w400,
                                     fontSize: 13,
                                     color: Color.fromRGBO(235, 235, 235, 0.6),
                                  )
                                )
                              ]
                            ) : SizedBox.shrink()
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          color: Color.fromRGBO(98, 112, 242, 1),
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GroupsMorePage("${widget.groupID}","${widget.name}", "${widget.desc}")),
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
