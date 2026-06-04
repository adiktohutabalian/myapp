import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MovieCatalog(),
      ),
    );

class Movie {
  final String title, date;
  final double rating;

  const Movie(this.title, this.date, this.rating);
}

class MovieCatalog extends StatelessWidget {
  const MovieCatalog({super.key});

  static const _movies = [
    Movie('Inception', '2010-07-15', 8.4),
    Movie('Interstellar', '2014-11-07', 8.6),
    Movie('Tenet', '2020-08-22', 7.3),
    Movie('The Dark Knight Rises', '2012-07-16', 7.8),
    Movie('Avatar: The Way of Water', '2022-12-14', 7.6),
    Movie('dune', '2021-10-22', 8.2),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF0F0F5),
        appBar: AppBar(
          title: const Text('Movie Catalog'),
          backgroundColor: const Color(0xFFF0F0F5),
          elevation: 0,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _movies.length,
          itemBuilder: (_, i) => _MovieCard(_movies[i]),
        ),
      );
}

class _MovieCard extends StatelessWidget {
  final Movie movie;

  const _MovieCard(this.movie);

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.movie,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.date,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.rating}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}