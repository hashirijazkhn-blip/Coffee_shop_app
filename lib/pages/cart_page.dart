import 'package:flutter/material.dart';
import 'package:myapp/models/coffe.dart';
import 'package:myapp/models/coffee_shop.dart';
import 'package:provider/provider.dart';

import '../components/coffee_tile.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeFromCart(Coffee coffee) {
    Provider.of<CoffeeShop>(context, listen: false).removeItemFromCart(coffee);
  }

  void payNow() {
  final shop = Provider.of<CoffeeShop>(context, listen: false);
  if (shop.userCart.isEmpty) return;

  // Simulate 2 second processing delay
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const AlertDialog(
      backgroundColor: Color(0xFF2D2D2D),
      content: Row(
        children: [
          CircularProgressIndicator(color: Color(0xFFC9A060)),
          SizedBox(width: 20),
          Text('Processing...', style: TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );

  Future.delayed(const Duration(seconds: 2), () {
    Navigator.pop(context); // close processing dialog

    shop.clearCart();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFFC9A060), size: 64),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                color: Color(0xFFE8E0D8),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you for choosing\nPeshawar Bean Lab!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFFC9A060))),
          ),
        ],
      ),
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShop>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text('Your Cart', style: TextStyle(fontSize: 20)),

              Expanded(
                child: ListView.builder(
                  itemCount: value.userCart.length,
                  itemBuilder: (context, index) {
                    Coffee eachCoffee = value.userCart[index];

                    return CoffeeTile(
                      coffee: eachCoffee,
                      onPressed: () => removeFromCart(eachCoffee),
                      icon: Icon(Icons.delete),
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: payNow,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:  const Center(
                    child: Text("Pay Now", style: TextStyle(color: Colors.white)),
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
