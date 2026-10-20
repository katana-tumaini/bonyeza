import 'package:flutter/material.dart';
import 'package:bonyeza/models/button_design.dart';
import 'package:bonyeza/technical/coin_manager.dart';

class ButtonShopScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ButtonShopScreen({super.key, required this.onBack});

  @override
  State<ButtonShopScreen> createState() => _ButtonShopScreenState();
}

class _ButtonShopScreenState extends State<ButtonShopScreen> {
  int _coins = 0;
  String _selectedButtonId = 'default';
  List<String> _purchasedButtons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final coins = await CoinManager.getCoins();
    final selectedButtonId = await CoinManager.getSelectedButtonId();
    final purchasedButtons = await CoinManager.getPurchasedButtons();

    setState(() {
      _coins = coins;
      _selectedButtonId = selectedButtonId;
      _purchasedButtons = purchasedButtons;
      _isLoading = false;
    });
  }

  Future<void> _purchaseButton(ButtonDesign design) async {
    if (_purchasedButtons.contains(design.id)) return;

    final success = await CoinManager.purchaseButton(design.id, design.cost);
    if (success) {
      setState(() {
        _coins -= design.cost;
        _purchasedButtons.add(design.id);
      });

      // Auto-select the newly purchased button
      await CoinManager.setSelectedButtonId(design.id);
      setState(() {
        _selectedButtonId = design.id;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Purchased ${design.name}!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not enough coins! Need ${design.cost - _coins} more.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _selectButton(ButtonDesign design) async {
    if (!_purchasedButtons.contains(design.id)) return;

    await CoinManager.setSelectedButtonId(design.id);
    setState(() {
      _selectedButtonId = design.id;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${design.name}'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBack,
            color: Colors.black,
          ),
          title: const Text(
            'Button Shop',
            style: TextStyle(
              fontFamily: 'PressStart',
              fontSize: 10,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
          color: Colors.black,
        ),
        title: const Text(
          'Button Shop',
          style: TextStyle(
            fontFamily: 'PressStart',
            fontSize: 10,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.yellow[400],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, size: 18, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  '$_coins',
                  style: const TextStyle(
                    fontFamily: 'PressStart',
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: ButtonDesign.designs.length,
        itemBuilder: (context, index) {
          final design = ButtonDesign.designs[index];
          final isPurchased = _purchasedButtons.contains(design.id);
          final isSelected = _selectedButtonId == design.id;

          return _ButtonDesignCard(
            design: design,
            isPurchased: isPurchased,
            isSelected: isSelected,
            onPurchase: () => _purchaseButton(design),
            onSelect: () => _selectButton(design),
          );
        },
      ),
    );
  }
}

class _ButtonDesignCard extends StatelessWidget {
  final ButtonDesign design;
  final bool isPurchased;
  final bool isSelected;
  final VoidCallback onPurchase;
  final VoidCallback onSelect;

  const _ButtonDesignCard({
    required this.design,
    required this.isPurchased,
    required this.isSelected,
    required this.onPurchase,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey,
          width: isSelected ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: design.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  design.name,
                  style: const TextStyle(
                    fontFamily: 'PressStart',
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  design.description,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                if (isPurchased)
                  ElevatedButton(
                    onPressed: isSelected ? null : onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.green : Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isSelected ? 'Selected' : 'Select',
                      style: const TextStyle(
                        fontFamily: 'PressStart',
                        fontSize: 8,
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: onPurchase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.monetization_on, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${design.cost}',
                          style: const TextStyle(
                            fontFamily: 'PressStart',
                            fontSize: 8,
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
    );
  }
}
