import 'package:flutter/foundation.dart';

class UserManager extends ChangeNotifier {
  String? authToken;

  void setAuthToken(String? token) {
    authToken = token;
    notifyListeners();
  }

  bool get isAuthenticated => authToken != null;
}
