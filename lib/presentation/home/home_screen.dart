import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clevertap_demo/presentation/product-experience/product_experience_screen.dart';
import 'package:flutter_clevertap_demo/presentation/product/product_screen.dart';
import 'package:flutter_clevertap_demo/presentation/widgets/common_boxshadow_container.dart';
import 'package:flutter_clevertap_demo/presentation/widgets/common_textfield.dart';
import 'package:flutter_clevertap_demo/presentation/widgets/native_view_builder.dart';
import 'package:flutter_clevertap_demo/providers/home_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cleverTapPlugin = CleverTapPlugin();
  StreamSubscription<Uri>? _linkSubscription;
  static const platform = MethodChannel('clevertap_deeplink_channel');
  @override
  void initState() {
    super.initState();

    CleverTapPlugin.initializeInbox();
    CleverTapPlugin.setDebugLevel(4);
    CleverTapPlugin.enableDeviceNetworkInfoReporting(true);
    initDeepLinks();
    createNotificationChannel();
    _cleverTapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
      context.read<HomeProvider>().pushClickedPayloadReceived,
    );
    _cleverTapPlugin.setCleverTapDisplayUnitsLoadedHandler(
      (displayUnitList) {
        context
            .read<HomeProvider>()
            .onDisplayUnitsLoaded(displayUnitList, context);
      },
    );
    // Listen to native method calls
    platform.setMethodCallHandler((call) async {
      if (call.method == "clevertapDeeplink") {
        final url = call.arguments as String;
        handleDeeplinkFromNative(url);
      }
    });
    _cleverTapPlugin.setCleverTapInboxMessagesDidUpdateHandler(
      context.read<HomeProvider>().inboxMessagesDidUpdate,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().initDeepLinks(context);
    });

    super.initState();
  }

  Future createNotificationChannel() async {
    await CleverTapPlugin.createNotificationChannel(
        "channelId", "channelName", "channelDescription", 1, true);
  }

  void handleDeeplinkFromNative(String url) {
    print("CleverTap Native Deeplink: $url");
    Fluttertoast.showToast(msg: "From Native: $url");
    Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen()));
  }

  Future<void> initDeepLinks() async {
    // Handle links
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
      print('onAppLink: $uri');
      Fluttertoast.showToast(msg: "URL : $uri");
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeState, _) {
        return Scaffold(
          appBar: AppBar(
            title: InkWell(
              onTap: () async {
                // Update ClerverTap profile with button data
                await CleverTapPlugin.recordEvent("scratch card", {});
              },
              child: Text(
                "Clevertap Flutter Demo",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
                      // Name field
                      Stack(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 200,
                            child: Text(
                              "Enter name",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          NativeTaggedView(tag: "profile_image"),
                        ],
                      ),
                      SizedBox(height: 4),
                      CommonTextfield(
                        hintText: "Dev Bathani",
                        controller: homeState.nameController,
                      ),
                      SizedBox(height: 16),
                      // Email field
                      Stack(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 200,
                            child: Text(
                              "Enter email",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          NativeTaggedView(tag: "search"),
                        ],
                      ),
                      SizedBox(height: 4),
                      CommonTextfield(
                        hintText: "dev.bathani@clevertap.com",
                        controller: homeState.emailController,
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16),

                      // Phone number field
                      Stack(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 200,
                            child: Text(
                              "Enter phone number",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          NativeTaggedView(tag: "cart"),
                        ],
                      ),
                      SizedBox(height: 4),
                      CommonTextfield(
                        hintText: "+91 7202897611",
                        controller: homeState.phoneNumberController,
                        textInputType: TextInputType.phone,
                      ),
                      SizedBox(height: 16),

                      // Identity field
                      Stack(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 200,
                            child: Text(
                              "Enter identity",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          NativeTaggedView(tag: "support_help"),
                        ],
                      ),
                      SizedBox(height: 4),
                      CommonTextfield(
                        hintText: "abc@123",
                        controller: homeState.identityController,
                      ),
                      SizedBox(height: 16),

                      // Stuff field
                      Stack(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 200,
                            child: Text(
                              "Enter Stuff",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          NativeTaggedView(tag: "settings"),
                        ],
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
                    items: homeState.actions.map((String action) {
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
                        homeState.recordEvent(context);
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
                      } else if (homeState.selectedAction == "getAppBoxData") {
                      } else if (homeState.selectedAction ==
                          "productExperience") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductExperienceScreen(),
                          ),
                        );
                      } else if (homeState.selectedAction == "getAppBoxData") {
                        homeState.getAppBoxData();
                      } else if (homeState.selectedAction == "makeACall") {
                        // homeState.makeSignedCall();
                      } else if (homeState.selectedAction ==
                          "inboxDidInitialize") {
                        homeState.inboxDidInitialize();
                      } else if (homeState.selectedAction ==
                          "getLocationPermission") {
                        homeState.getLocationPermission();
                      } else if (homeState.selectedAction == "viewProducts") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductScreen(),
                          ),
                        );
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
