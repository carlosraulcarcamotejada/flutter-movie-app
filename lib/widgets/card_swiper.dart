import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import '../models/movie.dart';

class CardSwipper extends StatelessWidget {
  final List<Movie> movies;
  const CardSwipper({super.key, required this.movies});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Swiper(
          itemCount: movies.length,
          layout: SwiperLayout.STACK,
          itemWidth: size.width * 0.6,
          itemHeight: size.height * 0.5,
          itemBuilder: (_, int index) {
            final movie = movies[index];
            movie.heroId = 'swiper-${movie.id}';

            return GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, 'details', arguments: movie),
              child: Hero(
                tag: movie.heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: const AssetImage("assets/no-image.jpg"),
                    image: NetworkImage(movie.fullPosterImg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
