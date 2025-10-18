import 'package:flutter/foundation.dart';
import 'package:snake_app/core/models/user.dart';
import 'package:snake_app/core/services/user_service.dart';

class UserState with ChangeNotifier {
  User? _currentUser;

  User get currrentUser => _currentUser!;

  String get orgUnitId => _currentUser != null && _currentUser!.isLogin
      ? _currentUser!.userOrgUnitIds?.first ?? ''
      : '';

  String get usernameIcon => _currentUser != null && _currentUser!.isLogin
      ? _currentUser!.fullName
            .split(' ')
            .map((name) => name.isNotEmpty ? name[0] : name)
            .toList()
            .join('')
            .toUpperCase()
      : '';

  void setCurrentUser(User currentUser) {
    _currentUser = currentUser;
    notifyListeners();
  }

  void updateUserPassword({required String newPassword}) async {
    _currentUser?.password = newPassword;
    await UserService().setCurrentUser(_currentUser!);
    setCurrentUser(_currentUser!);
  }
}
