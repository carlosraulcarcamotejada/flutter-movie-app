import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/helpers/debouncer.dart';
import 'package:flutter_movie_app/models/models.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier {
  final String _base_url = 'api.themoviedb.org';
  final String _api_key = '38043268c7cea881093e217eb9c98d38';
  final String _segmentOnPlaying = '3/movie/now_playing';
  final String _segmentPopular = '3/movie/popular';
  final String _language = 'en-US';
  int _pageOnPlaying = 0;
  int _pagePopular = 0;

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> movieCast = {};

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }
  //================== get json from end-point =======================
  Future<Map<String, dynamic>> _getJsonData(String segment,
      [int page = 1]) async {
    final url = Uri.https(_base_url, segment,
        {'api_key': _api_key, 'language': _language, 'page': page.toString()});

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(response.body);
    return decodedData;
  }

  //================== get on display movies =======================
  getOnDisplayMovies() async {
    _pageOnPlaying++;
    final jsonData = await _getJsonData(_segmentOnPlaying, _pageOnPlaying);
    final nowPLayingResponse = NowPLayingResponse.fromJson(jsonData);
    onDisplayMovies = [...onDisplayMovies, ...nowPLayingResponse.results];
    notifyListeners(); //To render again the widgets
  }

  //================== get the popular movies ===================
  getPopularMovies() async {
    _pagePopular++;
    final jsonData = await _getJsonData(_segmentPopular, _pagePopular);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  //==================   To get a movie cast ======================
  Future<List<Cast>> getMovieCast(int movieId) async {
    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;
    final jsonData =
        await _getJsonData('3/movie/$movieId/credits', _pageOnPlaying);
    final creditResponse = CreditResponse.fromJson(jsonData);

    movieCast[movieId] = creditResponse.cast;

    return creditResponse.cast;
  }

  //================== get the result of search a movie ==========
  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_base_url, '3/search/movie',
        {'api_key': _api_key, 'language': _language, 'query': query});

    final response = await http.get(url);
    //final Map<String, dynamic> decodedData = json.decode(response.body);
    final searchResponse = SearchResponse.fromRawJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) async {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await this.searchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((value) => timer.cancel());
  }
}
