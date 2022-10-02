import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/widgets/widges.dart';
import 'package:provider/provider.dart';

class HomeScreen  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelicular en cines'),
        elevation: 0,
        actions: [IconButton(
            onPressed: () { },
            icon: Icon(Icons.search_off_outlined))],

      ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CardSwiper( movies: moviesProvider.onDisplayMovies ),
              MovieSlider(
                movies: moviesProvider.popularsMovies,
                title: 'Populares',
                onNextPage: () => moviesProvider.getPopularMovies(),
              ),
            ],
          ),
        ),
    );
  }
}
