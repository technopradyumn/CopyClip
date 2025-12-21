import 'package:go_router/go_router.dart';
import '../app_keys.dart';
import 'app_router.dart';

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  routes: [
    ...getAuthRoutes(),
  ],
);
