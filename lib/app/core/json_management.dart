import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'models/daily_financial.dart';

class JsonManagement {
  Future<String> _getLocalFile(BuildContext context) async {
    return DefaultAssetBundle.of(
      context,
    ).loadString("assets/json/expense.json");
  }

  Future<List<DailyFinancial>> loadExpenses(BuildContext context) async {
    try {
      final String response = await _getLocalFile(context);
      final List<dynamic> data = jsonDecode(response);
      return data.map((e) => DailyFinancial.fromJson(e)).toList();
    } catch (e) {
      log("Error loading expenses: $e");
      return [];
    }
  }

  // Future<void> saveExpenses(List<DailyFinancial> expenses) async {
  //   final file = await _getLocalFile();
  //   final List<Map<String, dynamic>> jsonList = expenses
  //       .map((e) => e.toJson())
  //       .toList();
  //   // await file.writeAsString(jsonEncode(jsonList));
  // }

  Future<void> updateExpense(
    List<DailyFinancial> expenses,
    DateTime targetDate,
    double expenseToAdd,
  ) async {
    final entry = expenses.firstWhere(
      (e) =>
          e.date.year == targetDate.year &&
          e.date.month == targetDate.month &&
          e.date.day == targetDate.day,
      orElse: () => DailyFinancial(date: targetDate),
    );

    entry.addExpenditure(expenseToAdd);

    // If entry was newly created, add it
    if (!expenses.contains(entry)) {
      expenses.add(entry);
    }
    // await saveExpenses(expenses);
  }

  Future<void> updateRevenue(
    List<DailyFinancial> expenses,
    DateTime targetDate,
    double expenseToAdd,
  ) async {
    final entry = expenses.firstWhere(
      (e) =>
          e.date.year == targetDate.year &&
          e.date.month == targetDate.month &&
          e.date.day == targetDate.day,
      orElse: () => DailyFinancial(date: targetDate),
    );

    entry.addRevenue(expenseToAdd);
    // If entry was newly created, add it
    if (!expenses.contains(entry)) {
      expenses.add(entry);
    }
    // await saveExpenses(expenses);
  }
}
