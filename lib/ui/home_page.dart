import 'package:crypto_app/ui/ui_helper/home_page_view.dart';
import 'package:crypto_app/ui/ui_helper/theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageViewController = PageController(initialPage: 0);

  var defaultChoiceIndex = 0;

  final List<String> _choicesList = [
    'Top MarketCaps',
    'Top Gainers',
    'Top Losers'
  ];

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: const [
          ThemeSwitcher(),
        ],
        title: const Text('ExchangeBs'),
        titleTextStyle: textTheme.titleLarge,
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  right: 5,
                  left: 5,
                ),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      HomePageView(controller: _pageViewController),
                      Positioned(
                        bottom: 10,
                        child: SmoothPageIndicator(
                          controller: _pageViewController,
                          count: 4,
                          effect: ExpandingDotsEffect(
                              activeDotColor: primaryColor,
                              dotWidth: 10,
                              dotHeight: 10),
                          onDotClicked: (index) {
                            _pageViewController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                width: double.infinity,
                child: Marquee(
                  text: 'this is a place for news in application - ',
                  style: textTheme.bodySmall,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Buy',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Sell',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5),
                child: Row(
                  children: [
                    Wrap(
                      spacing: 8,
                      children: List.generate(
                        _choicesList.length,
                        (index) {
                          return ChoiceChip(
                            label: Text(
                              _choicesList[index],
                            ),
                            selected: defaultChoiceIndex == index,
                            labelStyle: textTheme.titleSmall,
                            showCheckmark: false,
                            side: const BorderSide(color: Colors.transparent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.grey[300],
                            selectedColor: primaryColor,
                            onSelected: (value) {
                              if (value) {
                                setState(() {
                                  defaultChoiceIndex = index;
                                });
                              }
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
