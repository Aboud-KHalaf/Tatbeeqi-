import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  UserCubit(this._getCurrentUserUseCase) : super(UserInitial());

  Future<void> loadCurrentUser() async {
    try {
      emit(UserLoading());
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserError('No user found.'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
