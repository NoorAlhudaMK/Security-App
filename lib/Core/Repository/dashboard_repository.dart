class DashboardRepository {
  Future<Map<String, dynamic>> getDashboardStats() async {

    await Future.delayed(const Duration(seconds: 2));

    return {
      "visitors": 14,
      "apartments": 128,
      "alerts": 2,
    };
  }
}