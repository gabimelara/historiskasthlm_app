import 'package:historiskasthlm_app/Databas_klasser/models/searchAddress.dart';
import 'package:historiskasthlm_app/Databas_klasser/networking/ApiProvider.dart';
import 'dart:async';

class addresses_repository extends ApiProvider {
  ApiProvider _provider = ApiProvider();
  String url;
  Future<searchAddress> fetchSearchedAddress() async {
    final response = await _provider.get(url);
    return searchAddress.fromJson(response);
  }
}