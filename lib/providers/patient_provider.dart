import 'package:flutter/material.dart';
import 'package:novindus/services/patient_service.dart';
import 'package:novindus/models/patient_model.dart';

class PatientProvider extends ChangeNotifier {
  List<Patient> _patients = [];
  bool _isLoading = false;
  String? _error;

  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPatients(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _patients = await PatientService().getPatients(token);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> registerPatient(Map<String, dynamic> data, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await PatientService().registerPatient(data, token);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
