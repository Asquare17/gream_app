import 'package:greamit_app/Model/WebMetaData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

Map<String, String> requestHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

Future<WebMetaData> getWebsiteMetadata({String websiteString}) async {

  final String baseUrl = 'https://url-metadata.herokuapp.com/api/metadata?url=';

  var endpointAction = await http.get(baseUrl + websiteString, headers: requestHeaders);
  final json = JSON.jsonDecode(endpointAction.body);

  if (json["data"] != null) {

    WebMetaData webMetaData =  WebMetaData.fromJson(json);
    return webMetaData;

  } else {

    var error = json["error"];
    throw Exception(error);

  }

}