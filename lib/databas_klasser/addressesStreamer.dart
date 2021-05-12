import 'package:flutter/cupertino.dart';
import 'package:historiskasthlm_app/databas_klasser/blocs/allAddresses_bloc.dart';
import 'package:historiskasthlm_app/databas_klasser/models/allAddresses.dart';
import 'package:historiskasthlm_app/databas_klasser/networking/Response.dart';
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
    StreamBuilder<Response<allAddresses>>(
      stream: _bloc.allAddressesListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          /* switch (snapshot.data.status) {
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
          }  */
        print('hej');
        }
        return Container();
      },
    );


  }
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}