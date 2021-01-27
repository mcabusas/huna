import 'package:huna/services/auth_services.dart';
import '../services/auth_services.dart';

class MyProfileModel {

  AuthServices _services = new AuthServices();

  Future<Map<String, dynamic>> myProfileData() async {
    return _services.userProfile();
  }


}