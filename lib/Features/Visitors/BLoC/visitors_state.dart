import 'dart:io';

class VisitorsState {
  final bool isScanning;
  final File? visitorIdImage;
  final String? lastScannedCode;

  VisitorsState({
    this.isScanning = false,
    this.visitorIdImage,
    this.lastScannedCode,
  });

  VisitorsState copyWith({
    bool? isScanning,
    File? visitorIdImage,
    String? lastScannedCode,
  }) {
    return VisitorsState(
      isScanning: isScanning ?? this.isScanning,
      visitorIdImage: visitorIdImage ?? this.visitorIdImage,
      lastScannedCode: lastScannedCode ?? this.lastScannedCode,
    );
  }
}