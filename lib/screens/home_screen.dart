import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/screens/detail_screens.dart';
import 'package:pilem/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiServices _apiServices = ApiServices();
  List<Movie> _allMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];
  bool _isLoading = true;
  
  Future<void> _loadMovies() async {
    try {
      final movies = await _apiServices.getAllMovies();
      final trending = await _apiServices.getTrendingMovies();
      final popular = await _apiServices.getPopularMovies();
      
      setState(() {
        _allMovies = movies.cast<Movie>();
        _trendingMovies = trending.cast<Movie>();
        _popularMovies = popular.cast<Movie>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error loading movies: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilem', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200],
        child: _isLoading ? _buildLoadingShimmer() : _buildMovieLists(),
      ),
    );
  }

  Widget _buildMovieLists() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMoviesList("All Movies", _allMovies),
          _buildMoviesList("Trending Movies", _trendingMovies),
          _buildMoviesList("Popular Movies", _popularMovies),
        ],
      ),
    );
  }

  Widget _buildMoviesList(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              final Movie movie = movies[index];
              return _buildMovieCard(movie);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(movie: movie),
        ),
      ),
      child: Container(
        width: 140,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                width: 140,
                height: 180,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Text(
                  movie.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(3, (index) => _buildShimmerList()),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(height: 20, width: 150, color: Colors.white),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 140,
                  height: 180,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
