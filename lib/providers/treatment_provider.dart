import 'package:flutter/material.dart';
import 'package:novindus/services/treatment_service.dart';
import 'package:novindus/models/treatment_model.dart';

class TreatmentProvider extends ChangeNotifier {
  List<Treatment> _treatments = [];
  bool _isLoading = false;
  String? _error;

  List<Treatment> get treatments => _treatments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTreatments(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _treatments = await TreatmentService().getTreatments(token);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
