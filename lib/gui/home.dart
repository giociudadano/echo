part of main;

class Post {
  String title = "";
  String content = "";

  Post(this.title, this.content);
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
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Text('Threads',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
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