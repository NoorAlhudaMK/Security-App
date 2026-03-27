abstract class VisitorsEvent {}

class ToggleScannerEvent extends VisitorsEvent {}

class PickIdImageEvent extends VisitorsEvent {}

class QRDetectedEvent extends VisitorsEvent {
  final String code;
  QRDetectedEvent(this.code);
}