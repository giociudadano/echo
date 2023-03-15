library main;

// Dart Libraries
import 'dart:async'; // Asynchronous Computing
import 'dart:math'; // Randomizers
import 'dart:ui';

// Flutter Libraries
import 'package:flutter/material.dart'; // Material Design
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'; // Date and Time Picker Widget
import 'package:multi_select_flutter/multi_select_flutter.dart'; // Item Selector
import 'package:flutter/foundation.dart';

// Firebase Libraries
import 'package:firebase_core/firebase_core.dart'; // Firebase Main
import 'package:firebase_auth/firebase_auth.dart'; // Authentication
import 'package:firebase_database/firebase_database.dart'; // Read and Write
import 'package:bullet/firebase_options.dart';

// Miscellaneous Libraries
import 'package:intl/intl.dart';

// Custom Objects
import 'objects/card_post.dart';
import 'objects/group_filter.dart';
import 'objects/card_group.dart';

part 'gui/login.dart';
part 'gui/signup.dart';
part 'gui/groups.dart';
part 'gui/home.dart';
part 'gui/debug.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bullet',
      theme: ThemeData(
        fontFamily: 'SF-Pro',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyAppPage(),
    );
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key});

  @override
  State <MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  bool isLoggedIn = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      isLoggedIn = (user != null);
      if (isLoggedIn){
        String username = await _getUsername();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Successfully logged in as $username"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:
          Text("Successfully logged out!")
        ));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = GroupsPage();
        break;
      case 2:
        page = DebugPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
          extendBody: true,
          body: Stack(
            children: [
              isLoggedIn ? page : LoginPage(),
              isLoggedIn ? AppNavigationBar() : const SizedBox.shrink(),
            ],
          ),
        );
  }

  AppNavigationBar(){
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              iconSize: 24,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.fromLTRB(40, 8, 0, 8),
                    child: Icon(Icons.home_outlined),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.groups_outlined),
                  label: 'Groups',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 40, 8),
                    child: Icon(Icons.anchor_outlined),
                  ),
                  label: 'Debug',
                ),
              ],
              currentIndex: selectedIndex,
              backgroundColor: Color.fromRGBO(22, 23, 27, 0.2),
              unselectedItemColor: const Color.fromRGBO(200, 200, 200, 0.8),
              selectedItemColor: const Color.fromRGBO(98, 112, 142, 1),
              onTap: (index){
                setState(() {
                  selectedIndex = index;
                });
              },
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),
        ),
      ),
    );
  }

  _getUsername() async {
    String userID = '';
    String username = 'Anonymous';
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userID = user.uid;
      DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$userID/username");
      DataSnapshot snapshot = await ref.get();
      username = snapshot.value.toString();
    }
    return username;
  }
}