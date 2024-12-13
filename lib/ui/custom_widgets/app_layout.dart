import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:splitz/constants/app_colors.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? customAppBar;

  const AppLayout({
    super.key, 
    required this.child,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.customAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar ?? (title == null ? null : AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            title!,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: showBackButton ? IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ) : null,
          actions: actions,
        )),
        body: child,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
