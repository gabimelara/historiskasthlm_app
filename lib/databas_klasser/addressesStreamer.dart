import 'package:flutter/cupertino.dart';
import 'package:historiskasthlm_app/databas_klasser/blocs/allAddresses_bloc.dart';
import 'package:historiskasthlm_app/databas_klasser/models/allAddresses.dart';
import 'package:historiskasthlm_app/databas_klasser/networking/Response.dart';
import 'package:flutter/material.dart';


class addressesStreamer extends StatefulWidget {
  @override
  _addressesStreamerState createState() => _addressesStreamerState();


}

class _addressesStreamerState extends State<addressesStreamer> {
  allAddresses_bloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = allAddresses_bloc();

  }

  Widget build(BuildContext context) {
    Container(child: StreamBuilder<Response<allAddresses>>(
      stream: _bloc.allAddressesListStream,
      builder: (context, snapshot) {
        print (snapshot);

      }, ),
    );
    return Container();





  }
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}