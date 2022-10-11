import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final Function onNextPage;

  const MovieSlider({
    super.key,
    required this.movies,
    this.title,
    required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  // Esto permite en el inicio montar un listener
  final ScrollController scrollController = new ScrollController();

  //ciclos de vida de los widgets
  //El dispose va al inicio
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {

      // maxima extension del scroll
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500){
        widget.onNextPage();
      }
    });
  }

  //El dispose va a lo ultimo
  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    width: double.infinity,
    height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if(widget.title != null)
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(widget.title!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
          ),

          SizedBox(height: 10,),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
                itemCount: widget.movies.length,
                itemBuilder: (_, index) => _MoviePoster(movie: widget.movies[index], heroId: '${widget.title}-$index-${widget.movies[index].id}'),
            ),
          ),

        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {

  final Movie movie;
  final String heroId;

  const _MoviePoster({super.key, required this.movie, required this.heroId});

  @override
  Widget build(BuildContext context) {

    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [

          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(height: 5,),

          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ],
      ),

    );
  }
}
