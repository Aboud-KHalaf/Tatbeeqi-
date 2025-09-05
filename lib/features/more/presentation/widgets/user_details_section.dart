import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/auth/domain/entities/user.dart';
import 'package:tatbeeqi/features/auth/presentation/manager/user_cubit/user_cubit.dart';
import 'package:tatbeeqi/features/auth/presentation/manager/user_cubit/user_state.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class UserDetailsSection extends StatelessWidget {
  const UserDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (state is UserLoading)
                  const CircularProgressIndicator()
                else if (state is UserError)
                  Column(
                    children: [
                      Icon(Icons.error_outline, color: colorScheme.error, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        l10n.userDataLoadError,
                        style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                      ),
                    ],
                  )
                else if (state is UserLoaded)
                  UserInfoDisplay(user: state.user)
                else
                  Column(
                    children: [
                      Icon(Icons.person_outline, color: colorScheme.outline, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        l10n.userDataNotLoaded,
                        style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class UserInfoDisplay extends StatelessWidget {
  final User user;

  const UserInfoDisplay({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: colorScheme.primary,
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user.email,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InfoChip(
              icon: Icons.school_outlined,
              label: _getYearName(context, user.studyYear),
              colorScheme: colorScheme,
            ),
            InfoChip(
              icon: Icons.business_outlined,
              label: _getDepartmentName(context, user.department),
              colorScheme: colorScheme,
            ),
          ],
        ),
      ],
    );
  }

  String _getDepartmentName(BuildContext context, int department) {
    final locale = Localizations.localeOf(context);
    const Map<int, String> departmentsAr = {
      1: 'التكييف والتبريد',
      2: 'تقنيات الحاسب',
    };
    const Map<int, String> departmentsEn = {
    1: 'Air Conditioning and Refrigeration',
    2: 'Computer Engineering',
  };
  if (locale.languageCode == 'ar') {
    return departmentsAr[department] ?? 'القسم $department';
  } else {
    return departmentsEn[department] ?? 'Department $department';
  }
  }

  String _getYearName(BuildContext context, int year) {
    final locale = Localizations.localeOf(context);
    const Map<int, String> studyYearsAr = {
      1: 'السنة الأولى',
      2: 'السنة الثانية',
      3: 'السنة الثالثة',
      4: 'السنة الرابعة',
    };
    const Map<int, String> studyYearsEn = {
      1: 'First Year',
      2: 'Second Year',
      3: 'Third Year',
      4: 'Fourth Year',
    };  
    if (locale.languageCode == 'ar') {
      return studyYearsAr[year] ?? 'السنة $year';
    } else {
      return studyYearsEn[year] ?? 'Year $year';
    }
    }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const InfoChip({super.key, required this.icon, required this.label, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onPrimaryContainer),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
