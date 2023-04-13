import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/games.dart';

class Api {
  static Future<List<Game>> getMostPlayedGames() async {
    // Récupération des jeux les plus populaires
    final response = await http.get(Uri.parse(
        'https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/'));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body)['response']['ranks'];
      final gamePopular = List<PopularGames>.from(
          jsonResponse.map((json) => PopularGames.fromJson(json)));
      final List<Game> games = [];

      for (final game in gamePopular.take(30)) {
        final gameId = game.id;
        final gameDetailsResponse = await http.get(Uri.parse(
            'https://store.steampowered.com/api/appdetails?appids=$gameId'));
        final gameDetailsJson = jsonDecode(gameDetailsResponse.body)['$gameId'];
        if (gameDetailsJson != null && gameDetailsJson['data'] != null) {
          final gameFinal = Game.fromJson(gameDetailsJson['data']);
          games.add(gameFinal);
        }
        //final gameDetails = gameDetailsJson[gameId]['data'];
      }

      return games;
    } else {
      throw Exception('Failed to load games');
    }
  }

  static Future<List<Game>> searchGame(String query) async {
    final response = await http
        .get(Uri.parse('https://steamcommunity.com/actions/SearchApps/$query'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<String> appIds = List<String>.from(
          jsonResponse.map((game) => game['appid'] as String));
      final List<Game> games = [];

      for (final gameId in appIds) {
        print(gameId);
        final gameDetailsResponse = await http.get(Uri.parse(
            'https://store.steampowered.com/api/appdetails?appids=$gameId'));
        final gameDetailsJson = jsonDecode(gameDetailsResponse.body)['$gameId'];
        if (gameDetailsJson != null && gameDetailsJson['data'] != null) {
          final gameFinal = Game.fromJson(gameDetailsJson['data']);
          games.add(gameFinal);
        }
        //final gameDetails = gameDetailsJson[gameId]['data'];
      }

      return games;
    } else {
      throw Exception('Failed to load games');
    }
  }

  static Future<List<Review>> getSteamReviews(int appId) async {
    final response = await http.get(
        Uri.parse('https://store.steampowered.com/appreviews/$appId?json=1'));

    if (response.statusCode == 200) {
      final jsonReviews = json.decode(response.body);
      final reviews = (jsonReviews['reviews'] as List)
          .map((r) => Review.fromJson(r))
          .toList();
      return reviews;
    } else {
      throw Exception('Failed to load game reviews');
    }
  }
}
