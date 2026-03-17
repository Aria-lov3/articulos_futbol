import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xFF2E3A47);
    const buttonColor = Color(0xFF6C757D);
    const priceColor = Color.fromARGB(255, 56, 93, 255);
    const textColor = Color(0xFF333333);

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tu Carrito')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final cartItem = cart.items.values.toList()[i];
                final cartKey = cart.items.keys.toList()[i];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 4,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: cartItem.iconColor.withOpacity(0.1),
                        radius: 25,
                        child: Icon(
                          cartItem.icon,
                          color: cartItem.iconColor,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        cartItem.title,
                        style: const TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (cartItem.size != null)
                            Text(
                              'Talla: ${cartItem.size}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF38B6FF),
                              ),
                            ),
                          Text(
                            'Total: \$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(color: textColor),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: Color(0xFF6C757D),
                            ),
                            onPressed: () {
                              cart.removeSingleItem(cartKey);
                            },
                          ),
                          Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Color(0xFF38B6FF),
                            ),
                            onPressed: () {
                              cart.incrementItemQuantity(cartKey);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              cart.removeItem(cartKey);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            color: Colors.white,
            margin: const EdgeInsets.all(15),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  _summaryRow(
                    'Subtotal:',
                    '\$${cart.subtotalAmount.toStringAsFixed(2)}',
                    textColor,
                  ),
                  const SizedBox(height: 5),
                  _summaryRow(
                    'IVA (16%):',
                    '\$${cart.ivaAmount.toStringAsFixed(2)}',
                    textColor,
                  ),
                  const SizedBox(height: 5),
                  _summaryRow(
                    'Envío:',
                    '\$${cart.shippingCost.toStringAsFixed(2)}',
                    textColor,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: priceColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: cart.totalAmount <= 0
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => const CheckoutScreen(),
                                ),
                              );
                            },
                      child: const Text(
                        'Comprar Ahora',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _summaryRow(String label, String value, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: textColor)),
        Text(value, style: TextStyle(fontSize: 16, color: textColor)),
      ],
    );
  }
}
