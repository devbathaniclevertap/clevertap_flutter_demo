import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/presentation/widgets/common_boxshadow_container.dart';
import 'package:flutter_clevertap_demo/presentation/widgets/common_textfield.dart';
import 'package:flutter_clevertap_demo/providers/home_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cleverTapPlugin = CleverTapPlugin();
  @override
  void initState() {
    CleverTapPlugin.setDebugLevel(3);
    _cleverTapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
      Provider.of<HomeProvider>(
        context,
        listen: false,
      ).pushClickedPayloadReceived,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeState, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Clevertap Flutter Demo",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 2,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 24),
                  Center(
                    child: Text(
                      "Enter the data to check the entry on dashboard",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter name",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      CommonTextfield(
                        hintText: "Dev Bathani",
                        controller: homeState.nameController,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Enter email",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      CommonTextfield(
                        hintText: "dev.bathani@clevertap.com",
                        controller: homeState.emailController,
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Enter phone number",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      CommonTextfield(
                        hintText: "+91 7202897611",
                        controller: homeState.phoneNumberController,
                        textInputType: TextInputType.phone,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Enter identity",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      CommonTextfield(
                        hintText: "abc@123",
                        controller: homeState.identityController,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Enter Stuff",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      CommonTextfield(
                        hintText: "data",
                        controller: homeState.stuffController,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  DropdownButton<String>(
                    value: homeState.selectedAction,
                    items:
                        homeState.actions.map((String action) {
                          return DropdownMenuItem<String>(
                            value: action,
                            child: Text(action),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        homeState.updateSelectedAction(newValue);
                      }
                    },
                  ),
                  SizedBox(height: 60),
                  Row(
                    children: [
                      Expanded(
                        child: CommonBoxshadowContainer(
                          onTap: () {
                            homeState.addStuff();
                          },
                          color: Color(0xff6EC6A9),
                          child: Center(
                            child: Text(
                              "Add stuff",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CommonBoxshadowContainer(
                          onTap: () {
                            homeState.clearStuff();
                          },
                          color: Color(0xff6EC6A9),
                          child: Center(
                            child: Text(
                              "Clear stuff",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  CommonBoxshadowContainer(
                    onTap: () {
                      if (homeState.selectedAction == "onUserLogin") {
                        homeState.onUserLogin();
                      } else if (homeState.selectedAction == "profilePush") {
                        homeState.profilePush();
                      } else if (homeState.selectedAction == "recordEvent") {
                        homeState.recordEvent();
                      } else if (homeState.selectedAction == "profileSet") {
                        homeState.profileSet();
                      } else if (homeState.selectedAction == "getCleverTapId") {
                        homeState.getCleverTapId();
                      } else if (homeState.selectedAction == "setLocation") {
                        homeState.setLocation();
                      } else if (homeState.selectedAction ==
                          "createPushNotification") {
                        homeState.createPushNotification();
                      } else if (homeState.selectedAction ==
                          "getNotificationPermission") {
                        homeState.getNotificationPermission();
                      }
                    },
                    color: Color(0xff6EC6A9),
                    child: Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
