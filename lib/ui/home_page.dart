import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_app/helpers/decimal_rounder.dart';
import 'package:crypto_app/models/crypto_model/crypto_data.dart';
import 'package:crypto_app/network/response_model.dart';
import 'package:crypto_app/providers/crypto_data_provider.dart';
import 'package:crypto_app/ui/ui_helper/home_page_view.dart';
import 'package:crypto_app/ui/ui_helper/theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageViewController = PageController(initialPage: 0);

  final List<String> _choicesList = [
    'Top MarketCaps',
    'Top Gainers',
    'Top Losers'
  ];
  // @override
  // void initState() {
  //   super.initState();

  //   final cryptoProvider =
  //       Provider.of<CryptoDataProvider>(context, listen: false);
  //   cryptoProvider.getTopMarketCapData();
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _getSlider(primaryColor),
              _getTextSlider(textTheme),
              const SizedBox(
                height: 10,
              ),
              _getButtons(),
              _getChoiceChips(
                textTheme,
                primaryColor,
              ),
              Consumer<CryptoDataProvider>(
                builder: (context, cryptoDataProvider, child) {
                  switch (cryptoDataProvider.state.status) {
                    case Status.loading:
                      return _getCoinShimmer();

                    case Status.completed:
                      List<CryptoData>? model = cryptoDataProvider
                          .dataFuture.data!.cryptoCurrencyList;
                      return _getCoinList(model, height, textTheme);

                    case Status.error:
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            switch (cryptoDataProvider.defaultChoiceIndex) {
                              case 0:
                                cryptoDataProvider.getTopMarketCapData();
                                break;
                              case 1:
                                cryptoDataProvider.getTopGainersData();
                                break;
                              case 2:
                                cryptoDataProvider.getTopLosersData();
                                break;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Try again',
                          ),
                        ),
                      );

                    default:
                      return Container();
                  }
                },
              ),
              const Divider(),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getChoiceChips(
    TextTheme textTheme,
    Color primaryColor,
  ) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5),
        child: Consumer<CryptoDataProvider>(
          builder: (context, cryptoDataProvider, child) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _choicesList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _choicesList[index],
                      ),
                    ),
                    selected: cryptoDataProvider.defaultChoiceIndex == index,
                    labelStyle: textTheme.titleSmall,
                    showCheckmark: false,
                    side: const BorderSide(color: Colors.transparent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.grey[300],
                    selectedColor: primaryColor,
                    onSelected: (bool selected) {
                      switch (index) {
                        case 0:
                          cryptoDataProvider.getTopMarketCapData();
                          break;
                        case 1:
                          cryptoDataProvider.getTopGainersData();

                          break;
                        case 2:
                          cryptoDataProvider.getTopLosersData();

                          break;
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Shimmer _getCoinShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8, top: 8, left: 8),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.add),
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 15,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            width: 25,
                            height: 15,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Flexible(
                fit: FlexFit.tight,
                child: SizedBox(
                  width: 70,
                  height: 40,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 15,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: 25,
                          height: 15,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ListView _getCoinList(
      List<CryptoData>? model, double height, TextTheme textTheme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var number = index + 1;
        var tokenId = model![index].id;
        MaterialColor filterColor = DecimalRounder.setColorFilter(
            model[index].quotes![0].percentChange24h);
        var finalPrice =
            DecimalRounder.removePriceDecimals(model[index].quotes![0].price);
        // percent change setup decimals and colors
        var percentChange = DecimalRounder.removePercentDecimals(
            model[index].quotes![0].percentChange24h);

        Color percentColor = DecimalRounder.setPercentChangesColor(
            model[index].quotes![0].percentChange24h);
        Icon percentIcon = DecimalRounder.setPercentChangesIcon(
            model[index].quotes![0].percentChange24h);

        return SizedBox(
          height: height * 0.075,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  number.toString(),
                  style: textTheme.bodySmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 15),
                child: CachedNetworkImage(
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.white,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                          ),
                        ),
                    fadeInDuration: const Duration(milliseconds: 500),
                    width: 32,
                    height: 32,
                    imageUrl:
                        'https://s2.coinmarketcap.com/static/img/coins/32x32/$tokenId.png'),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model[index].name!,
                      style: textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      model[index].symbol!,
                      style: textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(filterColor, BlendMode.srcATop),
                  child: SvgPicture.network(
                      'https://s3.coinmarketcap.com/generated/sparklines/web/1d/2781/$tokenId.svg'),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '\$$finalPrice',
                        style: textTheme.bodySmall,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          percentIcon,
                          Text(
                            '$percentChange%',
                            style: GoogleFonts.ubuntu(
                                color: percentColor, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: 10,
    );
  }

  Padding _getButtons() {
    return Padding(
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
    );
  }

  SizedBox _getTextSlider(TextTheme textTheme) {
    return SizedBox(
      height: 30,
      width: double.infinity,
      child: Marquee(
        text: 'this is a place for news in application - ',
        style: textTheme.bodySmall,
      ),
    );
  }

  Padding _getSlider(Color primaryColor) {
    return Padding(
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
                    activeDotColor: primaryColor, dotWidth: 10, dotHeight: 10),
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
    );
  }
}
