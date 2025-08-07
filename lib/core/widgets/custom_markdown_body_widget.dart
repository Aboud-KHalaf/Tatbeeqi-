import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tatbeeqi/core/utils/app_functions.dart';
import 'package:tatbeeqi/core/helpers/snack_bar_helper.dart';
import 'package:tatbeeqi/core/widgets/code_block_builder_widget.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomMarkDownBodyWidget extends StatelessWidget {
  final String data;
  const CustomMarkDownBodyWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Directionality(
      textDirection: getTextDirection(data),
      child: MarkdownBody(
        data: data,
        softLineBreak: true,
        styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
          p: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            height: 1.6,
            color: colorScheme.onSurfaceVariant,
          ),
          code: const TextStyle(backgroundColor: Colors.transparent),
          blockSpacing: 8,
        ),
        selectable: true,
        onTapLink: (text, href, title) {
          if (href != null) {
            _launchUrl(href, context);
          }
        },
        builders: {
          'code': HighlightedCodeBlockBuilder(context: context),
        },
      ),
    );
  }

  Future<void> _launchUrl(String url, BuildContext context) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          SnackBarHelper.showError(
            context: context,
            message: AppLocalizations.of(context)!.errorCouldNotLaunch(''),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showError(
          context: context,
          message: AppLocalizations.of(context)!.errorCouldNotLaunch(''),
        );
      }
    }
  }
}
