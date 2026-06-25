import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MovieCatalog(),
      ),
    );

class Movie {
  final String title, date, genre, description;
  final String? imageUrl;
  final double rating;
  bool isFavorite;

  Movie(
    this.title,
    this.date,
    this.rating, {
    this.genre = 'Animation',
    this.description = 'No description available.',
    this.imageUrl,
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
          imageUrl: 'https://image.tmdb.org/t/p/original/9sC0zY6hMlzejIu2uCC9CfK86iu.jpg',
        description:
            'In a post-apocalyptic world overrun by monsters, a young warrior embarks on a journey to protect humanity and uncover the secrets of the universe.'),
    Movie('Renegade Immortal', '2024', 4.0,
        genre: 'Fantasy, Drama',
        imageUrl: 'https://en-images.kinorium.com/movie/1080/10356010.jpg?1726747057',
        description:
            'A talented young cultivator faces betrayal and hardship, rising through the ranks of the immortal world through sheer determination and cunning.'),
    Movie('The Great Ruler', '2023', 4.8,
        genre: 'Fantasy, Adventure',
        description:
            'In a world where spiritual power determines one\'s fate, a young man strives to become the greatest ruler by mastering the art of spiritual cultivation.'),
    Movie('Ling Cage', '2022', 4.7,
        genre: 'Sci-Fi, Mecha',
        imageUrl: 'https://image.tmdb.org/t/p/original/NK9d7KiscPPAMhKHWIVjkcEIZy.jpg',
        description:
            'Humanity\'s last survivors live in a massive mobile city, fighting against alien creatures to reclaim their lost homeland.'),
    Movie('The Last Human', '2021', 4.6,
        genre: 'Post-Apocalyptic',
        imageUrl: 'https://tse4.mm.bing.net/th/id/OIP.s0Ud7Uq35Pv1WIJSiIVwKQHaKk?rs=1&pid=ImgDetMain&o=7&rm=3',
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

  // 🔵 FutureBuilder ----------------------------------------------------------
  // Future ini mensimulasikan proses "mengambil data movie dari server/API".
  // Cuma berjalan SEKALI saat halaman pertama kali dibuka.
  Future<List<Movie>> _fetchMovies() async {
    await Future.delayed(const Duration(seconds: 2)); // simulasi delay network
    return _movies;
  }

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
        // 🔵 FutureBuilder ----------------------------------------------------
        // Karena _fetchMovies() cuma butuh dipanggil sekali sampai datanya
        // selesai diambil, kita bungkus body-nya dengan FutureBuilder.
        body: FutureBuilder<List<Movie>>(
          future: _fetchMovies(),
          builder: (context, snapshot) {
            // Selama Future belum selesai -> tampilkan loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Mengambil data film...'),
                  ],
                ),
              );
            }

            // Kalau Future selesai tapi error
            if (snapshot.hasError) {
              return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
            }

            // Kalau Future selesai dan datanya ada -> tampilkan list seperti biasa
            final movies = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: movies.length,
              itemBuilder: (_, i) => _MovieCard(
                movies[i],
                onTap: () async {
                  final updated = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailPage(
                        movie: movies[i],
                        onToggleFavorite: () => _toggleFavorite(i),
                      ),
                    ),
                  );
                  if (updated == true) setState(() {});
                },
                onFavorite: () => _toggleFavorite(i),
              ),
            );
          },
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
                  child: movie.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            movie.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(Icons.movie, color: Colors.grey, size: 32),
                          ),
                        )
                      : const Icon(Icons.movie, color: Colors.grey, size: 32),
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
  // 🟢 StreamBuilder 
  // Stream ini mensimulasikan "rating realtime" yang terus berubah,
  // seakan-akan ada penonton lain yang sedang memberi rating secara live.
  // Stream akan mengirim nilai baru setiap 2 detik, terus-menerus,
  // berbeda dengan Future yang cuma sekali kirim data lalu berhenti.
  late Stream<double> _liveRatingStream;

  @override
  void initState() {
    super.initState();
    _liveRatingStream = _generateLiveRating(widget.movie.rating);
  }

  Stream<double> _generateLiveRating(double baseRating) async* {
    double current = baseRating;
    final random = DateTime.now().millisecondsSinceEpoch;
    int seed = random;

    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      // simulasi fluktuasi kecil rating, contoh: -0.2 s/d +0.2
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      final delta = ((seed % 41) - 20) / 100; // -0.20 .. +0.20
      current = (current + delta).clamp(1.0, 5.0);
      yield current;
    }
  }

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
              // ── Poster ──
              Center(
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: widget.movie.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.movie.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 220,
                            errorBuilder: (_, _, _) => const Icon(Icons.movie_creation, color: Colors.grey, size: 80),
                          ),
                        )
                      : const Icon(Icons.movie_creation, color: Colors.grey, size: 80),
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

              // ── Rating (Live, via StreamBuilder) & Year Row ──
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 22),
                  const SizedBox(width: 6),
                  // 🟢 StreamBuilder ------------------------------------------
                  // Setiap kali _liveRatingStream mengirim nilai baru (tiap 2
                  // detik), bagian Text ini rebuild ulang menampilkan rating
                  // terkini. Beda dengan FutureBuilder yang cuma rebuild sekali.
                  StreamBuilder<double>(
                    stream: _liveRatingStream,
                    initialData: widget.movie.rating,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('--');
                      }
                      final liveRating = snapshot.data ?? widget.movie.rating;
                      return Row(
                        children: [
                          Text(
                            liveRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'live',
                            style: TextStyle(fontSize: 11, color: Colors.green),
                          ),
                        ],
                      );
                    },
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