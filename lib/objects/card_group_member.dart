part of main;

class CardGroupMember extends StatefulWidget {
  var userID, username, displayName, profilePictureURL, status;
  CardGroupMember(this.userID, this.username, this.displayName, this.profilePictureURL, this.status);

  @override
  State<CardGroupMember> createState() => _CardGroupMemberState();
}

class _CardGroupMemberState extends State<CardGroupMember> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
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
                  color: Color.fromRGBO(245, 245, 245, 1),
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
    );
  }
}