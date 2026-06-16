import 'package:flutter/material.dart';
import 'coffe.dart';

class CoffeeShop extends ChangeNotifier {
  final List<Coffee> _shop = [
    Coffee(
      name: 'Black Coffee',
      price: "RS 800",
      imagePath: "assets/images/coffee.png",
    ),
    Coffee(
      name: 'Latte',
      price: "RS 1000",
      imagePath: "assets/images/latte.png",
    ),
    Coffee(
      name: 'Espresso',
      price: "RS 1500",
      imagePath: "assets/images/espresso.png",
    ),
    Coffee(
      name: 'Iced Coffee',
      price: "RS 500",
      imagePath: "assets/images/iced-coffee.png",
    ),
  ];

  final List<Coffee> _userCart = [];

  List<Coffee> get coffeeShop => _shop;

  List<Coffee> get userCart => _userCart;

  void addItemToCart(Coffee coffee) {
    _userCart.add(coffee);
    notifyListeners();
  }

  void removeItemFromCart(Coffee coffee) {
    _userCart.remove(coffee);
    notifyListeners();
  }

  void clearCart() {
    _userCart.clear();
    notifyListeners();
  }
}
