enum MyThemeMode {
  light,
  dark,
}

enum UserKarma {
  comment(1),
  textPost(3),
  linkPost(3),
  imagePost(3),
  awardPost(5),
  deletePost(-1);

  final int karma;
  const UserKarma(this.karma);
}
