// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Qulpynai';

  @override
  String get tabHome => 'Главная';

  @override
  String get tabMenu => 'Меню';

  @override
  String get tabStores => 'Магазины';

  @override
  String get tabProfile => 'Профиль';

  @override
  String cartButton(String count) {
    return 'Корзина, товаров: $count';
  }

  @override
  String get back => 'Назад';

  @override
  String get close => 'Закрыть';

  @override
  String get share => 'Поделиться';

  @override
  String get favorite => 'В избранное';

  @override
  String get filters => 'Фильтры';

  @override
  String get call => 'Позвонить';

  @override
  String get myLocation => 'Моё местоположение';

  @override
  String get onbTitle => 'Свежая выпечка каждое утро';

  @override
  String get onbText => 'Торты, десерты и хлеб из пекарни Qulpynai — с доставкой или самовывозом из ближайшего магазина.';

  @override
  String get start => 'Начать';

  @override
  String get skip => 'Пропустить';

  @override
  String get loginTitle => 'Вход по номеру';

  @override
  String get loginText => 'Отправим SMS с кодом подтверждения';

  @override
  String get phone => 'Номер телефона';

  @override
  String get getCode => 'Получить код';

  @override
  String get terms => 'Продолжая, вы соглашаетесь с условиями оферты и политикой конфиденциальности';

  @override
  String get otpTitle => 'Введите код';

  @override
  String otpSent(String phone) {
    return 'Код отправлен на $phone';
  }

  @override
  String resendIn(String time) {
    return 'Повторно через $time';
  }

  @override
  String get resend => 'Отправить снова';

  @override
  String get changeNumber => 'Изменить номер';

  @override
  String get otpWrong => 'Неверный код. Для теста подойдёт 1234';

  @override
  String get otpHint => 'Тестовый код: 1234';

  @override
  String get delivery => 'Доставка';

  @override
  String get pickup => 'Самовывоз';

  @override
  String get customCake => 'Торт на заказ';

  @override
  String get customShort => 'На заказ';

  @override
  String get customCakeSub => 'Свой размер, начинка и надпись';

  @override
  String get bonuses => 'Бонусы';

  @override
  String get pickupSub => 'Готово через 15 минут';

  @override
  String get hits => 'Хиты недели';

  @override
  String get all => 'Все';

  @override
  String get newBadge => 'Новинка';

  @override
  String get promoTitle => 'Новая коллекция весенних тортов';

  @override
  String get promoCta => 'Смотреть';

  @override
  String get searchHint => 'Торт, десерт, хлеб';

  @override
  String get categories => 'Категории';

  @override
  String greeting(String name) {
    return 'Доброе утро, $name';
  }

  @override
  String get freshToday => 'Сегодня из печи';

  @override
  String freshTime(String time) {
    return 'Испекли в $time';
  }

  @override
  String get addToCart => 'В корзину';

  @override
  String get addedToCart => 'Добавлено в корзину';

  @override
  String get per100 => 'На 100 г продукта';

  @override
  String get kcal => 'ккал';

  @override
  String get protein => 'белки, г';

  @override
  String get fat => 'жиры, г';

  @override
  String get carbs => 'углеводы, г';

  @override
  String get tabComposition => 'Состав';

  @override
  String get tabReviews => 'Отзывы';

  @override
  String get tabStorage => 'Хранение';

  @override
  String get size => 'Размер';

  @override
  String cakeSizeInfo(String diameter, String servings) {
    return 'Ø $diameter см · $servings порций';
  }

  @override
  String get cakePreview => 'превью торта';

  @override
  String get productPhoto => 'фото товара';

  @override
  String get photo => 'фото';

  @override
  String get inscription => 'Надпись на торте';

  @override
  String get inscriptionHint => 'Например: С днём рождения!';

  @override
  String get addons => 'Дополнительно';

  @override
  String get cart => 'Корзина';

  @override
  String get clear => 'Очистить';

  @override
  String get upsell => 'Добавить к заказу';

  @override
  String get subtotal => 'Товары';

  @override
  String get free => 'Бесплатно';

  @override
  String get total => 'Итого';

  @override
  String get checkoutCta => 'Оформить';

  @override
  String get cartEmpty => 'Корзина пуста';

  @override
  String get cartEmptyText => 'Добавьте что-нибудь вкусное из меню';

  @override
  String get toMenu => 'Перейти в меню';

  @override
  String get increase => 'Добавить ещё';

  @override
  String get decrease => 'Убрать одну';

  @override
  String get checkout => 'Оформление';

  @override
  String get whenDeliver => 'Когда доставить';

  @override
  String get asap => 'Как можно скорее';

  @override
  String get today => 'Сегодня';

  @override
  String get tomorrow => 'Завтра';

  @override
  String get recipient => 'Получатель';

  @override
  String get commentHint => 'Комментарий: подъезд 2, домофон 24';

  @override
  String get toPay => 'Перейти к оплате';

  @override
  String get payment => 'Оплата';

  @override
  String get payMethod => 'Способ оплаты';

  @override
  String get kaspiSub => 'QR или счёт в приложении';

  @override
  String get card => 'Банковская карта';

  @override
  String get cardSub => 'Visa, Mastercard';

  @override
  String get pay => 'Оплатить';

  @override
  String get secure => 'Платёж защищён банком';

  @override
  String get useBonus => 'Списать бонусы';

  @override
  String get orderPlaced => 'Заказ оформлен! Это демо: оплата не проводилась';

  @override
  String get mapTitle => 'Адрес доставки';

  @override
  String get mapStub => 'Здесь будет 2GIS / Яндекс Карты';

  @override
  String get inZone => 'Входит в зону доставки';

  @override
  String zoneInfo(String eta, String amount) {
    return '$eta · бесплатно от $amount';
  }

  @override
  String get confirmAddress => 'Подтвердить адрес';

  @override
  String etaRange(String from, String to) {
    return '$from–$to мин';
  }

  @override
  String get orders => 'Мои заказы';

  @override
  String get active => 'Активные';

  @override
  String get history => 'История';

  @override
  String get stAccepted => 'Принят';

  @override
  String get stBaking => 'Готовится';

  @override
  String get stWay => 'В пути';

  @override
  String get stDone => 'Доставлен';

  @override
  String courierEta(String minutes) {
    return 'Курьер будет через $minutes минут';
  }

  @override
  String get repeat => 'Повторить';

  @override
  String get noActiveOrders => 'Активных заказов нет';

  @override
  String get searchStore => 'Найти магазин';

  @override
  String get openNow => 'Открыто сейчас';

  @override
  String get route => 'Маршрут';

  @override
  String openUntil(String time) {
    return 'Открыто до $time';
  }

  @override
  String closesIn(String minutes) {
    return 'Закроется через $minutes мин';
  }

  @override
  String get closed => 'Закрыто';

  @override
  String get bonusCard => 'Бонусная карта';

  @override
  String get bonusHint => '1 бонус = 1 ₸. Начисляем 5% с каждого заказа';

  @override
  String get addresses => 'Мои адреса';

  @override
  String get favorites => 'Избранное';

  @override
  String get language => 'Язык';

  @override
  String get notifications => 'Уведомления';

  @override
  String get support => 'Поддержка';

  @override
  String get homeVariant => 'Вариант главной (dev)';

  @override
  String get reviews => 'Отзывы';

  @override
  String get withPhoto => 'С фото';

  @override
  String get leaveReview => 'Оставить отзыв';

  @override
  String get stub => 'Заглушка: функция появится позже';

  @override
  String get loadError => 'Не удалось загрузить данные';

  @override
  String get retry => 'Повторить';

  @override
  String apartment(String apt, String floor) {
    return 'кв. $apt, этаж $floor';
  }

  @override
  String basedOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count отзыва',
      many: '$count отзывов',
      few: '$count отзыва',
      one: '$count отзыв',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня назад',
      many: '$count дней назад',
      few: '$count дня назад',
      one: '$count день назад',
      zero: 'Сегодня',
    );
    return '$_temp0';
  }
}
