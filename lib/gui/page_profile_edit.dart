part of main;

class ProfileEditPage extends StatefulWidget {
  String displayName = '', username = '';
  ProfileEditPage(this.displayName, this.username);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final GlobalKey<FormState> formEditProfileKey = GlobalKey<FormState>();
  bool hasProfilePicture = false, toRemoveProfilePicture = false;
  String UID = getUID();
  String? profilePicturePath;
  String profilePictureURL = '';
  final inputDisplayName = TextEditingController();
  final inputUsername = TextEditingController();

  @override
  void initState() {
    super.initState();
    getHasProfilePicture();
    inputDisplayName.text = widget.displayName;
    inputUsername.text = (widget.username).substring(0, widget.username.length-5);
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

  String? verifyDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a display name';
    }
    return null;
  }

  String? verifyUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
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
            child: Form(
              key: formEditProfileKey,
              child: ListView(
              children: [
                SizedBox(height: 20),
                Text("PROFILE PICTURE",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    AlertUpdateProfilePicture();
                  },
                  child: Center(
                    child: Stack(children: [
                      (hasProfilePicture)
                          ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            profilePictureURL,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ))
                          : ProfilePicture(
                        name: widget.username,
                        radius: 40,
                        fontsize: 21,
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          )),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Icon(Icons.edit_outlined, color: Colors.grey, size: 16),
                      ),
                    ]),
                  ),
                ),
                SizedBox(height: 30),
                Text("DISPLAY NAME",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: inputDisplayName,
                  decoration:
                  const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter a display name',
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(
                            235, 235, 235, 0.2),
                        fontSize: 14),
                    isDense: true,
                    filled: true,
                    fillColor: Color.fromRGBO(
                        22, 23, 27, 1),
                  ),
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(
                          235, 235, 235, 0.8)),
                  validator: (String? value) {
                    return verifyDisplayName(value);
                  },
                ),
                SizedBox(height: 20),
                Text("USERNAME",
                  style: TextStyle(
                    color: Color.fromRGBO(245, 245, 245, 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Stack(
                  children: [
                    TextFormField(
                      maxLength: 20,
                      controller: inputUsername,
                      decoration:
                      const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        hintText: 'Enter a username',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(
                                235, 235, 235, 0.2),
                            fontSize: 14),
                        isDense: true,
                        filled: true,
                        fillColor: Color.fromRGBO(
                            22, 23, 27, 1),
                      ),
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(
                              235, 235, 235, 0.8)),
                      validator: (String? value) {
                        return verifyUsername(value);
                      },
                    ),
                    Positioned(
                      right: 5,
                      top: 0,
                      child: Container(
                        color: Color.fromRGBO(22, 23, 27, 1),
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(widget.username.substring(widget.username.length-5),
                              style: TextStyle(color: Color.fromRGBO(235, 235, 235, 0.4)),
                            )
                        ),
                      )
                    ),

                      ],
                    ),
                SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: Color.fromRGBO(245, 245, 245, 0.8), width: 1.5),
                              )
                          ),
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel", style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(98, 112, 242, 1)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (formEditProfileKey.currentState!.validate()) {
                            editProfile(inputDisplayName.text, inputUsername.text, widget.username.substring(widget.username.length-5));
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Save',
                            style: TextStyle(
                                color: Colors.white)),
                      ),
                  ]
                )
              ]
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
                        name: widget.username,
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
                                  profilePicturePath = '${file.path}';
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
                                      profilePicturePath = '${file.path}';
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
                  child: Text("Save",
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

  void editProfile(String displayName, String username, String usernameDiscrim) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/${getUID()}");
    ref.update({
      'username': "$username$usernameDiscrim",
      'displayName': displayName,
    });
  }
}
