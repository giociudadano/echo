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

  @override
  void initState() {
    getHasProfilePicture();
    getUsername();
  }

  void getHasProfilePicture() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$UID/profilePicture");
    ref.onChildChanged.listen((event) async {
      if (event.snapshot != null){
        setState((){
          hasProfilePicture = true;
        });
      }
    });
  }

  void getUsername() async {
    DataSnapshot snapshot = await (FirebaseDatabase.instance.ref("Users/$UID/username")).get();
    setState((){
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
                    const SizedBox(height: 20),
                              GestureDetector(
                                onTap: (){
                                  AlertUpdateProfilePicture();
                                },
                                child: hasProfilePicture ? SizedBox.shrink() : ProfilePicture(
                                  name: username,
                                  radius: 50,
                                  fontsize: 21,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text("$username",
                                  style: TextStyle(
                                    color: Color.fromRGBO(245, 245, 245, 1),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  )
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                              style: ButtonStyle(
                                  minimumSize: MaterialStatePropertyAll<Size>(Size.fromHeight(40)),
                                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                      )
                                  )
                              ),
                              onPressed: () {
                                _logoutUser(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text('Log Out',
                                  style: TextStyle(
                                    color: Color.fromRGBO(235, 235, 235, 0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                  ],
                ))),
      ),
    );
  }

  void AlertUpdateProfilePicture(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: Icon(Icons.account_circle_outlined, color: Color.fromRGBO(98, 112, 242, 1), size: 32),
            backgroundColor: Color.fromRGBO(32, 35, 43, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text("Update Profile Picture",
              style: TextStyle(
                color: Color.fromRGBO(245, 245, 245, 1),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(34, 50, 69, 1),
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          height: 70,
                          width: 70,
                          child: IconButton(
                            icon: Icon(Icons.photo_library),
                            color: Color.fromRGBO(235, 235, 235, 0.8),
                            onPressed: () {
                              print("Clicked Button: Upload from Gallery");
                            }
                          )
                        ),
                        Text("Gallery", style: TextStyle(color: Color.fromRGBO(235, 235, 235, 0.8)))
                      ]
                    ),
                    SizedBox(width: 20),
                    Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(34, 50, 69, 1),
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              height: 70,
                              width: 70,
                              child: IconButton(
                                  icon: Icon(Icons.photo_camera),
                                  color: Color.fromRGBO(235, 235, 235, 0.8),
                                  onPressed: () {
                                    print("Clicked Button: Upload from Camera");
                                  }
                              )
                          ),
                          Text("Camera", style: TextStyle(color: Color.fromRGBO(235, 235, 235, 0.8)))
                        ]
                    ),
                  ]
                )
              ]
            ),
            actions: [
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
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromRGBO(92, 112, 242, 1)
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )
                    ),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("Save Picture", style: TextStyle(color: Color.fromRGBO(245, 245, 245, 0.8))),
                ),
              ],
          );
        }
    );
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