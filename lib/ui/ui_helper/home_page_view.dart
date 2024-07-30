import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key, required this.controller});
  final PageController controller;

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  var images = [
    'images/a1.png',
    'images/a2.png',
    'images/a3.png',
    'images/a4.png',
  ];
  @override
  Widget build(BuildContext context) {
    return PageView(
      allowImplicitScrolling: true,
      controller: widget.controller,
      children: [
        myPages(images[0]),
        myPages(images[1]),
        myPages(images[2]),
        myPages(images[3]),
      ],
    );
  }

  Widget myPages(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image.asset(
        image,
        fit: BoxFit.fill,
      ),
    );
  }
}
