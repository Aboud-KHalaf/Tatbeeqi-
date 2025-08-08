import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class PDFViewerWidget extends StatefulWidget {
  final String pdfUrl;
  final String? title;

  const PDFViewerWidget({
    Key? key,
    required this.pdfUrl,
    this.title,
  }) : super(key: key);

  @override
  State<PDFViewerWidget> createState() => _PDFViewerWidgetState();
}

class _PDFViewerWidgetState extends State<PDFViewerWidget>
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
    )..repeat();
    _loadingAnimation = CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    );

    _controlsAnimationController.forward();
    _fabAnimationController.forward();
  }

  void _loadPdf() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
  }

  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    setState(() {
      _totalPages = details.document.pages.count;
      _isLoading = false;
      _hasError = false;
    });
    _startControlsTimer();
  }

  void _onDocumentLoadFailed(PdfDocumentLoadFailedDetails details) {
    setState(() {
      _isLoading = false;
      _hasError = true;
      _errorMessage = _parseErrorMessage(details.error);
    });
  }

  String _parseErrorMessage(String error) {
    if (error.toLowerCase().contains('connection reset')) {
      return 'Network connection was interrupted. Please check your internet connection and try again.';
    } else if (error.toLowerCase().contains('timeout')) {
      return 'Connection timed out. Please check your internet connection and try again.';
    } else if (error.toLowerCase().contains('404') || error.toLowerCase().contains('not found')) {
      return 'PDF file not found. The document may have been moved or deleted.';
    } else if (error.toLowerCase().contains('403') || error.toLowerCase().contains('forbidden')) {
      return 'Access denied. You don\'t have permission to view this document.';
    } else if (error.toLowerCase().contains('500') || error.toLowerCase().contains('server error')) {
      return 'Server error occurred. Please try again later.';
    } else {
      return 'Failed to load PDF document. Please try again.';
    }
  }

  void _onPageChanged(PdfPageChangedDetails details) {
    setState(() {
      _currentPage = details.newPageNumber;
    });
  }

  void _onZoomLevelChanged(PdfZoomDetails details) {
    setState(() {
      _zoomLevel = details.newZoomLevel;
    });
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _controlsAnimationController.reverse();
        _fabAnimationController.reverse();
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _showControlsWithTimer() {
    setState(() {
      _showControls = true;
    });
    _controlsAnimationController.forward();
    _fabAnimationController.forward();
    _startControlsTimer();
  }

  void _retryLoading() {
    setState(() {
      _retryCount++;
    });
    _loadPdf();
  }

  void _goToPage(int page) {
    if (_pdfController != null && page >= 1 && page <= _totalPages) {
      _pdfController!.jumpToPage(page);
    }
  }

  void _showPageNavigationDialog() {
    showDialog(
      context: context,
      builder: (context) => _PageNavigationDialog(
        currentPage: _currentPage,
        totalPages: _totalPages,
        onPageSelected: _goToPage,
      ),
    );
  }

  void _showZoomDialog() {
    showDialog(
      context: context,
      builder: (context) => _ZoomControlDialog(
        currentZoom: _zoomLevel,
        onZoomChanged: (zoom) {
          _pdfController?.zoomLevel = zoom;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        if (_showControls) {
          _controlsAnimationController.reverse();
          _fabAnimationController.reverse();
          setState(() {
            _showControls = false;
          });
        } else {
          _showControlsWithTimer();
        }
      },
      child: Stack(
        children: [
          // PDF Content
          if (!_hasError)
            _PDFContent(
              pdfUrl: widget.pdfUrl,
              pdfController: _pdfController,
              onDocumentLoaded: _onDocumentLoaded,
              onDocumentLoadFailed: _onDocumentLoadFailed,
              onPageChanged: _onPageChanged,
              onZoomLevelChanged: _onZoomLevelChanged,
            ),

          // Loading Overlay
          if (_isLoading)
            _LoadingOverlay(
              loadingAnimation: _loadingAnimation,
              retryCount: _retryCount,
              colorScheme: colorScheme,
              theme: theme,
            ),

          // Error Overlay
          if (_hasError)
            _ErrorOverlay(
              errorMessage: _errorMessage ?? 'Unknown error occurred',
              onRetry: _retryLoading,
              colorScheme: colorScheme,
              theme: theme,
            ),

          // Page Indicator
          if (!_isLoading && !_hasError && _showControls)
            AnimatedBuilder(
              animation: _controlsAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _controlsAnimation.value,
                  child: _PageIndicator(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    zoomLevel: _zoomLevel,
                    theme: theme,
                    colorScheme: colorScheme,
                  ),
                );
              },
            ),

          // Navigation Buttons
          if (!_isLoading && !_hasError && _showControls)
            AnimatedBuilder(
              animation: _fabAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fabAnimation.value,
                  child: _PDFNavigationButtons(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    onPreviousPage: () => _goToPage(_currentPage - 1),
                    onNextPage: () => _goToPage(_currentPage + 1),
                    onPageNavigation: _showPageNavigationDialog,
                    onZoomControl: _showZoomDialog,
                    colorScheme: colorScheme,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// Separated Widget Classes
class _PDFContent extends StatelessWidget {
  final String pdfUrl;
  final PdfViewerController? pdfController;
  final Function(PdfDocumentLoadedDetails) onDocumentLoaded;
  final Function(PdfDocumentLoadFailedDetails) onDocumentLoadFailed;
  final Function(PdfPageChangedDetails) onPageChanged;
  final Function(PdfZoomDetails) onZoomLevelChanged;

  const _PDFContent({
    required this.pdfUrl,
    required this.pdfController,
    required this.onDocumentLoaded,
    required this.onDocumentLoadFailed,
    required this.onPageChanged,
    required this.onZoomLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.network(
      pdfUrl,
      controller: pdfController,
      onDocumentLoaded: onDocumentLoaded,
      onDocumentLoadFailed: onDocumentLoadFailed,
      onPageChanged: onPageChanged,
      onZoomLevelChanged: onZoomLevelChanged,
      enableDoubleTapZooming: true,
      enableTextSelection: true,
      canShowScrollHead: false,
      canShowScrollStatus: false,
      canShowPaginationDialog: false,
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  final Animation<double> loadingAnimation;
  final int retryCount;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _LoadingOverlay({
    required this.loadingAnimation,
    required this.retryCount,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: loadingAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * loadingAnimation.value),
                  child: CircularProgressIndicator(
                    color: colorScheme.primary,
                    strokeWidth: 3,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Loading PDF...',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            if (retryCount > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Attempt ${retryCount + 1}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorOverlay extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _ErrorOverlay({
    required this.errorMessage,
    required this.onRetry,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    Icons.error_outline,
                    size: 64,
                    color: colorScheme.error,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load PDF',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                onRetry();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final double zoomLevel;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _PageIndicator({
    required this.currentPage,
    required this.totalPages,
    required this.zoomLevel,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$currentPage / $totalPages',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 1,
                    height: 12,
                    color: colorScheme.outlineVariant,
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.zoom_in,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(zoomLevel * 100).round()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onPageNavigation;
  final VoidCallback onZoomControl;
  final ColorScheme colorScheme;

  const _PDFNavigationButtons({
    required this.currentPage,
    required this.totalPages,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onPageNavigation,
    required this.onZoomControl,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Zoom Control
          FloatingActionButton.small(
            heroTag: "zoom",
            onPressed: () {
              HapticFeedback.lightImpact();
              onZoomControl();
            },
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 8),
          // Page Navigation
          FloatingActionButton.small(
            heroTag: "navigate",
            onPressed: () {
              HapticFeedback.lightImpact();
              onPageNavigation();
            },
            backgroundColor: colorScheme.secondaryContainer,
            foregroundColor: colorScheme.onSecondaryContainer,
            child: const Icon(Icons.menu_book),
          ),
          const SizedBox(height: 8),
          // Previous Page
          FloatingActionButton.small(
            heroTag: "previous",
            onPressed: currentPage > 1 ? () {
              HapticFeedback.lightImpact();
              onPreviousPage();
            } : null,
            backgroundColor: currentPage > 1 
                ? colorScheme.tertiaryContainer 
                : colorScheme.surfaceContainerHighest,
            foregroundColor: currentPage > 1 
                ? colorScheme.onTertiaryContainer 
                : colorScheme.onSurfaceVariant,
            child: const Icon(Icons.keyboard_arrow_up),
          ),
          const SizedBox(height: 8),
          // Next Page
          FloatingActionButton.small(
            heroTag: "next",
            onPressed: currentPage < totalPages ? () {
              HapticFeedback.lightImpact();
              onNextPage();
            } : null,
            backgroundColor: currentPage < totalPages 
                ? colorScheme.tertiaryContainer 
                : colorScheme.surfaceContainerHighest,
            foregroundColor: currentPage < totalPages 
                ? colorScheme.onTertiaryContainer 
                : colorScheme.onSurfaceVariant,
            child: const Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ),
    );
  }
}

class _PageNavigationDialog extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageSelected;

  const _PageNavigationDialog({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  @override
  State<_PageNavigationDialog> createState() => _PageNavigationDialogState();
}

class _PageNavigationDialogState extends State<_PageNavigationDialog> {
  late TextEditingController _controller;
  late int _selectedPage;

  @override
  void initState() {
    super.initState();
    _selectedPage = widget.currentPage;
    _controller = TextEditingController(text: _selectedPage.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.menu_book, color: colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Go to Page'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Page number',
              hintText: '1 - ${widget.totalPages}',
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              final page = int.tryParse(value);
              if (page != null && page >= 1 && page <= widget.totalPages) {
                setState(() {
                  _selectedPage = page;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          Slider(
            value: _selectedPage.toDouble(),
            min: 1,
            max: widget.totalPages.toDouble(),
            divisions: widget.totalPages - 1,
            label: _selectedPage.toString(),
            onChanged: (value) {
              setState(() {
                _selectedPage = value.round();
                _controller.text = _selectedPage.toString();
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onPageSelected(_selectedPage);
            Navigator.of(context).pop();
          },
          child: const Text('Go'),
        ),
      ],
    );
  }
}

class _ZoomControlDialog extends StatefulWidget {
  final double currentZoom;
  final Function(double) onZoomChanged;

  const _ZoomControlDialog({
    required this.currentZoom,
    required this.onZoomChanged,
  });

  @override
  State<_ZoomControlDialog> createState() => _ZoomControlDialogState();
}

class _ZoomControlDialogState extends State<_ZoomControlDialog> {
  late double _zoomLevel;

  @override
  void initState() {
    super.initState();
    _zoomLevel = widget.currentZoom;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.zoom_in, color: colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Zoom Control'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${(_zoomLevel * 100).round()}%',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: _zoomLevel,
            min: 0.5,
            max: 3.0,
            divisions: 25,
            label: '${(_zoomLevel * 100).round()}%',
            onChanged: (value) {
              setState(() {
                _zoomLevel = value;
              });
              widget.onZoomChanged(value);
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ZoomButton(
                label: '50%',
                onPressed: () {
                  setState(() {
                    _zoomLevel = 0.5;
                  });
                  widget.onZoomChanged(0.5);
                },
              ),
              _ZoomButton(
                label: '100%',
                onPressed: () {
                  setState(() {
                    _zoomLevel = 1.0;
                  });
                  widget.onZoomChanged(1.0);
                },
              ),
              _ZoomButton(
                label: '150%',
                onPressed: () {
                  setState(() {
                    _zoomLevel = 1.5;
                  });
                  widget.onZoomChanged(1.5);
                },
              ),
              _ZoomButton(
                label: '200%',
                onPressed: () {
                  setState(() {
                    _zoomLevel = 2.0;
                  });
                  widget.onZoomChanged(2.0);
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ZoomButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
