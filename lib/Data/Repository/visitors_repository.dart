import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../Core/AppConstants/app_constants.dart';
import '../Models/visitor_model.dart';

class VisitorsRepository {
  Future<List<VisitorModel>> getVisitors(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/user/get_visitor'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (kDebugMode) {
      print("Visitors response: ${response.body}");
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'].toString() == "true" && data['data'] != null) {
        final List<dynamic> visitorsList = data['data']['visitors'];
        return visitorsList.map((json) => VisitorModel.fromJson(json)).toList();
      } else {
        throw Exception(data['message'] ?? "فشل في جلب قائمة الزوار");
      }
    } else {
      throw Exception("فشل الاتصال بالسيرفر: ${response.statusCode}");
    }
  }

  Future<VisitorModel> addVisitor(String token, Map<String, dynamic> data) async {
    final url = Uri.parse('${AppConstants.baseUrl}/api/user/add_new_visitor');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );

    if (kDebugMode) {
      print("Add Visitor Status Code: ${response.statusCode}");
      print("Add Visitor Response Body: ${response.body}");
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      try {
        final errorData = jsonDecode(response.body);
        final message = errorData['message'] ?? "فشل في إضافة الزائر";
        throw Exception(message);

      } catch (_) {
        throw Exception("فشل في إضافة الزائر (رمز الخطأ: ${response.statusCode})");
      }
    }

    return VisitorModel.fromJson(jsonDecode(response.body)['data']['visitor']);
  }

  Future<void> checkoutVisitor(String token, int visitId, int gateId) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}/api/v1/security/visitor/checkout',
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"visit_id": visitId, "gate_id": gateId}),
    );

    if (response.statusCode != 200) {
      throw Exception("فشل في تسجيل خروج الزائر");
    }
  }

  Future<void> confirmVisit(String token, String qrToken, int gateId) async {
    final url = Uri.parse('${AppConstants.baseUrl}/api/user/confirm_visit');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"qr_token": qrToken, "gate_id": gateId}),
    );

    if (response.statusCode != 200) {
      throw Exception("فشل في تأكيد الزيارة: ${response.statusCode}");
    }
  }

  Future<VisitorModel> checkInVisitor(String token, String qrToken, int gateId) async {
    final url = Uri.parse('${AppConstants.baseUrl}/api/v1/security/visitor/checkin');

    if (kDebugMode) {
      print("Check-in param.s: $token , $qrToken , $gateId");
    }

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "qr_token": qrToken,
        "gate_id": gateId,
      }),
    );

    if (kDebugMode) {
      print("Check-in response: ${response.body}");
    }

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final visitorJson = data['data']['visitor'];
      return VisitorModel.fromJson(visitorJson);
    } else {
      throw Exception(data['message'] ?? "فشل في تسجيل دخول الزائر");
    }
  }

  Future<VisitorModel> checkOutVisitor(String token, String qrToken, int gateId) async {
    final url = Uri.parse('${AppConstants.baseUrl}/api/v1/security/visitor/checkout');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "qr_token": qrToken,
        "gate_id": gateId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return VisitorModel.fromJson(data['data']['visitor']);
    } else {
      throw Exception(data['message'] ?? "فشل في تسجيل خروج الزائر");
    }
  }
}