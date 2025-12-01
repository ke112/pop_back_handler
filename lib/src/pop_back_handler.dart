import 'dart:io';

import 'package:flutter/material.dart';

/// A unified back event handler widget.
/// Integrates PopScope + iOS swipe-back detection, exposing only one callback.
///
/// 统一的返回事件处理器
/// 集成 PopScope + iOS 侧滑检测，对外只暴露一个回调
class PopBackHandler extends StatefulWidget {
  const PopBackHandler({
    super.key,
    required this.child,
    required this.onPopRequested,
    this.enableInterceptBack = true,
    this.edgeWidth = 20.0,
    this.swipeThreshold = 100.0,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Unified callback for back events.
  /// Triggered when the user attempts to go back (Android back button, iOS swipe gesture).
  ///
  /// 统一的返回事件回调
  /// 当用户尝试返回时触发（Android 返回键、iOS 侧滑）
  final VoidCallback onPopRequested;

  /// Whether to enable back interception.
  /// - `true`: Intercepts back events and handles them via [onPopRequested] callback.
  /// - `false`: Does not intercept, allows system default back behavior.
  ///
  /// 是否开启拦截返回功能
  /// - `true`: 拦截返回事件，通过 onPopRequested 回调处理
  /// - `false`: 不拦截，允许系统默认返回行为
  final bool enableInterceptBack;

  /// The width of the edge trigger zone on iOS (in logical pixels).
  ///
  /// iOS 边缘触发区域宽度
  final double edgeWidth;

  /// The swipe distance threshold to trigger back on iOS (in logical pixels).
  ///
  /// iOS 触发返回的滑动距离阈值
  final double swipeThreshold;

  @override
  State<PopBackHandler> createState() => _PopBackHandlerState();
}

class _PopBackHandlerState extends State<PopBackHandler> {
  double _startX = 0;
  bool _isEdgeSwipe = false;

  bool _isIOS = false;

  @override
  void initState() {
    super.initState();
    _isIOS = Platform.isIOS;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.enableInterceptBack,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          widget.onPopRequested();
        }
      },
      child: _buildIOSSwipeDetector(context),
    );
  }

  Widget _buildIOSSwipeDetector(BuildContext context) {
    // On non-iOS platforms or when interception is disabled, return child directly.
    // When interception is disabled, iOS system swipe-back gesture works normally.
    if (!_isIOS || !widget.enableInterceptBack) {
      return widget.child;
    }

    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (details) {
        final screenWidth = MediaQuery.of(context).size.width;
        final startPosition = details.globalPosition.dx;

        // Determine edge position based on layout direction
        // LTR: swipe from left edge
        // RTL: swipe from right edge
        if (isRTL) {
          _isEdgeSwipe = startPosition > screenWidth - widget.edgeWidth;
        } else {
          _isEdgeSwipe = startPosition < widget.edgeWidth;
        }
        _startX = startPosition;
      },
      onHorizontalDragUpdate: (details) {
        // Visual feedback during swipe can be added here
      },
      onHorizontalDragEnd: (details) {
        if (!_isEdgeSwipe) return;

        final currentX = details.localPosition.dx;
        final deltaX = isRTL ? (_startX - currentX) : (currentX - _startX);

        // Trigger back if swipe distance exceeds threshold
        if (deltaX > widget.swipeThreshold) {
          widget.onPopRequested();
        }

        _isEdgeSwipe = false;
        _startX = 0;
      },
      onHorizontalDragCancel: () {
        _isEdgeSwipe = false;
        _startX = 0;
      },
      child: widget.child,
    );
  }
}
