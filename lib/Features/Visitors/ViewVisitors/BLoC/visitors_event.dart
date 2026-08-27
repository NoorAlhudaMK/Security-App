abstract class VisitorsEvent {}

class FetchVisitors extends VisitorsEvent {
  final int page;
  final Map<String, dynamic>? filters;
  final bool isPagination;

  FetchVisitors({this.page = 1, this.filters, this.isPagination = false});
}
class ToggleScannerEvent extends VisitorsEvent {}

class PickIdImageEvent extends VisitorsEvent {}

class QRDetectedEvent extends VisitorsEvent {
  final String code;
  QRDetectedEvent(this.code);
}

class AddVisitorEvent extends VisitorsEvent {
  final Map<String, dynamic> visitorData;
  AddVisitorEvent(this.visitorData);
}

class CheckoutVisitorEvent extends VisitorsEvent {
  final int visitId;
  final int gateId;
  CheckoutVisitorEvent(this.visitId, this.gateId);
}

class ConfirmVisitEvent extends VisitorsEvent {
  final String qrToken;
  final int gateId;
  ConfirmVisitEvent(this.qrToken, this.gateId);
}
