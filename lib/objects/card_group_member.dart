part of main;

class CardGroupMember extends StatefulWidget {
  var groupID, userID, username, displayName, profilePictureURL, status;
  bool isSelectable, isAdmin;
  CardGroupMember(
      this.groupID, this.userID, this.username, this.displayName,
      this.profilePictureURL, this.status, this.isSelectable, this.isAdmin);

  @override
  State<CardGroupMember> createState() => _CardGroupMemberState();
}

class _CardGroupMemberState extends State<CardGroupMember> {
  bool onSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: () {
      setState((){
        onSelected = !onSelected;
      });
    },
    child: Padding(
      padding: EdgeInsets.only(top: 15),
      child: PopupMenuButton(
        enabled: (widget.isSelectable && !widget.isAdmin),
        color: Colors.black,
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              onTap: () {
                Future.delayed(
                    const Duration(seconds: 0),
                        () => AlertRemoveMember(widget.userID)
                );
              },
              child: Text(
                "Remove Member",
                style: TextStyle(
                  color: Color.fromRGBO(255, 167, 167, 1),
                ),
              ),
            ),
          ];
        },
        icon: Row(
        children:[
          Stack(
            children: [
              ProfilePicture(
                name: widget.username,
                radius: 25,
                fontsize: 21,
                img: widget.profilePictureURL,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(32, 35, 43, 1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: getStatusColor(widget.status),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              widget.status == 'Away' ? Positioned(
                  bottom: 5,
                  right: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(32, 35, 43, 1),
                      shape: BoxShape.circle,
                    ),
                  )
              ) : SizedBox.shrink(),
              widget.status == 'Do Not Disturb' ?
              Positioned(
                  bottom: 9,
                  right: 7,
                  child: ClipRect(
                      child: Container(
                        width: 7,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(32, 35, 43, 1),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )
                  )
              ) : SizedBox.shrink(),
              widget.status == 'Offline' ? Positioned(
                  bottom: 7,
                  right: 7,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(32, 35, 43, 1),
                      shape: BoxShape.circle,
                    ),
                  )
              ) : SizedBox.shrink(),
            ]
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.displayName,
                style: TextStyle(
                  color: widget.isAdmin ? Color.fromRGBO(
                      183, 147, 248, 1.0) : Color.fromRGBO(245, 245, 245, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )
              ),
              Text(widget.username,
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    height: 0.95,
                  )
              ),
            ]
          ),
          Spacer(),
          widget.isAdmin ? Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(183, 147, 248, 1.0),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
            child: Text("   Admin   ",
                style: TextStyle(
                    color: Color.fromRGBO(183, 147, 248, 1.0),
                    fontSize: 12,
                )
            )
          )
          : SizedBox.shrink(),
        ]
      )
      ),
    )
    );
  }

  void AlertRemoveMember(String userID){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(30, 30, 32, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Center(
              child: Text("Confirm Remove Member?",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ))),
            content: Text("This action will remove this user from the group. They will be required to scan the QR Code again in order to be re-invited. Are you sure you want to continue?",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color.fromRGBO(245, 245, 245, 0.6),
                  height: 0.95,
                  fontSize: 12,
                )
            ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStatePropertyAll<Color>(Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                        color: Color.fromRGBO(245, 245, 245, 0.8), width: 1.5),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel",
                  style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromRGBO(238, 94, 94, 1)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              onPressed: () {
                RemoveMember(widget.groupID, widget.userID);
                Navigator.of(context).pop();
              },
              child: Text("Confirm",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.8),
                  )),
            ),
          ],
        );
      },
    );
  }

  void RemoveMember(String groupID, String userID) async {
    DataSnapshot snapshot =
    await (FirebaseDatabase.instance.ref("Groups/$groupID/posts")).get();
    List posts = [];
    if (snapshot.value != null) {
      (snapshot.value as Map).forEach((a, b) => posts.add(a));
      for (var post in posts) {
        snapshot =
        await (FirebaseDatabase.instance.ref("Posts/$post/userID")).get();
        if (snapshot.value == userID) {
          snapshot =
          await (FirebaseDatabase.instance.ref("Posts/$post/groups")).get();
          List groups = [];
          (snapshot.value as Map).forEach((a, b) => groups.add(a));
          if (groups.length == 1) {
            DeleteCard(post);
          } else {
            (FirebaseDatabase.instance.ref("Posts/$post/groups/$groupID"))
                .remove();
          }
        }
      }
    }
    (FirebaseDatabase.instance.ref("Groups/$groupID/members/$userID")).remove();
    (FirebaseDatabase.instance.ref("Users/$userID/groups/$groupID")).remove();
    Navigator.pop(context);
  }

}