import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pokemon_explorer/models/pokemon_model.dart';
import 'package:pokemon_explorer/services/api_service.dart';

class PokemonListProvider with ChangeNotifier {
  List<PokemonModel> _list = [];
  List<PokemonModel> _caughtlist = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _name = '';
  String _url = '';

  List<PokemonModel> get list => _list;
  List<PokemonModel> get caughtList => _caughtlist;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get name => _name;
  String? get url => _url;

  Future<void> setPokemon() async {
    _isLoading = true;
    notifyListeners();
    print("Fetching Pokémon...");

    try {
      List<PokemonModel> fetchedPokemon = await ApiService().getPokemon();
      _list = fetchedPokemon;
      _errorMessage = null;
      print("Fetched Pokémon: ${_list.length}");
    } catch (error) {
      _errorMessage = 'Failed to load Pokémon. Please try again.';
      print("Error fetching Pokémon: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  void catchPokemon(PokemonModel pokemon) {
    if (!_caughtlist.contains(pokemon)) {
      _caughtlist.add(pokemon);
      notifyListeners();
    }
  }
}
