import 'package:crypto_app/ui/home_page.dart';
import 'package:crypto_app/ui/market_view_page.dart';
import 'package:crypto_app/ui/profile_page.dart';
import 'package:crypto_app/ui/ui_helper/bottom_nav.dart';
import 'package:crypto_app/ui/watch_list_page.dart';
import 'package:flutter/material.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final PageController _myPage = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(
        controller: _myPage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        onPressed: () {},
        child: const Icon(
          Icons.compare_arrows_outlined,
        ),
      ),
      body: PageView(
        controller: _myPage,
        children: const [
          HomePage(),
          MarketViewPage(),
          ProfilePage(),
          WatchListPage(),
        ],
      ),
    );
  }
}
