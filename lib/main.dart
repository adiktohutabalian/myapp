import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MovieCatalog(),
      ),
    );

class Movie {
  final String title, date, genre, description;
  final double rating;
  bool isFavorite;

  Movie(
    this.title,
    this.date,
    this.rating, {
    this.genre = 'Animation',
    this.description = 'No description available.',
    this.isFavorite = false,
  });
}

// ─── Movie Catalog (List Page) ──────────────────────────────────────────────

class MovieCatalog extends StatefulWidget {
  const MovieCatalog({super.key});

  @override
  State<MovieCatalog> createState() => _MovieCatalogState();
}

class _MovieCatalogState extends State<MovieCatalog> {
  final _movies = [
    Movie('Swallowed Star', '2025', 4.5,
        genre: 'Sci-Fi, Action',
        description:
            'In a post-apocalyptic world overrun by monsters, a young warrior embarks on a journey to protect humanity and uncover the secrets of the universe.'),
    Movie('Renegade Immortal', '2024', 4.0,
        genre: 'Fantasy, Drama',
        description:
            'A talented young cultivator faces betrayal and hardship, rising through the ranks of the immortal world through sheer determination and cunning.'),
    Movie('The Great Ruler', '2023', 4.8,
        genre: 'Fantasy, Adventure',
        description:
            'In a world where spiritual power determines one\'s fate, a young man strives to become the greatest ruler by mastering the art of spiritual cultivation.'),
    Movie('Ling Cage', '2022', 4.7,
        genre: 'Sci-Fi, Mecha',
        description:
            'Humanity\'s last survivors live in a massive mobile city, fighting against alien creatures to reclaim their lost homeland.'),
    Movie('The Last Human', '2021', 4.6,
        genre: 'Post-Apocalyptic',
        description:
            'After a zombie apocalypse, the last surviving human must navigate a world full of dangers while searching for other survivors.'),
    Movie('The Legendary Moonlight Sculptor', '2020', 4.9,
        genre: 'Fantasy, Gaming',
        description:
            'A poverty-stricken young man enters a virtual reality game and discovers his talent for sculpting, which leads him on an epic adventure.'),
    Movie('The Desolate Era', '2019', 4.4,
        genre: 'Fantasy, Martial Arts',
        description:
            'A young man with a mysterious past embarks on a journey of martial arts cultivation, facing powerful enemies and uncovering ancient secrets.'),
    Movie('The Strongest System', '2018', 4.3,
        genre: 'Comedy, Fantasy',
        description:
            'A lazy student gains access to a mysterious system that allows him to level up and acquire skills in a world of cultivation.'),
    Movie('The Portal of Wonderland', '2017', 4.2,
        genre: 'Fantasy, Adventure',
        description:
            'A young boy discovers a portal to a magical world and must learn to harness its power to save both worlds from destruction.'),
  ];

  void _toggleFavorite(int index) {
    setState(() {
      _movies[index].isFavorite = !_movies[index].isFavorite;
    });
  }

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
          itemBuilder: (_, i) => _MovieCard(
            _movies[i],
            onTap: () async {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailPage(
                    movie: _movies[i],
                    onToggleFavorite: () => _toggleFavorite(i),
                  ),
                ),
              );
              if (updated == true) setState(() {});
            },
            onFavorite: () => _toggleFavorite(i),
          ),
        ),
      );
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _MovieCard(this.movie, {required this.onTap, required this.onFavorite});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Card(
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
                        movie.title,
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
                            movie.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onFavorite,
                  icon: Icon(
                    movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: movie.isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

// ─── Movie Detail Page ──────────────────────────────────────────────────────

class MovieDetailPage extends StatefulWidget {
  final Movie movie;
  final VoidCallback onToggleFavorite;

  const MovieDetailPage({
    super.key,
    required this.movie,
    required this.onToggleFavorite,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  void _toggle() {
    setState(() {
      widget.movie.isFavorite = !widget.movie.isFavorite;
    });
    widget.onToggleFavorite();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF0F0F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF0F0F5),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context, true),
          ),
          title: Text(
            widget.movie.title,
            style: const TextStyle(color: Colors.black87),
          ),
          actions: [
            IconButton(
              onPressed: _toggle,
              icon: Icon(
                widget.movie.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: widget.movie.isFavorite ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Poster Placeholder ──
              Center(
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.movie_creation,
                      color: Colors.grey, size: 80),
                ),
              ),
              const SizedBox(height: 20),

              // ── Title ──
              Text(
                widget.movie.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // ── Genre Chip ──
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.movie.genre,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Rating & Year Row ──
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    widget.movie.rating.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 24),
                  const Icon(Icons.calendar_today,
                      color: Colors.grey, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    widget.movie.date,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Description ──
              const Text(
                'Synopsis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.movie.description,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),

              // ── Favorite Button ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _toggle,
                  icon: Icon(
                    widget.movie.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  label: Text(
                    widget.movie.isFavorite
                        ? 'Remove from Favorites'
                        : 'Add to Favorites',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.movie.isFavorite ? Colors.red : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
