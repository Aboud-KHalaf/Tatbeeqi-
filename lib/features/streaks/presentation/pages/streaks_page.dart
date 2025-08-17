import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/streaks_cubit.dart';
import '../views/streaks_view.dart';

class StreaksPage extends StatelessWidget {
  const StreaksPage({super.key});

  static const String routePath = '/streaks';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StreaksCubit>(),
      child: const StreaksView(),
    );
  }
}
