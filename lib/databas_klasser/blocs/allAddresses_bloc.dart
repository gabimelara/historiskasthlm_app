import 'dart:async';
import 'package:historiskasthlm_app/databas_klasser/models/allAddresses.dart';
import 'package:historiskasthlm_app/databas_klasser/networking/Response.dart';
import 'package:historiskasthlm_app/databas_klasser/repository/allAddresses_repository.dart';

class allAddresses_bloc {
  allAddresses_repository _allAddressesRepository;
  StreamController _allAddressesController;

  StreamSink<Response<allAddresses>> get allAddressesListSink =>
      _allAddressesController.sink;

  Stream<Response<allAddresses>> get allAddressesListStream =>
      _allAddressesController.stream;

  allAddresses_bloc() {
    _allAddressesController = StreamController<Response<allAddresses>>();
    _allAddressesRepository = allAddresses_repository();
    fetchAllAddresses();
  }

  fetchAllAddresses() async {
    allAddressesListSink.add(Response.loading('Hämtar alla adresser.'));
    try {
      allAddresses allAdds =
      await _allAddressesRepository.fetchAllAddresses();
      allAddressesListSink.add(Response.completed(allAdds));
    } catch (e) {
      allAddressesListSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _allAddressesController?.close();
  }
}