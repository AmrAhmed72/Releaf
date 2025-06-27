import 'package:flutter/material.dart';
import 'package:releaf/UI/Home/Search/search_results_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<String> recentSearches;
  final Function(String) onSearchSubmitted;
  final VoidCallback onClearRecent;

  const SearchScreen({
    super.key,
    required this.recentSearches,
    required this.onSearchSubmitted,
    required this.onClearRecent,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late List<String> _currentRecentSearches;

  @override
  void initState() {
    super.initState();
    _currentRecentSearches = List.from(widget.recentSearches);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Helper method to update recent searches locally
  void _updateRecentSearches(String query) {
    if (!_currentRecentSearches.contains(query) && query.trim().isNotEmpty) {
      setState(() {
        _currentRecentSearches.insert(0, query);
        if (_currentRecentSearches.length > 6)
          _currentRecentSearches.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5EC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextSelectionTheme(  data: const TextSelectionThemeData(
            cursorColor: Color(0xFF609254),
            selectionColor: Color(0xFF609254),
            selectionHandleColor: Color(0xFF609254),
          ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 37,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF609254)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/output-onlinepngtools.png',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                style: TextStyle(
                                  color: Color(0xFF392515),
                                  fontSize: 15,
                                  fontFamily: 'Inter',
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Search plants...',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF9F8571),
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                  ),
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                ),
                                onSubmitted: (query) async {
                                  if (query.trim().isNotEmpty) {
                                    // Update recent searches locally and in Homepage
                                    _updateRecentSearches(query);
                                    widget.onSearchSubmitted(query);
                                    // Clear the search bar
                                    _searchController.clear();
                                    // Navigate to SearchResultsScreen and wait for result
                                    final updatedSearches = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SearchResultsScreen(
                                          searchQuery: query,
                                          recentSearches: _currentRecentSearches,
                                          onSearchSubmitted:
                                              widget.onSearchSubmitted,
                                          onClearRecent: widget.onClearRecent,
                                        ),
                                      ),
                                    );
                                    // Update local recent searches with the result
                                    if (updatedSearches != null) {
                                      setState(() {
                                        _currentRecentSearches =
                                            List.from(updatedSearches);
                                      });
                                    }
                                    // Request focus again after returning
                                    _searchFocusNode.requestFocus();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _searchController.clear();
                        _searchFocusNode.unfocus();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF609254),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFFF4F5EC),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent search',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF392515),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: const Color(0xFF392515),
                      onPressed: () {
                        widget.onClearRecent();
                        setState(() {
                          _currentRecentSearches.clear();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _currentRecentSearches.map((search) {
                    return GestureDetector(
                      onTap: () async {
                        _searchController.text = search;
                        // Update recent searches to move this query to the top
                        _updateRecentSearches(search);
                        widget.onSearchSubmitted(search);
                        // Clear the search bar after selecting a recent search
                        _searchController.clear();
                        // Navigate to SearchResultsScreen and wait for result
                        final updatedSearches = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultsScreen(
                              searchQuery: search,
                              recentSearches: _currentRecentSearches,
                              onSearchSubmitted: widget.onSearchSubmitted,
                              onClearRecent: widget.onClearRecent,
                            ),
                          ),
                        );
                        // Update local recent searches with the result
                        if (updatedSearches != null) {
                          setState(() {
                            _currentRecentSearches = List.from(updatedSearches);
                          });
                        }
                        // Request focus again after returning
                        _searchFocusNode.requestFocus();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F5EC),
                          border: Border.all(color: const Color(0xFF9F8571)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          search,
                          style: const TextStyle(color: Color(0xFF392515)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
