abstract class AlertsEvent {}

class EmergencyTriggered extends AlertsEvent {}

class CallApartmentChanged extends AlertsEvent { final String apartmentNo; CallApartmentChanged(this.apartmentNo); }