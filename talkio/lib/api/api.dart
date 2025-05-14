import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<int> addContact(
      String recipent_email, String recipent_name, String? from_email) async {
    if (from_email != null) {
      try {
        final response = await http.post(
          Uri.parse('https://talkio.sattva2025.site/addcontacts'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'recipent_email': recipent_email,
            'recipent_name': recipent_name,
            'from_email': from_email,
          }),
        );

        if (response.statusCode == 200) {
          return 200;
        } else {
          return 500;
        }
      } catch (e) {
        throw Exception('Error adding contact: $e');
      }
    } else {
      print("No user email found");
      return 400;
    }
  }

  Future<List<Map<String, dynamic>>> getContacts(String? email) async {
    try {
      final response = await http.post(
        Uri.parse('https://talkio.sattva2025.site/getcontacts'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(decoded);
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error getting contacts: $e');
    }
  }
}
