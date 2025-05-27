import 'dart:developer';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/models/product_icon_entity.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ProductExperienceProvider extends ChangeNotifier {
  ProductIconEntity? productIconEntity;

  Future getIconData() async {
    CleverTapPlugin.defineVariables({"Icon Data": "Data"});
    await CleverTapPlugin.syncCustomTemplatesInProd(true);
    await CleverTapPlugin.fetchVariables();
    CleverTapPlugin.getVariable('Icon Data').then(
      (variable) {
        try {
          log("Raw Data: $variable");
          print("Raw Data: ${variable.runtimeType}");
          productIconEntity = productIconEntityFromJson(variable);
          notifyListeners();
        } catch (e, stack) {
          log("Error parsing data: $e");
          log("Stack trace: $stack");
        }
      },
    );
  }

  void onButtonClick(IconsData data) async {
    try {
      // Create a mutable copy of the data
      final Map<String, dynamic> buttonData = data.toJson();

      // Get current clicks from existing data if available
      int currentClicks = 0;
      if (productIconEntity?.iconData != null) {
        final existing = _findExistingItem(data.id);
        if (existing != null) {
          currentClicks = existing.clicked;
        }
      }

      // Increment clicks
      currentClicks += 1;
      buttonData['clicked'] = currentClicks;

      final userEventdata = {
        "id": buttonData['id'],
        "title": buttonData['title'],
        "image_url": buttonData['image_url'],
        "position": buttonData['position'],
        "clicked": currentClicks,
      };

      final userPropertydata = [
        buttonData['id'].toString(),
        buttonData['title'].toString(),
        buttonData['image_url'].toString(),
        buttonData['position'].toString(),
        currentClicks.toString(),
      ];

      // Update ClerverTap profile with button data
      await CleverTapPlugin.profileSet({"button_clicked": userPropertydata});
      // Record event with updated click count
      await CleverTapPlugin.recordEvent("button_clicked", userEventdata);
      await Future.delayed(Duration(seconds: 2));
      CleverTapPlugin.defineVariables({"Button Clicked Data": "Data"});
      await CleverTapPlugin.syncCustomTemplatesInProd(true);
      await CleverTapPlugin.fetchVariables();
      CleverTapPlugin.getVariable('Button Clicked Data').then(
        (variable) {
          try {
            String rawString = variable.toString();
            log("Raw string: $rawString");

            // Extract components as before
            final RegExp idRegex = RegExp(r'^[^A-Z]+');
            final String id = idRegex.stringMatch(rawString) ?? '';
            rawString = rawString.substring(id.length);

            final String title = rawString.split('http')[0];
            rawString = 'http${rawString.split('http')[1]}';

            final RegExp urlRegex = RegExp(r'https?://[^,\s]+\.png');
            final String imageUrl = urlRegex.stringMatch(rawString) ?? '';
            rawString = rawString.substring(imageUrl.length);

            final List<String> numbers =
                rawString.replaceAll(RegExp(r'[^\d]'), '').split('');
            final String position = numbers.length > 1
                ? numbers.sublist(0, numbers.length - 1).join()
                : numbers[0];
            final String clicked =
                currentClicks.toString(); // Use the actual click count

            log("""Separated components:
ID: $id
Title: $title
Image URL: $imageUrl
Position: $position
Clicked: $clicked""");

            // Update and sort sections with correct click count
            if (productIconEntity?.iconData != null) {
              _updateAndSortSections(id, title, imageUrl, position, clicked);
              log("Sections sorted by click count");
            }

            notifyListeners();
          } catch (e) {
            log("Error parsing variable data: $e");
          }
        },
      );
    } catch (e) {
      log("Error in onButtonClick: $e");
    }
  }

  void _updateAndSortSections(String id, String title, String imageUrl,
      String position, String clicked) {
    // Update sections
    _updateSection(productIconEntity!.iconData.quickLinks, id, title, imageUrl,
        position, clicked, "quick_links");
    _updateSection(productIconEntity!.iconData.productSection, id, title,
        imageUrl, position, clicked, "product_section");
    _updateSection(productIconEntity!.iconData.priceSection, id, title,
        imageUrl, position, clicked, "price_section");
    _updateSection(productIconEntity!.iconData.serviceSection, id, title,
        imageUrl, position, clicked, "service_section");

    // Sort all sections
    _sortAndUpdatePositions(productIconEntity!.iconData.quickLinks);
    _sortAndUpdatePositions(productIconEntity!.iconData.productSection);
    _sortAndUpdatePositions(productIconEntity!.iconData.priceSection);
    _sortAndUpdatePositions(productIconEntity!.iconData.serviceSection);
  }

  void _updateSection(List<IconsData> section, String id, String title,
      String imageUrl, String position, String clicked, String sectionName) {
    for (var i = 0; i < section.length; i++) {
      if (section[i].id == id) {
        section[i] = IconsData(
          id: id,
          title: title,
          imageUrl: imageUrl,
          position: int.parse(position),
          clicked: int.parse(clicked),
          isAnimated: true,
        );
        log("Updated $sectionName item with id: $id");
      }
    }
  }

  void _sortAndUpdatePositions(List<IconsData> section) {
    section.sort((a, b) => (b.clicked).compareTo(a.clicked));

    for (var i = 0; i < section.length; i++) {
      section[i] = IconsData(
        id: section[i].id,
        title: section[i].title,
        imageUrl: section[i].imageUrl,
        position: i,
        clicked: section[i].clicked,
        isAnimated: section[i].isAnimated,
      );
    }
  }

  // Add this helper method to find existing item
  IconsData? _findExistingItem(String id) {
    if (productIconEntity?.iconData != null) {
      for (var item in productIconEntity!.iconData.quickLinks) {
        if (item.id == id) return item;
      }
      for (var item in productIconEntity!.iconData.productSection) {
        if (item.id == id) return item;
      }
      for (var item in productIconEntity!.iconData.priceSection) {
        if (item.id == id) return item;
      }
      for (var item in productIconEntity!.iconData.serviceSection) {
        if (item.id == id) return item;
      }
    }
    return null;
  }

  final _cleverTapPlugin = CleverTapPlugin();
  void activateCleverTapFlutterPluginHandlers() {
    print("In activateCleverTapFlutterPluginHandlers");
    _cleverTapPlugin
        .setCleverTapCustomTemplatePresentHandler(presentCustomTemplate);
    _cleverTapPlugin
        .setCleverTapCustomTemplateCloseHandler(closeCustomTemplate);
  }

  BuildContext? _context;
  GlobalKey? _icon0Key;
  GlobalKey? _icon1Key;
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  void setContext(BuildContext context) {
    _context = context;
  }

  void setTargetKeys(GlobalKey icon0, GlobalKey icon1) {
    _icon0Key = icon0;
    _icon1Key = icon1;
  }

  void showTutorial(String iconData0, String iconData1, String templateName) {
    if (_context == null || _icon0Key == null || _icon1Key == null) {
      print("Context or keys not set");
      return;
    }

    targets = [
      TargetFocus(
        identify: "Target 1",
        keyTarget: _icon0Key,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Access',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      iconData0,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.next(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                      ),
                      child: Text('Next'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "Target 2",
        keyTarget: _icon1Key,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom, // Changed from top to bottom
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(16),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Items',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      iconData1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => controller.previous(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Previous'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.skip();
                              closeCustomTemplate(templateName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Done'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ];

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        log("Tutorial finished");
      },
      onClickTarget: (target) {
        log("Clicked on ${target.identify}");
      },
    )..show(context: _context!);
  }

  void presentCustomTemplate(String templateName) async {
    print("presentCustomTemplate $templateName");
    setCustomTemplatePresented(templateName);
    String? icon0Data = await CleverTapPlugin.customTemplateGetStringArg(
        templateName, 'icon_0');
    String? icon1Data = await CleverTapPlugin.customTemplateGetStringArg(
        templateName, 'icon_1');
    print(icon0Data.toString());
    print(icon1Data.toString());
    if (icon0Data != null && icon1Data != null) {
      showTutorial(icon0Data, icon1Data, templateName);
    }
  }

  void closeCustomTemplate(String templateName) async {
    print("closeCustomTemplate $templateName");
    CleverTapPlugin.customTemplateSetDismissed(templateName);
  }

  void setCustomTemplatePresented(String templateName) {
    CleverTapPlugin.customTemplateSetPresented(templateName);
  }

  final GlobalKey icon_0 = GlobalKey();
  final GlobalKey icon_1 = GlobalKey();
}
