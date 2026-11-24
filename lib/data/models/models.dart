import 'localized_text.dart';

export 'localized_text.dart';

/// Colour family of a category tile; the UI maps it to brand colours.
enum CategoryTone { red, teal, cream, green, white }

class Category {
  const Category({required this.id, required this.name, required this.tone, this.subcategories = const [], this.image});

  final String id;

  /// Photo shown on the category tile: an asset path or an http(s) URL.
  /// Null shows the striped placeholder.
  final String? image;
  final LocalizedText name;
  final CategoryTone tone;
  final List<LocalizedText> subcategories;
}

class Nutrition {
  const Nutrition({required this.kcal, required this.protein, required this.fat, required this.carbs});

  final int kcal;
  final double protein;
  final double fat;
  final double carbs;
}

class ProductVariant {
  const ProductVariant({required this.weightGrams, required this.price});

  final int weightGrams;
  final int price;
}

class Product {
  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.weightGrams,
    this.image = 'assets/images/product1.png',
    this.isNew = false,
    this.rating = 4.8,
    this.reviewsCount = 0,
    this.description = const LocalizedText.same(''),
    this.composition = const LocalizedText.same(''),
    this.storage = const LocalizedText.same(''),
    this.nutrition,
    this.variants = const [],
  });

  final String id;
  final String categoryId;
  final LocalizedText name;
  final int price;
  final int weightGrams;
  final String image;
  final bool isNew;
  final double rating;
  final int reviewsCount;
  final LocalizedText description;
  final LocalizedText composition;
  final LocalizedText storage;
  final Nutrition? nutrition;
  final List<ProductVariant> variants;
}

class CakeSize {
  const CakeSize({required this.diameterCm, required this.servings, required this.price});

  final int diameterCm;
  final String servings;
  final int price;
}

class CakeAddon {
  const CakeAddon({required this.id, required this.name, required this.price});

  final String id;
  final LocalizedText name;
  final int price;
}

enum StoreStatus { open, closingSoon, closed }

class Store {
  const Store({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceKm,
    required this.status,
    required this.closesAt,
    required this.minutesToClose,
    required this.phone,
  });

  final String id;
  final String name;
  final LocalizedText address;
  final double distanceKm;
  final StoreStatus status;
  final String closesAt;
  final int minutesToClose;
  final String phone;
}

enum OrderStatus { accepted, baking, onTheWay, delivered }

class Order {
  const Order({
    required this.number,
    required this.total,
    required this.date,
    required this.status,
    required this.itemsCount,
    this.etaMinutes,
  });

  final int number;
  final int total;
  final DateTime date;
  final OrderStatus status;
  final int itemsCount;
  final int? etaMinutes;

  bool get isActive => status != OrderStatus.delivered;
}

class Review {
  const Review({required this.author, required this.rating, required this.daysAgo, required this.text, this.photos = 0});

  final String author;
  final int rating;
  final int daysAgo;
  final LocalizedText text;
  final int photos;
}

class UserProfile {
  const UserProfile({required this.name, required this.phone, required this.bonus, required this.address});

  final LocalizedText name;
  final String phone;
  final int bonus;
  final Address address;
}

class Address {
  const Address({required this.street, required this.apartment, required this.floor});

  final LocalizedText street;
  final String apartment;
  final String floor;
}
