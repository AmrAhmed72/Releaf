import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../screens/category_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Category>> _categoriesFuture;

  // Updated to match API category names
  final Map<String, String> categoryImages = {
    'Trees': 'assets/tree.png',
    'Ferns': 'assets/Ferns.png',
    'Flowers': 'assets/Flowers.png',
    'Herbs': 'assets/herbs1.png',
    'Vegetables': 'assets/vegandfrut.png',
  };

  // Default colors for categories (used for fallback if needed elsewhere)
  final Map<String, Color> categoryColors = {
    'Trees': Color(0xFF81B29A),
    'Ferns': Color(0xFF3D405B),
    'Flowers': Color(0xFFE07A5F),
    'Herbs': Color(0xFF81B29A),
    'Vegetables': Color(0xFFF2CC8F),
  };

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _apiService.getAllCategories();
  }

  void _navigateToCategoryDetail(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailScreen(
          categoryId: category.id,
          categoryName: category.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF609254),
        elevation: 0,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff392515)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories available'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final category = snapshot.data![index];
                return _buildCategoryCard(category);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () => _navigateToCategoryDetail(category),
      child: Container(
        width: 130,
        height: 130,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFEEF0E2),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0xFF9F8571)),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F4C2B12),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left:20,
              top: 20,
              child: Text(
                category.name,
                style: const TextStyle(
                  color: Color(0xFF4C2B12),
                  fontSize: 16,
                  fontFamily: 'Laila',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: 227,
                height: 227,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: categoryImages.containsKey(category.name)
                        ? AssetImage(categoryImages[category.name]!)
                        : const AssetImage('assets/placeholder_category.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'trees':
        return Icons.park;
      case 'ferns':
        return Icons.eco;
      case 'flowers':
        return Icons.local_florist;
      case 'herbs':
        return Icons.grass;
      case 'vegetables':
        return Icons.restaurant;
      default:
        return Icons.category;
    }
  }
}