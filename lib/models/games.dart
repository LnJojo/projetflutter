class Game{
  final int id;
  final String image;
  final String name;
  final String price;
  final String editor;
  final String description;


  Game({required this.id, required this.image, required this.name, required this.editor, required this.price, required this.description});

  factory Game.fromJson(Map<String, dynamic> json){
    if(json['is_free']==false && json['price_overview'] == null){
      return Game(
        id: json['steam_appid'],
        image: json['header_image'],
        name: json['name'],
        editor: json['publishers'][0],
        price:"10",
        description: json['short_description']

      );
    }
    return Game(
        id: json['steam_appid'],
        image: json['header_image'],
        name: json['name'],
        editor: json['publishers'][0],
        price: "0",
        description: json['short_description']
    );
  }
}


class PopularGames{
  final int id;
  final int rang;

  PopularGames({required this.id, required this.rang});

  factory PopularGames.fromJson(Map<String, dynamic> json){
    return PopularGames(id: json['appid'], rang: json['rank']);
  }
}

class Review{

  final String review;
  final String author;
  final int rate;

  Review({required this.author, required this.review, required this.rate});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      author: json['author']['steamid'],
      review: json['review'],
      rate: json['votes_up'].clamp(0, 5),
    );
  }

}

