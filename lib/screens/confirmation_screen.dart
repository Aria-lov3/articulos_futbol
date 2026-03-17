import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'package:articulos_futbol/models/cart_item.dart';
import 'home_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final double totalAmount;
  final double subtotalAmount;
  final double ivaAmount;
  final double shippingCost;
  final List<CartItem> items;

  const ConfirmationScreen({
    super.key,
    required this.totalAmount,
    required this.subtotalAmount,
    required this.ivaAmount,
    required this.shippingCost,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xFF2E3A47);
    const buttonColor = Color(0xFF6C757D);
    const priceColor = Color.fromARGB(255, 56, 93, 255);
    const textColor = Color(0xFF333333);

    final orderNumber = Random().nextInt(10000).toString().padLeft(4, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmación de Pago'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 80),
            const SizedBox(height: 20),
            const Text(
              '¡Pago Exitoso!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Número de Orden: #$orderNumber',
              style: const TextStyle(fontSize: 18, color: Color(0xFF6C757D)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Productos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    const Divider(),
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.quantity}x ${item.title}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (item.size != null)
                                    Text(
                                      'Talla: ${item.size}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF38B6FF),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                              style: const TextStyle(color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Resumen del Pago',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    const Divider(),
                    _summaryRow(
                      'Subtotal:',
                      '\$${subtotalAmount.toStringAsFixed(2)}',
                      textColor,
                    ),
                    const SizedBox(height: 8),
                    _summaryRow(
                      'IVA (16%):',
                      '\$${ivaAmount.toStringAsFixed(2)}',
                      textColor,
                    ),
                    const SizedBox(height: 8),
                    _summaryRow(
                      'Envío:',
                      '\$${shippingCost.toStringAsFixed(2)}',
                      textColor,
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pagado:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: titleColor,
                          ),
                        ),
                        Text(
                          '\$${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: priceColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).clear();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (ctx) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  'Volver a la tienda',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: textColor)),
        Text(value, style: TextStyle(color: textColor)),
      ],
    );
  }
}
