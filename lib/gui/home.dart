part of main;

class Post {
  String title = "";
  String content = "";

  Post(this.title, this.content);
}

class HomePage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _inputTitle = TextEditingController();
  final _inputContent = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Text('Your Feed',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 110),
              /*
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: TextFormField(
                        controller: _inputTitle,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                          hintText: 'Enter title',
                        ),
                        validator: (String? value) {
                          return _verifyTitle(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: TextFormField(
                        controller: _inputContent,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Content',
                          hintText: 'Enter additional information here.',
                        ),
                        validator: (String? value) {
                          return _verifyContent(value);
                        },
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _writePost(
                                context, _inputTitle.text, _inputContent.text);
                          },
                          child: const Text('Write Data'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _logoutUser(context);
                          },
                          child: const Text('Log Out'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              */
             updatePosts(),
            ],
          ),
        ),
      ),
    );
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Logout Successful!"),
    ));
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => LoginPage()), (
        route) => false);
  }

  void _writePost(BuildContext context, title, content) {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Posts");
      ref.push().update({
        'title': title,
        'content': content,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Post has been submitted!"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "There was an error submitting your post. Please try again later."),
      ));
    }
  }

  _verifyTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }

  _verifyContent(String? value) {
    return null;
  }
}


class updatePosts extends StatefulWidget {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Posts');

  @override
  State createState() => updatePostsState();
}

class updatePostsState extends State<updatePosts> {
  List <Post> posts = [];

  @override
  void initState() {
    super.initState();

    widget.ref.onChildAdded.listen((event) {
      posts.add(
          Post(
              event.snapshot.child('title').value.toString(),
              event.snapshot.child('content').value.toString()
          )
      );
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build (BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int i) {
              return PostCard(posts[i].title, posts[i].content);
            },
          )
        )
    );
  }
}