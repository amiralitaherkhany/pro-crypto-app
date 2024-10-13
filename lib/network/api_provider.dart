import 'package:dio/dio.dart';

class ApiProvider {
  dynamic getAllCryptoData() async {
    Response response;
    final dio = Dio();
    response = await dio.get(
      "https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing?start=1&limit=1000&sortBy=market_cap&sortType=desc&convert=USD&cryptoType=all&tagType=all&audited=false&aux=ath,atl,high24h,low24h,num_market_pairs,cmc_rank,date_added,max_supply,circulating_supply,total_supply,volume_7d,volume_30d,self_reported_circulating_supply,self_reported_market_cap",
    );
    return response;
  }

  dynamic getTopMarketCapData() async {
    Response response;
    final dio = Dio();
    response = await dio.get(
        "https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing?start=1&limit=10&sortBy=market_cap&sortType=desc&convert=USD&cryptoType=all&tagType=all&audited=false&aux=ath,atl,high24h,low24h,num_market_pairs,cmc_rank,date_added,max_supply,circulating_supply,total_supply,volume_7d,volume_30d,self_reported_circulating_supply,self_reported_market_cap");
    return response;
  }

  dynamic getTopGainerData() async {
    Response response;
    final dio = Dio();
    response = await dio.get(
        "https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing?start=1&limit=10&sortBy=percent_change_24h&sortType=desc&convert=USD&cryptoType=all&tagType=all&audited=false&aux=ath,atl,high24h,low24h,num_market_pairs,cmc_rank,date_added,max_supply,circulating_supply,total_supply,volume_7d,volume_30d,self_reported_circulating_supply,self_reported_market_cap");
    return response;
  }

  dynamic getTopLosersData() async {
    Response response;
    final dio = Dio();
    response = await dio.get(
        "https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing?start=1&limit=10&sortBy=percent_change_24h&sortType=asc&convert=USD&cryptoType=all&tagType=all&audited=false&aux=ath,atl,high24h,low24h,num_market_pairs,cmc_rank,date_added,max_supply,circulating_supply,total_supply,volume_7d,volume_30d,self_reported_circulating_supply,self_reported_market_cap");
    return response;
  }

  dynamic callRegisterApi(String name, String email, String password) async {
    Response response;
    final dio = Dio();
    var formData = FormData.fromMap(
      {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": password,
      },
    );
    response = await dio.post(
      'https://besenior.ir/api/register',
      data: formData,
    );
    return response;
  }
}
