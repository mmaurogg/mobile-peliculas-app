import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {

  // Cambiar a español
  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          //resul es lo que quiero regresar el show search
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return  Text('build Results');
  }

  Widget _emptyContainer(){
    return Container(
      child: Center(
        child: Icon( Icons.movie_creation_outlined, color:  Colors.black38, size: 100,),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if( query.isEmpty){
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    // ahorrar consumo de datos (cada que se unde un tecla hace peticion get)
    moviesProvider.getSuggestionsByQuery(query);
    
    //Cambio el timpo de widget para que pueda implementar el Stram
    //return FutureBuilder(
    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
        builder:(_, AsyncSnapshot<List<Movie>> snapshot){
          if (!snapshot.hasData) return _emptyContainer();

          final movies = snapshot.data!;

          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (_, index) => _MovieItem(movies[index])
          );
        },
    );
    
  }

}

class _MovieItem extends StatelessWidget {

  final Movie movie;

  const _MovieItem( this.movie );


  @override
  Widget build(BuildContext context) {

    movie.heroId = 'search-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text( movie.title ),
      subtitle: Text(movie.originalTitle),
      onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
    );
  }
}
