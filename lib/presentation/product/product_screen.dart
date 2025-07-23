import 'dart:convert';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/providers/cart_provider.dart';
import 'package:flutter_clevertap_demo/providers/product_experience_provider.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedTab = 1; // 0: Networth, 1: Savings, ...
  int selectedMainTab = 0; // 0: Home, 1: Transactions, ...
  int selectedBottomNav = 0;

  final List<Map<String, dynamic>> topTabs = [
    {"label": "NETWORTH", "color": Colors.black},
    {"label": "SAVINGS", "color": Color(0xFF8B1C1C)},
    {"label": "CREDIT CARDS", "color": Color(0xFF1A3C7B)},
    {"label": "LOANS", "color": Color(0xFF8B1C1C)},
    {"label": "MUTUAL FUNDS", "color": Color(0xFF3A3A3A)},
  ];

  final List<Map<String, dynamic>> sectionList = [
    {
      "label": "Payments",
      "subtitle": "One App for all Bills.",
      "color": Color(0xFFD6B24C),
      "textColor": Colors.white,
    },
    {
      "label": "Savings Accounts",
      "subtitle": "Fund more, earn more",
      "color": Color(0xFF8B1C1C),
      "textColor": Colors.white,
    },
    {
      "label": "Credit Cards",
      "subtitle": "Up to 20% off on brands",
      "color": Color(0xFF1A3C7B),
      "textColor": Colors.white,
    },
    {
      "label": "Mutual Funds",
      "subtitle": "Explore Top 100 Funds Now",
      "color": Color(0xFF3A3A3A),
      "textColor": Colors.white,
    },
    {
      "label": "Loans",
      "subtitle": "Apply for Personal Loan",
      "color": Color(0xFF8B1C1C),
      "textColor": Colors.white,
    },
  ];

  final List<Map<String, dynamic>> quickActions = [
    {"icon": Icons.send, "label": "Bank Transfer"},
    {
      "icon": Icons.flash_on,
      "label": "Instant\nCash ₹1,00,000",
      "badge": "Instant Cash"
    },
    {"icon": Icons.currency_rupee, "label": "Refer & Earn"},
  ];

  final List<String> mainTabs = ["Home", "Transactions", "Offers", "Services"];

  final List<Map<String, dynamic>> bottomNav = [
    {"icon": Icons.home, "label": "HOME"},
    {"icon": Icons.account_balance_wallet, "label": "ACCOUNTS"},
    {"icon": Icons.currency_rupee, "label": "PAY"},
    {"icon": Icons.account_balance, "label": "LOANS"},
    {"icon": Icons.qr_code_scanner, "label": "SCAN"},
  ];

  final List<Map<String, dynamic>> sectionListV2 = [
    {
      "label": "Loans",
      "subtitle": "Apply for Personal Loan",
      "color": Color(0xFF8B1C1C),
      "textColor": Colors.white,
    },
    {
      "label": "Wealth Management",
      "subtitle": "Invest in just 3 clicks!",
      "color": Color(0xFF3A3A3A),
      "textColor": Colors.white,
    },
    {
      "label": "Financial Planning",
      "subtitle": "Start SIPs. Track Goals",
      "color": Color(0xFF8B1C1C),
      "textColor": Colors.white,
    },
    {
      "label": "Insurance",
      "subtitle": "Secure your future today",
      "color": Color(0xFFE07B3A),
      "textColor": Colors.white,
    },
    {
      "label": "Deposits",
      "subtitle": "Book an FD/RD in 2 clicks",
      "color": Color(0xFF8B1C1C),
      "textColor": Colors.white,
    },
    {
      "label": "Recharges & Bills",
      "subtitle": "Tap to pay bills here!",
      "color": Color(0xFFD6B24C),
      "textColor": Colors.white,
    },
    {
      "label": "Travel and Shop",
      "subtitle": "Travel Bookings made easy",
      "color": Color(0xFF7B5A3A),
      "textColor": Colors.white,
    },
    {
      "label": "Customer Service",
      "subtitle": "",
      "color": Color(0xFFD6B24C),
      "textColor": Colors.white,
      "hasIcons": true,
    },
  ];

  final List<Map<String, dynamic>> referCards = [
    {
      "title": "All Bank Products",
      "color": Color(0xFFE07B3A),
      "buttonColor": Colors.white,
      "buttonTextColor": Color(0xFFE07B3A),
      "image": null,
    },
    {
      "title": "Savings Accounts",
      "color": Color(0xFF8B1C1C),
      "buttonColor": Colors.white,
      "buttonTextColor": Color(0xFF8B1C1C),
      "image": null,
    },
    {
      "title": "Credit Cards",
      "color": Color(0xFF1A3C7B),
      "buttonColor": Colors.white,
      "buttonTextColor": Color(0xFF1A3C7B),
      "image": null,
    },
  ];
  final _cleverTapPlugin = CleverTapPlugin();
  @override
  void initState() {
    _cleverTapPlugin.setCleverTapDisplayUnitsLoadedHandler(
        context.read<CartProvider>().onDisplayUnitsLoaded);
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      context.read<CartProvider>().getAdUnits();
    });
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      final provider = context.read<ProductExperienceProvider>();
      provider.setContext(context);

      provider.getIconData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductExperienceProvider>(
      builder: (context, productState, _) {
        return Scaffold(
          backgroundColor: Color(0xFFF8F8F8),
          body: SafeArea(
            child: Column(
              children: [
                // Top search bar and icons
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: Icon(Icons.menu, color: Colors.black),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 12),
                              Icon(Icons.qr_code_scanner, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Type  “Scan QR”',
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Icon(Icons.search, color: Colors.red.shade900),
                              SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon:
                            Icon(Icons.notifications_none, color: Colors.black),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.power_settings_new, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                // Horizontal tab bar
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    itemCount: productState.menuOptionKeys.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      final tab = productState.menuOptionKeys[idx];
                      final isSelected = selectedTab == idx;
                      return GestureDetector(
                        onTap: () => setState(() => selectedTab = idx),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Color(0xFF8B1C1C) : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Main scrollable content
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // Account Card as SliverToBoxAdapter
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: productState.menuOption != null
                              ? AccountCardWidget(
                                  cardData: productState
                                          .menuOptionKeys.isNotEmpty
                                      ? (productState.menuOption![productState
                                                  .menuOptionKeys[selectedTab]]
                                              is String
                                          ? Map<String, dynamic>.from(
                                              // Try to decode the JSON string to Map
                                              // If decoding fails, fallback to empty map
                                              (() {
                                                try {
                                                  return jsonDecode(productState
                                                      .menuOption![productState
                                                          .menuOptionKeys[
                                                      selectedTab]]);
                                                } catch (e) {
                                                  return {};
                                                }
                                              })(),
                                            )
                                          : Map<String, dynamic>.from(
                                              productState.menuOption![
                                                      productState
                                                              .menuOptionKeys[
                                                          selectedTab]] ??
                                                  {},
                                            ))
                                      : {},
                                )
                              : SizedBox.shrink(),
                        ),
                      ),
                      // Main Tabs (Home, Transactions, ...)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              ...List.generate(
                                  productState.serviceOptionKeys.length, (idx) {
                                final isSelected = selectedMainTab == idx;
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedMainTab = idx),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 4),
                                    child: Column(
                                      children: [
                                        Text(
                                          productState.serviceOptionKeys[idx],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Color(0xFF8B1C1C)
                                                : Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        if (isSelected)
                                          Container(
                                            height: 3,
                                            width: 28,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF8B1C1C),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              Spacer(),
                              Icon(Icons.tune, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                      // Section List (V2)
                      SliverList(
                        delegate: SliverChildListDelegate([
                          // Dynamically build the section list from provider's serviceOption
                          ...(() {
                            final selectedMainTabKey =
                                productState.serviceOptionKeys[selectedMainTab];
                            final dynamic mainTabRaw =
                                productState.serviceOption?[selectedMainTabKey];
                            List<dynamic> sectionList = [];
                            if (mainTabRaw is String) {
                              sectionList = jsonDecode(mainTabRaw);
                            } else if (mainTabRaw is List) {
                              sectionList = mainTabRaw;
                            }
                            return List.generate(sectionList.length, (idx) {
                              final section = sectionList[idx];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 6),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(section["color"]
                                        .replaceAll('#', '0xFF'))),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 4),
                                    title: Text(
                                      section["label"] ?? '',
                                      style: TextStyle(
                                        color: Color(int.parse(
                                            section["textColor"]
                                                .replaceAll('#', '0xFF'))),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    subtitle:
                                        (section["subtitle"] ?? '').isNotEmpty
                                            ? Text(
                                                section["subtitle"],
                                                style: TextStyle(
                                                  color: Color(int.parse(
                                                          section["textColor"]
                                                              .replaceAll(
                                                                  '#', '0xFF')))
                                                      .withOpacity(0.85),
                                                  fontSize: 14,
                                                ),
                                              )
                                            : null,
                                    trailing: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Color(int.parse(
                                            section["textColor"]
                                                .replaceAll('#', '0xFF')))),
                                    onTap: () {},
                                  ),
                                ),
                              );
                            });
                          })(),
                        ]),
                      ),
                      // Refer and Earn section as SliverToBoxAdapter
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 18),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Text(
                                'Refer and Earn',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 120,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                itemCount: referCards.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(width: 12),
                                itemBuilder: (context, idx) {
                                  final card = referCards[idx];
                                  return Container(
                                    width: 170,
                                    decoration: BoxDecoration(
                                      color: card["color"],
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Icon at the top (no image)
                                          Icon(Icons.card_giftcard,
                                              color: Colors.white, size: 32),
                                          SizedBox(height: 8),
                                          Text(
                                            card["title"],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 18),
                          ],
                        ),
                      ),
                      // Add a new sliver section for the Settings and Limits, Save the Planet, and landscape image UI:
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                              child: Text(
                                'Settings and Limits',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Color(0xFFE9E9EA),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _settingsIcon(
                                        Icons.dialpad, 'Change\nMPIN'),
                                    _settingsIcon(Icons.account_circle,
                                        'Change\nPreferred A/C'),
                                    _settingsIcon(Icons.phone_android,
                                        'Device\nManagement'),
                                    _settingsIcon(Icons.credit_card,
                                        'Manage Debit\nCard Limits'),
                                    _settingsIcon(
                                        Icons.credit_card, 'Manage\nCards'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 32),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Save the Planet',
                                    style: TextStyle(
                                      color: Color(0xFF218B4A),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: Text(
                                      'Do your bit for a greener future with our green-banking products. ',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text.rich(
                                        TextSpan(
                                          text: '',
                                          children: [
                                            TextSpan(
                                              text: 'Learn more',
                                              style: TextStyle(
                                                color: Colors.black,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 18),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF218B4A),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 48, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    child: Text('Book Green FD'),
                                  ),
                                  SizedBox(height: 32),
                                  // Placeholder for the landscape image
                                  Container(
                                    height: 140,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(horizontal: 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(32),
                                        topRight: Radius.circular(32),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFB6E2A1),
                                          Color(0xFF218B4A)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        // You can replace this with an SVG or PNG for a real landscape
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 24.0),
                                            child: Text(
                                              'Ethical • Digital • Social Good',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xFF8B1C1C),
            unselectedItemColor: Colors.black54,
            currentIndex: selectedBottomNav,
            onTap: (idx) => setState(() => selectedBottomNav = idx),
            items: bottomNav
                .map((item) => BottomNavigationBarItem(
                      icon: Icon(item["icon"]),
                      label: item["label"],
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  // Helper widget for settings icons
  Widget _settingsIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 32,
            child: Icon(icon, color: Color(0xFF8B1C1C), size: 32),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class AccountCardWidget extends StatelessWidget {
  final Map<String, dynamic> cardData;
  const AccountCardWidget({required this.cardData, super.key});

  Color parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  IconData getIcon(String name) {
    switch (name) {
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'chevron_right':
        return Icons.chevron_right;
      case 'credit_card':
        return Icons.credit_card;
      case 'visibility':
        return Icons.visibility;
      case 'visibility_off':
        return Icons.visibility_off;
      case 'info_outline':
        return Icons.info_outline;
      case 'account_balance':
        return Icons.account_balance;
      case 'pie_chart':
        return Icons.pie_chart;
      case 'trending_up':
        return Icons.trending_up;
      case 'trending_down':
        return Icons.trending_down;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'swap_horiz':
        return Icons.swap_horiz;
      case 'insights':
        return Icons.insights;
      case 'credit_score':
        return Icons.credit_score;
      case 'savings':
        return Icons.savings;
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'history':
        return Icons.history;
      case 'send':
        return Icons.send;
      case 'flash_on':
        return Icons.flash_on;
      case 'currency_rupee':
        return Icons.currency_rupee;
      case 'info':
        return Icons.info;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final header = cardData['header'];
    final balanceSection = cardData['balanceSection'];
    final addMoneyRow = cardData['addMoneyRow'];
    final actions = cardData['actions'] as List<dynamic>? ?? [];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: parseColor(cardData['backgroundColor'] ?? '#FFFFFF'),
        borderRadius:
            BorderRadius.circular((cardData['borderRadius'] ?? 18).toDouble()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    header['text'] ?? '',
                    style: TextStyle(
                      color: parseColor(header['textColor'] ?? '#FFFFFF'),
                      fontWeight: FontWeight.bold,
                      fontSize: (header['fontSize'] ?? 15).toDouble(),
                    ),
                  ),
                ),
                ...((header['rightIcons'] as List<dynamic>? ?? [])
                    .map((iconData) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            getIcon(iconData['icon']),
                            color: parseColor(iconData['color'] ?? '#FFFFFF'),
                            size: 20,
                          ),
                        ))),
              ],
            ),
            SizedBox(height: 16),
            // Balance Section
            Row(
              children: [
                Text(
                  balanceSection['label'] ?? '',
                  style: TextStyle(
                    color:
                        parseColor(balanceSection['labelColor'] ?? '#FFFFFF'),
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  balanceSection['value'] ?? '',
                  style: TextStyle(
                    color:
                        parseColor(balanceSection['valueColor'] ?? '#FFFFFF'),
                    fontWeight: FontWeight.bold,
                    fontSize:
                        (balanceSection['valueFontSize'] ?? 22).toDouble(),
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(width: 8),
                if (balanceSection['rightIcon'] != null)
                  Icon(
                    getIcon(balanceSection['rightIcon']['icon']),
                    color: parseColor(
                        balanceSection['rightIcon']['color'] ?? '#FFFFFF'),
                    size: 20,
                  ),
              ],
            ),
            SizedBox(height: 16),
            // Add Money Row
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: parseColor(
                        addMoneyRow['button']['backgroundColor'] ?? '#FFFFFF'),
                    foregroundColor: parseColor(
                        addMoneyRow['button']['textColor'] ?? '#000000'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          (addMoneyRow['button']['borderRadius'] ?? 24)
                              .toDouble()),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                  ),
                  child: Text(
                    addMoneyRow['button']['text'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    addMoneyRow['infoText']['text'] ?? '',
                    style: TextStyle(
                      color: parseColor(
                          addMoneyRow['infoText']['color'] ?? '#FFFFFF'),
                      fontSize: (addMoneyRow['infoText']['fontSize'] ?? 13)
                          .toDouble(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: actions.map((action) {
                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              parseColor(action['iconBackground'] ?? '#FFFFFF'),
                          radius: 22,
                          child: Icon(
                            getIcon(action['icon']),
                            color: parseColor(action['iconColor'] ?? '#000000'),
                          ),
                        ),
                        if (action['badge'] != null)
                          Positioned(
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: parseColor(action['badge']
                                        ['backgroundColor'] ??
                                    '#000000'),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                action['badge']['text'] ?? '',
                                style: TextStyle(
                                  color: parseColor(action['badge']
                                          ['textColor'] ??
                                      '#FFFFFF'),
                                  fontSize: (action['badge']['fontSize'] ?? 10)
                                      .toDouble(),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      action['label'] ?? '',
                      style: TextStyle(
                        color: parseColor(action['labelColor'] ?? '#000000'),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
