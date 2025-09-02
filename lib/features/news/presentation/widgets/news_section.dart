import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import 'package:tatbeeqi/features/news/presentation/manager/news_cubit.dart';
import 'package:tatbeeqi/features/news/presentation/widgets/news_card_shimmer_loader.dart';
import 'package:tatbeeqi/features/news/presentation/widgets/news_list_widget.dart';
import 'package:tatbeeqi/features/news/presentation/widgets/smooth_page_indicator_widget.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({super.key});

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _isAutoScrolling = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
     
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    if (!_isAutoScrolling) {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
        HapticFeedback.selectionClick();
      }
    }
  }
  
  void _goToPage(int page) {
    _isAutoScrolling = true;
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ).then((_) {
      _isAutoScrolling = false;
    });
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_onPageChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        if (state is NewsLoadedState) {
          return _buildNewsContent(context, state);
        } else if (state is NewsErrorState) {
          AppLogger.error(state.message);
          return _buildErrorState(context);
        } else {
          return NewsCardShimmerLoader(isSmallScreen: isSmallScreen);
        }
      },
    );
  }

  Widget _buildNewsContent(BuildContext context, NewsLoadedState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Column(
      children: [
        NewsListWidget(
          newsList: state.newsItems,
          isSmallScreen: isSmallScreen,
          pageController: _pageController,
          currentPage: _currentPage,
          onPageTap: _goToPage,
        ),
        const SizedBox(height: 16),
        SmoothPageIndicatorWidget(
          newsListlength: state.newsItems.length,
          pageController: _pageController,
          colorScheme: colorScheme,
        ),
      ],
    );
  }
  
  Widget _buildErrorState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 32,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(height: 8),
          Text(
            'فشل في تحميل الأخبار',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onErrorContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'تحقق من اتصالك بالإنترنت',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onErrorContainer.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
