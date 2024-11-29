import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/menu_category.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/menu_provider.dart';
import 'package:splitz/ui/custom_widgets/menu_grid_item.dart';
import 'package:splitz/ui/custom_widgets/custom_floating_button.dart';
import 'package:splitz/ui/screens/manager_screens/menu_category_form.dart';
import '../../../constants/app_colors.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    String? restaurantId = user?.restaurantId;

    return ChangeNotifierProvider(
      create: (_) => MenuCategoryProvider(),
      child: Consumer<MenuCategoryProvider>(
        builder: (context, provider, child) {
          // Fetch categories if not already loaded
          if (provider.categories.isEmpty && !provider.isLoading) {
            provider.fetchCategories(restaurantId!);
          }

          return Scaffold(
              appBar: AppBar(
                title: const Text('Menu'),
                centerTitle: true,
                titleTextStyle: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 30, right: 16, left: 16),
                child: Stack(children: [
                  Column(children: [
                    // Only show the menu items if they are loaded
                    provider.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : provider.categories.isEmpty
                            ? Center(child: Text('No categories available'))
                            : Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 24,
                                    crossAxisSpacing: 24,
                                  ),
                                  itemCount: provider.categories.length,
                                  itemBuilder: (context, index) {
                                    MenuCategory category =
                                        provider.categories[index];
                                    return MenuItem(
                                      imageUrl: category.image,
                                      label: category.name,
                                      onPressed: () {
                                        print('Clicked on ${category.name}');
                                      },
                                    );
                                  },
                                ),
                              ),
                  ]),
                  user?.userType == "manager"
                      ? CustomFloatingButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddCategoryDialog(
                                restaurantId: user!.restaurantId!,
                                onCategoryAdded: (newCategory) {
                                  provider.addCategory(
                                      newCategory, restaurantId!);
                                },
                              ),
                            );
                          },
                        )
                      : SizedBox.shrink(),
                ]),
              ));
        },
      ),
    );
  }
}
