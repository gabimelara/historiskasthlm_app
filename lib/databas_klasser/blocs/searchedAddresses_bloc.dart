import 'dart:async';
import 'package:historiskasthlm_app/databas_klasser/networking/Response.dart';
import 'package:historiskasthlm_app/databas_klasser/models/searchAddress.dart';
import 'package:historiskasthlm_app/databas_klasser/repository/searchedAddresses_repository.dart';

class searchedAddresses_bloc {
  searchedAddresses_repository _searchedAddressRep;
  StreamController _searchedAddressController;

  StreamSink<Response<searchAddress>> get searchedAddressListSink =>
      _searchedAddressController.sink;

  Stream<Response<searchAddress>> get searchedAddressListStream =>
      _searchedAddressController.stream;

  searchedAddresses_bloc() {
    _searchedAddressController = StreamController<Response<searchAddress>>();
    _searchedAddressRep = searchedAddresses_repository();
    fetchAddress();
  }

  fetchAddress() async {
    searchedAddressListSink.add(Response.loading('Hämtar adresser'));
    try {
      searchAddress address =
      await _searchedAddressRep.fetchSearchedAddress();
      searchedAddressListSink.add(Response.completed(address));
    } catch (e) {
      searchedAddressListSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _searchedAddressController?.close();
  }
}