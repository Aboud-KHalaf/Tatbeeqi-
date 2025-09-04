import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/references/domain/entities/reference.dart';
import 'package:tatbeeqi/features/references/domain/use_cases/fetch_references_use_case.dart';

part 'references_state.dart';

class ReferencesCubit extends Cubit<ReferencesState> {
  final FetchReferencesUseCase _fetchReferencesUseCase;

  ReferencesCubit({required FetchReferencesUseCase fetchReferencesUseCase})
      : _fetchReferencesUseCase = fetchReferencesUseCase,
        super(ReferencesInitial());

  Future<void> fetchReferences(String courseId) async {
    emit(ReferencesLoading());
    final result = await _fetchReferencesUseCase(courseId);
    result.fold(
      (failure) => emit(ReferencesError(failure.message)),
      (list) => emit(ReferencesLoaded(list)),
    );
  }
}
