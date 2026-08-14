import 'dart:io';
import 'package:equatable/equatable.dart';

import '../../../../Data/Models/visitor_model.dart';


abstract class VisitorsState extends Equatable {
  final bool isScanning;
  final File? visitorIdImage;
  final String? lastScannedCode;

  const VisitorsState({
    this.isScanning = false,
    this.visitorIdImage,
    this.lastScannedCode,
  });

  // أضفنا هذه الدالة لتكون متاحة لأي state
  VisitorsState copyWith({
    bool? isScanning,
    File? visitorIdImage,
    String? lastScannedCode,
  });

  @override
  List<Object?> get props => [isScanning, visitorIdImage, lastScannedCode];
}

class VisitorsInitial extends VisitorsState {
  const VisitorsInitial() : super();

  @override
  VisitorsInitial copyWith({
    bool? isScanning,
    File? visitorIdImage,
    String? lastScannedCode,
  }) => this;
}

class VisitorsLoading extends VisitorsState {
  const VisitorsLoading() : super();

  @override
  VisitorsLoading copyWith({
    bool? isScanning,
    File? visitorIdImage,
    String? lastScannedCode,
  }) => this;
}

class VisitorsLoaded extends VisitorsState {
  final List<VisitorModel> visitors;

  const VisitorsLoaded(
    this.visitors, {
    super.isScanning,
    super.visitorIdImage,
    super.lastScannedCode,
  });

  @override
  List<Object?> get props => [visitors, ...super.props];

  @override
  VisitorsLoaded copyWith({
    List<VisitorModel>? visitors,
    bool? isScanning,
    File? visitorIdImage,
    String? lastScannedCode,
  }) {
    return VisitorsLoaded(
      visitors ?? this.visitors,
      isScanning: isScanning ?? this.isScanning,
      visitorIdImage: visitorIdImage ?? this.visitorIdImage,
      lastScannedCode: lastScannedCode ?? this.lastScannedCode,
    );
  }
}

class VisitorsError extends VisitorsState {
  final String message;
  const VisitorsError(this.message) : super();

  @override
  List<Object?> get props => [message, ...super.props];

  @override
  VisitorsError copyWith({
    bool? isScanning,
    File? visitorIdImage,
    String? lastScannedCode,
  }) => this;
}
