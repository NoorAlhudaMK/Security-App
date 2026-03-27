class AlertsState {
  final bool isEmergencyActive;
  final String callQuery;

  AlertsState({this.isEmergencyActive = false, this.callQuery = ''});

  AlertsState copyWith({bool? isEmergencyActive, String? callQuery}) {
    return AlertsState(
      isEmergencyActive: isEmergencyActive ?? this.isEmergencyActive,
      callQuery: callQuery ?? this.callQuery,
    );
  }
}