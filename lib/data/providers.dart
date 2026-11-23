import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/models.dart';
import 'repositories/repositories.dart';

// Repositories: swap the mock for a real implementation here.
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) => const MockCatalogRepository());
final storesRepositoryProvider = Provider<StoresRepository>((ref) => const MockStoresRepository());
final ordersRepositoryProvider = Provider<OrdersRepository>((ref) => const MockOrdersRepository());
final authRepositoryProvider = Provider<AuthRepository>((ref) => const MockAuthRepository());
final profileRepositoryProvider = Provider<ProfileRepository>((ref) => const MockProfileRepository());

// Read models.
final categoriesProvider = FutureProvider<List<Category>>((ref) => ref.watch(catalogRepositoryProvider).categories());
final hitsProvider = FutureProvider<List<Product>>((ref) => ref.watch(catalogRepositoryProvider).hits());
final upsellProvider = FutureProvider<List<Product>>((ref) => ref.watch(catalogRepositoryProvider).upsell());
final productsProvider = FutureProvider.family<List<Product>, String?>(
  (ref, categoryId) => ref.watch(catalogRepositoryProvider).products(categoryId: categoryId),
);
final productProvider = FutureProvider.family<Product, String>((ref, id) => ref.watch(catalogRepositoryProvider).product(id));
final reviewsProvider = FutureProvider.family<List<Review>, String>((ref, id) => ref.watch(catalogRepositoryProvider).reviews(id));
final cakeSizesProvider = FutureProvider<List<CakeSize>>((ref) => ref.watch(catalogRepositoryProvider).cakeSizes());
final cakeAddonsProvider = FutureProvider<List<CakeAddon>>((ref) => ref.watch(catalogRepositoryProvider).cakeAddons());
final storesProvider = FutureProvider<List<Store>>((ref) => ref.watch(storesRepositoryProvider).stores());
final ordersProvider = FutureProvider<List<Order>>((ref) => ref.watch(ordersRepositoryProvider).orders());
final profileProvider = FutureProvider<UserProfile>((ref) => ref.watch(profileRepositoryProvider).me());
