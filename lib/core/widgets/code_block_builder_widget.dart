import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/dark.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:tatbeeqi/core/theme/code_theme.dart' as code_theme;

class HighlightedCodeBlockBuilder extends MarkdownElementBuilder {
  final BuildContext context;

  HighlightedCodeBlockBuilder({required this.context});

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final code = element.textContent;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xff2b2b2b) : const Color(0xFFF5F5F5);
    final theme = isDark ? code_theme.a11yDarkTheme : code_theme.a11yLightTheme;
    final language =
        element.attributes['class']?.replaceFirst('language-', '') ??
            'plaintext';

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: HighlightView(
            code,
            language: language,
            theme: theme,
            // textStyle: TextStyle(
            //   fontFamily: 'monospace',
            //   fontSize: 14,
            //   color: isDark ? Colors.white : Colors.black,
            //   backgroundColor: Colors.transparent,
            // ),
          ),
        ),
      ),
    );
  }
}
