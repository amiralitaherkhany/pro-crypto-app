import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/crypto_model/all_crypto_model.dart';
import '../network/api_provider.dart';
import '../network/response_model.dart';

class MarketViewProvider extends ChangeNotifier {
  ApiProvider apiProvider = ApiProvider();
  late AllCryptoModel dataFuture;
  late ResponseModel state;
  late Response response;
  MarketViewProvider() {
    getCryptoData();
  }

  serachCoin(String searchValue) async {
    state = ResponseModel.loading("is loading...");
    notifyListeners();
    try {
      response = await apiProvider.getAllCryptoData();
      if (response.statusCode == 200) {
        dataFuture = AllCryptoModel.fromJson(jsonDecode(response.data));

        if (searchValue.isNotEmpty) {
          dataFuture.data!.cryptoCurrencyList =
              dataFuture.data!.cryptoCurrencyList!.where(
            (element) {
              return element.name!
                  .toLowerCase()
                  .contains(searchValue.toLowerCase());
            },
          ).toList();
        }

        state = ResponseModel.completed(dataFuture);
      } else {
        debugPrint(response.statusCode.toString());

        state = ResponseModel.error("please check your connection...");
      }
      notifyListeners();
    } catch (e) {
      state = ResponseModel.error("something went wrong");
      debugPrint(e.toString());
      notifyListeners();
    }
  }

  getCryptoData() async {
    // start loading api
    state = ResponseModel.loading("is loading...");
    notifyListeners();

    try {
      response = await apiProvider.getAllCryptoData();
      if (response.statusCode == 200) {
        dataFuture = AllCryptoModel.fromJson(jsonDecode(response.data));
        state = ResponseModel.completed(dataFuture);
      } else {
        debugPrint(response.statusCode.toString());

        state = ResponseModel.error("please check your connection...");
      }
      notifyListeners();
    } catch (e) {
      state = ResponseModel.error("something went wrong");
      debugPrint(e.toString());
      notifyListeners();
    }
  }
}
