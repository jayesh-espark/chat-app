import 'package:flutter/material.dart';

/// Navigate to a named route and clear the entire navigation stack
Future<T?> navigateToNamedKillAll<T>(
  BuildContext context,
  String routeName, {
  Object? arguments,
}) {
  return Navigator.pushNamedAndRemoveUntil(
    context,
    routeName,
    (route) => false,
    arguments: arguments,
  );
}

/// Push a named route
Future<T?> navigateToNamed<T>(
  BuildContext context,
  String routeName, {
  Object? arguments,
}) {
  return Navigator.pushNamed(context, routeName, arguments: arguments);
}

/// Replace current route with a named one
Future<T?> replaceWithNamed<T>(
  BuildContext context,
  String routeName, {
  Object? arguments,
}) {
  return Navigator.pushReplacementNamed(
    context,
    routeName,
    arguments: arguments,
  );
}

/// Push a named route and remove all previous routes
Future<T?> navigateAndRemoveAllNamed<T>(
  BuildContext context,
  String routeName, {
  Object? arguments,
}) {
  return Navigator.pushNamedAndRemoveUntil(
    context,
    routeName,
    (Route<dynamic> route) => false,
    arguments: arguments,
  );
}

/// Push a new screen onto the stack
Future<T?> navigateTo<T>(BuildContext context, Widget page) {
  return Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}

/// Replace the current screen with a new one
Future<T?> replaceWith<T>(BuildContext context, Widget page) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => page),
  );
}

/// Push a new screen and remove all previous screens
Future<T?> navigateAndRemoveAll<T>(BuildContext context, Widget page) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => page),
    (Route<dynamic> route) => false,
  );
}

/// Go back to the previous screen
void goBack(BuildContext context, [dynamic result]) {
  Navigator.pop(context, result);
}

/// Check if it's possible to go back
bool canGoBack(BuildContext context) {
  return Navigator.canPop(context);
}
