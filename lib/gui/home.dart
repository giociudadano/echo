part of main;

class Post {
  String title = "";
  String content = "";
  String userID = "";
  String username = "";

  Post(this.title, this.content, this.userID, this.username);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(28, 5, 28, 10),
                  child: Text('For You',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(22, 15, 60, 15),
                    hintText: 'Search cards',
                    filled: true,
                    fillColor: Color.fromRGBO(233, 235, 247, 1),
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 45),
             updatePosts(),
            ],
          ),
        ),
      ),
    );
  }
}


class updatePosts extends StatefulWidget {
  DatabaseReference ref = FirebaseDatabase.instance.ref('Posts');

  updatePosts({super.key});

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
              event.snapshot.child('content').value.toString(),
              event.snapshot.child('userID').value.toString(),
              event.snapshot.child('username').value.toString(),
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
              return PostCard(posts[i].title, posts[i].content, posts[i].username);
            },
          )
        )
    );
  }
}