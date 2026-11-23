import '../models/models.dart';

/// Static sample data shown until the real backend is connected.
abstract final class MockData {
  static const categories = <Category>[
    Category(
      id: 'cakes',
      name: LocalizedText('Торты', 'Торттар'),
      tone: CategoryTone.red,
      subcategories: [
        LocalizedText('Медовые', 'Балды'),
        LocalizedText('Бисквитные', 'Бисквитті'),
        LocalizedText('Муссовые', 'Муссты'),
        LocalizedText('Чизкейки', 'Чизкейктер'),
      ],
    ),
    Category(id: 'desserts', name: LocalizedText('Десерты', 'Десерттер'), tone: CategoryTone.teal),
    Category(id: 'bakery', name: LocalizedText('Выпечка', 'Тоқаштар'), tone: CategoryTone.cream),
    Category(id: 'bread', name: LocalizedText('Хлеб', 'Нан'), tone: CategoryTone.green),
    Category(id: 'deli', name: LocalizedText('Кулинария', 'Аспаздық'), tone: CategoryTone.white),
    Category(id: 'drinks', name: LocalizedText('Напитки', 'Сусындар'), tone: CategoryTone.red),
  ];

  static const _medovikComposition = LocalizedText(
    'Мука пшеничная, мёд натуральный, сметана 20%, сахар, яйцо куриное, масло сливочное 82,5%, сода.',
    'Бидай ұны, табиғи бал, 20% қаймақ, қант, тауық жұмыртқасы, 82,5% сары май, сода.',
  );
  static const _storage = LocalizedText(
    'Хранить при температуре +2…+6 °C не более 72 часов.',
    '+2…+6 °C температурада 72 сағаттан артық сақтамаңыз.',
  );

  static const products = <Product>[
    Product(
      id: 'medovik',
      categoryId: 'cakes',
      name: LocalizedText('Торт «Медовик»', '«Медовик» торты'),
      price: 4900,
      weightGrams: 750,
      rating: 4.8,
      reviewsCount: 128,
      description: LocalizedText(
        'Тонкие медовые коржи, сметанный крем и лёгкая карамельная нота.',
        'Жұқа балды қабаттар, қаймақ кремі және жеңіл карамель дәмі.',
      ),
      composition: _medovikComposition,
      storage: _storage,
      nutrition: Nutrition(kcal: 436, protein: 6.5, fat: 22.5, carbs: 51.4),
      variants: [
        ProductVariant(weightGrams: 750, price: 4900),
        ProductVariant(weightGrams: 1200, price: 7600),
        ProductVariant(weightGrams: 2000, price: 12400),
      ],
    ),
    Product(
      id: 'ny-cheesecake',
      categoryId: 'cakes',
      name: LocalizedText('Чизкейк «Нью-Йорк»', '«Нью-Йорк» чизкейгі'),
      price: 1290,
      weightGrams: 120,
      isNew: true,
      rating: 4.9,
      reviewsCount: 54,
      description: LocalizedText('Классический сливочный чизкейк на песочной основе.', 'Құмды негіздегі классикалық кілегейлі чизкейк.'),
      composition: LocalizedText(
        'Сливочный сыр, сливки 33%, сахар, яйцо, печенье, масло сливочное.',
        'Кілегейлі ірімшік, 33% кілегей, қант, жұмыртқа, печенье, сары май.',
      ),
      storage: _storage,
      nutrition: Nutrition(kcal: 321, protein: 5.8, fat: 21.0, carbs: 27.3),
    ),
    Product(
      id: 'napoleon',
      categoryId: 'cakes',
      name: LocalizedText('Торт «Наполеон»', '«Наполеон» торты'),
      price: 5400,
      weightGrams: 900,
      rating: 4.7,
      reviewsCount: 96,
      description: LocalizedText('Хрустящие слоёные коржи и заварной крем.', 'Қытырлақ қатпарлы қабаттар және бұқтырылған крем.'),
      composition: LocalizedText(
        'Мука пшеничная, масло сливочное, молоко, сахар, яйцо, ваниль.',
        'Бидай ұны, сары май, сүт, қант, жұмыртқа, ваниль.',
      ),
      storage: _storage,
      nutrition: Nutrition(kcal: 398, protein: 5.9, fat: 24.1, carbs: 39.0),
    ),
    Product(
      id: 'berry-tart',
      categoryId: 'desserts',
      name: LocalizedText('Тарт с ягодами', 'Жидекті тарт'),
      price: 1590,
      weightGrams: 140,
      isNew: true,
      rating: 4.6,
      reviewsCount: 31,
      description: LocalizedText('Песочная корзинка, крем-патисьер и свежие ягоды.', 'Құмды себет, патисьер кремі және жаңа жидектер.'),
      storage: _storage,
      nutrition: Nutrition(kcal: 287, protein: 4.1, fat: 14.2, carbs: 35.6),
    ),
    Product(
      id: 'croissant-almond',
      categoryId: 'bakery',
      name: LocalizedText('Круассан с миндалём', 'Бадамды круассан'),
      price: 820,
      weightGrams: 90,
      rating: 4.8,
      reviewsCount: 77,
      description: LocalizedText('Слоёный круассан с миндальным кремом.', 'Бадам кремі бар қатпарлы круассан.'),
      nutrition: Nutrition(kcal: 412, protein: 8.2, fat: 23.4, carbs: 41.7),
    ),
    Product(
      id: 'eclair',
      categoryId: 'desserts',
      name: LocalizedText('Эклер', 'Эклер'),
      price: 690,
      weightGrams: 70,
      rating: 4.5,
      reviewsCount: 22,
    ),
    Product(
      id: 'sourdough',
      categoryId: 'bread',
      name: LocalizedText('Хлеб на закваске', 'Ашытқылы нан'),
      price: 1100,
      weightGrams: 500,
      rating: 4.9,
      reviewsCount: 64,
    ),
    Product(id: 'candles', categoryId: 'deli', name: LocalizedText('Свечи', 'Шамдар'), price: 500, weightGrams: 20),
  ];

  static const hitIds = ['medovik', 'ny-cheesecake', 'napoleon', 'berry-tart'];
  static const upsellIds = ['eclair', 'sourdough', 'candles'];

  static const cakeSizes = <CakeSize>[
    CakeSize(diameterCm: 18, servings: '6–8', price: 9900),
    CakeSize(diameterCm: 22, servings: '8–10', price: 14500),
    CakeSize(diameterCm: 26, servings: '12–14', price: 19800),
  ];

  static const cakeAddons = <CakeAddon>[
    CakeAddon(id: 'candles', name: LocalizedText('Свечи', 'Шамдар'), price: 500),
    CakeAddon(id: 'box', name: LocalizedText('Подарочная коробка', 'Сыйлық қорабы'), price: 1200),
  ];

  static const stores = <Store>[
    Store(
      id: 'abaya',
      name: 'Qulpynai · Абая',
      address: LocalizedText('пр. Абая, 52', 'Абай даңғ., 52'),
      distanceKm: 0.4,
      status: StoreStatus.open,
      closesAt: '22:00',
      minutesToClose: 240,
      phone: '+77070000001',
    ),
    Store(
      id: 'dostyk',
      name: 'Qulpynai · Достык',
      address: LocalizedText('пр. Достык, 105', 'Достық даңғ., 105'),
      distanceKm: 2.1,
      status: StoreStatus.closingSoon,
      closesAt: '21:00',
      minutesToClose: 40,
      phone: '+77070000002',
    ),
    Store(
      id: 'satpaeva',
      name: 'Qulpynai · Сатпаева',
      address: LocalizedText('ул. Сатпаева, 30А', 'Сәтбаев к-сі, 30А'),
      distanceKm: 3.6,
      status: StoreStatus.closed,
      closesAt: '20:00',
      minutesToClose: 0,
      phone: '+77070000003',
    ),
  ];

  static final orders = <Order>[
    Order(number: 10482, total: 11900, date: DateTime(2026, 11, 23), status: OrderStatus.onTheWay, itemsCount: 4, etaMinutes: 25),
    Order(number: 10377, total: 8300, date: DateTime(2026, 11, 12), status: OrderStatus.delivered, itemsCount: 3),
    Order(number: 10214, total: 15000, date: DateTime(2026, 10, 28), status: OrderStatus.delivered, itemsCount: 1),
  ];

  static const reviews = <Review>[
    Review(
      author: 'Динара',
      rating: 5,
      daysAgo: 2,
      photos: 2,
      text: LocalizedText(
        'Очень нежный медовик, не приторный. Заказывали на день рождения — гости попросили контакты пекарни.',
        'Өте нәзік медовик, тым тәтті емес. Туған күнге тапсырыс бердік — қонақтар наубайхананың байланысын сұрады.',
      ),
    ),
    Review(
      author: 'Ерлан',
      rating: 4,
      daysAgo: 7,
      text: LocalizedText(
        'Доставили вовремя, коробка аккуратная. Хотелось бы больше вариантов размера.',
        'Уақытында жеткізді, қорабы ұқыпты. Өлшемнің көбірек нұсқасы болса екен.',
      ),
    ),
    Review(
      author: 'Асель',
      rating: 5,
      daysAgo: 12,
      text: LocalizedText('Беру уже третий раз, всегда свежий.', 'Үшінші рет алып тұрмын, әрқашан жаңа.'),
    ),
  ];

  static const ratingDistribution = <int, double>{5: .82, 4: .12, 3: .04, 2: .01, 1: .01};

  static const user = UserProfile(
    name: LocalizedText('Айгерим', 'Әйгерім'),
    phone: '+77071234567',
    bonus: 1250,
    address: Address(street: LocalizedText('ул. Абая, 52', 'Абай к-сі, 52'), apartment: '24', floor: '5'),
  );

  static const freeDeliveryFrom = 10000;
  static const deliveryFee = 900;
  static const bonusWriteOff = 500;
}
