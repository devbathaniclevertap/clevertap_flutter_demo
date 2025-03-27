import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController identityController = TextEditingController();

  String selectedAction = "onUserLogin";
  final List<String> actions = ["onUserLogin", "profilePush", "recordEvent"];

  void updateSelectedAction(String data) {
    selectedAction = data;
    notifyListeners();
  }

  //Onuserlogin
  void onUserLogin() {
    var stuff = ["bags", "shoes"];
    var profile = {
      'Name': nameController.text,
      'Identity': identityController.text,
      'Email': emailController.text,
      'Phone': phoneNumberController.text,
      'stuff': stuff,
    };
    CleverTapPlugin.onUserLogin(profile);
  }

  //profilePush
  void profilePush() {
    var stuff = ["bags", "shoes"];
    var profile = {
      'Name': nameController.text,
      'Identity': identityController.text,
      'Email': emailController.text,
      'Phone': phoneNumberController.text,
      'stuff': stuff,
    };
    CleverTapPlugin.profileSet(profile);
  }

  //recordEvent
  void recordEvent() {
    CleverTapPlugin.recordEvent("Product Viewed", {"product_name": "Vada pav"});
  }
}
