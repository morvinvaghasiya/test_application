import 'package:flutter/material.dart';

import '../../utils/constant/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<_PlatformEntry> _platforms = [
    _PlatformEntry(name: 'Meesho'),
    _PlatformEntry(name: 'Amazon'),
    _PlatformEntry(name: 'Flipkart'),
    _PlatformEntry(name: 'Snapdeal'),
  ];

  @override
  void dispose() {
    for (final platform in _platforms) {
      platform.dispose();
    }
    super.dispose();
  }

  double _parse(TextEditingController controller) {
    return double.tryParse(controller.text.trim()) ?? 0;
  }

  _PlatformTotals _calculateTotals(_PlatformEntry entry) {
    final orders = _parse(entry.ordersController);
    final returns = _parse(entry.returnsController);
    final commission = _parse(entry.commissionController);
    final salary = _parse(entry.salaryController);
    final expense = _parse(entry.expenseController);
    final otherExpense = _parse(entry.otherExpenseController);
    final profitLoss =
        orders - returns - commission - salary - expense - otherExpense;
    return _PlatformTotals(
      orders: orders,
      returns: returns,
      commission: commission,
      salary: salary,
      expense: expense,
      otherExpense: otherExpense,
      profitLoss: profitLoss,
    );
  }

  _PlatformTotals _calculateOverall() {
    var totals = const _PlatformTotals.empty();
    for (final platform in _platforms) {
      totals = totals + _calculateTotals(platform);
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Marketplace Calculator'),
          centerTitle: true,
        ),
        backgroundColor: ConstColors.backgroundColor,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            const Text(
              'Monthly Profit & Loss',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Track returns, orders, commission, salaries, and expenses for each marketplace.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            for (final platform in _platforms) ...[
              _PlatformCard(
                platform: platform,
                totals: _calculateTotals(platform),
                onChanged: () => setState(() {}),
              ),
              const SizedBox(height: 16),
            ],
            _OverallSummaryCard(totals: _calculateOverall()),
          ],
        ),
      ),
    );
  }
}

class _PlatformEntry {
  _PlatformEntry({required this.name});

  final String name;
  final TextEditingController returnsController = TextEditingController();
  final TextEditingController ordersController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController otherExpenseController = TextEditingController();

  void dispose() {
    returnsController.dispose();
    ordersController.dispose();
    commissionController.dispose();
    salaryController.dispose();
    expenseController.dispose();
    otherExpenseController.dispose();
  }
}

class _PlatformTotals {
  const _PlatformTotals({
    required this.orders,
    required this.returns,
    required this.commission,
    required this.salary,
    required this.expense,
    required this.otherExpense,
    required this.profitLoss,
  });

  const _PlatformTotals.empty()
      : orders = 0,
        returns = 0,
        commission = 0,
        salary = 0,
        expense = 0,
        otherExpense = 0,
        profitLoss = 0;

  final double orders;
  final double returns;
  final double commission;
  final double salary;
  final double expense;
  final double otherExpense;
  final double profitLoss;

  _PlatformTotals operator +(_PlatformTotals other) => _PlatformTotals(
        orders: orders + other.orders,
        returns: returns + other.returns,
        commission: commission + other.commission,
        salary: salary + other.salary,
        expense: expense + other.expense,
        otherExpense: otherExpense + other.otherExpense,
        profitLoss: profitLoss + other.profitLoss,
      );
}

class _PlatformCard extends StatelessWidget {
  const _PlatformCard({
    required this.platform,
    required this.totals,
    required this.onChanged,
  });

  final _PlatformEntry platform;
  final _PlatformTotals totals;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  platform.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _ProfitBadge(amount: totals.profitLoss),
              ],
            ),
            const SizedBox(height: 12),
            _EntryField(
              label: 'Monthly Orders',
              controller: platform.ordersController,
              onChanged: onChanged,
            ),
            _EntryField(
              label: 'Monthly Returns',
              controller: platform.returnsController,
              onChanged: onChanged,
            ),
            _EntryField(
              label: 'Commission',
              controller: platform.commissionController,
              onChanged: onChanged,
            ),
            _EntryField(
              label: 'Employee Salary',
              controller: platform.salaryController,
              onChanged: onChanged,
            ),
            _EntryField(
              label: 'Expense',
              controller: platform.expenseController,
              onChanged: onChanged,
            ),
            _EntryField(
              label: 'Other Expense',
              controller: platform.otherExpenseController,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryField extends StatelessWidget {
  const _EntryField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (_) => onChanged(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: const Color(0xFFF6F6F6),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _ProfitBadge extends StatelessWidget {
  const _ProfitBadge({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    final isPositive = amount >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPositive ? const Color(0xFFE6F4EA) : const Color(0xFFFCE8E6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${isPositive ? '+' : '-'}₹${amount.abs().toStringAsFixed(0)}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isPositive ? const Color(0xFF1E8E3E) : const Color(0xFFD93025),
        ),
      ),
    );
  }
}

class _OverallSummaryCard extends StatelessWidget {
  const _OverallSummaryCard({required this.totals});

  final _PlatformTotals totals;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF111827),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Summary',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _SummaryRow(label: 'Orders', value: totals.orders),
            _SummaryRow(label: 'Returns', value: totals.returns),
            _SummaryRow(label: 'Commission', value: totals.commission),
            _SummaryRow(label: 'Employee Salary', value: totals.salary),
            _SummaryRow(label: 'Expense', value: totals.expense),
            _SummaryRow(label: 'Other Expense', value: totals.otherExpense),
            const Divider(color: Colors.white24, height: 24),
            _SummaryRow(
              label: 'Profit / Loss',
              value: totals.profitLoss,
              highlight: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final double value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final valueColor = highlight
        ? (value >= 0 ? const Color(0xFF34D399) : const Color(0xFFFCA5A5))
        : Colors.white70;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: highlight ? Colors.white : Colors.white70,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            '₹${value.toStringAsFixed(0)}',
            style: TextStyle(
              color: valueColor,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
