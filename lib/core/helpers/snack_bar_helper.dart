import 'package:flutter/material.dart';

/// Enum defining different types of snackbar states
enum SnackBarType {
  success,
  error,
  warning,
  info,
  custom,
}

/// Configuration class for SnackBar appearance and behavior
class SnackBarConfig {
  final Duration duration;
  final Duration animationDuration;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final bool showCloseIcon;
  final bool floating;
  final double elevation;
  final TextStyle? textStyle;
  final IconData? customIcon;
  final Color? customBackgroundColor;
  final Color? customTextColor;

  const SnackBarConfig({
    this.duration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 300),
    this.margin = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.showCloseIcon = false,
    this.floating = true,
    this.elevation = 6,
    this.textStyle,
    this.customIcon,
    this.customBackgroundColor,
    this.customTextColor,
  });
}

/// Custom animated SnackBar utility class
class SnackBarHelper {
  static const Map<SnackBarType, IconData> _defaultIcons = {
    SnackBarType.success: Icons.check_circle_outline,
    SnackBarType.error: Icons.error_outline,
    SnackBarType.warning: Icons.warning_amber_outlined,
    SnackBarType.info: Icons.info_outline,
  };

  static const Map<SnackBarType, Color> _defaultColors = {
    SnackBarType.success: Color(0xFF2E7D32),
    SnackBarType.error: Color(0xFFD32F2F),
    SnackBarType.warning: Color(0xFFF57C00),
    SnackBarType.info: Color(0xFF1976D2),
  };

  /// Shows an animated SnackBar with the specified configuration
  static void show({
    required BuildContext context,
    required String message,
    required SnackBarType type,
    SnackBarConfig config = const SnackBarConfig(),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    // Remove any existing SnackBar
    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar = _buildAnimatedSnackBar(
      message: message,
      type: type,
      config: config,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Convenience method for success messages
  static void showSuccess({
    required BuildContext context,
    required String message,
    SnackBarConfig config = const SnackBarConfig(),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.success,
      config: config,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Convenience method for error messages
  static void showError({
    required BuildContext context,
    required String message,
    SnackBarConfig config = const SnackBarConfig(
      duration: Duration(seconds: 5),
      showCloseIcon: true,
    ),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.error,
      config: config,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Convenience method for warning messages
  static void showWarning({
    required BuildContext context,
    required String message,
    SnackBarConfig config = const SnackBarConfig(
      duration: Duration(seconds: 4),
    ),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.warning,
      config: config,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Convenience method for info messages
  static void showInfo({
    required BuildContext context,
    required String message,
    SnackBarConfig config = const SnackBarConfig(),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.info,
      config: config,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Convenience method for custom styled messages
  static void showCustom({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
    SnackBarConfig config = const SnackBarConfig(),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.custom,
      config: SnackBarConfig(
        duration: config.duration,
        animationDuration: config.animationDuration,
        margin: config.margin,
        borderRadius: config.borderRadius,
        showCloseIcon: config.showCloseIcon,
        floating: config.floating,
        elevation: config.elevation,
        textStyle: config.textStyle,
        customIcon: icon,
        customBackgroundColor: backgroundColor,
        customTextColor: textColor,
      ),
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Builds the animated SnackBar widget
  static SnackBar _buildAnimatedSnackBar({
    required String message,
    required SnackBarType type,
    required SnackBarConfig config,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final backgroundColor = type == SnackBarType.custom
        ? config.customBackgroundColor ?? _defaultColors[SnackBarType.info]!
        : _defaultColors[type]!;

    final textColor = type == SnackBarType.custom
        ? config.customTextColor ?? Colors.white
        : Colors.white;

    final icon =
        type == SnackBarType.custom ? config.customIcon : _defaultIcons[type];

    return SnackBar(
      content: _AnimatedSnackBarContent(
        message: message,
        icon: icon,
        textColor: textColor,
        textStyle: config.textStyle,
        animationDuration: config.animationDuration,
      ),
      backgroundColor: backgroundColor,
      duration: config.duration,
      margin: config.floating ? config.margin : null,
      shape: config.floating
          ? RoundedRectangleBorder(borderRadius: config.borderRadius)
          : null,
      behavior:
          config.floating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      elevation: config.elevation,
      showCloseIcon: config.showCloseIcon,
      closeIconColor: textColor,
      action: actionLabel != null && onActionPressed != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textColor,
              onPressed: onActionPressed,
            )
          : null,
    );
  }

  /// Hides the currently displayed SnackBar
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}

/// Animated content widget for the SnackBar
class _AnimatedSnackBarContent extends StatefulWidget {
  final String message;
  final IconData? icon;
  final Color textColor;
  final TextStyle? textStyle;
  final Duration animationDuration;

  const _AnimatedSnackBarContent({
    required this.message,
    this.icon,
    required this.textColor,
    this.textStyle,
    required this.animationDuration,
  });

  @override
  State<_AnimatedSnackBarContent> createState() =>
      _AnimatedSnackBarContentState();
}

class _AnimatedSnackBarContentState extends State<_AnimatedSnackBarContent>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(
          milliseconds:
              (widget.animationDuration.inMilliseconds * 0.8).round()),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.bounceOut,
    ));

    // Start animations
    _slideController.forward();
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Row(
            children: [
              if (widget.icon != null) ...[
                TweenAnimationBuilder<double>(
                  duration: Duration(
                      milliseconds:
                          widget.animationDuration.inMilliseconds + 200),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * 0.5,
                      child: Icon(
                        widget.icon,
                        color: widget.textColor,
                        size: 20 + (value * 4),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  widget.message,
                  style: widget.textStyle?.copyWith(color: widget.textColor) ??
                      TextStyle(
                        color: widget.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension on BuildContext for easier access to SnackBar methods
extension SnackBarExtension on BuildContext {
  void showSuccessSnackBar(String message, {SnackBarConfig? config}) {
    SnackBarHelper.showSuccess(
      context: this,
      message: message,
      config: config ?? const SnackBarConfig(),
    );
  }

  void showErrorSnackBar(String message, {SnackBarConfig? config}) {
    SnackBarHelper.showError(
      context: this,
      message: message,
      config: config ??
          const SnackBarConfig(
            duration: Duration(seconds: 5),
            showCloseIcon: true,
          ),
    );
  }

  void showWarningSnackBar(String message, {SnackBarConfig? config}) {
    SnackBarHelper.showWarning(
      context: this,
      message: message,
      config: config ?? const SnackBarConfig(duration: Duration(seconds: 4)),
    );
  }

  void showInfoSnackBar(String message, {SnackBarConfig? config}) {
    SnackBarHelper.showInfo(
      context: this,
      message: message,
      config: config ?? const SnackBarConfig(),
    );
  }
}
