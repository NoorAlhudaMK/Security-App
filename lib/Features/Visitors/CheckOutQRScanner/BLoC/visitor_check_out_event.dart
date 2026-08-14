abstract class VisitorCheckOutEvent {}
class SubmitVisitorCheckOutEvent extends VisitorCheckOutEvent {
  final String token;
  final String qrToken;
  final int gateId;
  SubmitVisitorCheckOutEvent({required this.token, required this.qrToken, required this.gateId});
}