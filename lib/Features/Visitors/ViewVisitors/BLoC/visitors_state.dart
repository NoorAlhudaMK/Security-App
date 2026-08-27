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
  final bool hasMore;
  final int currentPage;

  const VisitorsLoaded(
      this.visitors, {
        this.hasMore = true,
        this.currentPage = 1,
        super.isScanning,
        super.visitorIdImage,
        super.lastScannedCode,
      });

  @override
  List<Object?> get props => [visitors, hasMore, currentPage, ...super.props];

  @override
  VisitorsLoaded copyWith({
    List<VisitorModel>? visitors,
    bool? hasMore,
    int? currentPage,
    bool? isScanning,
    File? visitorIdImage,
    String? lastScannedCode,
  }) {
    return VisitorsLoaded(
      visitors ?? this.visitors,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
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
