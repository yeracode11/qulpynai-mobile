import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('kk'), Locale('ru')];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Qulpynai'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get tabHome;

  /// No description provided for @tabMenu.
  ///
  /// In ru, this message translates to:
  /// **'Меню'**
  String get tabMenu;

  /// No description provided for @tabStores.
  ///
  /// In ru, this message translates to:
  /// **'Магазины'**
  String get tabStores;

  /// No description provided for @tabProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get tabProfile;

  /// No description provided for @cartButton.
  ///
  /// In ru, this message translates to:
  /// **'Корзина, товаров: {count}'**
  String cartButton(String count);

  /// No description provided for @back.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get back;

  /// No description provided for @close.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get close;

  /// No description provided for @share.
  ///
  /// In ru, this message translates to:
  /// **'Поделиться'**
  String get share;

  /// No description provided for @favorite.
  ///
  /// In ru, this message translates to:
  /// **'В избранное'**
  String get favorite;

  /// No description provided for @filters.
  ///
  /// In ru, this message translates to:
  /// **'Фильтры'**
  String get filters;

  /// No description provided for @call.
  ///
  /// In ru, this message translates to:
  /// **'Позвонить'**
  String get call;

  /// No description provided for @myLocation.
  ///
  /// In ru, this message translates to:
  /// **'Моё местоположение'**
  String get myLocation;

  /// No description provided for @onbTitle.
  ///
  /// In ru, this message translates to:
  /// **'Свежая выпечка каждое утро'**
  String get onbTitle;

  /// No description provided for @onbText.
  ///
  /// In ru, this message translates to:
  /// **'Торты, десерты и хлеб из пекарни Qulpynai — с доставкой или самовывозом из ближайшего магазина.'**
  String get onbText;

  /// No description provided for @start.
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get start;

  /// No description provided for @skip.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get skip;

  /// No description provided for @loginTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход по номеру'**
  String get loginTitle;

  /// No description provided for @loginText.
  ///
  /// In ru, this message translates to:
  /// **'Отправим SMS с кодом подтверждения'**
  String get loginText;

  /// No description provided for @phone.
  ///
  /// In ru, this message translates to:
  /// **'Номер телефона'**
  String get phone;

  /// No description provided for @getCode.
  ///
  /// In ru, this message translates to:
  /// **'Получить код'**
  String get getCode;

  /// No description provided for @terms.
  ///
  /// In ru, this message translates to:
  /// **'Продолжая, вы соглашаетесь с условиями оферты и политикой конфиденциальности'**
  String get terms;

  /// No description provided for @otpTitle.
  ///
  /// In ru, this message translates to:
  /// **'Введите код'**
  String get otpTitle;

  /// No description provided for @otpSent.
  ///
  /// In ru, this message translates to:
  /// **'Код отправлен на {phone}'**
  String otpSent(String phone);

  /// No description provided for @resendIn.
  ///
  /// In ru, this message translates to:
  /// **'Повторно через {time}'**
  String resendIn(String time);

  /// No description provided for @resend.
  ///
  /// In ru, this message translates to:
  /// **'Отправить снова'**
  String get resend;

  /// No description provided for @changeNumber.
  ///
  /// In ru, this message translates to:
  /// **'Изменить номер'**
  String get changeNumber;

  /// No description provided for @otpWrong.
  ///
  /// In ru, this message translates to:
  /// **'Неверный код. Для теста подойдёт 1234'**
  String get otpWrong;

  /// No description provided for @otpHint.
  ///
  /// In ru, this message translates to:
  /// **'Тестовый код: 1234'**
  String get otpHint;

  /// No description provided for @delivery.
  ///
  /// In ru, this message translates to:
  /// **'Доставка'**
  String get delivery;

  /// No description provided for @pickup.
  ///
  /// In ru, this message translates to:
  /// **'Самовывоз'**
  String get pickup;

  /// No description provided for @customCake.
  ///
  /// In ru, this message translates to:
  /// **'Торт на заказ'**
  String get customCake;

  /// No description provided for @customShort.
  ///
  /// In ru, this message translates to:
  /// **'На заказ'**
  String get customShort;

  /// No description provided for @customCakeSub.
  ///
  /// In ru, this message translates to:
  /// **'Свой размер, начинка и надпись'**
  String get customCakeSub;

  /// No description provided for @bonuses.
  ///
  /// In ru, this message translates to:
  /// **'Бонусы'**
  String get bonuses;

  /// No description provided for @pickupSub.
  ///
  /// In ru, this message translates to:
  /// **'Готово через 15 минут'**
  String get pickupSub;

  /// No description provided for @hits.
  ///
  /// In ru, this message translates to:
  /// **'Хиты недели'**
  String get hits;

  /// No description provided for @all.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get all;

  /// No description provided for @newBadge.
  ///
  /// In ru, this message translates to:
  /// **'Новинка'**
  String get newBadge;

  /// No description provided for @promoTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая коллекция весенних тортов'**
  String get promoTitle;

  /// No description provided for @promoCta.
  ///
  /// In ru, this message translates to:
  /// **'Смотреть'**
  String get promoCta;

  /// No description provided for @searchHint.
  ///
  /// In ru, this message translates to:
  /// **'Торт, десерт, хлеб'**
  String get searchHint;

  /// No description provided for @categories.
  ///
  /// In ru, this message translates to:
  /// **'Категории'**
  String get categories;

  /// No description provided for @greeting.
  ///
  /// In ru, this message translates to:
  /// **'Доброе утро, {name}'**
  String greeting(String name);

  /// No description provided for @freshToday.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня из печи'**
  String get freshToday;

  /// No description provided for @freshTime.
  ///
  /// In ru, this message translates to:
  /// **'Испекли в {time}'**
  String freshTime(String time);

  /// No description provided for @addToCart.
  ///
  /// In ru, this message translates to:
  /// **'В корзину'**
  String get addToCart;

  /// No description provided for @addedToCart.
  ///
  /// In ru, this message translates to:
  /// **'Добавлено в корзину'**
  String get addedToCart;

  /// No description provided for @per100.
  ///
  /// In ru, this message translates to:
  /// **'На 100 г продукта'**
  String get per100;

  /// No description provided for @kcal.
  ///
  /// In ru, this message translates to:
  /// **'ккал'**
  String get kcal;

  /// No description provided for @protein.
  ///
  /// In ru, this message translates to:
  /// **'белки, г'**
  String get protein;

  /// No description provided for @fat.
  ///
  /// In ru, this message translates to:
  /// **'жиры, г'**
  String get fat;

  /// No description provided for @carbs.
  ///
  /// In ru, this message translates to:
  /// **'углеводы, г'**
  String get carbs;

  /// No description provided for @tabComposition.
  ///
  /// In ru, this message translates to:
  /// **'Состав'**
  String get tabComposition;

  /// No description provided for @tabReviews.
  ///
  /// In ru, this message translates to:
  /// **'Отзывы'**
  String get tabReviews;

  /// No description provided for @tabStorage.
  ///
  /// In ru, this message translates to:
  /// **'Хранение'**
  String get tabStorage;

  /// No description provided for @size.
  ///
  /// In ru, this message translates to:
  /// **'Размер'**
  String get size;

  /// No description provided for @cakeSizeInfo.
  ///
  /// In ru, this message translates to:
  /// **'Ø {diameter} см · {servings} порций'**
  String cakeSizeInfo(String diameter, String servings);

  /// No description provided for @cakePreview.
  ///
  /// In ru, this message translates to:
  /// **'превью торта'**
  String get cakePreview;

  /// No description provided for @productPhoto.
  ///
  /// In ru, this message translates to:
  /// **'фото товара'**
  String get productPhoto;

  /// No description provided for @photo.
  ///
  /// In ru, this message translates to:
  /// **'фото'**
  String get photo;

  /// No description provided for @inscription.
  ///
  /// In ru, this message translates to:
  /// **'Надпись на торте'**
  String get inscription;

  /// No description provided for @inscriptionHint.
  ///
  /// In ru, this message translates to:
  /// **'Например: С днём рождения!'**
  String get inscriptionHint;

  /// No description provided for @addons.
  ///
  /// In ru, this message translates to:
  /// **'Дополнительно'**
  String get addons;

  /// No description provided for @cart.
  ///
  /// In ru, this message translates to:
  /// **'Корзина'**
  String get cart;

  /// No description provided for @clear.
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get clear;

  /// No description provided for @upsell.
  ///
  /// In ru, this message translates to:
  /// **'Добавить к заказу'**
  String get upsell;

  /// No description provided for @subtotal.
  ///
  /// In ru, this message translates to:
  /// **'Товары'**
  String get subtotal;

  /// No description provided for @free.
  ///
  /// In ru, this message translates to:
  /// **'Бесплатно'**
  String get free;

  /// No description provided for @total.
  ///
  /// In ru, this message translates to:
  /// **'Итого'**
  String get total;

  /// No description provided for @checkoutCta.
  ///
  /// In ru, this message translates to:
  /// **'Оформить'**
  String get checkoutCta;

  /// No description provided for @cartEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Корзина пуста'**
  String get cartEmpty;

  /// No description provided for @cartEmptyText.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте что-нибудь вкусное из меню'**
  String get cartEmptyText;

  /// No description provided for @toMenu.
  ///
  /// In ru, this message translates to:
  /// **'Перейти в меню'**
  String get toMenu;

  /// No description provided for @increase.
  ///
  /// In ru, this message translates to:
  /// **'Добавить ещё'**
  String get increase;

  /// No description provided for @decrease.
  ///
  /// In ru, this message translates to:
  /// **'Убрать одну'**
  String get decrease;

  /// No description provided for @checkout.
  ///
  /// In ru, this message translates to:
  /// **'Оформление'**
  String get checkout;

  /// No description provided for @whenDeliver.
  ///
  /// In ru, this message translates to:
  /// **'Когда доставить'**
  String get whenDeliver;

  /// No description provided for @asap.
  ///
  /// In ru, this message translates to:
  /// **'Как можно скорее'**
  String get asap;

  /// No description provided for @today.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In ru, this message translates to:
  /// **'Завтра'**
  String get tomorrow;

  /// No description provided for @recipient.
  ///
  /// In ru, this message translates to:
  /// **'Получатель'**
  String get recipient;

  /// No description provided for @commentHint.
  ///
  /// In ru, this message translates to:
  /// **'Комментарий: подъезд 2, домофон 24'**
  String get commentHint;

  /// No description provided for @toPay.
  ///
  /// In ru, this message translates to:
  /// **'Перейти к оплате'**
  String get toPay;

  /// No description provided for @payment.
  ///
  /// In ru, this message translates to:
  /// **'Оплата'**
  String get payment;

  /// No description provided for @payMethod.
  ///
  /// In ru, this message translates to:
  /// **'Способ оплаты'**
  String get payMethod;

  /// No description provided for @kaspiSub.
  ///
  /// In ru, this message translates to:
  /// **'QR или счёт в приложении'**
  String get kaspiSub;

  /// No description provided for @card.
  ///
  /// In ru, this message translates to:
  /// **'Банковская карта'**
  String get card;

  /// No description provided for @cardSub.
  ///
  /// In ru, this message translates to:
  /// **'Visa, Mastercard'**
  String get cardSub;

  /// No description provided for @pay.
  ///
  /// In ru, this message translates to:
  /// **'Оплатить'**
  String get pay;

  /// No description provided for @secure.
  ///
  /// In ru, this message translates to:
  /// **'Платёж защищён банком'**
  String get secure;

  /// No description provided for @useBonus.
  ///
  /// In ru, this message translates to:
  /// **'Списать бонусы'**
  String get useBonus;

  /// No description provided for @orderPlaced.
  ///
  /// In ru, this message translates to:
  /// **'Заказ оформлен! Это демо: оплата не проводилась'**
  String get orderPlaced;

  /// No description provided for @mapTitle.
  ///
  /// In ru, this message translates to:
  /// **'Адрес доставки'**
  String get mapTitle;

  /// No description provided for @mapStub.
  ///
  /// In ru, this message translates to:
  /// **'Здесь будет 2GIS / Яндекс Карты'**
  String get mapStub;

  /// No description provided for @inZone.
  ///
  /// In ru, this message translates to:
  /// **'Входит в зону доставки'**
  String get inZone;

  /// No description provided for @zoneInfo.
  ///
  /// In ru, this message translates to:
  /// **'{eta} · бесплатно от {amount}'**
  String zoneInfo(String eta, String amount);

  /// No description provided for @confirmAddress.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить адрес'**
  String get confirmAddress;

  /// No description provided for @etaRange.
  ///
  /// In ru, this message translates to:
  /// **'{from}–{to} мин'**
  String etaRange(String from, String to);

  /// No description provided for @orders.
  ///
  /// In ru, this message translates to:
  /// **'Мои заказы'**
  String get orders;

  /// No description provided for @active.
  ///
  /// In ru, this message translates to:
  /// **'Активные'**
  String get active;

  /// No description provided for @history.
  ///
  /// In ru, this message translates to:
  /// **'История'**
  String get history;

  /// No description provided for @stAccepted.
  ///
  /// In ru, this message translates to:
  /// **'Принят'**
  String get stAccepted;

  /// No description provided for @stBaking.
  ///
  /// In ru, this message translates to:
  /// **'Готовится'**
  String get stBaking;

  /// No description provided for @stWay.
  ///
  /// In ru, this message translates to:
  /// **'В пути'**
  String get stWay;

  /// No description provided for @stDone.
  ///
  /// In ru, this message translates to:
  /// **'Доставлен'**
  String get stDone;

  /// No description provided for @courierEta.
  ///
  /// In ru, this message translates to:
  /// **'Курьер будет через {minutes} минут'**
  String courierEta(String minutes);

  /// No description provided for @repeat.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get repeat;

  /// No description provided for @noActiveOrders.
  ///
  /// In ru, this message translates to:
  /// **'Активных заказов нет'**
  String get noActiveOrders;

  /// No description provided for @searchStore.
  ///
  /// In ru, this message translates to:
  /// **'Найти магазин'**
  String get searchStore;

  /// No description provided for @openNow.
  ///
  /// In ru, this message translates to:
  /// **'Открыто сейчас'**
  String get openNow;

  /// No description provided for @route.
  ///
  /// In ru, this message translates to:
  /// **'Маршрут'**
  String get route;

  /// No description provided for @openUntil.
  ///
  /// In ru, this message translates to:
  /// **'Открыто до {time}'**
  String openUntil(String time);

  /// No description provided for @closesIn.
  ///
  /// In ru, this message translates to:
  /// **'Закроется через {minutes} мин'**
  String closesIn(String minutes);

  /// No description provided for @closed.
  ///
  /// In ru, this message translates to:
  /// **'Закрыто'**
  String get closed;

  /// No description provided for @bonusCard.
  ///
  /// In ru, this message translates to:
  /// **'Бонусная карта'**
  String get bonusCard;

  /// No description provided for @bonusHint.
  ///
  /// In ru, this message translates to:
  /// **'1 бонус = 1 ₸. Начисляем 5% с каждого заказа'**
  String get bonusHint;

  /// No description provided for @addresses.
  ///
  /// In ru, this message translates to:
  /// **'Мои адреса'**
  String get addresses;

  /// No description provided for @favorites.
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get favorites;

  /// No description provided for @language.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get notifications;

  /// No description provided for @support.
  ///
  /// In ru, this message translates to:
  /// **'Поддержка'**
  String get support;

  /// No description provided for @homeVariant.
  ///
  /// In ru, this message translates to:
  /// **'Вариант главной (dev)'**
  String get homeVariant;

  /// No description provided for @reviews.
  ///
  /// In ru, this message translates to:
  /// **'Отзывы'**
  String get reviews;

  /// No description provided for @withPhoto.
  ///
  /// In ru, this message translates to:
  /// **'С фото'**
  String get withPhoto;

  /// No description provided for @leaveReview.
  ///
  /// In ru, this message translates to:
  /// **'Оставить отзыв'**
  String get leaveReview;

  /// No description provided for @stub.
  ///
  /// In ru, this message translates to:
  /// **'Заглушка: функция появится позже'**
  String get stub;

  /// No description provided for @loadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить данные'**
  String get loadError;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @apartment.
  ///
  /// In ru, this message translates to:
  /// **'кв. {apt}, этаж {floor}'**
  String apartment(String apt, String floor);

  /// No description provided for @basedOn.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} отзыв} few{{count} отзыва} many{{count} отзывов} other{{count} отзыва}}'**
  String basedOn(int count);

  /// No description provided for @daysAgo.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Сегодня} one{{count} день назад} few{{count} дня назад} many{{count} дней назад} other{{count} дня назад}}'**
  String daysAgo(int count);

  /// No description provided for @undo.
  ///
  /// In ru, this message translates to:
  /// **'Вернуть'**
  String get undo;

  /// No description provided for @goToCart.
  ///
  /// In ru, this message translates to:
  /// **'В корзину'**
  String get goToCart;

  /// No description provided for @cartCleared.
  ///
  /// In ru, this message translates to:
  /// **'Корзина очищена'**
  String get cartCleared;

  /// No description provided for @itemRemoved.
  ///
  /// In ru, this message translates to:
  /// **'Товар удалён'**
  String get itemRemoved;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
