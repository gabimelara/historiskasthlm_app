import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider  { //kommunicerar mellan app och API
  final String _baseUrl = "https://group10-15.pvt.dsv.su.se/demo/"; //länk till vår databas
  final String _getByAddress = "files/getByAddress/"; //länkändelse för ovanstående länk, för att söka efter adresser. Slås alltså ihop med ovanstående för en komplett länk.


  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + _getByAddress + url)); //"url" byts ut mot adressen användaren söker efter. Blir alltså https://group10-15.pvt.dsv.su.se/demo/files/getByAddress/Karlaplan+10 om användaren skulle söka på Karlaplan 10
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('Ingen internetkoppling');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  } //Olika felmeddelanden
}
//klasserna nedan är egna felmeddelanden
class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}