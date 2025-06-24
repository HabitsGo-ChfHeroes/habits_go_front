import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int? _userId;
  String? _userGoal;

  int? get userId => _userId;
  String? get userGoal => _userGoal;

  void setUserId(int id) {
    _userId = id;
    notifyListeners();
  }

  void setUserGoal(String goal) {
    _userGoal = goal;
    notifyListeners();
  }

  void clearUser() {
    _userId = null;
    _userGoal = null;
    notifyListeners();
  }
}
