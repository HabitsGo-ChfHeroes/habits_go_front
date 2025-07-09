import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expiryDateController = TextEditingController();

  bool _loading = false;
  String _message = '';

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cvvController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
      helpText: 'Selecciona fecha de expiración',
    );

    if (picked != null) {
      final formatted = "${picked.month.toString().padLeft(2, '0')}/${picked.year % 100}";
      _expiryDateController.text = formatted;
    }
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) {
      setState(() => _message = '⚠️ Usuario no identificado');
      return;
    }

    setState(() {
      _loading = true;
      _message = '';
    });

    final success = await PaymentService().makeMembershipPayment(userId);

    setState(() {
      _message = success
          ? "✅ Suscripción activada correctamente."
          : "❌ Fallo al registrar el pago.";
      _loading = false;
    });
  }

  String _formatCardNumber(String value) {
    return value.replaceAllMapped(RegExp(r".{1,4}"), (match) => "${match.group(0)}-").replaceAll(RegExp(r"-$"), "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suscripción Plus'),
        backgroundColor: const Color(0xFF226980),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  '💳 Membresía Plus',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Accede a beneficios premium por solo \$9.00 al mes (30 días).',
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 30, thickness: 1.2),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(19),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            String digits = newValue.text.replaceAll('-', '');
                            final newText = _formatCardNumber(digits);
                            return TextEditingValue(
                              text: newText,
                              selection: TextSelection.collapsed(offset: newText.length),
                            );
                          }),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Número de Tarjeta VISA',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.credit_card),
                          hintText: 'XXXX-XXXX-XXXX-XXXX',
                        ),
                        validator: (value) {
                          final cleaned = value?.replaceAll("-", "") ?? '';
                          if (cleaned.length != 16) return 'Ingrese una tarjeta válida';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _expiryDateController,
                        readOnly: true,
                        onTap: _selectExpiryDate,
                        decoration: const InputDecoration(
                          labelText: 'Fecha de expiración (MM/AA)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.date_range),
                          hintText: 'MM/AA',
                        ),
                        validator: (value) {
                          if (value == null || !value.contains('/')) {
                            return 'Seleccione una fecha válida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _cvvController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          hintText: '123',
                        ),
                        validator: (value) {
                          if (value == null || value.length != 3) {
                            return 'CVV inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _loading ? null : _submitPayment,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Pagar \$9.00'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF226980),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_message.isNotEmpty)
                        Text(
                          _message,
                          style: TextStyle(
                            color: _message.contains("✅") ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}