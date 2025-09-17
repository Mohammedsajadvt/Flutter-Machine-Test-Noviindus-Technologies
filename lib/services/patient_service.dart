import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:novindus/core/constants/app_constants.dart';
import 'package:novindus/models/patient_model.dart';

class PatientService {
  Future<List<Patient>> getPatients(String token) async {
    final url = Uri.parse(AppConstants.baseUrl + AppConstants.patientListEndpoint);
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['patient'] as List?;
      if (list == null) return [];
      return list.map((e) => Patient.fromJson(e)).toList();
    } else {
      throw 'Failed to fetch patients';
    }
  }

  Future<void> registerPatient(Map<String, dynamic> data, String token) async {
    final url = Uri.parse(AppConstants.baseUrl + AppConstants.patientUpdateEndpoint);
    final response = await http.post(url, headers: {'Authorization': 'Bearer $token'}, body: data);
    if (response.statusCode != 200) {
      throw 'Failed to register patient';
    }
  }
}
