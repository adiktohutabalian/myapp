import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MovieCatalog(),
      ),
    );

class Movie {
  final String judul, date;
  final double rating;

  const Movie(this.judul, this.date, this.rating);
}

class MovieCatalog extends StatelessWidget {
  const MovieCatalog({super.key});

  static const _movies = [
    Movie('Swallowed Star', '2025', 4.5),
    Movie('Renegade Immortal', '2024', 4.0),
    Movie('The Great Ruler', '2023', 4.8),
    Movie('Ling Cage', '2022', 4.7),
    Movie('The Last Human', '2021', 4.6),
    Movie('The Legendary Moonlight Sculptor', '2020', 4.9),
    Movie('The Desolate Era', '2019', 4.4),
    Movie('The Strongest System', '2018', 4.3),
    Movie('The Portal of Wonderland', '2017', 4.2),
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
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [

              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.movie, color: Colors.grey, size: 32),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.judul,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,         
                      overflow: TextOverflow.ellipsis,
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
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${movie.rating}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}