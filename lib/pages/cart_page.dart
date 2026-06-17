import 'package:flutter/material.dart';
import 'package:myapp/models/coffe.dart';
import 'package:myapp/models/coffee_shop.dart';
import 'package:myapp/pages/order_screen.dart';
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

  void goToOrder() {
    final shop = Provider.of<CoffeeShop>(context, listen: false);
    if (shop.userCart.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OrderScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShop>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Text('Your Cart', style: TextStyle(fontSize: 20)),

              Expanded(
                child: value.userCart.isEmpty
                    ? const Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: value.userCart.length,
                        itemBuilder: (context, index) {
                          Coffee eachCoffee = value.userCart[index];
                          return CoffeeTile(
                            coffee: eachCoffee,
                            onPressed: () => removeFromCart(eachCoffee),
                            icon: const Icon(Icons.delete),
                          );
                        },
                      ),
              ),

              GestureDetector(
                onTap: goToOrder,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: value.userCart.isEmpty
                        ? Colors.brown.withOpacity(0.4)
                        : Colors.brown,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Proceed to Order',
                      style: TextStyle(color: Colors.white),
                    ),
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