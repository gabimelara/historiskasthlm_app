import 'dart:async';

import 'package:historiskasthlm_app/Databas_klasser/models/searchAddress.dart';
import 'package:historiskasthlm_app/Databas_klasser/networking/Response.dart';
import 'package:historiskasthlm_app/Databas_klasser/repository/addresses_repository.dart';

class Addresses_bloc {
  addresses_repository _addressRep;
  StreamController _addressController;

  StreamSink<Response<searchAddress>> get addressListSink =>
      _addressController.sink;

  Stream<Response<searchAddress>> get addressListStream =>
      _addressController.stream;

  Addresses_bloc() {
    _addressController = StreamController<Response<searchAddress>>();
    _addressRep = addresses_repository();
    fetchAddress();
  }

  fetchAddress() async {
    addressListSink.add(Response.loading('Hämtar adresser'));
    try {
      searchAddress address =
      await _addressRep.fetchSearchedAddress();
      addressListSink.add(Response.completed(address));
    } catch (e) {
      addressListSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _addressController?.close();
  }
}