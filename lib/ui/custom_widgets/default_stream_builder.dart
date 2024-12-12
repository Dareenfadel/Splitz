import 'package:flutter/material.dart';
import 'package:splitz/ui/custom_widgets/cards_loading_screen.dart';
import 'package:splitz/ui/custom_widgets/generic_error_screen.dart';

class DefaultStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(T data) builder;
  final Widget? loadingWidget;
  final Widget Function(Object error)? errorBuilder;
  final T? initialData;
  final String? errorMessage;

  const DefaultStreamBuilder({
    super.key,
    required this.stream,
    required this.builder,
    this.loadingWidget,
    this.errorBuilder,
    this.errorMessage,
    this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      initialData: initialData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorBuilder?.call(snapshot.error!) ??
              GenericErrorScreen(
                message:
                    errorMessage ?? 'An error occurred while loading the data',
                details: snapshot.error.toString(),
              );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ?? const CardsLoadingScreen();
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return builder(snapshot.data as T);
      },
    );
  }
}
