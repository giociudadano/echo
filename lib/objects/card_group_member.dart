part of main;

class CardGroupMember extends StatefulWidget {
  var userID, username, displayName, profilePictureURL, status;
  bool isSelectable, isAdmin;
  CardGroupMember(
      this.userID, this.username, this.displayName,
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
      padding: EdgeInsets.only(top: 20),
      child: PopupMenuButton(
        enabled: (widget.isSelectable && !widget.isAdmin),
        color: Color.fromRGBO(30, 30, 32, 1),
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              onTap: () {
                Future.delayed(
                    const Duration(seconds: 0),
                        () => {}
                );
              },
              child: Text(
                "Remove Member",
                style: TextStyle(
                  color: Color.fromRGBO(235, 235, 235, 1),
                ),
              ),
            ),
          ];
        },
        icon: Row(
        children:[
          ProfilePicture(
            name: widget.username,
            radius: 25,
            fontsize: 21,
            img: widget.profilePictureURL,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.displayName,
                style: TextStyle(
                  color: widget.isAdmin ? Color.fromRGBO(
                      151, 98, 242, 1.0) : Color.fromRGBO(245, 245, 245, 1),
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
          )
        ]
      )
      ),
    )
    );
  }
}