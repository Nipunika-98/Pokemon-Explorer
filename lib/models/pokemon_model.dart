class PokemonModel {
  final String name;
  final String imageUrl;

  PokemonModel({required this.name, required this.imageUrl});

  factory PokemonModel.fromJson(String name, String imageUrl) {
    return PokemonModel(name: name, imageUrl: imageUrl);
  }
}
