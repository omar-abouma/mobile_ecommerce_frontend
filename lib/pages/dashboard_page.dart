import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  String _displayText = '';
  final String _fullText = 'High Quality Services With Better Prices';
  bool _isAnimating = true;

  final List<String> _heroImages = [
    'assets/hero/hero1.jpg',
    'assets/hero/hero2.jpg',
    'assets/hero/hero3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startImageSlider();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _startTextAnimation();
  }

  void _startImageSlider() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        int nextPage = _currentPage + 1;
        if (nextPage >= _heroImages.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startImageSlider();
      }
    });
  }

  void _startTextAnimation() async {
    while (_isAnimating) {
      for (int i = 0; i <= _fullText.length; i++) {
        if (!mounted || !_isAnimating) break;
        setState(() {
          _displayText = _fullText.substring(0, i);
        });
        await Future.delayed(const Duration(milliseconds: 50));
      }

      await Future.delayed(const Duration(seconds: 2));

      for (int i = _fullText.length; i >= 0; i--) {
        if (!mounted || !_isAnimating) break;
        setState(() {
          _displayText = _fullText.substring(0, i);
        });
        await Future.delayed(const Duration(milliseconds: 30));
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  void dispose() {
    _isAnimating = false;
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF0066CC),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(),
            _buildHeroSection(),
            _buildNavigationMenu(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0066CC),
            Colors.blue.shade700,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUtensilIcon(Icons.restaurant, Colors.orange),
              const SizedBox(width: 15),
              _buildUtensilIcon(Icons.kitchen, Colors.white),
              const SizedBox(width: 15),
              _buildUtensilIcon(Icons.local_dining, Colors.orange),
              const SizedBox(width: 15),
              _buildUtensilIcon(Icons.emoji_food_beverage, Colors.white),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Serve Your Expectations',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black26,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Premium Utensils for Professional Kitchens',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUtensilIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.3), width: 2),
      ),
      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _heroImages.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _heroImages[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text('Image not found', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color.fromRGBO(0, 0, 0, 0.6),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  _displayText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_heroImages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? Colors.white
                            : const Color.fromRGBO(255, 255, 255, 0.5),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationMenu() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0066CC),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Manage your utensil business efficiently',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildNavBox(
                icon: Icons.shopping_bag,
                title: 'Items',
                subtitle: 'Manage Products',
                color: Colors.blue,
                onTap: () {
                  Navigator.pushNamed(context, '/items');
                },
              ),
              _buildNavBox(
                icon: Icons.shopping_cart,
                title: 'View Orders',
                subtitle: 'Check Orders',
                color: Colors.green,
                onTap: () {
                  Navigator.pushNamed(context, '/view_orders');
                },
              ),
              _buildNavBox(
                icon: Icons.payment,
                title: 'Payment Report',
                subtitle: 'Financial Reports',
                color: Colors.orange,
                onTap: () {
                  Navigator.pushNamed(context, '/payment_report');
                },
              ),
              _buildNavBox(
                icon: Icons.analytics,
                title: 'Analytics',
                subtitle: 'Business Insights',
                color: Colors.purple,
                onTap: () {
                  _showFeatureDialog('Analytics', 'View business analytics and insights');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavBox({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.alphaBlend(color.withAlpha(25), Colors.white),
                Color.alphaBlend(color.withAlpha(12), Colors.white),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color.alphaBlend(color.withAlpha(51), Colors.white),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeatureDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
