import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_explorer/models/pokemon_model.dart';

class ApiService {
  static const String _apiUrl = "https://pokeapi.co/api/v2/pokemon?limit=20";

  Future<List<PokemonModel>> getPokemon() async {
    final response = await http.get(Uri.parse(_apiUrl));
    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> results = jsonData['results'];
      return results.map((pokemonJson) {
        String name = pokemonJson["name"];
        String url = pokemonJson["url"];

        final regex = RegExp(r'\/pokemon\/(\d+)\/$');
        final match = regex.firstMatch(url);
        final id = match != null ? match.group(1) : "0";

        // Construct Image URL
        String imageUrl =
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png";

        return PokemonModel(name: name, imageUrl: imageUrl);
      }).toList();
    } else {
      throw Exception('FAiled to load pokemon');
    }
  }
}
