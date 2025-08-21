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
  late final AnimationController _animationController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  int _currentPage = 0;
  bool _isAutoScrolling = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _pageController.addListener(_onPageChanged);
    _fadeController.forward();
  }

  void _onPageChanged() {
    if (!_isAutoScrolling) {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
        HapticFeedback.selectionClick();
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
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
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        if (state is NewsLoadedState) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildNewsContent(context, state),
            ),
          );
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
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_animationController.value * 0.02),
              child: child,
            );
          },
          child: NewsListWidget(
            newsList: state.newsItems,
            isSmallScreen: isSmallScreen,
            pageController: _pageController,
            currentPage: _currentPage,
            onPageTap: _goToPage,
          ),
        ),
        const SizedBox(height: 16),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: child,
              ),
            );
          },
          child: SmoothPageIndicatorWidget(
            newsListlength: state.newsItems.length,
            pageController: _pageController,
            colorScheme: colorScheme,
          ),
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
        color: colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.error.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 32,
            color: colorScheme.error,
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
