import 'package:flutter/material.dart';
import '../models/cart.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  String _cardName = "";
  String _cardNumber = "";
  String _expiryDate = "";

  void _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      // Sahte ödeme işlemi (2 saniye bekleme)
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Cart.items.clear();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ödeme Başarılı! Siparişiniz alındı."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Ana sayfaya kadar tüm sayfaları kapat
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Güvenli Ödeme"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mock Credit Card UI
              Container(
                height: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade800, Colors.blue.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.credit_card, color: Colors.white, size: 40),
                        Text(
                          "VISA",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _cardNumber.isEmpty ? "**** **** **** ****" : _cardNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _cardName.isEmpty ? "İSİM SOYİSİM" : _cardName.toUpperCase(),
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        Text(
                          _expiryDate.isEmpty ? "AA/YY" : _expiryDate,
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Form Fields
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Kart Üzerindeki İsim",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (value) => setState(() => _cardName = value),
                validator: (value) => value!.isEmpty ? "Lütfen isim girin" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Kart Numarası",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => _cardNumber = value),
                validator: (value) => value!.length < 16 ? "Geçerli bir kart numarası girin" : null,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Son Kullanma (AA/YY)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                      onChanged: (value) => setState(() => _expiryDate = value),
                      validator: (value) => value!.isEmpty ? "Tarih girin" : null,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "CVV",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (value) => value!.length < 3 ? "CVV girin" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // Total Amount Display
              Center(
                child: Text(
                  "Ödenecek Tutar: ${Cart.totalPrice.toStringAsFixed(2)} ₺",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Submit Button
              ElevatedButton(
                onPressed: _isProcessing || Cart.items.isEmpty ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        "Ödemeyi Tamamla",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
