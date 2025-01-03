import 'dart:convert';

import 'package:crypto_app/models/crypto_model/all_crypto_model.dart';
import 'package:crypto_app/network/api_provider.dart';
import 'package:crypto_app/network/response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CryptoDataProvider extends ChangeNotifier {
  CryptoDataProvider() {
    getTopMarketCapData();
  }
  late Response response;
  ApiProvider apiProvider = ApiProvider();
  late AllCryptoModel dataFuture;
  late ResponseModel state;
  var defaultChoiceIndex = 0;
  //
  getTopMarketCapData() async {
    defaultChoiceIndex = 0;
    state = ResponseModel.loading('is loading');
    notifyListeners();

    try {
      response = await apiProvider.getTopMarketCapData();
      if (response.statusCode == 200) {
        dataFuture = AllCryptoModel.fromJson(jsonDecode(response.data));
        state = ResponseModel.completed(dataFuture);
      } else {
        debugPrint(response.statusCode.toString());
        state = ResponseModel.error('please check your connection');
      }
      notifyListeners();
    } catch (e) {
      state = ResponseModel.error('something went wrong');
      debugPrint(e.toString());
      notifyListeners();
    }
  }

  getTopGainersData() async {
    defaultChoiceIndex = 1;
    state = ResponseModel.loading('is loading');
    notifyListeners();

    try {
      response = await apiProvider.getTopGainerData();
      if (response.statusCode == 200) {
        dataFuture = AllCryptoModel.fromJson(jsonDecode(response.data));
        state = ResponseModel.completed(dataFuture);
      } else {
        debugPrint(response.statusCode.toString());

        state = ResponseModel.error('please check your connection');
      }
      notifyListeners();
    } catch (e) {
      state = ResponseModel.error('something went wrong');
      debugPrint(e.toString());
      notifyListeners();
    }
  }

  getTopLosersData() async {
    defaultChoiceIndex = 2;
    state = ResponseModel.loading('is loading');
    notifyListeners();

    try {
      response = await apiProvider.getTopLosersData();
      if (response.statusCode == 200) {
        dataFuture = AllCryptoModel.fromJson(jsonDecode(response.data));
        state = ResponseModel.completed(dataFuture);
      } else {
        debugPrint(response.statusCode.toString());

        state = ResponseModel.error('please check your connection');
      }
      notifyListeners();
    } catch (e) {
      state = ResponseModel.error('something went wrong');
      debugPrint(e.toString());
      notifyListeners();
    }
  }
}
