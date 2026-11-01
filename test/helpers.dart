import 'dart:convert';
import 'package:axscend_tech_test/networking/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> userJson(int id) => {
  'id': id,
  'name': 'User $id',
  'username': 'user$id',
  'email': 'user$id@example.com',
  'address': {
    'street': 'Main St',
    'suite': 'Apt 1',
    'city': 'Bolton',
    'zipcode': 'BL1 1AA',
    'geo': {'lat': '53.5', 'lng': '-2.4'},
  },
  'phone': '01234 567890',
  'website': 'example.com',
  'company': {'name': 'Acme', 'catchPhrase': 'Catchy', 'bs': 'stuff'},
};

ApiClient fakeApi(Future<http.Response> Function(http.Request) handler) =>
    ApiClient(httpClient: MockClient(handler));

http.Response jsonResponse(Object body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json'},
);
