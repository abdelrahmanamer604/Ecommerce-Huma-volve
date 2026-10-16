
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/details/presentation/view/product_details_screen.dart';
import '../../features/main_navigation/screens/main_navigation_screen.dart';
import '../../features/splash/screens/splash_screen.dart';

class AppRouting {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainNavigation = '/main';
  static const String productDetails = '/products/:id';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: mainNavigation,
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: productDetails,
        builder: (context, state) {
          final productId = state.pathParameters['id'] ?? '1';
          return ProductDetailsScreen(productId: productId);
        },
      ),
    ],
  );
}
