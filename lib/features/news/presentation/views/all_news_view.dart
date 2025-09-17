import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tatbeeqi/core/utils/app_logger.dart';
import 'package:tatbeeqi/features/news/presentation/manager/news_cubit.dart';
import 'package:tatbeeqi/features/news/presentation/widgets/all_news_list_view_widget.dart';
import 'package:tatbeeqi/features/news/presentation/widgets/all_news_shimmer_loader_list_widget.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class AllNewsView extends StatelessWidget {
  const AllNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
            title: Text(
          l10n.homeLatestNewsAndEvents,
        )),
        body: RefreshIndicator(
          onRefresh: () => context.read<NewsCubit>().fetchNews(),
          child: BlocBuilder<NewsCubit, NewsState>(
            builder: (context, state) {
              if (state is NewsLoadedState) {
                if (state.newsItems.isEmpty) {
                  return Center(child: Text(l10n.newsNoNewsAvailable));
                }
                return AllNewsListViewWidget(
                    news: state.newsItems,
                    isSmallScreen: isSmallScreen,
                    colorScheme: colorScheme);
              } else if (state is NewsErrorState) {
                AppLogger.error(state.message);
                return ListView(children: [
                  SizedBox(height: size.height / 3),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]);
              } else {
                return AllNewsShimmerLoaderList(isSmallScreen: isSmallScreen);
              }
            },
          ),
        ));
  }
}
