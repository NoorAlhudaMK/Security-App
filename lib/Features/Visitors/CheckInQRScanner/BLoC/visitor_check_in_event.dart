abstract class VisitorCheckInEvent {}

class SubmitVisitorCheckInEvent extends VisitorCheckInEvent {
  final String token;
  final String qrToken;
  final int gateId;

  SubmitVisitorCheckInEvent({
    required this.token,
    required this.qrToken,
    required this.gateId,
  });
}