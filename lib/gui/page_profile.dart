part of main;

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool hasProfilePicture = false, toRemoveProfilePicture = false;
  String UID = getUID();
  String username = '';
  String? profilePicturePath;
  String profilePictureURL = '';

  @override
  void initState() {
    super.initState();
    getHasProfilePicture();
    getUsername();
  }

  void getHasProfilePicture() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$UID/profilePicture");
    DataSnapshot snapshot = await ref.get();
    setState((){
      hasProfilePicture = (snapshot.value != null);
      if (hasProfilePicture){
        profilePictureURL = snapshot.child("url").value.toString();
      }
    });
  }

  void getUsername() async {
    DataSnapshot snapshot =
        await (FirebaseDatabase.instance.ref("Users/$UID/username")).get();
    setState(() {
      username = snapshot.value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 35, 43, 1),
      body: SafeArea(
        child: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      color: Color.fromRGBO(22, 22, 22, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            AlertUpdateProfilePicture();
                          },
                          child: Stack(
                              children: [(hasProfilePicture) ?
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(profilePictureURL,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                )
                              : ProfilePicture(
                                  name: username,
                                  radius: 50,
                                  fontsize: 21,
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
                                  )
                                ),
                                Positioned(
                                    bottom: 7,
                                    right: 7,
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                )
                              ]
                            ),
                        ),
                        SizedBox(width: 25),
                        Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[

                            Stack(
                              clipBehavior: Clip.none,
                              children:[
                                Text("Aaron Aardvark",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color.fromRGBO(245, 245, 245, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22,
                                    )
                                ),
                                Positioned(
                                  top: 28,
                                  child: Text(username,
                                      style: TextStyle(
                                        color: Color.fromRGBO(245, 245, 245, 0.8),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      )
                                  ),
                                )
                              ]
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<Color>(const Color.fromRGBO(98, 112, 242, 1)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ))),
                              onPressed: () {  },
                                child: Text(
                                  '    Edit Profile    ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(235, 235, 235, 0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ]
                        )
                        )
                      ]
                    ),
                      )
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () => _logoutUser(context),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Row(
                          children: [
                            Icon(Icons.logout_outlined, color: Color.fromRGBO(255, 167, 167, 1)),
                            SizedBox(width: 20),
                            Text('Log Out',
                                style: TextStyle(
                                  color: Color.fromRGBO(235, 235, 235, 0.8),
                                  fontSize: 14,
                                )
                            )
                          ]
                        ),
                        Icon(Icons.chevron_right, color: Color.fromRGBO(235, 235, 235, 0.8)),
                      ]
                    ),
                  ),
                  ],
                ))),
      ),
    );
  }

  void AlertUpdateProfilePicture() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              icon: Icon(Icons.account_circle_outlined,
                  color: Color.fromRGBO(98, 112, 242, 1), size: 32),
              backgroundColor: Color.fromRGBO(32, 35, 43, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                "Update Profile Picture",
                style: TextStyle(
                  color: Color.fromRGBO(245, 245, 245, 1),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  "PREVIEW",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.6),
                    fontSize: 11,
                    letterSpacing: 2.5,
                  ),
                ),
                SizedBox(height: 10),
                (profilePicturePath == null) ?
                ProfilePicture(
                  name: username,
                  radius: 40,
                  fontsize: 21,
                  img: (hasProfilePicture && !toRemoveProfilePicture) ? profilePictureURL : null,
                ) : ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.file(File(profilePicturePath!),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                ),
                SizedBox(height: 20),
                Text(
                  "SELECT SOURCE",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.6),
                    fontSize: 11,
                    letterSpacing: 2.5,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(34, 50, 69, 1),
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            height: 70,
                            width: 70,
                            child: IconButton(
                                icon: Icon(Icons.photo_library_outlined),
                                color: Color.fromRGBO(235, 235, 235, 0.8),
                                onPressed: () async {
                                  ImagePicker imagePicker = ImagePicker();
                                  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                                  setState(() {
                                    if (file != null) {
                                      profilePicturePath = '${file?.path}';
                                    }
                                  });
                                },
                            ),
                            ),
                        Text("Gallery",
                            style: TextStyle(
                                color: Color.fromRGBO(235, 235, 235, 0.8)))
                      ]),
                      SizedBox(width: 10),
                      Column(children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(34, 50, 69, 1),
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            height: 70,
                            width: 70,
                            child: IconButton(
                                icon: Icon(Icons.photo_camera_outlined),
                                color: Color.fromRGBO(235, 235, 235, 0.8),
                                onPressed: () async {
                                  ImagePicker imagePicker = ImagePicker();
                                  XFile? file = await imagePicker.pickImage(
                                      source: ImageSource.camera);
                                  setState(() {
                                    if (file != null) {
                                      profilePicturePath = '${file?.path}';
                                    }
                                  });
                                  print('[DEBUG]: ${file?.path}');
                                })),
                        Text("Camera",
                            style: TextStyle(
                                color: Color.fromRGBO(235, 235, 235, 0.8)))
                      ]),
                      SizedBox(width: 10),
                      Column(children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(34, 50, 69, 1),
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                            height: 70,
                            width: 70,
                            child: IconButton(
                                icon: Icon(Icons.close_outlined),
                                color: Color.fromRGBO(235, 235, 235, 0.8),
                                onPressed: () async {
                                  setState((){
                                    profilePicturePath = null;
                                    toRemoveProfilePicture = true;
                                  });
                                })),
                        Text("Remove",
                            style: TextStyle(
                                color: Color.fromRGBO(235, 235, 235, 0.8)))
                      ]),
                    ])
              ]),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                          color: Color.fromRGBO(245, 245, 245, 0.8),
                          width: 1.5),
                    )),
                  ),
                  onPressed: () {
                    setState((){
                      profilePicturePath = null;
                      toRemoveProfilePicture = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel",
                      style:
                          TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromRGBO(92, 112, 242, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    )),
                  ),
                  onPressed: () async {
                    await changeProfilePicture();
                    Navigator.of(context).pop();
                  },
                  child: Text("Save Picture",
                      style:
                          TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
                ),
              ],
            );
          });
        });
  }

  changeProfilePicture() async {
    if (toRemoveProfilePicture){
      DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$UID/profilePicture");
      ref.remove();
      if (mounted){
        setState((){
          hasProfilePicture = false;
          profilePicturePath = null;
        });
      }
      return;
    }
    if (profilePicturePath != null) {
      Reference ref = FirebaseStorage.instance.ref('ProfilePics/$UID');
      ref.putFile(File(profilePicturePath!));
      DatabaseReference ref2 = FirebaseDatabase.instance.ref("Users/$UID/profilePicture");
      String downloadURL = await ref.getDownloadURL();
      ref2.update({
        'url': downloadURL,
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });
      if (mounted){
        setState((){
          debugPrint('Uploaded file: $downloadURL');
          profilePictureURL = downloadURL;
          hasProfilePicture = true;
          profilePicturePath = null;
        });
      }
    }
    return;
  }
}

void _logoutUser(BuildContext context) async {
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
