// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'Qulpynai';

  @override
  String get tabHome => 'Басты';

  @override
  String get tabMenu => 'Мәзір';

  @override
  String get tabStores => 'Дүкендер';

  @override
  String get tabProfile => 'Профиль';

  @override
  String cartButton(String count) {
    return 'Себет, тауарлар: $count';
  }

  @override
  String get back => 'Артқа';

  @override
  String get close => 'Жабу';

  @override
  String get share => 'Бөлісу';

  @override
  String get favorite => 'Таңдаулыларға';

  @override
  String get filters => 'Сүзгілер';

  @override
  String get call => 'Қоңырау шалу';

  @override
  String get myLocation => 'Менің орным';

  @override
  String get onbTitle => 'Әр таң сайын жаңа піскен тоқаштар';

  @override
  String get onbText => 'Qulpynai наубайханасының торттары, десерттері мен наны — жеткізумен немесе жақын дүкеннен алып кету.';

  @override
  String get start => 'Бастау';

  @override
  String get skip => 'Өткізу';

  @override
  String get loginTitle => 'Нөмір арқылы кіру';

  @override
  String get loginText => 'Растау коды бар SMS жібереміз';

  @override
  String get phone => 'Телефон нөмірі';

  @override
  String get getCode => 'Код алу';

  @override
  String get terms => 'Жалғастыра отырып, сіз оферта шарттары мен құпиялылық саясатына келісесіз';

  @override
  String get otpTitle => 'Кодты енгізіңіз';

  @override
  String otpSent(String phone) {
    return 'Код $phone нөміріне жіберілді';
  }

  @override
  String resendIn(String time) {
    return 'Қайта жіберу: $time';
  }

  @override
  String get resend => 'Қайта жіберу';

  @override
  String get changeNumber => 'Нөмірді өзгерту';

  @override
  String get otpWrong => 'Код қате. Тест үшін 1234 жарайды';

  @override
  String get otpHint => 'Тест коды: 1234';

  @override
  String get delivery => 'Жеткізу';

  @override
  String get pickup => 'Алып кету';

  @override
  String get customCake => 'Тапсырыспен торт';

  @override
  String get customShort => 'Тапсырыс';

  @override
  String get customCakeSub => 'Өлшемі, салмасы және жазуы өзіңізше';

  @override
  String get bonuses => 'Бонустар';

  @override
  String get pickupSub => '15 минутта дайын';

  @override
  String get hits => 'Апта хиттері';

  @override
  String get all => 'Барлығы';

  @override
  String get newBadge => 'Жаңа';

  @override
  String get promoTitle => 'Көктемгі торттардың жаңа топтамасы';

  @override
  String get promoCta => 'Қарау';

  @override
  String get searchHint => 'Торт, десерт, нан';

  @override
  String get categories => 'Санаттар';

  @override
  String greeting(String name) {
    return 'Қайырлы таң, $name';
  }

  @override
  String get freshToday => 'Бүгін пештен';

  @override
  String freshTime(String time) {
    return '$time-да пісті';
  }

  @override
  String get addToCart => 'Себетке';

  @override
  String get addedToCart => 'Себетке қосылды';

  @override
  String get per100 => '100 г өнімге';

  @override
  String get kcal => 'ккал';

  @override
  String get protein => 'ақуыз, г';

  @override
  String get fat => 'май, г';

  @override
  String get carbs => 'көмірсу, г';

  @override
  String get tabComposition => 'Құрамы';

  @override
  String get tabReviews => 'Пікірлер';

  @override
  String get tabStorage => 'Сақтау';

  @override
  String get size => 'Өлшемі';

  @override
  String cakeSizeInfo(String diameter, String servings) {
    return 'Ø $diameter см · $servings порция';
  }

  @override
  String get cakePreview => 'торт превьюі';

  @override
  String get productPhoto => 'тауар фотосы';

  @override
  String get photo => 'фото';

  @override
  String get inscription => 'Торттағы жазу';

  @override
  String get inscriptionHint => 'Мысалы: Туған күніңмен!';

  @override
  String get addons => 'Қосымша';

  @override
  String get cart => 'Себет';

  @override
  String get clear => 'Тазалау';

  @override
  String get upsell => 'Тапсырысқа қосу';

  @override
  String get subtotal => 'Тауарлар';

  @override
  String get free => 'Тегін';

  @override
  String get total => 'Жиыны';

  @override
  String get checkoutCta => 'Рәсімдеу';

  @override
  String get cartEmpty => 'Себет бос';

  @override
  String get cartEmptyText => 'Мәзірден дәмді бірдеңе қосыңыз';

  @override
  String get toMenu => 'Мәзірге өту';

  @override
  String get increase => 'Тағы қосу';

  @override
  String get decrease => 'Біреуін алып тастау';

  @override
  String get checkout => 'Рәсімдеу';

  @override
  String get whenDeliver => 'Қашан жеткізу';

  @override
  String get asap => 'Мүмкіндігінше тез';

  @override
  String get today => 'Бүгін';

  @override
  String get tomorrow => 'Ертең';

  @override
  String get recipient => 'Алушы';

  @override
  String get commentHint => 'Пікір: 2-кіреберіс, домофон 24';

  @override
  String get toPay => 'Төлемге өту';

  @override
  String get payment => 'Төлем';

  @override
  String get payMethod => 'Төлем тәсілі';

  @override
  String get kaspiSub => 'QR немесе қосымшадағы шот';

  @override
  String get card => 'Банк картасы';

  @override
  String get cardSub => 'Visa, Mastercard';

  @override
  String get pay => 'Төлеу';

  @override
  String get secure => 'Төлемді банк қорғайды';

  @override
  String get useBonus => 'Бонуспен төлеу';

  @override
  String get orderPlaced => 'Тапсырыс рәсімделді! Бұл демо: төлем жүргізілмеді';

  @override
  String get mapTitle => 'Жеткізу мекенжайы';

  @override
  String get mapStub => 'Мұнда 2GIS / Яндекс Карталар болады';

  @override
  String get inZone => 'Жеткізу аймағында';

  @override
  String zoneInfo(String eta, String amount) {
    return '$eta · $amount-ден тегін';
  }

  @override
  String get confirmAddress => 'Мекенжайды растау';

  @override
  String etaRange(String from, String to) {
    return '$from–$to мин';
  }

  @override
  String get orders => 'Менің тапсырыстарым';

  @override
  String get active => 'Белсенді';

  @override
  String get history => 'Тарих';

  @override
  String get stAccepted => 'Қабылданды';

  @override
  String get stBaking => 'Дайындалуда';

  @override
  String get stWay => 'Жолда';

  @override
  String get stDone => 'Жеткізілді';

  @override
  String courierEta(String minutes) {
    return 'Курьер $minutes минутта келеді';
  }

  @override
  String get repeat => 'Қайталау';

  @override
  String get noActiveOrders => 'Белсенді тапсырыстар жоқ';

  @override
  String get searchStore => 'Дүкен іздеу';

  @override
  String get openNow => 'Қазір ашық';

  @override
  String get route => 'Бағыт';

  @override
  String openUntil(String time) {
    return '$time-ге дейін ашық';
  }

  @override
  String closesIn(String minutes) {
    return '$minutes минуттан соң жабылады';
  }

  @override
  String get closed => 'Жабық';

  @override
  String get bonusCard => 'Бонус картасы';

  @override
  String get bonusHint => '1 бонус = 1 ₸. Әр тапсырыстан 5% қайтарамыз';

  @override
  String get addresses => 'Мекенжайларым';

  @override
  String get favorites => 'Таңдаулылар';

  @override
  String get language => 'Тіл';

  @override
  String get notifications => 'Хабарламалар';

  @override
  String get support => 'Қолдау қызметі';

  @override
  String get homeVariant => 'Басты бет нұсқасы (dev)';

  @override
  String get reviews => 'Пікірлер';

  @override
  String get withPhoto => 'Фотомен';

  @override
  String get leaveReview => 'Пікір қалдыру';

  @override
  String get stub => 'Уақытша: функция кейін қосылады';

  @override
  String get loadError => 'Деректерді жүктеу мүмкін болмады';

  @override
  String get retry => 'Қайталау';

  @override
  String apartment(String apt, String floor) {
    return '$apt-пәтер, $floor-қабат';
  }

  @override
  String basedOn(int count) {
    return '$count пікір';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count күн бұрын', zero: 'Бүгін');
    return '$_temp0';
  }
}
