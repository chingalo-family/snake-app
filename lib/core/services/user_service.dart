import 'dart:convert';
import 'package:snake_app/core/models/user.dart';
import 'package:snake_app/core/offline_db/user_offline_provider/user_offline_provider.dart';
import 'package:snake_app/core/services/dhis2_http_service.dart';
import 'package:snake_app/core/services/preference_service.dart';

class UserService {
  final String preferenceKey = 'current_user';

  //TODO sign up user fn

  Future<User?> login({
    required String username,
    required String password,
  }) async {
    User? user;
    try {
      var url = 'api/me.json';
      var queryParameters = {
        'fields':
            'id,name,email,gender,phoneNumber,organisationUnits[id],userGroups[name,id,users[id,name,username]]',
      };
      Dhis2HttpService http = Dhis2HttpService(
        username: username,
        password: password,
      );
      var response = await http.httpGet(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        user = User.fromJson(json.decode(response.body), username, password);
      }
      return user;
    } catch (error) {
      rethrow;
    }
  }

  Future<String> changeCurrentUserPassword(
    String oldPassword,
    String newPassword,
  ) async {
    var url = 'api/me/changePassword';
    String message = '';
    try {
      User? user = await getCurrentUser();
      Dhis2HttpService http = Dhis2HttpService(
        username: user?.username ?? '',
        password: user?.password ?? '',
      );
      var response = await http.httpPut(
        url,
        json.encode({'oldPassword': oldPassword, 'newPassword': newPassword}),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        var responseBody = json.decode(response.body);
        message = responseBody['message'] ?? '';
      }
    } catch (error) {
      message = error.toString();
    }
    return message;
  }

  Future logout() async {
    User? user = await getCurrentUser();
    if (user != null) {
      user.isLogin = false;
      user.password = '';
      await setCurrentUser(user);
    }
  }

  Future<User?> getCurrentUser() async {
    String? userId = await PreferenceService.getPreferenceValue(preferenceKey);
    List<User> users = await UserOfflineProvider().getUsers();
    List<User> filteredUsers = users
        .where((User user) => user.id == userId)
        .toList();
    return filteredUsers.isNotEmpty ? filteredUsers[0] : null;
  }

  setCurrentUser(User user) async {
    await UserOfflineProvider().addOrUpdateUser(user);
    await PreferenceService.setPreferenceValue(preferenceKey, user.id);
  }
}
