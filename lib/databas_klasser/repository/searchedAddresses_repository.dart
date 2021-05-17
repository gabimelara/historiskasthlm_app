import 'package:historiskasthlm_app/databas_klasser/models/searchAddress.dart';
import 'package:historiskasthlm_app/databas_klasser/networking/ApiProvider.dart';
import 'dart:async';

class searchedAddresses_repository extends ApiProvider {
  ApiProvider _provider = ApiProvider();
  String url;
  Future<searchAddress> fetchSearchedAddress() async {
    final response = await _provider.getSearchedAddress(url);
    return searchAddress.fromJson(response);
  }
}