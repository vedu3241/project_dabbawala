import 'package:flutter/material.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  int selectedMethod = 0;

  List<Map<String, dynamic>> paymentMethods = [
    {'icon': Icons.credit_card, 'title': 'VISA Classic', 'details': '**** **** **** 1254'},
    {'icon': Icons.credit_card, 'title': 'Master Card', 'details': '**** **** **** 1254'},
    {'icon': Icons.account_balance, 'title': 'Bank Transfer', 'details': '2316 **** **** 1254'},
    {'icon': Icons.payment, 'title': 'Online Payment', 'details': 'GPay / PhonePe / Paytm'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 10)
        ],
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              children: List.generate(paymentMethods.length, (index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(paymentMethods[index]['icon'], size: 40),
                    title: Text(paymentMethods[index]['title']),
                    subtitle: Text(paymentMethods[index]['details']),
                    trailing: Radio(
                      value: index,
                      groupValue: selectedMethod,
                      onChanged: (value) {
                        setState(() => selectedMethod = value!);
                      },
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text('Payment Info',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoTile('From', 'Bandra'),
                _infoTile('To', "Csmt"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade200,
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
