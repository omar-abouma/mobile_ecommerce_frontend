import 'package:flutter/material.dart';
import 'item_detail_page.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Glass',
    'Plates',
    'Dishes',
    'Cups',
    'Spoons',
    'Trays',
    'Others',
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';

  final Map<String, List<Map<String, dynamic>>> _itemsByCategory = {
    'Glass': [
      {
        'name': 'Wine Glass',
        'price': 3500,
        'image': 'assets/items/glass.jpg',
        'description': 'High-quality wine glass, perfect for parties and home.'
      },
      {
        'name': 'Juice Tumbler',
        'price': 4500,
        'image': 'assets/items/tumbler.jpg',
        'description': 'Durable juice tumbler, ideal for daily use.'
      },
    ],
    'Plates': [
      {
        'name': 'Dinner Plate',
        'price': 3000,
        'image': 'assets/items/plate.jpg',
        'description': 'Strong dinner plate, perfect for home and restaurants.'
      },
      {
        'name': 'Soup Plate',
        'price': 3500,
        'image': 'assets/items/soup_plate.jpg',
        'description': 'Deep soup plate for all types of soups and stews.'
      },
    ],
    'Dishes': [
      {
        'name': 'Serving Dish',
        'price': 4000,
        'image': 'assets/items/dish.jpg',
        'description': 'Elegant serving dish for special occasions.'
      },
      {
        'name': 'Baking Dish',
        'price': 5000,
        'image': 'assets/items/baking_dish.jpg',
        'description': 'Heat-resistant baking dish for oven use.'
      },
    ],
    'Cups': [
      {
        'name': 'Coffee Cup',
        'price': 2500,
        'image': 'assets/items/cup.jpg',
        'description': 'Ceramic coffee cup, ideal for coffee lovers.'
      },
      {
        'name': 'Tea Cup',
        'price': 2000,
        'image': 'assets/items/tea_cup.jpg',
        'description': 'Delicate tea cup for afternoon tea.'
      },
    ],
    'Spoons': [
      {
        'name': 'Silver Spoon',
        'price': 1500,
        'image': 'assets/items/spoon.jpg',
        'description': 'Elegant silver spoon for dining.'
      },
      {
        'name': 'Wooden Spoon',
        'price': 1000,
        'image': 'assets/items/wood_spoon.jpg',
        'description': 'Eco-friendly wooden spoon for cooking.'
      },
    ],
    'Trays': [
      {
        'name': 'Serving Tray',
        'price': 6000,
        'image': 'assets/items/tray.jpg',
        'description': 'Durable serving tray, suitable for parties.'
      },
    ],
    'Others': [
      {
        'name': 'Cutting Board',
        'price': 2500,
        'image': 'assets/items/board.jpg',
        'description': 'Sturdy cutting board for kitchen use.'
      },
      {
        'name': 'Knife Set',
        'price': 15000,
        'image': 'assets/items/knife.jpg',
        'description': 'Sharp knife set, essential for chefs.'
      },
      {
        'name': 'Cooking Pot',
        'price': 20000,
        'image': 'assets/items/pot.jpg',
        'description': 'Large cooking pot for family meals.'
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allItems =
        _itemsByCategory.values.expand((list) => list).toList();

    final items = _selectedCategory == 'All'
        ? allItems
        : _itemsByCategory[_selectedCategory] ?? [];

    final filteredItems = items
        .where((item) =>
            item['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        backgroundColor: const Color(0xFF0066CC),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          _buildCategoryBar(),
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text('No items found'))
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      itemCount: filteredItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return _buildItemCard(item, context);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: const InputDecoration(
          hintText: 'Search items...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                  child: Text(category,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black))),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ItemDetailPage(item: item)));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                          child: Icon(Icons.image_not_supported)),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('Tsh ${item['price']}',
                        style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600)),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
