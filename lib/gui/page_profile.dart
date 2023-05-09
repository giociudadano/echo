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
                            hasProfilePicture ? SizedBox.shrink() :
                              ProfilePicture(
                                name: username,
                                radius: 50,
                                fontsize: 21,
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