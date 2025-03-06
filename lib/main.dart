import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pokemon_explorer/provider/pokemon_list_provider.dart';
import 'package:pokemon_explorer/screen/caught_pokemon_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => PokemonListProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PokemonListScreen(),
    );
  }
}

class PokemonListScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PokemonListProvider>(context, listen: false).setPokemon();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pokémon Explorer',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 1.2),
        ),
        backgroundColor: const Color.fromARGB(255, 196, 189, 124),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CaughtPokemonScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 114, 114, 111),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(31, 162, 54, 54),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Pokemon..",
                  prefixIcon: Icon(Icons.search, color: const Color.fromARGB(255, 35, 33, 39)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 201, 205, 150),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
                onChanged: (query) {
                  Provider.of<PokemonListProvider>(context, listen: false).searchPokemon(query);
                },
              ),
            ),
          ),
          Expanded(
            child: Consumer<PokemonListProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: const Color.fromARGB(255, 198, 227, 33),
                    ),
                  );
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Text(
                      provider.errorMessage!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  );
                }

                if (provider.list.isEmpty) {
                  return Center(
                    child: Text(
                      'No Pokémon found!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: provider.list.length,
                    itemBuilder: (context, index) {
                      final pokemon = provider.list[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 6,
                        shadowColor: Colors.deepPurpleAccent.shade400,

                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [Colors.purple.shade100, Colors.deepPurple.shade200],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(pokemon.imageUrl, height: 90),
                              SizedBox(height: 10),
                              Text(
                                pokemon.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 74, 72, 78),
                                ),
                              ),
                              // SizedBox(height: 5),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 237, 236, 240),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                onPressed: () {
                                  Provider.of<PokemonListProvider>(
                                    context,
                                    listen: false,
                                  ).catchPokemon(pokemon);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${pokemon.name} caught!",
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      backgroundColor: const Color.fromARGB(255, 190, 154, 252),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Catch',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
