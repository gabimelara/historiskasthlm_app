import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

//AIzaSyB5CATDvNh2pQVoAshkcfsj2DPRIxY9TAw

const apiKey = "AIzaSyB5CATDvNh2pQVoAshkcfsj2DPRIxY9TAw";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);

class Autocomplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}

class AutocompleteField extends StatefulWidget {
  @override
  AutocompleteFieldState createState() => new AutocompleteFieldState();
}

class AutocompleteFieldState extends State<AutocompleteField> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                // show input autocomplete with selected mode
                // then get the Prediction selected
                Prediction p = await PlacesAutocomplete.show(
                    context: context, apiKey: apiKey);
                displayPrediction(p);
              },
              child: Text('Find address'),

            )
        )
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      //double lat = detail.result.geometry.location.lat;
      //double lng = detail.result.geometry.location.lng;

     // var address = await Geocoder.local.findAddressesFromQuery(p.description);
      //print(lat);
      //print(lng);
    }
  }
}