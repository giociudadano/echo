part of main;


class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Color.fromRGBO(98, 112, 243, 1), // Navigation bar
            statusBarColor: Color.fromRGBO(98, 112, 243, 1),
          )
      ),
      backgroundColor: Color.fromRGBO(98, 112, 243, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnBoardingContent(
                    image: contents[index].image,
                    title: contents[index].title,
                    description1: contents[index].description1,
                    description2: contents[index].description2,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                  (index) => buildDot(index, context),
                ),
              ),
              Container(
                height: 60,
                margin: const EdgeInsets.all(40),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (currentIndex == contents.length - 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage()));
                    }
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  )),
                  child: Text(
                    currentIndex == contents.length - 1 ? "Continue" : "Next",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 5,
      width: currentIndex == index ? 12 : 5,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent(
      {Key? key,
      required this.image,
      required this.title,
      required this.description1,
      required this.description2})
      : super(key: key);

  final String image, title, description1, description2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Stack(alignment: const Alignment(0, 0.8), children: <Widget>[
          Image.asset(
            image,
            height: 300,
          ),
          Text(
            title,
            style: const TextStyle(
                fontFamily: 'Spotnik',
                fontWeight: FontWeight.w700,
                fontSize: 42,
                color: Color(0xFFFFFFFF)),
          ),
        ]),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          leading: Image.asset(
            "lib/assets/images/onboarding/verified.png",
          ),
          title: Text(
            description1,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          leading: Image.asset(
            "lib/assets/images/onboarding/verified.png",
          ),
          title: Text(
            description2,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
