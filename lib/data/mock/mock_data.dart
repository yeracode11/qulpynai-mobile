import '../models/models.dart';

/// Catalog snapshot from qulpynai.kz (/api/menu, Almaty), 10 categories and
/// 40 products with real photos. Replaced by the API once the backend is connected.
abstract final class MockData {
  static const categories = <Category>[
    Category(id: '30', name: LocalizedText('Торты', 'Торттар'), tone: CategoryTone.red, image: 'assets/images/products/97.jpg'),
    Category(id: '27', name: LocalizedText('Пироги', 'Бәліштер'), tone: CategoryTone.teal, image: 'assets/images/products/32.jpg'),
    Category(id: '23', name: LocalizedText('Десерты', 'Тәттілер'), tone: CategoryTone.cream, image: 'assets/images/products/148.jpg'),
    Category(id: '15', name: LocalizedText('Боксы', 'Бокстар'), tone: CategoryTone.green, image: 'assets/images/products/137.jpg'),
    Category(id: '29', name: LocalizedText('Печенье', 'Печенье'), tone: CategoryTone.white, image: 'assets/images/products/180.jpg'),
    Category(id: '24', name: LocalizedText('Шоколад', 'Шоколад'), tone: CategoryTone.red, image: 'assets/images/products/121.jpg'),
    Category(
      id: '14',
      name: LocalizedText('Хлебные изделия', 'Нан өнімдері'),
      tone: CategoryTone.teal,
      image: 'assets/images/products/189.jpg',
    ),
    Category(id: '18', name: LocalizedText('Пицца', 'Пицца'), tone: CategoryTone.cream, image: 'assets/images/products/153.jpg'),
    Category(id: '26', name: LocalizedText('Выпечка', 'Выпечка'), tone: CategoryTone.green, image: 'assets/images/products/106.jpg'),
    Category(
      id: '25',
      name: LocalizedText('Полуфабрикаты', 'Жартылай дайын өнімдер'),
      tone: CategoryTone.white,
      image: 'assets/images/products/157.jpg',
    ),
  ];

  static const products = <Product>[
    Product(
      id: '97',
      categoryId: '30',
      name: LocalizedText('Шпинатный торт', 'Шпинат торты'),
      price: 8500,
      weightGrams: 1250,
      image: 'assets/images/products/97.jpg',
      description: LocalizedText(
        'Бестселлер! Шпинат - как натуральный краситель добавляется в бисквит для придания насыщеного зеленого цвета, а в сочетание с творожно-сырным кремом он получается очень вкусным. Торт оформлен сезонными фруктами.',
        'Бестселлер! Шпинат табиғи бояғыш ретінде бисквитке қанық жасыл түс беру үшін қосылады, ал сүзбе-ірімшік кремімен үйлескенде өте дәмді болып шығады. Торт маусымдық жемістермен безендірілген.',
      ),
    ),
    Product(
      id: '32',
      categoryId: '27',
      name: LocalizedText('Пирог "Қара қыз"', '«Қара қыз» бәліші'),
      price: 3600,
      weightGrams: 1170,
      image: 'assets/images/products/32.jpg',
      description: LocalizedText(
        'Сочный пирог, с шоколадной пропиткой и посыпкой из фисташек.',
        'Шоколад сіңдірмесі және пісте себіндісі бар шырынды бәліш.',
      ),
    ),
    Product(
      id: '148',
      categoryId: '23',
      name: LocalizedText('Мусс «Манго»', 'Манго мусс'),
      price: 1900,
      weightGrams: 110,
      image: 'assets/images/products/148.jpg',
      isNew: true,
      description: LocalizedText(
        'Мусс с манго — воздушный десерт с тропическим фруктовым пюре.',
        'Манго муссы — тропикалық жеміс пюресі қосылған үлпілдек десерт.',
      ),
    ),
    Product(
      id: '137',
      categoryId: '15',
      name: LocalizedText('Пироженое "Бокс мини тарт"', '"Мини-тарт" жинағы (бокс)'),
      price: 2800,
      weightGrams: 1000,
      image: 'assets/images/products/137.jpg',
      description: LocalizedText(
        'Бокс мини-тартов — набор песочных корзинок с разными начинками. Удобно взять с собой.',
        'Мини-тарт боксы — түрлі салмасы бар құмды қамыр себеттерінің жинағы. Өзіңізбен алып жүруге ыңғайлы.',
      ),
    ),
    Product(
      id: '180',
      categoryId: '29',
      name: LocalizedText('Орешки', 'Классикалық жаңғақша'),
      price: 950,
      weightGrams: 160,
      image: 'assets/images/products/180.jpg',
      description: LocalizedText('Классические орешки со сгущённым молоком', 'Қоюлатылған сүті бар классикалық жаңғақшалар'),
    ),
    Product(
      id: '121',
      categoryId: '24',
      name: LocalizedText('Драже «Клубника-сливки»', '«Құлпынай-кілегей» дражесі'),
      price: 1500,
      weightGrams: 100,
      image: 'assets/images/products/121.jpg',
      description: LocalizedText(
        'Цельная сублимированная клубника в оболочке из бельгийского белого шоколада с нежными сливочными нотками. Изысканный десерт с ярким вкусом, тонким ароматом ванили и аппетитным блеском.',
        'Бельгия ақ шоколадының қабығындағы бүтін сублимацияланған құлпынай, нәзік кілегей реңкімен. Жарқын дәмі, ваниль хош иісі және тәбет ашар жылтыры бар талғампаз десерт.',
      ),
    ),
    Product(
      id: '189',
      categoryId: '14',
      name: LocalizedText('Хлеб батон', 'Батон наны'),
      price: 450,
      weightGrams: 299,
      image: 'assets/images/products/189.jpg',
      description: LocalizedText(
        'Классический батон из пшеничной муки — мягкий мякиш, ровная корочка. Выпекаем каждый день.',
        'Бидай ұнынан пісірілген классикалық батон — жұмсақ жұмсақ, біркелкі қабық. Күн сайын пісіріледі.',
      ),
    ),
    Product(
      id: '153',
      categoryId: '18',
      name: LocalizedText('Пицца «Маргарита»', 'Маргарита пиццасы'),
      price: 3500,
      weightGrams: 587,
      image: 'assets/images/products/153.jpg',
      description: LocalizedText(
        'Пицца «Маргарита» — томатный соус, моцарелла и базилик. Классика без лишнего.',
        '«Маргарита» пиццасы — томат соусы, моцарелла және райхан. Артығы жоқ классика.',
      ),
    ),
    Product(
      id: '106',
      categoryId: '26',
      name: LocalizedText('Круассан сэндвич с курицей', 'Сэндвич круассан тауық етімен'),
      price: 1650,
      weightGrams: 178,
      image: 'assets/images/products/106.jpg',
      description: LocalizedText(
        'Круассан-сэндвич с курицей — слоёный круассан с куриным филе, сыром и свежими овощами.',
        'Тауық етімен круассан-сэндвич — тауық филесі, ірімшік және балғын көкөніс қосылған қатпарлы круассан.',
      ),
    ),
    Product(
      id: '157',
      categoryId: '25',
      name: LocalizedText('Вареники с картофелем (500 г)', 'Варениктер картоппен 500 гр Qulpynai'),
      price: 1700,
      weightGrams: 500,
      image: 'assets/images/products/157.jpg',
      description: LocalizedText(
        'Домашние вареники с картофелем — замороженный полуфабрикат. Упаковка 500 г, варить 5–7 минут.',
        'Картоппен үй варениктері — мұздатылған жартылай фабрикат. 500 г қаптама, 5–7 минут пісіріледі.',
      ),
    ),
    Product(
      id: '88',
      categoryId: '30',
      name: LocalizedText('Торт «Молочная девочка»', '«Аппақ қыз» торты'),
      price: 8200,
      weightGrams: 1128,
      image: 'assets/images/products/88.jpg',
      description: LocalizedText(
        'Многослойные, нежные коржи на основе сгущенного молока, пропитанные нежнейшим кремом пломбир. Очень мягкий, пропитанный торт.',
        'Қоюлатылған сүт негізіндегі көп қабатты, нәзік коржтар, пломбир кремімен әбден сіңірілген. Өте жұмсақ әрі шырынды торт.',
      ),
    ),
    Product(
      id: '39',
      categoryId: '27',
      name: LocalizedText('Черничный пирог', 'Қаражидек бәліші'),
      price: 4750,
      weightGrams: 750,
      image: 'assets/images/products/39.jpg',
      description: LocalizedText(
        'Пирог с черничным джемом на основе творожного мусса.',
        'Сүзбе муссы негізіндегі қаражидек джемі қосылған бәліш.',
      ),
    ),
    Product(
      id: '149',
      categoryId: '23',
      name: LocalizedText('Мусс «Кофе»', 'Мусс кофе'),
      price: 1900,
      weightGrams: 95,
      image: 'assets/images/products/149.jpg',
      description: LocalizedText(
        'Кофейный мусс — воздушный сливочный десерт с насыщенным вкусом кофе.',
        'Кофе муссы — қанық кофе дәмі бар үлпілдек кілегей десерті.',
      ),
    ),
    Product(
      id: '115',
      categoryId: '15',
      name: LocalizedText('Бокс «Тәтті микс»', '«Тәтті микс» жинағы'),
      price: 4000,
      weightGrams: 1000,
      image: 'assets/images/products/115.jpg',
      description: LocalizedText(
        'Сладкий бокс «Тәтті микс» — набор из орешков со сгущёнкой и безе. Готовый подарок к чаю.',
        '«Тәтті микс» боксы — қоюлатылған сүті бар жаңғақшалар мен безе жинағы. Шәйге дайын сыйлық.',
      ),
    ),
    Product(
      id: '181',
      categoryId: '29',
      name: LocalizedText('Орешки шоколадные', 'Шоколадты жаңғақша'),
      price: 950,
      weightGrams: 160,
      image: 'assets/images/products/181.jpg',
      description: LocalizedText('Шоколадные орешки со сгущённым молоком', 'Қоюлатылған сүті бар шоколадты жаңғақшалар'),
    ),
    Product(
      id: '123',
      categoryId: '24',
      name: LocalizedText('Драже «Миндальный»', '«Бадам» дражесі'),
      price: 1500,
      weightGrams: 100,
      image: 'assets/images/products/123.jpg',
      description: LocalizedText(
        'Драже «Миндальный» — нежный миндаль в оболочке из бельгийского молочного и тёмного шоколада с тонким ванильным ароматом. Изысканный вкус и хрустящая текстура в каждой конфете.',
        '«Бадам» дражесі — бельгия сүтті және қара шоколад қабығындағы нәзік бадам, жұмсақ ваниль хош иісімен. Әр кәмпитте талғампаз дәм мен қытырлақ құрылым.',
      ),
    ),
    Product(
      id: '188',
      categoryId: '14',
      name: LocalizedText('Хлеб клюквенный', 'Мүкжидек наны'),
      price: 800,
      weightGrams: 397,
      image: 'assets/images/products/188.jpg',
      description: LocalizedText(
        'Хлеб с клюквой — лёгкая кислинка ягод в мягком мякише. Хорош к сыру и чаю.',
        'Мүкжидек қосылған нан — жұмсақ жұмсақтағы жеңіл жидек қышқылдығы. Ірімшік пен шәйге жарасады.',
      ),
    ),
    Product(
      id: '154',
      categoryId: '18',
      name: LocalizedText('Пицца «Пепперони»', 'Пепперони пиццасы'),
      price: 3500,
      weightGrams: 594,
      image: 'assets/images/products/154.jpg',
      description: LocalizedText(
        'Пицца «Пепперони» — острые ломтики пепперони, моцарелла и томатный соус.',
        '«Пепперони» пиццасы — ащы пепперони тілімдері, моцарелла және томат соусы.',
      ),
    ),
    Product(
      id: '10',
      categoryId: '26',
      name: LocalizedText('Круассан с заварным кремом', 'Қайнақ кремді круассан'),
      price: 950,
      weightGrams: 126,
      image: 'assets/images/products/10.jpg',
      description: LocalizedText(
        'Французская булочка из слоеного теста с заварным кремом внутри.',
        'Қатпарлы қамырдан жасалған, іші заварной креммен толтырылған француз тоқашы.',
      ),
    ),
    Product(
      id: '158',
      categoryId: '25',
      name: LocalizedText('Вареники с картофелем (900 г)', 'Варениктер картоппен 900 гр Qulpynai'),
      price: 2500,
      weightGrams: 900,
      image: 'assets/images/products/158.jpg',
      description: LocalizedText(
        'Домашние вареники с картофелем — замороженный полуфабрикат. Упаковка 900 г, варить 5–7 минут.',
        'Картоппен үй варениктері — мұздатылған жартылай фабрикат. 900 г қаптама, 5–7 минут пісіріледі.',
      ),
    ),
    Product(
      id: '84',
      categoryId: '30',
      name: LocalizedText('Торт «Красный бархат»', '«Қызыл мақпал» торты'),
      price: 7500,
      weightGrams: 1347,
      image: 'assets/images/products/84.jpg',
      description: LocalizedText(
        'Торт на основе пропитанного, влажного, пористого бисквита красного цвета с творожно-сырным кремом.',
        'Сіңірілген, дымқыл, кеуекті қызыл бисквит пен сүзбе-ірімшік кремі негізіндегі торт.',
      ),
    ),
    Product(
      id: '37',
      categoryId: '27',
      name: LocalizedText('Пирог творожный', 'Сүзбе бәліші'),
      price: 3750,
      weightGrams: 1085,
      image: 'assets/images/products/37.jpg',
      description: LocalizedText('Рассыпчатый пирог с прослойкой творога внутри.', 'Ішінде сүзбе қабаты бар үгілмелі бәліш.'),
    ),
    Product(
      id: '150',
      categoryId: '23',
      name: LocalizedText('Мусс «Клубника»', 'Мусс құлпынайлы'),
      price: 1900,
      weightGrams: 123,
      image: 'assets/images/products/150.jpg',
      description: LocalizedText(
        'Клубничный мусс — воздушный десерт на сливках с ягодным пюре.',
        'Құлпынай муссы — кілегейге негізделген үлпілдек десерт, жидек пюресімен.',
      ),
    ),
    Product(
      id: '143',
      categoryId: '15',
      name: LocalizedText('Профитроли Шанхай', 'Шанхай профитролі'),
      price: 2500,
      weightGrams: 193,
      image: 'assets/images/products/143.jpg',
      isNew: true,
      description: LocalizedText(
        'Профитроли «Шанхай» с нежными сливками, клубникой и голубикой. Лёгкий десерт с натуральным вкусом и воздушной текстурой.',
        'Нәзік кілегей, құлпынай және көкжидек қосылған «Шанхай» профитролилері. Табиғи дәмі мен үлпілдек құрылымы бар жеңіл десерт.',
      ),
    ),
    Product(
      id: '179',
      categoryId: '29',
      name: LocalizedText('Орешки микс', 'Жаңғақша (шок & класс)'),
      price: 950,
      weightGrams: 160,
      image: 'assets/images/products/179.jpg',
      description: LocalizedText(
        'Классические и шоколадные орешки со сгущённым молоком',
        'Қоюлатылған сүті бар классикалық және шоколадты жаңғақшалар',
      ),
    ),
    Product(
      id: '124',
      categoryId: '24',
      name: LocalizedText('Драже «Фундук»', '«Орман жаңғағы» дражесі'),
      price: 1500,
      weightGrams: 100,
      image: 'assets/images/products/124.jpg',
      description: LocalizedText(
        'Цельный фундук в глазури из бельгийского молочного шоколада с ванильным акцентом. Хрустящий орех и нежный шоколад — идеальное сочетание для утончённого вкуса.',
        'Бельгия сүтті шоколад глазурындағы бүтін орман жаңғағы, ваниль реңкімен. Қытырлақ жаңғақ пен нәзік шоколад — талғампаз дәмнің тамаша үйлесімі.',
      ),
    ),
    Product(
      id: '110',
      categoryId: '14',
      name: LocalizedText('Хлеб Багет', 'Багет наны'),
      price: 450,
      weightGrams: 243,
      image: 'assets/images/products/110.jpg',
      description: LocalizedText(
        'Французский багет на закваске — тонкая хрустящая корка и воздушный мякиш. Выпекаем каждый день.',
        'Ашытқыға пісірілген француз багеті — жұқа қытырлақ қабығы мен үлпілдек жұмсағы. Күн сайын пісіріледі.',
      ),
    ),
    Product(
      id: '156',
      categoryId: '18',
      name: LocalizedText('Пицца «Куриная»', 'Пицца тауық етімен'),
      price: 3500,
      weightGrams: 594,
      image: 'assets/images/products/156.jpg',
      description: LocalizedText(
        'Пицца с курицей — куриное филе, моцарелла и томатный соус.',
        'Тауық етімен пицца — тауық филесі, моцарелла және томат соусы.',
      ),
    ),
    Product(
      id: '12',
      categoryId: '26',
      name: LocalizedText('Шоколадный круассан', 'Шоколад круассаны'),
      price: 900,
      weightGrams: 143,
      image: 'assets/images/products/12.jpg',
      description: LocalizedText(
        'Настоящий французский круассан - слоеное хрустящее тонкое тесто со 100% сливочным маслом и обильным шоколадом внутри.',
        'Нағыз француз круассаны — 100% сары майға илеген қатпарлы қытырлақ жұқа қамыр, іші шоколадқа толы.',
      ),
    ),
    Product(
      id: '163',
      categoryId: '25',
      name: LocalizedText('Вареники с творогом (500 г)', 'Варениктер сүзбемен 500 гр Qulpynai'),
      price: 1700,
      weightGrams: 500,
      image: 'assets/images/products/163.jpg',
      description: LocalizedText(
        'Домашние вареники с творогом — замороженный полуфабрикат. Упаковка 500 г, варить 5–7 минут.',
        'Сүзбемен үй варениктері — мұздатылған жартылай фабрикат. 500 г қаптама, 5–7 минут пісіріледі.',
      ),
    ),
    Product(
      id: '85',
      categoryId: '30',
      name: LocalizedText('Торт «Клубника»', '«Құлпынай» торты'),
      price: 8000,
      weightGrams: 1195,
      image: 'assets/images/products/85.jpg',
      description: LocalizedText(
        'Торт круглой формы на основе тонких молочных коржов с творожно-сырным кремом и прослойкой из клубничного пюре. Легкая кислинка клубники придает особый вкус.',
        'Жұқа сүт коржтары, сүзбе-ірімшік кремі және құлпынай пюресінің қабаты бар дөңгелек торт. Құлпынайдың жеңіл қышқылдығы ерекше дәм береді.',
      ),
    ),
    Product(
      id: '36',
      categoryId: '27',
      name: LocalizedText('Пирог творожно-ягодный', 'Сүзбе-жидек бәліші'),
      price: 4500,
      weightGrams: 1390,
      image: 'assets/images/products/36.jpg',
      description: LocalizedText(
        'Пирог похожий на чизкейк, с песочным тестом и начинкой из мягкого творога.',
        'Чизкейкке ұқсас бәліш: құмды қамыр мен жұмсақ сүзбе салмасы.',
      ),
    ),
    Product(
      id: '45',
      categoryId: '23',
      name: LocalizedText('Макаронс «Клубника-милкшейк»', '«Құлпынай-милкшейк» макаронсы'),
      price: 750,
      weightGrams: 35,
      image: 'assets/images/products/45.jpg',
      isNew: true,
      description: LocalizedText(
        'Французское пирожное из миндальной муки, хрустящее и нежное одновременно, с начинкой из клубники.',
        'Бадам ұнынан жасалған француз тәттісі — бір мезгілде қытырлақ әрі нәзік, құлпынай салмасымен.',
      ),
    ),
    Product(
      id: '182',
      categoryId: '15',
      name: LocalizedText('Микс булочки', 'Тоқаш микс (үлкен)'),
      price: 1450,
      weightGrams: 508,
      image: 'assets/images/products/182.jpg',
      description: LocalizedText(
        'Ватрушка с творогом мини - 3 шт Булочка с творогом мини - 4 шт Булочка с маком - 3 шт Улитка мини - 4 шт',
        'Сүзбелі мини ватрушка — 3 дана, сүзбелі мини тоқаш — 4 дана, көкнәрлі тоқаш — 3 дана, мини ұлу тоқаш — 4 дана.',
      ),
    ),
    Product(
      id: '113',
      categoryId: '29',
      name: LocalizedText('Бискотти', 'Бискотти'),
      price: 1500,
      weightGrams: 299,
      image: 'assets/images/products/113.jpg',
      description: LocalizedText(
        'Бискотти — сухое итальянское печенье двойной выпечки. Хорошо к кофе и чаю.',
        'Бискотти — екі рет пісірілген құрғақ итальян печеньесі. Кофе мен шәйге жарасады.',
      ),
    ),
    Product(
      id: '112',
      categoryId: '14',
      name: LocalizedText('Хлеб Тартин', 'Тартин наны'),
      price: 600,
      weightGrams: 585,
      image: 'assets/images/products/112.jpg',
      description: LocalizedText(
        'Тартин на закваске — плотный мякиш и толстая хрустящая корка. Долго остаётся свежим.',
        'Ашытқыға пісірілген тартин — тығыз жұмсақ және қалың қытырлақ қабық. Ұзақ уақыт балғын күйінде сақталады.',
      ),
    ),
    Product(
      id: '16',
      categoryId: '26',
      name: LocalizedText('Рогалик со сгущенкой', 'Тәтті рогалик'),
      price: 350,
      weightGrams: 63,
      image: 'assets/images/products/16.jpg',
      description: LocalizedText(
        'Слоеное тесто с варенной сгущенкой внутри. Просто, но вкусно.',
        'Ішінде пісірілген қоюлатылған сүті бар қатпарлы қамыр. Қарапайым, бірақ дәмді.',
      ),
    ),
    Product(
      id: '164',
      categoryId: '25',
      name: LocalizedText('Вареники с творогом (900 г)', 'Варениктер сүзбемен 900 гр Qulpynai'),
      price: 2500,
      weightGrams: 900,
      image: 'assets/images/products/164.jpg',
      description: LocalizedText(
        'Домашние вареники с творогом — замороженный полуфабрикат. Упаковка 900 г, варить 5–7 минут.',
        'Сүзбемен үй варениктері — мұздатылған жартылай фабрикат. 900 г қаптама, 5–7 минут пісіріледі.',
      ),
    ),
    Product(
      id: '94',
      categoryId: '30',
      name: LocalizedText('Торт «Черничный»', '«Қаражидек» торты'),
      price: 8000,
      weightGrams: 1155,
      image: 'assets/images/products/94.jpg',
      description: LocalizedText(
        'Легкий шоколадный бисквит, с кремом творожного сыра и сливок, с добавлением натуральной черники.',
        'Жеңіл шоколад бисквиті, сүзбе ірімшігі мен кілегей кремі, табиғи қаражидек қосылған.',
      ),
    ),
    Product(
      id: '178',
      categoryId: '27',
      name: LocalizedText('Пирог лимонный', 'Лимон бәліші'),
      price: 3900,
      weightGrams: 1045,
      image: 'assets/images/products/178.jpg',
      description: LocalizedText(
        'Лимонный пирог — песочная основа и яркая лимонная начинка с кислинкой.',
        'Лимон бәліші — құмды қамыр негізі және қышқылдау жарқын лимон салмасы.',
      ),
    ),
  ];

  static const promos = <Promo>[
    Promo(
      id: 'spring-cakes',
      title: LocalizedText('Новая коллекция весенних тортов', 'Көктемгі торттардың жаңа топтамасы'),
      subtitle: LocalizedText('Клубника, фисташка и шпинат', 'Құлпынай, пісте және шпинат'),
      image: 'assets/images/baganashil.png',
      imageAlignment: .4,
      link: '/menu/category/30',
    ),
    Promo(
      id: 'pizza',
      title: LocalizedText('Пицца из нашей печи', 'Біздің пештен пицца'),
      subtitle: LocalizedText('Маргарита, пепперони и с курицей — 3 500 ₸', 'Маргарита, пепперони және тауық етімен — 3 500 ₸'),
      image: 'assets/images/products/154.jpg',
      link: '/menu/category/18',
    ),
    Promo(
      id: 'croissants',
      title: LocalizedText('Круассаны каждое утро', 'Күн сайын таңертең круассан'),
      subtitle: LocalizedText('С кремом, шоколадом и сэндвичи', 'Кремді, шоколадты және сэндвич'),
      image: 'assets/images/products/12.jpg',
      link: '/menu/category/26',
    ),
  ];

  static const hitIds = ['97', '88', '84', '148'];
  static const upsellIds = ['45', '16', '180'];

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
