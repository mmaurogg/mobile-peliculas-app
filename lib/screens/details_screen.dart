import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/widgets/casting_cards.dart';

class DetailsScreen  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    
    print(movie.title);
    
    return Scaffold(
      // custom scroll view trabaja con slivers
      // Slives son widgets con contenido preprogrmado
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie),
          //version de columna en sliver
          SliverList(
              delegate: SliverChildListDelegate([
                _PosterAndTitle(movie),
                _Overview(movie),
                CastingCards( movie.id )
              ]),
          )

        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomAppBar(this.movie);

  @override
  Widget build(BuildContext context) {
    // controir un appbar y controlarle el alto y ancho
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          color: Colors.black12,
          child: Text(movie.title,
          style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),

      ),

    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle(this.movie);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(movie.fullPosterImg),
              height: 150,
            ),
          ),
          
          SizedBox(width: 20),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  movie.title,
                  style: textTheme.headline5, overflow: TextOverflow.ellipsis, maxLines: 2,),

                Text(movie.originalTitle,
                  style: textTheme.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 2,),

                  Row(
                    children: [
                      Icon(Icons.star_outline, size: 15, color: Colors.grey,),
                      Text('${movie.voteAverage}', style: textTheme.caption,)
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {

  final Movie movie;

  const _Overview(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text( movie.overview,
      style: Theme.of(context).textTheme.subtitle1,),

    );
  }
}

