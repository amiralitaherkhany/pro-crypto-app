import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../helpers/decimal_rounder.dart';
import '../models/crypto_model/crypto_data.dart';
import '../network/response_model.dart';
import '../providers/market_view_provider.dart';
import 'ui_helper/shimmer_market_widget.dart';

class MarketViewPage extends StatelessWidget {
  const MarketViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    var primaryColor = Theme.of(context).primaryColor;
    var borderColor = Theme.of(context).secondaryHeaderColor;

    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: Theme.of(context).iconTheme,
        // leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
        // actions: const [
        //   ThemeSwitcher(),
        // ],
        title: const Text("Market View"),
        titleTextStyle: textTheme.titleLarge,
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: textTheme.bodySmall,
                onSubmitted: (value) {
                  Provider.of<MarketViewProvider>(context, listen: false)
                      .serachCoin(value);
                },
                onChanged: (value) {
                  // List<CryptoData>? searchList = [];
                  //
                  // for(CryptoData crypto in model!){
                  //   if(crypto.name!.toLowerCase().contains(value) || crypto.symbol!.toLowerCase().contains(value)){
                  //     searchList.add(crypto);
                  //   }
                  // }
                  // marketViewProvider.configSearch(searchList);
                },
                // controller: searchController,
                decoration: InputDecoration(
                  hintStyle: textTheme.bodySmall,
                  prefixIcon: Icon(
                    Icons.search,
                    color: borderColor,
                  ),
                  hintText: 'Search...',
                  // hintText: AppLocalizations.of(context)!.search,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<MarketViewProvider>(
                builder: (context, marketViewProvider, child) {
                  switch (marketViewProvider.state.status) {
                    case Status.loading:
                      return const ShimmerMarketWidget();
                    case Status.completed:
                      List<CryptoData>? model = marketViewProvider
                          .dataFuture.data!.cryptoCurrencyList;
                      return RefreshIndicator(
                        onRefresh: () async {
                          await marketViewProvider.getCryptoData();
                          marketViewProvider.response.statusCode == 200
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    closeIconColor:
                                        Theme.of(context).iconTheme.color,
                                    showCloseIcon: true,
                                    backgroundColor: primaryColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.only(bottom: 5.0),
                                    content: Text(
                                      'Updatd !',
                                      style: textTheme.bodySmall,
                                    ),
                                  ),
                                )
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    closeIconColor:
                                        Theme.of(context).iconTheme.color,
                                    showCloseIcon: true,
                                    backgroundColor: primaryColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.only(bottom: 5.0),
                                    content: Text(
                                      'Update Failed !',
                                      style: textTheme.bodySmall,
                                    ),
                                  ),
                                );
                        },
                        color: Colors.white,
                        backgroundColor: primaryColor,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          itemCount: model!.length,
                          itemBuilder: (context, index) {
                            var number = index + 1;
                            var tokenId = model[index].id;

                            // get filter color for chart (green or red)
                            MaterialColor filterColor =
                                DecimalRounder.setColorFilter(
                                    model[index].quotes![0].percentChange24h);

                            // get price decimals fix
                            var finalPrice = DecimalRounder.removePriceDecimals(
                                model[index].quotes![0].price);

                            // percent change setup decimals and colors
                            var percentChange =
                                DecimalRounder.removePercentDecimals(
                                    model[index].quotes![0].percentChange24h);

                            Color percentColor =
                                DecimalRounder.setPercentChangesColor(
                                    model[index].quotes![0].percentChange24h);
                            Icon percentIcon =
                                DecimalRounder.setPercentChangesIcon(
                                    model[index].quotes![0].percentChange24h);

                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: InkWell(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => TokenDetailPage(cryptoData: model[index])));
                                },
                                child: SizedBox(
                                  height: height * 0.075,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          number.toString(),
                                          style: textTheme.bodySmall,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 15),
                                        child: CachedNetworkImage(
                                          fadeInDuration:
                                              const Duration(milliseconds: 500),
                                          height: 32,
                                          width: 32,
                                          imageUrl:
                                              "http://s2.coinmarketcap.com/static/img/coins/32x32/$tokenId.png",
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey.shade400,
                                            highlightColor: Colors.white,
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                        // flex: 2,
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              filterColor, BlendMode.srcATop),
                                          child: SvgPicture.network(
                                            "http://s3.coinmarketcap.com/generated/sparklines/web/30d/2781/$tokenId.svg",
                                          ),
                                        ),
                                      ),
                                      // Spacer(),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  "\$$finalPrice",
                                                  style: textTheme.bodySmall,
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    percentIcon,
                                                    Text(
                                                      "$percentChange%",
                                                      style: GoogleFonts.ubuntu(
                                                          color: percentColor,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    case Status.error:
                      return Center(
                        child: ElevatedButton(
                          onPressed: () {
                            marketViewProvider.getCryptoData();
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
                      return const ShimmerMarketWidget();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
