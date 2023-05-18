part of main;

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool hasProfilePicture = false;
  String UID = getUID();
  String username = '';
  String displayName = '';
  String profilePictureURL = '';
  String status = '';

  @override
  void initState() {
    super.initState();
    getHasProfilePicture();
    getProfileMetadata();
  }

  void getHasProfilePicture() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Users/$UID/profilePicture");
    DataSnapshot snapshot = await ref.get();
    setState(() {
      hasProfilePicture = (snapshot.value != null);
      if (hasProfilePicture) {
        profilePictureURL = snapshot.child("url").value.toString();
      }
    });
  }

  void getProfileMetadata() async {
    DataSnapshot snapshot = await (FirebaseDatabase.instance.ref("Users/$UID/username")).get();
    String username = snapshot.value.toString();
    snapshot = await (FirebaseDatabase.instance.ref("Users/$UID/displayName")).get();
    String displayName = snapshot.value.toString();
    snapshot = await (FirebaseDatabase.instance.ref("Users/$UID/status")).get();
    String status = snapshot.value.toString();
    setState(() {
      this.username = username;
      this.displayName = displayName;
      this.status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    getProfileMetadata();
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.black, // rNavigation bar
            statusBarColor: Color.fromRGBO(32, 35, 43, 1),
          )
      ),
      backgroundColor: const Color.fromRGBO(32, 35, 43, 1),
      body: SafeArea(
        child: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                    child: ListView(
                        children: [
                    SizedBox(height: 20),
                Text("PROFILE",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                    color: Color.fromRGBO(22, 22, 22, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(children: [
                        GestureDetector(
                          onTap: () {
                            AlertChangeStatus();
                          },
                          child: Stack(children: [
                            ProfilePicture(
                              name: username,
                              radius: 50,
                              fontsize: 21,
                              img: profilePictureURL,
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(25, 25, 32, 1),
                                    shape: BoxShape.circle,
                                  ),
                                )),
                            Positioned(
                                bottom: 7,
                                right: 7,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: getStatusColor(status),
                                    shape: BoxShape.circle,
                                  ),
                                )),
                            getStatusOverlay(status),
                          ]),
                        ),
                        SizedBox(width: 25),
                        Expanded(
                            child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Stack(clipBehavior: Clip.none, children: [
                                    Text(displayName,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color:
                                          Color.fromRGBO(245, 245, 245, 1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22,
                                        )),
                                    Positioned(
                                      top: 28,
                                      child: Text(username,
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                245, 245, 245, 0.8),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          )),
                                    )
                                  ]),
                                  SizedBox(height: 30),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            const Color.fromRGBO(
                                                98, 112, 242, 1)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                            ))),
                                    onPressed: () {
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            ProfileEditPage(displayName, username)
                                        ),
                                      ).then((_) {
                                        getHasProfilePicture();
                                        getProfileMetadata();
                                        debugPrint("[DEBUG] Refreshed!");
                                      }
                                      );
                                    },
                                    child: Text(
                                      '    Edit Profile    ',
                                      style: TextStyle(
                                        color:
                                        Color.fromRGBO(235, 235, 235, 0.8),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ]))
                      ]),
                    )),
                SizedBox(height: 20),
                      Text("SETTINGS",
                        style: TextStyle(
                          color: Color.fromRGBO(245, 245, 245, 0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          AlertChangeStatus();
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.person_pin_circle_outlined,
                                    color: Color.fromRGBO(235, 235, 235, 0.8)),
                                SizedBox(width: 20),
                                Text('Set Status',
                                    style: TextStyle(
                                      color: Color.fromRGBO(235, 235, 235, 0.8),
                                      fontSize: 14,
                                    ))
                              ]),
                              Row(children: [
                                Stack(
                                  children:[
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: getStatusColor(status),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    status == 'Away' ? Positioned(
                                          bottom: 3,
                                          right: 3,
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(32, 35, 43, 1),
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                      ) : SizedBox.shrink(),
                                    status == 'Do Not Disturb' ?
                                    Positioned(
                                        top: 3,
                                        left: 2,
                                        child: ClipRect(
                                            child: Container(
                                              width: 6,
                                              height: 3,
                                              decoration: BoxDecoration(
                                                color: Color.fromRGBO(32, 35, 43, 1),
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            )
                                        )
                                    ) : SizedBox.shrink(),
                                    status == 'Offline' ? Positioned(
                                        top: 2,
                                        left: 2,
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
                                SizedBox(width: 12),
                                Text(status,
                                    style: TextStyle(
                                      color: Color.fromRGBO(235, 235, 235, 0.4),
                                      fontSize: 14,
                                )),
                                SizedBox(width: 20),
                                Icon(Icons.chevron_right,
                                    color: Color.fromRGBO(235, 235, 235, 0.8)),
                              ]),
                            ]),
                      ),
                      TextButton(
                        onPressed: () {
                          logoutUser(context);
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.logout_outlined,
                                    color: Color.fromRGBO(255, 167, 167, 1)),
                                SizedBox(width: 20),
                                Text('Log Out',
                                    style: TextStyle(
                                      color: Color.fromRGBO(235, 235, 235, 0.8),
                                      fontSize: 14,
                                    ))
                              ]),
                              Icon(Icons.chevron_right,
                                  color: Color.fromRGBO(235, 235, 235, 0.8)),
                            ]),
                      ),
                      SizedBox(height: 5),
                      Divider(height: 1, color: Color.fromRGBO(235, 235, 235, 0.2)),
                      SizedBox(height: 5),
                      TextButton(
                        onPressed: () {
                          displayUnimplementedError();
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.language_outlined,
                                    color: Color.fromRGBO(235, 235, 235, 0.8)),
                                SizedBox(width: 20),
                                Text('Language',
                                    style: TextStyle(
                                      color: Color.fromRGBO(235, 235, 235, 0.8),
                                      fontSize: 14,
                                    ))
                              ]),
                              Icon(Icons.chevron_right,
                                  color: Color.fromRGBO(235, 235, 235, 0.8)),
                            ]),
                      ),
                      TextButton(
                        onPressed: () {
                          displayUnimplementedError();
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.accessibility_new_outlined,
                                    color: Color.fromRGBO(235, 235, 235, 0.8)),
                                SizedBox(width: 20),
                                Text('Accessibility',
                                    style: TextStyle(
                                      color: Color.fromRGBO(235, 235, 235, 0.8),
                                      fontSize: 14,
                                    ))
                              ]),
                              Icon(Icons.chevron_right,
                                  color: Color.fromRGBO(235, 235, 235, 0.8)),
                            ]),
                      ),
                      TextButton(
                        onPressed: () {
                          displayUnimplementedError();
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.display_settings_outlined,
                                    color: Color.fromRGBO(235, 235, 235, 0.8)),
                                SizedBox(width: 20),
                                Text('Display',
                                    style: TextStyle(
                                      color: Color.fromRGBO(235, 235, 235, 0.8),
                                      fontSize: 14,
                                    ))
                              ]),
                              Icon(Icons.chevron_right,
                                  color: Color.fromRGBO(235, 235, 235, 0.8)),
                            ]),
                      ),
                      TextButton(
                        onPressed: () {
                          displayUnimplementedError();
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.smartphone_outlined,
                                    color: Color.fromRGBO(235, 235, 235, 0.8)),
                                SizedBox(width: 20),
                                Text('Dashboard',
                                    style: TextStyle(
                                      color: Color.fromRGBO(235, 235, 235, 0.8),
                                      fontSize: 14,
                                    ))
                              ]),
                              Icon(Icons.chevron_right,
                                  color: Color.fromRGBO(235, 235, 235, 0.8)),
                            ]),
                      ),
                      TextButton(
                        onPressed: () {
                          displayUnimplementedError();
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.notifications_outlined,
                                    color: Color.fromRGBO(235, 235, 235, 0.8)),
                                SizedBox(width: 20),
                                Text('Notifications',
                                    style: TextStyle(
                                      color: Color.fromRGBO(235, 235, 235, 0.8),
                                      fontSize: 14,
                                    ))
                              ]),
                              Icon(Icons.chevron_right,
                                  color: Color.fromRGBO(235, 235, 235, 0.8)),
                            ]),
                      ),
                      SizedBox(height: 5),
                      Divider(height: 1, color: Color.fromRGBO(235, 235, 235, 0.2)),
                      SizedBox(height: 5),
                      TextButton(
                        onPressed: () {
                          displayUnimplementedError();
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.sms_failed_outlined,
                                    color: Color.fromRGBO(235, 235, 235, 0.8)),
                                SizedBox(width: 20),
                                Text('Send Feedback',
                                    style: TextStyle(
                                      color: Color.fromRGBO(235, 235, 235, 0.8),
                                      fontSize: 14,
                                    ))
                              ]),
                              Icon(Icons.chevron_right,
                                  color: Color.fromRGBO(235, 235, 235, 0.8)),
                            ]),
                      ),
                      TextButton(
                        onPressed: () {
                          displayUnimplementedError();
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.info_outlined,
                                    color: Color.fromRGBO(235, 235, 235, 0.8)),
                                SizedBox(width: 20),
                                Text('About Echo',
                                    style: TextStyle(
                                      color: Color.fromRGBO(235, 235, 235, 0.8),
                                      fontSize: 14,
                                    ))
                              ]),
                              Icon(Icons.chevron_right,
                                  color: Color.fromRGBO(235, 235, 235, 0.8)),
                            ]),
                      ),
                    ]),
                    )],
                ))),
      ),
    );
  }

  void displayUnimplementedError() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Feature coming soon! For the latest features, please update your app to the latest available version."),
    ));
  }

  void logoutUser(BuildContext context) async {
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

  AlertChangeStatus(){
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            color: Color.fromRGBO(32, 35, 43, 1),
            height: 260,
            child: Padding(
              padding: EdgeInsets.fromLTRB(22, 25, 22, 10),
              child: Column(
                children:[
                  Text("Set Status",
                      style: TextStyle(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                  )),
                  TextButton(
                    onPressed: () {
                      changeStatus('Online');
                      setState((){});
                      Navigator.pop(context);
                    },
                    child: Row(children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(102, 189, 80, 1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text('Online',
                          style: TextStyle(
                            color: Color.fromRGBO(235, 235, 235, 0.8),
                            fontSize: 14,
                          )
                      )
                    ]),
                  ),
                  TextButton(
                    onPressed: () {
                      changeStatus('Away');
                      setState((){});
                      Navigator.pop(context);
                    },
                    child: Row(children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(235, 188, 70, 1),
                                shape: BoxShape.circle,
                              ),
                          ),
                          Positioned(
                            bottom: 3,
                            right: 3,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(32, 35, 43, 1),
                                shape: BoxShape.circle,
                              ),
                            )
                          )
                        ]
                      ),
                      SizedBox(width: 20),
                      Text('Away',
                          style: TextStyle(
                            color: Color.fromRGBO(235, 235, 235, 0.8),
                            fontSize: 14,
                          )
                      )
                    ]),
                  ),
                  TextButton(
                    onPressed: () {
                      changeStatus('Do Not Disturb');
                      setState((){});
                      Navigator.pop(context);
                    },
                    child: Row(children: [
                      Stack(

                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(222, 72, 65, 1),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Positioned(
                                top: 5,
                                left: 2,
                                child: ClipRect(
                                    child: Container(
                                      width: 8,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(32, 35, 43, 1),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    )
                                )
                            ),
                          ]
                      ),
                      SizedBox(width: 20),
                      Text('Do Not Disturb',
                          style: TextStyle(
                            color: Color.fromRGBO(235, 235, 235, 0.8),
                            fontSize: 14,
                          )
                      )
                    ]),
                  ),
                  TextButton(
                    onPressed: () {
                      changeStatus('Offline');
                      setState((){});
                      Navigator.pop(context);
                    },
                    child: Row(children: [
                      Stack(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(195, 201, 208, 1),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Positioned(
                                top: 2,
                                left: 2,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(32, 35, 43, 1),
                                    shape: BoxShape.circle,
                                  ),
                                )
                            )
                          ]
                      ),
                      SizedBox(width: 20),
                      Text('Offline',
                          style: TextStyle(
                            color: Color.fromRGBO(235, 235, 235, 0.8),
                            fontSize: 14,
                          )
                      )
                    ]),
                  )
                ]
              )
            )
          );
        }
        );
  }

  getStatusColor(String status) {
    switch (status){
      case 'Online':
        return Color.fromRGBO(102, 189, 80, 1);
      case 'Away':
        return Color.fromRGBO(235, 188, 70, 1);
      case 'Do Not Disturb':
        return Color.fromRGBO(222, 72, 65, 1);
      case 'Offline':
        return Color.fromRGBO(195, 201, 208, 1);
      default:
        return Colors.transparent;
    }
  }

  Widget getStatusOverlay(String status){
    switch (status) {
      case 'Away':
        return Positioned(
          bottom: 13,
          right: 13,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
            color: Color.fromRGBO(25, 25, 32, 1),
            shape: BoxShape.circle,
            ),
          )
        );
      case 'Do Not Disturb':
        return Positioned(
            bottom: 15,
            right: 11,
            child: ClipRect(
              child: Container(
                width: 14,
                height: 6,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(25, 25, 32, 1),
                  shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                ),
              )
            )
        );
      case 'Offline':
        return Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Color.fromRGBO(25, 25, 32, 1),
                shape: BoxShape.circle,
              ),
            )
        );
      default:
        return SizedBox.shrink();
    }
  }

  void changeStatus(String status) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/${getUID()}");
    ref.update({
      "status": status,
    });
  }
}
