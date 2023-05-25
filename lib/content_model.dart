class PageContent {
  final String image, title, description1, description2;

  PageContent(
      {required this.image,
      required this.title,
      required this.description1,
      required this.description2});
}

final List<PageContent> contents = [
  PageContent(
    image: "lib/assets/images/onboarding/louder.png",
    title: "Louder",
    description1: "all class announcements in one app",
    description2: "contents are easy to spot and read",
  ),
  PageContent(
    image: "lib/assets/images/onboarding/faster.png",
    title: "Faster",
    description1: "posting is done quickly through a form",
    description2: "announcements may be sent to multiple groups at once",
  ),
  PageContent(
    image: "lib/assets/images/onboarding/clearer.png",
    title: "Clearer",
    description1: "groups strictly contain announcements",
    description2: "information are organized and presented in chunks",
  )
];
