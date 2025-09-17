import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:novindus/core/constants/app_constants.dart';
import 'package:novindus/models/treatment_model.dart';

class TreatmentService {
  Future<List<Treatment>> getTreatments(String token) async {
    final url = Uri.parse(AppConstants.baseUrl + AppConstants.treatmentListEndpoint);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if the response has the expected structure
      if (data['status'] == true && data['treatments'] != null) {
        final treatments = data['treatments'] as List;
        return treatments.map((treatment) => Treatment.fromJson(treatment)).toList();
      } else {
        throw 'Invalid response format: ${data['message'] ?? 'Unknown error'}';
      }
    } else {
      throw 'Failed to fetch treatments: ${response.statusCode} - ${response.body}';
    }
  }
}
