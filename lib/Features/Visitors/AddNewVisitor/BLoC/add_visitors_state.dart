import '../../../../Data/Models/visitor_model.dart';
import '../../../../Data/Models/resident_model.dart'; // تأكد من استيراد نموذج الساكن

class AddVisitorState {
  final int currentStep;
  final VisitorModel? lastCreatedVisitor;
  final bool isGenerating;

  final DateTime selectedDate;
  final bool isTimeSelected;

  final bool hasCar;
  final String? errorMessage;

  final int? selectedResidentId;
  final String? selectedResidentName;
  final int? selectedUnitId;
  final List<ResidentModel> residentsList;
  final bool isLoadingResidents;

  AddVisitorState({
    this.currentStep = 1,
    this.lastCreatedVisitor,
    this.isGenerating = false,
    DateTime? selectedDate,
    this.isTimeSelected = false,
    this.hasCar = false,
    this.errorMessage,
    this.selectedResidentId,
    this.selectedResidentName,
    this.selectedUnitId,
    this.residentsList = const [],
    this.isLoadingResidents = false,
  }) : selectedDate = selectedDate ?? DateTime.now();

  AddVisitorState copyWith({
    int? currentStep,
    VisitorModel? lastCreatedVisitor,
    bool? isGenerating,
    DateTime? selectedDate,
    bool? isTimeSelected,
    bool? hasCar,
    String? errorMessage,
    int? selectedResidentId,
    String? selectedResidentName,
    int? selectedUnitId,
    List<ResidentModel>? residentsList,
    bool? isLoadingResidents,
  }) {
    return AddVisitorState(
      currentStep: currentStep ?? this.currentStep,
      lastCreatedVisitor: lastCreatedVisitor ?? this.lastCreatedVisitor,
      isGenerating: isGenerating ?? this.isGenerating,
      selectedDate: selectedDate ?? this.selectedDate,
      isTimeSelected: isTimeSelected ?? this.isTimeSelected,
      hasCar: hasCar ?? this.hasCar,
      errorMessage: errorMessage,
      selectedResidentId: selectedResidentId ?? this.selectedResidentId,
      selectedResidentName: selectedResidentName ?? this.selectedResidentName,
      selectedUnitId: selectedUnitId ?? this.selectedUnitId,
      residentsList: residentsList ?? this.residentsList,
      isLoadingResidents: isLoadingResidents ?? this.isLoadingResidents,
    );
  }
}