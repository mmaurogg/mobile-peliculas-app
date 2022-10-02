import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/models/models.dart';

// Para que pueda ser un proveedor debe esctender de la siguiente clase:
class MoviesProvider extends ChangeNotifier {

  String _apiKey = '2043ac3da437771bb8adb14024c5a4e7';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularsMovies = [];

  int _popularPage = 0;

  MoviesProvider(){
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future <String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    // el siguiente paso es mapeado por el model now_playing
    //final Map<String, dynamic> decodeData = json.decode(response.body);

    onDisplayMovies = nowPlayingResponse.results;

    // decirle cuando hubo un cambio a los widgets
    notifyListeners();
  }

  getPopularMovies() async {

    _popularPage ++;

    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularsMovies = [...popularsMovies, ...popularResponse.results];
    notifyListeners();
  }


}


