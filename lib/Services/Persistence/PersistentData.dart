import 'package:greamit_app/Model/user.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Services/Persistence/persistenceModel.dart';

UserModel _userModel;

void setUser(UserModel userModel) {
  _userModel = userModel;
  persistUser(userModel);
}

UserModel get getUser => _userModel;