part of main;

class AuthService {
  signInWithGoogle() async {
    bool newUserInitialized = false;
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken
    );

    var result = await FirebaseAuth.instance.signInWithCredential(credential);

    if (result.additionalUserInfo!.isNewUser) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if ((user != null) && (!newUserInitialized)) {
          String userID = user.uid;
          String displayName = user.displayName!;
          newUserInitialized = true;
          DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$userID");
          ref.update({
            "username": generateUsername(displayName),
            "displayName": displayName,
            "status": "Online",
          });
        }
      });
    }
    return result;
  }

  generateUsername(username) {
    while (true) {
      bool isDuplicate = false;
      final String randomInt =
      Random().nextInt(9999).toString().padLeft(4, '0');
      var newUsername = "$username#$randomInt";
      DatabaseReference ref = FirebaseDatabase.instance.ref().child("Users");
      ref.orderByChild("username").equalTo(newUsername).get().then((value) => {
        if (value.exists) {isDuplicate = true}
      });
      if (!isDuplicate) {
        return newUsername;
      }
    }
  }
}