part of 'references_cubit.dart';

abstract class ReferencesState extends Equatable {
  const ReferencesState();

  @override
  List<Object?> get props => [];
}

class ReferencesInitial extends ReferencesState {}

class ReferencesLoading extends ReferencesState {}

class ReferencesLoaded extends ReferencesState {
  final List<Reference> references;

  const ReferencesLoaded(this.references);

  @override
  List<Object?> get props => [references];
}

class ReferencesError extends ReferencesState {
  final String message;

  const ReferencesError(this.message);

  @override
  List<Object?> get props => [message];
}
