import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'likes.dart';
import 'wishlists.dart';
import '/models/games.dart';
import 'details.dart';
import 'recherche.dart';
import 'connexion.dart';
import 'package:flutterprojet/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  void _logout() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ConnexionScreen()),
              (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1A2025),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset("images/like.svg"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Likes()),
              );
            },
          ),
          IconButton(
            icon: SvgPicture.asset("images/whishlist.svg"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Wishlists()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1A2025),
        ),
        child: Column(
          children: [
            searchBar,
            GameBanner(),
            const SizedBox(height: 5),
            Flexible(child: ListGames())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        tooltip: 'Déconnexion',
        backgroundColor: const Color(0xFF1A2025),
        shape: const CircleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 3,
          ),
        ),

        child: const Icon(Icons.logout),
      ),
    );
  }

  Widget searchBar = const Searchbar();
}


class Searchbar extends StatefulWidget {
  const Searchbar({Key? key}) : super(key: key);


  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {

  final TextEditingController _searchController = TextEditingController();

  void _performSearch() {
    // Appeler la fonction pour récupérer les jeux via l'API
    String searchTerm = _searchController.text;
    // ...
    // Naviguer vers la page pour afficher les résultats de recherche
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Recherche(search: searchTerm)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2025),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(1),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Rechercher un jeu...",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            color: const Color(0xFF636AF6),
            onPressed: _performSearch,
          ),
        ],
      ),
    );
  }
}

class GameBanner extends StatelessWidget {
  const GameBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/details');
      },
      child: Container(
        height: 200,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/affiche.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Counter Strike\nGlobal Offensive',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/details');
                },
                child: const Text('En savoir plus'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListGames extends StatelessWidget {
  const ListGames({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Game>>(
      future: Api.getMostPlayedGames(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final gamesList = snapshot.data!;
          return ListView.builder(
            itemCount: gamesList.length,
            itemBuilder: (context, index) {
              final game = gamesList[index];
              return GameDisplay(game: game);
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Failed to load games'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class GameDisplay extends StatelessWidget {
  final Game game;
  const GameDisplay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: Container(
            height: 100,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    game.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        game.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Editeur: ${game.editor}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Prix: ${game.price}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF636AF6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Details(game: game)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                child: Center(
                  child: Text(
                    'En savoir plus',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



