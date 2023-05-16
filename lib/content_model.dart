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
    description1: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    description2: "Excepteur sint occaecat cupidatat non proident.",
  ),
  PageContent(
    image: "lib/assets/images/onboarding/faster.png",
    title: "Faster",
    description1: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    description2: "Excepteur sint occaecat cupidatat non proident.",
  ),
  PageContent(
    image: "lib/assets/images/onboarding/clearer.png",
    title: "Clearer",
    description1: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    description2: "Excepteur sint occaecat cupidatat non proident.",
  )
];
