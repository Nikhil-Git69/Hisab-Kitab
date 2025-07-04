import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class dashscr extends StatefulWidget {
  const dashscr({super.key});

  @override
  State<dashscr> createState() => _dashscrState();
}

class _dashscrState extends State<dashscr> {
  List<Map<String, dynamic>> transactions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTransactions();
  }


  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('transactions');
    if (data != null) {
      setState(() {
        transactions = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  double get totalIncome => transactions
      .where((t) => t['type'] == 'Income')
      .fold(0.0, (sum, t) {
    final amount = (t['amount'] ?? 0);
    return sum + (amount is num ? amount.toDouble() : 0.0);
  });


  double get totalExpense => transactions
      .where((t) => t['type'] == 'Expense')
      .fold(0.0, (sum, t) {
    final amount = (t['amount'] ?? 0);
    return sum + (amount is num ? amount.toDouble() : 0.0);
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 40),
        backgroundColor: const Color(0xFF215977),
        centerTitle: true,
        title: const Text('Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            AspectRatio(
              aspectRatio: 1.5,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: totalIncome,
                      title: 'Income',
                      radius: 60,
                      titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: totalExpense,
                      title: 'Expense',
                      radius: 60,
                      titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                  sectionsSpace: 5,
                  centerSpaceRadius: 30,
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Recent Transactions",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: transactions.isEmpty
                  ? const Center(child: Text("No transactions"))
                  : ListView(
                children: transactions.reversed.take(5).map((t) {
                  final date = DateTime.parse(t['date']);
                  return ListTile(
                    leading: Icon(
                      t['type'] == 'Expense' ? Icons.money_off : Icons.attach_money,
                      color: t['type'] == 'Expense' ? Colors.red : Colors.green,
                    ),
                    title: Text("${t['description']}"),
                    subtitle: Text("${date.day}/${date.month}/${date.year}"),
                    trailing: Text(
                      "Rs. ${t['amount']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
