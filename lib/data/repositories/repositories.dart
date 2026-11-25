import '../mock/mock_data.dart';
import '../models/models.dart';

/// Every repository below is an interface with a mock implementation.
/// When the backend is ready, add a real implementation and swap it
/// in `data/providers.dart` — screens don't change.

const _latency = Duration(milliseconds: 350);

abstract interface class CatalogRepository {
  Future<List<Category>> categories();
  Future<List<Product>> products({String? categoryId});
  Future<List<Promo>> promos();
  Future<List<Product>> hits();
  Future<List<Product>> upsell();
  Future<Product> product(String id);
  Future<List<Review>> reviews(String productId);
  Future<void> addReview(String productId, Review review);
  Future<List<CakeSize>> cakeSizes();
  Future<List<CakeAddon>> cakeAddons();
}

class MockCatalogRepository implements CatalogRepository {
  const MockCatalogRepository();

  @override
  Future<List<Category>> categories() => Future.delayed(_latency, () => MockData.categories);

  @override
  Future<List<Product>> products({String? categoryId}) => Future.delayed(
    _latency,
    () => categoryId == null ? MockData.products : MockData.products.where((p) => p.categoryId == categoryId).toList(),
  );

  @override
  Future<List<Promo>> promos() => Future.delayed(_latency, () => MockData.promos);

  @override
  Future<List<Product>> hits() => Future.delayed(_latency, () => _byIds(MockData.hitIds));

  @override
  Future<List<Product>> upsell() => Future.delayed(_latency, () => _byIds(MockData.upsellIds));

  @override
  Future<Product> product(String id) => Future.delayed(_latency, () => MockData.products.firstWhere((p) => p.id == id));

  @override
  Future<List<Review>> reviews(String productId) =>
      Future.delayed(_latency, () => [...?_userReviews[productId]?.reversed, ...MockData.reviews]);

  static final Map<String, List<Review>> _userReviews = {};

  @override
  Future<void> addReview(String productId, Review review) => Future.delayed(_latency, () => (_userReviews[productId] ??= []).add(review));

  @override
  Future<List<CakeSize>> cakeSizes() => Future.delayed(_latency, () => MockData.cakeSizes);

  @override
  Future<List<CakeAddon>> cakeAddons() => Future.delayed(_latency, () => MockData.cakeAddons);

  List<Product> _byIds(List<String> ids) => [for (final id in ids) MockData.products.firstWhere((p) => p.id == id)];
}

abstract interface class StoresRepository {
  Future<List<Store>> stores();
}

class MockStoresRepository implements StoresRepository {
  const MockStoresRepository();

  @override
  Future<List<Store>> stores() => Future.delayed(_latency, () => MockData.stores);
}

abstract interface class DeliveryRepository {
  Future<List<DeliveryZone>> zones();
}

class MockDeliveryRepository implements DeliveryRepository {
  const MockDeliveryRepository();

  @override
  Future<List<DeliveryZone>> zones() => Future.delayed(_latency, () => MockData.deliveryZones);
}

abstract interface class OrdersRepository {
  Future<List<Order>> orders();

  /// Places an order and returns its number.
  Future<int> placeOrder({required int total, required List<OrderLine> lines});
}

class MockOrdersRepository implements OrdersRepository {
  const MockOrdersRepository();

  static final List<Order> _placed = [];

  @override
  Future<List<Order>> orders() => Future.delayed(_latency, () => [..._placed.reversed, ...MockData.orders]);

  @override
  Future<int> placeOrder({required int total, required List<OrderLine> lines}) => Future.delayed(const Duration(milliseconds: 800), () {
    final number = 10483 + _placed.length;
    _placed.add(
      Order(
        number: number,
        total: total,
        date: DateTime.now(),
        status: OrderStatus.accepted,
        itemsCount: lines.fold(0, (sum, l) => sum + l.qty),
        etaMinutes: 45,
        lines: lines,
      ),
    );
    return number;
  });
}

abstract interface class AuthRepository {
  Future<void> requestCode(String phone);

  /// Returns true when the code is accepted.
  Future<bool> verifyCode(String phone, String code);
}

class MockAuthRepository implements AuthRepository {
  const MockAuthRepository();

  static const testCode = '1234';

  @override
  Future<void> requestCode(String phone) => Future.delayed(_latency);

  @override
  Future<bool> verifyCode(String phone, String code) => Future.delayed(_latency, () => code == testCode);
}

abstract interface class ProfileRepository {
  Future<UserProfile> me();
  Future<void> updateAddress(Address address);
}

class MockProfileRepository implements ProfileRepository {
  const MockProfileRepository();

  static UserProfile _me = MockData.user;

  @override
  Future<UserProfile> me() => Future.delayed(_latency, () => _me);

  @override
  Future<void> updateAddress(Address address) => Future.delayed(_latency, () {
    _me = UserProfile(name: _me.name, phone: _me.phone, bonus: _me.bonus, address: address);
  });
}
