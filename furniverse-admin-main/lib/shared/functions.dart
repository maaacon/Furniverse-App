import 'dart:async';
import 'package:http/http.dart' as http;

Future<bool> doesImageExist(String imageUrl) async {
  try {
    final response = await http.head(Uri.parse(imageUrl));
    return response.statusCode >= 200 && response.statusCode < 300;
  } catch (e) {
    // An error occurred, such as a network error or invalid URL.
    return false;
  }
}
