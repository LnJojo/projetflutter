import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/models/games.dart';
import 'likes.dart';
import 'wishlists.dart';
import 'package:flutterprojet/api.dart';

class Details extends StatefulWidget {
  final Game game;

  const Details({required this.game, Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> with SingleTickerProviderStateMixin {
  bool isWished = false;
  bool isLiked = false;

  String scoreToStars(int score) {
    String star = '⭐️'; // caractère Unicode pour l'étoile
    String stars = '';
    for (int i = 0; i < score; i++) {
      stars += star;
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du jeu'),
        backgroundColor: const Color(0xFF1A2025),
        actions: [
          IconButton(
            icon: isLiked ? SvgPicture.asset("images/like_full.svg") : SvgPicture.asset("images/like.svg"),
            onPressed: () async {
              setState(() {
                isLiked = !isLiked;
              });

            },
          ),
          IconButton(
            icon: isWished ? SvgPicture.asset("images/whishlist_full.svg") : SvgPicture.asset("images/whishlist.svg"),
            onPressed: () {
              setState(() {
                isWished = !isWished;
              });
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 280,
              decoration: const BoxDecoration(
                color: Color(0xff1A2025),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.game.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A2025),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.game.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Editeur: ${widget.game.editor}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: const Color(0xFF1A2025),
                    child: const TabBar(
                        tabs: [
                          Tab(text: "Description"),
                          Tab(text: "Avis")
                        ]
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      children: [
                        Container(
                          color : const Color(0xFF1A2025),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              widget.game.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color : const Color(0xFF1A2025),
                          child: FutureBuilder(
                            future: Api.getSteamReviews(widget.game.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final reviews = snapshot.data;
                                return ListView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: reviews?.length,
                                  itemBuilder: (context, index) {
                                    final review = reviews![index];

                                    return Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2D3640),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${review.author}',
                                                    style: TextStyle(color : Colors.white),
                                                  ),
                                                ),
                                                Text(
                                                  '${scoreToStars(review.rate)}',
                                                  style: TextStyle(color : Colors.white),
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(
                                              review.review,
                                              style: TextStyle(color : Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8)
                                      ],
                                    );

                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Erreur lors de la récupération des avis'));
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                          ),
                        )


                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
