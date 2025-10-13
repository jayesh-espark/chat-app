import 'daily_financial.dart';
import 'financial_summary.dart';

class CalendarData {
  final DateTime month;
  final FinancialSummary summary;
  final List<DailyFinancial> dailyFinancials;

  CalendarData({
    required this.month,
    required this.summary,
    required this.dailyFinancials,
  });

  DailyFinancial? getFinancialForDate(DateTime date) {
    try {
      return dailyFinancials.firstWhere(
        (d) =>
            d.date != null &&
            d.date!.year == date.year &&
            d.date!.month == date.month &&
            d.date!.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }
}
