import 'package:flutter/material.dart';
import 'package:flutter_movie_app/providers/movies_provider.dart';
import 'package:flutter_movie_app/search/search_delegate.dart';
import 'package:flutter_movie_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
              icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //TO-DO
            //CardSwiper
            CardSwipper(movies: moviesProvider.onDisplayMovies),
            //Movie list
            MovieSlider(
                movies: moviesProvider.popularMovies,
                onNextPage: () => moviesProvider.getPopularMovies()),
          ],
        ),
      ),
    );
  }
}
