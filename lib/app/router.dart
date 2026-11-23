import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/cart/cart_screen.dart';
import '../features/checkout/address_map_screen.dart';
import '../features/checkout/checkout_screen.dart';
import '../features/checkout/payment_screen.dart';
import '../features/home/home_screen.dart';
import '../features/menu/category_screen.dart';
import '../features/menu/menu_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/product/custom_cake_screen.dart';
import '../features/product/product_screen.dart';
import '../features/product/reviews_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/stores/stores_screen.dart';
import 'tab_bar.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// All routes. Tabs live in a [StatefulShellRoute] so each tab keeps its
/// own stack; full-screen flows (product, cart, checkout) sit on the root.
final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
    GoRoute(
      path: '/otp',
      builder: (_, state) => OtpScreen(phone: state.uri.queryParameters['phone'] ?? ''),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _TabShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/home', builder: (_, _) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/menu',
              builder: (_, _) => const MenuScreen(),
              routes: [
                GoRoute(
                  path: 'category/:id',
                  builder: (_, s) => CategoryScreen(categoryId: s.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/stores', builder: (_, _) => const StoresScreen())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (_, _) => const ProfileScreen(),
              routes: [GoRoute(path: 'orders', builder: (_, _) => const OrdersScreen())],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/product/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, s) => ProductScreen(productId: s.pathParameters['id']!),
      routes: [
        GoRoute(
          path: 'reviews',
          builder: (_, s) => ReviewsScreen(productId: s.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(path: '/custom-cake', parentNavigatorKey: rootNavigatorKey, builder: (_, _) => const CustomCakeScreen()),
    GoRoute(path: '/cart', parentNavigatorKey: rootNavigatorKey, builder: (_, _) => const CartScreen()),
    GoRoute(path: '/checkout', parentNavigatorKey: rootNavigatorKey, builder: (_, _) => const CheckoutScreen()),
    GoRoute(path: '/payment', parentNavigatorKey: rootNavigatorKey, builder: (_, _) => const PaymentScreen()),
    GoRoute(path: '/address', parentNavigatorKey: rootNavigatorKey, builder: (_, _) => const AddressMapScreen()),
  ],
);

class _TabShell extends StatelessWidget {
  const _TabShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: QTabBar(
        currentIndex: shell.currentIndex,
        onTap: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
      ),
    );
  }
}
