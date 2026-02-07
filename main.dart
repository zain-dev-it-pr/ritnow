// lib/main.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

void main() {
  runApp(const RitNowApp());
}

class RitNowApp extends StatelessWidget {
  const RitNowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RitNow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const SplashScreen(),
    );
  }
}

/* -------------------- Splash Screen -------------------- */
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ServiceLocationPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using Stack so tagline fades in and image zooms.
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0033FF), Color(0xFF001F99), Color(0xFF000D4D)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnim.value,
                child: Transform.scale(
                  scale: _scaleAnim.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Put the logo image in a rounded container
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 6)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/ritnow_logo.jpeg',
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: Colors.white,
                              child: const Center(child: Icon(Icons.local_shipping, size: 60, color: Colors.orange)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      const SizedBox(height: 6),
                      Opacity(
                        opacity: _fadeAnim.value,
                        child: const Text(
                          'in 19 mins',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/* -------------------- Service Location Page -------------------- */
class ServiceLocationPage extends StatelessWidget {
  const ServiceLocationPage({Key? key}) : super(key: key);

  Widget _locationCard(BuildContext context, String title, String asset, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainNavigationPage(location: title)));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 8))],
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Icon(icon, size: 36, color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF001F99))),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF001F99)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locations = [
      {'name': 'Samayapuram', 'asset': 'assets/r5.jpg'},
      {'name': 'Irungalur', 'asset': 'assets/irungalur.jpg'},
      {'name': 'Manachanallur', 'asset': 'assets/Manachanallur.jpg'},
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0033FF), Color(0xFF001F99)]),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 24),
              const Text('Select Your', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.white)),
              const Text('Location', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              Text('Choose your service area', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8))),
              const SizedBox(height: 36),
              Expanded(
                child: ListView.separated(
                  itemCount: locations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final l = locations[index];
                    return _locationCard(context, l['name']!, l['asset']!, Icons.location_city);
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

/* -------------------- Cart Manager -------------------- */
class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  void addItem(Product p) {
    final idx = _items.indexWhere((it) => it.product.name == p.name);
    if (idx != -1) _items[idx].quantity++;
    else _items.add(CartItem(product: p, quantity: 1));
  }

  void removeItem(Product p) {
    _items.removeWhere((it) => it.product.name == p.name);
  }

  void updateQuantity(Product p, int q) {
    final idx = _items.indexWhere((it) => it.product.name == p.name);
    if (idx != -1) {
      if (q > 0) _items[idx].quantity = q;
      else _items.removeAt(idx);
    }
  }

  double get total => _items.fold(0.0, (s, it) => s + it.product.price * it.quantity);

  void clear() => _items.clear();
}

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, required this.quantity});
}

/* -------------------- Main Navigation -------------------- */
class MainNavigationPage extends StatefulWidget {
  final String location;
  const MainNavigationPage({Key? key, required this.location}) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(location: widget.location),
      MartPage(),
      const CartPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)]),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          selectedItemColor: const Color(0xFFFF8C00),
          unselectedItemColor: Colors.grey[600],
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Mart'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          ],
        ),
      ),
    );
  }
}

/* -------------------- Product Model and Sample Data -------------------- */
class Product {
  final String name;
  final double price;
  final String category;
  final String description;
  final String imagePath;

  Product({required this.name, required this.price, required this.category, required this.description, required this.imagePath});
}

final List<Product> sampleProducts = [
  // Grocery
  Product(name: 'Rice - 1kg', price: 45.0, category: 'Grocery', description: 'Premium Basmati Rice', imagePath: 'assets/r6.jpg'),
  Product(name: 'Wheat Flour - 1kg', price: 38.0, category: 'Grocery', description: 'Fresh Wheat Flour', imagePath: 'assets/r7.jpg'),
  Product(name: 'Sugar - 1kg', price: 42.0, category: 'Grocery', description: 'White Sugar', imagePath: 'assets/r8.jpg'),
  Product(name: 'Cooking Oil - 1L', price: 125.0, category: 'Grocery', description: 'Sunflower Oil', imagePath: 'assets/r9.jpg'),
  Product(name: 'Pulses - 500g', price: 85.0, category: 'Grocery', description: 'Mixed Dal', imagePath: 'assets/r10.jpg'),
  Product(name: 'chicken - 1kg', price: 200.0, category: 'Grocery', description: 'delicious chicken', imagePath: 'assets/r11.jpg'),
  Product(name: 'oats - 1kg', price: 399.0, category: 'Grocery', description: 'rolled oats', imagePath: 'assets/r12.jpg'),
  Product(name: 'dates - 1kg', price: 299.0, category: 'Grocery', description: 'ajfan dates', imagePath: 'assets/r13.jpg'),
  Product(name: 'milk 1L', price: 50.0, category: 'Grocery', description: 'Govinds', imagePath: 'assets/r14.jpg'),
  Product(name: 'carrot', price: 85.0, category: 'Grocery', description: 'fresh carrot', imagePath: 'assets/r15.jpg'),

  // Stationary
  Product(name: 'scale 30cm', price: 20.0, category: 'Stationary', description: 'glass scale', imagePath: 'assets/r20.jpg'),
  Product(name: 'geomentry box', price: 60.0, category: 'Stationary', description: 'geomentry box', imagePath: 'assets/r21.jpg'),
  Product(name: 'colour pencils', price: 20.0, category: 'Stationary', description: 'colour pencils', imagePath: 'assets/r23.jpg'),
  Product(name: 'sketchs', price: 50.0, category: 'Stationary', description: 'colour sketch', imagePath: 'assets/r23.jpg'),
  Product(name: 'bag', price: 700.0, category: 'Stationary', description: 'college bag', imagePath: 'assets/r24.jpg'),
  Product(name: 'tap', price: 35.0, category: 'Stationary', description: '5 ich tape', imagePath: 'assets/r25.jpg'),
  Product(name: 'water bottle 1l', price: 200.0, category: 'Stationary', description: 'bottle', imagePath: 'assets/r26.jpg'),
  Product(name: 'keychain', price: 150.0, category: 'Stationary', description: 'keychain', imagePath: 'assets/r27.jpg'),

  // Snacks
  Product(name: 'lays - 100g', price: 20.0, category: 'Snacks', description: 'Potato Chips', imagePath: 'assets/r28.jpg'),
  Product(name: 'Biscuits - 200g', price: 30.0, category: 'Snacks', description: 'Cream Biscuits', imagePath: 'assets/r29.jpg'),
  Product(name: 'Chocolates', price: 50.0, category: 'Snacks', description: 'Assorted Pack', imagePath: 'assets/r30.jpg'),
  Product(name: 'Namkeen - 150g', price: 25.0, category: 'Snacks', description: 'Spicy Mix', imagePath: 'assets/r31.jpg'),
  Product(name: 'diarymilk - 100g', price: 80.0, category: 'Snacks', description: 'diary milk', imagePath: 'assets/r32.jpg'),
  Product(name: 'kurkure - 250g', price: 30.0, category: 'Snacks', description: 'masala munch', imagePath: 'assets/r33.jpg'),
  Product(name: 'cheetos- 300g', price: 50.0, category: 'Snacks', description: 'masala balls', imagePath: 'assets/r34.jpg'),
  Product(name: '5 star -100g', price: 50.0, category: 'Snacks', description: 'choco bar', imagePath: 'assets/r35.jpg'),

  // Clothing
  Product(name: 'T-Shirt levis', price: 299.0, category: 'Clothing', description: 'Cotton Round Neck', imagePath: 'assets/r36.jpg'),
  Product(name: 'Jeans', price: 799.0, category: 'Clothing', description: 'Denim Blue', imagePath: 'assets/r38.jpg'),
  Product(name: 'superdry', price: 499.0, category: 'Clothing', description: 'sweat Shirt', imagePath: 'assets/r37.jpg'),
  Product(name: 'Saree', price: 1200.0, category: 'Clothing', description: 'Silk Saree', imagePath: 'assets/r39.jpg'),
  Product(name: 'formal pant', price: 299.0, category: 'Clothing', description: 'blue slim fit', imagePath: 'assets/r40.jpg'),
  Product(name: 'kerchif', price: 20.0, category: 'Clothing', description: ' Blue', imagePath: 'assets/r41.jpg'),
  Product(name: 'boxers', price: 499.0, category: 'Clothing', description: 'calvin klein', imagePath: 'assets/r42.jpg'),
  Product(name: 'towel', price: 1200.0, category: 'Clothing', description: 'cotton towel', imagePath: 'assets/r43.jpg'),
];

/* -------------------- Home Page -------------------- */
class HomePage extends StatelessWidget {
  final String location;
  const HomePage({Key? key, required this.location}) : super(key: key);

  IconData _iconFor(String category) {
    switch (category) {
      case 'Grocery':
        return Icons.shopping_basket;
      case 'Stationary':
        return Icons.edit;
      case 'Snacks':
        return Icons.fastfood;
      case 'Clothing':
        return Icons.checkroom;
      default:
        return Icons.category;
    }
  }

  Color _colorFor(String category) {
    switch (category) {
      case 'Grocery':
        return const Color(0xFF4CAF50);
      case 'Stationary':
        return const Color(0xFF2196F3);
      case 'Snacks':
        return const Color(0xFFFF9800);
      case 'Clothing':
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }

  String _imageFor(String category) {
    switch (category) {
      case 'Grocery':
        return 'assets/r1.jpg';
      case 'Stationary':
        return 'assets/r2.jpg';
      case 'Snacks':
        return 'assets/r3.jpg';
      case 'Clothing':
        return 'assets/r4.jpg';
      default:
        return 'assets/placeholder.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Grocery', 'Stationary', 'Snacks', 'Clothing'];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [const Color(0xFF0033FF), Colors.grey[100]!], stops: const [0.0, 0.3]),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Hello! 👋', style: TextStyle(fontSize: 22, color: Colors.white.withOpacity(0.95))),
                  const SizedBox(height: 6),
                  const Text('What do you need today?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [const Icon(Icons.location_on, color: Colors.white, size: 16), const SizedBox(width: 6), Text(location, style: const TextStyle(color: Colors.white))]),
                ),
              ]),
            ),

            // Categories grid
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: categories.map((cat) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryProductsPage(category: cat)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(image: AssetImage(_imageFor(cat)), fit: BoxFit.cover, colorFilter: null),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)],
                        ),
                        child: Center(
                          child: Text(cat, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(2, 2))])),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------- Category Products Page (collapsible search) -------------------- */
class CategoryProductsPage extends StatefulWidget {
  final String category;
  const CategoryProductsPage({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late List<Product> _products; // filtered

  @override
  void initState() {
    super.initState();
    _products = sampleProducts.where((p) => p.category == widget.category).toList();
  }

  void _updateSearch(String q) {
    setState(() {
      _products = sampleProducts.where((p) {
        return p.category == widget.category && p.name.toLowerCase().contains(q.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _productCard(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(product.imagePath, width: 70, height: 70, fit: BoxFit.cover)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(product.description, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('₹${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0033FF))),
          ]),
        ),
        IconButton(
          onPressed: () {
            CartManager().addItem(product);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} added to cart'), backgroundColor: const Color(0xFF4CAF50), duration: const Duration(seconds: 1)));
          },
          icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF0033FF)),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.category;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0033FF),
        elevation: 0,
        title: !_isSearching ? Text(title) : TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Search products...', hintStyle: TextStyle(color: Colors.white70), border: InputBorder.none),
          onChanged: _updateSearch,
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _products = sampleProducts.where((p) => p.category == widget.category).toList();
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _products.length,
        itemBuilder: (context, i) => _productCard(_products[i]),
      ),
    );
  }
}

/* -------------------- Mart Page (all products + visible search) -------------------- */
class MartPage extends StatefulWidget {
  const MartPage({Key? key}) : super(key: key);

  @override
  State<MartPage> createState() => _MartPageState();
}

class _MartPageState extends State<MartPage> {
  final TextEditingController _searchController = TextEditingController();
  late List<Product> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = List<Product>.from(sampleProducts);
  }

  void _onSearchChanged(String q) {
    setState(() {
      _filtered = sampleProducts.where((p) => p.name.toLowerCase().contains(q.toLowerCase())).toList();
    });
  }

  Widget _martProductCard(Product p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(p.imagePath, width: 64, height: 64, fit: BoxFit.cover)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(p.category, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 6),
            Text(p.description, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ]),
        ),
        Column(children: [
          Text('₹${p.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0033FF))),
          IconButton(
            onPressed: () {
              CartManager().addItem(p);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p.name} added to cart'), backgroundColor: const Color(0xFF4CAF50), duration: const Duration(seconds: 1)));
            },
            icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF0033FF)),
          ),
        ])
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar kept transparent look like old style
      appBar: AppBar(
        backgroundColor: const Color(0xFF0033FF),
        title: const Text('Grocery Mart'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [const Color(0xFF0033FF), Colors.grey[100]!], stops: const [0.0, 0.3]),
        ),
        child: SafeArea(
          child: Column(children: [
            // Search bar (always visible)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search products across all categories...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),

            // Product list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) => _martProductCard(_filtered[index]),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

/* -------------------- Cart Page (ask for customer details before sending) -------------------- */
class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final String whatsappNumber = '919789675936';
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  Future<void> _sendOrderToWhatsApp() async {
    final cartItems = CartManager().items;
    final total = CartManager().total;
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your cart is empty!')));
      return;
    }

    // If name/email empty -> ask user with modal
    if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter customer details'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            ]),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Save')),
            ],
          );
        },
      );

      if (result != true) return; // canceled
    }

    String orderDetails = "🛍 *New Order Details:*\n\n";
    for (var item in cartItems) {
      orderDetails += "• ${item.product.name} (x${item.quantity}) - ₹${(item.product.price * item.quantity).toStringAsFixed(2)}\n";
    }
    orderDetails += "\n💰 *Total:* ₹${total.toStringAsFixed(2)}";
    orderDetails += "\n\n📍 *Customer Name:* ${_nameController.text.trim()}";
    orderDetails += "\n📧 *Email:* ${_emailController.text.trim()}";

    final encodedMessage = Uri.encodeComponent(orderDetails);
    final whatsappUrl = Uri.parse("https://wa.me/$whatsappNumber?text=$encodedMessage");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening WhatsApp...'), backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open WhatsApp')));
    }
  }

  Widget _buildCartItem(CartItem cartItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(cartItem.product.imagePath, width: 64, height: 64, fit: BoxFit.cover)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(cartItem.product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('₹${cartItem.product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, color: Color(0xFF0033FF))),
          ]),
        ),
        Row(children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (cartItem.quantity > 1) CartManager().updateQuantity(cartItem.product, cartItem.quantity - 1);
                else CartManager().removeItem(cartItem.product);
              });
            },
            icon: const Icon(Icons.remove_circle_outline),
            color: const Color(0xFF0033FF),
          ),
          Text('${cartItem.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: () {
              setState(() => CartManager().updateQuantity(cartItem.product, cartItem.quantity + 1));
            },
            icon: const Icon(Icons.add_circle_outline),
            color: const Color(0xFF0033FF),
          ),
        ])
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager().items;
    final total = CartManager().total;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [const Color(0xFF0033FF), Colors.grey[100]!], stops: const [0.0, 0.25])),
        child: SafeArea(
          child: Column(children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(children: [
                CircleAvatar(radius: 26, backgroundColor: const Color(0xFFFF8C00), child: const Icon(Icons.shopping_cart, size: 28, color: Colors.white)),
                const SizedBox(width: 12),
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Your Cart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 2),
                ]),
              ]),
            ),

            // Cart contents
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                child: cartItems.isEmpty
                    ? Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 20),
                    Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  ]),
                )
                    : ListView.builder(padding: const EdgeInsets.all(8), itemCount: cartItems.length, itemBuilder: (c, i) => _buildCartItem(cartItems[i])),
              ),
            ),

            // Footer - total + place order
            if (cartItems.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)]),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Total Amount:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('₹${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0033FF))),
                  ]),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _sendOrderToWhatsApp,
                      icon: const Icon(Icons.chat, color: Colors.white),
                      label: const Text('Place Order via WhatsApp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  )
                ]),
              )
          ]),
        ),
      ),
    );
  }
}
