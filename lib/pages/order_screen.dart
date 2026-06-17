import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/coffee_shop.dart';
import 'package:myapp/models/coffe.dart';
import 'package:myapp/pages/tracking_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isDelivery = true;

  static const Color primary = Color(0xFFD4724A);
  static const Color bgDark = Color(0xFF1A1A1A);
  static const Color cardDark = Color(0xFF2A2A2A);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF9E9E9E);
  static const Color divider = Color(0xFF3A3A3A);

  // Delivery fee logic
  static const double deliveryFeeOriginal = 200;
  static const double deliveryFeeDiscounted = 100;

  // Parse "RS 800" → 800.0
  double _parsePrice(String price) {
    final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  double _subtotal(List<Coffee> cart) =>
      cart.fold(0.0, (sum, item) => sum + _parsePrice(item.price));

  double _total(List<Coffee> cart) =>
      _subtotal(cart) + deliveryFeeDiscounted;

  @override
  Widget build(BuildContext context) {
    final coffeeShop = Provider.of<CoffeeShop>(context);
    final cart = coffeeShop.userCart;

    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: cart.isEmpty
                  ? _buildEmptyCart()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildToggle(),
                          const SizedBox(height: 28),
                          if (isDelivery) ...[
                            _buildDeliveryAddress(),
                            const SizedBox(height: 20),
                          ],
                          _buildCartItems(cart, coffeeShop),
                          const SizedBox(height: 16),
                          _buildDiscount(),
                          const SizedBox(height: 28),
                          _buildPaymentSummary(cart),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
            ),
            if (cart.isNotEmpty) _buildBottomBar(cart),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.coffee_outlined, color: textMuted, size: 64),
          SizedBox(height: 16),
          Text('Your cart is empty',
              style: TextStyle(color: textMuted, fontSize: 16)),
          SizedBox(height: 8),
          Text('Add some coffee to get started',
              style: TextStyle(color: Color(0xFF666666), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_left, color: textLight, size: 22),
            ),
          ),
          const Expanded(
            child: Text(
              'Order',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textLight, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      decoration: BoxDecoration(
          color: cardDark, borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _toggleButton('Deliver', isDelivery,
              () => setState(() => isDelivery = true)),
          _toggleButton('Pick Up', !isDelivery,
              () => setState(() => isDelivery = false)),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : textMuted,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Delivery Address',
            style: TextStyle(
                color: textLight, fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 10),
        const Text('Phase 1 Hayatabad',
            style: TextStyle(
                color: textLight, fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 4),
        const Text('Phase 1 Hayatabad, Peshawar, Pakistan',
            style: TextStyle(color: textMuted, fontSize: 12)),
        const SizedBox(height: 14),
        Row(
          children: [
            _addressChip(Icons.edit_outlined, 'Edit Address'),
            const SizedBox(width: 10),
            _addressChip(Icons.note_add_outlined, 'Add Note'),
          ],
        ),
      ],
    );
  }

  Widget _addressChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          border: Border.all(color: divider),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textMuted),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: textMuted, fontSize: 12)),
        ],
      ),
    );
  }

  // Renders each cart item as a card with a remove button
  Widget _buildCartItems(List<Coffee> cart, CoffeeShop coffeeShop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your Items',
            style: TextStyle(
                color: textLight, fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 12),
        ...cart.map((coffee) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildCartItemCard(coffee, coffeeShop),
            )),
      ],
    );
  }

  Widget _buildCartItemCard(Coffee coffee, CoffeeShop coffeeShop) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: cardDark, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 54,
              height: 54,
              color: const Color(0xFF3D2B1F),
              child: Image.asset(
                coffee.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.coffee, color: primary, size: 28),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(coffee.name,
                    style: const TextStyle(
                        color: textLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Text(coffee.price,
                    style: const TextStyle(color: primary, fontSize: 13)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => coffeeShop.removeItemFromCart(coffee),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.remove, size: 16, color: textLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
          color: cardDark, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: primary.withOpacity(0.15), shape: BoxShape.circle),
            child: const Icon(Icons.local_offer_outlined,
                size: 16, color: primary),
          ),
          const SizedBox(width: 12),
          const Text('1 Discount Is Applied',
              style: TextStyle(
                  color: textLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: textMuted, size: 20),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(List<Coffee> cart) {
    final subtotal = _subtotal(cart);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Summary',
            style: TextStyle(
                color: textLight, fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 16),
        _paymentRow('Price', 'RS ${subtotal.toStringAsFixed(0)}'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Delivery Fee',
                style: TextStyle(color: textMuted, fontSize: 14)),
            if (isDelivery)
              Row(
                children: [
                  Text(
                    'RS ${deliveryFeeOriginal.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 13,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: textMuted,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text('RS ${deliveryFeeDiscounted.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: textLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              )
            else
              const Text('Free',
                  style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(color: divider),
        const SizedBox(height: 8),
        _paymentRow(
          'Total',
          'RS ${(isDelivery ? _total(cart) : subtotal).toStringAsFixed(0)}',
        ),
      ],
    );
  }

  Widget _paymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: textMuted, fontSize: 14)),
        Text(value,
            style: const TextStyle(
                color: textLight, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildBottomBar(List<Coffee> cart) {
    final coffeeShop = Provider.of<CoffeeShop>(context, listen: false);
    final total = isDelivery ? _total(cart) : _subtotal(cart);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: bgDark,
        border: Border(top: BorderSide(color: divider, width: 1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.account_balance_wallet_outlined,
                    color: primary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cash/Wallet',
                      style: TextStyle(
                          color: textLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  Text('RS ${total.toStringAsFixed(0)}',
                      style:
                          const TextStyle(color: textMuted, fontSize: 12)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_down, color: textMuted),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                coffeeShop.clearCart();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const TrackingScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Order · RS ${total.toStringAsFixed(0)}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ), 
    );
  }
}