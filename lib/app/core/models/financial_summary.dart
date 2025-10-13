import 'package:intl/intl.dart';

class FinancialSummary {
  final double totalRevenue;
  final double totalExpenditure;
  final double remaining;

  FinancialSummary({
    required this.totalRevenue,
    required this.totalExpenditure,
    required this.remaining,
  });

  String formatAmount(double amount) {
    final isPositive = amount >= 0;
    final absAmount = amount.abs();
    final formatted = NumberFormat('#,###', 'vi_VN').format(absAmount);
    return '${isPositive ? '+' : '-'}$formatted VND';
  }
}
