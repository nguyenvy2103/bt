import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaymentSelectionScreen(),
    );
  }
}

abstract class PaymentMethod {
  String get name;
  String get logoUrl;
}

class PaypalPayment extends PaymentMethod {
  @override
  String get name => "PayPal";

  @override
  String get logoUrl =>
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/PayPal.svg/2560px-PayPal.svg.png";
}

class GooglePayPayment extends PaymentMethod {
  @override
  String get name => "Google Pay";

  @override
  String get logoUrl =>
      "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Google_Pay_Logo.svg/1200px-Google_Pay_Logo.svg.png";
}

class ApplePayPayment extends PaymentMethod {
  @override
  String get name => "Apple Pay";

  @override
  String get logoUrl =>
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWxYUQvdwKXZ9meVu4Jx6fr7nNNo99TLl-bA&s";
}


class PaymentSelectionScreen extends StatefulWidget {
  const PaymentSelectionScreen({super.key});

  @override
  State<PaymentSelectionScreen> createState() =>
      _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  final List<PaymentMethod> methods = [
    PaypalPayment(),
    GooglePayPayment(),
    ApplePayPayment(),
  ];

  PaymentMethod? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phương thức thanh toán"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            SizedBox(
              height: 90,
              child: selectedMethod == null
                  ? const Icon(
                Icons.credit_card,
                size: 90,
                color: Colors.grey,
              )
                  : Image.network(
                selectedMethod!.logoUrl,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 24),


            ...methods.map(
                  (method) => PaymentTile(
                method: method,
                selectedMethod: selectedMethod,
                onTap: () {
                  setState(() {
                    selectedMethod = method;
                  });
                },
              ),
            ),

            const Spacer(),



            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedMethod == null
                    ? null
                    : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Bạn đã chọn ${selectedMethod!.name}",
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  disabledBackgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continue",
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
    );
  }
}


class PaymentTile extends StatelessWidget {
  final PaymentMethod method;
  final PaymentMethod? selectedMethod;
  final VoidCallback onTap;

  const PaymentTile({
    super.key,
    required this.method,
    required this.selectedMethod,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = method == selectedMethod;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: isSelected ? 6 : 1,
      color: isSelected ? Colors.blue.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: Radio<PaymentMethod>(
          value: method,
          groupValue: selectedMethod,
          onChanged: (_) => onTap(),
        ),
        title: Text(
          method.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight:
            isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),


        trailing: Image.network(
          method.logoUrl,
          height: 28,
          fit: BoxFit.contain,
        ),

        onTap: onTap,
      ),
    );
  }
}
