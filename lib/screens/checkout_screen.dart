import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _shippingFormKey = GlobalKey<FormState>();
  final _creditCardFormKey = GlobalKey<FormState>();

  String _name = '';
  String _address = '';
  String _zipCode = '';
  String _phone = '';

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    if (creditCardModel == null) return;
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Future<void> _processPayment() async {
    final shippingValid = _shippingFormKey.currentState?.validate() ?? false;
    final cardValid = _creditCardFormKey.currentState?.validate() ?? false;

    if (!shippingValid || !cardValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF2E3A47),
          content: Text('Por favor, corrija los errores en el formulario.'),
        ),
      );
      return;
    }

    _shippingFormKey.currentState?.save();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF38B6FF)),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    Navigator.of(context).pop();

    final cart = Provider.of<CartProvider>(context, listen: false);
    final total = cart.totalAmount;
    final subtotal = cart.subtotalAmount;
    final iva = cart.ivaAmount;
    final shipping = cart.shippingCost;
    final items = cart.items.values.toList();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => ConfirmationScreen(
          totalAmount: total,
          subtotalAmount: subtotal,
          ivaAmount: iva,
          shippingCost: shipping,
          items: items,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xFF2E3A47);
    const buttonColor = Color(0xFF6C757D);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _shippingFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Datos de Envío',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildTextField(
                              'Nombre Completo',
                              (value) => _name = value ?? '',
                            ),
                            const SizedBox(height: 10),
                            _buildTextField(
                              'Dirección',
                              (value) => _address = value ?? '',
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    'CP',
                                    (value) => _zipCode = value ?? '',
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextField(
                                    'Teléfono',
                                    (value) => _phone = value ?? '',
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Método de Pago',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                        ),
                      ),
                    ),
                    CreditCardWidget(
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      showBackView: isCvvFocused,
                      onCreditCardWidgetChange: (CreditCardBrand brand) {},
                      obscureCardNumber: true,
                      obscureCardCvv: true,
                      isHolderNameVisible: true,
                      cardBgColor: titleColor,
                      isSwipeGestureEnabled: true,
                    ),
                    CreditCardForm(
                      formKey: _creditCardFormKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _processPayment,
                child: Consumer<CartProvider>(
                  builder: (ctx, cart, _) => Text(
                    'Pagar \$${cart.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    Function(String?) onSaved, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        labelStyle: const TextStyle(color: Color(0xFF6C757D)),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF38B6FF)),
        ),
      ),
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFF333333)),
      validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
      onSaved: onSaved,
    );
  }
}
