import 'package:flutter/material.dart';
import 'package:pokemon_explorer/provider/pokemon_list_provider.dart';
import 'package:provider/provider.dart';

class CaughtPokemonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Caught Pokémon')),
      body: Consumer<PokemonListProvider>(
        builder: (context, provider, child) {
          if (provider.caughtList.isEmpty) {
            return Center(child: Text('No Pokémon caught yet!'));
          }

          return ListView.builder(
            itemCount: provider.caughtList.length,
            itemBuilder: (context, index) {
              final pokemon = provider.caughtList[index];

              return ListTile(
                leading: Image.network(pokemon.imageUrl, width: 50, height: 50),
                title: Text(pokemon.name.toUpperCase()),
              );
            },
          );
        },
      ),
    );
  }
}
