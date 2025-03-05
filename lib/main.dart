import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pokemon_explorer/provider/pokemon_list_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    // Call setPokemon after the current build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PokemonListProvider>(context, listen: false).setPokemon();
    });

    return Scaffold(
      appBar: AppBar(title: Text('Pokémon Explorer')),
      body: Consumer<PokemonListProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          if (provider.list.isEmpty) {
            return Center(child: Text('No Pokémon found!'));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: provider.list.length,
            itemBuilder: (context, index) {
              final pokemon = provider.list[index];
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(pokemon.imageUrl, height: 80),
                    SizedBox(height: 8),
                    Text(pokemon.name),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<PokemonListProvider>(
                          context,
                          listen: false,
                        ).catchPokemon(pokemon);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("${pokemon.name} caught!")));
                      },
                      child: Text('Catch'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
