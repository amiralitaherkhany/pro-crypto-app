import 'package:crypto_app/models/crypto_model/all_crypto_model.dart';
import 'package:crypto_app/network/api_provider.dart';
import 'package:crypto_app/network/response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CryptoDataProvider extends ChangeNotifier {
  late Response response;
  ApiProvider apiProvider = ApiProvider();
  late AllCryptoModel dataFuture;
  late ResponseModel state;
  getTopMarketCapData() async {
    state = ResponseModel.loading('is loading');
    try {
      response = await apiProvider.getTopMarketCapData();
      if (response.statusCode == 200) {
        dataFuture = AllCryptoModel.fromJson(response.data);
        state = ResponseModel.completed(dataFuture);
      } else {
        state = ResponseModel.error('please check your connection');
      }
      notifyListeners();
    } catch (e) {
      state = ResponseModel.error('something went wrong');
      print(e.toString());
      notifyListeners();
    }
  }
}
