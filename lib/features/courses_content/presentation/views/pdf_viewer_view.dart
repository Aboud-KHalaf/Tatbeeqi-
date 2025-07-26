import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String? title;

  const PDFViewerScreen({
    Key? key,
    required this.pdfUrl,
    this.title,
  }) : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen>
    with TickerProviderStateMixin {
  PdfViewerController? _pdfController;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _showControls = true;
  double _zoomLevel = 1.0;
  int _retryCount = 0;
  Timer? _controlsTimer;

  late AnimationController _controlsAnimationController;
  late Animation<double> _controlsAnimation;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  late AnimationController _loadingAnimationController;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadPdf();
  }

  void _initializeControllers() {
    _pdfController = PdfViewerController();

    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controlsAnimation = CurvedAnimation(
      parent: _controlsAnimationController,
      curve: Curves.easeInOut,
    );

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );

    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _loadingAnimation = CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    );

    _showControlsTemporarily();
  }

  void _loadPdf() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });
    _loadingAnimationController.repeat();
  }

  void _showControlsTemporarily() {
    _controlsTimer?.cancel();
    setState(() {
      _showControls = true;
    });
    _controlsAnimationController.forward();
    _fabAnimationController.forward();

    _controlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        _hideControls();
      }
    });
  }

  void _hideControls() {
    _controlsTimer?.cancel();
    _controlsAnimationController.reverse();
    _fabAnimationController.reverse();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _goToPage(int page) {
    if (_pdfController != null && page >= 1 && page <= _totalPages) {
      _pdfController!.jumpToPage(page);
      HapticFeedback.selectionClick();
    }
  }

  void _retryLoading() {
    _retryCount++;
    _loadPdf();
    HapticFeedback.lightImpact();
  }

  void _showPageDialog() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => _PageNavigationDialog(
        currentPage: _currentPage,
        totalPages: _totalPages,
        onPageSelected: (page) {
          _goToPage(page);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showZoomDialog() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => _ZoomControlDialog(
        currentZoom: _zoomLevel,
        onZoomChanged: (zoom) {
          setState(() {
            _zoomLevel = zoom;
          });
          _pdfController?.zoomLevel = zoom;
        },
        onReset: () {
          setState(() {
            _zoomLevel = 1.0;
          });
          _pdfController?.zoomLevel = 1.0;
        },
      ),
    );
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _controlsAnimationController.dispose();
    _fabAnimationController.dispose();
    _loadingAnimationController.dispose();
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _PDFAppBar(
        title: widget.title ?? 'PDF Viewer',
        isLoading: _isLoading,
        hasError: _hasError,
        totalPages: _totalPages,
        onZoomPressed: _showZoomDialog,
        onPagePressed: _showPageDialog,
      ),
      body: _PDFContent(
        pdfUrl: widget.pdfUrl,
        controller: _pdfController,
        isLoading: _isLoading,
        hasError: _hasError,
        errorMessage: _errorMessage,
        currentPage: _currentPage,
        totalPages: _totalPages,
        zoomLevel: _zoomLevel,
        showControls: _showControls,
        controlsAnimation: _controlsAnimation,
        loadingAnimation: _loadingAnimation,
        retryCount: _retryCount,
        onDocumentLoaded: (details) {
          setState(() {
            _totalPages = details.document.pages.count;
            _isLoading = false;
            _hasError = false;
          });
          _loadingAnimationController.stop();
        },
        onDocumentLoadFailed: (details) {
          setState(() {
            _isLoading = false;
            _hasError = true;
            _errorMessage = _getNetworkErrorMessage(details.error);
          });
          _loadingAnimationController.stop();
        },
        onPageChanged: (details) {
          setState(() {
            _currentPage = details.newPageNumber;
          });
        },
        onZoomLevelChanged: (details) {
          setState(() {
            _zoomLevel = details.newZoomLevel;
          });
        },
        onTap: () {
          if (_showControls) {
            _hideControls();
          } else {
            _showControlsTemporarily();
          }
        },
        onRetry: _retryLoading,
      ),
      floatingActionButton: _PDFNavigationButtons(
        currentPage: _currentPage,
        totalPages: _totalPages,
        isLoading: _isLoading,
        hasError: _hasError,
        fabAnimation: _fabAnimation,
        onGoToPage: _goToPage,
      ),
    );
  }

  String _getNetworkErrorMessage(String originalError) {
    if (originalError.contains('Connection reset by peer') ||
        originalError.contains('SocketException')) {
      return 'Network connection failed. Please check your internet connection and try again.';
    } else if (originalError.contains('timeout')) {
      return 'Connection timed out. The PDF file might be too large or your connection is slow.';
    } else if (originalError.contains('404') ||
        originalError.contains('Not Found')) {
      return 'PDF file not found. The file may have been moved or deleted.';
    } else if (originalError.contains('403') ||
        originalError.contains('Forbidden')) {
      return 'Access denied. You may not have permission to view this PDF.';
    }
    return 'Failed to load PDF. Please try again later.';
  }
}

// Separated Widget Classes
class _PDFAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLoading;
  final bool hasError;
  final int totalPages;
  final VoidCallback onZoomPressed;
  final VoidCallback onPagePressed;

  const _PDFAppBar({
    required this.title,
    required this.isLoading,
    required this.hasError,
    required this.totalPages,
    required this.onZoomPressed,
    required this.onPagePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      actions: [
        if (!isLoading && !hasError && totalPages > 0) ...[
          IconButton(
            onPressed: onZoomPressed,
            icon: const Icon(Icons.zoom_in),
            tooltip: 'Zoom',
          ),
          IconButton(
            onPressed: onPagePressed,
            icon: const Icon(Icons.pages_outlined),
            tooltip: 'Go to page',
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PDFContent extends StatelessWidget {
  final String pdfUrl;
  final PdfViewerController? controller;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final double zoomLevel;
  final bool showControls;
  final Animation<double> controlsAnimation;
  final Animation<double> loadingAnimation;
  final int retryCount;
  final Function(PdfDocumentLoadedDetails) onDocumentLoaded;
  final Function(PdfDocumentLoadFailedDetails) onDocumentLoadFailed;
  final Function(PdfPageChangedDetails) onPageChanged;
  final Function(PdfZoomDetails) onZoomLevelChanged;
  final VoidCallback onTap;
  final VoidCallback onRetry;

  const _PDFContent({
    required this.pdfUrl,
    required this.controller,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.currentPage,
    required this.totalPages,
    required this.zoomLevel,
    required this.showControls,
    required this.controlsAnimation,
    required this.loadingAnimation,
    required this.retryCount,
    required this.onDocumentLoaded,
    required this.onDocumentLoadFailed,
    required this.onPageChanged,
    required this.onZoomLevelChanged,
    required this.onTap,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          if (!hasError)
            SfPdfViewer.network(
              pdfUrl,
              controller: controller,
              onDocumentLoaded: onDocumentLoaded,
              onDocumentLoadFailed: onDocumentLoadFailed,
              onPageChanged: onPageChanged,
              onZoomLevelChanged: onZoomLevelChanged,
              enableDoubleTapZooming: true,
              enableTextSelection: true,
              canShowScrollHead: false,
              canShowScrollStatus: false,
              canShowPaginationDialog: false,
            ),
          // Loading overlay with enhanced animation
          if (isLoading)
            _LoadingOverlay(
              animation: loadingAnimation,
              retryCount: retryCount,
            ),
          // Error overlay with retry functionality
          if (hasError)
            _ErrorOverlay(
              errorMessage: errorMessage,
              retryCount: retryCount,
              onRetry: onRetry,
            ),
          // Page indicator with smooth animations - FIXED: Positioned is now direct child of Stack
          if (showControls && totalPages > 0 && !isLoading && !hasError)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: AnimatedBuilder(
                animation: controlsAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: controlsAnimation.value,
                    child: _PageIndicator(
                      currentPage: currentPage,
                      totalPages: totalPages,
                      zoomLevel: zoomLevel,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  final Animation<double> animation;
  final int retryCount;

  const _LoadingOverlay({
    required this.animation,
    required this.retryCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                          strokeWidth: 3,
                          value: animation.value,
                        ),
                      ),
                      Center(
                        child: Transform.scale(
                          scale: 0.8 + (0.2 * animation.value),
                          child: Icon(
                            Icons.picture_as_pdf,
                            size: 32,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              retryCount > 0 ? 'Retrying... ($retryCount)' : 'Loading PDF...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            if (retryCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Please wait while we reconnect',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ErrorOverlay extends StatelessWidget {
  final String? errorMessage;
  final int retryCount;
  final VoidCallback onRetry;

  const _ErrorOverlay({
    required this.errorMessage,
    required this.retryCount,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Icon(
                      Icons.wifi_off_rounded,
                      size: 64,
                      color: colorScheme.error,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Connection Error',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage ?? 'Failed to load PDF. Please try again.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              if (retryCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Retry attempt: $retryCount',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
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

class _PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final double zoomLevel;

  const _PageIndicator({
    required this.currentPage,
    required this.totalPages,
    required this.zoomLevel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.inverseSurface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 16,
                    color: colorScheme.onInverseSurface,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$currentPage of $totalPages',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onInverseSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 1,
                    height: 16,
                    color: colorScheme.onInverseSurface.withOpacity(0.3),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.zoom_in_rounded,
                    size: 14,
                    color: colorScheme.onInverseSurface.withOpacity(0.8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(zoomLevel * 100).round()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onInverseSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PDFNavigationButtons extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final bool hasError;
  final Animation<double> fabAnimation;
  final Function(int) onGoToPage;

  const _PDFNavigationButtons({
    required this.currentPage,
    required this.totalPages,
    required this.isLoading,
    required this.hasError,
    required this.fabAnimation,
    required this.onGoToPage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading || hasError || totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: fabAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: fabAnimation.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Previous page
              FloatingActionButton.small(
                onPressed:
                    currentPage > 1 ? () => onGoToPage(currentPage - 1) : null,
                backgroundColor: currentPage > 1
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                foregroundColor: currentPage > 1
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                heroTag: "prev",
                elevation: currentPage > 1 ? 6 : 0,
                child: const Icon(Icons.keyboard_arrow_up_rounded),
              ),
              const SizedBox(height: 8),
              // Next page
              FloatingActionButton.small(
                onPressed: currentPage < totalPages
                    ? () => onGoToPage(currentPage + 1)
                    : null,
                backgroundColor: currentPage < totalPages
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                foregroundColor: currentPage < totalPages
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                heroTag: "next",
                elevation: currentPage < totalPages ? 6 : 0,
                child: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PageNavigationDialog extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageSelected;

  const _PageNavigationDialog({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textController = TextEditingController(text: currentPage.toString());

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.pages_rounded,
            color: colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'Go to Page',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Page number (1-$totalPages)',
              labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              prefixIcon: Icon(
                Icons.tag_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
        FilledButton(
          onPressed: () {
            final pageNum = int.tryParse(textController.text);
            if (pageNum != null && pageNum >= 1 && pageNum <= totalPages) {
              onPageSelected(pageNum);
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Go'),
        ),
      ],
    );
  }
}

class _ZoomControlDialog extends StatelessWidget {
  final double currentZoom;
  final Function(double) onZoomChanged;
  final VoidCallback onReset;

  const _ZoomControlDialog({
    required this.currentZoom,
    required this.onZoomChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.zoom_in_rounded,
            color: colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'Zoom Level',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Text(
                  '${(currentZoom * 100).round()}%',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: currentZoom,
              min: 0.5,
              max: 3.0,
              divisions: 25,
              activeColor: colorScheme.primary,
              inactiveColor: colorScheme.outline,
              onChanged: onZoomChanged,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '50%',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              Text(
                '300%',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onReset,
          child: Text(
            'Reset',
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
