import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransacPage extends StatefulWidget {
  const TransacPage({super.key});

  @override
  State<TransacPage> createState() => _TransacPageState();
}

class _TransacPageState extends State<TransacPage> {
  List<Map<String, dynamic>> transactions = [];

  final List<String> categories = [
    'Food',
    'Entertainment',
    'Utilities',
    'Transport',
    'Shopping',
    'Others',
  ];

  String? selectedCategory;


  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('transactions');
    if (data != null) {
      try {
        final decoded = json.decode(data);
        if (decoded is List) {
          setState(() {
            transactions = decoded
                .whereType<Map<String, dynamic>>()
                .toList();
          });
        }
      } catch (e) {
        setState(() {
          transactions = [];
        });
      }
    }
  }

  Future<void> _saveTransaction(Map<String, dynamic> transaction) async {
    final prefs = await SharedPreferences.getInstance();
    transactions.add(transaction);
    await prefs.setString('transactions', json.encode(transactions));
    setState(() {});
  }

  void _showAddTransactionDialog(BuildContext context) {
    String selectedType = 'Expense';
    String? localSelectedCategory;
    TextEditingController amountController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Transaction"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    DropdownButtonFormField<String>(
                      value: selectedType,
                      items: ['Expense', 'Income'].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedType = value;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: "Transaction Type"),
                    ),
                    const SizedBox(height: 10),


                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Amount"),
                    ),
                    const SizedBox(height: 10),


                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: "Description"),
                    ),
                    const SizedBox(height: 10),


                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Category'),
                      value: localSelectedCategory,
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          localSelectedCategory = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final double? amount = double.tryParse(amountController.text);
                    final String description = descriptionController.text;

                    if (amount == null || description.isEmpty || localSelectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter valid data and category")),
                      );
                      return;
                    }

                    final newTransaction = {
                      'type': selectedType,
                      'amount': amount,
                      'description': description,
                      'category': localSelectedCategory,
                      'date': DateTime.now().toIso8601String(),
                    };

                    _saveTransaction(newTransaction);

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Transaction Added")),
                    );
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _deleteTransaction(Map<String, dynamic> transaction) async {
    final prefs = await SharedPreferences.getInstance();
      transactions.remove(transaction);
         await prefs.setString('transactions', json.encode(transactions));
      setState(() {});
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transaction Deleted")),
    );
  }

  Future<void> _showEditTransactionDialog(Map<String, dynamic> transaction) {
    String selectedType = transaction['type'];
    String? localSelectedCategory = transaction['category'];
    TextEditingController amountController = TextEditingController(text: transaction['amount'].toString());
    TextEditingController descriptionController = TextEditingController(text: transaction['description']);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Edit Transaction"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      items: ['Expense', 'Income'].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedType = value;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: "Transaction Type"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Amount"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: "Description"),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Category'),
                      value: localSelectedCategory,
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          localSelectedCategory = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final double? amount = double.tryParse(amountController.text);
                    final String description = descriptionController.text;

                    if (amount == null || description.isEmpty || localSelectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter valid data and category")),
                      );
                      return;
                    }

                    transaction['type'] = selectedType;
                    transaction['amount'] = amount;
                    transaction['description'] = description;
                    transaction['category'] = localSelectedCategory;
                    transaction['date'] = DateTime.now().toIso8601String();

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('transactions', json.encode(transactions));

                    Navigator.pop(context); // Close dialog

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Transaction Updated")),
                    );
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final incomeList = transactions
        .where((t) => t['type'] == 'Income')
        .toList();

    final expenseList = transactions
        .where((t) => t['type'] == 'Expense')
        .toList();

    Widget buildList(List<Map<String, dynamic>> data) {
      if (data.isEmpty) return const Center(child: Text("No transactions"));

      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final t = data.reversed.toList()[index];
          final date = DateTime.tryParse(t['date'] ?? '');
          return  ListTile(
            leading: CircleAvatar(
              backgroundColor:
              t['type'] == 'Expense' ? Colors.red[100] : Colors.green[100],
              child: Icon(
                t['type'] == 'Expense' ? Icons.money_off : Icons.attach_money,
                color: t['type'] == 'Expense' ? Colors.red : Colors.green,
              ),
            ),
            title: Text(
              "${t['description']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t['category'] != null ? "Category: ${t['category']}" : "No Category",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  date != null
                      ? "${date.day}/${date.month}/${date.year}"
                      : "Invalid date",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "Rs. ${t['amount']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Edit',
                onPressed: () async {
                  await _showEditTransactionDialog(t);
                  setState(() {});
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Delete',
                onPressed: () => _deleteTransaction(t),
              ),
            ],
          ),

          );

        },
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white, size: 30),
          backgroundColor: const Color(0xFF215977),
          centerTitle: true,
          title: const Text(
            'Transactions',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Income", icon: Icon(Icons.attach_money)),
              Tab(text: "Expense", icon: Icon(Icons.money_off)),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            buildList(incomeList),
            buildList(expenseList),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF215977),
          onPressed: () => _showAddTransactionDialog(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
