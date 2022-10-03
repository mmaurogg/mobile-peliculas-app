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

  //Mapeamos el id d ela pelicula y los actores que tiene
  Map <int, List<Cast>> movieCast = {};

  int _popularPage = 0;

  MoviesProvider(){
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future <String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });

    // esto es lo que hace la peticion http
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

  Future<List<Cast>> getMovieCast(int movieId) async {

    //Verificamos que el cast no se encuentre ya en memoria
    if ( movieCast.containsKey(movieId)) return movieCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditresponse = CreditsResponse.fromJson((jsonData));

    movieCast[movieId] = creditresponse.cast;

    return creditresponse.cast;
  }
  Future<List<Movie>> searchMovie( String query) async {

    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    final response = await http.get(url);
    final searchMoviesResponse = SearchMovieResponse.fromJson(response.body);

    return searchMoviesResponse.results;
  }
}


