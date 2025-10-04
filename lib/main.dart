import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:badges/badges.dart' as badges;
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF2E7D32),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const ElFayoumiApp(),
    ),
  );
}

// ==================== Main App ====================
class ElFayoumiApp extends StatelessWidget {
  const ElFayoumiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عربية الفيومي',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }
}

// ==================== Theme Configuration ====================
class AppTheme {
  // ألوان عربية الفول الشعبية
  static const Color primaryGreen = Color(0xFF2E7D32); // أخضر غامق
  static const Color secondaryRed = Color(0xFFD32F2F); // أحمر
  static const Color accentYellow = Color(0xFFFFC107); // أصفر
  static const Color lightGreen = Color(0xFF81C784); // أخضر فاتح
  static const Color backgroundColor = Color(0xFFFFF8E1); // خلفية دافئة
  static const Color surfaceColor = Colors.white;
  static const Color textPrimary = Color(0xFF1B5E20);
  static const Color textSecondary = Color(0xFF558B2F);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Cairo',
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      secondary: secondaryRed,
      surface: surfaceColor,
      background: backgroundColor,
    ),
    textTheme: GoogleFonts.cairoTextTheme().apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryGreen,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 24),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryRed,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryGreen.withOpacity(0.1), width: 1),
      ),
      color: surfaceColor,
    ),
  );
}

// ==================== Providers ====================
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  void addItem(MenuItem item, int quantity, List<String> additions) {
    _items.add(CartItem(
      item: item,
      quantity: quantity,
      selectedAdditions: additions,
    ));
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void updateQuantity(int index, int quantity) {
    if (quantity > 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (total, item) => total + item.totalPrice);
  }

  int get itemCount {
    return _items.fold(0, (total, item) => total + item.quantity);
  }
}

// ==================== Models ====================
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool isPopular;
  final double rating;
  final int reviews;
  final int preparationTime;
  final List<String> additions;
  final double? discount;
  final String size;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isPopular = false,
    this.rating = 4.5,
    this.reviews = 0,
    this.preparationTime = 5,
    this.additions = const [],
    this.discount,
    this.size = 'عادي',
  });

  double get finalPrice => discount != null ? price * (1 - discount!) : price;
}

class CartItem {
  final MenuItem item;
  int quantity;
  List<String> selectedAdditions;

  CartItem({
    required this.item,
    this.quantity = 1,
    this.selectedAdditions = const [],
  });

  double get totalPrice {
    double additionsPrice = selectedAdditions.length * 1.0; // سعر الإضافات 1 جنيه
    return (item.finalPrice + additionsPrice) * quantity;
  }
}

// ==================== Data ====================
class AppData {
  static final List<MenuItem> allItems = [
    // أصناف الفول
    MenuItem(
      id: '1',
      name: 'فول بالزيت البلدي',
      description: 'فول مدمس على الطريقة البلدية بالزيت البلدي والكمون والليمون',
      price: 5.0,
      category: 'الفول',
      imageUrl: 'https://www.cairo24.com/Upload/libfiles/98/7/439.jpg',
      isPopular: true,
      rating: 4.9,
      reviews: 523,
      preparationTime: 3,
      additions: ['زيت حار', 'طحينة', 'سلطة خضرا', 'ليمون إضافي'],
      size: 'ساندوتش',
    ),
    MenuItem(
      id: '2',
      name: 'فول بالطحينة',
      description: 'فول مدمس غني بالطحينة البيضاء والثوم',
      price: 6.0,
      category: 'الفول',
      imageUrl: 'https://media.elbalad.news/2024/10/large/1061/4/760.jpg',
      rating: 4.8,
      reviews: 412,
      preparationTime: 3,
      additions: ['بصل', 'طماطم', 'فلفل أخضر'],
      size: 'ساندوتش',
    ),
    MenuItem(
      id: '3',
      name: 'فول إسكندراني',
      description: 'فول بالطماطم والثوم والفلفل الحار',
      price: 7.0,
      category: 'الفول',
      imageUrl: 'https://i.ytimg.com/vi/3abd0CMORAE/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLA4TRQ5_VspJXxSufAmc5NFLJ4lCg',
      isPopular: true,
      rating: 4.7,
      reviews: 389,
      preparationTime: 5,
      additions: ['جبنة قديمة', 'بيض مسلوق'],
      discount: 0.15,
      size: 'ساندوتش',
    ),

    // أصناف الطعمية
    MenuItem(
      id: '4',
      name: 'طعمية ساده',
      description: 'طعمية مقرمشة طازجة من الفول المطحون بالخضرة',
      price: 3.0,
      category: 'الطعمية',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0upnGfqJOc59xTeOCSTtS3qBi4yUexlZsJA&s',
      isPopular: true,
      rating: 4.9,
      reviews: 678,
      preparationTime: 5,
      additions: ['طحينة', 'سلطة', 'مخلل'],
      size: 'ساندوتش',
    ),
    MenuItem(
      id: '5',
      name: 'طعمية محشية',
      description: 'طعمية محشية بالفلفل الحار والبصل',
      price: 4.0,
      category: 'الطعمية',
      imageUrl: 'https://img.ananinja.com/media/ninja-catalog-42/restaurants/h5ir7e6spsucy4wrn9llqdkuii35/%D9%82%D8%B1%D8%B5%20%D8%B7%D8%B9%D9%85%D9%8A%D8%A9%20%D8%B3%D8%A7%D8%AF%D8%A9.jpg',
      rating: 4.8,
      reviews: 445,
      preparationTime: 7,
      additions: ['جبنة بيضاء', 'طماطم'],
      size: 'ساندوتش',
    ),

    // أصناف البيض
    MenuItem(
      id: '6',
      name: 'بيض مقلي بلدي',
      description: 'بيض بلدي مقلي بالسمن البلدي',
      price: 8.0,
      category: 'البيض',
      imageUrl: 'https://img-global.cpcdn.com/recipes/73ccefe85f23ddd8/200x200cq80/%D8%A7%D9%84%D8%B5%D9%88%D8%B1%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9-%D9%84%D9%88%D8%B5%D9%81%D8%A9%D8%A8%D9%8A%D8%B6-%D9%85%D9%82%D9%84%D9%8A-%D8%A8%D9%84%D8%B3%D9%85%D9%86-%D8%A7%D9%84%D8%A8%D9%84%D8%AF%D9%8A.jpg',
      rating: 4.6,
      reviews: 234,
      preparationTime: 5,
      additions: ['جبنة', 'بسطرمة'],
      size: 'طبق',
    ),
    MenuItem(
      id: '7',
      name: 'بيض بالبسطرمة',
      description: 'بيض مقلي مع البسطرمة البلدي',
      price: 15.0,
      category: 'البيض',
      imageUrl: 'https://img.ahlmasrnews.com/600x/2021/09/-1632914585-1.jpg',
      isPopular: true,
      rating: 4.8,
      reviews: 356,
      preparationTime: 7,
      size: 'طبق',
    ),

    // الجبن والمقبلات
    MenuItem(
      id: '8',
      name: 'جبنة قريش بالطماطم',
      description: 'جبنة قريش طازجة بالطماطم والنعناع والزيت',
      price: 5.0,
      category: 'الجبن',
      imageUrl: 'https://img-global.cpcdn.com/recipes/aa77d02573231090/1200x630cq80/photo.jpg',
      rating: 4.5,
      reviews: 189,
      preparationTime: 2,
      size: 'طبق',
    ),
    MenuItem(
      id: '9',
      name: 'جبنة قديمة',
      description: 'جبنة قديمة مع الطماطم والفلفل',
      price: 8.0,
      category: 'الجبن',
      imageUrl: 'https://watanimg.elwatannews.com/image_archive/original_lower_quality/12066258311713909669.jpg',
      rating: 4.7,
      reviews: 267,
      preparationTime: 2,
      size: 'ساندوتش',
    ),

    // المشروبات الشعبية
    MenuItem(
      id: '10',
      name: 'ويسكي',
      description: 'ويسكي حلال بنكهة قوية',
      price: 3.0,
      category: 'المشروبات',
      imageUrl: 'https://mediaaws.almasryalyoum.com/news/verylarge/2025/04/10/2649634_0.jpg',
      rating: 4.9,
      reviews: 892,
      preparationTime: 3,
      size: 'كوب كبير',
    ),
    MenuItem(
      id: '11',
      name: 'شاي كشري',
      description: 'شاي أحمر خفيف',
      price: 2.0,
      category: 'المشروبات',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Lipton-mug-tea.jpg/1200px-Lipton-mug-tea.jpg',
      rating: 4.8,
      reviews: 634,
      preparationTime: 2,
      size: 'كوب',
    ),
    MenuItem(
      id: '12',
      name: 'نسكافيه بلبن',
      description: 'نسكافيه ساخن باللبن',
      price: 5.0,
      category: 'المشروبات',
      imageUrl: 'https://modo3.com/thumbs/fit630x300/43584/1434548265/%D8%B7%D8%B1%D9%8A%D9%82%D8%A9_%D8%B9%D9%85%D9%84_%D8%A7%D9%84%D9%86%D8%B3%D9%83%D8%A7%D9%81%D9%8A%D9%87_%D8%A8%D8%A7%D9%84%D8%AD%D9%84%D9%8A%D8%A8.jpg',
      rating: 4.6,
      reviews: 423,
      preparationTime: 3,
      size: 'كوب',
    ),

    // المخللات والسلطات
    MenuItem(
      id: '13',
      name: 'طبق مخلل مشكل',
      description: 'مخلل بلدي (جزر، لفت، خيار، ليمون)',
      price: 3.0,
      category: 'المخللات',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfuXaP1r1lLNgG9U34NLba_v5nABDpZZuYQA&s',
      rating: 4.7,
      reviews: 312,
      preparationTime: 1,
      size: 'طبق',
    ),
    MenuItem(
      id: '14',
      name: 'سلطة خضراء',
      description: 'طماطم، خيار، جرجير، بصل، فلفل أخضر',
      price: 3.0,
      category: 'المخللات',
      imageUrl: 'https://www.khalty.net/cdn/shop/files/42f0a0e052ef6ab9a7d17f721ec96845_w750_h750_600x.jpg?v=1724775449',
      rating: 4.8,
      reviews: 445,
      preparationTime: 2,
      size: 'طبق',
    ),
  ];

  static final List<Map<String, dynamic>> categories = [
    {
      'id': 'all',
      'name': 'الكل',
      'icon': 'https://cdn-icons-png.flaticon.com/512/2927/2927347.png',
      'color': AppTheme.primaryGreen
    },
    {
      'id': 'fool',
      'name': 'الفول',
      'icon': 'https://www.pngall.com/wp-content/uploads/10/Falafel-PNG-Cutout.png',
      'color': AppTheme.primaryGreen
    },
    {
      'id': 'taamia',
      'name': 'الطعمية',
      'icon': 'https://www.pngall.com/wp-content/uploads/10/Falafel-PNG-Images.png',
      'color': AppTheme.accentYellow
    },
    {
      'id': 'eggs',
      'name': 'البيض',
      'icon': 'https://pngimg.com/uploads/egg/egg_PNG5.png',
      'color': AppTheme.secondaryRed
    },
    {
      'id': 'cheese',
      'name': 'الجبن',
      'icon': 'https://cdn-icons-png.flaticon.com/512/3050/3050158.png',
      'color': AppTheme.lightGreen
    },
    {
      'id': 'drinks',
      'name': 'المشروبات',
      'icon': 'https://cdn-icons-png.flaticon.com/512/2935/2935307.png',
      'color': AppTheme.primaryGreen
    },
    {
      'id': 'pickles',
      'name': 'المخللات',
      'icon': 'https://cdn-icons-png.flaticon.com/512/2674/2674065.png',
      'color': AppTheme.accentYellow
    },
  ];

  static final List<Map<String, dynamic>> bannerData = [
    {
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQP5aALbwUE6-jm8oRBtDOP2I-osbKsSLZ7qQ&s',
      'title': 'فطار بلدي أصيل',
      'subtitle': 'من الساعة 5 صباحاً',
      'color': AppTheme.primaryGreen,
    },
    {
      'image': 'https://media.gemini.media/img//large/2019/11/25/2019_11_25_17_41_36_485.jpg',
      'title': 'طعمية ساخنة طازة',
      'subtitle': 'محضرة يومياً',
      'color': AppTheme.accentYellow,
    },
    {
      'image': 'https://i.pinimg.com/736x/6a/c2/b8/6ac2b83c8c19ed0c6fca413a90119508.jpg',
      'title': 'توصيل سريع',
      'subtitle': 'لجميع المناطق',
      'color': AppTheme.secondaryRed,
    },
  ];
}

// ==================== Home Screen ====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String selectedCategory = 'all';
  int _currentBanner = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<MenuItem> get filteredItems {
    if (selectedCategory == 'all') {
      return AppData.allItems;
    }
    return AppData.allItems
        .where((item) => item.category == getCategoryName(selectedCategory))
        .toList();
  }

  String getCategoryName(String id) {
    switch (id) {
      case 'fool': return 'الفول';
      case 'taamia': return 'الطعمية';
      case 'eggs': return 'البيض';
      case 'cheese': return 'الجبن';
      case 'drinks': return 'المشروبات';
      case 'pickles': return 'المخللات';
      default: return 'الكل';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildModernAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                _buildBannerSection(),
                _buildCategoriesSection(),
                _buildPopularSection(),
                _buildMenuSection(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildCartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: AppTheme.primaryGreen,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Pattern
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryGreen,
                    AppTheme.primaryGreen.withOpacity(0.8),
                    AppTheme.lightGreen.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            // Pattern Overlay
            Positioned.fill(
              child: CustomPaint(
                painter: PatternPainter(),
              ),
            ),
            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _animation.value,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    'https://mir-s3-cdn-cf.behance.net/projects/404/9e744862823523.Y3JvcCwyNTgxLDIwMjAsMCw2.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Colors.white,
                                    AppTheme.accentYellow.withOpacity(0.9),
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'عربية الفيومي',
                                  style: GoogleFonts.cairo(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentYellow.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'أصل الفطار المصري 🍳',
                                  style: GoogleFonts.cairo(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.notifications_active,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: AppTheme.secondaryRed,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: AppTheme.primaryGreen,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'التوصيل إلى',
                                  style: GoogleFonts.cairo(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                Text(
                                  'شارع الجمهورية - المنزل',
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  size: 14,
                                  color: AppTheme.successColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '15-20 د',
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.successColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final hour = DateTime.now().hour;
    String greeting;
    IconData greetingIcon;

    if (hour < 12) {
      greeting = 'صباح الخير ☀️';
      greetingIcon = Icons.wb_sunny;
    } else if (hour < 18) {
      greeting = 'مساء الخير 🌤️';
      greetingIcon = Icons.wb_cloudy;
    } else {
      greeting = 'مساء الخير 🌙';
      greetingIcon = Icons.nightlight_round;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightGreen.withOpacity(0.3),
            AppTheme.accentYellow.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentYellow.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              greetingIcon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'اطلب فطارك دلوقتي وهيوصلك ساخن',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            viewportFraction: 0.92,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              setState(() {
                _currentBanner = index;
              });
            },
          ),
          items: AppData.bannerData.map((banner) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: banner['color'].withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: banner['image'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.dividerColor,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            banner['color'].withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              banner['title'],
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: banner['color'],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner['subtitle'],
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _currentBanner,
          count: AppData.bannerData.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: AppTheme.primaryGreen,
            dotColor: AppTheme.dividerColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: AppData.categories.length,
        itemBuilder: (context, index) {
          final category = AppData.categories[index];
          final isSelected = selectedCategory == category['id'];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category['id'];
              });
            },
            child: Container(
              width: 90,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isSelected ? 70 : 60,
                    height: isSelected ? 70 : 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? category['color']
                          : AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? category['color']
                            : AppTheme.dividerColor,
                        width: isSelected ? 3 : 2,
                      ),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: category['color'].withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CachedNetworkImage(
                        imageUrl: category['icon'],
                        color: isSelected ? Colors.white : category['color'],
                        errorWidget: (context, url, error) => Icon(
                          Icons.restaurant,
                          color: isSelected ? Colors.white : category['color'],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'],
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected
                          ? category['color']
                          : AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularSection() {
    final popularItems = AppData.allItems.where((item) => item.isPopular).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryRed,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'الأكثر طلباً 🔥',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'عرض الكل',
                  style: GoogleFonts.cairo(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: popularItems.length,
            itemBuilder: (context, index) {
              return _buildPopularItemCard(popularItems[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularItemCard(MenuItem item) {
    return GestureDetector(
      onTap: () => _showItemDetails(item),
      child: Container(
        width: 190,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryGreen.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (item.discount != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'خصم ${(item.discount! * 100).toInt()}%',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: AppTheme.accentYellow,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${item.rating}',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.size,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.discount != null)
                            Text(
                              '${item.price.toStringAsFixed(0)} جنيه',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Row(
                            children: [
                              Text(
                                '${item.finalPrice.toStringAsFixed(0)}',
                                style: GoogleFonts.cairo(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                              Text(
                                ' جنيه',
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _quickAddToCart(item),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryRed,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.secondaryRed.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.accentYellow,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'قائمة الأصناف',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            return _buildMenuItem(filteredItems[index]);
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return GestureDetector(
      onTap: () => _showItemDetails(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accentYellow.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.lightGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.size,
                            style: GoogleFonts.cairo(
                              fontSize: 11,
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${item.finalPrice.toStringAsFixed(0)}',
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            Text(
                              ' جنيه',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => _quickAddToCart(item),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryRed,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.secondaryRed.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.add_shopping_cart,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'أضف',
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartButton() {
    final cartProvider = Provider.of<CartProvider>(context);

    if (cartProvider.itemCount == 0) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryRed,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          shadowColor: AppTheme.secondaryRed.withOpacity(0.4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${cartProvider.itemCount}',
                style: GoogleFonts.cairo(
                  color: AppTheme.secondaryRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.shopping_cart, size: 20),
            const SizedBox(width: 8),
            Text(
              'السلة',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 2,
              height: 20,
              color: Colors.white30,
            ),
            Text(
              '${cartProvider.totalPrice.toStringAsFixed(0)} جنيه',
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _quickAddToCart(MenuItem item) {
    context.read<CartProvider>().addItem(item, 1, []);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'تم إضافة ${item.name} للسلة',
              style: GoogleFonts.cairo(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showItemDetails(MenuItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ItemDetailsSheet(item: item),
    );
  }
}

// Pattern Painter for AppBar
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    for (double i = 0; i < size.width; i += 30) {
      for (double j = 0; j < size.height; j += 30) {
        canvas.drawCircle(Offset(i, j), 3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ==================== Item Details Sheet ====================
class ItemDetailsSheet extends StatefulWidget {
  final MenuItem item;

  const ItemDetailsSheet({Key? key, required this.item}) : super(key: key);

  @override
  State<ItemDetailsSheet> createState() => _ItemDetailsSheetState();
}

class _ItemDetailsSheetState extends State<ItemDetailsSheet> {
  int quantity = 1;
  Set<String> selectedAdditions = {};

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double totalPrice = widget.item.finalPrice + (selectedAdditions.length * 1.0);
    totalPrice *= quantity;

    return Container(
      height: size.height * 0.85,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryGreen.withOpacity(0.2),
            width: 2,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.item.imageUrl,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        if (widget.item.discount != null)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryRed,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'خصم ${(widget.item.discount! * 100).toInt()}%',
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.name,
                              style: GoogleFonts.cairo(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              widget.item.size,
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.lightGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: AppTheme.primaryGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.item.preparationTime} دقيقة',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 18,
                        color: AppTheme.accentYellow,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.item.rating}',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${widget.item.reviews} تقييم)',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGreen.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      widget.item.description,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  if (widget.item.additions.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppTheme.accentYellow,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'الإضافات',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '+1 جنيه للإضافة',
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: AppTheme.secondaryRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.item.additions.map((addition) {
                        final isSelected = selectedAdditions.contains(addition);
                        return FilterChip(
                          label: Text(
                            addition,
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedAdditions.add(addition);
                              } else {
                                selectedAdditions.remove(addition);
                              }
                            });
                          },
                          selectedColor: AppTheme.primaryGreen,
                          backgroundColor: AppTheme.surfaceColor,
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.primaryGreen
                                : AppTheme.dividerColor,
                          ),
                          checkmarkColor: Colors.white,
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.primaryGreen.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: quantity > 1
                                ? () => setState(() => quantity--)
                                : null,
                            icon: Icon(
                              Icons.remove_circle,
                              color: quantity > 1
                                  ? AppTheme.secondaryRed
                                  : AppTheme.dividerColor,
                            ),
                          ),
                          Container(
                            constraints: const BoxConstraints(minWidth: 60),
                            child: Text(
                              '$quantity',
                              style: GoogleFonts.cairo(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => quantity++),
                            icon: Icon(
                              Icons.add_circle,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              border: Border(
                top: BorderSide(
                  color: AppTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'الإجمالي',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${totalPrice.toStringAsFixed(0)}',
                            style: GoogleFonts.cairo(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          Text(
                            ' جنيه',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartProvider>().addItem(
                          widget.item,
                          quantity,
                          selectedAdditions.toList(),
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  'تم إضافة ${widget.item.name} للسلة',
                                  style: GoogleFonts.cairo(color: Colors.white),
                                ),
                              ],
                            ),
                            backgroundColor: AppTheme.successColor,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: AppTheme.secondaryRed,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart_checkout, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'أضف للسلة',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Cart Screen ====================
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'السلة',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryGreen,
      ),
      body: cartProvider.items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.lightGreen.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: AppTheme.primaryGreen.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'السلة فاضية',
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'اطلب دلوقتي وهيوصلك فطارك ساخن',
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: Text(
                'ارجع للقائمة',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryGreen.withOpacity(0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: item.item.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.item.name,
                                style: GoogleFonts.cairo(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              if (item.selectedAdditions.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.backgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.selectedAdditions.join(' • '),
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.backgroundColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppTheme.primaryGreen.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (item.quantity > 1) {
                                              cartProvider.updateQuantity(
                                                index,
                                                item.quantity - 1,
                                              );
                                            } else {
                                              cartProvider.removeItem(index);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.remove,
                                              size: 18,
                                              color: AppTheme.secondaryRed,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Text(
                                            '${item.quantity}',
                                            style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            cartProvider.updateQuantity(
                                              index,
                                              item.quantity + 1,
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.add,
                                              size: 18,
                                              color: AppTheme.primaryGreen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        '${item.totalPrice.toStringAsFixed(0)}',
                                        style: GoogleFonts.cairo(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryGreen,
                                        ),
                                      ),
                                      Text(
                                        ' جنيه',
                                        style: GoogleFonts.cairo(
                                          fontSize: 12,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => cartProvider.removeItem(index),
                          icon: Icon(
                            Icons.delete_outline,
                            color: AppTheme.secondaryRed.withOpacity(0.7),
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              border: Border(
                top: BorderSide(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  width: 2,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGreen.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'إجمالي الطلب',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${cartProvider.totalPrice.toStringAsFixed(0)}',
                              style: GoogleFonts.cairo(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            Text(
                              ' جنيه',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _showSuccessDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: AppTheme.secondaryRed,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'أكد الطلب',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppTheme.successColor,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'تم استلام طلبك! 🎉',
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'جاري تحضير الطلب',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'هيوصلك خلال 10-15 دقيقة',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.read<CartProvider>().clearCart();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  'تمام',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}