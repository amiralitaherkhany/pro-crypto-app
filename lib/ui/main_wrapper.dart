import 'package:crypto_app/providers/crypto_data_provider.dart';
import 'package:crypto_app/ui/home_page.dart';
import 'package:crypto_app/ui/market_view_page.dart';
import 'package:crypto_app/ui/profile_page.dart';
import 'package:crypto_app/ui/ui_helper/bottom_nav.dart';
import 'package:crypto_app/ui/watch_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/market_view_provider.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final PageController _myPage = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNav(
        controller: _myPage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        onPressed: () {},
        child: Icon(
          Icons.compare_arrows_outlined,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      body: PageView(
        controller: _myPage,
        children: [
          ChangeNotifierProvider(
              create: (context) => CryptoDataProvider(),
              child: const HomePage()),
          ChangeNotifierProvider(
            create: (context) => MarketViewProvider(),
            child: const MarketViewPage(),
          ),
          const ProfilePage(),
          const WatchListPage(),
        ],
      ),
    );
  }
}
