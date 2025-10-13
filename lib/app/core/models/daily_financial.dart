class DailyFinancial {
  final DateTime date; // Non-nullable, as date is essential
  double revenue; // Non-final to allow mutation
  double? expenditure; // Non-final, nullable as not always provided

  DailyFinancial({required this.date, this.revenue = 0.0, this.expenditure}) {
    // Validate inputs
    if (revenue < 0) {
      throw ArgumentError('Revenue cannot be negative');
    }
    if (expenditure != null && expenditure! < 0) {
      throw ArgumentError('Expenditure cannot be negative');
    }
  }

  // Getter for total (revenue - expenditure)
  double get total => revenue - (expenditure ?? 0.0);

  // Format amount with improved handling for negative values and currency
  String formatAmount(double amount, {String currency = ''}) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    String formatted;

    if (absAmount >= 1000000) {
      final millions = absAmount / 1000000;
      formatted = '${millions.toStringAsFixed(millions % 1 == 0 ? 0 : 2)}M';
    } else if (absAmount >= 1000) {
      formatted = '${(absAmount / 1000).toStringAsFixed(0)}k';
    } else {
      formatted = absAmount.toStringAsFixed(0);
    }

    return '${isNegative ? '-' : ''}$currency$formatted';
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'revenue': revenue,
      'expenditure': expenditure,
    };
  }

  // Convert JSON to object with validation
  factory DailyFinancial.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date'] as String?;
    if (dateStr == null) {
      throw ArgumentError('Date is required in JSON');
    }
    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(dateStr);
    } catch (e) {
      throw FormatException('Invalid date format: $dateStr');
    }

    final revenue = (json['revenue'] as num?)?.toDouble() ?? 0.0;
    final expenditure = (json['expenditure'] as num?)?.toDouble();

    return DailyFinancial(
      date: parsedDate,
      revenue: revenue,
      expenditure: expenditure,
    );
  }

  // Function to add revenue
  void addRevenue(double amount) {
    if (amount < 0) {
      throw ArgumentError('Cannot add negative revenue');
    }
    revenue += amount;
  }

  // Function to add expenditure
  void addExpenditure(double amount) {
    if (amount < 0) {
      throw ArgumentError('Cannot add negative expenditure');
    }
    expenditure = (expenditure ?? 0.0) + amount;
  }

  // Create a copy with modified fields
  DailyFinancial copyWith({
    DateTime? date,
    double? revenue,
    double? expenditure,
  }) {
    return DailyFinancial(
      date: date ?? this.date,
      revenue: revenue ?? this.revenue,
      expenditure: expenditure ?? this.expenditure,
    );
  }

  // Check if the record has meaningful financial data
  bool get hasData => revenue > 0 || expenditure != null;

  // String representation for debugging
  @override
  String toString() {
    return 'DailyFinancial(date: ${date.toIso8601String()}, '
        'revenue: ${formatAmount(revenue)}, '
        'expenditure: ${expenditure != null ? formatAmount(expenditure!) : 'null'})';
  }

  // Equality comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyFinancial &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          revenue == other.revenue &&
          expenditure == other.expenditure;

  @override
  int get hashCode => date.hashCode ^ revenue.hashCode ^ expenditure.hashCode;
}
