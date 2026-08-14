import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../Core/AppConstants/app_constants.dart';
import '../Models/resident_model.dart';

class AdvancedSearchRepository {
  Future<List<ResidentModel>> searchResidents({
    required String token,
    int? buildingId,
    int? unitId,
    String? search,
    int? page,
    int? perPage,
  }) async {
    if (page != null && perPage == null) {
      throw ArgumentError("يجب تحديد قيمة perPage في حال تم تمرير page");
    }

    final queryParameters = {
      if (buildingId != null) 'building_id': buildingId.toString(),
      if (unitId != null) 'unit_id': unitId.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'per_page': perPage.toString(),
    };

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/residents')
        .replace(queryParameters: queryParameters);

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.get(uri, headers: headers);

    if (kDebugMode) {
      print("Advanced Search Response: ${response.body}");
    }

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      List<dynamic> residentsList = [];
      if (decodedData is Map<String, dynamic>) {
        if (decodedData['data'] is Map && decodedData['data']['residents'] != null) {
          residentsList = decodedData['data']['residents'];
        } else if (decodedData['residents'] != null) {
          residentsList = decodedData['residents'];
        }
      }

      return residentsList
          .map<ResidentModel>((item) => ResidentModel.fromJson(item))
          .toList();

    } else {
      throw Exception("فشل في جلب نتائج البحث: ${response.statusCode}");
    }
  }
}