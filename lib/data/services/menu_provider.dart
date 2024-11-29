import 'package:flutter/material.dart';
import 'package:splitz/data/models/menu_category.dart';
import 'package:splitz/data/services/menu_category_Service.dart';

class MenuCategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<MenuCategory> _categories = [];
  bool _isLoading = false;

  List<MenuCategory> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories(String restaurantId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _categoryService.fetchMenuCategories(restaurantId);
    } catch (e) {
      // Handle error
      print("Error fetching categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(MenuCategory category, String restaurantId) async {
    await _categoryService.addMenuCategory(
        restaurantId, category.name, category.description, category.image);

    _categories.add(category);
    notifyListeners();
  }
}
