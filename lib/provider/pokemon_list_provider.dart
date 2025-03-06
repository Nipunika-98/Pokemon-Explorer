import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pokemon_explorer/models/pokemon_model.dart';
import 'package:pokemon_explorer/services/api_service.dart';

class PokemonListProvider with ChangeNotifier {
  List<PokemonModel> _list = [];
  List<PokemonModel> _caughtList = [];
  List<PokemonModel> _filteredList = [];

  bool _isLoading = false;
  bool _isSearching = false;

  String? _errorMessage;

  // String _name = '';
  // String _url = '';

  // List<PokemonModel> get list => _list;
  List<PokemonModel> get list => _filteredList.isNotEmpty || _isSearching ? _filteredList : _list;
  List<PokemonModel> get caughtList => _caughtList;
  // List<PokemonModel> get filteredList => _filteredList;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // String? get name => _name;
  // String? get url => _url;

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
    if (!_caughtList.contains(pokemon)) {
      _caughtList.add(pokemon);
      notifyListeners();
    }
  }

  void clearCaughtPokemon() {
    _caughtList.clear();
    notifyListeners();
  }

  void searchPokemon(String query) {
    if (query.isEmpty) {
      _filteredList = [];
      _isSearching = false;
    } else {
      _filteredList =
          _list
              .where((pokemon) => pokemon.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
      _isSearching = true;
    }
    notifyListeners();
  }
}
