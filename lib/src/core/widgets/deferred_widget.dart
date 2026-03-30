import 'dart:async';
import 'package:flutter/material.dart';

typedef LibraryLoader = Future<void> Function();
typedef DeferredWidgetBuilder = Widget Function();

/// A widget that loads a deferred library and then builds a widget from it.
/// Used for Tip 06: Deferred Loading to improve cold start performance.
class DeferredWidget extends StatefulWidget {
  final LibraryLoader libraryLoader;
  final DeferredWidgetBuilder builder;

  const DeferredWidget({
    super.key,
    required this.libraryLoader,
    required this.builder,
  });

  @override
  State<DeferredWidget> createState() => _DeferredWidgetState();
}

class _DeferredWidgetState extends State<DeferredWidget> {
  Future<void>? _libraryLoaderFuture;

  @override
  void initState() {
    super.initState();
    _libraryLoaderFuture = widget.libraryLoader();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _libraryLoaderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
             return Scaffold(
               body: Center(
                 child: Text('Error loading component: ${snapshot.error}'),
               ),
             );
          }
          return widget.builder();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
