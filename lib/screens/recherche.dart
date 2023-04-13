import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'details.dart';
import 'package:flutterprojet/api.dart';
import '/models/games.dart';
import 'accueil.dart';

class Recherche extends StatefulWidget {
  String search;

  Recherche({Key? key, required this.search}) : super(key: key);

  @override
  State<Recherche> createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {


  List<Game> gamesFound = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    Api.searchGame(widget.search).then((games) {
      setState(() {
        gamesFound = games;
        count = gamesFound.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController(text: widget.search);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1A2025),
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                "images/close.svg",
                height: 16,
                width: 16,
                color: Colors.white,
              ),
            ),
            const Text('Recherche'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              '$count résultat(s) trouvé(s)',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1A2025),
        ),
        child: FutureBuilder<List<Game>>(
          future: Api.searchGame(widget.search),
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
        ),
      ),
    );
  }
}
