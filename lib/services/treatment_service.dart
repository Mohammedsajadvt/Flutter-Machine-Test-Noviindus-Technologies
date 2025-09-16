import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:novindus/core/constants/app_constants.dart';
import 'package:novindus/models/treatment_model.dart';

class TreatmentService {
  Future<List<Treatment>> getTreatments(String token) async {
    final url = Uri.parse(AppConstants.baseUrl + AppConstants.treatmentListEndpoint);
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['treatments'] as List?;
      if (list == null) return [];
      return list.map((e) => Treatment.fromJson(e)).toList();
    } else {
      throw 'Failed to fetch treatments';
    }
  }
}
