import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, String>> getSupBaseCred() async {
  await dotenv.load(fileName: ".env");
  String? url = dotenv.env['SUPABASE_URL'];
  String? anonKey = dotenv.env['SUPABASE_ANON_KEY'];
  if (url == null || anonKey == null) {
    throw Exception("Supabase credentials not found in .env file");
  }
  return {'url': url, 'anonKey': anonKey};
}

removeFocus(BuildContext context) {
  FocusScope.of(context).unfocus();
}
