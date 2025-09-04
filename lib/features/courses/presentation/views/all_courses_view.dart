import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/fetch_courses_cubit/fetch_courses_cubit.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/fetch_courses_cubit/fetch_courses_state.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/courses_grid_widget.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/courses_shimmer_grid.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/courses_tab_bar_shimmer.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/empty_courses_widget.dart';

class AllCoursesView extends StatefulWidget {
  const AllCoursesView({super.key});

  @override
  State<AllCoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends State<AllCoursesView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging &&
        mounted &&
        _tabController.index != _selectedTabIndex) {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text("المقررات الدراسية")),
      body: BlocBuilder<FetchCoursesCubit, FetchCoursesState>(
        builder: (context, state) {
          if (state is CoursesError) {
            return const Center(child: Text('Error loading courses'));
          } else if (state is CoursesLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildCoursesContent(state.courseEntities, isTablet),
            );
          } else {
            return _buildLoadingContent(isTablet);
          }
        },
      ),
    );
  }

  Widget _buildCoursesContent(List<Course> courses, bool isTablet) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        if (courses.isEmpty)
          SliverFillRemaining(
            child: EmptyCoursesWidget(
              key: ValueKey('empty_$_selectedTabIndex'),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            sliver: CoursesGridWidget(
              courses: courses,
              isTablet: isTablet,
              selectedTabIndex: _selectedTabIndex,
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingContent(bool isTablet) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          sliver: CoursesShimmerGridWidget(
            isTablet: isTablet,
            selectedTabIndex: _selectedTabIndex,
          ),
        ),
      ],
    );
  }
}
