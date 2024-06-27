import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, String>> getCityAndState(
    double latitude, double longitude) async {
  final String url =
      'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    // print(data);
    final String city = data['city'] ?? '';
    final String state = data['principalSubdivision'] ?? '';
    return {
      'city': city,
      'state': state,
    };
  } else {
    throw Exception('Failed to fetch data from API');
  }
}
