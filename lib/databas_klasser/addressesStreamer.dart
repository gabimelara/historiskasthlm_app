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
/*        if (snapshot.hasData) {
          *//* switch (snapshot.data.status) {
            case Status.LOADING:
              return Loading(loadingMessage: snapshot.data.message);
              break;
            case Status.COMPLETED:
              return CategoryList(categoryList: snapshot.data.data);
              break;
            case Status.ERROR:
              return Error(
                errorMessage: snapshot.data.message,
                onRetryPressed: () => _bloc.fetchCategories(),
              );
              break;
          }  *//*
*//*          while(snapshot.hasData){
            snapshot.data.
            Marker stockholmMarker = Marker(
                markerId: MarkerId('stockholm1'),
                icon: BitmapDescriptor.defaultMarkerWithHue(14),
                position: LatLng(59.31433730000001, 18.0735509),
                infoWindow: InfoWindow(title: 'Medborgarplatsen'),
                // onTap: () {
                //     Navigator.push(context,
                //       MaterialPageRoute(builder: (context) => HomePage()),
                //     );
                //   }
                // }
                onTap: () {
                  print('hej');
                }
                //för varje objekt läggs det i en lista som returneras till map_Screen
            );
          }*//*
        } else { print('ingen data');}*/
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