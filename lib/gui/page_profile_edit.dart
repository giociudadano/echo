part of main;

class ProfileEditPage extends StatefulWidget {
  ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  bool hasProfilePicture = false, toRemoveProfilePicture = false;
  String UID = getUID();
  String username = '';
  String displayName = '';
  String? profilePicturePath;
  String profilePictureURL = '';

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
    DataSnapshot snapshot =
        await (FirebaseDatabase.instance.ref("Users/$UID/username")).get();
    String username = snapshot.value.toString();
    snapshot =
        await (FirebaseDatabase.instance.ref("Users/$UID/displayName")).get();
    String displayName = snapshot.value.toString();
    setState(() {
      this.username = username;
      this.displayName = displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Color.fromRGBO(32, 35, 43, 1), // Navigation bar
            statusBarColor: Colors.black,
          ),
          iconTheme: IconThemeData(
            color: Color.fromRGBO(235, 235, 235, 1), //change your color here
          ),
          title: Text("Edit Profile",
            style: TextStyle(
                color: Color.fromRGBO(235, 235, 235, 1),
                fontWeight: FontWeight.w600,
                fontSize: 16,
            ),
          ),
          backgroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromRGBO(32, 35, 43, 1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: GestureDetector(
              onTap: () {
                AlertUpdateProfilePicture();
              },
              child: (hasProfilePicture)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        profilePictureURL,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ))
                  : ProfilePicture(
                      name: username,
                      radius: 50,
                      fontsize: 21,
                    ),
            ),
          ),
        ),
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
                (profilePicturePath == null)
                    ? ProfilePicture(
                        name: username,
                        radius: 40,
                        fontsize: 21,
                        img: (hasProfilePicture && !toRemoveProfilePicture)
                            ? profilePictureURL
                            : null,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.file(
                          File(profilePicturePath!),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )),
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
                              XFile? file = await imagePicker.pickImage(
                                  source: ImageSource.gallery);
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
                                  setState(() {
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
                    setState(() {
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
    if (toRemoveProfilePicture) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("Users/$UID/profilePicture");
      ref.remove();
      if (mounted) {
        setState(() {
          hasProfilePicture = false;
          profilePicturePath = null;
        });
      }
      return;
    }
    if (profilePicturePath != null) {
      Reference ref = FirebaseStorage.instance.ref('ProfilePics/$UID');
      ref.putFile(File(profilePicturePath!));
      DatabaseReference ref2 =
          FirebaseDatabase.instance.ref("Users/$UID/profilePicture");
      String downloadURL = await ref.getDownloadURL();
      ref2.update({
        'url': downloadURL,
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });
      if (mounted) {
        setState(() {
          debugPrint('Uploaded file: $downloadURL');
          profilePictureURL = downloadURL;
          hasProfilePicture = true;
          profilePicturePath = null;
        });
      }
    }
    return;
  }

  void displayUnimplementedError() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          "Feature coming soon! For the latest features, please update your app to the latest available version."),
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
}
