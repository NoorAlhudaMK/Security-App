import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../Core/AppConstants/app_constants.dart';
import '../../Core/CacheManager/cache_manager.dart';
import '../Models/shift_model.dart';

class ShiftRepository {
  Future<List<ShiftModel>> getShifts() async {
    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/security/shift');

    final token = await CacheManager.getToken();

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.get(uri, headers: headers);

    if (kDebugMode) {
      print("Shift API Response: ${response.body}");
    }

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      List<dynamic> shiftsList = [];
      if (decodedData is Map<String, dynamic>) {
        if (decodedData['data'] is Map && decodedData['data']['shifts'] != null) {
          shiftsList = decodedData['data']['shifts'];
        } else if (decodedData['shifts'] != null) {
          shiftsList = decodedData['shifts'];
        }
      }

      return shiftsList
          .map<ShiftModel>((item) => ShiftModel.fromJson(item))
          .toList();
    } else {
      throw Exception("فشل في جلب بيانات الشفتات: ${response.statusCode}");
    }
  }
}