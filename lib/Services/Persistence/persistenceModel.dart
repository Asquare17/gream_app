import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:greamit_app/Model/user.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Utilities/Constants.dart';

final FlutterSecureStorage secureStorage = GetIt.I.get<FlutterSecureStorage>();

Future<void> persistUser(UserModel userModel) async {
  await secureStorage.write(key: USER, value: jsonEncode(userModel.toJson()));
}

Future<UserModel> getPersistedUser() async {
  final String userString = await secureStorage.read(key: USER);
  UserModel userModel;

  print('User string is $userString');

  try {
    final Map<String, dynamic> userMap = jsonDecode(userString);
    userModel = UserModel.fromJson(userMap);
  } catch (ex) {
    return null;
  }

  return userModel;
}

Future<void> deletePersistedUser() async {
  await secureStorage.delete(key: USER);
}
