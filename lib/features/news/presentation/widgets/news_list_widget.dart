import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/features/news/domain/entities/news_item_entity.dart';
import 'package:tatbeeqi/features/news/presentation/widgets/news_list_item.dart';

class NewsListWidget extends StatefulWidget {
  const NewsListWidget({
    super.key,
    required this.isSmallScreen,
    required PageController pageController,
    required int currentPage,
    required this.newsList,
    this.onPageTap,
  })  : _pageController = pageController,
        _currentPage = currentPage;

  final bool isSmallScreen;
  final PageController _pageController;
  final int _currentPage;
  final List<NewsItemEntity> newsList;
  final Function(int)? onPageTap;

  @override
  State<NewsListWidget> createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: child,
        );
      },
      child: SizedBox(
        height: widget.isSmallScreen ? 160 : 200,
        child: PageView.builder(
          controller: widget._pageController,
          itemCount: widget.newsList.length,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            HapticFeedback.lightImpact();
            _triggerBounce();
          },
          itemBuilder: (context, index) {
            final item = widget.newsList[index];
            final isCurrentPage = index == widget._currentPage;
            return GestureDetector(
              onTap: () {
                if (widget.onPageTap != null) {
                  HapticFeedback.selectionClick();
                  widget.onPageTap!(index);
                }
              },
              child: TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 300 + (index * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: NewsListItem(
                  item: item,
                  index: index,
                  pageController: widget._pageController,
                  isCurrentPage: isCurrentPage,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  void _triggerBounce() {
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
  }
}
