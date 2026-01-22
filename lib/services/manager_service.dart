import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';

class ManagerService {
  Future<Map<String, dynamic>> addCar({
    required Map<String, String> fields,
    required List<File> images,
  }) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/manager_add_car.php");

    final req = http.MultipartRequest("POST", uri);

    // fields
    req.fields.addAll(fields);

    // images
    for (final f in images) {
      req.files.add(await http.MultipartFile.fromPath("images[]", f.path));
    }

    final streamed = await req.send();
    final body = await streamed.stream.bytesToString();

    if (streamed.statusCode != 200) {
      throw Exception("HTTP ${streamed.statusCode}: $body");
    }

    final data = jsonDecode(body);
    if (data["ok"] != true) {
      throw Exception(data["message"] ?? "Failed");
    }
    return Map<String, dynamic>.from(data);
  }

  // (خلي fetchStats زي ما عندك)
  Future<Map<String, dynamic>> fetchStats() async {
    // ...
    throw UnimplementedError();
  }
}
