class Garbage {
  final String name;
  final String imageUrl;
  final bool? isImageAsset;
  const Garbage(
      {required this.name, required this.imageUrl, this.isImageAsset});
}

final List<Garbage> garbages = [
  const Garbage(
      name: "Canette",
      imageUrl:
          "https://upload.wikimedia.org/wikipedia/commons/6/6c/Tolkki20091027.jpg")
];
