import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiServices _apiServices = ApiServices();
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchMovies);
    
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();

  }

  void _searchMovies() async {
    if (_searchController.text.isEmpty){
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    final List<Movie> searchData =
         await _apiServices.searchMovies(_searchController.text);
    
         setState(() {
           _searchResults = searchData;
         });
    

  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}