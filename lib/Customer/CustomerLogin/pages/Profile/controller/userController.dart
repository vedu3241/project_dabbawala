import 'package:get/get.dart';

class UserController extends GetxController {
  var userName = ''.obs;
  var isProfileComplete = false.obs;

  void setUser(String name, bool profileStatus) {
    userName.value = name;
    isProfileComplete.value = profileStatus;
  }
}
