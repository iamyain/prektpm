import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '062823563668df902af9e833016d7423';

class ApiService {
  static const String baseUrl = 'https://api.rajaongkir.com/starter';

  static Future<List<dynamic>> getAllCity() async {
    print('call get all city');
    try {
      const url = '$baseUrl/city?key=$apiKey';
      print(url);
      final response = await http.get(Uri.parse('$baseUrl/city?key=$apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['rajaongkir']['status']['code'] == 200) {
          print(data['rajaongkir']);
          return data['rajaongkir']['results'];
        } else {
          throw Exception(
              'API request failed: ${data['rajaongkir']['status']['description']}');
        }
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
    return [];
  }

  static Future<List<dynamic>> getCost(
      String origin, String destination, int weight, String courier) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cost'),
        headers: {
          'key': apiKey, // Replace with your RajaOngkir API key
        },
        body: {
          'origin': origin,
          'destination': destination,
          'weight': weight.toString(),
          'courier': courier,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['rajaongkir']['status']['code'] == 200) {
          return data['rajaongkir']['results'][0]['costs'];
        } else {
          throw Exception(
              'API request failed: ${data['rajaongkir']['status']['description']}');
        }
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }

    return [];
  }
}
