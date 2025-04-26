import 'dart:convert';

import 'package:dabbawala/features/AnalytisPage/models/analytic_model.dart';
import 'package:dabbawala/features/AnalytisPage/models/dab_income_model.dart';
import 'package:dabbawala/features/AnalytisPage/screens/income_chart.dart';
import 'package:dabbawala/features/AnalytisPage/screens/summary_screen.dart';
import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DabbawalaIcomeStat _selectedStat;
  final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

  /// New var
  int selectedYear = DateTime.now().year;
  List<DabbawalaIcomeStat> stats = [];
  bool isLoading = true;

  final List<int> availableYears = [
    2022,
    2023,
    2024,
    2025,
  ];

  Future<void> fetchIncomeData(int year) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${UsedConstants.baseUrl}/dab/analytics/income/yearly/$year'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<DabbawalaIcomeStat> loadedStats = data.map((item) {
          return DabbawalaIcomeStat(
            month: item['month'],
            income: (item['income'] as num).toDouble(),
          );
        }).toList();

        setState(() {
          stats = loadedStats;
        });
      } else {
        throw Exception('Failed to load income data');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchIncomeData(selectedYear);

    // _monthlyStats = DabbawalaDataProvider.getMonthlyStats();
    _selectedStat = DabbawalaIcomeStat(
        month: 'Dec', income: 22500); // Default to the latest month
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dabbawala Analytics'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary cards
                SummaryCards(
                  monthlyIncome: _selectedStat.income,
                  customerCount: 10,
                  averageIncomePerCustomer: 10,
                  month: _selectedStat.month,
                ),

                const SizedBox(height: 24),

                // Monthly Income Chart
                Row(
                  children: [
                    const Text(
                      'Monthly Income',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButton<int>(
                        value: selectedYear,
                        items: availableYears.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year.toString()),
                          );
                        }).toList(),
                        onChanged: (newYear) {
                          if (newYear != null) {
                            setState(() {
                              selectedYear = newYear;
                            });
                            fetchIncomeData(newYear);
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        height: 200,
                        child: IncomeChart(
                          stats: stats,
                          onMonthSelected: (stat) {
                            setState(() {
                              _selectedStat = stat;
                            });
                          },
                        ),
                      ),

                const SizedBox(height: 24),

                // // Monthly Customer Chart
                // const Text(
                //   'Monthly Customers',
                //   style: TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 8),
                // SizedBox(
                //   height: 200,
                //   child: CustomerChart(
                //     stats: _monthlyStats,
                //     onMonthSelected: (stat) {
                //       setState(() {
                //         _selectedStat = stat;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
