import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:novindus/core/constants/app_constants.dart';
import 'package:novindus/models/branch_model.dart';

class BranchService {
  Future<List<Branch>> getBranches(String token) async {
    final url = Uri.parse(AppConstants.baseUrl + AppConstants.branchListEndpoint);
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['branches'] as List?;
      if (list == null) return [];
      return list.map((e) => Branch.fromJson(e)).toList();
    } else {
      throw 'Failed to fetch branches';
    }
  }
}
