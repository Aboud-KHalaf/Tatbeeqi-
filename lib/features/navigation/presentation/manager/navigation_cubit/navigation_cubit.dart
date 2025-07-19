import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitial());

  /// Changes the navigation index with validation
  void changeIndex(int index) {
    // Validate index range (0-3 for Home, Courses, Community, More)
    if (index < 0 || index > 3) {
      return;
    }
    
    // Only emit if the index actually changed to prevent unnecessary rebuilds
    if (state.index != index) {
      emit(NavigationIndexChanged(index));
    }
  }
  
  /// Get current navigation index
  int get currentIndex => state.index;
}
