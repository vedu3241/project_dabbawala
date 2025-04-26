import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class SummaryCards extends StatelessWidget {
  final double monthlyIncome;
  final int customerCount;
  final double averageIncomePerCustomer;
  final String month;

  const SummaryCards({
    Key? key,
    required this.monthlyIncome,
    required this.customerCount,
    required this.averageIncomePerCustomer,
    required this.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$month Summary',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCard(
                title: 'Monthly Income',
                value: currencyFormat.format(monthlyIncome),
                icon: Icons.monetization_on,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCard(
                title: 'Customers',
                value: customerCount.toString(),
                icon: Icons.people,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCard(
          title: 'Income per Customer',
          value: currencyFormat.format(averageIncomePerCustomer),
          icon: Icons.person,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
