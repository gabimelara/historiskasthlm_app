import 'package:historiskasthlm_app/databas_klasser/networking/ApiProvider.dart';
import 'dart:async';

import 'package:historiskasthlm_app/databas_klasser/models/allAddresses.dart';

class allAddresses_repository extends ApiProvider {
  ApiProvider _provider = ApiProvider();
  Future<allAddresses> fetchAllAddresses() async {
    final response = await _provider.getAllAddresses();
    return allAddresses.fromJson(response);
  }


}