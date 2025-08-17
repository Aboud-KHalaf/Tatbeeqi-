import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/di/navigation_dependencies.dart';
import 'package:tatbeeqi/features/streaks/presentation/cubit/streaks_cubit.dart';
import 'package:tatbeeqi/features/streaks/presentation/widgets/streaks_view_body.dart';

class StreaksView extends StatelessWidget {
  const StreaksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StreaksCubit>(),
      child: const Scaffold(
        body: StreaksViewBody(),
      ),
    );
  }
}
