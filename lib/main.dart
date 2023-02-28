library main;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:bullet/firebase_options.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'objects/PostCard.dart';
import 'package:intl/intl.dart';

part 'gui/login.dart';
part 'gui/signup.dart';
part 'gui/home.dart';
part 'gui/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  runApp(MyApp());
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
      home: MyAppPage(),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
          Text("Successfully logged in as $username")
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
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
        page = ProfilePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: isLoggedIn ? page : LoginPage(),
      bottomNavigationBar: isLoggedIn ? AppNavigationBar() : SizedBox.shrink(),
    );
  }

  AppNavigationBar(){
    return BottomNavigationBar(
      iconSize: 28,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      unselectedItemColor: Color.fromRGBO(70, 70, 70, 1),
      selectedItemColor: Color.fromRGBO(100, 100, 100, 1),
      onTap: (index){
        setState(() {
          selectedIndex = index;
        });
      },
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