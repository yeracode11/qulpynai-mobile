# Qulpynai — мобильное приложение

Flutter-приложение пекарни Qulpynai для iOS и Android. Сейчас это вёрстка всех экранов из дизайна
«Дизайн мобильного приложения Qulpynai» с заглушками и мок-данными, без реального бэкенда.

## Запуск

```bash
flutter pub get
flutter run                     # на подключённом устройстве / симуляторе
flutter test                    # smoke-тесты: каждый экран на 390×844, RU и KZ
```

Флаги для сборки:

| Флаг | Что делает |
|---|---|
| `--dart-define=HOME_VARIANT=bento\|catalog\|editorial` | какой из трёх вариантов главной открыть (1a / 1b / 1c) |
| `--dart-define=DEV_MENU=true` | показать переключатель вариантов главной в профиле и в release-сборке |

Тестовый код из SMS: **1234**.

## Экраны

| Макет | Маршрут | Файл |
|---|---|---|
| 1f Онбординг · язык | `/onboarding` | `features/onboarding/onboarding_screen.dart` |
| 1g Вход по номеру | `/login` | `features/auth/login_screen.dart` |
| 1h Код из SMS | `/otp` | `features/auth/otp_screen.dart` |
| 1a / 1b / 1c Главная | `/home` | `features/home/home_screen.dart` |
| Меню (плитки из 1b) | `/menu` | `features/menu/menu_screen.dart` |
| 1i Категория | `/menu/category/:id` | `features/menu/category_screen.dart` |
| 1d Карточка товара | `/product/:id` | `features/product/product_screen.dart` |
| 1q Отзывы | `/product/:id/reviews` | `features/product/reviews_screen.dart` |
| 1e Торт на заказ | `/custom-cake` | `features/product/custom_cake_screen.dart` |
| 1j Корзина | `/cart` | `features/cart/cart_screen.dart` |
| 1k Оформление | `/checkout` | `features/checkout/checkout_screen.dart` |
| 1l Оплата | `/payment` | `features/checkout/payment_screen.dart` |
| 1m Карта доставки | `/address` | `features/checkout/address_map_screen.dart` |
| 1n Магазины | `/stores` | `features/stores/stores_screen.dart` |
| 1o Мои заказы | `/profile/orders` | `features/orders/orders_screen.dart` |
| 1p Профиль | `/profile` | `features/profile/profile_screen.dart` |

## Устройство

```
lib/
  app/            MaterialApp, go_router (табы через StatefulShellRoute), плавающий таб-бар
  core/theme/     цвета, шрифты (Lora / Raleway / Gilroy + ₸), тема
  core/widgets/   общие компоненты: кнопки, чипсы, сегменты, карточки товаров, заглушки
  core/state/     язык, вариант главной, доставка/самовывоз (Riverpod)
  data/models/    модели; тексты с бэкенда — LocalizedText (ru + kk)
  data/mock/      мок-данные
  data/repositories/  интерфейсы репозиториев + Mock-реализации (с задержкой 350 мс)
  data/providers.dart Riverpod-провайдеры; здесь мок меняется на реальный API
  features/       экраны по фичам
  l10n/           app_ru.arb (шаблон) и app_kk.arb
```

- **Бэкенд.** Каждый репозиторий — интерфейс с `Mock…`-реализацией. Чтобы подключить API, добавьте
  реализацию и замените её в `data/providers.dart`; экраны менять не нужно.
- **Языки.** Русский и казахский (`kk`). Строки интерфейса — в ARB, тексты товаров — в `LocalizedText`.
  Переключатель RU/KZ на онбординге, в профиле и бейдж «РУС/ҚАЗ» на главной.
- **Корзина** локальная (`features/cart/cart_controller.dart`), при старте заполнена товарами из макета.
- **Заглушки:** карты (2GIS / Яндекс), поиск, избранное, уведомления, поддержка, звонок, маршрут,
  «Повторить заказ», «Оставить отзыв», реальная оплата Kaspi/картой. Нажатие показывает «Заглушка».
- Иконки — Material Icons, близкие к макету. Фото, которых нет, — полосатые плашки как в дизайне.

## Шрифты и ассеты

Основной шрифт — Onest (OFL, Google Fonts): полная поддержка казахской кириллицы (ә, ғ, қ, ң, ө, ұ, ү, һ, і) и знака ₸,
табличные цифры для цен. Из вариативного файла нарезаны статические начертания 400–800 в `assets/fonts`.
Логотип взят из репозитория `qulpynai` (frontend/public).