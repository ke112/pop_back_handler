/// A Flutter widget that provides unified handling for back navigation events.
///
/// This library exports [PopBackHandler], a widget that integrates Flutter's
/// [PopScope] with iOS swipe-back gesture detection, providing a single
/// callback for all back navigation attempts.
///
/// ## Features
/// - Intercepts Android back button press
/// - Detects iOS edge swipe gestures (when interception is enabled)
/// - Supports both LTR and RTL layout directions
/// - Simple API with single callback
///
/// ## Usage
///
/// ```dart
/// PopBackHandler(
///   onPopRequested: () async {
///     final shouldPop = await showConfirmDialog();
///     if (shouldPop && mounted) {
///       Navigator.pop(context);
///     }
///   },
///   child: YourPageContent(),
/// )
/// ```
library pop_back_handler;

export 'src/pop_back_handler.dart';
