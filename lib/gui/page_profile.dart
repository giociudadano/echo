part of main;

class ProfilePage extends StatelessWidget {

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 35, 43, 1),
      body: SafeArea(
        child: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                        child: ListView(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _logoutUser(context);
                              },
                              child: const Text('Log Out'),
                            ),
                          ],
                        )),
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