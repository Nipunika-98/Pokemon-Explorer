import 'package:flutter/material.dart';
import 'package:pokemon_explorer/provider/pokemon_list_provider.dart';
import 'package:provider/provider.dart';

class CaughtPokemonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caught Pokémon', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 237, 174, 174),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: const Color.fromARGB(255, 218, 37, 37)),
            onPressed: () {
              Provider.of<PokemonListProvider>(context, listen: false).clearCaughtPokemon();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All caught Pokémon have been released!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 114, 114, 111),
      body: Consumer<PokemonListProvider>(
        builder: (context, provider, child) {
          if (provider.caughtList.isEmpty) {
            return Center(
              child: Text(
                'No Pokémon caught yet!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: provider.caughtList.length,
              itemBuilder: (context, index) {
                final pokemon = provider.caughtList[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            pokemon.imageUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          pokemon.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 74, 72, 78),
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
    );
  }
}
