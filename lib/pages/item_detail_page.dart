import 'package:flutter/material.dart';

class ItemDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  String _orderType = 'pcs';
  int _quantity = 1;
  int _total = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  void _calculateTotal() {
    int pcsPrice = widget.item['price'];
    int setPrice = pcsPrice * 6;
    int cartonPrice = setPrice * 8;

    switch (_orderType) {
      case 'pcs':
        _total = pcsPrice * _quantity;
        break;
      case 'set':
        _total = setPrice * _quantity;
        break;
      case 'carton':
        _total = cartonPrice * _quantity;
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int pcsPrice = widget.item['price'];
    int setPrice = pcsPrice * 6;
    int cartonPrice = setPrice * 8;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['name']),
        backgroundColor: const Color(0xFF0066CC),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.item['image'],
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
              return Container(
                  height: 250,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.image_not_supported)));
            }),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.item['name'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Price per pcs: Tsh $pcsPrice',
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Price per set (6 pcs): Tsh $setPrice',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Price per carton (8 sets): Tsh $cartonPrice',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                    Text('Description:',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(widget.item['description'],
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0066CC),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            _showOrderDialog(context);
                          },
                          icon: const Icon(Icons.shopping_cart_checkout),
                          label: const Text('Order Now')),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }

  void _showOrderDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(
              builder: (context, setStateDialog) => AlertDialog(
                    title: const Text('Place Order'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                                labelText: 'Full Name', border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                labelText: 'Phone Number', border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _orderType,
                            items: const [
                              DropdownMenuItem(value: 'pcs', child: Text('Pcs')),
                              DropdownMenuItem(value: 'set', child: Text('Set')),
                              DropdownMenuItem(value: 'carton', child: Text('Carton')),
                            ],
                            onChanged: (value) {
                              setStateDialog(() {
                                _orderType = value!;
                                _calculateTotal();
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: 'Order Type', border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Quantity', border: OutlineInputBorder()),
                            onChanged: (value) {
                              setStateDialog(() {
                                _quantity = int.tryParse(value) ?? 1;
                                _calculateTotal();
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Text('Total: Tsh $_total',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel')),
                      ElevatedButton(
                          onPressed: () {
                            if (_nameController.text.isEmpty ||
                                _phoneController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please enter your name and phone number')));
                              return;
                            }
                            Navigator.pop(context);
                            _showConfirmation(context);
                          },
                          child: const Text('Submit Order'))
                    ],
                  ));
        });
  }

  void _showConfirmation(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Order Placed'),
              content: Text(
                  '$_quantity $_orderType(s) of ${widget.item['name']} ordered by ${_nameController.text} (Phone: ${_phoneController.text}) for Tsh $_total.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'))
              ],
            ));
  }
}
