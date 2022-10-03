import 'package:flutter/material.dart';

class MovieSearchDelegate extends SearchDelegate {

  // Cambiar a español
  @override
  // TODO: implement searchFieldLabel
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

  @override
  Widget buildSuggestions(BuildContext context) {

    if( query.isEmpty){
      return Container(
        child: Center(
          child: Icon( Icons.movie_creation_outlined, color:  Colors.black38, size: 100,),
        ),
      );
    }

    return Container();
  }

}